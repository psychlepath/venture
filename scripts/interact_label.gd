extends MeshInstance3D
class_name InteractLabelClass

var tex_filepaths = [
	"res://textures/open_hand_icon.png",
	"res://textures/pointing_hand_icon.png",
	"res://textures/horiz_arrow_icon.png",
	"res://textures/vert_arrow_icon.png",
	"res://textures/horiz_arrow_curve_icon.png",
	"res://textures/vert_arrow_curve_icon.png"
]
var label_img_tex : ImageTexture

func set_icon(label_type : int):
	var label_mat = self.get_surface_override_material(0)
	match label_type:
		0:
			var label_img : Image = load(tex_filepaths[0])
			label_img_tex = ImageTexture.create_from_image(label_img)
			label_mat.albedo_texture = label_img_tex
		1:
			var label_img : Image = load(tex_filepaths[1])
			label_img_tex = ImageTexture.create_from_image(label_img)
			label_mat.albedo_texture = label_img_tex
		2:
			var label_img : Image = load(tex_filepaths[2])
			label_img_tex = ImageTexture.create_from_image(label_img)
			label_mat.albedo_texture = label_img_tex
		3:
			var label_img : Image = load(tex_filepaths[3])
			label_img_tex = ImageTexture.create_from_image(label_img)
			label_mat.albedo_texture = label_img_tex
		4:
			var label_img : Image = load(tex_filepaths[4])
			label_img_tex = ImageTexture.create_from_image(label_img)
			label_mat.albedo_texture = label_img_tex
		5:
			var label_img : Image = Image.load_from_file(tex_filepaths[5])
			label_img_tex = ImageTexture.create_from_image(label_img)
			label_mat.albedo_texture = label_img_tex
		#_:
			#push_error puts the message into the Debugger screen. Godot brings the editor to the line of code in question when the message is clicked on
			#push_error("error: No interaction texture available from '%s'. " % [label_type])
