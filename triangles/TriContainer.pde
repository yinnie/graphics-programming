
class TriContainer {

  ArrayList<Tri> Trilist;

  TriContainer() {
    Trilist = new ArrayList();
  }

  void addTriangle(Tri theTri) {
    Trilist.add(theTri);
  }

  Tri getTriangle(int index) {
    //make sure when other people try to use this get method
    //they dont get bad data
    //so put in conditions
    if (index>=0 && index < getTriangleCount()) {
      return Trilist.get(index);
    }
    return null;
  }

  int getTriangleCount() {
    return Trilist.size();
  }

  void draw() {
    //for efficiency, calculate size once
    int count = getTriangleCount();
    beginShape(TRIANGLES);
    for (int i = 0; i < count; i++) {
      Trilist.get(i).allVertices();
    }
    endShape();
  }
  
  
}








