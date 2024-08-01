extends Node3D
#voxels using Naive Surface Net algorithm
class_name TerrainChunkSurfaceNet

@onready var mesh_inst = $MeshInstance3D
@onready var coll_shape = $StaticBody3D/CollisionShape3D
@onready var chunk_size : int = GlblScrpt.chunk_size
@onready var terrain_section_size : float = float(GlblScrpt.terrain_section_size)


var chunk_height_verts = [
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
	[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
]
#Y then Z then X ????????????
var chunk_ones_zeroes = [
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	],
	[
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1],
		[1,1,1,1,1,1,1,1,1,1]
	]
]
var chunk_ones_zeroes_size : int = 0
var cube_vert_offsets = [
	Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(1,0,1), Vector3i(0,0,1),
	Vector3i(0,1,0), Vector3i(1,1,0), Vector3i(1,1,1), Vector3i(0,1,1)
]
var cube_edges = [
	Vector2i(0,1), Vector2i(1,2), Vector2i(2,3), Vector2i(3,0),
	Vector2i(4,5), Vector2i(5,6), Vector2i(6,7), Vector2i(7,4),
	Vector2i(0,4), Vector2i(1,5), Vector2i(2,6), Vector2i(3,7)	
]

var verts_inside_voxels = [
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	],
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	],
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	],
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	],
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	],
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	],
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	],
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	],
	[
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
		[Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),Vector3(0.0,0.0,0.0),],
	]
	
]

var verts_in_chunk : bool = false #Controls whether or not there is any need to create a mesh for this chunk
var num_verts_in_chunk : int = 0 #TODO: combine with verts_in_chunk variable for greater efficiency?
var isosurface : float = 0.0
var verts : PackedVector3Array = []
var uvs : PackedVector2Array = []
var indices : PackedInt32Array = []
#var chunk_edges_5_6_10 = []
var placeholder_vector = Vector3(-1,-1,-1)#used to track whether or not an array index has been used 
var placeholder_int : int = -2
var placeholder_float : float = 2.0

var a_mesh : ArrayMesh
var coll_shape_shape : ConcavePolygonShape3D

var chunk_pos : Vector3 = Vector3(0.0, 0.0, 0.0)
var terrain_mat : ShaderMaterial
var terrain_section_index : int
var chunk_location_in_terrain_section : Vector2i
#identifiers for the terrain sections containing the neighbouring chunks
var chunk_to_E_terr_sect_idx : int = -1
var chunk_to_SE_terr_sect_idx : int = -1
var chunk_to_S_terr_sect_idx : int = -1
#handles to the parent quad of this chunk and the parent quads of neighbouring chunks
var parent_quad = null
var chunk_to_E_quad = null
var chunk_to_SE_quad = null
var chunk_to_S_quad = null
#handles to neighbouring chunks
var chunk_to_E = null
var chunk_to_E_up = null
var chunk_to_SE = null
var chunk_to_SE_up = null
var chunk_to_S = null
var chunk_to_S_up = null
var chunk_above = null
#handles to the positions of the surrounding chunks
var chunk_to_E_pos : Vector3
var chunk_to_E_up_pos : Vector3
var chunk_to_SE_pos : Vector3
var chunk_to_SE_up_pos : Vector3
var chunk_to_S_pos : Vector3
var chunk_to_S_up_pos : Vector3
var chunk_above_pos : Vector3
#handles to resource files containing height and material data for this and neighbouring chunks
var current_resource_file = null
var this_resource_filename = null
var resource_east_filename = null #does this need to be a global variable?
var resource_southeast_filename = null #does this need to be a global variable?
var resource_south_filename = null #does this need to be a global variable?

func init_chunk(_chunk_pos : Vector3):
	chunk_ones_zeroes_size = chunk_ones_zeroes.size()
	coll_shape_shape = ConcavePolygonShape3D.new()
	coll_shape.shape = coll_shape_shape
	chunk_pos = _chunk_pos
	self.global_position = chunk_pos
	var chunk_x_in_section = fmod(chunk_pos.x, terrain_section_size)
	var chunk_z_in_section = fmod(chunk_pos.z, terrain_section_size)
	chunk_location_in_terrain_section = Vector2i(int(chunk_x_in_section), int(chunk_z_in_section))
	#calculate which terrain section the chunk is in
	terrain_section_index = get_terr_section_index(chunk_pos)
	parent_quad = get_quad(chunk_pos, terrain_section_index)
	chunk_to_E_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z)
	chunk_to_E_up_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y + float(chunk_size), chunk_pos.z)
	chunk_to_SE_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z + float(chunk_size))
	chunk_to_SE_up_pos = Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y + float(chunk_size), chunk_pos.z + float(chunk_size))
	chunk_to_S_pos = Vector3(chunk_pos.x, chunk_pos.y, chunk_pos.z + float(chunk_size))
	chunk_to_S_up_pos = Vector3(chunk_pos.x, chunk_pos.y + float(chunk_size), chunk_pos.z + float(chunk_size))
	chunk_above_pos = Vector3(chunk_pos.x, chunk_pos.y + float(chunk_size), chunk_pos.z)
	
	#this allows the chunk to find the right resource file to access the heights data needed to
	#populate the chunk_ones_zeroes array
	this_resource_filename = get_section_resource_filename(chunk_pos)
	var path_to_section_data = "res://terrain/" + this_resource_filename + "/" + this_resource_filename + ".tres"
	current_resource_file = load(path_to_section_data)
	#TODO: assign the correct material to match this chunk's parent quad and terrain section
	#TODO: also allow for setting of a triplanar material for excavated areas
	#possibly a second shadermaterial in the section's resource file?
	terrain_mat = current_resource_file.section_mat
	#get the first 9x9 verts representing the heightmap heights for this chunk
	for height_z in range(0, chunk_size + 1):
		for height_x in range(0, chunk_size + 1):
			var height_offset_z : int = floor((chunk_location_in_terrain_section.y + height_z) * (terrain_section_size + 1))
			var height_offset_x : int = chunk_location_in_terrain_section.x + height_x
			chunk_height_verts[height_z][height_x] = current_resource_file.height_data[height_offset_z + height_offset_x]
		#insert placeholder heights in the last column in case there is no neighbouring chunk to the East 
		chunk_height_verts[height_z][chunk_size + 1] = chunk_height_verts[height_z][chunk_size]
	#insert placeholder heights in the last row in case there is no neighbouring chunk to the South
	for s_heights in range(0, chunk_size + 2):
		chunk_height_verts[chunk_size + 1][s_heights] = chunk_height_verts[chunk_size][s_heights]


