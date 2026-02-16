class_name MagicRecoveryState
extends CharacterState
## Brief recovery after firing magic.

var _timer: float = 0.0
const RECOVERY_TIME: float = 0.4


func enter() -> void:
	_timer = 0.0


func process_physics(delta: float) -> void:
	_timer += delta
	character.apply_gravity(delta)
	character.velocity.x = move_toward(character.velocity.x, 0.0, character.deceleration * delta)
	character.velocity.z = move_toward(character.velocity.z, 0.0, character.deceleration * delta)
	character.move_and_slide()

	if _timer >= RECOVERY_TIME:
		state_machine.transition_to("Idle")
