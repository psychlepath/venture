@tool
extends Node3D
class_name TerrainQuad32

@onready var mesh_inst : MeshInstance3D = $MeshInstance3D
@onready var coll_shape = $StaticBody3D/CollisionShape3D
@onready var quad_size : int = GlblScrpt.tile_size
@onready var section_size : int = GlblScrpt.terrain_section_size
@onready var quad_strip_length : int = section_size / quad_size
@onready var this_quad_x_pos : int = 0
@onready var this_quad_z_pos : int = 0
var a_mesh : ArrayMesh
var coll_shape_shape : ConcavePolygonShape3D
var path_to_section_data = ""
var resource_file
var quad_x : int = 0
var strip_z : int = 0
# the z location of the top left corner of this quad inside the 513x513 parent
var starting_z : int = 0
# the x location of the top left corner of this quad inside the 513x513 parent
var starting_x : int = 0
var max_LOD_dist : int = 10
# each 32x32 quad has a LOD and a direction
# the distance of each quad to the quad in which the player is located
enum LODs {LOD0, LOD1, LOD2, LOD3, LOD4, LOD5}
# LOD0 = 1x1 metres
# LOD1 = 2x2
# LOD2 = 4x4
# LOD3 = 8x8
# LOD4 = 16x16
# LOD5 = 32x32 - this might not be practical with faraway excavations...

# the direction from the player to each quad
enum dirs {no_dir, N, NE, E, SE, S, SW, W, NW}
# none : 0
# N: 1
# NE: 2 
# E: 3 
# SE: 4 
# S: 5
# SW: 6 
# W: 7 
# NW: 8
# these two pieces of information will determine which
# vertices will be added to the VERTICES array to create this quad's mesh
var current_dir : int = -1
var current_lod : int = -1

func init_quad(_section_data_path, _quad_x : int, _strip_z : int, _max_LOD_dist : int):
	this_quad_x_pos = floor(self.global_position.x / float(quad_size))
	this_quad_z_pos = floor(self.global_position.z / float(quad_size))
	quad_x = _quad_x
	strip_z = _strip_z
	max_LOD_dist = _max_LOD_dist
	# the z location of the top left corner of this quad inside the 513x513 parent
	starting_z = strip_z * quad_size * (section_size + 1)
	# the x location of the top left corner of this quad inside the 513x513 parent
	starting_x = quad_x * quad_size
	#create the mesh and the collisionshape at init 
	#to avoid having to make each one unique in the editor
	a_mesh = ArrayMesh.new()
	coll_shape_shape = ConcavePolygonShape3D.new()
	coll_shape.shape = coll_shape_shape
	path_to_section_data = _section_data_path
	
	if path_to_section_data != "":
		resource_file = load(path_to_section_data)

#func set_dir_and_LOD(dir_and_lod : Vector2i):
	#if current_dir != dir_and_lod.x or current_lod != dir_and_lod.y:
		#create_quad_mesh(dir_and_lod)