func handle_excavation(excavator_pos : Vector3, excavator_size : float) -> void:
	#TODO: allow for different shapes...
	#calculate the effect on the chunk_ones_zeroes array of the excavator's shape
	if chunk_ones_zeroes != null:
		for vert_y in range(0, chunk_ones_zeroes_size):
			for vert_z in range(0, chunk_ones_zeroes_size):
				for vert_x in range(0, chunk_ones_zeroes_size):
					#is this cube vertex inside the excavator shape?
					var vertex_global_pos = Vector3(chunk_pos.x + float(vert_x), chunk_pos.y + float(vert_y), chunk_pos.z + float(vert_z))
					if vertex_global_pos.distance_to(excavator_pos) < excavator_size:
						chunk_ones_zeroes[vert_y][vert_z][vert_x] = 1.0
	#TODO: update the data relating to the neighbouring chunks to East, Southeast, South and above
	update_chunk_ones_zeroes()
	create_chunk_mesh()

#calculate the filename of the resource containing the terrain section's height data etc.
func get_section_resource_filename(_chunk_pos : Vector3) -> String:
	var x_string : String = ""
	var terr_sect_x : int = floor(chunk_pos.x / terrain_section_size)
	if terr_sect_x > 9 or terr_sect_x < -9:
		x_string = "x" + str(terr_sect_x)
	elif terr_sect_x < 0 and terr_sect_x > -10:
		x_string = "x-0" + str(terr_sect_x)
	else:
		x_string = "x0" + str(terr_sect_x)
	var z_string : String = ""
	var terr_sect_z : int = floor(chunk_pos.z  / terrain_section_size)
	if terr_sect_z > 9 or terr_sect_z < -9:
		z_string = "z" + str(terr_sect_z)
	elif terr_sect_z < 0 and terr_sect_z > -10:
		z_string = "z-0" + str(terr_sect_z)
	else:
		z_string = "z0" + str(terr_sect_z)
	return x_string + z_string

func get_terr_section_index(_chunk_pos : Vector3) -> int:
	var current_index = -1
	var terr_section_x = floor(_chunk_pos.x / float(GlblScrpt.terrain_section_size))
	var terr_section_centre_x = terr_section_x + (float(GlblScrpt.terrain_section_size) / 2.0)
	var terr_section_z = floor(_chunk_pos.z / float(GlblScrpt.terrain_section_size))
	var terr_section_centre_z = terr_section_z + (float(GlblScrpt.terrain_section_size) / 2.0)
	if GlblScrpt.terrain_manager:
		return GlblScrpt.terrain_manager.get_terrain_section_index(Vector2(terr_section_centre_x, terr_section_centre_z))
	return current_index
	
func get_quad(_chunk_pos, _terr_sect_idx):
	var current_quad = null
	var quad_z : int = floor(fmod(_chunk_pos.z, float(GlblScrpt.terrain_section_size)) / float(GlblScrpt.quad_size))
	var quad_x : int = floor(fmod(_chunk_pos.x, float(GlblScrpt.terrain_section_size)) / float(GlblScrpt.quad_size))
	if GlblScrpt.terrain_manager:
		current_quad = GlblScrpt.terrain_manager.get_child(_terr_sect_idx).terrain.get_child(quad_z).get_child(quad_x)
	return current_quad

