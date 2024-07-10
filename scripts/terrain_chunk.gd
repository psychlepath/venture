extends Node3D

class_name TerrainChunk

@onready var chunk_size : int = GlblScrpt.chunk_size
var chunk_height_verts = [
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
#Y then Z then X ????????????
var chunk_cube_verts_Y0 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y1 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y2 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y3 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y4 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y5 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y6 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y7 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y8 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_cube_verts_Y9 = [	
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]],
	[[0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0], [0.0]]
]
var chunk_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var is_north_edge_chunk : bool = false
var is_east_edge_chunk : bool = false
var is_south_edge_chunk : bool = false
var is_west_edge_chunk : bool = false
var terrain_mat : ShaderMaterial
enum dirs {N, E, SE, S, W}
#is there a terrain section that contains a quad or a chunk to the North of this chunk?
var chunk_to_N_terr_sect_idx : int = -1
var chunk_to_E_terr_sect_idx : int = -1
var chunk_to_SE_terr_sect_idx : int = -1
var chunk_to_S_terr_sect_idx : int = -1
var chunk_to_W_terr_sect_idx : int = -1
#is there a quad that contains a chunk to the north of this chunk?
var chunk_to_N_quad = null
var chunk_to_E_quad = null
var chunk_to_SE_quad = null
var chunk_to_S_quad = null
var chunk_to_W_quad = null
#is there a chunk to the north?
var chunk_to_N = null
var chunk_to_E = null
var chunk_to_E_up = null
var chunk_to_SE = null
var chunk_to_SE_up = null
var chunk_to_S = null
var chunk_to_S_up = null
var chunk_to_W = null
#resource files
var parent_resource_file
var resource_file_east = null
var resource_file_southeast = null
var resource_file_south = null

var terrain_section_index : int
var chunk_location_in_terrain_section : Vector2i


