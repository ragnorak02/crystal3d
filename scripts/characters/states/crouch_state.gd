class_name CrouchState
extends CharacterState


func enter() -> void:
	character.set_crouch(true)


func exit() -> void:
	character.set_crouch(false)


func process_physics(delta: float) -> void:
	character.apply_gravity(delta)
	character.apply_movement(delta, character.move_speed * character.crouch_speed_multiplier)
	character.move_and_slide()

	if not character.is_on_floor():
		state_machine.transition_to("Fall")
		return

	if InputManager.jump_buffered:
		InputManager.consume_jump_buffer()
		state_machine.transition_to("HighJump")
		return

	if InputManager.crouch_just_pressed:
		state_machine.transition_to("Idle")
