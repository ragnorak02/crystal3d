extends Control
## Pause menu — overlays gameplay. Esc to toggle.

@onready var resume_btn: Button = $Panel/VBoxContainer/ResumeButton
@onready var settings_btn: Button = $Panel/VBoxContainer/SettingsButton
@onready var quit_btn: Button = $Panel/VBoxContainer/QuitButton


func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_btn.pressed.connect(_on_resume)
	settings_btn.pressed.connect(_on_settings)
	quit_btn.pressed.connect(_on_quit)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_confirm") and visible:
		var focused := get_viewport().gui_get_focus_owner()
		if focused is Button:
			focused.pressed.emit()
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_back"):
		if visible:
			_on_resume()
		elif GameManager.current_state == GameManager.GameState.PLAYING:
			_show_pause()
		get_viewport().set_input_as_handled()


func _show_pause() -> void:
	visible = true
	GameManager.pause_game()
	resume_btn.grab_focus()


func _on_resume() -> void:
	visible = false
	GameManager.resume_game()


func _on_settings() -> void:
	# In-game settings: keep paused, show settings over pause
	GameManager.go_to_scene("res://scenes/ui/Settings.tscn")


func _on_quit() -> void:
	visible = false
	GameManager.resume_game()
	GameManager.go_to_menu()
