import processing.opengl.*;

NodeGeom root1, root2;
NodeGeom[] layer1, layer2, layer3, layer4;

void setup() {

  size( 800, 800, OPENGL );

  root1 = new NodeGeom();
  root1.setName( "root1" );
  root1.setColor( color( 100) );
  root1.setPosition( new PVector( 0, 0.0, 0.0 ) );
  root1.setSideLength( 0 );

  layer1 = new NodeGeom[30];
  for (int i = 0; i<layer1.length; i++) {
    layer1[i] = new NodeGeom(); 
    layer1[i].setPosition(new PVector(0, 0, 20));
    layer1[i].setSideLength(i*5);
    if (i == 0) root1.addChild(layer1[i]);
    else layer1[i-1].addChild(layer1[i]);
  }

  layer2 = new NodeGeom[30];
  for (int i = 0; i<layer2.length; i++) {
    layer2[i] = new NodeGeom(); 
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

  layer3 = new NodeGeom[30];
  for (int i = 0; i<layer3.length; i++) {
    layer3[i] = new NodeGeom(); 
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

  layer4 = new NodeGeom[30];
  for (int i = 0; i<layer4.length; i++) {
    layer4[i] = new NodeGeom();
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

