#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/TriMesh.h"
#include "TCube.h"
#include "cinder/Camera.h"
#include "cinder/gl/Vbo.h"
#include "cinder/Perlin.h"
#include "cinder/MayaCamUI.h"
#include "cinder/CinderMath.h"
#include "cinder/gl/GlslProg.h"
#include "Gol.h"
#include "cinder/gl/Texture.h"
#include "cinder/ImageIo.h"

using namespace ci;
using namespace ci::app;
using namespace std;

#define STRINGIFY(s) #s
#define COL 50
#define ROW 50

static const string GLSL_VERT_PASSTHROUGH = STRINGIFY(
                                                      
void main()
{
    gl_FrontColor = gl_Color;
   gl_TexCoord[0] = gl_MultiTexCoord0;
                                                        
   gl_Position = ftransform();
                                                      }
);

static const string GLSL_FRAG_IMGPROC = STRINGIFY(
                                                  
uniform float       width;
uniform float       height;
uniform sampler2D   texture;
                                                  
void main(void) {
// Get current position within rect:
                                                      
//vec2 texCoord	= gl_TexCoord[0].xy;
                                                      
//glitched game of life
vec2 texCoord	= vec2 ( gl_TexCoord[0].x, gl_TexCoord[0].y*0.5 );
//vec2 texCoord	= vec2 ( gl_TexCoord[0].x, gl_TexCoord[0].y*0.73 );
                                                      
// Determine the ratio dimension of a single pixel:
float w			= 1.0/width;
 float h			= 1.0/height;
                                                      
// Get the value of the current pixel:
// (Since GOL uses binary states black/white, we only need one color channel)
float texColor	= texture2D( texture, texCoord ).r;
                                                      
// Get neighbor positions:
vec2 offset[8];
offset[0] = vec2(  -w,  -h );
offset[1] = vec2( 0.0,  -h );
offset[2] = vec2(   w,  -h );
offset[3] = vec2(  -w, 0.0 );
offset[4] = vec2(   w, 0.0 );
offset[5] = vec2(  -w,   h );
 offset[6] = vec2( 0.0,   h );
offset[7] = vec2(   w,   h );
                                                      
// Determine the number of active neighbors:
int sum = 0;
for(int i = 0; i < 8; i++) {
if( texture2D( texture, texCoord + offset[i] ).r > 0.5 ) { sum++; }
}
                                                      
// Determine pixel value based on the GOL rules:
float outVal = 0.0;
if     ( ( texColor >= 0.5 ) && (sum == 2 || sum == 3) ) { outVal = 1.0; }
else if( ( texColor <  0.5 ) && (sum == 3) )             { outVal = 1.0; }
                                                      
// Set final pixel value:
gl_FragColor = vec4( outVal, outVal, outVal, 1.0 );
}

);


class simpleMeshApp : public AppBasic {
  public:
	void setup();
    void prepareSettings(Settings *settings);
	void mouseDown( MouseEvent event );
    void mouseDrag( MouseEvent event );
    void mouseMove( MouseEvent event );
    void resize(ResizeEvent event);
	void update();
	void draw();
    void drawGrid();
    
    int mode;
    int cubeRadius;
    int size;
    float increment;
    TCube cube;
    gl::VboMesh vbomesh;
    MayaCamUI mayacam;
    Vec2f mousePos;
    Gol game;

    
    gl::GlslProg mShader;
    gl::Texture mTexture;
};

void simpleMeshApp::prepareSettings(Settings *settings) {
    settings-> setWindowSize(1280, 760);
}

