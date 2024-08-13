@tool
extends Node3D
class_name TerrainQuad32

@onready var quad_size : int = GlblScrpt.quad_size
@onready var section_size : int = GlblScrpt.terrain_section_size
@onready var max_LOD_dist : int = GlblScrpt.max_LOD_dist_terrain
var parent_section
var mesh_inst : MeshInstance3D
var coll_shape : CollisionShape3D
var verts : PackedVector3Array = []
var uvs : PackedVector2Array = []
var indices : PackedInt32Array = []
var a_mesh : ArrayMesh
var coll_shape_shape : ConcavePolygonShape3D
var resource_file = null
var quad_x_in_section : int = 0
var quad_z_in_section : int = 0
var quad_x_global : float = 0.0
var quad_z_global : float = 0.0

# each 32x32 quad has a LOD and a direction
# the distance of each quad to the quad in which the player is located
enum LODs {LOD0, LOD1, LOD2, LOD3, LOD4, LOD5}
# LOD0 = 1x1 metres, LOD1 = 2x2, LOD2 = 4x4, LOD3 = 8x8, LOD4 = 16x16, LOD5 = 32x32 - this might not be practical with faraway excavations...

# the direction from the player to each quad
enum dirs {no_dir, N, NE, E, SE, S, SW, W, NW}
# none : 0, N: 1, NE: 2, E: 3, SE: 4, S: 5, SW: 6, W: 7, NW: 8
# these two pieces of information will determine which
# vertices will be added to the verts array to create this quad's mesh
var current_dir = null
var current_lod = null
var section_mat : ShaderMaterial
var checking_dir_and_lod : bool = false
var handling_excavation : bool = false

func init_quad(_quad_x : int, _quad_z : int):
	parent_section = self.get_parent().get_parent()
	quad_x_in_section = _quad_x
	quad_z_in_section = _quad_z
	quad_x_global = self.global_position.x
	quad_z_global = self.global_position.z
	#create the mesh and the collisionshape at init 
	#to avoid having to make each one unique in the editor
	a_mesh = ArrayMesh.new()
	coll_shape_shape = ConcavePolygonShape3D.new()
	coll_shape = $StaticBody3D/CollisionShape3D
	mesh_inst = $MeshInstance3D
	coll_shape.shape = coll_shape_shape
	check_dir_and_LOD()
	

#func set_dir_and_LOD(dir_and_lod : Vector2i):
	#if current_dir != dir_and_lod.x or current_lod != dir_and_lod.y:
		#create_quad_mesh(dir_and_lod)

