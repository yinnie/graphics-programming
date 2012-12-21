
#include "cinder/app/AppBasic.h"
#include "particleController.h"
#include "cinder/Rand.h"
#include <vector>


ParticleController ::ParticleController() {
    
}

void ParticleController:: update() {
    
    vector<Particle>::iterator it;
    
    for ( it = particles.begin(); it < particles.end(); it++) {
        it->update();
    }
    
}

void ParticleController::draw() {
    
    vector<Particle>::iterator it;
    for(it = particles.begin(); it<particles.end(); it++) {
        it->draw();
    }
    
}

void ParticleController::addParticle (int amt) {
    for (int i=0; i<amt; i++) {
        
        float x = Rand::randFloat(app::getWindowWidth());
        float y = Rand::randFloat(app::getWindowHeight());
        
        //why cant i use the following
        //Particle newP = new Particle(Vec2f(x,y));
        
        //what does push back expect? a pointer?
        //why are we passing Particle(xxx) straight in??
        particles.push_back(Particle(Vec2f(x, y)));
    }

}

void ParticleController::removeParticle(int amt) {
    for(int i = 0; i<amt; i++) {
        particles.pop_back();
    }
}

