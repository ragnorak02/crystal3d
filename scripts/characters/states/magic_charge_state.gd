class_name MagicChargeState
extends CharacterState
## Hold to charge magic. Can rotate but can't move. Release to fire.

var _charge_time: float = 0.0
const MIN_CHARGE: float = 0.2


func enter() -> void:
	_charge_time = 0.0


func process_physics(delta: float) -> void:
	_charge_time += delta
	character.apply_gravity(delta)

	# Can rotate toward input direction but not move
	var input_dir := InputManager.move_direction
	var camera := character.get_viewport().get_camera_3d()
	if input_dir.length() > 0.1 and camera:
		var cam_basis := camera.global_transform.basis
		var forward := -cam_basis.z
		var right := cam_basis.x
		forward.y = 0.0
		right.y = 0.0
		forward = forward.normalized()
		right = right.normalized()
		var direction := (right * input_dir.x + forward * (-input_dir.y)).normalized()
		var target_angle := atan2(direction.x, direction.z)
		character.rotation.y = lerp_angle(character.rotation.y, target_angle, character.rotation_speed * delta)

	# Decelerate to stop
	character.velocity.x = move_toward(character.velocity.x, 0.0, character.deceleration * delta)
	character.velocity.z = move_toward(character.velocity.z, 0.0, character.deceleration * delta)
	character.move_and_slide()

	if not character.is_on_floor():
		state_machine.transition_to("Fall")
		return

	if InputManager.magic_charge_just_released and _charge_time >= MIN_CHARGE:
		_fire_projectile()
		state_machine.transition_to("MagicRecovery")
	elif not InputManager.magic_charge_pressed and _charge_time < MIN_CHARGE:
		state_machine.transition_to("Idle")


func _fire_projectile() -> void:
	var fireball_scene := load("res://scenes/combat/Fireball.tscn") as PackedScene
	if not fireball_scene:
		return
	var fireball := fireball_scene.instantiate()
	character.get_tree().current_scene.add_child(fireball)
	fireball.global_position = character.global_position + Vector3(0, 0.175, 0)
	var fire_dir := -character.global_transform.basis.z.normalized()
	fireball.set_direction(fire_dir)
