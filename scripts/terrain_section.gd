@tool
extends Node3D
class_name TerrainSection

@export var section_data : Resource
@export var section_mat : ShaderMaterial
@export var update_heights : bool = false
@onready var quad_child_scene = preload("res://scenes/terrain_quad.tscn")
@onready var quads_parent : Node3D = $quads_parent
@onready var quad_size : int = GlblScrpt.quad_size
@onready var section_size : int = GlblScrpt.terrain_section_size
@onready var num_quads_in_section : int = int(section_size/quad_size)
@onready var max_LOD_dist : int = GlblScrpt.max_LOD_dist_terrain
var section_pos : Vector2
var terrain_manager
var splatmap : ImageTexture = null
var splatmap_img : Image = null
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
#neighbouring terrain section centre positions in the following order: N, NE, E, SE, S, SW, W, NW
#var neighbouring_terrain_sections = [placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int]
var section_centre_N : Vector2
var section_centre_NE : Vector2
var section_centre_E : Vector2
var section_centre_SE : Vector2
var section_centre_S : Vector2
var section_centre_SW : Vector2
var section_centre_W : Vector2
var section_centre_NW : Vector2
var checking_quads : bool = false
var handling_excavation : bool = false

func _process(_delta):
	if GlblScrpt.terrain_manager != null:
		terrain_manager = GlblScrpt.terrain_manager
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
			create_section_data()


#editor only function? remove before shipping	
func create_section_data():
	section_pos = Vector2(self.global_position.x, self.global_position.z)
	#calculate the centres of the neighbouring terrain sections
	section_centre_N = Vector2(section_pos.x + float(section_size / 2), section_pos.y - float(section_size / 2))
	section_centre_NE = Vector2(section_pos.x + (float(section_size) * 1.5), section_pos.y - float(section_size / 2))
	section_centre_E = Vector2(section_pos.x + (float(section_size) * 1.5), section_pos.y + float(section_size / 2))
	section_centre_SE = Vector2(section_pos.x + (float(section_size) * 1.5), section_pos.y + (float(section_size) * 1.5))
	section_centre_S = Vector2(section_pos.x + float(section_size / 2), section_pos.y + (float(section_size) * 1.5))
	section_centre_SW = Vector2(section_pos.x - float(section_size / 2), section_pos.y + (float(section_size) * 1.5))
	section_centre_W = Vector2(section_pos.x - float(section_size / 2), section_pos.y + float(section_size / 2))
	section_centre_NW = Vector2(section_pos.x - float(section_size / 2), section_pos.y - float(section_size / 2))
	
	#fill the resource file's 513x513 heights array from the heightmap
	#get the image file name from the resource file
	if resource_file_name == "":
		resource_file_name = section_data.resource_path.get_file().trim_suffix('.tres')
	var heightmap_file_name = resource_file_name + ".exr"
	var file_path = "res://terrain/heightmaps/" + heightmap_file_name
	var heightmap_image : Image = load(file_path)
	section_data.height_data.clear()
	heightmap_image.convert(Image.FORMAT_RF)#convert the red channel to float values
	#TODO: the heightmap stores data in the range of 0.0 to 1.0.
	# this allows for an altitude range of more than just 0.0 to 255.0 metres...
	var heights_array = heightmap_image.get_data().to_float32_array()
	for h in range(0, heights_array.size()):
		section_data.height_data.append(heights_array[h] * GlblScrpt.terrain_height_scale)
	#save the splatmap data to the resource file
	var splatmap_file_name = resource_file_name + ".png"
	file_path = "res://terrain/terrain_splatmaps/" + splatmap_file_name
	splatmap_img = load(file_path)
	splatmap = ImageTexture.create_from_image(splatmap_img)
	section_mat.set_shader_parameter("splatmap", splatmap)
	section_data.splatmap_width = splatmap_img.get_width()
	section_data.splatmap_height = splatmap_img.get_height()
	section_data.splatmap_uses_mipmaps = splatmap_img.has_mipmaps()
	section_data.splatmap_format = splatmap_img.get_format()
	section_data.splatmap_data = splatmap_img.get_data()
	ResourceSaver.save(section_data, section_data.get_path(), 0)
	instantiate_quads()

