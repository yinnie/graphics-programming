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

uniform float time;
varying float V;

//generate a random value from four points
vec4 rand(vec2 A,vec2 B,vec2 C,vec2 D){
                                                          
vec2 s=vec2(12.9898,78.233);
vec4 tmp=vec4(dot(A,s),dot(B,s),dot(C,s),dot(D,s));
                                                          
return fract(sin(tmp) * 43758.5453)* 2.0 - 1.0;
}
                                                      
//this is similar to a perlin noise function
float noise(vec2 coord,float d){ 
                                                          
vec2 C[4]; 
                                                          
float d1 = 1.0/d;
                                                          
C[0]=floor(coord*d)*d1; 
                                                          
C[1]=C[0]+vec2(d1,0.0); 
                                                          
C[2]=C[0]+vec2(d1,d1); 
                                                          
C[3]=C[0]+vec2(0.0,d1);
                                                          
                                                          
vec2 p=fract(coord*d); 
                                                          
vec2 q=1.0-p; 
                                                          
vec4 w=vec4(q.x*q.y,p.x*q.y,p.x*p.y,q.x*p.y); 
                                                          
return dot(vec4(rand(C[0],C[1],C[2],C[3])),w); 
} 

void main()
{
    gl_TexCoord[0] = gl_MultiTexCoord0;
    
    V = gl_TexCoord[0].t; //try .s for vertical stripes

    vec4 pos = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
    
    float noiseAmntX = noise( vec2(-time + pos.x / 10.0, 10.0), 6.0);
	float noiseAmntZ = noise( vec2(time + pos.z / 10.0, pos.z / 10.0), 6.0 );
    
    pos.y -= 12.0 * time;
    pos.x += noiseAmntX * 0.3;
	pos.z += noiseAmntZ * 0.3;
    
    gl_Position = pos;
                                                      }
);

static const string GLSL_FRAG_IMGPROC = STRINGIFY(
                                                  
const float frequency = 2.3;
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
    Vec3f eye;
    Perlin mPerlin;
    CameraPersp cam;
    
    gl::GlslProg mShader;
};

void simpleMeshApp::setup()
{
    cubeRadius = 1;
    cube.setup(Vec3f(-50, 0,0), cubeRadius);
    size = 45;
    increment = 0.08;
    
   
    eye = Vec3f ( 0, 100, 100);
    cam.setPerspective(60.0, getWindowAspectRatio(), 1.0, 1000.0);
    cam.setEyePoint(eye);
    cam.setCenterOfInterestPoint(Vec3f(0.0f, 0.0f, 100.0f));
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

void simpleMeshApp::prepareSettings(Settings *settings) {
    settings-> setWindowSize(1280, 760);
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
        
    mShader.bind();
    mShader.uniform("Color0", Vec3f(0, 0, 0));
    mShader.uniform("Color1", Vec3f(1, 1, 1));
    mShader.uniform("time",(float)getElapsedSeconds());
    
    float xoff = 0.0;
    for (int i = 0; i < size; i++) {
        xoff += increment;
        float yoff = 0.0;
        
        for ( int j = 0; j < size; j++) {
            yoff += increment;
    
            //noise 3d
            float zoff = 0.0;
            for (int p = 0; p < size; p++) {
                zoff += increment;
                float density = mPerlin.fBm(xoff, zoff, yoff);
            
                if(density > 0.27) {
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
