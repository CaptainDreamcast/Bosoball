shader_type canvas_item;

const float PI = 3.141592653;

float lenny(vec2 v)
{
  return abs(v.x)+abs(v.y);
}
float sat(float a)
{
  return clamp(a,0.,1.);
}

vec3 rdr(vec2 uv, float iTime, sampler2D iChannel0)
{
  vec3 col;
  float t = iTime*.1+uv.x*2.*sin(iTime)+uv.y*4.*sin(iTime);
  float tt = iTime;//*(1.+.05*sin(iTime*.2));
  float blur = 2.*mix(0.01,0.001,sin(iTime*.2)*.5+.5);
  float l = pow(length(uv),.1)*1.;
  uv += vec2(sin(t+l),cos(t+l))*.2*pow(length(uv),.5);
  col = texture(iChannel0, vec2(0.1*atan(uv.y, uv.x)/PI, .05*tt+blur/length(uv))).xyz;
vec3 col2 = texture(iChannel0, -vec2(.2*atan(uv.y, uv.x)/PI, .05*tt+.001/length(uv))).xyz;

  return vec3(.9,.12,.38)*col2*.8+.1*col*pow(length(uv),.5)*vec3(.5,.3,.7)*max(dot(uv, vec2(1.)),.5)
  + 3.5*pow(1.-sat(lenny(uv*.5)),5.)*vec3(.32,.45,.65);
}

void fragment(){
 vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
  vec2 uv = FRAGCOORD.xy / resolution.xx;
uv -= vec2(.5)*resolution.xy/resolution.xx;
    uv += vec2(sin(TIME)*.1, cos(TIME*.2)*.1);
uv*=1.5;
vec3 col = rdr(uv, TIME, TEXTURE);
col = mix(col, col.xzy,sin(5.*length(uv)+TIME*2.)*1.);
    col *= pow(sat(1.-lenny(uv*.05)), 20.);

	  col = pow(col, vec3(1./1.2));
      COLOR = vec4(col, 1.0);
}