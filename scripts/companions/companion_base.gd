class_name CompanionBase
extends Node3D
## Base class for all companions. Follows player with smooth interpolation.

@export var offset: Vector3 = Vector3(0.6, 1.6, 0.3)
@export var follow_speed: float = 3.5
@export var bob_speed: float = 2.5
@export var bob_amplitude: float = 0.12

var target: Node3D
var time_elapsed: float = 0.0


func _ready() -> void:
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")
	if target:
		global_position = target.global_position + offset


func _process(delta: float) -> void:
	if not target:
		target = get_tree().get_first_node_in_group("player")
		return

	time_elapsed += delta
	var target_pos := _get_follow_position(delta)
	global_position = global_position.lerp(target_pos, follow_speed * delta)


func _get_follow_position(_delta: float) -> Vector3:
	var pos := target.global_position + offset
	pos.y += sin(time_elapsed * bob_speed) * bob_amplitude
	return pos


func on_companion_action() -> void:
	pass
