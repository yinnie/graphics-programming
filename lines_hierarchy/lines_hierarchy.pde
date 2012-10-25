// Art of Graphics Programming
// Section Example 001: "Basic Scenegraph: Node trees and nested matrices"
// Example Stage: B
// Course Materials by Patrick Hebron

import processing.opengl.*;

NodeGeom root1, root2;

NodeGeom[] layer1, layer2, layer3;

void setup() {

  size( 800, 800, OPENGL );

  root1 = new NodeGeom();
  root1.setName( "root1" );
  root1.setColor( color( 100) );
  root1.setPosition( new PVector( 0, 0.0, 0.0 ) );
  root1.setSideLength( 2.0 );

  layer1 = new NodeGeom[300];
  for (int i = 0; i<layer1.length; i++) {
    layer1[i] = new NodeGeom(); 
    layer1[i].setColor(color(0));
    layer1[i].setPosition(new PVector(random(-width/2, width/2), random(-height/4, height/4), random(-height/4, height/4)));
    layer1[i].setSideLength((int)random(3));
    layer1[i].setRotation(new PVector(0, 1, 0));
    root1.addChild(layer1[i]);
  }

  layer2 = new NodeGeom[300];
  for (int i = 0; i<layer2.length; i++) {
    layer2[i] = new NodeGeom(); 
    layer2[i].setColor(color(0));
    layer2[i].setPosition(new PVector(50, 0, 0));
    layer2[i].setSideLength((int)random(3));

    layer1[i].addChild(layer2[i]);
  }
}

void draw() {
  // Clear window
  background( 255);
  // Translate to center of screen
  translate( width/2, height/2, 0.0 );
  // Draw the scenegraph
  root1.draw();

  for (int i = 0; i<layer1.length-10; i++) {
    layer1[i].seek(layer1[i+10].getPosition());
    layer1[i].update();
  }


  for (int i = 0; i<layer1.length-10; i++) {
    strokeWeight(0.7);
    stroke(0, 95); 
    PVector p = layer1[i].getPosition(); 
    println(layer1[100].getPosition());
    PVector q = layer1[i+10].getPosition();
    line(p.x, p.y, p.z, q.x, q.y, q.z);
  }

 
  //root1.setPosition(new PVector (mouseX, mouseY, 0));
  //root1.setRotation(new PVector (0, mouseY/50, 0));
  //childA.drawReverse(); 

}

void mousePressed() {
   root1.applyForce(new PVector(0, 0, 0.5));
}


