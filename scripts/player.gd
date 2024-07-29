@tool
extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 9.0

var regd_in_glbls : bool = false #check that the player variable in the global script points to this player
# Get the gravity from the project settings to be synced with RigidBody nodes.
var game_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 0.0;
var raycast_enabled : bool = false
var mouse_down : bool = false
var prev_camera_pivot_rot : float = 0.0
var prev_player_rot : float = 0.0
var interact_item : Node3D = null
@export var mouse_sensitivity : float = 0.01
@onready var camera_pivot := $camera_pivot
@onready var camera := $camera_pivot/Camera3D
@onready var mouse_l_r := $mouse_tracker_l_r
@onready var mouse_u_d := $mouse_tracker_u_d
@onready var raycast := $camera_pivot/Camera3D/RayCast3D

#func _enter_tree():
func _ready():
	#if not Engine.is_editor_hint():
	#Set the player variable in the singleton script for use with terrain rendering calculations etc
	#GlblScrpt.player = self # doesn't work reliably in editor mode, so workaround is put in _process function
	#Globals.current_camera = camera
	prev_camera_pivot_rot = $camera_pivot.rotation.x
	prev_player_rot = rotation.y

func _process(_delta):
	if !regd_in_glbls:
		#Set the player variable in the singleton script for use with terrain rendering calculations etc
		GlblScrpt.player = self
		if GlblScrpt.player != null:
			regd_in_glbls = true
			#switch off process (call from global script)?
		else: 
			print("player not registered")

func _unhandled_input(event: InputEvent) -> void:
	if not Engine.is_editor_hint():
		if event is InputEventMouseButton:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		elif event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				#TODO: stop camera and player rotation if mouse is pressed?
				#this will allow interaction with items
				if !mouse_down:
					rotate_y(-event.relative.x * mouse_sensitivity)
					camera_pivot.rotate_x(-event.relative.y * mouse_sensitivity)
					camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, -0.75, 0.75)
					mouse_l_r.rotation.y = 0.0
					mouse_u_d.rotation.x = camera_pivot.rotation.x
				else: 
					mouse_l_r.rotate_y(-event.relative.x * mouse_sensitivity)
					mouse_u_d.rotate_x(-event.relative.y * mouse_sensitivity)
					mouse_u_d.rotation.x = clamp(mouse_u_d.rotation.x, -0.75, 0.75)
					
			elif event is InputEventMouseButton:
				if event.get_button_index() == 1:
					#letf mouse button click event
					if event.is_pressed():
						mouse_down = true
					else:
						mouse_down = false

func _physics_process(delta):
	
	#print(camera.get_frustum())
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("enable_player_gravity"):
			if gravity == 0.0:
				gravity = game_gravity
			else:
				gravity = 0.0
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
				
		if raycast_enabled:
			#raycast.force_raycast_update()
			if raycast.is_colliding():
				#print("raycast is colliding")
				#print(raycast.get_collider())
				if raycast.get_collider().is_in_group("interactable"):
					if interact_item != raycast.get_collider().get_parent():
						interact_item = raycast.get_collider().get_parent()
						interact_item.set_initial_input(Vector2(mouse_u_d.rotation.x, mouse_l_r.rotation.y))
						interact_item.show_outline()
					if mouse_down:
						#if the left mouse button is down, 
						interact_item.handle_input(Vector2(mouse_u_d.rotation.x, mouse_l_r.rotation.y))
						
				else:
					if interact_item != null:
						interact_item.hide_outline()
						interact_item = null
						
			else:
				if interact_item != null:
					interact_item.hide_outline()
					interact_item = null
					
			
					
#called by interactable_item		
func enable_raycast():
	#print("enabling raycast")
	raycast_enabled = true
	raycast.enabled = true

#called by interactable_item	
func disable_raycast():
	#print("disabling raycast")
	raycast_enabled = false
	raycast.enabled = false
	if interact_item != null:
		interact_item.hide_outline()
		interact_item = null
