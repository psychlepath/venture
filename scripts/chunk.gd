@tool
extends MeshInstance3D
class_name terrain_chunk

var verts_in_chunk : bool = false#Controls whether or not there is any need to create a mesh for this chunk
var chunk_size : int = 8
var chunk_position : Vector3 = Vector3(0,0,0)
var isosurface : float = 0.0
var chunk_heights = []
var chunk_material : Material
var chunk_noise = []
var current_vert_index : int = 0
var chunk_indices = []
var chunk_edges_5_6_10 = []
var a_mesh : ArrayMesh
var st : SurfaceTool
var voxel_vertices : PackedVector3Array = PackedVector3Array()
var voxel_indices : PackedInt32Array = PackedInt32Array()
var placeholder_vector = Vector3(-1,-1,-1)#used to track whether or not an array index has been used 
var placeholder_int : int = -2
var placeholder_float : float = 2.0

var cube_verts = [
	Vector3(0,0,0), Vector3(1,0,0), Vector3(1,0,1), Vector3(0,0,1),
	Vector3(0,1,0), Vector3(1,1,0), Vector3(1,1,1), Vector3(0,1,1)
]

var cube_edges = [
	Vector2(0,1), Vector2(1,2), Vector2(2,3), Vector2(3,0),
	Vector2(4,5), Vector2(5,6), Vector2(6,7), Vector2(7,4),
	Vector2(0,4), Vector2(1,5), Vector2(2,6), Vector2(3,7)	
]

func init_chunk(_size : int, _pos : Vector3, _heights, _chunk_mat : Material):
	chunk_size = _size
	chunk_position = _pos
	chunk_heights = _heights
	chunk_material = _chunk_mat
	init_arrays()
	create_noise_from_heightmap()
	calculate_verts_from_noise()
	create_indices()
	create_mesh()

func init_arrays():
	#fill the chunk_noise array with placeholders
	chunk_noise.resize(chunk_size + 2)
	for i in chunk_size + 2:
		chunk_noise[i] = []
		chunk_noise[i].resize(chunk_size + 2)
		for j in chunk_size + 2:
			chunk_noise[i][j] = []
			chunk_noise[i][j].resize(chunk_size + 2)
			for k in chunk_size + 2:
				chunk_noise[i][j][k] = placeholder_float
		
	#use an array to keep track of the index of the mesh vertex inside the chunk's voxels
	#if a vertex exists
	chunk_indices.resize(chunk_size + 1)
	for i in chunk_size + 1:
		chunk_indices[i] = []
		chunk_indices[i].resize(chunk_size + 1)
		for j in chunk_size + 1:
			chunk_indices[i][j] = []
			chunk_indices[i][j].resize(chunk_size + 1)
			for k in chunk_size + 1:
				chunk_indices[i][j][k] = placeholder_int
	
	#also keep track of each vertex's normal to be used in tri winding later			
	chunk_edges_5_6_10.resize(chunk_size + 1)
	for i in chunk_size + 1:
		chunk_edges_5_6_10[i] = []
		chunk_edges_5_6_10[i].resize(chunk_size + 1)
		for j in chunk_size + 1:
			chunk_edges_5_6_10[i][j] = []
			chunk_edges_5_6_10[i][j].resize(chunk_size + 1)
			for k in chunk_size + 1:
				chunk_edges_5_6_10[i][j][k] = Vector3(0,0,0)

func create_noise_from_heightmap():
	for noise_y in chunk_size + 2:
		for noise_z in chunk_size + 2:
			for noise_x in chunk_size + 2:
				#print((noise_z * chunk_size + 2) + noise_x)
				var local_height = chunk_heights[(noise_z * (chunk_size + 2)) + noise_x]
				if (noise_y + chunk_position.y) <= local_height:
					chunk_noise[noise_y][noise_z][noise_x] = 1.0
				else:
					chunk_noise[noise_y][noise_z][noise_x] =  0.0
	#print(chunk_noise)
	#TODO: save the noise for this chunk for later modification 
	
