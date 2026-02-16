class_name JumpState
extends CharacterState


func enter() -> void:
	character.air_jump_count = 0
	character.velocity.y = character.jump_force


func process_physics(delta: float) -> void:
	character.apply_gravity(delta)
	character.apply_movement(delta)
	character.move_and_slide()

	if character.velocity.y < 0.0:
		state_machine.transition_to("Fall")
