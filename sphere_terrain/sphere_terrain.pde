// Art of Graphics Programming
// Section Example 004: "Storing Geometries: A Generic Approach"
// Example Stage: C
// Course Materials by Patrick Hebron

import processing.opengl.*;

TMesh[][][] meshes;

int r = 25;
int rectx = 300;
int recty = 300;
int rectz = 200;
int n = rectx/r;
int nZ = rectz/r;

boolean zplus = false;
 float cameraz = -100;
 
void setup() {
  // In this stage, we introduce the TMeshFactory, which encapsulates various geometric primitive generators
  // into a simple API. Rather than the lengthy setup() in the previous two stages, we can reduce the instantiation
  // of each new geometry to something like meshFactory.createCylinder(...)
  // Also notice that we've added addCylinder, etc to NodeGeom so that child geometries can be easily added to any node.

  size( 800, 600, OPENGL );

  // Choose the number of UVs in the mesh
  int meshPointsU = 10;
  int meshPointsV = 10;

  // Create new mesh factory
  TMeshFactory meshFactory = new TMeshFactory();

  // Create a new mesh lisg
  meshes = new TMesh[n][n][n];
  
  for (int i = 0; i< n; i++ ) {
    for (int j = 0; j< n; j++) {
      for (int z = 0; z< nZ; z++) {
      meshes[i][j][z] = meshFactory.createSphere( meshPointsU, meshPointsV, r );
      //meshes[i][j][z].setVisibility(true);
      meshes[i][j][z].setPosition( new PVector(i*r*2, j*r*2, z*r*2 ));
      
      float p = random(1);
      if(p > 0.2) { meshes[i][j][z].setVisibility(false);}
      else meshes[i][j][z].setVisibility(true);
      
      }
    }
  }
  
}

void draw() {
  // Clear window
  lights();
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

 camera(mouseX, mouseY, cameraz, // eyeX, eyeY, eyeZ
         width/2, height/2, 0, // centerX, centerY, centerZ
         1.0, 1.0, 0.0); // upX, upY, upZ
 if(zplus) cameraz--;
 
 
 
  // Set colors
  //stroke( 255, 80 );
  noStroke();
  fill( 255);

  //draw a grid
  translate(width/2, height/2, -350);
  rotateY(-PI/6);
  rotateX(PI/3);
  rect(0, 0, rectx, recty);

  // Draw the mesh
  for (int i = 0; i< n; i++ ) {
    for (int j = 0; j< n; j++) {
       for (int z = 0; z< nZ; z++) {
      meshes[i][j][z].draw();
    }
  }
  }
}

void mousePressed() {
  zplus = false;
}