#replace the placeholder values on the East, Southeast and South edges of the chunk_height_verts array
func update_initial_chunk_heights():
	#get handles to the surrounding chunks, quads, and terrain sections, as required.
	#East
	chunk_to_E_terr_sect_idx = get_terr_section_index(chunk_to_E_pos)
	if chunk_to_E_terr_sect_idx != -1:
		chunk_to_E_quad = get_quad(chunk_to_E_pos, chunk_to_E_terr_sect_idx)
		if chunk_to_E_quad != null:
			if chunk_to_E_quad.check_has_voxels() == true:
				chunk_to_E = chunk_to_E_quad.get_chunk_at_position(chunk_to_E_pos)
				
	#East one level up
	if chunk_to_E_quad != null:
		if chunk_to_E_quad.check_has_voxels() == true:
			chunk_to_E_up = chunk_to_E_quad.get_chunk_at_position(chunk_to_E_up_pos)
				
	#Southeast
	chunk_to_SE_terr_sect_idx = get_terr_section_index(chunk_to_SE_pos)
	if chunk_to_SE_terr_sect_idx != -1:
		chunk_to_SE_quad = get_quad(chunk_to_SE_pos, chunk_to_SE_terr_sect_idx)
		if chunk_to_SE_quad != null:
			if chunk_to_SE_quad.check_has_voxels() == true:
				chunk_to_SE = chunk_to_SE_quad.get_chunk_at_position(chunk_to_SE_pos)
				
	#Southeast one level up
	if chunk_to_SE_quad != null:
		if chunk_to_SE_quad.check_has_voxels() == true:
			chunk_to_SE_up = chunk_to_SE_quad.get_chunk_at_position(chunk_to_SE_up_pos)
	
	#South
	chunk_to_S_terr_sect_idx = get_terr_section_index(chunk_to_S_pos)
	if chunk_to_S_terr_sect_idx != -1:
		chunk_to_S_quad = get_quad(chunk_to_S_pos, chunk_to_S_terr_sect_idx)
		if chunk_to_S_quad != null:
			if chunk_to_S_quad.check_has_voxels() == true:
				chunk_to_S = chunk_to_S_quad.get_chunk_at_position(chunk_to_S_pos)
				
	#South one level up
	if chunk_to_S_quad != null:
		if chunk_to_S_quad.check_has_voxels() == true:
			chunk_to_S_up = chunk_to_S_quad.get_chunk_at_position(chunk_to_S_up_pos)
	
	#the chunk directly above this chunk
	chunk_above = parent_quad.get_chunk_at_position(chunk_above_pos)
	
	var path_to_section_data : String = ""
	var resource_file = null
	#start with the heights to the East
	if chunk_to_E_terr_sect_idx != null:
		if resource_east_filename == null:
			resource_east_filename = get_section_resource_filename(Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z))
		path_to_section_data = "res://terrain/" + resource_east_filename + "/" + resource_east_filename + ".tres"
		resource_file = load(path_to_section_data)
		if resource_file != null:
			for e_height in range(0, chunk_size + 1):
				var height_z : int = int(fmod(chunk_to_E_pos.z + float(e_height), terrain_section_size) * (terrain_section_size + 1.0))
				var height_x : int = 1
				chunk_height_verts[e_height][chunk_size + 1] = resource_file.height_data[height_z + height_x]
			resource_file = null
			
	#heights to the Southeast
	if chunk_to_SE_terr_sect_idx != null:
		if resource_southeast_filename == null:
			resource_southeast_filename = get_section_resource_filename(Vector3(chunk_pos.x + float(chunk_size), chunk_pos.y, chunk_pos.z + float(chunk_size)))	
		path_to_section_data = "res://terrain/" + resource_southeast_filename + "/" + resource_southeast_filename + ".tres"
		resource_file = load(path_to_section_data)
		if resource_file != null:
			var height_z : int = int(fmod(chunk_to_SE_pos.z + 1.0, terrain_section_size) * (terrain_section_size + 1.0))
			var height_x : int = 1
			chunk_height_verts[chunk_size + 1][chunk_size + 1] = resource_file.height_data[height_z + height_x]
		resource_file = null
	
	#heights to the South
	if chunk_to_S_terr_sect_idx != null:
		if resource_south_filename == null:
			resource_south_filename = get_section_resource_filename(Vector3(chunk_pos.x, chunk_pos.y, chunk_pos.z + float(chunk_size)))	
		path_to_section_data = "res://terrain/" + resource_south_filename + "/" + resource_south_filename + ".tres"
		resource_file = load(path_to_section_data)
		if resource_file != null:
			var height_z : int = int(fmod(chunk_to_S_pos.z + 1.0, terrain_section_size) * (terrain_section_size + 1.0))
			for s_height in range(0, chunk_size + 1):
				chunk_height_verts[chunk_size + 1][s_height] = resource_file.height_data[height_z + s_height]
		resource_file = null
	init_chunk_ones_zeroes()
		
#assign a "1" or a "0" to each vertex of each voxel cube, depending on whether it is in the air or in the ground
#TODO: make sure that the 1 is in the air and the 0 is in the ground.
func init_chunk_ones_zeroes():
	for cube_y in range(0, chunk_ones_zeroes_size):
		for cube_z in range(0, chunk_ones_zeroes_size):
			for cube_x in range(0, chunk_ones_zeroes_size):
				if chunk_pos.y + float(cube_y) <= chunk_height_verts[cube_z][cube_x]:
					chunk_ones_zeroes[cube_y][cube_z][cube_x] = 0
				else:
					chunk_ones_zeroes[cube_y][cube_z][cube_x] = 1
	create_chunk_mesh()

