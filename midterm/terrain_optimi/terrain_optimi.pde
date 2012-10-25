// Art of Graphics Programming
// Section Example 005: "Optimizing Geometries"
// Example Stage: A
// Course Materials by Patrick Hebron

// Processing OpenGL
import processing.opengl.*;
// Raw OpenGL handle
import javax.media.opengl.*;
// GLGraphics: http://glgraphics.sourceforge.net
import codeanticode.glgraphics.*;

TCube[][][] cubegrid;

Globals globals;

// Choose the number of UVs in the mesh..U and V are the same
int meshPointsU = 3;   
//radius of square
int r = 20;
//dimensions of the entire cube grid
int dim = 200;
//maximum number of cubes in each dimension
int n = dim/r;

//noise increment
float increment = 0.08;

//camera/eye position
float eyeX, eyeY, eyeZ;
//increment of eye position when keys are pressed
float step = 50;

void setup() {
  // In this stage, we add the GLGraphics library, which provides easy access to some of OpenGL's more advanced
  // features and optimizations. This will require several changes throughout the code. In essence,
  // GLGraphics is circumventing Processing's standard render to provide easier access to more optimized
  // but also more complex tools within OpenGL. In previous examples, we've been computing the vertex
  // positions once, storing these values on the CPU side (in RAM) and then passing them to the graphics card
  // via OpenGL each frame. In this example, we compute the vertex positions once and then immediately pass
  // them into GPU memory by way of a GLGraphics object called a GLModel. In other OpenGL-based application
  // frameworks such as OpenFrameworks and Cinder, we might call GLModel a wrapper class for a particular type
  // of OpenGL storage unit known as a Vertex Buffer Object (VBO). A VBO stores vertex data within GPU memory, allowing
  // us to construct a rendering pipeline in which we only copy geometric data to the GPU once within the lifecycle
  // of the application. Later, when we add the ability to animate vertex positions within a mesh, we'll need to revise
  // our approach slightly, but can still prevent excessive CPU-to-GPU data transfers.
  // See TMesh and particularly the initModelAcceleration() method of TMeshFactory for additional notes.
  
  // We now initialize the renderer with "GLConstants.GLGRAPHICS" rather than "OPENGL":
  size( 800, 600, GLConstants.GLGRAPHICS );
  
  // GLGraphics requires lower-level access to some of the PApplet's properties,
  // namely the OpenGL renderer. To provide this to each node, we'll create a globals
  // class that gets passed to each node when it is initialized. 
  globals = new Globals( this );
    
  // Create new mesh factory
  TMeshFactory meshFactory = new TMeshFactory( globals );
  
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
      int zheight = (int) map(h, 0, 1, 0, 25); 
      for ( int z = 0; z< n; z++) {

        cubegrid[i][j][z] = meshFactory.createCube( meshPointsU, r);
        cubegrid[i][j][z].setPosition( new PVector(i*r*2, j*r*2, zheight*r*2 ));
      }
    }
  }

  //setting up initial eye position
  eyeX = 100;
  eyeY = 300;
  eyeZ = 1250;
  
  // Set mesh texture
 // mesh.setTexture( "world32k.jpg" );
 
}

void draw() {
  // Enter scene:
  // Since GLGraphics is circumventing Processing's usual renderer,
  // we need to tell the renderer where to begin. 
 
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
 
  
  globals.mRenderer.beginGL();
  
  
  
  background( 0);  
  //draw floor
  //translate(width/2, width/2, -500);
  //fill(255,40);
  //noStroke();
  //rect(0, 0, 3000, 3000);
  
  globals.mRenderer.gl.glEnable(GL.GL_LIGHTING);
  
  // Disabling color tracking, so the lighting is determined using the colors
  // set only with glMaterialfv()
  globals.mRenderer.gl.glDisable(GL.GL_COLOR_MATERIAL);
  
  // Enabling color tracking for the specular component, this means that the 
  // specular component to calculate lighting will obtained from the colors 
  // of the model (in this case, pure green).
  // This tutorial is quite good to clarify issues regarding lighting in OpenGL:
  // http://www.sjbaker.org/steve/omniv/opengl_lighting.html
  //renderer.gl.glEnable(GL.GL_COLOR_MATERIAL);
  //renderer.gl.glColorMaterial(GL.GL_FRONT_AND_BACK, GL.GL_SPECULAR);  
  
  globals.mRenderer.gl.glEnable(GL.GL_LIGHT0);
  globals.mRenderer.gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL.GL_AMBIENT, new float[]{0.1,0.1,0.1,1}, 0);
  globals.mRenderer.gl.glMaterialfv(GL.GL_FRONT_AND_BACK, GL.GL_DIFFUSE, new float[]{1,0,0,1}, 0);  
  globals.mRenderer.gl.glLightfv(GL.GL_LIGHT0, GL.GL_POSITION, new float[] {200, 300, 1250, 0 }, 0);
  globals.mRenderer.gl.glLightfv(GL.GL_LIGHT0, GL.GL_SPECULAR, new float[] { 1, 1, 1, 1 }, 0); 
 
  drawTerrain();
  
  // Exit scene:
  // We also need to tell the GLGraphics render where to end.
  globals.mRenderer.endGL();
  
  println("x " + eyeX);
  println("y " + eyeY);
  println("z " +eyeZ);
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


