#pragma once

#include "cinder/gl/gl.h"
#include "cinder/TriMesh.h"
#include <vector>

using namespace ci;


class TCube {
  
public:
    TCube();
    
    void setup(Vec3f c, float r);
    void update();
    void draw();

    TriMesh mesh;
    


};
