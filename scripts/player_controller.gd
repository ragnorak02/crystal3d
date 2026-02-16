extends CharacterBody3D
## Player movement controller with keyboard/mouse and gamepad support.
## Uses camera-relative movement for isometric-style controls.

# -- Movement --
@export_group("Movement")
@export var move_speed: float = 7.0
@export var acceleration: float = 50.0
@export var deceleration: float = 40.0
@export var rotation_speed: float = 10.0

# -- Jump --
@export_group("Jump")
@export var jump_force: float = 9.0
@export var gravity_multiplier: float = 2.0
@export var fall_multiplier: float = 2.5

# -- Crouch --
@export_group("Crouch")
@export var crouch_speed_multiplier: float = 0.5
@export var stand_height: float = 1.4
@export var crouch_height: float = 0.8

# -- State --
var is_crouching: bool = false

# -- References --
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var model: Node3D = $PlayerModel

# Gravity from project settings
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	add_to_group("player")


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_crouch()
	_handle_movement(delta)
	move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		# Fall faster than rise for snappy jump feel
		var mult := fall_multiplier if velocity.y < 0.0 else gravity_multiplier
		velocity.y -= gravity * mult * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouching:
		velocity.y = jump_force


func _handle_crouch() -> void:
	if Input.is_action_just_pressed("crouch"):
		is_crouching = not is_crouching
		var shape := collision_shape.shape as CapsuleShape3D
		if is_crouching:
			shape.height = crouch_height
			collision_shape.position.y = crouch_height / 2.0
			model.scale.y = crouch_height / stand_height
		else:
			shape.height = stand_height
			collision_shape.position.y = stand_height / 2.0
			model.scale.y = 1.0


func _handle_movement(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var camera := get_viewport().get_camera_3d()
	var speed := move_speed * (crouch_speed_multiplier if is_crouching else 1.0)

	if input_dir.length() > 0.1 and camera:
		# Camera-relative movement direction projected onto XZ plane
		var cam_basis := camera.global_transform.basis
		var forward := -cam_basis.z
		var right := cam_basis.x
		forward.y = 0.0
		right.y = 0.0
		forward = forward.normalized()
		right = right.normalized()

		# Combine input with camera directions (input_dir.y is negative for forward)
		var direction := (right * input_dir.x + forward * (-input_dir.y)).normalized()

		# Smooth acceleration
		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)

		# Rotate character to face movement direction
		var target_angle := atan2(direction.x, direction.z)
		rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)
	else:
		# Smooth deceleration
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, deceleration * delta)
