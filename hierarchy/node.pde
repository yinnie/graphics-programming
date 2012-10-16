
class Node {
  String name;
  Node parent;
  ArrayList<Node> children;

  Node(String _name) {
    name = _name;
    parent = null;
    children = new ArrayList<Node>();
  }

  void addChild(Node newChild) {  
    
    children.add(newChild);
    newChild.setParent(this);
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
  
  
  void printout(int index) {
  
       println(str(index) + " " +name);
       index++;
       for(int i=0; i< children.size(); i++) {
        Node thisChild = children.get(i);
        thisChild.printout(index);   
      }       
  }
  
   
} 

