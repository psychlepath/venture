// NOTE: Shader automatically converted from Godot Engine 4.2.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D splatmap : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D tex00 : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D tex01 : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D tex02 : source_color,filter_linear_mipmap,repeat_enable;
uniform sampler2D tex03 : source_color,filter_linear_mipmap,repeat_enable;
uniform float point_size : hint_range(0,128);
uniform float roughness : hint_range(0,1);
//uniform sampler2D tex00_m : hint_default_white,filter_linear_mipmap,repeat_enable;
uniform float tex00_r : hint_range(0,1);
uniform float tex01_r : hint_range(0,1);
uniform float tex02_r : hint_range(0,1);
uniform float tex03_r : hint_range(0,1);
uniform float specular;
uniform sampler2D tex00_n : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform sampler2D tex01_n : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform sampler2D tex02_n : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform sampler2D tex03_n : hint_roughness_normal,filter_linear_mipmap,repeat_enable;
uniform float normal_scale : hint_range(-16,16);
varying vec3 tex00_uv1_triplanar_pos;
varying vec3 tex01_uv1_triplanar_pos;
varying vec3 tex02_uv1_triplanar_pos;
varying vec3 tex03_uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 tex00_uv1_scale;
uniform vec3 tex01_uv1_scale;
uniform vec3 tex02_uv1_scale;
uniform vec3 tex03_uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

void vertex() {
	vec3 normal = MODEL_NORMAL_MATRIX * NORMAL;
	TANGENT = vec3(0.0,0.0,-1.0) * abs(normal.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(normal.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(normal.z);
	TANGENT = inverse(MODEL_NORMAL_MATRIX) * normalize(TANGENT);
	BINORMAL = vec3(0.0,1.0,0.0) * abs(normal.x);
	BINORMAL+= vec3(0.0,0.0,-1.0) * abs(normal.y);
	BINORMAL+= vec3(0.0,1.0,0.0) * abs(normal.z);
	BINORMAL = inverse(MODEL_NORMAL_MATRIX) * normalize(BINORMAL);
	uv1_power_normal=pow(abs(normal),vec3(uv1_blend_sharpness));
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	tex00_uv1_triplanar_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0f)).xyz * tex00_uv1_scale + uv1_offset;
	tex00_uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
	tex01_uv1_triplanar_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0f)).xyz * tex01_uv1_scale + uv1_offset;
	tex01_uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
	tex02_uv1_triplanar_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0f)).xyz * tex02_uv1_scale + uv1_offset;
	tex02_uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
	tex03_uv1_triplanar_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0f)).xyz * tex03_uv1_scale + uv1_offset;
	tex03_uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
}

vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	samp+= texture(p_sampler,p_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,p_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,p_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

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
	
	vec4 tex00_tex = triplanar_texture(tex00,uv1_power_normal,tex00_uv1_triplanar_pos);
	vec4 tex01_tex = triplanar_texture(tex01,uv1_power_normal,tex01_uv1_triplanar_pos);
	vec4 tex02_tex = triplanar_texture(tex02,uv1_power_normal,tex02_uv1_triplanar_pos);
	vec4 tex03_tex = triplanar_texture(tex03,uv1_power_normal,tex03_uv1_triplanar_pos);
	//vec3 tex00_col = texture(tex00, UV * tex00_resolution).rgb * tex00_weight;
	vec3 tex00_col = tex00_tex.rgb * tex00_weight;
	vec3 tex01_col = tex01_tex.rgb * tex01_weight;
	vec3 tex02_col = tex02_tex.rgb * tex02_weight;
	vec3 tex03_col = tex03_tex.rgb * tex03_weight;
	//ALBEDO = albedo.rgb * soil_tex.rgb;
	ALBEDO = albedo.rgb * (tex00_col.rgb + tex01_col.rgb + tex02_col.rgb + tex03_col.rgb);
	METALLIC = 0.0;
	ROUGHNESS = ((tex00_r * tex00_weight) + (tex01_r * tex01_weight) + (tex02_r * tex02_weight) + (tex03_r * tex03_weight)) * roughness;
	SPECULAR = specular;
	vec3 tex00_nor = triplanar_texture(tex00_n,uv1_power_normal,tex00_uv1_triplanar_pos).rgb * tex00_weight;
	vec3 tex01_nor = triplanar_texture(tex01_n,uv1_power_normal,tex01_uv1_triplanar_pos).rgb * tex01_weight;
	vec3 tex02_nor = triplanar_texture(tex02_n,uv1_power_normal,tex02_uv1_triplanar_pos).rgb * tex02_weight;
	vec3 tex03_nor = triplanar_texture(tex03_n,uv1_power_normal,tex03_uv1_triplanar_pos).rgb * tex03_weight;
	//NORMAL_MAP = triplanar_texture(tex00_n,uv1_power_normal,uv1_triplanar_pos).rgb;
	NORMAL_MAP = tex00_nor.rgb + tex01_nor.rgb + tex02_nor.rgb + tex03_nor.rgb;
	NORMAL_MAP_DEPTH = normal_scale;
}