func init_chunk(_chunk_pos : Vector3, _is_north_edge_chunk : bool, _is_east_edge_chunk : bool, _is_south_edge_chunk : bool, _is_west_edge_chunk : bool, parent_quad_x : int, parent_quad_z : int):
	chunk_pos = _chunk_pos
	self.global_position = chunk_pos
	var chunk_x_in_section = fmod(chunk_pos.x, float(GlblScrpt.terrain_section_size))
	var chunk_z_in_section = fmod(chunk_pos.z, float(GlblScrpt.terrain_section_size))
	chunk_location_in_terrain_section = Vector2i(int(chunk_x_in_section), int(chunk_z_in_section))
	is_north_edge_chunk = _is_north_edge_chunk
	is_east_edge_chunk = _is_east_edge_chunk
	is_south_edge_chunk = _is_south_edge_chunk
	is_west_edge_chunk = _is_west_edge_chunk
	#calculate which terrain section the chunk is in
	#this allows the chunk to find the right resource file to access the heights data needed to
	#populate the chunk_cube_verts array
	var resource_filename = get_section_resource_filename(chunk_pos)
	var path_to_section_data = "res://terrain/" + resource_filename + "/" + resource_filename + ".tres"
	parent_resource_file = load(path_to_section_data)
	#TODO: assign the correct material to match this chunk's parent quad and terrain section
	#TODO: also allow for setting of a triplanar material for excavated areas
	#possibly a second shadermaterial in the section's resource file?
	terrain_mat = parent_resource_file.section_mat
	#get handles to the surrounding chunks, quads, and terrain sections, as required.
	#North
	var chunk_to_N_pos = Vector3(chunk_pos.x, chunk_pos.y, chunk_pos.z - float(GlblScrpt.chunk_size))
	chunk_to_N_terr_sect_idx = get_terr_section_index(chunk_to_N_pos)
	if chunk_to_N_terr_sect_idx != -1:
		chunk_to_N_quad = get_quad(chunk_to_N_pos, chunk_to_N_terr_sect_idx)
		if chunk_to_N_quad != null:
			if chunk_to_N_quad.check_has_voxels() == true:
				chunk_to_N = chunk_to_N_quad.get_chunk_at_position(chunk_to_N_pos)
	
	#East
	var chunk_to_E_pos = Vector3(chunk_pos.x + float(GlblScrpt.chunk_size), chunk_pos.y, chunk_pos.z)
	chunk_to_E_terr_sect_idx = get_terr_section_index(chunk_to_E_pos)
	if chunk_to_E_terr_sect_idx != -1:
		chunk_to_E_quad = get_quad(chunk_to_E_pos, chunk_to_E_terr_sect_idx)
		if chunk_to_E_quad != null:
			if chunk_to_E_quad.check_has_voxels() == true:
				chunk_to_E = chunk_to_E_quad.get_chunk_at_position(chunk_to_E_pos)
				
	#East one level up
	var chunk_to_E_up_pos = Vector3(chunk_pos.x + float(GlblScrpt.chunk_size), chunk_pos.y + float(GlblScrpt.chunk_size), chunk_pos.z)
	if chunk_to_E_quad != null:
		if chunk_to_E_quad.check_has_voxels() == true:
			chunk_to_E_up = chunk_to_E_quad.get_chunk_at_position(chunk_to_E_up_pos)
				
	#Southeast
	var chunk_to_SE_pos = Vector3(chunk_pos.x + float(GlblScrpt.chunk_size), chunk_pos.y, chunk_pos.z + float(GlblScrpt.chunk_size))
	chunk_to_SE_terr_sect_idx = get_terr_section_index(chunk_to_SE_pos)
	if chunk_to_SE_terr_sect_idx != -1:
		chunk_to_SE_quad = get_quad(chunk_to_SE_pos, chunk_to_SE_terr_sect_idx)
		if chunk_to_SE_quad != null:
			if chunk_to_SE_quad.check_has_voxels() == true:
				chunk_to_SE = chunk_to_SE_quad.get_chunk_at_position(chunk_to_SE_pos)
				
	#Southeast one level up
	var chunk_to_SE_up_pos = Vector3(chunk_pos.x + float(GlblScrpt.chunk_size), chunk_pos.y + float(GlblScrpt.chunk_size), chunk_pos.z + float(GlblScrpt.chunk_size))
	if chunk_to_SE_quad != null:
		if chunk_to_SE_quad.check_has_voxels() == true:
			chunk_to_SE_up = chunk_to_SE_quad.get_chunk_at_position(chunk_to_SE_up_pos)
	
	#South
	var chunk_to_S_pos = Vector3(chunk_pos.x, chunk_pos.y, chunk_pos.z + float(GlblScrpt.chunk_size))
	chunk_to_S_terr_sect_idx = get_terr_section_index(chunk_to_S_pos)
	if chunk_to_S_terr_sect_idx != -1:
		chunk_to_S_quad = get_quad(chunk_to_S_pos, chunk_to_S_terr_sect_idx)
		if chunk_to_S_quad != null:
			if chunk_to_S_quad.check_has_voxels() == true:
				chunk_to_S = chunk_to_S_quad.get_chunk_at_position(chunk_to_S_pos)
				
	#South one level up
	var chunk_to_S_up_pos = Vector3(chunk_pos.x, chunk_pos.y + float(GlblScrpt.chunk_size), chunk_pos.z + float(GlblScrpt.chunk_size))
	if chunk_to_S_quad != null:
		if chunk_to_S_quad.check_has_voxels() == true:
			chunk_to_S_up = chunk_to_S_quad.get_chunk_at_position(chunk_to_S_up_pos)
			
	#West
	var chunk_to_W_pos = Vector3(chunk_pos.x - float(GlblScrpt.chunk_size), chunk_pos.y, chunk_pos.z)
	chunk_to_W_terr_sect_idx = get_terr_section_index(chunk_to_W_pos)
	if chunk_to_W_terr_sect_idx != -1:
		chunk_to_W_quad = get_quad(chunk_to_W_pos, chunk_to_W_terr_sect_idx)
		if chunk_to_W_quad != null:
			if chunk_to_W_quad.check_has_voxels() == true:
				chunk_to_W = chunk_to_S_quad.get_chunk_at_position(chunk_to_W_pos)
	
	#get the verts representing the heightmap heights for this chunk
	for vert_z in range(0, chunk_height_verts.size()):
		for vert_x in range(0, chunk_height_verts.size()):
			var vert_offset_z : int = (chunk_location_in_terrain_section.y + vert_z) * (GlblScrpt.terrain_section_size + 1)
			var vert_offset_x : int = chunk_location_in_terrain_section.x + vert_x
			chunk_height_verts[vert_z][vert_x] = parent_resource_file.height_data[vert_offset_z + vert_offset_x]
	
	
	
	
	
	
	
	
	#fill the vertical slices of the arrays representing the corners of the voxel cubes
		
		
		#check whether the quad to the East has chunks
		#quad_to_east = self.get_parent().get_child(parent_quad_x + 1)
		#if quad_to_east.check_has_voxels() == true:
			##find the neighbouring voxel chunk to the East and also East up
			#chunk_to_east = quad_to_east
			
		
		
		
		
		
		#find the terrain section index in the terrrain_manager's terrain_section_centres array from the chunk's global position
		#terrain_section_index = get_terr_section_index(chunk_pos)
	
	
	#for cube_y in range(0, chunk_array.size()):
		#for cube_z in range(0, chunk_array.size()):
			#for cube_x in range(0, chunk_array.size()):
				#var z_in_chunk_surf_verts = cube_z * (chunk_array.size() + 1)
				#if bottom_of_chunk + cube_y <= chunk_surface_verts[z_in_chunk_surf_verts + cube_x].y:
					#chunk_array[cube_y][cube_z][cube_x] = 1.0
	create_chunk_mesh()

