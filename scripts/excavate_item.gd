extends Node3D

class_name ExcavateItem

@onready var excavation_point = $excavation_point
#@onready var detect_area : Area3D = $Area3D
@export var excavation_radius : float = 3.0

#var digging_desirable : bool = false
#this area has detected an intersection with another object on Layer 9
func _on_area_3d_body_entered(body):
	#if digging_desirable == false:
		#return
	if body.is_in_group("terrain_quads"):
		#print("excavating quad mesh")
		body.get_parent().handle_excavation(excavation_point.global_position, excavation_radius)

