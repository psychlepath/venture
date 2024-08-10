@tool
extends Node3D

func _ready():
	GlblScrpt.register_player(self)

func get_player_pos() -> Vector2:
	return Vector2(self.global_position.x, self.global_position.z)
