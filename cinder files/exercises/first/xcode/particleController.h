#pragma once


#include "particle.h"
#include <vector>

using namespace std;


class ParticleController {
public:

    ParticleController();
    void update();
    void draw();
    void addParticle(int amtAdd);
    void removeParticle(int amtRem);

    vector<Particle> particles;


};
