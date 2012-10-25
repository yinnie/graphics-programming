//use noise to generate a terrain
//'w' 's' and arrow keys moves one step on the grid..
//mousePressed to add a cube
//camera movement not yet added

import processing.opengl.*;

TMeshFactory meshFactory;
TCube[][][] cubegrid;
// Choose the number of UVs in the mesh..U and V are the same
int meshPointsU = 3;   
//radius of square
int r = 2;
//dimensions of the entire cube grid
int dim = 40;
//maximum number of cubes in each dimension
int n = dim/r;

//current position in the grid, 0 up to gridx/y/z
int curx = n/2;
int cury = n/2;
int curz = n-5;
//current cube location in the grid 
TCube curCube;

//noise increment
float increment = 0.08;

//camera/eye position
float eyeX, eyeY, eyeZ, centerX, centerY, centerZ;
//increment of eye position when keys are pressed
float step = 2;

void setup() {

  size( 1280, 800, OPENGL );
  meshFactory = new TMeshFactory();

  cubegrid = new TCube[n][n][n];
  curCube = new TCube();
  
  //make the terrain 
  float xoff = 0.0;
  for (int i = 0; i< n; i++ ) {
    //noise offset
    xoff += increment;
    float yoff = 0.0;
    for (int j = 0; j< n; j++) {
      //noise offest 
      yoff+= increment; 
      float h =  noise(xoff, yoff); 
      int zheight = (int) map(h, 0, 1, 0, n); 
      for ( int z = 0; z< n; z++) {

        cubegrid[i][j][z] = meshFactory.createCube( meshPointsU, r );
        cubegrid[i][j][z].setPosition( new PVector(i*r*2, j*r*2, z*r*2 ));
        if (z <= zheight)  cubegrid[i][j][z].setVisibility(true);
        else  cubegrid[i][j][z].setVisibility(false);
      }
    }
  }
  //make the curCube
  curCube  = meshFactory.createCube( meshPointsU, r);

  //setting up initial eye position
  eyeX = width/3.7;
  eyeY = height/4;
  eyeZ = -300;
  //center of the scene that the camera is looking at
  centerX = width/4+r*n;
  centerY = width/4+r*n;
  centerZ = -500;
}

void draw() {

  lights();
  background( 0);
  //setting up camera perspective
  float cameraY = height/2.0;
  float fov =  PI/2;
  float cameraZ = cameraY / tan(fov / 2.0);
  float aspect = float(width)/float(height);
  perspective(fov, aspect, cameraZ/10, cameraZ*10.0);

  if (keyPressed) {
    if (key == 'P') {
      eyeY+=step;
    }
    else if (key == 'L') {
      eyeY-=step;
    }
    else if (keyCode == LEFT) {
      eyeX-=step;
    }
    else if (keyCode == RIGHT) {
      eyeX+=step;
    }
    else if (keyCode == UP) {
      eyeZ+=step;
    }
    else if (keyCode == DOWN) {
      eyeZ-=step;
    }
  }

  camera(eyeX, eyeY, eyeZ, // eyeX, eyeY, eyeZ
  centerX, centerY, centerZ, // centerX, centerY, centerZ
  0.0, 0.0, -1.0); // upX, upY, upZ

  //draw floor
  translate(0, 0, centerZ+100);
  fill(255, 50);
  noStroke();
  rect(0, 0, 3000, 3000);

  translate(width/4, height/4, 0);
  //draw the generated terrain
  fill( 150);
  stroke(200);
  drawTerrain();
  
  //update the curCube
  curCube.setPosition( new PVector(curx*r*2, cury*r*2, curz*r*2));
  noFill();
  stroke(255, 150, 0);
  curCube.draw();
  
  println("x " + eyeX + "y " + eyeY + "z " +eyeZ);
}


void drawTerrain() {
  for (int i = 0; i< n; i++ ) {
    for (int j = 0; j< n; j++) {
      for (int z = 0; z< n; z++) {
        if (cubegrid[i][j][z].getVisibility())
          cubegrid[i][j][z].draw();
      }
    }
  }
}

void mousePressed() {
  //turn the current location in the grid to 1
  boolean vis = cubegrid[curx][cury][curz].getVisibility();
  cubegrid[curx][cury][curz].setVisibility(!vis);
}


void keyPressed() {
 if (key == 'w') {
 cury--;
 if (cury < 0) cury = 0;
 }
 if (key == 's') {
 cury++;
 if (cury > n-1) cury = n-1;
 }    
 if (key == 'a') {
 curx--; 
 if (curx < 0) curx =0;
 }
 if (key == 'd') {
 curx++;
 if (curx > n-1) curx = n-1;
 }
 if(key == 'q') {
 curz++;
 if (curz > n-1) curz= n-1;
 }
 if(key == 'e') {
 curz--;
 if (curz < 0) curz =0;
 }
 }
 

