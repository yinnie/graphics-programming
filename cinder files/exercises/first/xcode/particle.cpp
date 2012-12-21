
#include "particle.h"
#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/Rand.h"

using namespace ci;


Particle :: Particle () {

}

Particle :: Particle(Vec2f origin) {
    loc = origin;
    radius =3.0f;
    acc = Rand::randVec2f();
}

void Particle:: update() {
    
    loc += acc;
}


void Particle::draw() {
     
    gl::drawSolidCircle(loc, radius);
}
