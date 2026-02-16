class_name SpearAdept
extends CharacterBase
## Green lancer with long-reach thrust. Slower but powerful.


func _ready() -> void:
	super._ready()
	move_speed = 5.5
	sprint_speed = 8.0
	attack_damage = 2


func get_companion_scene() -> String:
	return "res://scenes/companions/FairyCompanion.tscn"
