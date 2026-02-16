class_name HighJumpState
extends CharacterState
## Crouch + Jump = high vertical jump.


func enter() -> void:
	character.air_jump_count = 0
	character.set_crouch(false)
	character.velocity.y = character.high_jump_force


func process_physics(delta: float) -> void:
	character.apply_gravity(delta)
	character.apply_movement(delta, character.move_speed * 0.5)
	character.move_and_slide()

	if character.velocity.y < 0.0:
		state_machine.transition_to("Fall")