func handle_excavation(excavator_pos : Vector3, excavator_size : float) -> void:
	#TODO: allow for different shapes...
	#calculate the effect on the chunk_cube_verts array of the excavator's shape
	if chunk_cube_verts != null:
		for chunk_y in range(0, chunk_cube_verts.size()):
			for chunk_z in range(0, chunk_cube_verts.size()):
				for chunk_x in range(0, chunk_cube_verts.size()):
					#is this cube vertex inside the excavator shape?
					var vertex_global_pos = Vector3(self.global_position.x + float(chunk_x), self.global_position.y + float(chunk_y), self.global_position.z + float(chunk_z))
					if vertex_global_pos.distance_squared_to(excavator_pos) < excavator_size * excavator_size:
						chunk_cube_verts[chunk_y][chunk_z][chunk_x] = 1.0
	create_chunk_mesh()

func create_chunk_mesh():
	
	pass
	
	#var x_string = ""
	#if x_pos > 9 or x_pos < -9:
		#x_string = "x" + str(x_pos)
	#elif x_pos < 0 and x_pos > -10:
		#x_string = "x-0" + str(x_pos)
	#else:
		#x_string = "x0" + str(x_pos)
	#var z_string = ""
	#if z_pos > 9 or z_pos < -9:
		#z_string = "z" + str(z_pos)
	#elif z_pos < 0 and z_pos > -10:
		#z_string = "z-0" + str(z_pos)
	#else:
		#z_string = "z0" + str(z_pos)
	#GlblScrpt.add_terrain_section_position(x_string + z_string)

#calculate the filename of the resource containing the terrain section's height data etc.
func get_section_resource_filename(_chunk_pos : Vector3) -> String:
	var x_string : String = ""
	var terr_sect_x : int = floor(chunk_pos.x / float(GlblScrpt.terrain_section_size))
	if terr_sect_x > 9 or terr_sect_x < -9:
		x_string = "x" + str(terr_sect_x)
	elif terr_sect_x < 0 and terr_sect_x > -10:
		x_string = "x-0" + str(terr_sect_x)
	else:
		x_string = "x0" + str(terr_sect_x)
	var z_string : String = ""
	var terr_sect_z : int = floor(chunk_pos.z  / float(GlblScrpt.terrain_section_size))
	if terr_sect_z > 9 or terr_sect_z < -9:
		z_string = "z" + str(terr_sect_z)
	elif terr_sect_z < 0 and terr_sect_z > -10:
		z_string = "z-0" + str(terr_sect_z)
	else:
		z_string = "z0" + str(terr_sect_z)
	return x_string + z_string

func get_terr_section_index(_chunk_pos : Vector3) -> int:
	var current_index = -1
	var terr_section_x = floor(_chunk_pos.x / float(GlblScrpt.terrain_section_size))
	var terr_section_centre_x = terr_section_x + (float(GlblScrpt.terrain_section_size) / 2.0)
	var terr_section_z = floor(_chunk_pos.z / float(GlblScrpt.terrain_section_size))
	var terr_section_centre_z = terr_section_z + (float(GlblScrpt.terrain_section_size) / 2.0)
	if GlblScrpt.terrain_manager:
		return GlblScrpt.terrain_manager.get_terrain_section_index(Vector2(terr_section_centre_x, terr_section_centre_z))
	return current_index
	
func get_quad(_chunk_pos, _terr_sect_idx):
	var current_quad = null
	var quad_z : int = floor(fmod(_chunk_pos.z, float(GlblScrpt.terrain_section_size)) / float(GlblScrpt.quad_size))
	var quad_x : int = floor(fmod(_chunk_pos.x, float(GlblScrpt.terrain_section_size)) / float(GlblScrpt.quad_size))
	if GlblScrpt.terrain_manager:
		current_quad = GlblScrpt.terrain_manager.get_child(_terr_sect_idx).terrain.get_child(quad_z).get_child(quad_x)
	return current_quad



#return an array containing a slice of cube verts on the YZ axis, one slice in along the X axis
func get_western_verts():
	var west_array0 = []
	
	
func get_western_down_verts():
	pass

func get_northern_verts():
	pass
	
func get_northern_down_verts():
	pass
	
func get_northwestern_verts():
	pass
	
func get_northwestern_down_verts():
	pass
