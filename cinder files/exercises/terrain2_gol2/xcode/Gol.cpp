#include "Gol.h"
#include "cinder/app/AppBasic.h"
#include "cinder/Rand.h"

using namespace std;
using namespace ci;

Gol::Gol() {
    
}

void Gol::setup() {
    
    for ( int i = 0; i < COL; i++){
        for ( int j = 0; j < COL; j++) {
            for ( int m = 0; m < COL; m++) {
            board[i][j][m] = randInt(0,2);
            //total[i][j][m] = 0;
        }
      }
    }
}

void Gol::generate(){
    
    int next[COL][COL][COL];
    
    for ( int i = 1; i < COL-1; i++) {
        for ( int j = 1; j < COL -1; j++) {
            for ( int m = 1; m < COL -1; m++) {
            
            int neighbour = 0;
            for ( int x = -1; x <=1; x++) {
                for ( int y = -1; y<=1; y++) {
                    for ( int k = -1; k<=1; k++) {
                    neighbour +=board[i+x][j+y][m+k];
                }
             }
            }
            
            neighbour -=board[i][j][m];
            
            if      ((board[i][j][m] == 1) && (neighbour <  4)) next[i][j][m] = 0;           // Loneliness
            else if ((board[i][j][m] == 1) && (neighbour >  6)) next[i][j][m] = 0;           // Overpopulation
            else if ((board[i][j][m] == 0) && (neighbour == 6)) next[i][j][m] = 1;           // Reproduction
            else                                            next[i][j][m] = board[i][j][m];  // Stasis
        }
      }
    }
    
    for ( int i = 0; i < COL; i++){
        for ( int j = 0; j < COL; j++) {
            for ( int m = 1; m < COL; m++) {
            board[i][j][m] = next[i][j][m];
            //total[i][j] += next[i][j];
        }
     }

    }
    
}