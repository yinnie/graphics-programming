
import processing.opengl.*;

int[][][] grid;
TMeshFactory meshFactory;
ArrayList<TCube> cubes;
// Choose the number of UVs in the mesh..U and V are the same
int meshPointsU = 6;   

//number of squares on each side of the grid
int gridx = 10;
int gridy = 10;
int gridz = 10;
//current position in the grid, 0 up to gridx/y/z
int curx = 0;
int cury = 0;
int curz = 0;
//length of each square will be twice of r
int r = 15;

boolean zplus = false;
float cameraz = -100;

void setup() {

  size( 800, 600, OPENGL );
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
}

void draw() {
  //lights();
  background( 0);
  /*
  float cameraY = height/2.0;
   float fov = mouseX/float(width) * PI/2;
   float cameraZ = cameraY / tan(fov / 2.0);
   float aspect = float(width)/float(height);
   if (mousePressed) {
   aspect = aspect / 2.0;
   }
   perspective(fov, aspect, cameraZ/10.0, cameraZ*10.0);
   */
  /*
 camera(mouseX, mouseY, cameraz, // eyeX, eyeY, eyeZ
   width/2, height/2, 0, // centerX, centerY, centerZ
   1.0, 1.0, 0.0); // upX, upY, upZ
   if(zplus) cameraz--;  */

  //stroke( 255, 80 );
  noStroke();
  fill( 150, 50);

  //draw a grid
  translate(width/2, height/2, 0);
  rotateY(-PI/6);
  rotateX(PI/3);
  rect(0, 0, gridx*r*2, gridy*r*2);
  // Draw the meshes
  for (int i = 0; i<cubes.size(); i++) {
    TCube cube = cubes.get(i);
    cube.draw();
  }
  println("curx" + curx + "cury" + cury + "curz" + curz);
}

void mousePressed() {
  //turn the current location in the grid to 1
  grid[curx][cury][curz] = 1;
  TCube cube = meshFactory.createCube( meshPointsU,  r );
  cube.setPosition(new PVector(curx*r*2, cury*r*2, curz*r*2));
  cubes.add(cube);
}

void keyPressed() {
  if (key == 'w') {
    cury--;
    if (cury < 0) cury = 0;
  }
  if (key == 's') {
    cury++;
    if (cury > gridy) cury = gridy;
  }    
  if (key == 'a') {
    curx--; 
   if (curx <0) curx =0;
  }
   if (key == 'd') {
    curx++;
    if (curx > gridx) curx = gridx;
  }
   if(keyCode == UP) {
     curz++;
     if (curz > gridz) curz= gridz;
   }
   if(keyCode == DOWN) {
     curz--;
      if (curz <0) curz =0;
   }
  
  
}

