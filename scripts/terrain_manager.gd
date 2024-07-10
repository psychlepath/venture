@tool
extends Node3D

var regd_in_glbls : bool = false #check that the terrain manager variable in the global script points to this terrain manager
@export var terrain_section_scene : PackedScene
#@export var terrain_update_toggle : bool = false
var updating_terrain : bool = false
#var init_player_pos : Vector2 = Vector2(0.0, 0.0)
#var player_tile_pos : Vector2 = Vector2(0.0, 0.0)
var num_terrain_sections : int = 0
#var current_children_positions = []
var terrain_section_centres = []
var active_sections = [] 

func _ready():
	#TODO: remove this editor-specific code before shipping
	#if Engine.is_editor_hint():
		#
		#for sect in range(0, num_terrain_sections):
			##populate the array that keeps track of the global x,z position of each terrain section
			#var current_section = self.get_child(sect) 
			#current_children_positions.append(Vector2(current_section.global_position.x,current_section.global_position.z))
			#current_section.init_section()
	#
	if !Engine.is_editor_hint():
		num_terrain_sections = get_child_count()
		for sect in range(0, num_terrain_sections):
			#populate the array that keeps track of the global x,z position of the centre of each terrain section
			#var current_section = self.get_child(sect)
			var section_centre = Vector2(self.get_child(sect).global_position.x + (float(GlblScrpt.terrain_section_size) / 2.0), self.get_child(sect).global_position.z + (float(GlblScrpt.terrain_section_size) / 2.0))
			terrain_section_centres.append(section_centre)
			#current_children_positions.append(Vector2(current_section.global_position.x,current_section.global_position.z))
			#current_section.init_section()

func _process(_delta):
	if !regd_in_glbls:
		#Set the player variable in the singleton script for use with terrain rendering calculations etc
		GlblScrpt.terrain_manager = self
		if GlblScrpt.terrain_manager != null:
			regd_in_glbls = true
			# switch off process function once the check as to whether this node is registered
			# in the global script returns true
			self.set_process(false)

func update_terrain(player_pos : Vector2):
	#print(updating_terrain)
	if !updating_terrain:
		updating_terrain = true
		#TODO: start thread here
		active_sections.clear()
		var num_terrain_sections : int = get_child_count()
		#remove any terrain sections outside of the visual range of the player
		for sect in range(0, num_terrain_sections):
			#var section_centre = Vector2(current_children_positions[sect].x + (GlblScrpt.terrain_section_size / 2), current_children_positions[sect].y + (GlblScrpt.terrain_section_size / 2))
			#var section_centre = Vector2(self.get_child(sect).global_position.x + (float(GlblScrpt.terrain_section_size) / 2.0), self.get_child(sect).global_position.z + (float(GlblScrpt.terrain_section_size) / 2.0))
			var dist_from_player = terrain_section_centres[sect].distance_to(Vector2(player_pos.x, player_pos.y))
			if dist_from_player > GlblScrpt.terrain_view_range:
				disable_and_hide_node(self.get_child(sect))
			else:
				enable_and_show_node(self.get_child(sect))
				#keep track of which terrain sections are visible
				active_sections.append(sect)
		#print(active_sections.size())	
		for terr_sect in range(0, active_sections.size()):
			self.get_child(active_sections[terr_sect]).check_quads(player_pos)
		#TODO: wait for thread to finish
		updating_terrain = false

#keep track of the terrain sections' centres in the editor
func add_terrain_section_centre(section_pos : Vector2) -> void:
	terrain_section_centres.append(section_pos)

func disable_and_hide_node(node:Node) -> void:
	node.process_mode = 4 # = Mode: Disabled
	node.hide()

func enable_and_show_node(node:Node) -> void:
	node.process_mode = 0 # = Mode: Inherit
	node.show()
	
func get_terrain_section_index(section_centre_pos : Vector2) -> int:
	var terr_sect_index : int = -1
	for centre in range(0, self.get_child_count()):
		if section_centre_pos.x == terrain_section_centres[centre].x:
			if section_centre_pos.y == terrain_section_centres[centre].y:
				terr_sect_index = centre
	return terr_sect_index
