extends SceneTree
## Master test runner — validates core project structure after Hybrid Nights refactor.

func _init() -> void:
	print("=== HYBRID NIGHTS PROJECT TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	# Test 1: Validate all input actions exist (15 total)
	print("[TEST 1] Checking input actions...")
	var actions := [
		"move_forward", "move_backward", "move_left", "move_right",
		"jump", "crouch", "run", "attack", "magic_charge",
		"companion_action", "lock_on_toggle", "lock_on_next", "lock_on_prev",
		"ui_confirm", "ui_back",
	]
	var all_actions := true
	for action in actions:
		if not InputMap.has_action(action):
			print("  FAIL: Missing input action '%s'" % action)
			failed += 1
			all_actions = false
	if all_actions:
		print("  PASS: All 15 input actions exist")
		passed += 1

	# Test 2: Validate character scenes load
	print("")
	print("[TEST 2] Loading character scenes...")
	var char_scenes := [
		"res://scenes/characters/Fighter.tscn",
		"res://scenes/characters/SpearAdept.tscn",
		"res://scenes/characters/Dragonbound.tscn",
	]
	for path in char_scenes:
		var scene := load(path) as PackedScene
		if scene:
			var inst := scene.instantiate()
			if inst is CharacterBody3D:
				print("  PASS: %s loads as CharacterBody3D" % path.get_file())
				passed += 1
			else:
				print("  FAIL: %s wrong type" % path.get_file())
				failed += 1
			inst.queue_free()
		else:
			print("  FAIL: Could not load %s" % path)
			failed += 1

	# Test 3: Validate enemy scene loads
	print("")
	print("[TEST 3] Loading enemy scene...")
	var grunt_scene := load("res://scenes/enemies/MeleeGrunt.tscn") as PackedScene
	if grunt_scene:
		var grunt := grunt_scene.instantiate()
		if grunt is CharacterBody3D:
			print("  PASS: MeleeGrunt loads as CharacterBody3D")
			passed += 1
		else:
			print("  FAIL: MeleeGrunt wrong type")
			failed += 1
		grunt.queue_free()
	else:
		print("  FAIL: Could not load MeleeGrunt.tscn")
		failed += 1

	# Test 4: Validate UI scenes load
	print("")
	print("[TEST 4] Loading UI scenes...")
	var ui_scenes := [
		"res://scenes/ui/TitleScreen.tscn",
		"res://scenes/ui/MainMenu.tscn",
		"res://scenes/ui/CharacterSelect.tscn",
		"res://scenes/ui/HUD.tscn",
		"res://scenes/ui/Settings.tscn",
		"res://scenes/ui/PauseMenu.tscn",
	]
	for path in ui_scenes:
		var scene := load(path) as PackedScene
		if scene:
			print("  PASS: %s loads" % path.get_file())
			passed += 1
			scene.instantiate().queue_free()
		else:
			print("  FAIL: Could not load %s" % path)
			failed += 1

	# Test 5: Validate GameLevel scene loads
	print("")
	print("[TEST 5] Loading GameLevel...")
	var level_scene := load("res://scenes/levels/GameLevel.tscn") as PackedScene
	if level_scene:
		var level := level_scene.instantiate()
		print("  PASS: GameLevel loads")
		passed += 1

		var cam_rig := level.get_node_or_null("CameraRig")
		if cam_rig:
			print("  PASS: GameLevel has CameraRig")
			passed += 1
			var cam := cam_rig.get_node_or_null("Camera3D")
			if cam and cam is Camera3D:
				print("  PASS: CameraRig has Camera3D")
				passed += 1
			else:
				print("  FAIL: Missing Camera3D under CameraRig")
				failed += 1
			var lockon := cam_rig.get_node_or_null("LockOnSystem")
			if lockon:
				print("  PASS: CameraRig has LockOnSystem")
				passed += 1
			else:
				print("  FAIL: Missing LockOnSystem")
				failed += 1
		else:
			print("  FAIL: Missing CameraRig")
			failed += 3

		var hud := level.get_node_or_null("HUD")
		if hud:
			print("  PASS: GameLevel has HUD")
			passed += 1
		else:
			print("  FAIL: Missing HUD in GameLevel")
			failed += 1

		var pause := level.get_node_or_null("PauseMenu")
		if pause:
			print("  PASS: GameLevel has PauseMenu")
			passed += 1
		else:
			print("  FAIL: Missing PauseMenu in GameLevel")
			failed += 1

		# Check enemy instances
		var grunt_count := 0
		for child in level.get_children():
			if child.name.begins_with("MeleeGrunt"):
				grunt_count += 1
		if grunt_count >= 3:
			print("  PASS: GameLevel has %d enemies" % grunt_count)
			passed += 1
		else:
			print("  FAIL: GameLevel has %d enemies, expected >= 3" % grunt_count)
			failed += 1

		level.queue_free()
	else:
		print("  FAIL: Could not load GameLevel.tscn")
		failed += 7

	# Test 6: Validate Fireball loads
	print("")
	print("[TEST 6] Loading Fireball...")
	var fb_scene := load("res://scenes/combat/Fireball.tscn") as PackedScene
	if fb_scene:
		print("  PASS: Fireball loads")
		passed += 1
		fb_scene.instantiate().queue_free()
	else:
		print("  FAIL: Could not load Fireball.tscn")
		failed += 1

	# Test 7: Validate companion scenes
	print("")
	print("[TEST 7] Loading companion scenes...")
	var comp_scenes := [
		"res://scenes/companions/FairyCompanion.tscn",
		"res://scenes/companions/DragonCompanion.tscn",
	]
	for path in comp_scenes:
		var scene := load(path) as PackedScene
		if scene:
			print("  PASS: %s loads" % path.get_file())
			passed += 1
			scene.instantiate().queue_free()
		else:
			print("  FAIL: Could not load %s" % path)
			failed += 1

	# Test 8: Data classes
	print("")
	print("[TEST 8] Checking data architecture...")
	if ElementTypes.get_strength(ElementTypes.Element.FIRE) == ElementTypes.Element.ICE:
		print("  PASS: Fire beats Ice")
		passed += 1
	else:
		print("  FAIL: Element strength lookup broken")
		failed += 1

	var char_data := CharacterData.get_character(0)
	if char_data["name"] == "Fighter":
		print("  PASS: CharacterData[0] = Fighter")
		passed += 1
	else:
		print("  FAIL: CharacterData[0] wrong")
		failed += 1

	if CharacterData.CHARACTERS.size() == 3:
		print("  PASS: 3 characters defined")
		passed += 1
	else:
		print("  FAIL: Expected 3 characters, got %d" % CharacterData.CHARACTERS.size())
		failed += 1

	# Summary
	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
