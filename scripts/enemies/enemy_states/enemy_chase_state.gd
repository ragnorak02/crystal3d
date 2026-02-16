class_name EnemyChaseState
extends CharacterState


func process_physics(delta: float) -> void:
	var enemy := character as EnemyBase

	if not enemy.is_on_floor():
		enemy.velocity.y -= enemy.gravity * 2.0 * delta
	else:
		enemy.velocity.y = 0.0

	if not enemy.target:
		state_machine.transition_to("EnemyIdle")
		return

	var to_target := enemy.target.global_position - enemy.global_position
	to_target.y = 0.0
	var distance := to_target.length()

	if distance <= enemy.attack_range:
		state_machine.transition_to("EnemyAttack")
		return

	if distance > enemy.detection_range * 1.5:
		enemy.target = null
		state_machine.transition_to("EnemyIdle")
		return

	var direction := to_target.normalized()
	enemy.velocity.x = direction.x * enemy.move_speed
	enemy.velocity.z = direction.z * enemy.move_speed
	enemy.rotation.y = atan2(direction.x, direction.z)
	enemy.move_and_slide()
