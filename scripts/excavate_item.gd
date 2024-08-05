extends Node3D

class_name ExcavateItem

@onready var detect_area : Area3D = $Area3D
@export var excavation_radius : float  = 1.0
#this area has detected an intersection with another object on Layer 9
func _on_area_3d_body_entered(body):
	#var excavation_point : Vector3 = Vector3(detect_area.global_position.x, detect_area.global_position.y - excavation_radius, detect_area.global_position.z)
	if body.is_in_group("terrain_quads"):
		body.get_parent().handle_excavation(self.global_position)
	if body.is_in_group("terrain_chunks"):
		body.get_parent().handle_excavation_sphere(self.global_position, excavation_radius)
