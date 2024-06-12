@tool
extends Resource
class_name  TerrainSectionData

@export var section_mat : ShaderMaterial
#var section_position : Vector2
#var height_data : PackedByteArray#should this be a PackedInt32Array?
@export var height_data : PackedFloat32Array
