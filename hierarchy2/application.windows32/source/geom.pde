

class Geom extends Node {
  
  PVector position;
  PVector theScale;
  PVector rotation;
  PVector velocity;
  PVector acceleration;
  color theColor;
  float l; //length of rectangle
  float maxspeed;
  float maxforce;
  ArrayList<PVector> history = new ArrayList<PVector>();

  Geom() {
    //initialise base class
    super();
    position = new PVector(0, 0, 0);
    theScale = new PVector(1, 1, 1);
    rotation = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    theColor = color (0);
    l = 10;
    maxspeed = 4;
    maxforce = 0.1; 
  }
  
  void draw() {
    
    pushMatrix();
    translate(position.x, position.y, position.z);
    scale(theScale.x, theScale.y, theScale.z);
    rotateX(rotation.x);
    rotateY(rotation.y);
    rotateZ(rotation.z);
    
    noStroke();
    fill(0,20);
    rectMode(CENTER);
    rect(0, 0, l, l);
    int t = getChildCount();
    for(int i = 0; i<t; i++) {
      getChild(i).draw();      
      //children.get(i).draw();   //WHAT IS THE DIFFERNECE??
      //((Node)getChild(i)).getPosition(); 
      //children are by defaul node objects...so type  casting to use a function that
      //only appears in geom class not the base class 
    }  
    
    popMatrix();
  }
  
  void seek(PVector target) {
     PVector desired = PVector.sub(target, position);
     desired.normalize();     //direction decided..
     desired.mult(maxspeed);  //speed capped ...
     PVector steer = PVector.sub(desired, velocity);
     steer.limit(maxforce);
     applyForce(steer);
  }
  
  void update() {   
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
    history.add(position.get());
    if (history.size() >50) {
      history.remove(0);
    }
    
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);   //NOT acceleration equals force
                               //assuming mass is 1
  }
  
  PVector getPosition() {
    return position;
  }
  
  PVector getRotation() {
    return rotation;
  }
  
  PVector getScale() {
    return theScale;
  }
  
  void setPosition(PVector pos) {
    position.set(pos);
  }
  
   void setRotation(PVector iValue) { 
    rotation.set( iValue );
  }
  
  void setScale(PVector iValue) { 
    theScale.set( iValue );
  }
  void setColor(color iColor) {
    theColor = iColor;
  }
   void setSideLength(float iLength) {
    l = iLength;
   }
  
  
}
  
