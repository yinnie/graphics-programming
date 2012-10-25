//class for making cubes as an array  of Tmeshes

class TCube extends NodeGeom {
  
  TMesh[] cubemeshes;
  
  //U and V dimensions are the same
  TCube() {
    super();
    cubemeshes = new TMesh[6];  
  }
  
  void draw() {
    for(int i = 0; i<6; i++) {
       cubemeshes[i].draw();
    } 
  }
  
  void setRotation(PVector p) {
     for(int i = 0; i<6; i++) {
       cubemeshes[i].setRotation(p);
    } 
  }
  
  void setPosition(PVector p) {
     for(int i = 0; i<6; i++) {
       cubemeshes[i].setPosition(p);
    } 
  }
  
  
}