func instantiate_quads() -> void:
	#remove any existing children
	for q in quads_parent.get_children():
		quads_parent.remove_child(q)
		q.queue_free()
	#create the new quads
	var quad_idx = 0
	for quad_z in range(0, num_quads_in_section):
		for quad_x in range(0, num_quads_in_section):
			var new_quad : TerrainQuad32 = quad_child_scene.instantiate()
			quads_parent.add_child(new_quad)
			new_quad.global_position = Vector3(self.global_position.x + float(quad_x * quad_size), self.global_position.y, self.global_position.z + float(quad_z * quad_size))
			new_quad.init_quad(quad_x, quad_z, quad_idx)
	quads_created = true
		
func check_quads():
	if splatmap == null:
		splatmap_img = Image.create_from_data(section_data.splatmap_width, section_data.splatmap_height, section_data.splatmap_uses_mipmaps, section_data.splatmap_format, section_data.splatmap_data)
		splatmap = ImageTexture.create_from_image(splatmap_img)
		section_mat.set_shader_parameter("splatmap", splatmap)
	if checking_quads == false:
		checking_quads = true
		if quads_created == false:
			#update_section()
			instantiate_quads()
		quads_created = true
		#find the golbal coords of the quad in which the player is located
		#var player_quad_x : float = floor(float(player_pos.x) / float(quad_size))
		#var player_quad_z : float = floor(float(player_pos.y) / float(quad_size))
		for quad in range(0, quads_parent.get_child_count()):
			#quads_parent.get_child(quad).check_dir_and_LOD(Vector2i(player_quad_x, player_quad_z))
			quads_parent.get_child(quad).check_dir_and_LOD()
		#TODO: a 512x512 terrain section that is far enough away can have a single LOD1 mesh and not show or check its 32x32 quads
		checking_quads = false
		
func get_resource_file():
	return section_data


		
