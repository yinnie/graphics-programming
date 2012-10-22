//use noise2d to generate a terrain
//'w' 's' and arrow keys moves one step on the grid..
//mousePressed to add a cube
//camera movement not yet added

import processing.opengl.*;

TMeshFactory meshFactory;
ArrayList<TCube> cubes;
TCube[][][] cubegrid;
// Choose the number of UVs in the mesh..U and V are the same
int meshPointsU = 3;   
//length of each square will be twice of r
int r = 10;

//length of sides
int rectx = 300;
int recty = 300;
int rectz = 300;
//number of cubes on each side
int n = rectx/r;
//number of cubes on z 
int nZ = rectz/r;

//noise increment
float increment = 0.08;

//camera/eye position
float eyeX, eyeY, eyeZ;
float step = 50;

void setup() {

  size( 1280, 800, OPENGL );
  meshFactory = new TMeshFactory();

  cubes = new ArrayList();

  cubegrid = new TCube[n][n][nZ];

  float xoff = 0.0;
  for (int i = 0; i< n; i++ ) {
    //noise offset
    xoff += increment;
    float yoff = 0.0;
    for (int j = 0; j< n; j++) {
      //noise offest 
      yoff+= increment; 
      float n =  noise(xoff, yoff); 
      int zheight = (int) map(n, 0, 1, 0, 25); 
      println(n);
      for ( int z = 0; z< nZ; z++) {

        cubegrid[i][j][z] = meshFactory.createCube( meshPointsU, r );
        cubegrid[i][j][z].setPosition( new PVector(i*r*2, j*r*2, zheight*r*2 ));
      }
    }
  }

  //setting up initial eye position
  eyeX = width/4;
  eyeY = height/4;
  eyeZ = 0;
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
  width/2, height/2, -500, // centerX, centerY, centerZ
  0.0, 0.0, -1.0); // upX, upY, upZ

  //draw floor
  translate(0, 0, -500);
  fill(255);
  noStroke();
  rect(0, 0, 3000, 3000);

  translate(width/4, height/4, 0);
  //draw the generated terrain
  fill( 255, 40);
  stroke(250);
  drawTerrain();
 
}


void drawTerrain() {
  for (int i = 0; i< n; i++ ) {
    for (int j = 0; j< n; j++) {
      for (int z = 0; z< nZ; z++) {
        if (cubegrid[i][j][z].getVisibility())
          cubegrid[i][j][z].draw();
      }
    }
  }
}


