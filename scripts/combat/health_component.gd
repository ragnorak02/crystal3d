class_name HealthComponent
extends Node
## Reusable health tracker. Attach to any entity with HP.

@export var max_hp: int = 6

var current_hp: int

signal health_changed(current: int, maximum: int)
signal died


func _ready() -> void:
	current_hp = max_hp


func take_damage(amount: int) -> void:
	current_hp = maxi(current_hp - amount, 0)
	health_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		died.emit()


func heal(amount: int) -> void:
	current_hp = mini(current_hp + amount, max_hp)
	health_changed.emit(current_hp, max_hp)
