extends Node3D
#voxels using Marchins Cubes algorithm
class_name TerrainChunk

@onready var mesh_inst = $MeshInstance3D
@onready var coll_shape = $StaticBody3D/CollisionShape3D
@onready var chunk_size : int = GlblScrpt.chunk_size
@onready var terrain_section_size : float = float(GlblScrpt.terrain_section_size)
var a_mesh : ArrayMesh
var coll_shape_shape : ConcavePolygonShape3D
var isosurface : float = 0.0
var num_verts : int = 0 #TODO: remember to reset this to zero before updating the mesh
var verts : PackedVector3Array = []
var uvs : PackedVector2Array = []
var indices : PackedInt32Array = []
var triangle_order = [0, 1, 2]#default winding order of a tri's vertices
var voxels = []

#var heights = [] #this might not be necessary...
var chunk_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var terrain_mat : ShaderMaterial
var terrain_section_index : int
#handle to resource files containing height and material data for this chunk's terrain section
var parent_resource_filename : String = ""
#handle to the parent quad of this chunk
var parent_quad = null

func init_chunk(_chunk_pos : Vector3):
	coll_shape_shape = ConcavePolygonShape3D.new()
	coll_shape.shape = coll_shape_shape
	chunk_pos = _chunk_pos
	self.global_position = chunk_pos
	voxels.resize((chunk_size + 1) * (chunk_size + 1) * (chunk_size + 1))
	#calculate which terrain section the chunk is in
	terrain_section_index = get_terr_section_index(chunk_pos)
	parent_quad = get_quad(chunk_pos, terrain_section_index)
	#this allows the chunk to find the right resource file to access the heights data needed to
	#populate the chunk_ones_zeroes array
	parent_resource_filename = get_section_resource_filename(chunk_pos)
	var path_to_section_data = "res://terrain/" + parent_resource_filename + "/" + parent_resource_filename + ".tres"
	var parent_resource_file = load(path_to_section_data)
	#TODO: assign the correct material to match this chunk's parent quad and terrain section
	#TODO: also allow for setting of a triplanar material for excavated areas
	#possibly a second shadermaterial in the section's resource file?
	terrain_mat = parent_resource_file.section_mat
	get_initial_heights(parent_resource_file.height_data)
	generate_mesh()


					
	
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
	
#populate the voxels array with ones (solid/under the surface) and minus ones (air / outside the surface).	
func get_initial_heights(height_data) -> void:
	var chunk_x_in_terrain_heights = fmod(chunk_pos.x, terrain_section_size)
	var chunk_z_in_terrain_heights = fmod(chunk_pos.z, terrain_section_size)
	for vert_y in range(0, chunk_size + 1):
		for vert_z in range(0, chunk_size + 1):
			for vert_x in range(0, chunk_size + 1):
				var current_height_index = (chunk_z_in_terrain_heights * (terrain_section_size + 1)) + chunk_x_in_terrain_heights
				if chunk_pos.y + vert_y < height_data[current_height_index]:
					voxels[vert_y][vert_z][vert_x] = 1.0
				else:
					voxels[vert_y][vert_z][vert_x] = -1.0	
	
func generate_mesh() -> void:
	#clear out the mesh generation arrays
	num_verts = 0
	verts.clear()
	uvs.clear()
	indices.clear()
	var cube = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
	#set the triangulation order
	if (isosurface > 0.0):
		triangle_order[0] = 2
		triangle_order[1] = 1
		triangle_order[2] = 0
	else:
		triangle_order[0] = 0
		triangle_order[1] = 1
		triangle_order[2] = 2
	for cube_y in range(0, chunk_size):
		for cube_z in range(0, chunk_size):
			for cube_x in range(0, chunk_size):
				for v in range(0, cube.size()):
					#populates each vertex of the cube with either a 1.0 or a -1.0
					#TODO: maybe the below should be chunk_size instead of chunk_size + 1?
					var cube_vert_y = (cube_y + GlblScrpt.cube_vert_offsets[v].y) * (chunk_size + 1) * (chunk_size + 1)
					var cube_vert_z = (cube_z + GlblScrpt.cube_vert_offsets[v].z) * (chunk_size + 1)
					var cube_vert_x = cube_x + GlblScrpt.cube_vert_offsets[v].x
					var cube_vert = cube_vert_y + cube_vert_z + cube_vert_x
					if cube_vert != null and cube_vert != NAN:
						cube[v] = cube_vert
					else:
						print("cube vert not found in voxels array")
					march_cube(cube, cube_y, cube_z, cube_x)
		
