extends CanvasLayer
## Persistent control hints bar at the bottom of every screen.

var _label: Label


func _ready() -> void:
	layer = 100
	process_mode = Node.PROCESS_MODE_ALWAYS

	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var panel := PanelContainer.new()
	panel.anchor_left = 0.0
	panel.anchor_right = 1.0
	panel.anchor_top = 1.0
	panel.anchor_bottom = 1.0
	panel.offset_top = -40.0
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.7)
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	panel.add_theme_stylebox_override("panel", style)

	_label = Label.new()
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_color_override("font_color", Color("f0c850"))
	_label.add_theme_font_size_override("font_size", 14)
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	panel.add_child(_label)
	root.add_child(panel)
	add_child(root)

	GameManager.state_changed.connect(_on_state_changed)
	_update_hints(GameManager.current_state)


func _on_state_changed(new_state: GameManager.GameState) -> void:
	_update_hints(new_state)


func _update_hints(state: GameManager.GameState) -> void:
	match state:
		GameManager.GameState.TITLE:
			_label.text = "Start: Any Key / Any Button"
		GameManager.GameState.MENU:
			_label.text = "Navigate: Arrows / DPad  |  Select: Enter / A  |  Back: Esc / B"
		GameManager.GameState.SELECT:
			_label.text = "Browse: A/D / DPad  |  Select: E / A  |  Back: Esc / B"
		GameManager.GameState.PLAYING:
			_label.text = "Move: WASD / LS  |  Sprint: Shift / LT  |  Jump: Space / A  |  Attack: LMB / X  |  Magic: RMB / Y  |  Companion: Q / LB  |  Lock-On: Tab / RB  |  Pause: Esc / B"
		GameManager.GameState.PAUSED:
			_label.text = "Navigate: Arrows / DPad  |  Select: Enter / A  |  Resume: Esc / B"
