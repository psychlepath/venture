@tool
extends Node3D
class_name TerrainSection

@export var section_data : Resource
@export var section_mat : ShaderMaterial
@export var update_heights : bool = false
@onready var terrain : Node3D = $terrain
@onready var num_quad_strips : int = terrain.get_child_count()
@onready var num_quads_in_strip : int = terrain.get_child(0).get_child_count()
var quad_size : int
var section_size : int
@onready var terr_pos : Vector2 = Vector2(self.global_position.x, self.global_position.z)
#var terr_sect_x : int = 0
#var terr_sect_z : int = 0
var max_LOD_dist : int = 10
var resource_file_name
# given the player position, use a series of 32x32 quads
# to calculate which of the 512 x 512 vertices make up 
# this terrain section's mesh.
# each 32x32 quad has a LOD and a direction
enum LODs {LOD0, LOD1, LOD2, LOD3, LOD4, LOD5}
# LOD0 = 1x1
# LOD1 = 2x2
# LOD2 = 4x4
# LOD3 = 8x8
# LOD4 = 16x16
# LOD5 = 32x32 - this might not be practical with faraway excavations...
# find the distance of each quad to the quad in which the player is located
# find the direction from the player to each quad
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
# vertices will be added to the VERTICES array to create
# this terrain section's mesh

# TODO: keep an array of the quads' LODs and directions to check whether there is any
# need to update the mesh

func _ready():
	quad_size = GlblScrpt.quad_size
	section_size = GlblScrpt.terrain_section_size
	if section_data == null:
		print("no section data file found")
	else:
		resource_file_name = section_data.resource_path.get_file().trim_suffix('.tres')
		init_quads()
	

		


func _process(_delta):
	if Engine.is_editor_hint():
		if update_heights == true:
			update_heights = false
			if GlblScrpt.terrain_manager != null:
				GlblScrpt.terrain_manager.update_section_centres_array()
			create_section_heights()

#func init_section():
	#terr_sect_x = floor(terr_pos.x / float(quad_size))# how many quads along the global X axis the terrain section is
	#terr_sect_z = floor(terr_pos.y / float(quad_size))# how many quads along the global Z axis the terrain section is
	
		
#editor only function	
func create_section_heights():
	#fill the resource file's 513x513 heights array from the heightmap
	#get the image file name from the resource file
	var heightmap_file_name = resource_file_name + ".exr"
	var file_path = "res://terrain/heightmaps/" + heightmap_file_name
	var heightmap_image : Image = load(file_path)
	#var heightmap_bytes = heightmap_image.get_data()
	section_data.height_data.clear()
	#print("heights array length: ",  str(section_data.height_data.size()))
	#section_data.height_data = heightmap_bytes.to_int32_array()
	heightmap_image.convert(Image.FORMAT_RF)#convert the red channel to float values
	#TODO: the heightmap stores data ini the range of 0.0 to 1.0.
	# this allows for an altitude range of more than just 0.0 to 255.0 metres...
	#section_data.height_data = heightmap_image.get_data().to_float32_array()
	var heights_array = heightmap_image.get_data().to_float32_array()
	for h in range(0, heights_array.size()):
		#section_data.height_data.append(heights_array[h] * GlblScrpt.terrain_height_scale)
		#snappedf(3.14159, 0.1) trim floats to a single decimal point
		section_data.height_data.append(snappedf(heights_array[h] * GlblScrpt.terrain_height_scale, 0.1))
	#print("heights array length: ",  str(section_data.height_data.size()))
	section_data.section_mat = section_mat
	ResourceSaver.save(section_data, section_data.get_path(), 0)
	#init_quads()
		
func init_quads():
	#pass the resource file to the child quads 
	#so that they can use it to find the resource file when they need it
	for strip_z in range(0, num_quad_strips):
		for quad_x in range(0, num_quads_in_strip):
			terrain.get_child(strip_z).get_child(quad_x).init_quad("res://terrain/" + resource_file_name + "/" + resource_file_name + ".tres", quad_x, strip_z, max_LOD_dist, section_mat)
		

func check_quads(player_pos : Vector2):
	#find the golbal coords of the quad in which the player is located
	#var player_quad_x = floor(player_pos.x / quad_size) * quad_size
	#var player_quad_z = floor(player_pos.y / quad_size) * quad_size
	var player_quad_x : int = floor(float(player_pos.x) / float(quad_size))# how many quads along the global X axis the player quad is
	var player_quad_z : int = floor(float(player_pos.y) / float(quad_size))# how many quads along the global Y axis the player quad is
	#TODO: a 512x512 terrain section that is far enough away can have a single LOD1 mesh and not show or check its 32x32 quads
	#if abs(player_quad_x - terr_quad_x) >= (section_size / quad_size) or abs(player_quad_z - terr_quad_z) >= (section_size / quad_size):
		##set the quads to direction none and LOD5
		#for strip_z in range(0, num_quad_strips):
			#for quad_x in range(0, num_quads_in_strip): 
				#terrain.get_child(strip_z).get_child(quad_x).set_dir_and_LOD(Vector2i(dirs.no_dir, LODs.LOD5))
	#else:
	#check the direction and LOD level for each quad and 
	#update the mesh if its current configuration does not match
	for strip_z in range(0, num_quad_strips):
		#var player_quad_dist_z : float = (terr_pos.y + float(strip_z)) - player_quad_z
		#var player_quad_dist_z : int = player_quad_z - terr_quad_z + strip_z # how many quads away the player is in the global Z direction
		for quad_x in range(0, num_quads_in_strip): 
			#var player_quad_dist_x : int = player_quad_x - terr_quad_x + quad_x # how many quads away the player is in the global X direction
			#first check if the current strip of quads is more than max LOD quads away from the quad
			#in which the player is located
			#if abs(player_quad_dist_z) >= max_LOD_dist:
				##this quad is far enough from the player to have a "none" direction and a LOD of 5
				#terrain.get_child(strip_z).get_child(quad_x).set_dir_and_LOD(Vector2i(dirs.no_dir, LODs.LOD5))
			#elif abs(player_quad_dist_x) >= max_LOD_dist:
				##this quad is far enough from the player to have a "none" direction and a LOD of 5
				#terrain.get_child(strip_z).get_child(quad_x).set_dir_and_LOD(Vector2i(dirs.no_dir, LODs.LOD5))
			#else:
				#terrain.get_child(strip_z).get_child(quad_x).check_dir_and_LOD(Vector2i(player_quad_x, player_quad_z))
			terrain.get_child(strip_z).get_child(quad_x).check_dir_and_LOD(Vector2i(player_quad_x, player_quad_z))	
				
