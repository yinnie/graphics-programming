uniform float size;

//generate a random value
float rand(vec2 A){
                                                          
vec2 s=vec2(12.9898,78.233);
float tmp=dot(A,s);
                                                          
return fract(sin(tmp) * 43758.5453)* 3.0;
}

vec3 mesh (vec2 A) {
  float z = rand (A); 
  vec3 pos = vec3 ( A.x * size, A.y * size, z);
 return pos;
}

void main()
{
	gl_FrontColor = gl_Color;
	gl_TexCoord[0] = gl_MultiTexCoord0;
    
      vec2 curUV = gl_TexCoord[0].xy;
     vec3 pos = mesh ( curUV);
     
     //offset values 
     //neighbour vertices
     vec2 offset[8];
    offset[0] = vec2(  -size,  -size);
   offset[1] = vec2(  0.0,  -size);
   offset[2] = vec2(  size,  -size);
   offset[3] = vec2(  -size,  0.0);
   offset[4] = vec2(  size,  0.0);
   offset[5] = vec2(  -size,  size);
   offset[6] = vec2(  0.0,  size);
   offset[7] = vec2(  size,  size);
   

// Determine the number of active neighbors:
int sum = 0;
for(int i = 0; i < 8; i++) {
if( mesh(curUV + offset[i]).z > 0.5 ) { sum++; }
}

float curZ = mesh ( curUV).z;                                                     
// Determine z value based on the GOL rules:
float outVal = 0.0;
if     ( ( curZ >= 0.0 ) && (sum == 2 || sum == 3) ) { outVal = 1.0; }
else if( ( curZ <  0.0 ) && (sum == 3) )             { outVal = 1.0; }

	gl_Position = vec4 ( outVal, outVal, outVal, 1.0);
}