#check to East, Southeast, South and one level up to make sure that the chunk cube verts array is up to date
func update_chunk_ones_zeroes():
	var neighbouring_cube_verts = []
	var chunk_found : bool = false
	var resource_file
	#check for the chunk to the East and East one level up
	if chunk_to_E_terr_sect_idx != -1:
		if chunk_to_E_quad != null:
			if chunk_to_E_quad.has_voxels() == true:
				if chunk_to_E == null:
					chunk_to_E_quad.get_chunk_at_position(chunk_to_E_pos)
				if chunk_to_E != null:
					chunk_found = true
					neighbouring_cube_verts = chunk_to_E.get_western_cube_verts()
					# insert these ones and zeroes into the chunk cube verts array
					for vert_y in range(0, chunk_ones_zeroes_size):
						for vert_z in range(0, chunk_ones_zeroes_size):
							chunk_ones_zeroes[vert_y][vert_z][chunk_ones_zeroes_size - 1] = neighbouring_cube_verts[(vert_y * chunk_ones_zeroes_size) + vert_z]
				#check for the chunk to the East and one level up
				neighbouring_cube_verts.clear()
				if chunk_to_E_up == null:
					chunk_to_E_quad.get_chunk_at_position(chunk_to_E_up_pos)
				if chunk_to_E_up != null:
					chunk_found = true
					neighbouring_cube_verts = chunk_to_E_up.get_western_cube_verts_down()
					# insert these ones and zeroes into the chunk cube verts array
					for vert_z in range(0, chunk_ones_zeroes_size):
						chunk_ones_zeroes[chunk_ones_zeroes_size - 1][vert_z][chunk_ones_zeroes_size - 1] = neighbouring_cube_verts[vert_z]
		#if there is no voxel cube data for the chunk to the East, use the heights instead. 
		if chunk_found == false and chunk_to_E_terr_sect_idx != -1:
			resource_file = load("res://terrain/" + resource_east_filename + "/" + resource_east_filename + ".tres")
			for e_height in range(0, chunk_size + 1):
				var height_z : int = int(fmod(chunk_to_E_pos.z + float(e_height), terrain_section_size) * (terrain_section_size + 1.0))
				var height_x : int = 1
				chunk_height_verts[e_height][chunk_size + 1] = resource_file.height_data[height_z + height_x]
			#TODO: kludge what happens when this chunk is excavated near its border with the chunk to the East...
			#update the ones and zeroes in the eastern slice of the cube verts array with reference to the height data of the chunk to the East's terrain_section resource file
			for vert_y in range(0, chunk_ones_zeroes_size):
				for vert_z in range(0, chunk_ones_zeroes_size):
					if chunk_pos.y + float(vert_y) > chunk_height_verts[vert_z][chunk_ones_zeroes_size - 1]:
						chunk_ones_zeroes[vert_y][vert_z][chunk_ones_zeroes_size - 1] = 1
					else:
						chunk_ones_zeroes[vert_y][vert_z][chunk_ones_zeroes_size - 1] = 0	
	
	
	#check for the chunk to the Southeast and Southeast one level up
	neighbouring_cube_verts.clear()
	resource_file = null
	chunk_found = false
	if chunk_to_SE_terr_sect_idx != -1:
		if chunk_to_SE_quad != null:
			if chunk_to_SE_quad.has_voxels() == true:
				if chunk_to_SE == null:
					chunk_to_SE_quad.get_chunk_at_position(chunk_to_SE_pos)
				if chunk_to_SE != null:
					chunk_found = true
					neighbouring_cube_verts = chunk_to_SE.get_northwestern_cube_verts()
					# insert these ones and zeroes into the chunk cube verts array
					for vert_y in range(0, chunk_ones_zeroes_size):
						chunk_ones_zeroes[vert_y][chunk_ones_zeroes_size - 1][chunk_ones_zeroes_size - 1] = neighbouring_cube_verts[vert_y]
				#check for the chunk to the Southeast and one level up
				neighbouring_cube_verts.clear()
				if chunk_to_SE_up == null:
					chunk_to_SE_quad.get_chunk_at_position(chunk_to_SE_up_pos)
				if chunk_to_SE_up != null:
					chunk_found = true
					neighbouring_cube_verts = chunk_to_SE_up.get_northwestern_cube_verts_down()
					# insert this one or zero into the chunk cube verts array
					chunk_ones_zeroes[chunk_ones_zeroes_size - 1][chunk_ones_zeroes_size - 1][chunk_ones_zeroes_size - 1] = neighbouring_cube_verts[0]
		#if there is no voxel cube data for the chunk to the Southeast, use the heights instead. 
		if chunk_found == false and chunk_to_SE_terr_sect_idx != -1:
			resource_file = load("res://terrain/" + resource_southeast_filename + "/" + resource_southeast_filename + ".tres")
			for s_height in range(0, chunk_size + 1):
				var height_z : int = int(fmod(chunk_to_S_pos.z + float(chunk_size + 1), terrain_section_size) * (terrain_section_size + 1.0))
				chunk_height_verts[chunk_size + 1][s_height] = resource_file.height_data[height_z + s_height]
			#TODO: kludge what happens when this chunk is excavated near its border with the chunk to the South...
			#update the ones and zeroes in the Southern slice of the cube verts array with reference to the height data of the chunk to the South's terrain_section resource file
			for vert_y in range(0, chunk_ones_zeroes_size):
				for vert_x in range(0, chunk_ones_zeroes_size):
					if chunk_pos.y + float(vert_y) > chunk_height_verts[chunk_ones_zeroes_size - 1][vert_x]:
						chunk_ones_zeroes[vert_y][chunk_ones_zeroes_size - 1][vert_x] = 1
					else:
						chunk_ones_zeroes[vert_y][chunk_ones_zeroes_size - 1][vert_x] = 0	
	
	#check for the chunk to the South and South one level up
	neighbouring_cube_verts.clear()
	resource_file = null
	chunk_found = false
	if chunk_to_S_terr_sect_idx != -1:
		if chunk_to_S_quad != null:
			if chunk_to_S_quad.has_voxels() == true:
				if chunk_to_S == null:
					chunk_to_S_quad.get_chunk_at_position(chunk_to_S_pos)
				if chunk_to_S != null:
					chunk_found = true
					neighbouring_cube_verts = chunk_to_S.get_northern_cube_verts()
					# insert these ones and zeroes into the chunk cube verts array
					for vert_y in range(0, chunk_ones_zeroes_size):
						for vert_x in range(0, chunk_ones_zeroes_size):
							chunk_ones_zeroes[vert_y][chunk_ones_zeroes_size - 1][vert_x] = neighbouring_cube_verts[(vert_y * chunk_ones_zeroes_size) + vert_x]
				#check for the chunk to the South and one level up
				neighbouring_cube_verts.clear()
				if chunk_to_S_up == null:
					chunk_to_S_quad.get_chunk_at_position(chunk_to_S_up_pos)
				if chunk_to_S_up != null:
					chunk_found = true
					neighbouring_cube_verts = chunk_to_S_up.get_northern_cube_verts_down()
					# insert these ones and zeroes into the chunk cube verts array
					for vert_x in range(0, chunk_ones_zeroes_size):
						chunk_ones_zeroes[chunk_ones_zeroes_size - 1][chunk_ones_zeroes_size - 1][vert_x] = neighbouring_cube_verts[vert_x]
		#if there is no voxel cube data for the chunk to the South, use the heights instead. 
		if chunk_found == false and chunk_to_S_terr_sect_idx != -1:
			resource_file = load("res://terrain/" + resource_south_filename + "/" + resource_south_filename + ".tres")
			for s_height in range(0, chunk_size + 1):
				var height_z : int = int(fmod(chunk_to_S_pos.z + float(chunk_size + 1), terrain_section_size) * (terrain_section_size + 1.0))
				chunk_height_verts[chunk_size + 1][s_height] = resource_file.height_data[height_z + s_height]
			#TODO: kludge what happens when this chunk is excavated near its border with the chunk to the South...
			#update the ones and zeroes in the Southern slice of the cube verts array with reference to the height data of the chunk to the South's terrain_section resource file
			for vert_y in range(0, chunk_ones_zeroes_size):
				for vert_x in range(0, chunk_ones_zeroes_size):
					if chunk_pos.y + float(vert_y) > chunk_height_verts[chunk_ones_zeroes_size - 1][vert_x]:
						chunk_ones_zeroes[vert_y][chunk_ones_zeroes_size - 1][vert_x] = 1
					else:
						chunk_ones_zeroes[vert_y][chunk_ones_zeroes_size - 1][vert_x] = 0	
	
	#check for the chunk one level up
	neighbouring_cube_verts.clear()
	resource_file = null
	chunk_found = false
	if chunk_above == null:
		parent_quad.get_chunk_at_position(chunk_above_pos)
	if chunk_above != null:
		neighbouring_cube_verts = chunk_above.get_bottom_verts()
		# insert these ones and zeroes into the chunk cube verts array
		for vert_z in range(0, chunk_ones_zeroes_size):
			for vert_x in range(0, chunk_ones_zeroes_size):
				chunk_ones_zeroes[chunk_ones_zeroes_size - 1][vert_z][vert_x] = neighbouring_cube_verts[vert_z * chunk_ones_zeroes_size + vert_x]
	
			
