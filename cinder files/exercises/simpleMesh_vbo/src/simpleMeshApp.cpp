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
    
    int mode;
    //making a mesh and then send the mesh to vbomesh
    TCube cube1;
    TCube cube2;
    gl::VboMesh vbomesh;
    CameraPersp cam;
    int totalVert;
    
    //two vbos
    gl::VboMesh vbomesh1;
    gl::VboMesh vbomesh2;
};

void simpleMeshApp::setup()
{
    Vec3f center1(0, 0, 0);
    Vec3f center2(10, 0, 0);
    
    cube1.setup(center1, 3.0);
    cube2.setup(center2, 3.0);
    
    totalVert = cube1.mesh.getNumVertices();
    
    cam.setPerspective(60.0f, getWindowAspectRatio(), 1, 1000);
    
    
    gl::VboMesh::Layout layout;
    layout.setStaticIndices();
    layout.setStaticColorsRGB();
    layout.setStaticPositions();
    
    mode = 2;
    
    if( mode == 1) {
    //combine to make one vbo mesh
    
    int numIndices = cube1.mesh.getNumIndices();
    int numVertices = cube1.mesh.getNumVertices();
        
    //get indices and vertices from cube1
    vector<uint32_t> cube1Indices = cube1.mesh.getIndices();
    vector<Vec3f> cube1Vert = cube1.mesh.getVertices();
    
    //get stuff from cube2
    vector<uint32_t> cube2Indices = cube2.mesh.getIndices();
    vector<Vec3f> cube2Vert = cube2.mesh.getVertices();
    
    //increment all the indices by total number of indices
        /*
         //i did the iterator math wrong!
    vector<uint32_t> ::iterator it;
    for ( it = cube2Indices.begin(); it < cube2Indices.end(); ++it)
    {
        it+= numIndices ;
    } 
         */
    /*
        for (int i = 0; i < cube2Indices.size(); i++) {
            cube2Indices[i] += numVertices;
        }
     
    cube1Indices.insert(cube1Indices.end(), cube2Indices.begin(), cube2Indices.end());
    
     */
        for (int i = 0; i < cube1Indices.size(); i++) {
            cout << cube1Indices[i] << endl;
        }

    
   //cube1Vert.insert(cube1Vert.end(), cube2Vert.begin(), cube2Vert.end());
        
        for (int i = 0; i < cube1Vert.size(); i++) {
            cout << cube1Vert[i] << endl;
        }
    
    //building vbomesh from new vectors
    vbomesh = gl::VboMesh (numVertices, numIndices, layout, GL_TRIANGLES);

    vbomesh.bufferIndices(cube1Indices);
    vbomesh.bufferPositions(cube1Vert);
    
    }

    if (mode == 2) {
        //two vbo meshes
        vbomesh1 = gl::VboMesh ( cube1.mesh);
        vbomesh2 = gl::VboMesh ( cube2.mesh);
    }
    
}

void simpleMeshApp::mouseDown( MouseEvent event )
{
}

void simpleMeshApp::update()
{
}

void simpleMeshApp::draw()
{
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) );
    
    //update matrix according to camera
    gl::setMatrices(cam);
    
    
    gl::enableDepthRead();
    gl::enableDepthWrite();
    if (mode == 1) {
        gl::draw(vbomesh);
    }
    if (mode == 2) {
        gl::draw(vbomesh1);
        gl::draw(vbomesh2);
    }
    
}

CINDER_APP_BASIC( simpleMeshApp, RendererGl )
