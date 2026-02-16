class_name Hurtbox
extends Area3D
## Receives damage from Hitbox overlaps.

signal hurt(damage: int, knockback_force: float, hit_origin: Vector3)


func _ready() -> void:
	monitorable = true
	monitoring = false


func take_hit(damage: int, knockback_force: float, hit_origin: Vector3) -> void:
	hurt.emit(damage, knockback_force, hit_origin)