func calculate_verts_from_noise():
	var current_chunk_index : int = 0
	#iterate over the voxels in the chunk in vertical slices aligned along the XY axes
	#for the best chance of creating LOD-friendly tris
	for voxel_y in chunk_size + 1:
		for voxel_z in chunk_size + 1:
			for voxel_x in chunk_size + 1:
				var vert_in_voxel = false
				#create an array to hold the points at which the edges are intersected
				var intersection_points = [
					placeholder_vector, placeholder_vector, placeholder_vector, placeholder_vector,
					placeholder_vector, placeholder_vector, placeholder_vector, placeholder_vector,
					placeholder_vector, placeholder_vector, placeholder_vector, placeholder_vector
				]
				#create an array to keep track of whether the intersected edges
				#are going from outside to inside with regards to the isosurface
				#or from inside to outside
				var edge_directions = [0,0,0,0,0,0,0,0,0,0,0,0]
				#iterate over each edge of the cube and check whether
				#its vertices are on different sides of the isosurface
				for edge_index in cube_edges.size():
					var v0_ind : int = cube_edges[edge_index][0]
					var v1_ind : int = cube_edges[edge_index][1]
					var v0_pos : Vector3 = Vector3(voxel_x, voxel_y, voxel_z) + cube_verts[v0_ind]#relative to chunk
					var v1_pos : Vector3 = Vector3(voxel_x, voxel_y, voxel_z) + cube_verts[v1_ind]#relative to chunk
					var v0_mat = chunk_noise[v0_pos.y][v0_pos.z][v0_pos.x]
					var v1_mat = chunk_noise[v1_pos.y][v1_pos.z][v1_pos.x]
					
					#if no intersections take place, do nothing
					
					#if the edge is intersected by the isosurface
					if v0_mat != v1_mat:
						if v0_mat > isosurface and v1_mat <= isosurface:
							edge_directions[edge_index] = 1 #this edge goes from solid at its first vertex to air at its second vertex
						if v1_mat > isosurface and v0_mat <= isosurface:
							edge_directions[edge_index] = -1 #this edge goes from air at its first vertex to solid at its second vertex
											
						if edge_directions[edge_index] != 0:
							#find the intersection point along each edge.
							#In naive surface nets, this is usually taken to be half way along the edge
#							var intersect_pos = 0
#							if v1_pos > v0_pos:
#								intersect_pos = ((v1_pos - v0_pos) / 2) + v0_pos
#							else:
#								intersect_pos = ((v0_pos - v1_pos) / 2) + v1_pos
							#However, with heightmaps it is probably better to just use the offset 
							#of the edge vertex that is at the closest to the isosurface
							#N.B. not all cube edges go from a lower-numbered vertex to a higher-numbered one
							#add the intersection point to the intersection_points array
							if v1_pos > v0_pos:
								intersection_points[edge_index] = v1_pos
							else:
								intersection_points[edge_index] = v0_pos
							
							vert_in_voxel = true
							
							#flag the fact that there are vertices in this chunk
							verts_in_chunk = true
				#save the directions of the intersections of this voxel's edge 5, edge 6 and edge 10
				#for use when creating quads and tris 					
				chunk_edges_5_6_10[voxel_y][voxel_z][voxel_x] = Vector3(edge_directions[5], edge_directions[6], edge_directions[10])
										
				#if this voxel has edges intersected by the isosurface,
				#and therefore contains a mesh vertex
				if vert_in_voxel:
					#add the intersection points together and divide them by the number
					#of intersection points to get an average position for the vertex in this voxel
					var num_intersection_points = 0
					var intersection_x = 0
					var intersection_y = 0
					var intersection_z = 0
					for edge in edge_directions.size():
						if edge_directions[edge] != 0:
							intersection_x += intersection_points[edge].x
							intersection_y += intersection_points[edge].y
							intersection_z += intersection_points[edge].z
							num_intersection_points += 1
					if num_intersection_points != 0:
						var vertex_position = Vector3(intersection_x / num_intersection_points, intersection_y / num_intersection_points, intersection_z / num_intersection_points) #relative to chunk
						#append the chunk-relative vertex position to the voxel_vertices array
						voxel_vertices.append(vertex_position)
						#keep track of which vertex is in which of the chunk's voxels
						chunk_indices[voxel_y][voxel_z][voxel_x] = current_chunk_index
						current_chunk_index += 1

