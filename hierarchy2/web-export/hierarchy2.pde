import processing.opengl.*;

Geom root1, root2;
Geom[] layer1, layer2, layer3, layer4;

void setup() {

  size( 800, 800, OPENGL );

  root1 = new Geom();
  root1.setName( "root1" );
  root1.setColor( color( 100) );
  root1.setPosition( new PVector( 0, 0.0, 0.0 ) );
  root1.setSideLength( 0 );

  layer1 = new Geom[30];
  for (int i = 0; i<layer1.length; i++) {
    layer1[i] = new Geom(); 
    layer1[i].setPosition(new PVector(0, 0, 20));
    layer1[i].setSideLength(i*5);
    if (i == 0) root1.addChild(layer1[i]);
    else layer1[i-1].addChild(layer1[i]);
  }

  layer2 = new Geom[30];
  for (int i = 0; i<layer2.length; i++) {
    layer2[i] = new Geom(); 
    layer2[i].setPosition(new PVector(0, 0, 20));
    layer2[i].setSideLength(i*5);
    if (i == 0) 
    { 
      layer2[i].setPosition(new PVector(0, 0, 30*5+20));  
      root1.addChild(layer2[i]);
      layer2[i].setName("layer2");
    }
    else {
      layer2[i-1].addChild(layer2[i]);
      layer2[i].setPosition(new PVector(0, 0, 20));
    }
  }

  layer3 = new Geom[30];
  for (int i = 0; i<layer3.length; i++) {
    layer3[i] = new Geom(); 
    layer3[i].setSideLength(i*5);
    if (i == 0) 
    { 
    layer3[i].setPosition(new PVector(0, 0, 60*5+20));   
      root1.addChild(layer3[i]);
      layer3[i].setName("layer3");
    }
    else  {
      layer3[i-1].addChild(layer3[i]);
       layer3[i].setPosition(new PVector(0, 0, 20));
    }
  }

  layer4 = new Geom[30];
  for (int i = 0; i<layer4.length; i++) {
    layer4[i] = new Geom();
    layer4[i].setSideLength(i*5);
    if (i == 0) 
    { 
      layer4[i].setPosition(new PVector(0, 0, 90*6+20));  
      root1.addChild(layer4[i]);
      layer4[i].setName("layer4");
    }
    else {
      layer4[i-1].addChild(layer4[i]);
      layer4[i].setPosition(new PVector(0, 0, 20)); 
    }
  }
}

void draw() {
  
  background(190);
  translate( width/2, height/2, 0.0 );
  root1.draw();
  //root1.print(0);

  float y = map(mouseY, 0, height, 0, 250);
  root1.setPosition(new PVector (0, 0, y));
 
}



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
  

class Node {
  
  String name;
  Node parent;
  ArrayList<Node> children;

  Node(String _name) {
    name = _name;
    parent = null;
    children = new ArrayList();
  }
  
  Node() {
    name = "unamed";
    parent = null;
    children = new ArrayList();
  }

  void addChild(Node newChild) {  
    
    children.add(newChild);
    newChild.setParent(this);
  }
  
  Node getChild(int index) {
    if(index >=0 && index < children.size()) {
      return children.get(index);
    }
    else return null;
  }
  
  void setName(String n) {
    name = n;
  }
  
  void setParent(Node newP) {
    parent = newP;
  }

  Node getParent() {
    return parent;
  }

  void addParent(Node newParent) {
    setParent(newParent);
    newParent.addChild(this);
  }
  
  int getChildCount() {
    return children.size();
  }
  
  void printout(int index) {
       
       String space = " ";
       int l = space.length()*index;
       String indent = new String(new char[l]).replace("\0", space); 
       //\0 is null character. since the new String was not initiated yet..all char are null
       println(indent + str(index) + space + name);
       index++;
       int s = getChildCount();
       for(int i=0; i< s; i++) {
        Node thisChild = children.get(i);
        thisChild.printout(index);   
       }  
       
  }
  
  void draw() {
    //stud method
  }
   
} 


