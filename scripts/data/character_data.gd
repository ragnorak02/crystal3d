class_name CharacterData
## Static character configuration data for character select and spawning.

const CHARACTERS: Array[Dictionary] = [
	{
		"id": 0,
		"name": "Fighter",
		"description": "A balanced warrior with fireball magic.\nStrong melee, medium speed.",
		"color": Color(0.3, 0.5, 0.85),
		"scene_path": "res://scenes/characters/Fighter.tscn",
		"companion_scene": "res://scenes/companions/FairyCompanion.tscn",
	},
	{
		"id": 1,
		"name": "Spear Adept",
		"description": "A disciplined lancer with long reach.\nSlower but powerful thrust attacks.",
		"color": Color(0.3, 0.7, 0.35),
		"scene_path": "res://scenes/characters/SpearAdept.tscn",
		"companion_scene": "res://scenes/companions/FairyCompanion.tscn",
	},
	{
		"id": 2,
		"name": "Dragonbound",
		"description": "An agile fighter bonded with a dragon.\nDouble jump, glide, dragon companion.",
		"color": Color(0.6, 0.3, 0.8),
		"scene_path": "res://scenes/characters/Dragonbound.tscn",
		"companion_scene": "res://scenes/companions/DragonCompanion.tscn",
	},
]


static func get_character(id: int) -> Dictionary:
	if id >= 0 and id < CHARACTERS.size():
		return CHARACTERS[id]
	return CHARACTERS[0]
