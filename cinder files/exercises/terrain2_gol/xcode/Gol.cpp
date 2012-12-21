#include "Gol.h"
#include "cinder/app/AppBasic.h"
#include "cinder/Rand.h"

using namespace std;
using namespace ci;

Gol::Gol() {
    
}

void Gol::setup() {
    
    for ( int i = 0; i < COL; i++){
        for ( int j = 0; j < ROW; j++) {
            board[i][j] = randInt(0,2);
            total[i][j] = 0;
        }
    }
}

void Gol::generate() {
    
    int next[COL][ROW];
    
    for ( int i = 1; i < COL-1; i++) {
        for ( int j = 1; j < ROW -1; j++) {
            
            int neighbour = 0;
            for ( int x = -1; x <=1; x++) {
                for ( int y = -1; y<=1; y++) {
                    neighbour +=board[i+x][j+y];
                }
            }
            
            neighbour -=board[i][j];
            
            if      ((board[i][j] == 1) && (neighbour <  2)) next[i][j] = 0;           // Loneliness
            else if ((board[i][j] == 1) && (neighbour >  3)) next[i][j] = 0;           // Overpopulation
            else if ((board[i][j] == 0) && (neighbour == 3)) next[i][j] = 1;           // Reproduction
            else                                            next[i][j] = board[i][j];  // Stasis
        }
    }
    
    for ( int i = 0; i < COL; i++){
        for ( int j = 0; j < ROW; j++) {
            board[i][j] = next[i][j];
            total[i][j] += next[i][j];
        }
    }

    
    
}