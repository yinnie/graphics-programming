#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/ImageIo.h"
#include "particleController.h"

using namespace ci;
using namespace ci::app;
using namespace std;


class firstApp : public AppBasic {
  public:
    void prepareSettings(Settings *settings);
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
	void draw();
    
    gl:: Texture img;
    ParticleController controller;
};


void firstApp:: prepareSettings(Settings *settings) {
    
    settings-> setWindowSize(800, 600);
    settings-> setFrameRate(60);
    settings-> setTitle("first");
}

void firstApp::setup()
{
    img = gl::Texture(loadImage(loadResource("tree.png")));
    controller.addParticle(100);
    
}

void firstApp::mouseDown( MouseEvent event )
{
    controller.removeParticle(2);
}

void firstApp::update()
{
    controller.update();
}

void firstApp::draw()
{
    //cycle background color
    //float c = sin(getElapsedSeconds())*0.5+0.1;
	//gl::clear( Color( c, c, c ), false );

    gl::clear(Color(0, 0, 0));
    
    img.enableAndBind();
    
    gl::draw(img, getWindowBounds());
    float x = cos(getElapsedSeconds())*50;
    float y = sin(getElapsedSeconds())*50;
    float r = abs(x);
    gl::drawSolidCircle(Vec2f(x, y) + getWindowSize()/2, r);
 
    glColor3f(1, 0.5, 1);
    controller.draw();
    
}

CINDER_APP_BASIC( firstApp, RendererGl )
