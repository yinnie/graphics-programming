#pragma once
#include "cinder/app/AppBasic.h"

using namespace ci;

#define COL 40


class Gol {
    
public:
    
    Gol();
    
    void setup();
    void generate();

    
    int board[COL][COL][COL];
    //int total[COL][COL][COL];

    
};



