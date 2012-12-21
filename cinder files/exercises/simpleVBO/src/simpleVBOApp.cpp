#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Vbo.h"
#include "cinder/Camera.h"
#include <vector>

using namespace ci;
using namespace ci::app;
using namespace std;

class simpleVBOApp : public AppBasic {
  public:
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
	void draw();

    gl::VboMesh mesh;
    CameraPersp cam;    
};

void simpleVBOApp::setup()
{
        
    gl::VboMesh::Layout layout;
    layout.setStaticIndices();
    layout.setStaticColorsRGB();
    layout.setStaticPositions();
    
    
    int numVert = 24;
    int numIndices = 24;
    
    mesh = gl::VboMesh(numVert, numIndices, layout, GL_QUADS);
    
    vector<uint32_t> indices;
    for ( int i = 0; i< numIndices; i++) {
        indices.push_back(i);
    }
    
    mesh.bufferIndices(indices);
        
    vector<Vec3f> positions;

    positions.push_back(Vec3f(100, 200, 1));
    positions.push_back(Vec3f( 200, 200, 1));
    positions.push_back(Vec3f( 200, 100, 1));
    positions.push_back(Vec3f(100, 100, 1));
    
    positions.push_back(Vec3f( 200, 200, 1));
    positions.push_back(Vec3f( 200, 200, 100));
    positions.push_back(Vec3f( 200, 100, 100));
    positions.push_back(Vec3f( 200, 100, 1));
    
    positions.push_back(Vec3f( 200, 200, 100));
    positions.push_back(Vec3f(100, 200, 100));
    positions.push_back(Vec3f(100, 100, 100));
    positions.push_back(Vec3f( 200, 100, 100));
    
    positions.push_back(Vec3f(100, 200, 100));
    positions.push_back(Vec3f(100, 200, 1));
    positions.push_back(Vec3f(100, 100, 1));
    positions.push_back(Vec3f(100, 100, 100));
    
    positions.push_back(Vec3f(100, 200, 100));
    positions.push_back(Vec3f( 200, 200, 100));
    positions.push_back(Vec3f( 200, 200, 1));
    positions.push_back(Vec3f(100, 200, 1));
    
    positions.push_back(Vec3f(100, 100, 100));
    positions.push_back(Vec3f( 200, 100, 100));
    positions.push_back(Vec3f( 200, 100, 1));
    positions.push_back(Vec3f(100, 100, 1));
    
    mesh.bufferPositions(positions);
    
    //extra camera setup
    /*     
     Vec3f center(getWindowWidth()/2-50, getWindowHeight()/2, -200);
     cam.setEyePoint(Vec3f (center.x, center.y+300, 200));
     cam.setCenterOfInterestPoint( center );
     cam.setPerspective(60.0f, getWindowAspectRatio(), 1, 1000);
     */
    
}

void simpleVBOApp::mouseDown( MouseEvent event )
{
}

void simpleVBOApp::update()
{
    //update mesh colors
    //first retrieve the colors

    gl::VboMesh::VertexIter it = mesh.mapVertexBuffer();

    float g = sin(getElapsedSeconds());
    float b = cos(getElapsedSeconds());

    for ( int i = 0; i < 24; i++) {
        it.setColorRGBA(ColorA(1-(g+b/3), g, b, 0.5));  //ColorA is Color with alpha
        ++it;
    }
    
}

void simpleVBOApp::draw()
{
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) );
 
    gl::setMatrices(cam);
    
    gl:: enableDepthRead();
    
    gl::draw(mesh);
    
}

CINDER_APP_BASIC( simpleVBOApp, RendererGl )