func create_chunk_mesh():
	var edges_5_6_10 = [
		[
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		],
		[
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		],
		[	
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		],
		[
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		],
		[
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		],
		[
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		],
		[
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		],
		[
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		],
		[
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)],
			[Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2), Vector3i(-2,-2,-2)]
		]
	]
	var voxel_inidces = [
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		],
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		],
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		],
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		],
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		],
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		],
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		],
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		],
		[
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2],
			[-2,-2,-2,-2,-2,-2,-2,-2,-2]
		]
	]
	var current_vert_index = 0
	#iterate over each of the voxel cubes in the chunk
	verts_in_chunk = false
	for voxel_y in range(0, chunk_ones_zeroes_size - 1):
		for voxel_z in range(0, chunk_ones_zeroes_size - 1):
			for voxel_x in range(0, chunk_ones_zeroes_size - 1):
				var this_cube_verts_ones_zeroes = []#keep track of the one or zero associated with each of the cube's 8 vertices
				var this_cube_verts_global_positions = []
				#find the location of the voxel's origin inside the chunk
				var voxel_origin_in_chunk : Vector3i = Vector3i(voxel_x, voxel_y, voxel_z)
				#find the global location of the voxel's origin
				var voxel_origin_global : Vector3 = Vector3(chunk_pos.x + float(voxel_x), chunk_pos.y + float(voxel_y), chunk_pos.z + float (voxel_z))
				#store the chunk-relative locations of all 8 of the voxel's vertices
				for offset in range(0, cube_vert_offsets.size()):
					var x_offset = voxel_origin_in_chunk.x + cube_vert_offsets[offset].x
					var y_offset = voxel_origin_in_chunk.y + cube_vert_offsets[offset].y
					var z_offset = voxel_origin_in_chunk.z + cube_vert_offsets[offset].z
					#populate the array holding ones and zeroes for this cube
					this_cube_verts_ones_zeroes.append(chunk_ones_zeroes[y_offset][z_offset][x_offset])
					this_cube_verts_global_positions.append(voxel_origin_global + Vector3(float(cube_vert_offsets[offset].x), float(cube_vert_offsets[offset].y), float(cube_vert_offsets[offset].z)))
				#check whether any of the voxel's edges is intersected by the isosurface
				var intersect_positions = []
				#if an intersection does occur, keep track of the direction in which the edge crosses the isosurface. This information will be used later for tri winding and normals.
				var intersect_directions = [
					placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int, placeholder_int
				]
				for edge in range(0, cube_edges.size()):
					#get the first and second vertices of each edge
					var cube_edge_vert0 = this_cube_verts_ones_zeroes[cube_edges[edge].x]
					var cube_edge_vert1 = this_cube_verts_ones_zeroes[cube_edges[edge].y]
					if cube_edge_vert0 != cube_edge_vert1:
						if cube_edge_vert0 < cube_edge_vert1:
							#the edge goes from ground at its first vertex to air at its second vertex
							#TODO: double-check that this is the correct way to mark air and ground, not the other way around
							intersect_directions[edge] = 1
						if cube_edge_vert0 > cube_edge_vert1:
							#the edge goes from air at its first vertex to ground at its second vertex
							intersect_directions[edge] = -1
						var edge_vert01_global_pos = this_cube_verts_global_positions[cube_edges[edge].x]
						var edge_vert02_global_pos = this_cube_verts_global_positions[cube_edges[edge].y]
						var current_intersect_pos_x = (edge_vert01_global_pos.x + edge_vert02_global_pos.x) / 2.0
						var current_intersect_pos_y = (edge_vert01_global_pos.y + edge_vert02_global_pos.y) / 2.0
						var current_intersect_pos_z = (edge_vert01_global_pos.z + edge_vert02_global_pos.z) / 2.0
						intersect_positions.append(Vector3(current_intersect_pos_x, current_intersect_pos_y, current_intersect_pos_z))
				
				#if one or more edges of this voxel are intersected by the isosurface
				if intersect_positions.size() > 0:
					verts_in_chunk = true
					#store the directions of the intersections through edges 5, 6 and 10 to calculate tri winding and normals later
					edges_5_6_10[voxel_y][voxel_z][voxel_x] = Vector3i(intersect_directions[5], intersect_directions[6], intersect_directions[10])
					#find the mesh vertex position within the voxel by getting an average of the intersection points
					var intersection_points_x = 0
					var intersection_points_y = 0
					var intersection_points_z = 0
					for pt in range(0, intersect_positions.size()):
						intersection_points_x = intersection_points_x + intersect_positions[pt].x
						intersection_points_y = intersection_points_y + intersect_positions[pt].y
						intersection_points_z = intersection_points_z + intersect_positions[pt].z
					intersection_points_x = intersection_points_x / intersect_positions.size()
					intersection_points_y = intersection_points_y / intersect_positions.size()
					intersection_points_z = intersection_points_z / intersect_positions.size()
					##add the vertex to the mesh vertices array
					#verts.append(Vector3(intersection_points_x, intersection_points_y, intersection_points_z))
					##calculate the uv offsets for this vertex based on its XZ position inside the terrain section
					#var uv_x = fmod(intersection_points_x, terrain_section_size) / terrain_section_size
					#var uv_y = fmod(intersection_points_z, terrain_section_size) / terrain_section_size
					#uvs.append(Vector2(uv_x, uv_y))
					verts_inside_voxels[voxel_y][voxel_z][voxel_x] = Vector3(intersection_points_x, intersection_points_y, intersection_points_z)
					#add the index to the voxel indices array for triangulation calculations later
					voxel_inidces[voxel_y][voxel_z][voxel_x] = current_vert_index
					current_vert_index = current_vert_index + 1
	
	if verts_in_chunk == true:
		create_indices_verts_uvs(voxel_inidces, edges_5_6_10)
		#print("num verts: " + str(verts.size()))
		#print("num indices: " + str(indices.size()))
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		st.set_material(terrain_mat)
		#for vert in range(0, verts.size()):
			#st.set_uv(uvs[vert])
			##TODO: make the vert position local to the chunk
			#var vert_local_pos : Vector3 = verts[vert] - chunk_pos
			#st.add_vertex(vert_local_pos)
			###st.add_vertex(verts[vert])
		#for ind in range(0, indices.size()):
			#if ind < verts.size():
				#st.add_index(ind)
		for ind in range(0, indices.size()):
			st.set_uv(uvs[ind])
			#make the vert position local to the chunk
			var vert_local_pos : Vector3 = verts[ind] - chunk_pos
			st.add_vertex(vert_local_pos)
			#st.add_vertex(verts[ind])
		#generate smooth normals	
		st.generate_normals(true)
		a_mesh = ArrayMesh.new()
		st.commit(a_mesh)
		mesh_inst.mesh = a_mesh
		#coll_shape_shape.set_faces(a_mesh.get_faces())
		
