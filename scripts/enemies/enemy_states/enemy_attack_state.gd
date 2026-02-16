class_name EnemyAttackState
extends CharacterState

var _timer: float = 0.0
const ATTACK_DURATION: float = 0.3
const COOLDOWN: float = 0.8
var _hit_active: bool = false


func enter() -> void:
	_timer = 0.0
	_hit_active = false
	var hitbox := character.get_node_or_null("Hitbox") as Hitbox
	if hitbox:
		hitbox.damage = (character as EnemyBase).attack_damage
		hitbox.activate(ATTACK_DURATION)
		_hit_active = true


func exit() -> void:
	var hitbox := character.get_node_or_null("Hitbox") as Hitbox
	if hitbox:
		hitbox.deactivate()


func process_physics(delta: float) -> void:
	var enemy := character as EnemyBase
	_timer += delta

	if not enemy.is_on_floor():
		enemy.velocity.y -= enemy.gravity * 2.0 * delta
	else:
		enemy.velocity.y = 0.0
	enemy.velocity.x = 0.0
	enemy.velocity.z = 0.0
	enemy.move_and_slide()

	if _timer >= ATTACK_DURATION + COOLDOWN:
		state_machine.transition_to("Chase")
