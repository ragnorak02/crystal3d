extends SceneTree
## Test: Asset existence validation — verifies all expected files are present.

func _init() -> void:
	print("=== ASSET VALIDATION TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	# --- Scene files (.tscn) ---
	print("[Scene Files]")
	var scenes := [
		"res://scenes/ui/TitleScreen.tscn",
		"res://scenes/ui/MainMenu.tscn",
		"res://scenes/ui/CharacterSelect.tscn",
		"res://scenes/ui/HUD.tscn",
		"res://scenes/ui/Settings.tscn",
		"res://scenes/ui/PauseMenu.tscn",
		"res://scenes/levels/GameLevel.tscn",
		"res://scenes/characters/CharacterBase.tscn",
		"res://scenes/characters/Fighter.tscn",
		"res://scenes/characters/SpearAdept.tscn",
		"res://scenes/characters/Dragonbound.tscn",
		"res://scenes/enemies/MeleeGrunt.tscn",
		"res://scenes/combat/Fireball.tscn",
		"res://scenes/companions/FairyCompanion.tscn",
		"res://scenes/companions/DragonCompanion.tscn",
	]
	for path in scenes:
		var fname: String = path.get_file()
		if ResourceLoader.exists(path):
			print("  PASS: %s exists" % fname)
			passed += 1
		else:
			print("  FAIL: %s missing" % fname)
			failed += 1

	# --- Core script files (.gd) ---
	print("")
	print("[Core Scripts]")
	var core_scripts := [
		"res://scripts/autoload/game_manager.gd",
		"res://scripts/autoload/input_manager.gd",
		"res://scripts/autoload/save_manager.gd",
		"res://scripts/autoload/control_hints.gd",
		"res://scripts/characters/character_base.gd",
		"res://scripts/characters/character_state.gd",
		"res://scripts/characters/state_machine.gd",
		"res://scripts/characters/fighter.gd",
		"res://scripts/characters/spear_adept.gd",
		"res://scripts/characters/dragonbound.gd",
		"res://scripts/enemies/enemy_base.gd",
		"res://scripts/enemies/melee_grunt.gd",
		"res://scripts/combat/hitbox.gd",
		"res://scripts/combat/hurtbox.gd",
		"res://scripts/combat/health_component.gd",
		"res://scripts/combat/attack_data.gd",
		"res://scripts/combat/projectile.gd",
		"res://scripts/companions/companion_base.gd",
		"res://scripts/companions/fairy_companion.gd",
		"res://scripts/companions/dragon_companion.gd",
		"res://scripts/camera/camera_rig.gd",
		"res://scripts/camera/lock_on_system.gd",
		"res://scripts/data/element_types.gd",
		"res://scripts/data/character_data.gd",
		"res://scripts/data/race_types.gd",
	]
	for path in core_scripts:
		var fname: String = path.get_file()
		if ResourceLoader.exists(path):
			print("  PASS: %s exists" % fname)
			passed += 1
		else:
			print("  FAIL: %s missing" % fname)
			failed += 1

	# --- Character state scripts ---
	print("")
	print("[Character States]")
	var char_states := [
		"res://scripts/characters/states/idle_state.gd",
		"res://scripts/characters/states/run_state.gd",
		"res://scripts/characters/states/sprint_state.gd",
		"res://scripts/characters/states/jump_state.gd",
		"res://scripts/characters/states/fall_state.gd",
		"res://scripts/characters/states/crouch_state.gd",
		"res://scripts/characters/states/attack_state.gd",
		"res://scripts/characters/states/magic_charge_state.gd",
		"res://scripts/characters/states/magic_recovery_state.gd",
		"res://scripts/characters/states/double_jump_state.gd",
		"res://scripts/characters/states/dragon_jump_state.gd",
		"res://scripts/characters/states/glide_state.gd",
		"res://scripts/characters/states/long_jump_state.gd",
		"res://scripts/characters/states/high_jump_state.gd",
	]
	for path in char_states:
		var fname: String = path.get_file()
		if ResourceLoader.exists(path):
			print("  PASS: %s exists" % fname)
			passed += 1
		else:
			print("  FAIL: %s missing" % fname)
			failed += 1

	# --- Enemy state scripts ---
	print("")
	print("[Enemy States]")
	var enemy_states := [
		"res://scripts/enemies/enemy_states/enemy_idle_state.gd",
		"res://scripts/enemies/enemy_states/enemy_patrol_state.gd",
		"res://scripts/enemies/enemy_states/enemy_chase_state.gd",
		"res://scripts/enemies/enemy_states/enemy_attack_state.gd",
		"res://scripts/enemies/enemy_states/enemy_die_state.gd",
	]
	for path in enemy_states:
		var fname: String = path.get_file()
		if ResourceLoader.exists(path):
			print("  PASS: %s exists" % fname)
			passed += 1
		else:
			print("  FAIL: %s missing" % fname)
			failed += 1

	# --- project.godot integrity ---
	print("")
	print("[Project Configuration]")
	var config := ConfigFile.new()
	var err := config.load("res://project.godot")
	if err == OK:
		print("  PASS: project.godot loads successfully")
		passed += 1

		var proj_name: String = config.get_value("application", "config/name", "")
		if proj_name != "":
			print("  PASS: project name is set (\"%s\")" % proj_name)
			passed += 1
		else:
			print("  FAIL: project name is empty")
			failed += 1

		var main_scene: String = config.get_value("application", "run/main_scene", "")
		if main_scene != "":
			print("  PASS: main scene is set (\"%s\")" % main_scene)
			passed += 1
		else:
			print("  FAIL: main scene is not set")
			failed += 1
	else:
		print("  FAIL: project.godot failed to load")
		failed += 3

	# --- Art assets directory (informational, non-failing) ---
	print("")
	print("[Art Assets]")
	if DirAccess.dir_exists_absolute("res://assets"):
		var dir := DirAccess.open("res://assets")
		if dir:
			dir.list_dir_begin()
			var has_files := false
			var fname := dir.get_next()
			while fname != "":
				if not dir.current_is_dir() and not fname.begins_with("."):
					has_files = true
					break
				fname = dir.get_next()
			dir.list_dir_end()
			if has_files:
				print("  PASS: assets/ directory has files")
			else:
				print("  PASS: assets/ directory exists (placeholder stage — no art files yet)")
			passed += 1
		else:
			print("  PASS: assets/ directory exists (could not enumerate)")
			passed += 1
	else:
		print("  PASS: assets/ directory not yet created (placeholder stage)")
		passed += 1

	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
