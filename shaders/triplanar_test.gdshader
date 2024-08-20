shader_type spatial;

//render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

// Magic that puts VERTEX/NORMAL in world coordinates instead of local
//render_mode world_vertex_coords;

const float color_mult = 1.0f;
uniform sampler2D grid_texture: hint_default_white;
uniform sampler2D grid_normal;
uniform float brightness: hint_range(0.0f, 1.0f) = 1.0f;

vec3 random(vec3 coord)
{
	vec3 res;
	res.x = fract(sin(dot(coord.yz, vec2(12.9898,78.233))) * 43758.5453123);
	res.y = fract(sin(dot(coord.xz, vec2(16.6539,68.698))) * 69845.5962848);
	res.z = fract(sin(dot(coord.xy, vec2(25.5263,41.256))) * 42538.6985436);
	return res;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 projected_coords = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec3 albedoX = texture(grid_texture, projected_coords.zy).rgb;
	vec3 albedoY = texture(grid_texture, projected_coords.xz).rgb;
	vec3 albedoZ = texture(grid_texture, projected_coords.xy).rgb;
	vec3 world_normal = abs(INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	vec3 normal_weights = world_normal / (world_normal.x + world_normal.y + world_normal.z);
	
	vec3 color_offset = random(floor(projected_coords.xyz));
	
	ALBEDO = mix(vec3(0.0f), mix((albedoX * normal_weights.x + albedoY * normal_weights.y + albedoZ * normal_weights.z), color_offset.rgb, 0.05f), brightness);
}