#update the height_data array and splatmap in the resource file
func handle_excavation(_excavator_pos : Vector3, _excavator_radius : float, _originating_section : bool) -> void:
	if handling_excavation:
		return
	handling_excavation = true
	#var excavated_verts
	#var neighbouring_verts
	var excavator_pos_in_section : Vector2 = Vector2(roundf(_excavator_pos.x - self.global_position.x), roundf(_excavator_pos.z - self.global_position.z))
	#var excavator_x_in_section : float = roundf(_excavator_pos.x - self.global_position.x)
	#var excavator_z_in_section : float = roundf(_excavator_pos.z - self.global_position.z)
	var verts_to_update_min_x : int = int(excavator_pos_in_section.x - _excavator_radius)
	var verts_to_update_min_z : int = int(excavator_pos_in_section.y - _excavator_radius)
	var verts_to_update_max_x : int = int(excavator_pos_in_section.x + _excavator_radius) + 1
	var verts_to_update_max_z : int = int(excavator_pos_in_section.y + _excavator_radius) + 1
	if verts_to_update_min_x < 0:
		verts_to_update_min_x = 0
		#excavator is close to the west side of the terrain section and will impinge on the terrain section to the West, if it exists
		#check that this is the terrain section in which the excavator is digging
		if _originating_section == true:
			#check that the neighbouring terrain section to the West exists
			var section_index_to_W : int = terrain_manager.get_terrain_section_index(section_centre_W)
			if section_index_to_W != GlblScrpt.placeholder_int:
				#tell the section to the West to handle excavation
				terrain_manager.get_child(section_index_to_W).handle_excavation(_excavator_pos, _excavator_radius, false)
			if verts_to_update_min_z < 0:
				#check that the neighbouring terrain section to the Norhtwest exists
				var section_index_to_NW : int = terrain_manager.get_terrain_section_index(section_centre_NW)
				if section_index_to_NW != GlblScrpt.placeholder_int:
					terrain_manager.get_child(section_index_to_NW).handle_excavation(_excavator_pos, _excavator_radius, false)
			if verts_to_update_max_z > section_size + 1:
				#check that the neighbouring terrain section to the Southwest exists
				var section_index_to_SW : int = terrain_manager.get_terrain_section_index(section_centre_SW)
				if section_index_to_SW != GlblScrpt.placeholder_int:
					terrain_manager.get_child(section_index_to_SW).handle_excavation(_excavator_pos, _excavator_radius, false)
	
	if verts_to_update_max_x > section_size + 1:
		verts_to_update_max_x = section_size + 1
		if _originating_section == true:
			#check that the neighbouring terrain section to the East exists
			var section_index_to_E : int = terrain_manager.get_terrain_section_index(section_centre_E)
			if section_index_to_E != GlblScrpt.placeholder_int:
				#tell the section to the East to handle excavation
				terrain_manager.get_child(section_index_to_E).handle_excavation(_excavator_pos, _excavator_radius, false)
			if verts_to_update_min_z < 0:
				#check that the neighbouring terrain section to the Norhteast exists
				var section_index_to_NE : int = terrain_manager.get_terrain_section_index(section_centre_NE)
				if section_index_to_NE != GlblScrpt.placeholder_int:
					terrain_manager.get_child(section_index_to_NE).handle_excavation(_excavator_pos, _excavator_radius, false)	
			if verts_to_update_max_z > section_size + 1:
				#check that the neighbouring terrain section to the Southeast exists
				var section_index_to_SE : int = terrain_manager.get_terrain_section_index(section_centre_SE)
				if section_index_to_SE != GlblScrpt.placeholder_int:
					terrain_manager.get_child(section_index_to_SE).handle_excavation(_excavator_pos, _excavator_radius, false)
				
	if verts_to_update_min_z < 0:
		verts_to_update_min_z = 0
		if _originating_section == true:
			#check if the neighbouring terrain section to the North exists
			var section_index_to_N : int = terrain_manager.get_terrain_section_index(section_centre_N)
			if section_index_to_N != GlblScrpt.placeholder_int:
				terrain_manager.get_child(section_index_to_N).handle_excavation(_excavator_pos, _excavator_radius, false)
				
	if verts_to_update_max_z > section_size + 1:
		verts_to_update_max_z = section_size + 1
		if _originating_section == true:
			#check if the neighbouring terrain section to the North exists
			var section_index_to_S : int = terrain_manager.get_terrain_section_index(section_centre_S)
			if section_index_to_S != GlblScrpt.placeholder_int:
				terrain_manager.get_child(section_index_to_S).handle_excavation(_excavator_pos, _excavator_radius, false)

	#iterate over the rectangle of heights and change only the ones that are within the radius of the excavator item
	
	for hz in range(verts_to_update_min_z, verts_to_update_max_z):
		for hx in range(verts_to_update_min_x, verts_to_update_max_x):
			#only change the heights that are actually inside the radius
			if Vector2(float(hx), float(hz)).distance_to(excavator_pos_in_section) <= _excavator_radius:
				#var hv = ((verts_to_update_min_z + hz) * section_size + 1) + verts_to_update_min_x + hx
				var hv = (hz * (section_size + 1)) + hx
				section_data.height_data[hv] = _excavator_pos.y
				#update the splatmap to show excavation material at the site of the excavation
				var pixel_x = (hx / float(section_size + 1)) * float(section_size)
				var pixel_y = (hz / float(section_size + 1)) * float(section_size)
				splatmap_img.set_pixel(pixel_x, pixel_y, Color.BLACK)
	
	splatmap.update(splatmap_img)
	
	
	#iterate over the affected quads and force them to recreate their meshes by setting their current LOD to 5
	var min_quad_z : int = verts_to_update_min_z / quad_size
	var min_quad_x : int = verts_to_update_min_x / quad_size
	var max_quad_z : int = verts_to_update_max_z / quad_size
	var max_quad_x : int = verts_to_update_max_x / quad_size
	##use ResourceSaver to make the changes persist
	#ResourceSaver.save(section_data, section_data.get_path(), 0)
	
	for qz in range(min_quad_z, max_quad_z + 1):
		for qx in range(min_quad_x, max_quad_x + 1):
			var quad_idx = (qz * num_quads_in_section) + qx
			quads_parent.get_child(quad_idx).set_LOD(LODs.LOD5)
			quads_parent.get_child(quad_idx).check_dir_and_LOD()
			
	#TODO: use a save manager to make the changes persist
	#ResourceSaver.save(section_data, section_data.get_path(), 0)
	handling_excavation = false


func get_section_material() -> ShaderMaterial:
	return section_mat

