class_name Projectile
extends CharacterBody3D
## Base projectile that travels forward and hits enemies.

@export var speed: float = 15.0
@export var damage: int = 2
@export var lifetime: float = 3.0

var direction: Vector3 = Vector3.FORWARD
var _time_alive: float = 0.0


func set_direction(dir: Vector3) -> void:
	direction = dir.normalized()
	look_at(global_position + direction, Vector3.UP)


func _physics_process(delta: float) -> void:
	_time_alive += delta
	if _time_alive >= lifetime:
		queue_free()
		return

	velocity = direction * speed
	var collision := move_and_slide()

	# Check for hurtbox overlaps via the Area3D child
	var area := get_node_or_null("HitArea") as Area3D
	if area:
		for overlapping in area.get_overlapping_areas():
			if overlapping is Hurtbox:
				overlapping.take_hit(damage, 2.0, global_position)
				queue_free()
				return

	# Destroy on wall collision
	if is_on_wall():
		queue_free()
