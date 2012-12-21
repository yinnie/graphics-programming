#include "TCube.h"
#include "cinder/app/AppBasic.h"

using namespace ci;
using namespace std;
using namespace ci::app;

TCube ::TCube() {
    
}

void TCube ::setup(Vec3f c, float r) {
    
    //prepare the vertices
    Vec3f v0 (-r + c.x, -r +c.y, -r+c.z);
    Vec3f v1 (r + c.x, -r +c.y, -r+c.z);
    Vec3f v2 (r + c.x, r +c.y, -r+c.z);
    Vec3f v3 (-r + c.x, r +c.y, -r+c.z);
    Vec3f v4 (-r + c.x, -r +c.y, r+c.z);
    Vec3f v5 (r + c.x, -r +c.y, r+c.z);
    Vec3f v6 (r + c.x, r +c.y, r+c.z);
    Vec3f v7 (-r + c.x, r +c.y, r+c.z);

    /*
    //prepare the colors
    Color c0( 0, 0, 0 );
    Color c1( 1, 0, 0 );
    Color c2( 1, 1, 0 );
    Color c3( 0, 1, 0 );
    Color c4( 0, 0, 1 );
    Color c5( 1, 0, 1 );
    Color c6( 1, 1, 1 );
    Color c7( 0, 1, 1 ); 
    */
    
    //prepare the colors
    Color c0( 0, 0, 0 );
    Color c1( 0.5, 0.5, 0.5 );
    Color c2( 1, 1, 1 );
    Color c3( 0.5, 0.5, 0.5 );
    Color c4( 1, 1, 1 );
    Color c5( 0, 0, 0 );
    Color c6( 1, 1, 1 );
    Color c7( 0, 0, 0 );
    
    //the order of vertices for the 6 faces
    Vec3f faces[6][4] = { /* Vertices for the 6 faces of a cube. */
        {v0, v1, v2, v3}, {v3, v2, v6, v7}, {v7, v6, v5, v4},
        {v4, v5, v1, v0}, {v5, v6, v2, v1}, {v7, v4, v0, v3} };
    Color colors[6][4] = { /* colors for each vertex of the cube. */
        {c0, c1, c2, c3}, {c3, c2, c6, c7}, {c7, c6, c5, c4},
        {c4, c5, c1, c0}, {c5, c6, c2, c1}, {c7, c4, c0, c3} };
    

    mesh.clear();
    
    for (int i = 0; i < 6; i++)
    {
        mesh.appendVertex(faces[i][0]);
        mesh.appendColorRGB(colors[i][0]);
        mesh.appendVertex(faces[i][1]);
        mesh.appendColorRGB(colors[i][1]);
        mesh.appendVertex(faces[i][2]);
        mesh.appendColorRGB(colors[i][2]);
        mesh.appendVertex(faces[i][3]);
        mesh.appendColorRGB(colors[i][3]);
        
        int numberVertices = mesh.getNumVertices();
        
        mesh.appendTriangle(numberVertices-4, numberVertices-3, numberVertices-2);
        mesh.appendTriangle(numberVertices-4, numberVertices-2, numberVertices-1);
    }
    
}

void TCube::update() {
    
    //get the vertices and colors into vectors
    vector<Vec3f> vertices = mesh.getVertices();
    vector<Color> colors = mesh.getColorsRGB();
    
    int numVertices = mesh.getNumVertices();
    
    //clear mesh first
    mesh.clear();
    
    //modify the vertices
    vector<Vec3f> ::iterator it;
    
    for(it= vertices.begin(); it < vertices.end(); it++) {
        it->x += cos(getElapsedSeconds())*2;
        mesh.appendVertex(*it);
    }
    
    //modify the colors
    vector<Color> :: iterator itColor;
    for(itColor= colors.begin(); itColor < colors.end(); itColor++) {
        itColor->r += cos(getElapsedSeconds());
        mesh.appendColorRGB(*itColor);
    }
    
    //add indices..every four vertices makes a pair of triangles which makes up a face
    for (int i = 4; i < numVertices; i+=4){
        mesh.appendTriangle(i-4, i-3, i-2);
        mesh.appendTriangle(i-4, i-2, i-1);
    }
    
}

void TCube::draw() {

    gl::draw(mesh);
}

































