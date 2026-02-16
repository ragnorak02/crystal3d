extends Node3D
## Camera rig with smooth follow and lock-on support.
## Replaces the original camera_follow.gd with lock-on camera adjustments.

@export var follow_speed: float = 8.0
@export var lock_on_offset: Vector3 = Vector3(0, 0.5, 0)

var target: Node3D
var _lock_on_system: LockOnSystem


func _ready() -> void:
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")
	if target:
		global_position = target.global_position
	_lock_on_system = get_node_or_null("LockOnSystem")


func _physics_process(delta: float) -> void:
	if not target:
		target = get_tree().get_first_node_in_group("player")
		return

	var target_pos := target.global_position

	# When locked on, offset camera to keep both player and target visible
	if _lock_on_system and _lock_on_system.is_locked and is_instance_valid(_lock_on_system.locked_target):
		var midpoint := (target.global_position + _lock_on_system.locked_target.global_position) / 2.0
		target_pos = midpoint + lock_on_offset

	global_position = global_position.lerp(target_pos, follow_speed * delta)
