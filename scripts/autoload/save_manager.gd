extends Node
## JSON save system at user://hybrid_nights_save.json

const SAVE_PATH: String = "user://hybrid_nights_save.json"
const SAVE_VERSION: int = 1


func save_game(data: Dictionary) -> void:
	data["version"] = SAVE_VERSION
	data["timestamp"] = Time.get_datetime_string_from_system()
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))


func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return {}
	var json := JSON.new()
	var err := json.parse(file.get_as_text())
	if err != OK:
		return {}
	var result = json.data
	if result is Dictionary:
		return result
	return {}


func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
