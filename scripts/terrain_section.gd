@tool
extends Node3D
class_name TerrainSection

@onready var quad_child_scene = preload("res://scenes/terrain_quad.tscn")
@export var section_data : Resource
@export var section_mat : ShaderMaterial
@export var update_heights : bool = false
@onready var quads_parent : Node3D = $quads_parent
@onready var quad_size : int = GlblScrpt.quad_size
@onready var section_size : int = GlblScrpt.terrain_section_size
@onready var num_quads_in_section : int = section_size/quad_size
@onready var section_pos : Vector2 = Vector2(self.global_position.x, self.global_position.z)
@onready var max_LOD_dist : int = GlblScrpt.max_LOD_dist_terrain
var terrain_manager

var resource_file_name = ""
# given the player position, use a series of 32x32 quads
# to calculate which of the 512 x 512 vertices make up 
# this terrain section's mesh.
# each 32x32 quad has a LOD and a direction
enum LODs {LOD0, LOD1, LOD2, LOD3, LOD4, LOD5}
# LOD0 = 1x1, LOD1 = 2x2, LOD2 = 4x4, LOD3 = 8x8, LOD4 = 16x16, LOD5 = 32x32 - this might not be practical with faraway excavations...
# find the distance of each quad to the quad in which the player is located
# find the direction from the player to each quad
enum dirs {no_dir, N, NE, E, SE, S, SW, W, NW}
# none : 0, N: 1, NE: 2, E: 3, SE: 4, S: 5, SW: 6, W: 7, NW: 8
# these two pieces of information will determine which
# vertices will be added to the VERTICES array to create
# this terrain section's mesh
var quads_created = false
var checking_quads : bool = false


func _process(_delta):
	if Engine.is_editor_hint():
		if update_heights == true:
			update_heights = false
			if GlblScrpt.terrain_manager != null:
				GlblScrpt.terrain_manager.update_section_centres_array()
			if section_data == null:
				print("please assign a data file for this terrain section")
				return
			if resource_file_name == "":
				resource_file_name = section_data.resource_path.get_file().trim_suffix('.tres')
			create_section_heights()

#editor only function? remove before shipping	
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
	#TODO: the heightmap stores data in the range of 0.0 to 1.0.
	# this allows for an altitude range of more than just 0.0 to 255.0 metres...
	#section_data.height_data = heightmap_image.get_data().to_float32_array()
	var heights_array = heightmap_image.get_data().to_float32_array()
	for h in range(0, heights_array.size()):
		#snappedf(3.14159, 0.1) trim floats to a single decimal point
		#section_data.height_data.append(snappedf(heights_array[h] * GlblScrpt.terrain_height_scale, 0.1))
		section_data.height_data.append(heights_array[h] * GlblScrpt.terrain_height_scale)
	#print("heights array length: ",  str(section_data.height_data.size()))
	section_data.section_mat = section_mat
	ResourceSaver.save(section_data, section_data.get_path(), 0)
	instantiate_quads()
	
func instantiate_quads() -> void:
	for quad_z in range(0, num_quads_in_section):
		for quad_x in range(0, num_quads_in_section):
			var new_quad : TerrainQuad32 = quad_child_scene.instantiate()
			quads_parent.add_child(new_quad)
			new_quad.global_position = Vector3(self.global_position.x + float(quad_x * quad_size), self.global_position.y, self.global_position.z + float(quad_z * quad_size))
			new_quad.init_quad(quad_x, quad_z)
	quads_created = true		
		
func check_quads():
	if checking_quads == false:
		checking_quads = true
		if quads_created == false:
			instantiate_quads()
		#find the golbal coords of the quad in which the player is located
		#var player_quad_x : float = floor(float(player_pos.x) / float(quad_size))
		#var player_quad_z : float = floor(float(player_pos.y) / float(quad_size))
		for quad in range(0, quads_parent.get_child_count()):
			#quads_parent.get_child(quad).check_dir_and_LOD(Vector2i(player_quad_x, player_quad_z))
			quads_parent.get_child(quad).check_dir_and_LOD()
		#TODO: a 512x512 terrain section that is far enough away can have a single LOD1 mesh and not show or check its 32x32 quads
		checking_quads = false
		
func get_resource_file():
	#var filepath = "res://terrain/" + resource_file_name + "/" + resource_file_name + ".tres"
	return section_data
