
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

