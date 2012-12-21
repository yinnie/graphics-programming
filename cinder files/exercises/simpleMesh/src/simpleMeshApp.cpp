#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/TriMesh.h"
#include "TCube.h"
#include "cinder/Camera.h"
#include "cinder/gl/Vbo.h"

using namespace ci;
using namespace ci::app;
using namespace std;

class simpleMeshApp : public AppBasic {
  public:
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
	void draw();
    
    //making a mesh and then send the mesh to vbomesh
    TCube cube;
    gl::VboMesh vbomesh;
    CameraPersp cam;
    int totalVert;
};

void simpleMeshApp::setup()
{
    Vec3f center(0, 0, 0);
    
    cube.setup(center, 1.0);
    
    totalVert = cube.mesh.getNumVertices();
    
    cam.setEyePoint(Vec3f (center.x, center.y+3, 10));
    cam.setCenterOfInterestPoint( center );
    cam.setPerspective(60.0f, getWindowAspectRatio(), 1, 1000);
    
    gl::VboMesh::Layout layout;
    layout.setStaticIndices();
    layout.setStaticColorsRGB();
    layout.setStaticPositions();
        
    vbomesh = gl::VboMesh (cube.mesh);
   
}

void simpleMeshApp::mouseDown( MouseEvent event )
{
}

void simpleMeshApp::update()
{
    //not working with dynamic colors ?? 
    /*
    float g = sin(getElapsedSeconds())+1.0;
    
    gl::VboMesh::VertexIter iter = vbomesh.mapVertexBuffer();
    
    for (int i = 0; i < totalVert; ++i) {
        iter.setColorRGB(Color(g, 0, 0));
        ++iter;
    }
    */
}

void simpleMeshApp::draw()
{
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) );
    
    //update matrix according to camera
    gl::setMatrices(cam);
    
    gl::enableDepthRead();
    gl::enableDepthWrite();
    
    gl::draw(vbomesh);
}

CINDER_APP_BASIC( simpleMeshApp, RendererGl )
