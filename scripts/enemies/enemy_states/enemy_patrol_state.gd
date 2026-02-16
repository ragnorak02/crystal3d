class_name EnemyPatrolState
extends CharacterState

var _wander_target: Vector3
var _timer: float = 0.0
const PATROL_TIME: float = 4.0


func enter() -> void:
	_timer = 0.0
	var enemy := character as EnemyBase
	# Pick random point within patrol radius
	var angle := randf() * TAU
	var dist := randf_range(1.0, enemy.patrol_radius)
	_wander_target = enemy.spawn_position + Vector3(cos(angle) * dist, 0, sin(angle) * dist)


func process_physics(delta: float) -> void:
	var enemy := character as EnemyBase

	if not enemy.is_on_floor():
		enemy.velocity.y -= enemy.gravity * 2.0 * delta
	else:
		enemy.velocity.y = 0.0

	if enemy.target:
		state_machine.transition_to("Chase")
		return

	_timer += delta
	if _timer >= PATROL_TIME:
		state_machine.transition_to("EnemyIdle")
		return

	var to_target := _wander_target - enemy.global_position
	to_target.y = 0.0
	if to_target.length() < 0.3:
		state_machine.transition_to("EnemyIdle")
		return

	var direction := to_target.normalized()
	enemy.velocity.x = direction.x * enemy.move_speed * 0.5
	enemy.velocity.z = direction.z * enemy.move_speed * 0.5

	# Face movement direction
	enemy.rotation.y = atan2(direction.x, direction.z)
	enemy.move_and_slide()