func create_indices():
	#quads are built only in the X+, Y+ and Z+ directions from each voxel vertex.
	#Therefore, only edges 5, 6 and 10 need to be taken into account
	#calculate the winding of the tris, ideally in a LOD-friendly manner
	#---------
	#| \ | / |
	#---------
	#| / | \ |
	#_________  
	var tri_type01 = true #there are two possible ways of constructing the tris in a given quad...
	for vox_y in chunk_size:
		for vox_z in chunk_size:
			for vox_x in chunk_size:
				#if this voxel contains a mesh vertex
				if chunk_indices[vox_y][vox_z][vox_x] != placeholder_int:
					#check whether edges 5,6 and 10 are intersected by the isosurface and in which direction
					var edge_5 = chunk_edges_5_6_10[vox_y][vox_z][vox_x].x
					var edge_6 = chunk_edges_5_6_10[vox_y][vox_z][vox_x].y
					var edge_10 = chunk_edges_5_6_10[vox_y][vox_z][vox_x].z
				
					#if edge 5 is intersected
					if edge_5 != 0:
						#the vertex in this voxel will make a quad with the vertices in
						#the following voxels: (X+1,Y+0,Z+0), (X+0,Y+1,Z+0), (X+1,Y+1,Z+0)
						#check that the other vertices exist
						#calculate which way the triangles should be wound for LODing purposes on horizontal quads facing in the X+ and X- directions
						#even-numbered rows
						tri_type01 = true
						if vox_y % 2 == 0:
							#odd-numbered cells
							if vox_x % 2 != 0:
								tri_type01 = false
						#odd-numbered rows
						if vox_y % 2 != 0:
							#even-numbered cells
							if vox_x % 2 == 0:
								tri_type01 = false
								
						#if the isosurface is facing in the direction from edge 5's vertex 0
						#towards edge 5's vertex 1
						if edge_5 == 1:
							if tri_type01:
								if chunk_indices[vox_y+1][vox_z][vox_x] != placeholder_int and chunk_indices[vox_y][vox_z][vox_x+1]:
									#tri 1
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
									voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
									if chunk_indices[vox_y+1][vox_z][vox_x+1] != placeholder_int:
										#tri2 
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
							else:
								if chunk_indices[vox_y+1][vox_z][vox_x+1] != placeholder_int:
									if chunk_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri 1
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x+1])
									if chunk_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
								
						#if the isosurface is facing in the direction from edge 5's vertex 1
						#towards edge 5's vertex 0
						if edge_5 == -1:
							if tri_type01:
								if chunk_indices[vox_y][vox_z][vox_x+1] != placeholder_int and chunk_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
									#tri 1
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
									voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
									if chunk_indices[vox_y+1][vox_z][vox_x+1] != placeholder_int:
										#tri2 
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x+1])
							else:
								if chunk_indices[vox_y+1][vox_z][vox_x+1] != placeholder_int:
									if chunk_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri 1
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
									if chunk_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x+1])

					if edge_6 != 0:
						#the vertex in this voxel will make a quad with the vertices in
						#the following voxels: (X+0,Y+1,Z+0), (X+0,Y+1,Z+1), (X+0,Y+0,Z+1)
						tri_type01 = true
						#even-numbered rows
						if vox_y % 2 == 0:
							#odd-numbered cells
							if vox_z % 2 != 0:
								tri_type01 = false
						#odd-numbered rows
						if vox_y % 2 != 0:
							#even-numbered cells
							if vox_z % 2 == 0:
								tri_type01 = false
								
						if edge_6 == 1:
							if tri_type01:
								if chunk_indices[vox_y+1][vox_z][vox_x] != placeholder_int and chunk_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
									#tri1
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
									voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
									voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
									if chunk_indices[vox_y+1][vox_z+1][vox_x] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z+1][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
							else:
								if chunk_indices[vox_y+1][vox_z+1][vox_x] != placeholder_int:
									if chunk_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri1
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z+1][vox_x])
									if chunk_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z+1][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
								
						if edge_6 == -1:
							if tri_type01:
								if chunk_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
									if chunk_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri1
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
									if chunk_indices[vox_y+1][vox_z+1][vox_x] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z+1][vox_x])
							else:
								if chunk_indices[vox_y+1][vox_z+1][vox_x] != placeholder_int:
									if chunk_indices[vox_y+1][vox_z][vox_x] != placeholder_int:
										#tri1
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z+1][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z][vox_x])
									if chunk_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
										voxel_indices.append(chunk_indices[vox_y+1][vox_z+1][vox_x])
							
					if edge_10 != 0:
						#the vertex in this voxel will make a quad with the vertices in
						#the following voxels: (X+1,Y+0,Z+0), (X+1,Y+0,Z+1), (X+0,Y+0,Z+1)... if they exist
						tri_type01 = true
						#even-numbered rows
						if vox_z % 2 == 0:
							#odd-numbered cells
							if vox_x % 2 != 0:
								tri_type01 = false
						#odd-numbered rows
						if vox_z % 2 != 0:
							#even-numbered cells
							if vox_x % 2 == 0:
								tri_type01 = false
						
						if edge_10 == 1:
							#calculate which way the triangles should be wound for LODing purposes on quads facing in the Y+ direction
							if tri_type01:
								if chunk_indices[vox_y][vox_z+1][vox_x+1] != placeholder_int:
									if chunk_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
										#tri1
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
									if chunk_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x+1])

							else:
								if chunk_indices[vox_y][vox_z][vox_x+1] != placeholder_int and chunk_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
									#tri1
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
									voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
								if chunk_indices[vox_y][vox_z+1][vox_x+1] != placeholder_int:
									#tri2
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
									voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x+1])
									voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
						
						if edge_10 == -1:
							if tri_type01:
								if chunk_indices[vox_y][vox_z+1][vox_x+1] != placeholder_int:
									if chunk_indices[vox_y][vox_z+1][vox_x] != placeholder_int:
										#tri1
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x+1])
									if chunk_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
							else:
								if chunk_indices[vox_y][vox_z+1][vox_x] != placeholder_int and chunk_indices[vox_y][vox_z][vox_x+1] != placeholder_int:
									#tri1
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x])
									voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
									voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
									if chunk_indices[vox_y][vox_z+1][vox_x+1] != placeholder_int:
										#tri2
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x])
										voxel_indices.append(chunk_indices[vox_y][vox_z+1][vox_x+1])
										voxel_indices.append(chunk_indices[vox_y][vox_z][vox_x+1])
							

func create_mesh():
	if verts_in_chunk:
		st = SurfaceTool.new()
		
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		
		for vert in voxel_vertices:
			#TODO: convert from chunk-relative to terrain section-relative position
			vert += chunk_position
			st.add_vertex(vert)
		for ind in voxel_indices:
			st.add_index(ind)
		st.generate_normals()
		a_mesh = ArrayMesh.new()
		st.set_material(chunk_material)
		st.commit(a_mesh)
		mesh = a_mesh
		#probably no need for collision when editing the terrain in the editor...
		if not Engine.is_editor_hint():
			create_collision()
	
func create_collision():
	if get_child_count() > 0:
		for i in get_children():
			i.free()
	create_trimesh_collision()
