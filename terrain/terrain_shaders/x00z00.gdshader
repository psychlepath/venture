shader_type spatial;

uniform sampler2D splatmap;
uniform sampler2D tex00;
uniform sampler2D tex01;
uniform sampler2D tex02;
uniform sampler2D tex03;

uniform float tex00_resolution = 1.0;
uniform float tex01_resolution = 1.0;
uniform float tex02_resolution = 1.0;
uniform float tex03_resolution = 1.0;

void fragment() {
	vec4 v_splat_colour = texture(splatmap,UV).rgba;
	float tex00_weight = clamp(1.0 - (v_splat_colour.r + v_splat_colour.g + v_splat_colour.b), 0.0, 1.0);
	float tex01_weight = v_splat_colour.r;
	float tex02_weight = v_splat_colour.g;
	float tex03_weight = v_splat_colour.b;
	
	float total_weight = tex00_weight + tex01_weight + tex02_weight + tex03_weight;
	tex00_weight /= total_weight;
	tex01_weight /= total_weight;
	tex02_weight /= total_weight;
	tex03_weight /= total_weight;
	
	vec3 tex00_col = texture(tex00, UV * tex00_resolution).rgb * tex00_weight;
	vec3 tex01_col = texture(tex01, UV * tex01_resolution).rgb * tex01_weight;
	vec3 tex02_col = texture(tex02, UV * tex02_resolution).rgb * tex02_weight;
	vec3 tex03_col = texture(tex03, UV * tex03_resolution).rgb * tex03_weight;
	
	ALBEDO = tex00_col + tex01_col + tex02_col + tex03_col;//rgb value
	
}