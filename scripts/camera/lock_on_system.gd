class_name LockOnSystem
extends Node3D
## Zelda Z-targeting lock-on. Child of CameraRig.
## Finds nearest enemy in "lock_on_targets" group, cycles with 1/2.

@export var max_lock_range: float = 10.0

var locked_target: Node3D = null
var is_locked: bool = false

signal target_changed(new_target: Node3D)


func _process(_delta: float) -> void:
	if InputManager.lock_on_toggle_just_pressed:
		if is_locked:
			unlock()
		else:
			_lock_nearest()

	if is_locked:
		if not is_instance_valid(locked_target) or not locked_target.is_inside_tree():
			unlock()
			return

		# Check range
		var player := get_tree().get_first_node_in_group("player") as Node3D
		if player:
			var dist := player.global_position.distance_to(locked_target.global_position)
			if dist > max_lock_range:
				unlock()
				return

		# Cycle targets
		if InputManager.lock_on_next_just_pressed:
			_cycle_target(1)
		elif InputManager.lock_on_prev_just_pressed:
			_cycle_target(-1)


func _lock_nearest() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node3D
	if not player:
		return

	var targets := get_tree().get_nodes_in_group("lock_on_targets")
	var nearest: Node3D = null
	var nearest_dist := max_lock_range

	for t in targets:
		if not t is Node3D or not t.is_inside_tree():
			continue
		var dist := player.global_position.distance_to(t.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = t

	if nearest:
		locked_target = nearest
		is_locked = true
		# Notify player
		if player is CharacterBase:
			player.lock_on_target = locked_target
		target_changed.emit(locked_target)


func unlock() -> void:
	locked_target = null
	is_locked = false
	var player := get_tree().get_first_node_in_group("player")
	if player is CharacterBase:
		player.lock_on_target = null
	target_changed.emit(null)


func _cycle_target(direction: int) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node3D
	if not player:
		return

	var targets := get_tree().get_nodes_in_group("lock_on_targets")
	var valid: Array[Node3D] = []
	for t in targets:
		if t is Node3D and t.is_inside_tree():
			var dist := player.global_position.distance_to(t.global_position)
			if dist <= max_lock_range:
				valid.append(t)

	if valid.is_empty():
		unlock()
		return

	var current_idx := valid.find(locked_target)
	if current_idx < 0:
		current_idx = 0
	else:
		current_idx = (current_idx + direction) % valid.size()

	locked_target = valid[current_idx]
	if player is CharacterBase:
		player.lock_on_target = locked_target
	target_changed.emit(locked_target)
