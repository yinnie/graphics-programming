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

TCube  mcube;
Globals globals;

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
  
  // Choose the number of UVs in the mesh
  int meshPointsU = 100;
  int meshPointsV = 100;
  // Choose a size for the mesh
  float meshRadius = 100.0;
  
  // Create new mesh factory
  TMeshFactory meshFactory = new TMeshFactory( globals );
  
  mcube = meshFactory.createCube(meshPointsU, meshRadius);
 
 
  // Set mesh texture
 // mesh.setTexture( "world32k.jpg" );
  
}

void draw() {
  // Enter scene:
  // Since GLGraphics is circumventing Processing's usual renderer,
  // we need to tell the renderer where to begin. 
  globals.mRenderer.beginGL();
    
  // Clear window
  background( 0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 255, 0, 0 );
  
  translate(width/2, height/2, 0);
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
  globals.mRenderer.gl.glLightfv(GL.GL_LIGHT0, GL.GL_POSITION, new float[] {-1000, 600, 2000, 0 }, 0);
  globals.mRenderer.gl.glLightfv(GL.GL_LIGHT0, GL.GL_SPECULAR, new float[] { 1, 1, 1, 1 }, 0); 
  
  mcube.setRotation( new PVector( PI, mouseX*PI/400, 0.0 ) );
  mcube.draw();
  
  
  // Exit scene:
  // We also need to tell the GLGraphics render where to end.
  globals.mRenderer.endGL();
}
