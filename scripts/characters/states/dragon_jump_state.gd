class_name DragonJumpState
extends CharacterState
## Dragonbound 3rd jump — dragon-assisted boost at 70% force.


func enter() -> void:
	character.velocity.y = character.jump_force * 0.7
	# Dragon companion flash effect
	if character.companion and character.companion.has_method("flash"):
		character.companion.flash()


func process_physics(delta: float) -> void:
	character.apply_gravity(delta)
	character.apply_movement(delta)
	character.move_and_slide()

	if character.velocity.y < 0.0:
		state_machine.transition_to("Fall")
