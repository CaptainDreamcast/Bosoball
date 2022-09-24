shader_type canvas_item;

uniform float speed;

void fragment(){
  	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	vec2 ndc = (FRAGCOORD.xy + vec2(0, -50) - resolution.xy / 2.0) / min(resolution.x, resolution.y);
    vec3 lens = normalize(vec3(ndc, 0.05));
	vec3 location = lens * 15.0 + vec3(0.0, 0.0, TIME * speed);
	vec3 cellId = floor(location);
	vec3 relativeToCell = fract(location);
    vec3 locationOfStarInCell = fract(cross(cellId, vec3(2.154, -6.21, 0.42))) * 0.5 + 0.25;
	float star = max(0.0, 10.0 * (0.1 - distance(relativeToCell, locationOfStarInCell)));
	COLOR = vec4(star * 256.0, star * 256.0, star * 256.0, 1.0);
}