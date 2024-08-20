extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.enable_raycast()

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.disable_raycast()
