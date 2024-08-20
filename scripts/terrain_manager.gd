@tool
extends Node3D

var updating_terrain : bool = false
var num_terrain_sections : int = 0
var terrain_section_centres = []
var active_sections = [] 
var player = null
var current_player_quad_pos : Vector2 = Vector2(-10.0, -10.0)
var quad_size = GlblScrpt.quad_size

func _ready():
	GlblScrpt.register_terrain_manager(self)
	num_terrain_sections = self.get_child_count()
	if num_terrain_sections > 0:
		terrain_section_centres.clear()
		for sect in range(0, num_terrain_sections):
			#populate the array that keeps track of the global x,z position of the centre of each terrain section
			var section_centre = Vector2(self.get_child(sect).global_position.x + (float(GlblScrpt.terrain_section_size) / 2.0), self.get_child(sect).global_position.z + (float(GlblScrpt.terrain_section_size) / 2.0))
			terrain_section_centres.append(section_centre)
			self.get_child(sect).create_section_data()
			

func _process(_delta):
	if player == null:
		player = GlblScrpt.player
	var new_player_pos : Vector2 = player.get_player_pos()
	if floor(new_player_pos.x / float(quad_size)) != current_player_quad_pos.x:
		current_player_quad_pos.x = floor(new_player_pos.x / float(quad_size))
		current_player_quad_pos.y = floor(new_player_pos.y / float(quad_size))
		update_terrain(new_player_pos)
		return
	if floor(new_player_pos.y / float(quad_size)) != current_player_quad_pos.y:
		current_player_quad_pos.x = floor(new_player_pos.x / float(quad_size))
		current_player_quad_pos.y = floor(new_player_pos.y / float(quad_size))
		update_terrain(new_player_pos)

func update_terrain(player_pos : Vector2):
	if !Engine.is_editor_hint():
		if updating_terrain == false:
			updating_terrain = true
			#TODO: start thread here
			active_sections.clear()
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
				self.get_child(active_sections[terr_sect]).check_quads()
			#TODO: wait for thread to finish
			updating_terrain = false
	if Engine.is_editor_hint():
		num_terrain_sections = get_child_count()
		if num_terrain_sections > 0:
			if updating_terrain == false:
				updating_terrain = true
				#TODO: start thread here
				active_sections.clear()
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
					self.get_child(active_sections[terr_sect]).check_quads()
				#TODO: wait for thread to finish
				updating_terrain = false

func disable_and_hide_node(node:Node) -> void:
	#node.process_mode = 4 # = Mode: Disabled
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()

func enable_and_show_node(node:Node) -> void:
	#node.process_mode = 0 # = Mode: Inherit
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()
	
func get_terrain_section_index(section_centre_pos : Vector2) -> int:
	var terr_sect_index : int = -1
	for centre in range(0, self.get_child_count()):
		if section_centre_pos.x == terrain_section_centres[centre].x:
			if section_centre_pos.y == terrain_section_centres[centre].y:
				terr_sect_index = centre
	return terr_sect_index

func update_section_centres_array():
	num_terrain_sections = self.get_child_count()
	if num_terrain_sections > 0:
		terrain_section_centres.clear()
		for sect in range(0, num_terrain_sections):
			#update the array that keeps track of the global x,z position of the centre of each terrain section
			var section_centre = Vector2(self.get_child(sect).global_position.x + (float(GlblScrpt.terrain_section_size) / 2.0), self.get_child(sect).global_position.z + (float(GlblScrpt.terrain_section_size) / 2.0))
			terrain_section_centres.append(section_centre)
