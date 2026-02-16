extends SceneTree
## Test: Verify enemy scenes load with correct structure and groups.

func _init() -> void:
	print("=== ENEMY TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	# Test MeleeGrunt
	print("[MeleeGrunt]")
	var grunt_scene := load("res://scenes/enemies/MeleeGrunt.tscn") as PackedScene
	if grunt_scene:
		var grunt := grunt_scene.instantiate()

		if grunt is EnemyBase:
			print("  PASS: MeleeGrunt is EnemyBase")
			passed += 1
		else:
			print("  FAIL: MeleeGrunt is not EnemyBase")
			failed += 1

		if grunt is CharacterBody3D:
			print("  PASS: MeleeGrunt is CharacterBody3D")
			passed += 1
		else:
			print("  FAIL: MeleeGrunt not CharacterBody3D")
			failed += 1

		# Check state machine
		var sm := grunt.get_node_or_null("StateMachine")
		if sm:
			print("  PASS: MeleeGrunt has StateMachine")
			passed += 1

			var expected_states := ["EnemyIdle", "Patrol", "Chase", "EnemyAttack", "Die"]
			var all_found := true
			for state_name in expected_states:
				if not sm.get_node_or_null(state_name):
					print("  FAIL: Missing state '%s'" % state_name)
					failed += 1
					all_found = false
			if all_found:
				print("  PASS: All 5 enemy states present")
				passed += 1
		else:
			print("  FAIL: MeleeGrunt missing StateMachine")
			failed += 2

		# Check detection area
		var detection := grunt.get_node_or_null("DetectionArea")
		if detection and detection is Area3D:
			print("  PASS: MeleeGrunt has DetectionArea")
			passed += 1
		else:
			print("  FAIL: MeleeGrunt missing DetectionArea")
			failed += 1

		# Check hitbox/hurtbox
		var hitbox := grunt.get_node_or_null("Hitbox")
		if hitbox and hitbox is Area3D:
			print("  PASS: MeleeGrunt has Hitbox")
			passed += 1
		else:
			print("  FAIL: MeleeGrunt missing Hitbox")
			failed += 1

		var hurtbox := grunt.get_node_or_null("Hurtbox")
		if hurtbox and hurtbox is Area3D:
			print("  PASS: MeleeGrunt has Hurtbox")
			passed += 1
		else:
			print("  FAIL: MeleeGrunt missing Hurtbox")
			failed += 1

		# Check HP
		if grunt.max_hp == 3:
			print("  PASS: MeleeGrunt has 3 HP")
			passed += 1
		else:
			print("  FAIL: MeleeGrunt HP is %d, expected 3" % grunt.max_hp)
			failed += 1

		grunt.queue_free()
	else:
		print("  FAIL: Could not load MeleeGrunt.tscn")
		failed += 8

	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
