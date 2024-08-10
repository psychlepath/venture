@tool
extends MeshInstance3D

var regd_in_glbls : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#Set the player variable in the singleton script for use with terrain rendering calculations etc
	GlblScrpt.register_player(self)

		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
