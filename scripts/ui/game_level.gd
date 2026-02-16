extends Node3D
## Main game level. Spawns selected character and companion at runtime.

@export var spawn_point: Vector3 = Vector3(0, 0.1, 0)

var _player: CharacterBase


func _ready() -> void:
	_spawn_character()
	# Save on level entry
	_save_progress()


func _spawn_character() -> void:
	var char_data := CharacterData.get_character(GameManager.selected_character_id)
	var char_scene := load(char_data["scene_path"]) as PackedScene
	if not char_scene:
		push_error("GameLevel: Failed to load character scene: %s" % char_data["scene_path"])
		return

	_player = char_scene.instantiate() as CharacterBase
	_player.global_position = spawn_point
	add_child(_player)

	# Connect hurtbox to take damage
	var hurtbox := _player.get_node_or_null("Hurtbox") as Hurtbox
	if hurtbox:
		hurtbox.hurt.connect(_on_player_hurt)

	# Spawn companion
	var companion_path: String = char_data.get("companion_scene", "")
	if companion_path != "":
		var comp_scene := load(companion_path) as PackedScene
		if comp_scene:
			var companion := comp_scene.instantiate()
			add_child(companion)
			_player.companion = companion

	_player.died.connect(_on_player_died)


func _on_player_hurt(damage: int, _knockback: float, _origin: Vector3) -> void:
	if _player:
		_player.take_damage(damage)


func _on_player_died() -> void:
	# Restart level after brief delay
	await get_tree().create_timer(1.5).timeout
	GameManager.go_to_game()


func _save_progress() -> void:
	if not _player:
		return
	SaveManager.save_game({
		"character_id": GameManager.selected_character_id,
		"level_path": scene_file_path,
		"current_hp": _player.current_hp,
		"max_hp": _player.max_hp,
	})
