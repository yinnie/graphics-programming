
class Tri {
  
  PVector[] verts;
  
  Tri(PVector vertA, PVector vertB, PVector vertC) {
    
    //INITIATE the array by assigning a size!!!!!
    //similar to vector in c++..where you initialize by saying thisvector.resize();
    verts = new PVector[3];
    verts[0] = vertA;
    verts[1] = vertB;
    verts[2] = vertC;

  }
  
  void allVertices() {
     for(int i = 0; i<3; i++) {
      vertex(verts[i].x, verts[i].y, verts[i].z);
     } 
   
  }
    
}
