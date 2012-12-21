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

using namespace ci;
using namespace ci::app;
using namespace std;

#define STRINGIFY(s) #s
#define COL 50
#define ROW 50

static const string GLSL_VERT_PASSTHROUGH = STRINGIFY(
                                                      
varying float V;

void main()
{
   gl_TexCoord[0] = gl_MultiTexCoord0;
                                                          
   V = gl_TexCoord[0].t; //try .s for vertical stripes
   gl_Position = ftransform();
                                                      }
);

static const string GLSL_FRAG_IMGPROC = STRINGIFY(
                                                  
const float frequency = 5.0;
uniform vec3 Color0;
uniform vec3 Color1;
                                                  
varying float V;
                                                  
                                                  
    void main()
    {
    
    float sawtooth = fract (V * frequency);
    float triangle = abs(2.0 * sawtooth - 1.0);
    float dp = length ( vec2(dFdx(V), dFdy(V)));
    float edge = dp * frequency * 2.0;
    float square = smoothstep(0.8 - edge, 0.3 + edge, triangle);
    vec3 color = mix(Color0, Color1, square);
    
    gl_FragColor = vec4( color, 1.0 );
    
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
    Perlin mPerlin;
    Gol game;

    
    gl::GlslProg mShader;
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
    cam.setEyePoint(Vec3f(0, 100, 120));
    cam.setCenterOfInterestPoint(Vec3f(0.0f, 10.0f, 0.0f));
    mayacam.setCurrentCam(cam);
    
    vbomesh = gl::VboMesh ( cube.mesh );
    
    game.setup();
   
    //initialize shader
    try {
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
   
    mShader.bind();
    mShader.uniform("Color0", Vec3f(0, 0, 0));
    mShader.uniform("Color1", Vec3f(1, 1, 1));
    
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