func check_dir_and_LOD(player_quad_pos: Vector2i):
	var new_dir = null
	var new_lod = null
	var dist_x_from_player_quad : int = abs(player_quad_pos.x - this_quad_x_pos) 
	#if dist_x_from_player_quad < max_LOD_dist: #already checked by terrain section
	var dist_z_from_player_quad : int = abs(player_quad_pos.y - this_quad_z_pos)
	#new_lod = abs(dist_z_from_player_quad) / 2
	#this quad is further to the East or West than it is North or South of the player
	var lod_sorted : bool = false
	if dist_z_from_player_quad < dist_x_from_player_quad:
		match dist_x_from_player_quad:
			0:
				new_lod = LODs.LOD0
				new_dir = dirs.no_dir
				
			1: 
				new_lod = LODs.LOD0
				#default assumption is that the quad is to the West of the player
				new_dir = dirs.W
				if this_quad_x_pos > player_quad_pos.x:
					#quad is to the East of the player
					new_dir = dirs.E
				
			2:
				new_lod = LODs.LOD1
				new_dir = dirs.no_dir
				
				#default assumption is that the quad is to the West of the player
				#new_dir = dirs.W
				#if this_quad_x_pos > player_quad_pos.x:
					##quad is to the East of the player
					#new_dir = dirs.E
			3:
				new_lod = LODs.LOD1
				#default assumption is that the quad is to the West of the player
				new_dir = dirs.W
				if this_quad_x_pos > player_quad_pos.x:
					#quad is to the East of the player
					new_dir = dirs.E
			4:
				new_lod = LODs.LOD2
				new_dir = dirs.no_dir
				#default assumption is that the quad is to the West of the player
				#new_dir = dirs.W
				#if this_quad_x_pos > player_quad_pos.x:
					##quad is to the East of the player
					#new_dir = dirs.E
			5:
				new_lod = LODs.LOD2
				#default assumption is that the quad is to the West of the player
				new_dir = dirs.W
				if this_quad_x_pos > player_quad_pos.x:
					#quad is to the East of the player
					new_dir = dirs.E
			6:
				new_lod = LODs.LOD3
				new_dir = dirs.no_dir
				#default assumption is that the quad is to the West of the player
				#new_dir = dirs.W
				#if this_quad_x_pos > player_quad_pos.x:
					##quad is to the East of the player
					#new_dir = dirs.E
			7:
				new_lod = LODs.LOD3
				#default assumption is that the quad is to the West of the player
				new_dir = dirs.W
				if this_quad_x_pos > player_quad_pos.x:
					#quad is to the East of the player
					new_dir = dirs.E
			8:
				new_lod = LODs.LOD4
				new_dir = dirs.no_dir
				#default assumption is that the quad is to the West of the player
				#new_dir = dirs.W
				#if this_quad_x_pos > player_quad_pos.x:
					##quad is to the East of the player
					#new_dir = dirs.E
			9:
				new_lod = LODs.LOD4
				#default assumption is that the quad is to the West of the player
				new_dir = dirs.W
				if this_quad_x_pos > player_quad_pos.x:
					#quad is to the East of the player
					new_dir = dirs.E
			_:
				new_lod = LODs.LOD5
				new_dir = dirs.no_dir

	#this quad is further to the North or South than it is East or West of the player
	if dist_z_from_player_quad > dist_x_from_player_quad:
		
		match dist_z_from_player_quad:
			0:
				new_lod = LODs.LOD0
				new_dir = dirs.no_dir
			1: 
				new_lod = LODs.LOD0
				#default assumption is that the quad is to the North of the player
				new_dir = dirs.N
				if this_quad_z_pos > player_quad_pos.y:
					#quad is to the South of the player
					new_dir = dirs.S
			2:
				new_lod = LODs.LOD1
				new_dir = dirs.no_dir
				#default assumption is that the quad is to the North of the player
				#new_dir = dirs.N
				#if this_quad_z_pos > player_quad_pos.y:
					##quad is to the South of the player
					#new_dir = dirs.S
			3:
				new_lod = LODs.LOD1
				#default assumption is that the quad is to the North of the player
				new_dir = dirs.N
				if this_quad_z_pos > player_quad_pos.y:
					#quad is to the South of the player
					new_dir = dirs.S
			4:
				new_lod = LODs.LOD2
				new_dir = dirs.no_dir
				#default assumption is that the quad is to the North of the player
				#new_dir = dirs.N
				#if this_quad_z_pos > player_quad_pos.y:
					##quad is to the South of the player
					#new_dir = dirs.S
			5:
				new_lod = LODs.LOD2
				#default assumption is that the quad is to the North of the player
				new_dir = dirs.N
				if this_quad_z_pos > player_quad_pos.y:
					#quad is to the South of the player
					new_dir = dirs.S
			6:
				new_lod = LODs.LOD3
				new_dir = dirs.no_dir
				#default assumption is that the quad is to the North of the player
				#new_dir = dirs.N
				#if this_quad_z_pos > player_quad_pos.y:
					##quad is to the South of the player
					#new_dir = dirs.S
			7:
				new_lod = LODs.LOD3
				#default assumption is that the quad is to the North of the player
				new_dir = dirs.N
				if this_quad_z_pos > player_quad_pos.y:
					#quad is to the South of the player
					new_dir = dirs.S
			8:
				new_lod = LODs.LOD4
				new_dir = dirs.no_dir
				#default assumption is that the quad is to the North of the player
				#new_dir = dirs.N
				#if this_quad_z_pos > player_quad_pos.y:
					##quad is to the South of the player
					#new_dir = dirs.S
			9:
				new_lod = LODs.LOD4
				#default assumption is that the quad is to the North of the player
				new_dir = dirs.N
				if this_quad_z_pos > player_quad_pos.y:
					#quad is to the South of the player
					new_dir = dirs.S
			_:
				new_lod = LODs.LOD5
				new_dir = dirs.no_dir
	
	#this quad is the same distance from the player to the North or South 
	#as it is to East or West, or further North or South			
	if dist_z_from_player_quad == dist_x_from_player_quad:
		match dist_z_from_player_quad:
			0:
				#this is the quad on which the player is located
				new_lod = LODs.LOD0
				new_dir = dirs.no_dir
			1:
				
				new_lod = LODs.LOD0
				if this_quad_z_pos < player_quad_pos.y:
				#this quad is to the North of the player
				#assuming default of quad being West of the player
					new_dir = dirs.NW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.NE
				else:
					#this quad is to the South of the player
					#assuming default of quad being West of the player
					new_dir = dirs.SW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.SE
				
			2:
				new_lod = LODs.LOD1
				new_dir = dirs.no_dir
			3:
				new_lod = LODs.LOD1
				if this_quad_z_pos < player_quad_pos.y:
				#this quad is to the North of the player
				#assuming default of quad being West of the player
					new_dir = dirs.NW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.NE
				else:
					#if this_quad_z_pos > player_quad_pos.y:
					#this quad is to the South of the player
					#assuming default of quad being West of the player
					new_dir = dirs.SW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.SE
			4:
				new_lod = LODs.LOD2
				new_dir = dirs.no_dir
			5:
				new_lod = LODs.LOD2
				if this_quad_z_pos < player_quad_pos.y:
				#this quad is to the North of the player
				#assuming default of quad being West of the player
					new_dir = dirs.NW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.NE
				else:
					#if this_quad_z_pos > player_quad_pos.y:
					#this quad is to the South of the player
					#assuming default of quad being West of the player
					new_dir = dirs.SW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.SE
			6:
				new_lod = LODs.LOD3
				new_dir = dirs.no_dir
			7:
				new_lod = LODs.LOD3
				if this_quad_z_pos < player_quad_pos.y:
				#this quad is to the North of the player
				#assuming default of quad being West of the player
					new_dir = dirs.NW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.NE
				else:
					#if this_quad_z_pos > player_quad_pos.y:
					#this quad is to the South of the player
					#assuming default of quad being West of the player
					new_dir = dirs.SW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.SE
			8:
				new_lod = LODs.LOD4
				new_dir = dirs.no_dir
			9:
				new_lod = LODs.LOD4
				if this_quad_z_pos < player_quad_pos.y:
				#this quad is to the North of the player
				#assuming default of quad being West of the player
					new_dir = dirs.NW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.NE
				else:
					#if this_quad_z_pos > player_quad_pos.y:
					#this quad is to the South of the player
					#assuming default of quad being West of the player
					new_dir = dirs.SW
					if this_quad_x_pos > player_quad_pos.x:
						#this quad is to the East of the player
						new_dir = dirs.SE
			_:
				new_lod = LODs.LOD5
				new_dir = dirs.no_dir
	
	if current_dir != new_dir or current_lod != new_lod:
		current_dir = new_dir
		current_lod = new_lod
		create_quad_mesh(Vector2i(current_dir, current_lod))

