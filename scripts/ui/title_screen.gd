extends Control
## Title screen with blinking "Press Any Button" prompt.

@onready var prompt_label: Label = $PromptLabel
var _blink_time: float = 0.0


func _ready() -> void:
	# Consume any leftover input from previous scene
	set_process_input(true)


func _process(delta: float) -> void:
	_blink_time += delta
	prompt_label.modulate.a = 0.5 + 0.5 * sin(_blink_time * 3.0)


func _input(event: InputEvent) -> void:
	if event.is_pressed() and not event is InputEventMouseMotion:
		GameManager.go_to_menu()
