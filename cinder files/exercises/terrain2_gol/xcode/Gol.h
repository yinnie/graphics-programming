#pragma once
#include "cinder/app/AppBasic.h"

using namespace ci;

#define COL 50
#define ROW 50


class Gol {
    
public:
    
    Gol();
    
    void setup();
    void generate();

    
    int board[COL][ROW];
    int total[COL][ROW];

    
};



