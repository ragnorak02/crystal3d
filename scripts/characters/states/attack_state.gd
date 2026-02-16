class_name AttackState
extends CharacterState
## Melee attack. Enables hitbox for duration, player can move.

var _timer: float = 0.0
var _duration: float = 0.3
var _hitbox_activated: bool = false


func enter() -> void:
	_timer = 0.0
	_hitbox_activated = false
	_duration = 0.3

	# Orient toward lock-on target if available
	if character.lock_on_target:
		var to_target: Vector3 = (character.lock_on_target.global_position - character.global_position).normalized()
		character.rotation.y = atan2(to_target.x, to_target.z)

	# Activate hitbox
	var hitbox := character.get_node_or_null("Hitbox") as Hitbox
	if hitbox:
		hitbox.damage = character.attack_damage
		hitbox.activate(_duration)
		_hitbox_activated = true


func exit() -> void:
	var hitbox := character.get_node_or_null("Hitbox") as Hitbox
	if hitbox:
		hitbox.deactivate()


func process_physics(delta: float) -> void:
	_timer += delta
	character.apply_gravity(delta)
	# Allow movement during melee (reduced speed)
	character.apply_movement(delta, character.move_speed * 0.5)
	character.move_and_slide()

	if _timer >= _duration + 0.1:
		if InputManager.move_direction.length() > 0.1:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