func create_indices_verts_uvs(voxel_indices, edges_5_6_10):
	#quads are built only in the X+, Y+ and Z+ directions from each voxel vertex.
	#Therefore, only edges 5, 6 and 10 need to be taken into account
	#calculate the winding of the tris, ideally in a LOD-friendly manner
	#---------
	#| \ | / |
	#---------
	#| / | \ |
	#_________  
	verts.clear()
	uvs.clear()
	indices.clear()
	#print(voxel_indices)
	#print(edges_5_6_10)
	for vox_y in range(0, chunk_size):
		for vox_z in range(0, chunk_size):
			for vox_x in range(0, chunk_size):
				#if this voxel contains a mesh vertex
				if voxel_indices[vox_y][vox_z][vox_x] != placeholder_int:
					var tri_type01 = true #there are two ways of constructing a given tri, depending on its location in the quad |\ or \| and the quad's normal direction
					#check whether edges 5,6 and 10 are intersected by the isosurface and in which direction
					var edge_5 = edges_5_6_10[vox_y][vox_z][vox_x].x
					var edge_6 = edges_5_6_10[vox_y][vox_z][vox_x].y
					var edge_10 = edges_5_6_10[vox_y][vox_z][vox_x].z
					#if edge 5 is intersected
					if edge_5 != placeholder_int:
						#the vertex in this voxel will make a quad with the vertices in the following voxels: (X+1,Y+0,Z+0), (X+0,Y+1,Z+0), (X+1,Y+1,Z+0)
						#calculate which way the triangles should be wound on horizontal quads facing in the X+ or X- directions
						tri_type01 = true
						#if this is an even-numbered slice
						if vox_y % 2 == 0:
							#if this is an odd-numbered cell
							if vox_x % 2 != 0:
								tri_type01 = false
						#this is an odd-numbered slice
						else:
							#if this is an even-numbered cell
							if vox_x % 2 == 0:
								tri_type01 = false
						#if the isosurface is facing in the direction from edge 5's 0th vertex towards edge 5's 1th vertex
						if edge_5 == 1:
							if tri_type01 == true:
								if voxel_indices[vox_y+1][vox_z][vox_x] != placeholder_int and voxel_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
									#tri 1
									indices.append(voxel_indices[vox_y][vox_z][vox_x])
									indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
									indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
									verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
									verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
									verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
									#calculate the uv offsets for each vertex based on its XZ position inside the terrain section
									var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
									var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
									uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
									uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									
									if voxel_indices[vox_y+1][vox_z][vox_x+1] != placeholder_int:
										#tri2 
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x+1])
										indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
							else:
								if voxel_indices[vox_y+1][vox_z][vox_x+1] != placeholder_int:
									if voxel_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri 1
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x+1])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
								if voxel_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
									#tri2
									indices.append(voxel_indices[vox_y][vox_z][vox_x])
									indices.append(voxel_indices[vox_y+1][vox_z][vox_x+1])
									indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
									verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
									verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x+1])
									verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
									var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
									var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
									uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
									uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
										
						#if the isosurface is facing in the direction from edge 5's 1th vertex towards edge 5's 0th vertex
						if edge_5 == -1:
							if tri_type01 == true:
								if voxel_indices[vox_y][vox_z][vox_x+1] != placeholder_int and voxel_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
									#tri 1
									indices.append(voxel_indices[vox_y][vox_z][vox_x])
									indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
									indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
									verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
									verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
									verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
									var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
									var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
									uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
									uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									
									if voxel_indices[vox_y+1][vox_z][vox_x+1] != placeholder_int:
										#tri2 
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x+1])
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
							else:
								if voxel_indices[vox_y+1][vox_z][vox_x+1] != placeholder_int:
									if voxel_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri 1
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x+1])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
										
									if voxel_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
										#tri2
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x+1])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
					if edge_6 != placeholder_int:
						#the vertex in this voxel will make a quad with the vertices in the following voxels: (X+0,Y+1,Z+0), (X+0,Y+1,Z+1), (X+0,Y+0,Z+1)
						tri_type01 = true
						#if this is an even-numbered slice
						if vox_y % 2 == 0:
							#if this is an odd-numbered row
							if vox_z % 2 != 0:
								tri_type01 = false
						else:
							#this is an odd-numbered slice
							#if this is an even-numbered row
							if vox_z % 2 == 0:
								tri_type01 = false
						if edge_6 == 1:
							if tri_type01:
								if voxel_indices[vox_y+1][vox_z][vox_x] != placeholder_int and voxel_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
									#tri1
									indices.append(voxel_indices[vox_y][vox_z][vox_x])
									indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
									indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
									verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
									verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
									verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
									var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
									var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
									uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
									uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
									uvs.append(Vector2(uv_x, uv_y))
									
									if voxel_indices[vox_y+1][vox_z+1][vox_x] != placeholder_int:
										#tri2
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z+1][vox_x])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
							else:
								if voxel_indices[vox_y+1][vox_z+1][vox_x] != placeholder_int:
									if voxel_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri1
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z+1][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
									if voxel_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
										#tri2
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z+1][vox_x])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))

						if edge_6 == -1:
							if tri_type01:
								if voxel_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
									if voxel_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri1
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
									if voxel_indices[vox_y+1][vox_z+1][vox_x] != placeholder_int:
										#tri2
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z+1][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
							else:
								if voxel_indices[vox_y+1][vox_z+1][vox_x] != placeholder_int:
									if voxel_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri1
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z+1][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
									if voxel_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
										#tri2
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
										indices.append(voxel_indices[vox_y+1][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y+1][vox_z+1][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y+1][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))

						if edge_10 != placeholder_int:
							#the vertex in this voxel will make a quad with the vertices in the following voxels: (X+1,Y+0,Z+0), (X+1,Y+0,Z+1), (X+0,Y+0,Z+1)... if they exist
							tri_type01 = true
							#even-numbered rows
							if vox_z % 2 == 0:
								#odd-numbered cells
								if vox_x % 2 != 0:
									tri_type01 = false
							else:
								#even-numbered cells
								if vox_x % 2 == 0:
									tri_type01 = false
							
							if edge_10 == 1:
								#calculate which way the triangles should be wound for LODing purposes on quads facing in the Y+ direction
								if tri_type01:
									if voxel_indices[vox_y][vox_z+1][vox_x+1] != placeholder_int:
										if voxel_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
											#tri1
											indices.append(voxel_indices[vox_y][vox_z][vox_x])
											indices.append(voxel_indices[vox_y][vox_z+1][vox_x+1])
											indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
											verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
											verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x+1])
											verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
											var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
											var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											
										if voxel_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
											#tri2
											indices.append(voxel_indices[vox_y][vox_z][vox_x])
											indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
											indices.append(voxel_indices[vox_y][vox_z+1][vox_x+1])
											verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
											verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
											verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x+1])
											var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
											var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											
								else:
									if voxel_indices[vox_y][vox_z][vox_x+1] != placeholder_int and voxel_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
										#tri1
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
									if voxel_indices[vox_y][vox_z+1][vox_x+1] != placeholder_int:
										#tri2
										indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x+1])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x+1])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
							if edge_10 == -1:
								if tri_type01:
									if voxel_indices[vox_y][vox_z+1][vox_x+1] != placeholder_int:
										if voxel_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
											#tri1
											indices.append(voxel_indices[vox_y][vox_z][vox_x])
											indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
											indices.append(voxel_indices[vox_y][vox_z+1][vox_x+1])
											verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
											verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
											verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x+1])
											var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
											var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											
										if voxel_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
											#tri2
											indices.append(voxel_indices[vox_y][vox_z][vox_x])
											indices.append(voxel_indices[vox_y][vox_z+1][vox_x+1])
											indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
											verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
											verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x+1])
											verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
											var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
											var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											
								else:
									if voxel_indices[vox_y][vox_z+1][vox_x] != placeholder_int and voxel_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
										#tri1
										indices.append(voxel_indices[vox_y][vox_z][vox_x])
										indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
										indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
										verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
										var uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].x, terrain_section_size) / terrain_section_size
										var uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
										uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
										uvs.append(Vector2(uv_x, uv_y))
										
										if voxel_indices[vox_y][vox_z+1][vox_x+1] != placeholder_int:
											#tri2
											indices.append(voxel_indices[vox_y][vox_z+1][vox_x])
											indices.append(voxel_indices[vox_y][vox_z+1][vox_x+1])
											indices.append(voxel_indices[vox_y][vox_z][vox_x+1])
											verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x])
											verts.append(verts_inside_voxels[vox_y][vox_z+1][vox_x+1])
											verts.append(verts_inside_voxels[vox_y][vox_z][vox_x+1])
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z+1][vox_x+1].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
											uv_x = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].x, terrain_section_size) / terrain_section_size
											uv_y = fmod(verts_inside_voxels[vox_y][vox_z][vox_x+1].z, terrain_section_size) / terrain_section_size
											uvs.append(Vector2(uv_x, uv_y))
	
											
