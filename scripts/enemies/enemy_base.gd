class_name EnemyBase
extends CharacterBody3D
## Base class for all enemies. Has HP, detection, and state machine.

@export var max_hp: int = 3
@export var move_speed: float = 3.0
@export var detection_range: float = 5.0
@export var attack_range: float = 0.5
@export var attack_damage: int = 1
@export var patrol_radius: float = 3.0

var current_hp: int
var spawn_position: Vector3
var target: CharacterBody3D = null
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var state_machine: StateMachine = $StateMachine
@onready var detection_area: Area3D = $DetectionArea

signal health_changed(current: int, maximum: int)
signal died


func _ready() -> void:
	add_to_group("enemies")
	add_to_group("lock_on_targets")
	current_hp = max_hp
	spawn_position = global_position
	collision_layer = 4  # EnemyBody
	collision_mask = 1   # Environment

	if detection_area:
		detection_area.body_entered.connect(_on_body_entered_detection)
		detection_area.body_exited.connect(_on_body_exited_detection)

	var hurtbox := get_node_or_null("Hurtbox") as Hurtbox
	if hurtbox:
		hurtbox.hurt.connect(_on_hurt)


func take_damage(amount: int) -> void:
	current_hp = maxi(current_hp - amount, 0)
	health_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		state_machine.transition_to("Die")
		died.emit()


func _on_hurt(damage: int, _knockback: float, _origin: Vector3) -> void:
	take_damage(damage)


func _on_body_entered_detection(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body


func _on_body_exited_detection(body: Node3D) -> void:
	if body == target:
		target = null
