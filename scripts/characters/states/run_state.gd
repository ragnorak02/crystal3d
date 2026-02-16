class_name RunState
extends CharacterState


func process_physics(delta: float) -> void:
	character.apply_gravity(delta)
	character.apply_movement(delta)
	character.move_and_slide()

	if not character.is_on_floor():
		state_machine.transition_to("Fall")
		return

	if InputManager.jump_buffered:
		InputManager.consume_jump_buffer()
		state_machine.transition_to("Jump")
		return

	if InputManager.attack_buffered:
		InputManager.consume_attack_buffer()
		state_machine.transition_to("Attack")
		return

	if InputManager.magic_charge_pressed:
		state_machine.transition_to("MagicCharge")
		return

	if InputManager.crouch_just_pressed:
		state_machine.transition_to("Crouch")
		return

	if InputManager.run_pressed:
		state_machine.transition_to("Sprint")
		return

	if InputManager.move_direction.length() < 0.1:
		state_machine.transition_to("Idle")
