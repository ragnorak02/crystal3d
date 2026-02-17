extends SceneTree
## Test: Performance sanity checks — generous thresholds to catch regressions.

func _init() -> void:
	print("=== PERFORMANCE TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	# Test GameLevel instantiation under 5000ms
	print("[GameLevel Instantiation]")
	var start := Time.get_ticks_msec()
	var level_scene := load("res://scenes/levels/GameLevel.tscn") as PackedScene
	if level_scene:
		var level := level_scene.instantiate()
		level.queue_free()
	var elapsed := Time.get_ticks_msec() - start
	if elapsed < 5000:
		print("  PASS: GameLevel instantiated in %dms (< 5000ms)" % elapsed)
		passed += 1
	else:
		print("  FAIL: GameLevel took %dms (> 5000ms threshold)" % elapsed)
		failed += 1

	# Test all 3 character scenes load under 2000ms total
	print("")
	print("[Character Scene Loading]")
	start = Time.get_ticks_msec()
	var char_scenes := [
		"res://scenes/characters/Fighter.tscn",
		"res://scenes/characters/SpearAdept.tscn",
		"res://scenes/characters/Dragonbound.tscn",
	]
	for path in char_scenes:
		var scene := load(path) as PackedScene
		if scene:
			scene.instantiate().queue_free()
	elapsed = Time.get_ticks_msec() - start
	if elapsed < 2000:
		print("  PASS: 3 characters loaded in %dms (< 2000ms)" % elapsed)
		passed += 1
	else:
		print("  FAIL: 3 characters took %dms (> 2000ms threshold)" % elapsed)
		failed += 1

	# Test HealthComponent throughput — 1000 create+damage cycles
	print("")
	print("[HealthComponent Throughput]")
	start = Time.get_ticks_msec()
	for i in 1000:
		var h := HealthComponent.new()
		h.max_hp = 10
		h._ready()
		h.take_damage(5)
		h.free()
	elapsed = Time.get_ticks_msec() - start
	if elapsed < 500:
		print("  PASS: 1000 HealthComponent cycles in %dms (< 500ms)" % elapsed)
		passed += 1
	else:
		print("  FAIL: 1000 HealthComponent cycles took %dms (> 500ms threshold)" % elapsed)
		failed += 1

	# Test core script loading — all autoload/character/combat scripts
	print("")
	print("[Core Script Loading]")
	start = Time.get_ticks_msec()
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
	]
	var all_loaded := true
	for path in core_scripts:
		if not ResourceLoader.exists(path):
			all_loaded = false
		else:
			load(path)
	elapsed = Time.get_ticks_msec() - start
	if elapsed < 3000 and all_loaded:
		print("  PASS: %d core scripts loaded in %dms (< 3000ms)" % [core_scripts.size(), elapsed])
		passed += 1
	elif not all_loaded:
		print("  FAIL: Some core scripts could not be found")
		failed += 1
	else:
		print("  FAIL: %d core scripts took %dms (> 3000ms threshold)" % [core_scripts.size(), elapsed])
		failed += 1

	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
