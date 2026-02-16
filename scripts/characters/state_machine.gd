class_name StateMachine
extends Node
## Generic state machine. Children must be CharacterState nodes.

@export var initial_state_name: String = "Idle"

var current_state: CharacterState
var states: Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is CharacterState:
			states[child.name] = child
			child.state_machine = self
			child.character = get_parent()
	if states.has(initial_state_name):
		current_state = states[initial_state_name]
		current_state.enter()


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.process_physics(delta)


func _process(delta: float) -> void:
	if current_state:
		current_state.process_frame(delta)


func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		push_warning("StateMachine: no state '%s'" % state_name)
		return
	if current_state:
		current_state.exit()
	current_state = states[state_name]
	current_state.enter()
