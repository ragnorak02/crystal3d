class_name EnemyIdleState
extends CharacterState

var _timer: float = 0.0
const WAIT_TIME: float = 2.0


func enter() -> void:
	_timer = 0.0


func process_physics(delta: float) -> void:
	var enemy := character as EnemyBase
	# Apply gravity
	if not enemy.is_on_floor():
		enemy.velocity.y -= enemy.gravity * 2.0 * delta
	else:
		enemy.velocity.y = 0.0
	enemy.velocity.x = 0.0
	enemy.velocity.z = 0.0
	enemy.move_and_slide()

	if enemy.target:
		state_machine.transition_to("Chase")
		return

	_timer += delta
	if _timer >= WAIT_TIME:
		state_machine.transition_to("Patrol")
