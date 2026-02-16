class_name Hitbox
extends Area3D
## Deals damage when overlapping a Hurtbox. Enable/disable via monitoring.

@export var damage: int = 1
@export var knockback_force: float = 3.0

signal hit_landed(hurtbox: Area3D)

var _visual: MeshInstance3D


func _ready() -> void:
	monitoring = false
	area_entered.connect(_on_area_entered)


func activate(duration: float = 0.0) -> void:
	monitoring = true
	_show_visual()
	if duration > 0.0:
		await get_tree().create_timer(duration).timeout
		deactivate()


func deactivate() -> void:
	monitoring = false
	_hide_visual()


func _on_area_entered(area: Area3D) -> void:
	if area is Hurtbox:
		area.take_hit(damage, knockback_force, global_position)
		hit_landed.emit(area)


func _show_visual() -> void:
	if _visual:
		return
	var col_shape: CollisionShape3D = null
	for child in get_children():
		if child is CollisionShape3D:
			col_shape = child
			break
	if not col_shape or not col_shape.shape:
		return

	_visual = MeshInstance3D.new()
	var shape := col_shape.shape
	if shape is SphereShape3D:
		var mesh := SphereMesh.new()
		mesh.radius = shape.radius
		mesh.height = shape.radius * 2.0
		_visual.mesh = mesh
	elif shape is BoxShape3D:
		var mesh := BoxMesh.new()
		mesh.size = shape.size
		_visual.mesh = mesh
	elif shape is CapsuleShape3D:
		var mesh := CapsuleMesh.new()
		mesh.radius = shape.radius
		mesh.height = shape.height
		_visual.mesh = mesh
	else:
		_visual.queue_free()
		_visual = null
		return

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.0, 0.0, 0.35)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_visual.material_override = mat
	_visual.transform = col_shape.transform
	add_child(_visual)


func _hide_visual() -> void:
	if _visual:
		_visual.queue_free()
		_visual = null
