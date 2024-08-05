extends Node3D
#voxels using Marchins Cubes algorithm
class_name TerrainChunk

@onready var mesh_inst = $MeshInstance3D
@onready var coll_shape = $StaticBody3D/CollisionShape3D
@onready var chunk_size : int = GlblScrpt.chunk_size
@onready var terrain_section_size : float = float(GlblScrpt.terrain_section_size)
var a_mesh : ArrayMesh
var coll_shape_shape : ConcavePolygonShape3D
var isosurface : float = 0.01
var verts : PackedVector3Array = []
var uvs : PackedVector2Array = []
var indices : PackedInt32Array = []
var voxel_grid
var is_surface_chunk : bool = false
var chunk_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var terrain_section_mat : ShaderMaterial
var terrain_section_index : int
#handle to resource files containing height and material data for this chunk's terrain section
var parent_resource_filename : String = ""
#handle to the parent quad of this chunk
var parent_quad = null

class VoxelGrid:
	var data: PackedFloat32Array
	var resolution: int
	
	func _init(_resolution: int):
		self.resolution = _resolution
		self.data.resize(resolution*resolution*resolution)
		self.data.fill(1.0)
	
	func read(x: int, y: int, z: int):
		return self.data[x + self.resolution * (y + self.resolution * z)]
	
	func write(x: int, y: int, z: int, value: float):
		self.data[x + self.resolution * (y + self.resolution * z)] = value

func init_chunk(_chunk_pos : Vector3, _is_surface_chunk : bool):
	voxel_grid = VoxelGrid.new(chunk_size + 1)
	coll_shape_shape = ConcavePolygonShape3D.new()
	coll_shape.shape = coll_shape_shape
	chunk_pos = _chunk_pos
	self.global_position = chunk_pos
	is_surface_chunk = _is_surface_chunk
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
	terrain_section_mat = parent_resource_file.section_mat
	get_initial_heights(parent_resource_file.height_data)
	generate_mesh()

func get_initial_heights(height_data) -> void:
	var chunk_x_in_terrain_section = fmod(chunk_pos.x, terrain_section_size)
	var chunk_z_in_terrain_section = fmod(chunk_pos.z, terrain_section_size)
	# make sure that minus values in the x and z axes read from the correct part of the heights array...
	if chunk_z_in_terrain_section < 0.0:
		chunk_z_in_terrain_section = chunk_z_in_terrain_section + terrain_section_size
	if chunk_x_in_terrain_section < 0.0:
		chunk_x_in_terrain_section = chunk_x_in_terrain_section + terrain_section_size
	#for x in range(1, voxel_grid.resolution-1):
	for x in range(0, voxel_grid.resolution):
		#for y in range(1, voxel_grid.resolution-1):
		for y in range(0, voxel_grid.resolution):
			#for z in range(1, voxel_grid.resolution-1):
			for z in range(0, voxel_grid.resolution):
				var z_in_heights : int = int((chunk_z_in_terrain_section + float(z)) * (terrain_section_size + 1))
				var x_in_heights : int = int(chunk_x_in_terrain_section + float(x))
				if self.global_position.y + float(y) <= height_data[z_in_heights + x_in_heights]:
					voxel_grid.write(x, y, z, -1.0)

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
	
func generate_mesh() -> void:
	#clear out the mesh generation arrays
	verts.clear()
	uvs.clear()
	indices.clear()
	for x in voxel_grid.resolution-1:
		for y in voxel_grid.resolution-1:
			for z in voxel_grid.resolution-1:
				march_cube(x, y, z)
	#draw
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	#if verts.size() == 0:
		#print("no vertices created.")
	for vert in verts:
		surface_tool.add_vertex(vert)
	
	surface_tool.generate_normals()
	surface_tool.index()
	surface_tool.set_material(terrain_section_mat)
	a_mesh = ArrayMesh.new()
	surface_tool.commit(a_mesh)
	#if mesh_inst == null:
		#print("mesh instance not found: ")
		#return
	mesh_inst.mesh = a_mesh
	coll_shape_shape.set_faces(a_mesh.get_faces())

func march_cube(x:int, y:int, z:int):
	var tri = get_triangulation(x, y, z)
	for edge_index in tri:
		if edge_index < 0: break
		var point_indices = GlblScrpt.EDGES[edge_index]
		var p0 = GlblScrpt.POINTS[point_indices.x]
		var p1 = GlblScrpt.POINTS[point_indices.y]
		var pos_a = Vector3(x+p0.x, y+p0.y, z+p0.z)
		var pos_b = Vector3(x+p1.x, y+p1.y, z+p1.z)
		var vert_position = calculate_interpolation(pos_a, pos_b)
		verts.append(vert_position)	
	
func get_triangulation(x:int, y:int, z:int):
	var idx = 0b00000000
	idx |= int(voxel_grid.read(x, y, z) < isosurface)<<0
	idx |= int(voxel_grid.read(x, y, z+1) < isosurface)<<1
	idx |= int(voxel_grid.read(x+1, y, z+1) < isosurface)<<2
	idx |= int(voxel_grid.read(x+1, y, z) < isosurface)<<3
	idx |= int(voxel_grid.read(x, y+1, z) < isosurface)<<4
	idx |= int(voxel_grid.read(x, y+1, z+1) < isosurface)<<5
	idx |= int(voxel_grid.read(x+1, y+1, z+1) < isosurface)<<6
	idx |= int(voxel_grid.read(x+1, y+1, z) < isosurface)<<7
	return GlblScrpt.TRIANGULATIONS[idx]

func calculate_interpolation(a:Vector3, b:Vector3):
	var val_a = voxel_grid.read(a.x, a.y, a.z)
	var val_b = voxel_grid.read(b.x, b.y, b.z)
	var t = (isosurface - val_a)/(val_b-val_a)
	return a+t*(b-a)

func handle_excavation_sphere(sphere_pos : Vector3, radius : float):
	#convert the sphere position to be relative to the chunk
	var excav_local_pos : Vector3 = sphere_pos - self.global_position
	#check each vert in nearby y slices of the voxel grid to see whether or not it is within radius distance of sphere_pos
	var max_y = excav_local_pos.y + radius
	if max_y > voxel_grid.resolution:
		max_y = voxel_grid.resolution
	var min_y = excav_local_pos.y - radius
	if min_y < 0:
		min_y = 0
	for x in range(0, voxel_grid.resolution):
		for y in range(min_y, max_y):
			for z in range (voxel_grid.resolution):
				if Vector3(x,y,z).distance_to(excav_local_pos) < radius:
					#if it is, set that index of the voxel grid to 1.0
					voxel_grid.write(x, y, z, 1.0)
	generate_mesh()

func handle_excavation_cubic(cube_pos : Vector3, width : float, height : float, depth: float):
	pass
	
func handle_smoothing(top_left : Vector3, bottom_right : Vector3):
	pass



