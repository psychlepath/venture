@tool
extends Node3D

class_name ExcavateItem

@onready var detect_area : Area3D = $Area3D
@export var excavation_radius : float  = 1.0
#this area has detected an intersection with another object on Layer 9
func _on_area_3d_body_entered(body):
	var excavation_point : Vector3 = Vector3(detect_area.global_position.x, detect_area.global_position.y - excavation_radius, detect_area.global_position.z)
	body.get_parent().handle_excavation(excavation_point)
