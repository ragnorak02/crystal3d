extends SceneTree
## Unified test runner — outputs JSON for Hybrid Nights Studio OS integration.
## Usage: godot --headless --path <project> --script tests/run-tests.gd
## Results written to tests/results.json and printed to stdout.

var _passed := 0
var _failed := 0
var _details: Array[Dictionary] = []
var _start_time: int


func _init() -> void:
	_start_time = Time.get_ticks_msec()

	_test_input_actions()
	_test_scene_loading()
	_test_character_structure()
	_test_enemy_structure()
	_test_combat_components()
	_test_save_system()
	_test_script_existence()
	_test_data_classes()
	_test_performance()

	_output_results()
	quit()


func _assert(test_name: String, condition: bool, msg: String = "") -> void:
	if condition:
		_passed += 1
		_details.append({"name": test_name, "status": "pass", "message": msg if msg else "OK"})
	else:
		_failed += 1
		_details.append({"name": test_name, "status": "fail", "message": msg if msg else "Assertion failed"})


func _output_results() -> void:
	var duration := Time.get_ticks_msec() - _start_time
	var total := _passed + _failed
	var status := "pass" if _failed == 0 else "fail"
	var ts := Time.get_datetime_string_from_system(true) + "Z"

	var result := {
		"status": status,
		"testsTotal": total,
		"testsPassed": _passed,
		"durationMs": duration,
		"timestamp": ts,
		"details": _details
	}

	var json_str := JSON.stringify(result, "  ")

	# Write to file for launcher/CI consumption
	var file := FileAccess.open("res://tests/results.json", FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()

	print(json_str)


# ---------------------------------------------------------------------------
# Input Actions — verify all 16 mapped actions exist
# ---------------------------------------------------------------------------
func _test_input_actions() -> void:
	var actions := [
		"move_forward", "move_backward", "move_left", "move_right",
		"jump", "crouch", "run", "attack", "magic_charge",
		"companion_action", "lock_on_toggle", "lock_on_next", "lock_on_prev",
		"ui_confirm", "ui_back", "ui_accept",
	]
	for action in actions:
		_assert("input/%s" % action, InputMap.has_action(action), "")


# ---------------------------------------------------------------------------
# Scene Loading — every major .tscn instantiates without crash
# ---------------------------------------------------------------------------
func _test_scene_loading() -> void:
	var scenes := {
		"TitleScreen": "res://scenes/ui/TitleScreen.tscn",
		"MainMenu": "res://scenes/ui/MainMenu.tscn",
		"CharacterSelect": "res://scenes/ui/CharacterSelect.tscn",
		"HUD": "res://scenes/ui/HUD.tscn",
		"Settings": "res://scenes/ui/Settings.tscn",
		"PauseMenu": "res://scenes/ui/PauseMenu.tscn",
		"GameLevel": "res://scenes/levels/GameLevel.tscn",
		"Fighter": "res://scenes/characters/Fighter.tscn",
		"SpearAdept": "res://scenes/characters/SpearAdept.tscn",
		"Dragonbound": "res://scenes/characters/Dragonbound.tscn",
		"MeleeGrunt": "res://scenes/enemies/MeleeGrunt.tscn",
		"Fireball": "res://scenes/combat/Fireball.tscn",
		"FairyCompanion": "res://scenes/companions/FairyCompanion.tscn",
		"DragonCompanion": "res://scenes/companions/DragonCompanion.tscn",
	}
	for scene_name in scenes:
		var scene := load(scenes[scene_name]) as PackedScene
		_assert("scene/%s" % scene_name, scene != null, "")
		if scene:
			scene.instantiate().queue_free()


# ---------------------------------------------------------------------------
# Character Structure — each character has required nodes
# ---------------------------------------------------------------------------
func _test_character_structure() -> void:
	var chars := {
		"Fighter": "res://scenes/characters/Fighter.tscn",
		"SpearAdept": "res://scenes/characters/SpearAdept.tscn",
		"Dragonbound": "res://scenes/characters/Dragonbound.tscn",
	}
	for char_name in chars:
		var scene := load(chars[char_name]) as PackedScene
		if not scene:
			_assert("character/%s/loads" % char_name, false, "Scene not found")
			continue
		var inst := scene.instantiate()
		_assert("character/%s/is_CharacterBody3D" % char_name, inst is CharacterBody3D, "")
		_assert("character/%s/has_StateMachine" % char_name, inst.get_node_or_null("StateMachine") != null, "")
		_assert("character/%s/has_Hitbox" % char_name, inst.get_node_or_null("Hitbox") is Area3D, "")
		_assert("character/%s/has_Hurtbox" % char_name, inst.get_node_or_null("Hurtbox") is Area3D, "")
		inst.queue_free()


# ---------------------------------------------------------------------------
# Enemy Structure — MeleeGrunt nodes + all 5 AI states
# ---------------------------------------------------------------------------
func _test_enemy_structure() -> void:
	var scene := load("res://scenes/enemies/MeleeGrunt.tscn") as PackedScene
	if not scene:
		_assert("enemy/MeleeGrunt/loads", false, "Scene not found")
		return
	var inst := scene.instantiate()
	_assert("enemy/MeleeGrunt/is_CharacterBody3D", inst is CharacterBody3D, "")
	_assert("enemy/MeleeGrunt/has_StateMachine", inst.get_node_or_null("StateMachine") != null, "")
	_assert("enemy/MeleeGrunt/has_DetectionArea", inst.get_node_or_null("DetectionArea") is Area3D, "")
	_assert("enemy/MeleeGrunt/has_Hitbox", inst.get_node_or_null("Hitbox") is Area3D, "")
	_assert("enemy/MeleeGrunt/has_Hurtbox", inst.get_node_or_null("Hurtbox") is Area3D, "")
	var sm := inst.get_node_or_null("StateMachine")
	if sm:
		for state_name in ["EnemyIdle", "Patrol", "Chase", "EnemyAttack", "Die"]:
			_assert("enemy/MeleeGrunt/state_%s" % state_name, sm.get_node_or_null(state_name) != null, "")
	inst.queue_free()


# ---------------------------------------------------------------------------
# Combat Components — Fireball structure, AttackData, HealthComponent
# ---------------------------------------------------------------------------
func _test_combat_components() -> void:
	var fb_scene := load("res://scenes/combat/Fireball.tscn") as PackedScene
	if fb_scene:
		var fb := fb_scene.instantiate()
		_assert("combat/Fireball/has_HitArea", fb.get_node_or_null("HitArea") is Area3D, "")
		_assert("combat/Fireball/has_Mesh", fb.get_node_or_null("Mesh") is MeshInstance3D, "")
		fb.queue_free()
	else:
		_assert("combat/Fireball/loads", false, "Scene not found")

	var atk := AttackData.new()
	_assert("combat/AttackData/defaults_valid", atk.damage == 1 and atk.duration > 0.0, "")

	var health := HealthComponent.new()
	health.max_hp = 6
	health._ready()
	_assert("combat/HealthComponent/starts_at_max", health.current_hp == 6, "")
	var died := {"fired": false}
	health.died.connect(func(): died["fired"] = true)
	health.take_damage(6)
	_assert("combat/HealthComponent/dies_at_zero", health.current_hp == 0 and died["fired"], "")


# ---------------------------------------------------------------------------
# Save System — round-trip write / read / delete
# ---------------------------------------------------------------------------
func _test_save_system() -> void:
	var sm_script := load("res://scripts/autoload/save_manager.gd")
	if not sm_script:
		_assert("save/script_loads", false, "SaveManager script not found")
		return
	var sm := Node.new()
	sm.set_script(sm_script)
	sm.delete_save()
	_assert("save/empty_initially", not sm.has_save(), "")
	sm.save_game({"character_id": 1, "current_hp": 4})
	_assert("save/write_succeeds", sm.has_save(), "")
	var data: Dictionary = sm.load_game()
	_assert("save/read_character_id", data.get("character_id") == 1, "")
	_assert("save/has_version", data.has("version"), "")
	sm.delete_save()
	_assert("save/delete_succeeds", not sm.has_save(), "")
	sm.free()


# ---------------------------------------------------------------------------
# Script Existence — all core .gd files present in project
# ---------------------------------------------------------------------------
func _test_script_existence() -> void:
	var scripts := [
		"res://scripts/autoload/game_manager.gd",
		"res://scripts/autoload/input_manager.gd",
		"res://scripts/autoload/save_manager.gd",
		"res://scripts/autoload/control_hints.gd",
		"res://scripts/characters/character_base.gd",
		"res://scripts/characters/fighter.gd",
		"res://scripts/characters/spear_adept.gd",
		"res://scripts/characters/dragonbound.gd",
		"res://scripts/enemies/enemy_base.gd",
		"res://scripts/enemies/melee_grunt.gd",
		"res://scripts/combat/hitbox.gd",
		"res://scripts/combat/hurtbox.gd",
	]
	for path in scripts:
		_assert("script/%s" % path.get_file().get_basename(), ResourceLoader.exists(path), "")


# ---------------------------------------------------------------------------
# Data Classes — ElementTypes + CharacterData
# ---------------------------------------------------------------------------
func _test_data_classes() -> void:
	_assert(
		"data/fire_beats_ice",
		ElementTypes.get_strength(ElementTypes.Element.FIRE) == ElementTypes.Element.ICE,
		""
	)
	var char0 := CharacterData.get_character(0)
	_assert("data/character_0_is_fighter", char0["name"] == "Fighter", "")
	_assert("data/three_characters", CharacterData.CHARACTERS.size() == 3, "")


# ---------------------------------------------------------------------------
# Performance — scene instantiation completes in under 5 seconds
# ---------------------------------------------------------------------------
func _test_performance() -> void:
	var start := Time.get_ticks_msec()
	var heavy_scenes := [
		"res://scenes/levels/GameLevel.tscn",
		"res://scenes/characters/Fighter.tscn",
		"res://scenes/enemies/MeleeGrunt.tscn",
	]
	for path in heavy_scenes:
		var scene := load(path) as PackedScene
		if scene:
			scene.instantiate().queue_free()
	var elapsed := Time.get_ticks_msec() - start
	_assert("perf/scene_load_under_5s", elapsed < 5000, "Loaded in %dms" % elapsed)