#returns a vertical slice representing the 1th column of ones and zeroes
func get_western_cube_verts():
	var verts_array = []
	for vert_y in range(0, chunk_ones_zeroes_size):
		for vert_z in range(0, chunk_ones_zeroes_size):
			verts_array.append(chunk_ones_zeroes[vert_y][vert_z][1])
	return verts_array

#returns a horizontal ribbon representing the 1th column of ones and zeroes in the 1th slice
func get_western_cube_verts_down():
	var verts_array = []
	for vert_z in range(0, chunk_ones_zeroes_size):
		verts_array.append(chunk_ones_zeroes[1][vert_z][1])
	return verts_array
	
#returns a vertical slice representing the 1th row of ones and zeroes	
func get_northern_cube_verts():
	var verts_array = []
	for vert_y in range(0, chunk_ones_zeroes_size):
		for vert_x in range(0, chunk_ones_zeroes_size):
			verts_array.append(chunk_ones_zeroes[vert_y][1][vert_x])
	return verts_array

#returns a horizontal ribbon representing the 1th row of the 1th slice in ones and zeroes
func get_northern_cube_verts_down():
	var verts_array = []
	for vert_x in range(0, chunk_ones_zeroes_size):
		verts_array.append(chunk_ones_zeroes[1][1][vert_x])
	return verts_array

#returns a vertical ribbon of verts in the 1th row and 1th column of each slice
func get_northwestern_cube_verts():
	var verts_array = []
	for vert_y in range(0, chunk_ones_zeroes_size):
		verts_array.append(chunk_ones_zeroes[vert_y][1][1])
	return verts_array
	
# returns a single vertex at the Y1,Z1,X1 position in the cube_verts_array
func get_northwestern_cube_verts_down():
	return chunk_ones_zeroes[1][1][1]

#returns a horizontal slice representing the 1th slice in ones and zeroes
func get_bottom_verts():
	var verts_array = []
	for vert_z in range(0, chunk_ones_zeroes_size):
		for vert_x in range(0, chunk_ones_zeroes_size):
			verts_array.append(chunk_ones_zeroes[1][vert_z][vert_x])
	return verts_array
