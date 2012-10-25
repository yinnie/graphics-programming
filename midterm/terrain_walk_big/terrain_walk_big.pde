//use noise2d to generate a terrain
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
int dim = 60;
//maximum number of cubes in each dimension
int n = dim/r;

//noise increment
float increment = 0.08;

//camera/eye position
float eyeX, eyeY, eyeZ;
//increment of eye position when keys are pressed
float step = 2;

void setup() {

  size( 1280, 800, OPENGL );
  meshFactory = new TMeshFactory();
  
  cubegrid = new TCube[n][n][n];

  float xoff = 0.0;
  for (int i = 0; i< n; i++ ) {
    //noise offset
    xoff += increment;
    float yoff = 0.0;
    for (int j = 0; j< n; j++) {
      //noise offest 
      yoff+= increment; 
      float h =  noise(xoff, yoff); 
      int zheight = (int) map(h, 0, 1, 0, 30); 
      println(n);
      for ( int z = 0; z< n; z++) {

        cubegrid[i][j][z] = meshFactory.createCube( meshPointsU, r );
        cubegrid[i][j][z].setPosition( new PVector(i*r*2, j*r*2, z*r*2 ));
        if(z <= zheight)  cubegrid[i][j][z].setVisibility(true);
        else  cubegrid[i][j][z].setVisibility(false);

      }
    }
  }

  //setting up initial eye position
  eyeX = width/3;
  eyeY = height/4;
  eyeZ = -280;
}

void draw() {
  lights();
  background( 0);
  //setting up camera perspective
  float cameraY = height/3.0;
  float fov =  PI/2;
  float cameraZ = cameraY / tan(fov / 2.0);
  float aspect = float(width)/float(height);
  perspective(fov, aspect, cameraZ/10, cameraZ*10.0);
 
 if(keyPressed) {
   if (key == 'w') {
    eyeY+=step; 
  }
  else if (key == 's') {
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
  width/4+r*n, height/4+r*n, -500, // centerX, centerY, centerZ
  0.0, 0.0, -1.0); // upX, upY, upZ

  //draw floor
  translate(0, 0, -400);
  fill(255, 50);
  noStroke();
  rect(0, 0, 3000, 3000);

  translate(width/4, height/4, 0);
  //draw the generated terrain
  fill( 150);
  stroke(200);
  drawTerrain();
  
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


