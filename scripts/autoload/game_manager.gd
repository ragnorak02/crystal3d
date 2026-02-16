extends Node
## Global game state manager. Handles scene transitions and selected character.

enum GameState { TITLE, MENU, SELECT, PLAYING, PAUSED }

var current_state: GameState = GameState.TITLE
var selected_character_id: int = 0  # 0=Fighter, 1=SpearAdept, 2=Dragonbound

signal state_changed(new_state: GameState)


func change_state(new_state: GameState) -> void:
	current_state = new_state
	state_changed.emit(new_state)


func go_to_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)


func go_to_title() -> void:
	change_state(GameState.TITLE)
	go_to_scene("res://scenes/ui/TitleScreen.tscn")


func go_to_menu() -> void:
	change_state(GameState.MENU)
	go_to_scene("res://scenes/ui/MainMenu.tscn")


func go_to_character_select() -> void:
	change_state(GameState.SELECT)
	go_to_scene("res://scenes/ui/CharacterSelect.tscn")


func go_to_game(character_id: int = -1) -> void:
	if character_id >= 0:
		selected_character_id = character_id
	change_state(GameState.PLAYING)
	go_to_scene("res://scenes/levels/GameLevel.tscn")


func pause_game() -> void:
	if current_state == GameState.PLAYING:
		get_tree().paused = true
		change_state(GameState.PAUSED)


func resume_game() -> void:
	if current_state == GameState.PAUSED:
		get_tree().paused = false
		change_state(GameState.PLAYING)
