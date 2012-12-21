const float frequency = 2.3;
uniform vec3 Color0;
uniform vec3 Color1;
uniform float time;
                                                  
varying float V;
                                                  
                                                  
    void main()
    {    
    float fre = frequency * mod(time, 1.0) * 10.0;
    float sawtooth = fract (V * fre);
    float triangle = abs(2.0 * sawtooth - 1.0);
    float dp = length ( vec2(dFdx(V), dFdy(V)));
    float edge = dp * frequency * 2.0;
    float square = smoothstep(0.8 - edge, 0.3 + edge, triangle);
    vec3 color = mix(Color0, Color1, square);
    
    gl_FragColor = vec4( color, 1.0 );
    
   }

