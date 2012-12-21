#version 120

uniform float timeValX = 1.0;
uniform float timeValY = 1.0;

//generate a random value from four points
vec4 rand(vec2 A,vec2 B,vec2 C,vec2 D){ 

	vec2 s=vec2(12.9898,78.233); 
	vec4 tmp=vec4(dot(A,s),dot(B,s),dot(C,s),dot(D,s)); 

	return fract(sin(tmp) * 43758.5453)* 2.0 - 1.0; 
} 

//this is similar to a perlin noise function
float noise(vec2 coord,float d){ 

	vec2 C[4]; 

	float d1 = 1.0/d;

	C[0]=floor(coord*d)*d1; 

	C[1]=C[0]+vec2(d1,0.0); 

	C[2]=C[0]+vec2(d1,d1); 

	C[3]=C[0]+vec2(0.0,d1);


	vec2 p=fract(coord*d); 

	vec2 q=1.0-p; 

	vec4 w=vec4(q.x*q.y,p.x*q.y,p.x*p.y,q.x*p.y); 

	return dot(vec4(rand(C[0],C[1],C[2],C[3])),w); 
} 


void main()
{    
    vec4 pos = gl_ProjectionMatrix * gl_ModelViewMatrix * gl_Vertex;
     //generate some noise values based on vertex position and the time value which comes in from our OF app
	float noiseAmntX = noise( vec2(-timeValX + pos.x / 1000.0, 100.0), 20.0 );
	float noiseAmntY = noise( vec2(timeValY + pos.y / 1000.0, pos.x / 2000.0), 20.0 );

	gl_FrontColor = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
	gl_Position = ftransform();

     //modify our position with the smooth noise
	pos.x += noiseAmntX * 20.0;
	pos.y += noiseAmntY * 10.0;

    gl_Position = pos;
}
