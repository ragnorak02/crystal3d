class_name EnemyDieState
extends CharacterState

var _timer: float = 0.0
const DEATH_DELAY: float = 0.8


func enter() -> void:
	_timer = 0.0
	# Disable collision so player can walk through
	character.collision_layer = 0
	character.collision_mask = 0
	# Visual feedback — shrink
	var tween := character.create_tween()
	tween.tween_property(character, "scale", Vector3(0.1, 0.1, 0.1), DEATH_DELAY)


func process_physics(delta: float) -> void:
	_timer += delta
	if _timer >= DEATH_DELAY:
		character.queue_free()
