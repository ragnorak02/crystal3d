extends Node3D
## Smooth camera follow rig for isometric-style view.
## Attach to a Node3D parent of the Camera3D.
## The rig follows the player position; the Camera3D child provides the angle.

@export var follow_speed: float = 8.0

var target: Node3D


func _ready() -> void:
	# Wait one frame so the player has time to register in its group
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")
	if target:
		global_position = target.global_position


func _physics_process(delta: float) -> void:
	if not target:
		target = get_tree().get_first_node_in_group("player")
		return

	global_position = global_position.lerp(target.global_position, follow_speed * delta)
