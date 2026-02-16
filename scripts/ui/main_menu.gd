extends Control
## Main menu with keyboard/controller navigation.

@onready var continue_btn: Button = $VBoxContainer/ContinueButton
@onready var new_game_btn: Button = $VBoxContainer/NewGameButton
@onready var quick_game_btn: Button = $VBoxContainer/QuickGameButton
@onready var settings_btn: Button = $VBoxContainer/SettingsButton
@onready var quit_btn: Button = $VBoxContainer/QuitButton


func _ready() -> void:
	continue_btn.visible = SaveManager.has_save()
	continue_btn.pressed.connect(_on_continue)
	new_game_btn.pressed.connect(_on_new_game)
	quick_game_btn.pressed.connect(_on_quick_game)
	settings_btn.pressed.connect(_on_settings)
	quit_btn.pressed.connect(_on_quit)

	# Set up circular focus navigation
	var first_btn := continue_btn if continue_btn.visible else new_game_btn
	first_btn.focus_neighbor_top = quit_btn.get_path()
	quit_btn.focus_neighbor_bottom = first_btn.get_path()

	# Focus first available button for controller navigation
	if continue_btn.visible:
		continue_btn.grab_focus()
	else:
		new_game_btn.grab_focus()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_confirm"):
		var focused := get_viewport().gui_get_focus_owner()
		if focused is Button:
			focused.pressed.emit()
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_back"):
		_on_quit()
		get_viewport().set_input_as_handled()


func _on_continue() -> void:
	var data := SaveManager.load_game()
	if data.has("character_id"):
		GameManager.selected_character_id = data["character_id"]
	GameManager.go_to_game()


func _on_new_game() -> void:
	SaveManager.delete_save()
	GameManager.go_to_character_select()


func _on_quick_game() -> void:
	GameManager.go_to_game(0)  # Default to Fighter


func _on_settings() -> void:
	GameManager.go_to_scene("res://scenes/ui/Settings.tscn")


func _on_quit() -> void:
	get_tree().quit()
