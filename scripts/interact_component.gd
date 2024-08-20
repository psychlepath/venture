extends Area3D

@export var label_type : int = 0
@onready var label_pos_marker = $label_pos_marker
@onready var label_child_scene = preload("res://scenes/interact_label.tscn")

func set_initial_input(mouse_rot: Vector2):
	add_label()
	if self.get_parent().has_method("set_initial_input"):
		self.get_parent().set_initial_input(mouse_rot)

func handle_input(mouse_rot: Vector2):
	if self.get_parent().has_method("handle_input"):
		self.get_parent().handle_input(mouse_rot)
	
func get_label_type() -> int:
	return label_type

func add_label():
	#print("adding label")
	remove_label()#remove any existing children
	var new_label : InteractLabelClass = label_child_scene.instantiate()
	label_pos_marker.add_child(new_label)
	new_label.set_icon(label_type)
	
func remove_label():
	for lbl in label_pos_marker.get_children():
		label_pos_marker.remove_child(lbl)
		lbl.queue_free()
