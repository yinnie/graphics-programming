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

using namespace ci;
using namespace ci::app;
using namespace std;

#define STRINGIFY(s) #s

static const string GLSL_VERT_PASSTHROUGH = STRINGIFY(
                                                      
                                                      uniform float size;
                                                      
                                                      //generate a random value
                                                      float rand(vec2 A){
                                                          
                                                          vec2 s=vec2(12.9898,78.233);
                                                          float tmp=dot(A,s);
                                                          
                                                          return fract(sin(tmp) * 43758.5453)* 3.0;
                                                      }
                                                      
                                                      vec3 mesh (vec2 A) {
                                                          float z = rand (A);
                                                          vec3 pos = vec3 ( A.x * size, A.y * size, z);
                                                          return pos;
                                                      }
                                                      
                                                      void main()
{
	gl_FrontColor = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
    
    vec2 curUV = gl_TexCoord[0].xy;
    vec3 pos = mesh ( curUV);
    
    //offset values 
    //neighbour vertices
    vec2 offset[8];
    offset[0] = vec2(  -size,  -size);
    offset[1] = vec2(  0.0,  -size);
    offset[2] = vec2(  size,  -size);
    offset[3] = vec2(  -size,  0.0);
    offset[4] = vec2(  size,  0.0);
    offset[5] = vec2(  -size,  size);
    offset[6] = vec2(  0.0,  size);
    offset[7] = vec2(  size,  size);
    
    
    // Determine the number of active neighbors:
    int sum = 0;
    for(int i = 0; i < 8; i++) {
        if( mesh(curUV + offset[i]).z > 0.5 ) { sum++; }
    }
    
    float curZ = mesh ( curUV).z;                                                     
    // Determine z value based on the GOL rules:
    float outVal = 0.0;
    if     ( ( curZ >= 0.5 ) && (sum == 2 || sum == 3) ) { outVal = 1.0; }
    else if( ( curZ <  0.5 ) && (sum == 3) )             { outVal = 1.0; }
    
	gl_Position = vec4 ( outVal, outVal, outVal, 1.0);
}
                                                      
                                                      

);

static const string GLSL_FRAG_IMGPROC = STRINGIFY(
                                                  
                            
                                                  
    void main()
    {
    gl_FragColor = vec4 ( vec3(1.0, 0.0, 0.0), 1.0);
    
   }
);


class simpleMeshApp : public AppBasic {
  public:
	void setup();
	void mouseDown( MouseEvent event );
    void mouseDrag( MouseEvent event );
    void mouseMove( MouseEvent event );
    void resize(ResizeEvent event);
	void update();
	void draw();
    void drawGrid();
    
    int mode;
    int cubeRadius;
    int side;
    float increment;
    TCube cube;
    gl::VboMesh vbomesh;
    MayaCamUI mayacam;
    Vec2f mousePos;
    Perlin mPerlin;
    
    gl::GlslProg mShader;
};

void simpleMeshApp::setup()
{
    cubeRadius = 1;
    cube.setup(Vec3f(-50, 0,0), cubeRadius);
    side = 45;
    increment = 0.02;
    
    CameraPersp cam;
    cam.setPerspective(60.0, getWindowAspectRatio(), 1.0, 1000.0);
    cam.setEyePoint(Vec3f(0, 10, 100));
    cam.setCenterOfInterestPoint(Vec3f(0.0f, 10.0f, 0.0f));
    mayacam.setCurrentCam(cam);
    
    vbomesh = gl::VboMesh ( cube.mesh );
    
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
   drawGrid();
     
   
    mShader.bind();
    mShader.uniform("size", (float)3.0);
    
    
    float xoff = 0.0;
    for (int i = 0; i < side; i++) {
        xoff += increment;
        float yoff = 0.0;
        
        for ( int j = 0; j < side; j++) {
            yoff += increment;
    
            //noise 3d
            float zoff = 0.0;
            for (int p = 0; p < side; p++) {
                zoff += increment;
                float density = mPerlin.fBm(xoff, zoff, yoff);
                
                if(density > 0.13) {
                    gl::pushMatrices();
                    gl::translate(Vec3f(i*cubeRadius*2, p*cubeRadius*2, j*cubeRadius*2));
                    
                    
                    gl::draw(vbomesh);
                    gl::popMatrices();
                }
            }
        }
    }
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
