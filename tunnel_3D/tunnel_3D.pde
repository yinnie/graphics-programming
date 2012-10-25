import processing.opengl.*;

TriContainer root1, root2;
TriContainer[] layer1, layer2, layer3, layer4;
int           index;
boolean       goingUp;

void setup() {

  size( 800, 800, OPENGL );
  
   index         = 0;
  goingUp       = true;

  root1 = new TriContainer();
  root1.setName( "root1" );
  root1.setColor( color( 0) );
  root1.setPosition( new PVector( 0, 0.0, 0.0 ) );
  root1.setSubdivLength( 0 );

  layer1 = new TriContainer[15];
  for (int i = 0; i<layer1.length; i++) {
    layer1[i] = new TriContainer(); 
    layer1[i].setPosition(new PVector(0, 0, 20));
    layer1[i].setSubdivLength(i*5);
    if (i == 0) root1.addChild(layer1[i]);
    else layer1[i-1].addChild(layer1[i]);
  }

  layer2 = new TriContainer[15];
  for (int i = 0; i<layer2.length; i++) {
    layer2[i] = new TriContainer(); 
    layer2[i].setPosition(new PVector(0, 0, 20));
    layer2[i].setSubdivLength(i*5);
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

  layer3 = new TriContainer[20];
  for (int i = 0; i<layer3.length; i++) {
    layer3[i] = new TriContainer(); 
    layer3[i].setSubdivLength(i*5);
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

  layer4 = new TriContainer[20];
  for (int i = 0; i<layer4.length; i++) {
    layer4[i] = new TriContainer();
    layer4[i].setSubdivLength(i*5);
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
  rotateY( radians( mouseX - width/2.0 ) / 30.0 );
  root1.draw();
  //root1.print(0);

  float y = map(mouseY, 0, height, 0, 250);
  root1.setPosition(new PVector (0, 0, y));
  
  for(int i =0; i< layer1.length; i++) {
  // Get the vertex at the current index
  PVector currVert = layer1[i].getVertex( index );
  // Update the z position of the current vertex
  if( goingUp )
    currVert.z -= layer1[i].subdivLength;
  else 
    currVert.z += layer1[i].subdivLength;
  
  // Update animation cycle
  if( frameCount % 5 == 0 ) {
    // We are now using the "index" variable to iterate over each vertex
    // rather than each triangle
    if( index + 1 < ( (layer1[i].subdivisionsX + 1) * (layer1[i].subdivisionsY + 1) ) ) {
      // Increment vertex index
      index++;
    }
    else {
      // Reset vertex index
      index   = 0;
      // Reverse direction
      goingUp = !goingUp;
    }
  }
 
 
  }
  
  
  for(int i =0; i< layer2.length; i++) {
  // Get the vertex at the current index
  PVector currVert = layer2[i].getVertex( index );
  // Update the z position of the current vertex
  if( goingUp )
    currVert.z -= layer2[i].subdivLength;
  else 
    currVert.z += layer2[i].subdivLength;
  
  // Update animation cycle
  if( frameCount % 5 == 0 ) {
    // We are now using the "index" variable to iterate over each vertex
    // rather than each triangle
    if( index + 1 < ( (layer2[i].subdivisionsX + 1) * (layer2[i].subdivisionsY + 1) ) ) {
      // Increment vertex index
      index++;
    }
    else {
      // Reset vertex index
      index   = 0;
      // Reverse direction
      goingUp = !goingUp;
    }
  }
 
 
  }
  
  
  for(int i =0; i< layer3.length; i++) {
  // Get the vertex at the current index
  PVector currVert = layer3[i].getVertex( index );
  // Update the z position of the current vertex
  if( goingUp )
    currVert.z -= layer3[i].subdivLength;
  else 
    currVert.z += layer3[i].subdivLength;
  
  // Update animation cycle
  if( frameCount % 5 == 0 ) {
    // We are now using the "index" variable to iterate over each vertex
    // rather than each triangle
    if( index + 1 < ( (layer3[i].subdivisionsX + 1) * (layer3[i].subdivisionsY + 1) ) ) {
      // Increment vertex index
      index++;
    }
    else {
      // Reset vertex index
      index   = 0;
      // Reverse direction
      goingUp = !goingUp;
    }
  }
 
 
  }
  
  for(int i =0; i< layer4.length; i++) {
  // Get the vertex at the current index
  PVector currVert = layer4[i].getVertex( index );
  // Update the z position of the current vertex
  if( goingUp )
    currVert.z -= layer4[i].subdivLength;
  else 
    currVert.z += layer4[i].subdivLength;
  
  // Update animation cycle
  if( frameCount % 5 == 0 ) {
    // We are now using the "index" variable to iterate over each vertex
    // rather than each triangle
    if( index + 1 < ( (layer4[i].subdivisionsX + 1) * (layer4[i].subdivisionsY + 1) ) ) {
      // Increment vertex index
      index++;
    }
    else {
      // Reset vertex index
      index   = 0;
      // Reverse direction
      goingUp = !goingUp;
    }
  }
 
 
  }
}