func march_cube(cube, cube_y, cube_z, cube_x) -> void:
	#create an int that will serve as a hexadecimal mask for comparison with the CubeEdgeFlags array defined in terrain_globals singleton
	var vert_mask = 0
	#Find which of the cube's 8 vertices are inside of the surface and which are outside
	for i in range(0, cube.size()):
		#First
		#Left shift bitwise operator << is equivalent to multiplying the first operand by 2 raised to the power of the second operand
		# a<<b is the same as a(2^b)
		#Second
		#Bitwise "OR" assignment operator |= functions by ORing the bits of the left operand and right operand and assigning the result to the left operand
		#In effect, if the result of the left shift operation is less than the VertexMask, Cube[i] is assigned the VertexMask.
		#Otherwise, Cube[i] is assigned (VertexMask plus (1 << i))
		if (cube[i] <= isosurface):
			vert_mask |= 1 << i
	var edge_mask = GlblScrpt.cube_edge_flags[vert_mask]
	#if none of the edges are intersected by the isosurface, no need to draw this voxel
	if (edge_mask == 0):
		return
	#an array to hold the vertex positions on the edges of the cube. These verts will be used to create up to 5 triangles inside the cube
	var edge_verts = [
		Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), 
		Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), 
		Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0), Vector3(0.0, 0.0, 0.0)
	]
	
	for ev in range(0, edge_verts.size()):
		#First calculate 1 * (2^ev)
		#Second, compare the bits of edge_mask and the result of the first calculation using the bitwise AND operator.
		#This comparison returns a 1 bit only if both of the bits being compared are 1, otherwise it returns a 0
		if ((edge_mask & 1 << ev) != 0):
			var offset : float = get_interpolated_offset(cube[GlblScrpt.edge_connection[ev][0]], cube[GlblScrpt.edge_connection[ev][1]])
			edge_verts[ev].x = cube_x + (GlblScrpt.cube_vert_offsets[GlblScrpt.edge_connection[ev][0]][0] + offset * GlblScrpt.edge_direction[ev][0])
			edge_verts[ev].y = cube_y + (GlblScrpt.cube_vert_offsets[GlblScrpt.edge_connection[ev][0]][1] + offset * GlblScrpt.edge_direction[ev][1])
			edge_verts[ev].z = cube_z + (GlblScrpt.cube_vert_offsets[GlblScrpt.edge_connection[ev][0]][2] + offset * GlblScrpt.edge_direction[ev][2])
			
	#Save the triangles that describe the isosurface inside the voxel, maximum 5 triangles
	for edge in range(5):
		#In the triangle connection table, the triangles are described by sets of three edges intersected by the isosurface
		#"3 * edge" is used to iterate over them
		#-1 is used to mark the end of the list of triangles in a given row.
		if (GlblScrpt.tri_connection_table[vert_mask][3 * edge] < 0):
			break
		var vert_0 = edge_verts[GlblScrpt.tri_connection_table[vert_mask][3 * edge]]
		var vert_1 = edge_verts[GlblScrpt.tri_connection_table[vert_mask][3 * edge + 1]]
		var vert_2 = edge_verts[GlblScrpt.tri_connection_table[vert_mask][3 * edge + 2]]
		#add the three vertices to the verts array for the SurfaceTool
		verts.append(vert_0)
		verts.append(vert_1)
		verts.append(vert_2)
		#add the correct indices to the indices array
		indices.append(num_verts + triangle_order[0])
		indices.append(num_verts + triangle_order[1])
		indices.append(num_verts + triangle_order[2])
		
		num_verts = num_verts + 3

func get_interpolated_offset(v0 : float, v1 : float) -> float:
	#smoothing of the mesh by interpolating along each edge to find where the isosurface intersects it
	var loc_delta : float = v1 - v0
	if loc_delta == 0.0:
		return isosurface
	return (isosurface - v0) / loc_delta
