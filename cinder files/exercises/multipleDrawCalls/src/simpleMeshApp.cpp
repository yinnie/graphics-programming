#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/TriMesh.h"
#include "TCube.h"
#include "cinder/Camera.h"
#include "cinder/gl/Vbo.h"
#include "cinder/Perlin.h"
#include "cinder/MayaCamUI.h"
#include "cinder/CinderMath.h"


using namespace ci;
using namespace ci::app;
using namespace std;

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
    int size;
    float increment;
    TCube cube;
    gl::VboMesh vbomesh;
    MayaCamUI mayacam;
    Vec2f mousePos;
    Perlin mPerlin;
    
};

void simpleMeshApp::setup()
{
    cubeRadius = 1;
    cube.setup(Vec3f(-50, 0,0), cubeRadius);
    size = 45;
    increment = 0.02;
    
    CameraPersp cam;
    cam.setPerspective(60.0, getWindowAspectRatio(), 1.0, 1000.0);
    cam.setEyePoint(Vec3f(0, 10, 100));
    cam.setCenterOfInterestPoint(Vec3f(0.0f, 10.0f, 0.0f));
    mayacam.setCurrentCam(cam);
    
    vbomesh = gl::VboMesh ( cube.mesh );    
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
    
    drawGrid();
    
    gl::enableDepthRead();
    gl::enableDepthWrite();
    gl::color(1.0, 1.0, 1.0);
 
    float xoff = 0.0;
    for (int i = 0; i < size; i++) {
        xoff += increment;
        float yoff = 0.0;
        
        for ( int j = 0; j < size; j++) {
            yoff += increment;
            
            /*
            //noise 2d
            float h = mPerlin.fBm(xoff, yoff);
            float height = lmap<float>(h, 0, 1, 1, size);
        
            for ( int p = 1; p < height; p++) {
                gl::pushMatrices();
                gl::translate(Vec3f(i*cubeRadius*2, p*cubeRadius*2, j*cubeRadius*2));
                gl::draw(vbomesh);
                gl::popMatrices();
            }
            */
            
            //noise 3d
            float zoff = 0.0;
            for (int p = 0; p < size; p++) {
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
