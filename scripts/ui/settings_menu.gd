extends Control
## Settings menu — volume sliders and fullscreen toggle.

@onready var master_slider: HSlider = $VBoxContainer/MasterVolume/Slider
@onready var fullscreen_check: CheckButton = $VBoxContainer/FullscreenToggle/CheckButton
@onready var back_btn: Button = $VBoxContainer/BackButton

var _return_scene: String = ""


func _ready() -> void:
	# Load current settings
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	fullscreen_check.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

	master_slider.value_changed.connect(_on_volume_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	back_btn.pressed.connect(_on_back)
	back_btn.grab_focus()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_confirm"):
		var focused := get_viewport().gui_get_focus_owner()
		if focused is Button:
			focused.pressed.emit()
			get_viewport().set_input_as_handled()
		elif focused is CheckButton:
			focused.button_pressed = !focused.button_pressed
			get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_back"):
		_on_back()
		get_viewport().set_input_as_handled()


func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_fullscreen_toggled(enabled: bool) -> void:
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_back() -> void:
	GameManager.go_to_menu()
