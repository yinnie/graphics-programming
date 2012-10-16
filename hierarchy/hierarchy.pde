
Node person;


void setup() {
  size(500, 500);
  person = new Node("person");
  Node head = new Node("head");
  person.addChild(head);
  Node body = new Node("body");
  Node arms = new Node("arms");
  head.addChild(body);
  head.addChild(arms);

}

void draw() {
  person.printout(0);
}

