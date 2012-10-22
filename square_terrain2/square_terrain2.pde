//use noise2d to generate a terrain
//'w' 's' 'a' 'd' moves one step on the grid..Up and Down moves in up and down in space
//mousePressed to add a cube
//camera movement not yet added

import processing.opengl.*;

int[][][] grid;
TMeshFactory meshFactory;
ArrayList<TCube> cubes;
TCube[][][] cubegrid;
// Choose the number of UVs in the mesh..U and V are the same
int meshPointsU = 3;   
//length of each square will be twice of r
int r = 15;

//length of sides
int rectx = 400;
int recty = 400;
int rectz = 400;
//number of cubes on each side
int n = rectx/r;
//number of cubes on z 
int nZ = rectz/r;

//number of squares on each side of the grid
int gridx = n;
int gridy = n;
int gridz = nZ;

//current position in the grid, 0 up to gridx/y/z
int curx = 0;
int cury = 0;
int curz = 0;

//noise increment
float increment = 0.08;

//camera/eye position
float eyeX, eyeY, eyeZ;
boolean moveForward = false;
boolean moveBack = false;
boolean moveLeft = false;
boolean moveRight = false;
boolean moveUp = false;
boolean moveDown = false;

void setup() {

  size( 1280, 800, OPENGL );
  meshFactory = new TMeshFactory();

  cubes = new ArrayList();
  //initialize the grid
  grid = new int[gridx][gridy][gridz];
  for (int i = 0; i< gridx; i++ ) {
    for (int j = 0; j< gridy; j++) {
      for (int z = 0; z< gridz; z++) {
        grid[i][j][z] = 0;
      }
    }
  }

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

 updateCamera();
 
  noStroke();
  fill( 255);
  //draw floor
  translate(0, 0, -500);
  rect(0, 0, 3000, 3000);

  translate(width/4, height/4, 0);
  //draw the generated terrain
  drawTerrain();

 
}

void mousePressed() {
  //turn the current location in the grid to 1
  grid[curx][cury][curz] = 1;
  TCube cube = meshFactory.createCube( meshPointsU, r );
  cube.setPosition(new PVector(curx*r*2, cury*r*2, curz*r*2));
  cubes.add(cube);
}

void keyPressed() {
  if (key == 'w') 
    moveForward = true;
  else if (key == 's')
    moveBack = true; 
  else if (key == 'a')
    moveLeft = true;
  else if (key == 'd')
    moveRight = true;
  else if (keyCode == UP)
    moveUp = true;
  else if (keyCode == DOWN)
    moveDown = true;
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

  // Draw the newly added cubes
  for (int i = 0; i<cubes.size(); i++) {
    TCube cube = cubes.get(i);
    cube.draw();
  }
  // println("curx" + curx + "cury" + cury + "curz" + curz);
}

void keyReleased() {
  if (key == 'w') 
    moveForward = false;
  else if (key == 's')
    moveBack = false; 
  else if (key == 'a')
    moveLeft = false;
  else if (key == 'd')
    moveRight = false;
  else if (keyCode == UP)
    moveUp = false;
  else if (keyCode == DOWN)
    moveDown = false;
}

void updateCamera() {
  
  if (moveForward) eyeY+=10;
  else if (moveBack) eyeY-=10;
  else if (moveLeft) eyeX-=10;
  else if (moveRight) eyeX+=10;
  else if (moveUp) eyeZ++;
  else if (moveDown) eyeZ--;
  
   camera(eyeX, eyeY, 0, // eyeX, eyeY, eyeZ
  width/2, height/2, -500, // centerX, centerY, centerZ
  0.0, 0.0, -1.0); // upX, upY, upZ
}

