#pragma once
#include "cinder/app/AppBasic.h"

using namespace ci;

#define COL 80
#define ROW 80


class Gol {
    
public:
    
    Gol();
    
    void setup();
    void generate();

    
    int board[COL][ROW];
    int total[COL][ROW];

    
};



