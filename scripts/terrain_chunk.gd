extends Node3D

class_name TerrainChunk

@onready var chunk_size : int = GlblScrpt.chunk_size
@onready var terrain_section_size : float = float(GlblScrpt.terrain_section_size)
var chunk_height_verts = [
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
]
#Y then Z then X ????????????
var chunk_cube_verts = [
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	],
	[
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
		[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	]
]

var chunk_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var is_east_edge_chunk : bool = false
var is_south_edge_chunk : bool = false
var terrain_mat : ShaderMaterial
enum dirs {N, E, SE, S, W}
#is there a terrain section that contains a quad or a chunk to the North of this chunk?
var chunk_to_E_terr_sect_idx : int = -1
var chunk_to_SE_terr_sect_idx : int = -1
var chunk_to_S_terr_sect_idx : int = -1
#is there a quad that contains a chunk to the north of this chunk?
var chunk_to_E_quad = null
var chunk_to_SE_quad = null
var chunk_to_S_quad = null
#is there a chunk to the East, Southeast or South?
var chunk_to_E = null
var chunk_to_E_up = null
var chunk_to_SE = null
var chunk_to_SE_up = null
var chunk_to_S = null
var chunk_to_S_up = null
#resource files
var current_resource_file = null
var this_resource_filename = null
var resource_east_filename = null #does this need to be a global variable?
var resource_southeast_filename = null #does this need to be a global variable?
var resource_south_filename = null #does this need to be a global variable?

var terrain_section_index : int
var chunk_location_in_terrain_section : Vector2i


func init_chunk(_chunk_pos : Vector3, _is_east_edge_chunk : bool, _is_south_edge_chunk : bool, parent_quad_x : int, parent_quad_z : int):
	chunk_pos = _chunk_pos
	self.global_position = chunk_pos
	var chunk_x_in_section = fmod(chunk_pos.x, terrain_section_size)
	var chunk_z_in_section = fmod(chunk_pos.z, terrain_section_size)
	chunk_location_in_terrain_section = Vector2i(int(chunk_x_in_section), int(chunk_z_in_section))
	is_east_edge_chunk = _is_east_edge_chunk
	is_south_edge_chunk = _is_south_edge_chunk
	
		
	#get handles to the surrounding chunks, quads, and terrain sections, as required.
		
	#East
	var chunk_to_E_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z)
	chunk_to_E_terr_sect_idx = get_terr_section_index(chunk_to_E_pos)
	if chunk_to_E_terr_sect_idx != -1:
		chunk_to_E_quad = get_quad(chunk_to_E_pos, chunk_to_E_terr_sect_idx)
		if chunk_to_E_quad != null:
			if chunk_to_E_quad.check_has_voxels() == true:
				chunk_to_E = chunk_to_E_quad.get_chunk_at_position(chunk_to_E_pos)
				
	#East one level up
	var chunk_to_E_up_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y + float(chunk_size), chunk_pos.z)
	if chunk_to_E_quad != null:
		if chunk_to_E_quad.check_has_voxels() == true:
			chunk_to_E_up = chunk_to_E_quad.get_chunk_at_position(chunk_to_E_up_pos)
				
	#Southeast
	var chunk_to_SE_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z + float(chunk_size))
	chunk_to_SE_terr_sect_idx = get_terr_section_index(chunk_to_SE_pos)
	if chunk_to_SE_terr_sect_idx != -1:
		chunk_to_SE_quad = get_quad(chunk_to_SE_pos, chunk_to_SE_terr_sect_idx)
		if chunk_to_SE_quad != null:
			if chunk_to_SE_quad.check_has_voxels() == true:
				chunk_to_SE = chunk_to_SE_quad.get_chunk_at_position(chunk_to_SE_pos)
				
	#Southeast one level up
	var chunk_to_SE_up_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y + float(chunk_size), chunk_pos.z + float(chunk_size))
	if chunk_to_SE_quad != null:
		if chunk_to_SE_quad.check_has_voxels() == true:
			chunk_to_SE_up = chunk_to_SE_quad.get_chunk_at_position(chunk_to_SE_up_pos)
	
	#South
	var chunk_to_S_pos = Vector3(chunk_pos.x, chunk_pos.y, chunk_pos.z + float(chunk_size))
	chunk_to_S_terr_sect_idx = get_terr_section_index(chunk_to_S_pos)
	if chunk_to_S_terr_sect_idx != -1:
		chunk_to_S_quad = get_quad(chunk_to_S_pos, chunk_to_S_terr_sect_idx)
		if chunk_to_S_quad != null:
			if chunk_to_S_quad.check_has_voxels() == true:
				chunk_to_S = chunk_to_S_quad.get_chunk_at_position(chunk_to_S_pos)
				
	#South one level up
	var chunk_to_S_up_pos = Vector3(chunk_pos.x, chunk_pos.y + float(chunk_size), chunk_pos.z + float(chunk_size))
	if chunk_to_S_quad != null:
		if chunk_to_S_quad.check_has_voxels() == true:
			chunk_to_S_up = chunk_to_S_quad.get_chunk_at_position(chunk_to_S_up_pos)
			

	#calculate which terrain section the chunk is in
	#this allows the chunk to find the right resource file to access the heights data needed to
	#populate the chunk_cube_verts array
	this_resource_filename = get_section_resource_filename(chunk_pos)
	var path_to_section_data = "res://terrain/" + this_resource_filename + "/" + this_resource_filename + ".tres"
	current_resource_file = load(path_to_section_data)
	#TODO: assign the correct material to match this chunk's parent quad and terrain section
	#TODO: also allow for setting of a triplanar material for excavated areas
	#possibly a second shadermaterial in the section's resource file?
	terrain_mat = current_resource_file.section_mat
	#get the first 9x9 verts representing the heightmap heights for this chunk
	for height_z in range(0, chunk_size + 1):
		for height_x in range(0, chunk_size + 1):
			var height_offset_z : int = (chunk_location_in_terrain_section.y + height_z) * (terrain_section_size + 1)
			var height_offset_x : int = chunk_location_in_terrain_section.x + height_x
			chunk_height_verts[height_z][height_x] = current_resource_file.height_data[height_offset_z + height_offset_x]
		#insert placeholder heights in the last column in case there is no neighbouring chunk to the East 
		chunk_height_verts[height_z][chunk_size + 1] = chunk_height_verts[height_z][chunk_size]
	#insert placeholder heights in the last row in case there is no neighbouring chunk to the South
	for s_heights in range(0, chunk_size + 2):
		chunk_height_verts[chunk_size + 1][s_heights] = chunk_height_verts[chunk_size][s_heights]
		
	#insert placeholder heights in the last cell of the last column in case there is no neighbouring chunk to the Southeast
	#chunk_height_verts[chunk_size + 1][chunk_size + 1] = chunk_height_verts[chunk_size][chunk_size + 1]
	
	update_initial_chunk_heights()
	
	init_chunk_cube_verts()
			
		
		#path_to_section_data = "res://terrain/" + resource_east_filename + "/" + resource_east_filename + ".tres"
		#for height_east in range(0, chunk_size + 1):
			#var height_offset_z : int = (chunk_location_in_terrain_section.y + height_east) * (GlblScrpt.terrain_section_size + 1)
			#var height_offset_x : int = chunk_location_in_terrain_section.x + 1 # get the 1th column of heights in the neighbouring chunk to the East
			#chunk_height_verts[height_east][chunk_size + 1] = current_resource_file.height_data[height_offset_z + height_offset_x]
	
	
	
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
	#create_chunk_mesh()

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
	var terr_sect_x : int = floor(chunk_pos.x / terrain_section_size)
	if terr_sect_x > 9 or terr_sect_x < -9:
		x_string = "x" + str(terr_sect_x)
	elif terr_sect_x < 0 and terr_sect_x > -10:
		x_string = "x-0" + str(terr_sect_x)
	else:
		x_string = "x0" + str(terr_sect_x)
	var z_string : String = ""
	var terr_sect_z : int = floor(chunk_pos.z  / terrain_section_size)
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