func check_dir_and_LOD():
	if checking_dir_and_lod == false:
		checking_dir_and_lod = true
		var player_pos : Vector2 = GlblScrpt.player.get_player_pos()
		var player_quad_pos : Vector2i = Vector2i(floor(player_pos.x / float(quad_size)) * float(quad_size), floor(player_pos.y / float(quad_size)) * quad_size)
		var new_dir = null
		var new_lod = null
		#player_quad_pos holds the global x and z coordinates of the quad in which the player is located
		var dist_x_from_player_quad : int = abs(player_quad_pos.x - quad_x_global) / quad_size
		var dist_z_from_player_quad : int = abs(player_quad_pos.y - quad_z_global) / quad_size
		
		if dist_z_from_player_quad < dist_x_from_player_quad:
			#this quad is further to the East or West than it is North or South of the player
			match dist_x_from_player_quad:
				0:
					new_lod = LODs.LOD0
					new_dir = dirs.no_dir
					
				1: 
					new_lod = LODs.LOD0
					#default assumption is that the quad is to the West of the player
					new_dir = dirs.W
					if quad_x_global > player_quad_pos.x:
						#quad is to the East of the player
						new_dir = dirs.E
				2:
					new_lod = LODs.LOD1
					new_dir = dirs.no_dir
				3:
					new_lod = LODs.LOD1
					#default assumption is that the quad is to the West of the player
					new_dir = dirs.W
					if quad_x_global > player_quad_pos.x:
						#quad is to the East of the player
						new_dir = dirs.E
				4:
					new_lod = LODs.LOD2
					new_dir = dirs.no_dir
				5:
					new_lod = LODs.LOD2
					#default assumption is that the quad is to the West of the player
					new_dir = dirs.W
					if quad_x_global > player_quad_pos.x:
						#quad is to the East of the player
						new_dir = dirs.E
				6:
					new_lod = LODs.LOD3
					new_dir = dirs.no_dir
				7:
					new_lod = LODs.LOD3
					#default assumption is that the quad is to the West of the player
					new_dir = dirs.W
					if quad_x_global > player_quad_pos.x:
						#quad is to the East of the player
						new_dir = dirs.E
				8:
					new_lod = LODs.LOD4
					new_dir = dirs.no_dir
				9:
					new_lod = LODs.LOD4
					#default assumption is that the quad is to the West of the player
					new_dir = dirs.W
					if quad_x_global > player_quad_pos.x:
						#quad is to the East of the player
						new_dir = dirs.E
				_:
					new_lod = LODs.LOD5
					new_dir = dirs.no_dir

		if dist_z_from_player_quad > dist_x_from_player_quad:
			#this quad is further to the North or South than it is East or West of the player
			match dist_z_from_player_quad:
				0:
					new_lod = LODs.LOD0
					new_dir = dirs.no_dir
				1: 
					new_lod = LODs.LOD0
					#default assumption is that the quad is to the North of the player
					new_dir = dirs.N
					if quad_z_global > player_quad_pos.y:
						#quad is to the South of the player
						new_dir = dirs.S
				2:
					new_lod = LODs.LOD1
					new_dir = dirs.no_dir
				3:
					new_lod = LODs.LOD1
					#default assumption is that the quad is to the North of the player
					new_dir = dirs.N
					if quad_z_global > player_quad_pos.y:
						#quad is to the South of the player
						new_dir = dirs.S
				4:
					new_lod = LODs.LOD2
					new_dir = dirs.no_dir

				5:
					new_lod = LODs.LOD2
					#default assumption is that the quad is to the North of the player
					new_dir = dirs.N
					if quad_z_global > player_quad_pos.y:
						#quad is to the South of the player
						new_dir = dirs.S
				6:
					new_lod = LODs.LOD3
					new_dir = dirs.no_dir

				7:
					new_lod = LODs.LOD3
					#default assumption is that the quad is to the North of the player
					new_dir = dirs.N
					if quad_z_global > player_quad_pos.y:
						#quad is to the South of the player
						new_dir = dirs.S
				8:
					new_lod = LODs.LOD4
					new_dir = dirs.no_dir
				9:
					new_lod = LODs.LOD4
					#default assumption is that the quad is to the North of the player
					new_dir = dirs.N
					if quad_z_global > player_quad_pos.y:
						#quad is to the South of the player
						new_dir = dirs.S
				_:
					new_lod = LODs.LOD5
					new_dir = dirs.no_dir
		
		if dist_z_from_player_quad == dist_x_from_player_quad:
			#this quad is the same distance from the player to the North or South 
			#as it is to East or West, or further North or South			
			match dist_z_from_player_quad:
				0:
					#this is the quad on which the player is located
					new_lod = LODs.LOD0
					new_dir = dirs.no_dir
				1:
					
					new_lod = LODs.LOD0
					if quad_z_global < player_quad_pos.y:
					#this quad is to the North of the player
					#assuming default of quad being West of the player
						new_dir = dirs.NW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.NE
					else:
						#this quad is to the South of the player
						#assuming default of quad being West of the player
						new_dir = dirs.SW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.SE
					
				2:
					new_lod = LODs.LOD1
					new_dir = dirs.no_dir
				3:
					new_lod = LODs.LOD1
					if quad_z_global < player_quad_pos.y:
					#this quad is to the North of the player
					#assuming default of quad being West of the player
						new_dir = dirs.NW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.NE
					else:
						#if this_quad_z_pos > player_quad_pos.y:
						#this quad is to the South of the player
						#assuming default of quad being West of the player
						new_dir = dirs.SW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.SE
				4:
					new_lod = LODs.LOD2
					new_dir = dirs.no_dir
				5:
					new_lod = LODs.LOD2
					if quad_z_global < player_quad_pos.y:
					#this quad is to the North of the player
					#assuming default of quad being West of the player
						new_dir = dirs.NW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.NE
					else:
						#if this_quad_z_pos > player_quad_pos.y:
						#this quad is to the South of the player
						#assuming default of quad being West of the player
						new_dir = dirs.SW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.SE
				6:
					new_lod = LODs.LOD3
					new_dir = dirs.no_dir
				7:
					new_lod = LODs.LOD3
					if quad_z_global < player_quad_pos.y:
					#this quad is to the North of the player
					#assuming default of quad being West of the player
						new_dir = dirs.NW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.NE
					else:
						#if this_quad_z_pos > player_quad_pos.y:
						#this quad is to the South of the player
						#assuming default of quad being West of the player
						new_dir = dirs.SW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.SE
				8:
					new_lod = LODs.LOD4
					new_dir = dirs.no_dir
				9:
					new_lod = LODs.LOD4
					if quad_z_global < player_quad_pos.y:
					#this quad is to the North of the player
					#assuming default of quad being West of the player
						new_dir = dirs.NW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.NE
					else:
						#if this_quad_z_pos > player_quad_pos.y:
						#this quad is to the South of the player
						#assuming default of quad being West of the player
						new_dir = dirs.SW
						if quad_x_global > player_quad_pos.x:
							#this quad is to the East of the player
							new_dir = dirs.SE
				_:
					new_lod = LODs.LOD5
					new_dir = dirs.no_dir
		
		if current_dir != new_dir or current_lod != new_lod:
			current_dir = new_dir
			current_lod = new_lod
			generate_mesh()
			apply_mesh()
		checking_dir_and_lod = false

