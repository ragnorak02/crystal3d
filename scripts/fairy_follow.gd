extends Node3D
## Fairy companion that floats near the player with gentle bobbing.
## Follows in world-space with smooth interpolation for organic movement.

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

	# Base position: player + offset
	var target_pos := target.global_position + offset
	# Gentle vertical bob
	target_pos.y += sin(time_elapsed * bob_speed) * bob_amplitude
	# Subtle circular drift for organic feel
	target_pos.x += cos(time_elapsed * 1.3) * 0.05
	target_pos.z += sin(time_elapsed * 1.1) * 0.05

	global_position = global_position.lerp(target_pos, follow_speed * delta)