func create_quad_mesh(dir_and_lod : Vector2i):
	current_dir = dir_and_lod.x
	current_lod = dir_and_lod.y
	
	#populate the verts array with a 33x33 selection of the resource file's 513x513 height data,
	#based on the strip_z and quad_x location of the quad
	var verts : PackedVector3Array = []
	var indices : PackedInt32Array = []
	var uvs : PackedVector2Array = []
	var vert_selection : PackedInt32Array = []
	#TODO: check that the global script's arrays are not being overwritten when "vert_selection"
	#and "indices" arrays are changed
	# = example.duplicate(false) #shallow copy. Changes in either of the arrays will cause changes in the other.
	
	match current_lod:
		LODs.LOD0:
			vert_selection = GlblScrpt.vert00
			indices = GlblScrpt.ind00
		LODs.LOD1:
			vert_selection = GlblScrpt.vert01
			indices = GlblScrpt.ind01
		LODs.LOD2:
			vert_selection = GlblScrpt.vert02
			indices = GlblScrpt.ind02
		LODs.LOD3:
			vert_selection = GlblScrpt.vert03
			indices = GlblScrpt.ind03
		LODs.LOD4:
			vert_selection = GlblScrpt.vert04
			indices = GlblScrpt.ind04
		LODs.LOD5:
			vert_selection = GlblScrpt.vert05
			indices = GlblScrpt.ind05
		_:
			print("no LOD assigned")
		
	for sel_vert in range(0, vert_selection.size()):
		var vert_z_in_quad : float = floor(vert_selection[sel_vert] / float(quad_size + 1))
		#32 / 33 = 0z, leaving 32x
		#33 / 33 = 1z, leaving 0x
		#64 / 33 = 1z, leaving 31x
		#98 / 33 = 2z, leaving 32x
		var vert_x_in_quad : float = vert_selection[sel_vert] - (vert_z_in_quad * float(quad_size + 1))
		var z_distance_into_array : int = floor(vert_selection[sel_vert] / float(quad_size + 1)) * (section_size + 1) + starting_z
		var vert_y_in_array : int = z_distance_into_array + starting_x + vert_x_in_quad
		var vert_y : float = resource_file.height_data[vert_y_in_array]
		
		match current_dir:
			dirs.N:
				#this quad is facing North, so every second vertex in the first row needs to be 
				#matched to the lower LOD quad to the north
				if vert_z_in_quad == 0.0 and fmod(vert_x_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to West and East of this vertex
					var vert_y_west : float = resource_file.height_data[vert_y_in_array - 1]
					var vert_y_east : float = resource_file.height_data[vert_y_in_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
					
			dirs.NE:
				#this quad is facing both North and East. Match to lower LODS in either direction
				#North
				if vert_z_in_quad == 0.0 and fmod(vert_x_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to West and East of this vertex
					var vert_y_west : float = resource_file.height_data[vert_y_in_array - 1]
					var vert_y_east : float = resource_file.height_data[vert_y_in_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
				#East
				if vert_x_in_quad == float(quad_size) and fmod(vert_z_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[vert_y_in_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[vert_y_in_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
			
			dirs.E:
				#this quad is facing East, so the vertex at the end of every second row
				#needs to be matched to the lower LOD quad to the East
				if vert_x_in_quad == float(quad_size) and fmod(vert_z_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[vert_y_in_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[vert_y_in_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
			
			dirs.SE:
				#this quad is facing both South and East. Match to lower LODS in either direction
				#South
				if vert_z_in_quad == float(quad_size) and fmod(vert_x_in_quad, 2.0) != 0.0:
					var vert_y_west : float = resource_file.height_data[vert_y_in_array - 1]
					var vert_y_east : float = resource_file.height_data[vert_y_in_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
				#East
				if vert_x_in_quad == float(quad_size) and fmod(vert_z_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[vert_y_in_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[vert_y_in_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0	
					
			dirs.S:
				#this quad is facing South, so every second vertex in the last row needs to be
				#matched to the lower LOD quad to the South
				if vert_z_in_quad == float(quad_size) and fmod(vert_x_in_quad, 2.0) != 0.0:
					var vert_y_west : float = resource_file.height_data[vert_y_in_array - 1]
					var vert_y_east : float = resource_file.height_data[vert_y_in_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
			
			dirs.SW:
				#this quad is facing both South and West. Match to lower LODS in either direction
				#South
				if vert_z_in_quad == float(quad_size) and fmod(vert_x_in_quad, 2.0) != 0.0:
					var vert_y_west : float = resource_file.height_data[vert_y_in_array - 1]
					var vert_y_east : float = resource_file.height_data[vert_y_in_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
				#West
				if vert_x_in_quad == 0.0 and fmod(vert_z_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[vert_y_in_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[vert_y_in_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
			
			dirs.W:
				#this quad is facing West, so the vertex at the start of every second row
				#needs to be matched to the lower LOD quad to the West
				if vert_x_in_quad == 0.0 and fmod(vert_z_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[vert_y_in_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[vert_y_in_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
			
			dirs.NW:
				#this quad is facing both North and West. Match to lower LODS in either direction
				#North
				if vert_z_in_quad == 0.0 and fmod(vert_x_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to West and East of this vertex
					var vert_y_west : float = resource_file.height_data[vert_y_in_array - 1]
					var vert_y_east : float = resource_file.height_data[vert_y_in_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
				#West
				if vert_x_in_quad == 0.0 and fmod(vert_z_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[vert_y_in_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[vert_y_in_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
					
			#dirs.no_dir:				
				#vert_y = resource_file.height_data[vert_y_in_array]
		
		verts.append(Vector3(vert_x_in_quad, vert_y, vert_z_in_quad))
		#calculate the UVs of this vert, based on its location in the 513x513 grid
		#should this be 512x512?
		var uv_x : float = float(starting_x + vert_x_in_quad) / float(section_size)
		var uv_y : float = float((strip_z * quad_size) + vert_z_in_quad) / float(section_size)
		uvs.append(Vector2(uv_x, uv_y))
		#uvs.append(Vector2(0.5, 0.5))
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(resource_file.section_mat)
	#TODO: set smooth normals
	st.set_smooth_group(0)
	for vert in range(0, verts.size()):
		st.set_uv(uvs[vert])
		#TODO: convert from quad-relative to terrain section-relative position?
		#vert += quad_position
		st.add_vertex(verts[vert])
	
	for ind in range(0,indices.size()):
		st.add_index(indices[ind])
	st.generate_normals()
	st.generate_tangents()
	a_mesh.clear_surfaces()
	st.commit(a_mesh)
	mesh_inst.mesh = a_mesh
	#var shape = ConcavePolygonShape3D.new()
	#shape.set_faces(a_mesh.get_faces())
	#coll_shape.shape = shape
	coll_shape_shape.set_faces(a_mesh.get_faces())#does this generate a collision mesh at the world origin?
	#coll_shape.set_shape()
	#mesh_inst.create_trimesh_collision()#useful for testing, but very slow

