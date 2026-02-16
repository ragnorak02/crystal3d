class_name LongJumpState
extends CharacterState
## Sprint + Jump = long low arc with forward boost.


func enter() -> void:
	character.air_jump_count = 0
	character.velocity.y = character.long_jump_force
	# Apply forward boost in facing direction
	var forward := -character.global_transform.basis.z.normalized()
	character.velocity.x = forward.x * character.long_jump_forward_boost
	character.velocity.z = forward.z * character.long_jump_forward_boost


func process_physics(delta: float) -> void:
	character.apply_gravity(delta)
	# Reduced air control during long jump
	character.apply_movement(delta, character.sprint_speed * 0.3)
	character.move_and_slide()

	if character.velocity.y < 0.0:
		state_machine.transition_to("Fall")