#replace the placeholder values on the East, Southeast and South edges of the chunk_height_verts array
func update_initial_chunk_heights():
	var path_to_section_data : String = ""
	var resource_file = null
	#start with the heights to the East
	if chunk_to_E_terr_sect_idx != null:
		if resource_east_filename == null:
			resource_east_filename = get_section_resource_filename(Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z))
		path_to_section_data = "res://terrain/" + resource_east_filename + "/" + resource_east_filename + ".tres"
		resource_file = load(path_to_section_data)
		if resource_file != null:
			var chunk_to_E_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z)
			for e_height in range(0, chunk_size + 1):
				var height_z : int = int(fmod(chunk_to_E_pos.z + float(e_height), terrain_section_size) * (terrain_section_size + 1.0))
				var height_x : int = 1
				chunk_height_verts[e_height][chunk_size + 1] = resource_file.height_data[height_z + height_x]
			resource_file = null
			
	#heights to the Southeast
	if chunk_to_SE_terr_sect_idx != null:
		if resource_southeast_filename == null:
			resource_southeast_filename = get_section_resource_filename(Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z + float(chunk_size)))	
		path_to_section_data = "res://terrain/" + resource_southeast_filename + "/" + resource_southeast_filename + ".tres"
		resource_file = load(path_to_section_data)
		if resource_file != null:
			var chunk_to_SE_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z + float(chunk_size))
			var height_z : int = int(fmod(chunk_to_SE_pos.z + 1.0, terrain_section_size) * (terrain_section_size + 1.0))
			var height_x : int = 1
			chunk_height_verts[chunk_size + 1][chunk_size + 1] = resource_file.height_data[height_z + height_x]
		resource_file = null
	
	#heights to the South
	if chunk_to_S_terr_sect_idx != null:
		if resource_south_filename == null:
			resource_south_filename = get_section_resource_filename(Vector3(chunk_pos.x, chunk_pos.y, chunk_pos.z + float(chunk_size)))	
		path_to_section_data = "res://terrain/" + resource_south_filename + "/" + resource_south_filename + ".tres"
		resource_file = load(path_to_section_data)
		if resource_file != null:
			var chunk_to_S_pos = Vector3(chunk_pos.x, chunk_pos.y, chunk_pos.z  + float(chunk_size))
			var height_z : int = int(fmod(chunk_to_S_pos.z + 1.0, terrain_section_size) * (terrain_section_size + 1.0))
			for s_height in range(0, chunk_size + 1):
				chunk_height_verts[chunk_size + 1][s_height] = resource_file.height_data[height_z + s_height]
		resource_file = null
		
#assign a "0" or a "1" to each vertex of each voxel cube, depending on whether it is in the air or in the ground
func init_chunk_cube_verts():
	for cube_y in range(0, chunk_cube_verts.size()):
		for cube_z in range(0, chunk_cube_verts.size()):
			for cube_x in range(0, chunk_cube_verts.size()):
				if chunk_pos.y + float(cube_y) > chunk_height_verts[cube_z][cube_x]:
					chunk_cube_verts[cube_y][cube_z][cube_x] = 0
				else:
					chunk_cube_verts[cube_y][cube_z][cube_x] = 1

				
