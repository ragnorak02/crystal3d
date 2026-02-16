extends SceneTree
## Test: Verify UI scenes load with correct structure.

func _init() -> void:
	print("=== UI TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	# Test TitleScreen
	print("[TitleScreen]")
	var title_scene := load("res://scenes/ui/TitleScreen.tscn") as PackedScene
	if title_scene:
		var title := title_scene.instantiate()
		if title is Control:
			print("  PASS: TitleScreen is Control")
			passed += 1
		else:
			print("  FAIL: TitleScreen wrong type")
			failed += 1
		var prompt := title.get_node_or_null("PromptLabel")
		if prompt and prompt is Label:
			print("  PASS: TitleScreen has PromptLabel")
			passed += 1
		else:
			print("  FAIL: TitleScreen missing PromptLabel")
			failed += 1
		title.queue_free()
	else:
		print("  FAIL: Could not load TitleScreen.tscn")
		failed += 2

	# Test MainMenu
	print("")
	print("[MainMenu]")
	var menu_scene := load("res://scenes/ui/MainMenu.tscn") as PackedScene
	if menu_scene:
		var menu := menu_scene.instantiate()
		var buttons := ["ContinueButton", "NewGameButton", "QuickGameButton", "SettingsButton", "QuitButton"]
		var all_found := true
		for btn_name in buttons:
			var btn := menu.get_node_or_null("VBoxContainer/%s" % btn_name)
			if not btn or not btn is Button:
				print("  FAIL: Missing button '%s'" % btn_name)
				failed += 1
				all_found = false
		if all_found:
			print("  PASS: All 5 menu buttons present")
			passed += 1
		menu.queue_free()
	else:
		print("  FAIL: Could not load MainMenu.tscn")
		failed += 1

	# Test CharacterSelect
	print("")
	print("[CharacterSelect]")
	var select_scene := load("res://scenes/ui/CharacterSelect.tscn") as PackedScene
	if select_scene:
		var select := select_scene.instantiate()
		var panels_found := 0
		for i in range(3):
			var panel := select.get_node_or_null("HBoxContainer/Panel%d" % i)
			if panel and panel is Panel:
				panels_found += 1
		if panels_found == 3:
			print("  PASS: CharacterSelect has 3 panels")
			passed += 1
		else:
			print("  FAIL: CharacterSelect has %d panels, expected 3" % panels_found)
			failed += 1
		select.queue_free()
	else:
		print("  FAIL: Could not load CharacterSelect.tscn")
		failed += 1

	# Test HUD
	print("")
	print("[HUD]")
	var hud_scene := load("res://scenes/ui/HUD.tscn") as PackedScene
	if hud_scene:
		var hud := hud_scene.instantiate()
		if hud is CanvasLayer:
			print("  PASS: HUD is CanvasLayer")
			passed += 1
		else:
			print("  FAIL: HUD wrong type")
			failed += 1
		var hearts := hud.get_node_or_null("HeartsContainer")
		if hearts:
			print("  PASS: HUD has HeartsContainer")
			passed += 1
		else:
			print("  FAIL: HUD missing HeartsContainer")
			failed += 1
		var lockon := hud.get_node_or_null("LockOnIndicator")
		if lockon:
			print("  PASS: HUD has LockOnIndicator")
			passed += 1
		else:
			print("  FAIL: HUD missing LockOnIndicator")
			failed += 1
		hud.queue_free()
	else:
		print("  FAIL: Could not load HUD.tscn")
		failed += 3

	# Test Settings
	print("")
	print("[Settings]")
	var settings_scene := load("res://scenes/ui/Settings.tscn") as PackedScene
	if settings_scene:
		print("  PASS: Settings scene loads")
		passed += 1
		settings_scene.instantiate().queue_free()
	else:
		print("  FAIL: Could not load Settings.tscn")
		failed += 1

	# Test PauseMenu
	print("")
	print("[PauseMenu]")
	var pause_scene := load("res://scenes/ui/PauseMenu.tscn") as PackedScene
	if pause_scene:
		var pause := pause_scene.instantiate()
		var resume := pause.get_node_or_null("Panel/VBoxContainer/ResumeButton")
		if resume and resume is Button:
			print("  PASS: PauseMenu has ResumeButton")
			passed += 1
		else:
			print("  FAIL: PauseMenu missing ResumeButton")
			failed += 1
		pause.queue_free()
	else:
		print("  FAIL: Could not load PauseMenu.tscn")
		failed += 1

	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
