extends SceneTree
## Test: Verify all 15 input actions exist in InputMap.

func _init() -> void:
	print("=== INPUT ACTION TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	var actions := [
		"move_forward", "move_backward", "move_left", "move_right",
		"jump", "crouch",
		"run", "attack", "magic_charge", "companion_action",
		"lock_on_toggle", "lock_on_next", "lock_on_prev",
		"ui_confirm", "ui_back",
	]

	for action in actions:
		if InputMap.has_action(action):
			print("  PASS: '%s' exists" % action)
			passed += 1
		else:
			print("  FAIL: '%s' missing" % action)
			failed += 1

	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
