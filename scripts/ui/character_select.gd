extends Control
## Character select screen with 3 panels navigable by keyboard/controller.

@onready var panels: Array[Panel] = [
	$HBoxContainer/Panel0,
	$HBoxContainer/Panel1,
	$HBoxContainer/Panel2,
]

var selected_index: int = 0


func _ready() -> void:
	_update_panels()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_right") or event.is_action_pressed("lock_on_next"):
		selected_index = mini(selected_index + 1, 2)
		_update_panels()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("move_left") or event.is_action_pressed("lock_on_prev"):
		selected_index = maxi(selected_index - 1, 0)
		_update_panels()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_confirm") or event.is_action_pressed("jump"):
		GameManager.go_to_game(selected_index)
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_back"):
		GameManager.go_to_menu()
		get_viewport().set_input_as_handled()


func _update_panels() -> void:
	for i in range(3):
		var panel := panels[i]
		var data := CharacterData.get_character(i)
		var color_rect := panel.get_node("ColorPreview") as ColorRect
		var name_label := panel.get_node("NameLabel") as Label
		var desc_label := panel.get_node("DescLabel") as Label

		color_rect.color = data["color"]
		name_label.text = data["name"]
		desc_label.text = data["description"]

		# Highlight selected panel
		if i == selected_index:
			panel.modulate = Color(1, 1, 1, 1)
			panel.get_theme_stylebox("panel").border_color = Color(1, 0.85, 0.2)
		else:
			panel.modulate = Color(0.6, 0.6, 0.6, 1)
