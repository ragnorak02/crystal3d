class_name CharacterBase
extends CharacterBody3D
## Base class for all playable characters. Contains exports, health, signals,
## and virtual methods for subclass overrides.

# -- Movement --
@export_group("Movement")
@export var move_speed: float = 7.0
@export var sprint_speed: float = 11.0
@export var acceleration: float = 50.0
@export var deceleration: float = 40.0
@export var rotation_speed: float = 10.0

# -- Jump --
@export_group("Jump")
@export var jump_force: float = 9.0
@export var gravity_multiplier: float = 2.0
@export var fall_multiplier: float = 2.5
@export var long_jump_force: float = 7.0
@export var long_jump_forward_boost: float = 14.0
@export var high_jump_force: float = 13.0

# -- Crouch --
@export_group("Crouch")
@export var crouch_speed_multiplier: float = 0.5
@export var stand_height: float = 0.35
@export var crouch_height: float = 0.2

# -- Combat --
@export_group("Combat")
@export var max_hp: int = 6
@export var attack_damage: int = 1

# -- State --
var current_hp: int
var is_crouching: bool = false
var lock_on_target: Node3D = null
var air_jump_count: int = 0
var companion: Node3D = null

# -- References --
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var model: Node3D = $PlayerModel
@onready var state_machine: StateMachine = $StateMachine

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# -- Signals --
signal health_changed(new_hp: int, max_hp: int)
signal died


func _ready() -> void:
	add_to_group("player")
	current_hp = max_hp
	# Collision layer: PlayerBody (2), mask: Environment (1)
	collision_layer = 2
	collision_mask = 1


func take_damage(amount: int) -> void:
	current_hp = maxi(current_hp - amount, 0)
	health_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		died.emit()


func heal(amount: int) -> void:
	current_hp = mini(current_hp + amount, max_hp)
	health_changed.emit(current_hp, max_hp)


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		var mult := fall_multiplier if velocity.y < 0.0 else gravity_multiplier
		velocity.y -= gravity * mult * delta


func apply_movement(delta: float, speed_override: float = -1.0) -> void:
	var input_dir := InputManager.move_direction
	var camera := get_viewport().get_camera_3d()
	var speed := speed_override if speed_override > 0.0 else move_speed

	if input_dir.length() > 0.1 and camera:
		var cam_basis := camera.global_transform.basis
		var forward := -cam_basis.z
		var right := cam_basis.x
		forward.y = 0.0
		right.y = 0.0
		forward = forward.normalized()
		right = right.normalized()

		var direction := (right * input_dir.x + forward * (-input_dir.y)).normalized()

		velocity.x = move_toward(velocity.x, direction.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * speed, acceleration * delta)

		# Face movement direction (or lock-on target)
		if lock_on_target:
			var to_target := (lock_on_target.global_position - global_position).normalized()
			var target_angle := atan2(to_target.x, to_target.z)
			rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)
		else:
			var target_angle := atan2(direction.x, direction.z)
			rotation.y = lerp_angle(rotation.y, target_angle, rotation_speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0.0, deceleration * delta)


func set_crouch(crouching: bool) -> void:
	is_crouching = crouching
	var shape := collision_shape.shape as CapsuleShape3D
	if crouching:
		shape.height = crouch_height
		collision_shape.position.y = crouch_height / 2.0
		model.scale.y = crouch_height / stand_height
	else:
		shape.height = stand_height
		collision_shape.position.y = stand_height / 2.0
		model.scale.y = 1.0


# Virtual methods for subclass overrides
func get_primary_attack_data() -> Resource:
	return null


func can_double_jump() -> bool:
	return false


func can_glide() -> bool:
	return false


func can_dragon_jump() -> bool:
	return false


func get_max_air_jumps() -> int:
	return 0


func get_companion_scene() -> String:
	return "res://scenes/companions/FairyCompanion.tscn"
