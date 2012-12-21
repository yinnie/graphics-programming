#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "Resources.h"
#include "cinder/MayaCamUI.h"

#include <vector>
#include <utility>

using namespace ci;
using namespace ci::app;
using namespace std;

class terrain1App : public AppBasic {
  public:
	void setup();
	void mouseDown( MouseEvent event );
    void mouseMoved( MouseEvent event);
	void update();
	void draw();
    void drawGrid();
    
    int preMouseX;
    Vec3f eyePos;
    CameraPersp cam;
    
};

void terrain1App::setup()
{
    eyePos = Vec3f ( 0.0f, 50.0f, 200.0f);
    cam.setEyePoint( eyePos );
	cam.setCenterOfInterestPoint( Vec3f(0.0f, 10.0f, 0.0f) );
	cam.setPerspective( 60.0f, getWindowAspectRatio(), 1.0f, 1000.0f );
    
    preMouseX = 0;

}

void terrain1App::mouseDown( MouseEvent event )
{
    //eyePos.z -= 2;
    Vec3f curViewDir = cam.getViewDirection();
   // cam.getEyePoint();
   // cam.getCenterOfInterestPoint()
    Vec3f changeDir (-1, 0, 0);
    changeDir.normalize();
    curViewDir -= changeDir;
    curViewDir.normalize();
    cam.setViewDirection(curViewDir);
}

void terrain1App::mouseMoved(MouseEvent event)
{
    //int mouseX = event.getX();
    
    
}

void terrain1App::update()
{
    cam.setEyePoint(eyePos);
}

void terrain1App::draw()
{
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) );
    //Vec3f center = Vec3f(getWindowWidth()/2,getWindowHeight()/2, 200);
    
    gl:: setMatrices(cam);
    glColor3f(1, 0.6, 1);
    drawGrid();
 
}

void terrain1App::drawGrid()
{
    glColor3f(1, 1, 1);
    float step = 10.0;
    float size = 200;
    for ( int i = -size; i < size; i+=step)
    {
        gl::drawLine(Vec3f(i, 0, -size), Vec3f(i,0,size));
        gl::drawLine(Vec3f(-size, 0, i), Vec3f(size, 0, i));
    }
}

CINDER_APP_BASIC( terrain1App, RendererGl )
