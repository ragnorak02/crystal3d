extends Node
## Centralized input polling with 0.15s input buffering.
## Read these properties from any script instead of calling Input directly.

# Movement
var move_direction: Vector2 = Vector2.ZERO

# Actions - current frame
var jump_just_pressed: bool = false
var crouch_just_pressed: bool = false
var attack_just_pressed: bool = false
var magic_charge_pressed: bool = false
var magic_charge_just_released: bool = false
var companion_just_pressed: bool = false
var lock_on_toggle_just_pressed: bool = false
var lock_on_next_just_pressed: bool = false
var lock_on_prev_just_pressed: bool = false
var run_pressed: bool = false
var jump_pressed: bool = false
var ui_confirm_just_pressed: bool = false
var ui_back_just_pressed: bool = false

# Input buffering (0.15s)
const BUFFER_DURATION: float = 0.15
var _jump_buffer: float = 0.0
var _attack_buffer: float = 0.0

var jump_buffered: bool:
	get: return _jump_buffer > 0.0
var attack_buffered: bool:
	get: return _attack_buffer > 0.0


func consume_jump_buffer() -> void:
	_jump_buffer = 0.0


func consume_attack_buffer() -> void:
	_attack_buffer = 0.0


func _process(delta: float) -> void:
	# Movement vector
	move_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	# Actions
	jump_just_pressed = Input.is_action_just_pressed("jump")
	crouch_just_pressed = Input.is_action_just_pressed("crouch")
	attack_just_pressed = Input.is_action_just_pressed("attack")
	magic_charge_pressed = Input.is_action_pressed("magic_charge")
	magic_charge_just_released = Input.is_action_just_released("magic_charge")
	companion_just_pressed = Input.is_action_just_pressed("companion_action")
	lock_on_toggle_just_pressed = Input.is_action_just_pressed("lock_on_toggle")
	lock_on_next_just_pressed = Input.is_action_just_pressed("lock_on_next")
	lock_on_prev_just_pressed = Input.is_action_just_pressed("lock_on_prev")
	run_pressed = Input.is_action_pressed("run")
	jump_pressed = Input.is_action_pressed("jump")
	ui_confirm_just_pressed = Input.is_action_just_pressed("ui_confirm")
	ui_back_just_pressed = Input.is_action_just_pressed("ui_back")

	# Buffering
	if jump_just_pressed:
		_jump_buffer = BUFFER_DURATION
	elif _jump_buffer > 0.0:
		_jump_buffer -= delta

	if attack_just_pressed:
		_attack_buffer = BUFFER_DURATION
	elif _attack_buffer > 0.0:
		_attack_buffer -= delta
