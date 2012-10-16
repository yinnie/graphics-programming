
TriContainer container;

int inc = 30; //rectangel width
int numX = 10;
int numY = 10;

void setup() {

  size(500, 500, OPENGL);
  container = new TriContainer();

  int startx = 50;
  int starty = 50;

  for ( int i = 0; i< numX; i++) {
    for ( int j = 0; j < numY; j++) {

      PVector A = new PVector(startx+inc*i, starty+j*inc, 0);
      PVector B = new PVector(startx+inc*i, starty+(j+1)*inc, 0);
      PVector C = new PVector(startx+inc*(i+1), starty+j*inc, 0);
      PVector D = new PVector(startx+inc*(i+1), starty+(j+1)*inc, 0);
      
      container.addTriangle(new Tri(A,B,C));
      container.addTriangle(new Tri(B.get(), C.get(), D));
    }
  }
  
}


void draw() {
      background(0);
      translate(50+30*10/2, 50+30*10/2, 0);
      rotateY(radians(mouseX)/2);
      stroke(255, 0, 0);
      fill(0, 255, 0);
      
      container.draw();
      
}




