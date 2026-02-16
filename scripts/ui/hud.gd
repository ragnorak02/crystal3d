extends CanvasLayer
## In-game HUD — hearts, ability icons, control hints, lock-on indicator.

@onready var hearts_container: HBoxContainer = $HeartsContainer
@onready var ability_label: Label = $AbilityLabel
@onready var hints_label: Label = $HintsLabel
@onready var lock_on_indicator: Control = $LockOnIndicator

var _player: CharacterBase


func _ready() -> void:
	lock_on_indicator.visible = false
	hints_label.text = "WASD Move | Shift Sprint | Space Jump | C Crouch\nLMB Attack | RMB Magic | Q Companion | Tab Lock-On"
	await get_tree().process_frame
	_find_player()


func _process(_delta: float) -> void:
	if not _player:
		_find_player()
		return

	# Update lock-on indicator position
	if _player.lock_on_target and is_instance_valid(_player.lock_on_target):
		lock_on_indicator.visible = true
		var camera := get_viewport().get_camera_3d()
		if camera:
			var target_pos := _player.lock_on_target.global_position + Vector3(0, 0.5, 0)
			var screen_pos := camera.unproject_position(target_pos)
			lock_on_indicator.position = screen_pos - lock_on_indicator.size / 2.0
	else:
		lock_on_indicator.visible = false


func _find_player() -> void:
	var player_node := get_tree().get_first_node_in_group("player")
	if player_node is CharacterBase:
		_player = player_node
		_player.health_changed.connect(_on_health_changed)
		_update_hearts(_player.current_hp, _player.max_hp)


func _on_health_changed(current: int, maximum: int) -> void:
	_update_hearts(current, maximum)


func _update_hearts(current: int, maximum: int) -> void:
	# Each heart = 2 HP. Display as full/half/empty.
	var num_hearts := ceili(maximum / 2.0)
	# Clear existing
	for child in hearts_container.get_children():
		child.queue_free()

	for i in range(num_hearts):
		var hp_for_heart := current - i * 2
		var label := Label.new()
		label.add_theme_font_size_override("font_size", 28)
		if hp_for_heart >= 2:
			label.text = "[F]"  # Full heart
			label.modulate = Color(1, 0.2, 0.2)
		elif hp_for_heart == 1:
			label.text = "[H]"  # Half heart
			label.modulate = Color(1, 0.5, 0.3)
		else:
			label.text = "[E]"  # Empty heart
			label.modulate = Color(0.4, 0.4, 0.4)
		hearts_container.add_child(label)
