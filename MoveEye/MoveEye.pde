/**
 * Move Eye. 
 * by Simon Greenwold.
 * 
 * The camera lifts up (controlled by mouseY) while looking at the same point.
 */

float z;

void setup() {
  size(640, 360, P3D);
  fill(204);
  z = 220.0;
}

void draw() {
  lights();
  background(0);
  
  // Change height of the camera with mouseY
  camera(mouseX, height/2, mouseY, // eyeX, eyeY, eyeZ
         0.0, 0.0, 0.0, // centerX, centerY, centerZ
         0.0, 1.0, 0.0); // upX, upY, upZ
  
  noStroke();
  box(90);
  stroke(255);
  line(-100, 0, 0, 100, 0, 0);
  line(0, -100, 0, 0, 100, 0);
  line(0, 0, -100, 0, 0, 100);
}

void keyPressed() {
  /*
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
  */
   if(keyCode == UP) {
     z+=10;
   }
   if(keyCode == DOWN) {
      z-=10;
   }
    
}

