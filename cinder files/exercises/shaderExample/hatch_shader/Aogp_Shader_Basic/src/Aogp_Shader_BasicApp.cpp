#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/GlslProg.h"
#include "cinder/ImageIo.h"
#include "cinder/Capture.h"

using namespace ci;
using namespace ci::app;
using namespace std;


#define STRINGIFY(s) #s

static const string GLSL_VERT_PASSTHROUGH = STRINGIFY(
         
        varying float V;
        void main() {
            gl_TexCoord[0] = gl_MultiTexCoord0;
            
            V = gl_TexCoord[0].s; //try .s for vertical stripes
            gl_Position = ftransform();
    }
);

static const string GLSL_FRAG_IMGPROC = STRINGIFY(
                                                  const float frequency = 12.0;
                                                  uniform vec3 Color0;
                                                  uniform vec3 Color1;
                                                  
                                                  varying float V;
                
                                                  
                                                  void main()
{
    
    float sawtooth = fract (V * frequency);
    float triangle = abs(2.0 * sawtooth - 1.0);
    float dp = length ( vec2(dFdx(V), dFdy(V)));
    float edge = dp * frequency * 2.0;
    float square = smoothstep(0.5 - edge, 0.5 + edge, triangle);
    vec3 color = mix(Color0, Color1, square);
    
    gl_FragColor = vec4( color, 1.0 );
    
}




);

class Aogp_Shader_BasicApp : public AppBasic {
  public:
	void prepareSettings( Settings *settings );
	void setup();
	void mouseDown( MouseEvent event );
	void keyDown( KeyEvent event );
	void resize( ResizeEvent event );
	void update();
	void draw();


    
	gl::GlslProg mShader;
 
};

void Aogp_Shader_BasicApp::prepareSettings( Settings *settings ) {
	settings->setFrameRate( 60.0f );
	settings->setWindowSize( 800, 600 );
}

void Aogp_Shader_BasicApp::setup() {
    // Initialize shader:
	try {
		mShader = gl::GlslProg( GLSL_VERT_PASSTHROUGH.c_str(), GLSL_FRAG_IMGPROC.c_str() );
	}
    catch( gl::GlslProgCompileExc &exc ) {
		console() << "Cannot compile shader: " << exc.what() << std::endl;
		exit(1);
	}
    catch( Exception &exc ){
		console() << "Cannot load shader: " << exc.what() << std::endl;
		exit(1);
	}
    
  
}

void Aogp_Shader_BasicApp::mouseDown( MouseEvent event ) {
}

void Aogp_Shader_BasicApp::keyDown( KeyEvent event ) {
}

void Aogp_Shader_BasicApp::resize( ResizeEvent event ) {
}

void Aogp_Shader_BasicApp::update() {
    
}

void Aogp_Shader_BasicApp::draw() {
	gl::clear( Color(0, 0, 0) );
	
        mShader.bind();
        mShader.uniform("Color0", Vec3f(0, 0, 0));
        mShader.uniform("Color1", Vec3f(1, 1, 1));
        
    gl::drawSphere(Vec3f(300, 300, 10), 100);
        mShader.unbind();
  
}

CINDER_APP_BASIC( Aogp_Shader_BasicApp, RendererGl(0) )
