extends SceneTree
## Test: Verify SaveManager round-trip (save, load, delete).

func _init() -> void:
	print("=== SAVE SYSTEM TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	# Manually load the SaveManager script since autoloads aren't available in --script mode
	var sm_script := load("res://scripts/autoload/save_manager.gd")
	var sm := Node.new()
	sm.set_script(sm_script)

	# Clean state
	sm.delete_save()

	# Test has_save when no save exists
	if not sm.has_save():
		print("  PASS: has_save = false when no save")
		passed += 1
	else:
		print("  FAIL: has_save should be false initially")
		failed += 1

	# Test save
	var test_data := {"character_id": 1, "current_hp": 4, "max_hp": 6, "level_path": "res://test"}
	sm.save_game(test_data)

	if sm.has_save():
		print("  PASS: has_save = true after save")
		passed += 1
	else:
		print("  FAIL: has_save should be true after save")
		failed += 1

	# Test load
	var loaded: Dictionary = sm.load_game()
	if loaded.get("character_id") == 1:
		print("  PASS: Loaded character_id = 1")
		passed += 1
	else:
		print("  FAIL: Loaded character_id wrong: %s" % str(loaded.get("character_id")))
		failed += 1

	if loaded.get("current_hp") == 4:
		print("  PASS: Loaded current_hp = 4")
		passed += 1
	else:
		print("  FAIL: Loaded current_hp wrong")
		failed += 1

	if loaded.has("version") and loaded["version"] == 1:
		print("  PASS: Save has version = 1")
		passed += 1
	else:
		print("  FAIL: Save missing or wrong version")
		failed += 1

	if loaded.has("timestamp"):
		print("  PASS: Save has timestamp")
		passed += 1
	else:
		print("  FAIL: Save missing timestamp")
		failed += 1

	# Test delete
	sm.delete_save()
	if not sm.has_save():
		print("  PASS: Save deleted successfully")
		passed += 1
	else:
		print("  FAIL: Save not deleted")
		failed += 1

	sm.free()

	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
