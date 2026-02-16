class_name GlideState
extends CharacterState
## Dragonbound glide — slow descent with full air movement.

const GLIDE_FALL_SPEED: float = 1.5


func enter() -> void:
	# Cap downward velocity for smooth transition into glide
	if character.velocity.y < -GLIDE_FALL_SPEED:
		character.velocity.y = -GLIDE_FALL_SPEED


func process_physics(delta: float) -> void:
	# Gentle downward drift instead of full gravity
	character.velocity.y = move_toward(character.velocity.y, -GLIDE_FALL_SPEED, 10.0 * delta)
	character.apply_movement(delta)
	character.move_and_slide()

	if character.is_on_floor():
		character.air_jump_count = 0
		state_machine.transition_to("Idle")
		return

	# Release jump to stop gliding
	if not InputManager.jump_pressed:
		state_machine.transition_to("Fall")
