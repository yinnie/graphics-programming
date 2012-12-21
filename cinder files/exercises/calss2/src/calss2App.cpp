#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"

using namespace ci;
using namespace ci::app;
using namespace std;


class Info {  
public:
    Info() {}   //default constructor to prepare pointer..
    Info(string name) {
        name  = mName;
    }
    string mName;
    string getName() {
        return mName;
    }
    void setName(string name) {
        mName = name;
    }
};


class subinfo {

public:
    subinfo() {}
    subinfo (int num) {
        mNum = num;
    }
    int mNum;
    int getNum() {
        return mNum;
    }

    
};

class calss2App : public AppBasic {
  public:
	void setup();
	void mouseDown( MouseEvent event );	
	void update();
	void draw();
    
    Info obj1;
    Info * obj2;
    
    shared_ptr<Info> mobj3;
    
    vector<Info*> mobjcontainer;   //you dont have to initiate vector..it can be empty
    map<string, Info*> mobjmap;   
};

void calss2App::setup()
{
    obj1 = Info("mobj1");
    obj2 = new Info ("mobj2");  //pointer needs new
    
    obj1.getName();
    obj2->getName();
    (&obj1)->getName();  //brackets!
    (*obj2).getName();
    
    mobj3 = shared_ptr<Info> (new Info("mobj3"));
    
    mobj3->getName();
    //mobj3.get() gives you back the pointer info*..so if you want to type cast you need to get the pointer first
    mobj3.get() -> getName();
    
    //type casting to subinfo so we can access functions in that class
    int a = ((subinfo*)(mobj3.get())) ->getNum();
    //this wont work:  ((subinfo*mobj3)->getNum();
    
    mobjcontainer.push_back(obj2);
    
    mobjmap.push(obj2);
    
    int count = mobjcontainer.size();
    
    vector<Info*>::iterator it;
    for(it = mobjcontainer.begin(); it < mobjcontainer.end(); it++) {
        (*it)->getName();
    }

    map<string, Info*>::iterator it1;
    //there are two things at each index of map...first and second...in pairs
    for(it1 = mobjmap.begin(); it1 != mobjmap.end(); it1++) {
        (*it1).first.length();  //the string's function
        (*it1).second->getName();  // accessing the pointer info*
    }
    
    //maps
    mobjmap["patrick"] = mobj2;
    Info* tOut = mobjmap["patrick"];
    //make sure tOut! = NULL
    
    //insert function in map...insert a pair of string and object...
    
    
}

void calss2App::mouseDown( MouseEvent event )
{
}

void calss2App::update()
{
}

void calss2App::draw()
{
	// clear out the window with black
	gl::clear( Color( 0, 0, 0 ) ); 
}

CINDER_APP_BASIC( calss2App, RendererGl )
