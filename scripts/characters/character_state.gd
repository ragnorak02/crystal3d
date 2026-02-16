class_name CharacterState
extends Node
## Base class for character states in the state machine.

var character  # CharacterBase or EnemyBase — untyped to avoid cyclic refs
var state_machine: Node


func enter() -> void:
	pass


func exit() -> void:
	pass


func process_physics(delta: float) -> void:
	pass


func process_frame(delta: float) -> void:
	pass
