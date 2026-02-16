class_name DoubleJumpState
extends CharacterState
## Dragonbound double jump — second jump in mid-air.


func enter() -> void:
	character.velocity.y = character.jump_force * 0.85


func process_physics(delta: float) -> void:
	character.apply_gravity(delta)
	character.apply_movement(delta)
	character.move_and_slide()

	if character.velocity.y < 0.0:
		state_machine.transition_to("Fall")
