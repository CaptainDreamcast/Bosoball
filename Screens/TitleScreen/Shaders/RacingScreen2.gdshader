shader_type canvas_item;

void fragment(){
	vec2 uv = UV;
  
    uv *= 3.0;
    vec2 gv = fract(uv) - 0.5;
    vec3 col = vec3(gv.xy, 1.);

    float m = 0.;
    float t = TIME/2.;

    
    float dist = length(uv * 4.);
    for(int x = -2; x<=2;x++) {
        for(int y = -2; y<=2;y++) {
            vec2 offset = vec2(float(x), float(y)); 
            float d = length(gv-offset*0.7)*1.75;
            float tNorm = sin(dist-t) * .5 + 0.5;
            float r = mix(0.35, 1.8, tNorm);

            m += smoothstep(r*1.0001, r, d);
        }
    }
    
    col.x = mod(m/1., 1.1);
    col.y = mod(m/1.1, 1.3);
    col.z = mod(m/1.3, 1.4);

    COLOR = vec4(col,1.0);
}