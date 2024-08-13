@tool
extends Resource
class_name  TerrainSectionData

@export var section_mat : ShaderMaterial
@export var section_height_scale : float
@export var height_data : PackedFloat32Array
@export var splatmap_width : int
@export var splatmap_height : int
@export var splatmap_uses_mipmaps : bool
@export var splatmap_format : Image.Format
@export var splatmap_data : PackedByteArray

