extends Node3D
## Dragon companion that follows player and attacks on Q with cooldown.

@export var offset: Vector3 = Vector3(-0.5, 0.8, 0.4)
@export var follow_speed: float = 4.0
@export var bob_speed: float = 1.8
@export var bob_amplitude: float = 0.08
@export var attack_cooldown: float = 3.0
@export var attack_range: float = 3.0
@export var attack_damage: int = 2

var target: Node3D
var time_elapsed: float = 0.0
var _cooldown_timer: float = 0.0


func _ready() -> void:
	await get_tree().process_frame
	target = get_tree().get_first_node_in_group("player")
	if target:
		global_position = target.global_position + offset


func _process(delta: float) -> void:
	if not target:
		target = get_tree().get_first_node_in_group("player")
		return

	time_elapsed += delta
	_cooldown_timer = maxf(_cooldown_timer - delta, 0.0)

	var target_pos := target.global_position + offset
	target_pos.y += sin(time_elapsed * bob_speed) * bob_amplitude
	global_position = global_position.lerp(target_pos, follow_speed * delta)

	# Attack on companion_action
	if InputManager.companion_just_pressed and _cooldown_timer <= 0.0:
		_perform_attack()
		_cooldown_timer = attack_cooldown


func flash() -> void:
	var light := get_node_or_null("Light") as OmniLight3D
	if light:
		var tween := create_tween()
		tween.tween_property(light, "light_energy", 3.0, 0.05)
		tween.tween_property(light, "light_energy", 0.3, 0.4)
		var tween2 := create_tween()
		tween2.tween_property(light, "omni_range", 4.0, 0.05)
		tween2.tween_property(light, "omni_range", 1.5, 0.4)
	var body := get_node_or_null("Body") as MeshInstance3D
	if body and body.get_surface_override_material(0):
		var mat := body.get_surface_override_material(0) as StandardMaterial3D
		if mat:
			var tween3 := create_tween()
			tween3.tween_property(mat, "emission_energy_multiplier", 5.0, 0.05)
			tween3.tween_property(mat, "emission_energy_multiplier", 1.5, 0.4)


func _perform_attack() -> void:
	# Find nearest enemy and deal damage
	var enemies := get_tree().get_nodes_in_group("enemies")
	var nearest: Node3D = null
	var nearest_dist := attack_range

	for e in enemies:
		if not e is Node3D or not e.is_inside_tree():
			continue
		var dist := global_position.distance_to(e.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = e

	if nearest and nearest.has_method("take_damage"):
		nearest.take_damage(attack_damage)
		# Visual: quick lunge toward target
		var tween := create_tween()
		var attack_pos := nearest.global_position + Vector3(0, 0.3, 0)
		tween.tween_property(self, "global_position", attack_pos, 0.15)
		tween.tween_property(self, "global_position", target.global_position + offset, 0.3)