func generate_mesh():
	#populate the verts array with a 33x33 selection of the resource file's 513x513 height data,
	#based on the X and Z location of the quad
	verts.clear()
	indices.clear()
	uvs.clear()
	var vert_selection : PackedInt32Array = []
	#TODO: check that the global script's arrays are not being overwritten when "vert_selection"
	#and "indices" arrays are changed
	# = example.duplicate(false) #shallow copy. Changes in either of the arrays will cause changes in the other.
	
	match current_lod:
		LODs.LOD0:
			vert_selection = GlblScrpt.vert00.duplicate()
			indices = GlblScrpt.ind00.duplicate()
		LODs.LOD1:
			vert_selection = GlblScrpt.vert01.duplicate()
			indices = GlblScrpt.ind01.duplicate()
		LODs.LOD2:
			vert_selection = GlblScrpt.vert02.duplicate()
			indices = GlblScrpt.ind02.duplicate()
		LODs.LOD3:
			vert_selection = GlblScrpt.vert03.duplicate()
			indices = GlblScrpt.ind03.duplicate()
		LODs.LOD4:
			vert_selection = GlblScrpt.vert04.duplicate()
			indices = GlblScrpt.ind04.duplicate()
		LODs.LOD5:
			vert_selection = GlblScrpt.vert05.duplicate()
			indices = GlblScrpt.ind05.duplicate()
		_:
			print("no LOD assigned")
	
	#vert_selection now holds the index of each vert in sequential order, based on the density of verts in this quad (ie. the LOD)
	#for example, at LOD0, the first row of vert_selection is 0,1,2,3... up to quad_size
	#at LOD1, the first row of vert selection is 0,2,4,6... up to quad_size
	resource_file = parent_section.get_resource_file()
	#if resource_file == null:
		#print("could not get this section's resource file")
		#return
	#else:
		#print("resource filename: " + resource_file.name)
	for sel_vert in range(0, vert_selection.size()):
		var vert_z_in_quad : int = int(vert_selection[sel_vert] / (quad_size + 1))
		#32 / 33 = 0 (row Z), (with 0 to 32 in the X columns of row 0)
		#33 / 33 = 1 (row Z), leaving 0 X
		#64 / 33 = 1 (row Z), leaving 31 X
		#98 / 33 = 2 (row Z), leaving 32 X
		var vert_x_in_quad : int = vert_selection[sel_vert] - (vert_z_in_quad * (quad_size + 1))
		var z_in_heights_array : int = ((quad_z_in_section * quad_size) + vert_z_in_quad) * (section_size + 1)
		var x_in_heights_array : int = (quad_x_in_section * quad_size) + vert_x_in_quad
		var y_in_heights_array : int = z_in_heights_array + x_in_heights_array
		var vert_y : float = resource_file.height_data[y_in_heights_array]
		
		match current_dir:
			dirs.N:
				#this quad is facing North, so every second vertex in the first row needs to be 
				#matched to the lower LOD quad to the north
				if vert_z_in_quad == 0 and vert_x_in_quad % 2 != 0:
					#get the heights of the vertices to West and East of this vertex
					var vert_y_west : float = resource_file.height_data[y_in_heights_array - 1]
					var vert_y_east : float = resource_file.height_data[y_in_heights_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
					
			dirs.NE:
				#this quad is facing both North and East. Match to lower LODS in either direction
				#North
				if vert_z_in_quad == 0 and vert_x_in_quad % 2 != 0:
					#get the heights of the vertices to West and East of this vertex
					var vert_y_west : float = resource_file.height_data[y_in_heights_array - 1]
					var vert_y_east : float = resource_file.height_data[y_in_heights_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
				#East
				if vert_x_in_quad == float(quad_size) and fmod(vert_z_in_quad, 2.0) != 0.0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[y_in_heights_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[y_in_heights_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
			
			dirs.E:
				#this quad is facing East, so the vertex at the end of every second row
				#needs to be matched to the lower LOD quad to the East
				if vert_x_in_quad == quad_size and vert_z_in_quad % 2 != 0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[y_in_heights_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[y_in_heights_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
			
			dirs.SE:
				#this quad is facing both South and East. Match to lower LODS in either direction
				#South
				if vert_z_in_quad == quad_size and vert_x_in_quad % 2 != 0:
					var vert_y_west : float = resource_file.height_data[y_in_heights_array - 1]
					var vert_y_east : float = resource_file.height_data[y_in_heights_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
				#East
				if vert_x_in_quad == quad_size and vert_z_in_quad % 2 != 0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[y_in_heights_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[y_in_heights_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0	
					
			dirs.S:
				#this quad is facing South, so every second vertex in the last row needs to be
				#matched to the lower LOD quad to the South
				if vert_z_in_quad == quad_size and vert_x_in_quad % 2 != 0:
					var vert_y_west : float = resource_file.height_data[y_in_heights_array - 1]
					var vert_y_east : float = resource_file.height_data[y_in_heights_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
			
			dirs.SW:
				#this quad is facing both South and West. Match to lower LODS in either direction
				#South
				if vert_z_in_quad == quad_size and vert_x_in_quad % 2 != 0:
					var vert_y_west : float = resource_file.height_data[y_in_heights_array - 1]
					var vert_y_east : float = resource_file.height_data[y_in_heights_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
				#West
				if vert_x_in_quad == 0 and vert_z_in_quad % 2 != 0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[y_in_heights_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[y_in_heights_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
			
			dirs.W:
				#this quad is facing West, so the vertex at the start of every second row
				#needs to be matched to the lower LOD quad to the West
				if vert_x_in_quad == 0 and vert_z_in_quad % 2 != .0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[y_in_heights_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[y_in_heights_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
			
			dirs.NW:
				#this quad is facing both North and West. Match to lower LODS in either direction
				#North
				if vert_z_in_quad == 0 and vert_x_in_quad % 2 != 0:
					#get the heights of the vertices to West and East of this vertex
					var vert_y_west : float = resource_file.height_data[y_in_heights_array - 1]
					var vert_y_east : float = resource_file.height_data[y_in_heights_array + 1]
					vert_y = (vert_y_west + vert_y_east) / 2.0
				#West
				if vert_x_in_quad == 0 and vert_z_in_quad % 2 != 0:
					#get the heights of the vertices to North and South of this vertex
					var vert_y_north : float = resource_file.height_data[y_in_heights_array - (section_size + 1)]
					var vert_y_south : float = resource_file.height_data[y_in_heights_array + (section_size + 1)]
					vert_y = (vert_y_north + vert_y_south) / 2.0
					

		verts.append(Vector3(vert_x_in_quad, vert_y, vert_z_in_quad))
		#calculate the UVs of this vert, based on its location in the 512x512 grid
		#TODO: figure out if the divisor should be section_size + 1.
		#Unlikely, as the textures for the shader material need to be power of 2 for mipmapping purposes.
		var uv_x : float = fmod(self.global_position.x + float(vert_x_in_quad), float(section_size + 1)) / float(section_size + 1)
		var uv_y : float = fmod(self.global_position.z + float(vert_z_in_quad), float(section_size + 1)) / float(section_size + 1)
		uvs.append(Vector2(uv_x, uv_y))
	
		
func apply_mesh():
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_material(resource_file.section_mat)
	#TODO: set smooth normals
	#st.set_smooth_group(0)
	if indices.size() == 0:
		print("no indices in array: " + str(indices.size()))
		return
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
	coll_shape_shape.set_faces(a_mesh.get_faces())

func handle_tunnelling():
	pass
	
func handle_excavation(_excavator_pos : Vector3, _excavator_radius : float, _excavator_influence : float) -> void:
	if handling_excavation:
		return
	handling_excavation = true
	var verts_to_change = []
	for vert in range(0, verts.size()):
		var vert_global_pos : Vector3 = Vector3(quad_x_global, 0.0, quad_z_global) + verts[vert]
		if vert_global_pos.distance_to(_excavator_pos) < _excavator_radius:
			verts[vert].y = verts[vert].y - _excavator_influence
			if verts[vert].y < 0.0:
				verts[vert].y = 0.0
			verts_to_change.append(vert_global_pos)
	apply_mesh()
	update_section_data(verts_to_change)
	handling_excavation = false
	
func handle_filling(_filler_pos : Vector3) -> void:
	pass

func update_section_data(vert_positions) -> void:
	parent_section.update_section_heights(vert_positions)
	parent_section.update_section_splatmap(vert_positions)

func disable_and_hide_node(node:Node) -> void:
	#node.process_mode = 4 # = Mode: Disabled
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

func enable_and_show_node(node:Node) -> void:
	#node.process_mode = 0 # = Mode: Inherit
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()
