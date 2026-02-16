class_name FallState
extends CharacterState


func enter() -> void:
	pass


func process_physics(delta: float) -> void:
	character.apply_gravity(delta)
	character.apply_movement(delta)
	character.move_and_slide()

	if character.is_on_floor():
		character.air_jump_count = 0
		if InputManager.move_direction.length() > 0.1:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
		return

	# Air jumps (double jump, then dragon jump)
	if InputManager.jump_buffered and character.air_jump_count < character.get_max_air_jumps():
		InputManager.consume_jump_buffer()
		character.air_jump_count += 1
		if character.air_jump_count == 1:
			state_machine.transition_to("DoubleJump")
		elif character.air_jump_count == 2 and character.can_dragon_jump():
			state_machine.transition_to("DragonJump")
		return

	# Hold jump to glide (only while falling, after air jumps exhausted or any time)
	if InputManager.jump_pressed and character.can_glide() and character.velocity.y < 0.0:
		state_machine.transition_to("Glide")
