shader_type spatial;

uniform sampler2D label_tex : source_color,filter_linear_mipmap,repeat_enable;

void vertex() {
	vec3 dir = CAMERA_POSITION_WORLD - NODE_POSITION_WORLD;
	dir.y = 0.;
	dir = normalize(dir);
	mat3 bt = mat3(cross(vec3(0.0,1.0,0.0), dir), vec3(0.0,1.0,0.0), dir);
	VERTEX = bt * VERTEX;
	NORMAL = dir;
}


