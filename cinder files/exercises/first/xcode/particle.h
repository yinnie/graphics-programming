#pragma once 

#include "cinder/Vector.h"
#include <vector>

using namespace ci;

class Particle {
    
public:
    Particle();
    Particle (Vec2f origin);
    void update();
    void draw();
    
    float radius;
    Vec2f loc;
    Vec2f acc;
};