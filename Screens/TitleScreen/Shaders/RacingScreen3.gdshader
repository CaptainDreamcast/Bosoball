shader_type canvas_item;

void fragment(){
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 uv = ( FRAGCOORD.xy - .5*resolution.xy) /resolution.y;
	float aspect = resolution.x/resolution.y;
    float betrag = length(vec2(uv.x,uv.y));
    float winkel = atan(uv.x,uv.y);
    float r = abs(sin((TIME*0.25+winkel)*10.+cos((betrag+TIME)*5.)*2.));
    float g = sin(winkel*10.+cos((betrag-TIME)*5.)*2.);
    float b = abs(sin((r*3.14)/(1.5+sin(TIME))));
    

    // Output to screen
    COLOR = vec4(0.7*r,g,1.2*b,1.0);
}