class_name Dragonbound
extends CharacterBase
## Purple agile fighter with double jump, glide, and dragon companion.


func _ready() -> void:
	super._ready()
	move_speed = 7.5
	sprint_speed = 12.0
	attack_damage = 1


func can_double_jump() -> bool:
	return true


func can_glide() -> bool:
	return true


func can_dragon_jump() -> bool:
	return true


func get_max_air_jumps() -> int:
	return 2


func get_companion_scene() -> String:
	return "res://scenes/companions/DragonCompanion.tscn"