void simpleMeshApp::setup()
{
    cubeRadius = 1;
    cube.setup(Vec3f(-50, 0,0), cubeRadius);
    size = 45;
    increment = 0.02;
    
    CameraPersp cam;
    cam.setPerspective(60.0, getWindowAspectRatio(), 1.0, 1000.0);
    cam.setEyePoint(Vec3f(0, 50, 120));
    cam.setCenterOfInterestPoint(Vec3f(0.0f, 10.0f, 0.0f));
    mayacam.setCurrentCam(cam);
    
    vbomesh = gl::VboMesh ( cube.mesh );
    
    game.setup();
   
    //initialize shader
    try {
        mTexture = gl::Texture( loadImage( loadResource( "bluecat.jpeg" ) ) );
        mShader = gl::GlslProg( GLSL_VERT_PASSTHROUGH.c_str(), GLSL_FRAG_IMGPROC.c_str());
    }    
    catch( gl::GlslProgCompileExc &exc ) {
		console() << "Cannot compile shader: " << exc.what() << std::endl;
		exit(1);
	}
    catch( Exception &exc ){
		console() << "Cannot load shader: " << exc.what() << std::endl;
		exit(1);
	}
    
    // Set texture GL parameters:
    // Texture should REPEAT so that the GOL environment wraps around the texture edges.
    // Texture should use NEAREST interpolation to prevent value blending (though GL_LINEAR works too).
	mTexture.setWrap( GL_REPEAT, GL_REPEAT );
	mTexture.setMinFilter( GL_NEAREST );
	mTexture.setMagFilter( GL_NEAREST );
}

void simpleMeshApp::update()
{
}

void simpleMeshApp::draw()
{
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) );
    
    //update matrix according to camera
    gl::setMatrices(mayacam.getCamera());
    
    gl::enableDepthRead();
    //drawGrid();
    
    game.generate();
   
    mTexture.enableAndBind();
    mShader.bind();
    mShader.uniform("width", (float)(size*0.6));
    mShader.uniform("height", (float)(size*0.6));
    mShader.uniform("texture", 0);
    
    //visualizing game of life with cubes
    for ( int i = 0; i < COL; i++){
        for ( int j = 0; j < ROW; j++) {
            
            cout << game.board[i][j] << endl;
            int height = game.total[i][j];
                gl::pushMatrices();
                gl::translate(Vec3f(i*cubeRadius*2, height, j*cubeRadius*2));
                gl::draw(vbomesh);
                gl::popMatrices();
        }
    }
    
    /*
    for ( int i = 0; i < COL; i++){
        for ( int j = 0; j < ROW; j++) {
            
            cout << game.board[i][j] << endl;
            int height = game.total[i][j];
            gl::pushMatrices();
            gl::translate(Vec3f(i*cubeRadius*2, height, j*cubeRadius*2));
            gl::draw(vbomesh);
            gl::popMatrices();
        }
    }
     */
    
    mTexture.unbind();
    mShader.unbind();
}

void simpleMeshApp::drawGrid()
{
    glColor3f(1, 1, 1);
    float step = 10.0;
    float side = 200;
    for ( int i = -side; i < side; i+=step)
    {
        gl::drawLine(Vec3f(i, 0, -side), Vec3f(i,0,side));
        gl::drawLine(Vec3f(-side, 0, i), Vec3f(side, 0, i));
    }
}

void simpleMeshApp::mouseMove(MouseEvent event) {
    mousePos = event.getPos();
}

void simpleMeshApp::mouseDown( MouseEvent event )
{
    mayacam.mouseDown( event.getPos() );
      
}

void simpleMeshApp::mouseDrag(MouseEvent event){
    // keep track of the mouse
	mousePos = event.getPos();
    
	// let the camera handle the interaction
	mayacam.mouseDrag( event.getPos(), event.isLeftDown(), event.isMiddleDown(), event.isRightDown() );
    
}
void simpleMeshApp::resize( ResizeEvent event )
{
	// adjust aspect ratio
	CameraPersp cam = mayacam.getCamera();
	cam.setAspectRatio( getWindowAspectRatio() );
	mayacam.setCurrentCam( cam );
}



CINDER_APP_BASIC( simpleMeshApp, RendererGl )
