extends SceneTree
## Test: Verify character scenes load with correct structure and properties.

func _init() -> void:
	print("=== CHARACTER TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	# Test Fighter
	print("[Fighter]")
	var fighter_scene := load("res://scenes/characters/Fighter.tscn") as PackedScene
	if fighter_scene:
		var fighter := fighter_scene.instantiate()
		if fighter is CharacterBase:
			print("  PASS: Fighter is CharacterBase")
			passed += 1
		else:
			print("  FAIL: Fighter is not CharacterBase")
			failed += 1

		var col := fighter.get_node_or_null("CollisionShape3D")
		if col and col is CollisionShape3D:
			var shape = (col as CollisionShape3D).shape as CapsuleShape3D
			if shape and absf(shape.radius - 0.0875) < 0.01:
				print("  PASS: Fighter capsule radius ~0.0875 (25%% scale)")
				passed += 1
			else:
				print("  FAIL: Fighter capsule radius wrong")
				failed += 1
		else:
			print("  FAIL: Fighter missing CollisionShape3D")
			failed += 1

		var sm := fighter.get_node_or_null("StateMachine")
		if sm:
			print("  PASS: Fighter has StateMachine")
			passed += 1
			if sm.get_node_or_null("Idle"):
				print("  PASS: StateMachine has Idle state")
				passed += 1
			else:
				print("  FAIL: StateMachine missing Idle")
				failed += 1
		else:
			print("  FAIL: Fighter missing StateMachine")
			failed += 2

		var hitbox := fighter.get_node_or_null("Hitbox")
		if hitbox and hitbox is Area3D:
			print("  PASS: Fighter has Hitbox")
			passed += 1
		else:
			print("  FAIL: Fighter missing Hitbox")
			failed += 1

		var hurtbox := fighter.get_node_or_null("Hurtbox")
		if hurtbox and hurtbox is Area3D:
			print("  PASS: Fighter has Hurtbox")
			passed += 1
		else:
			print("  FAIL: Fighter missing Hurtbox")
			failed += 1

		fighter.queue_free()
	else:
		print("  FAIL: Could not load Fighter.tscn")
		failed += 6

	# Test SpearAdept
	print("")
	print("[SpearAdept]")
	var spear_scene := load("res://scenes/characters/SpearAdept.tscn") as PackedScene
	if spear_scene:
		var spear := spear_scene.instantiate()
		if spear is CharacterBase:
			print("  PASS: SpearAdept is CharacterBase")
			passed += 1
			if spear.move_speed < 7.0:
				print("  PASS: SpearAdept slower speed (%.1f)" % spear.move_speed)
				passed += 1
			else:
				print("  FAIL: SpearAdept speed not slower (%.1f)" % spear.move_speed)
				failed += 1
		else:
			print("  FAIL: SpearAdept is not CharacterBase")
			failed += 2

		var spear_mesh := spear.get_node_or_null("PlayerModel/Spear")
		if spear_mesh and spear_mesh is MeshInstance3D:
			print("  PASS: SpearAdept has spear mesh")
			passed += 1
		else:
			print("  FAIL: SpearAdept missing spear mesh")
			failed += 1

		spear.queue_free()
	else:
		print("  FAIL: Could not load SpearAdept.tscn")
		failed += 3

	# Test Dragonbound
	print("")
	print("[Dragonbound]")
	var dragon_scene := load("res://scenes/characters/Dragonbound.tscn") as PackedScene
	if dragon_scene:
		var dragon := dragon_scene.instantiate()
		if dragon is CharacterBase:
			print("  PASS: Dragonbound is CharacterBase")
			passed += 1
			if dragon.can_double_jump():
				print("  PASS: Dragonbound can_double_jump = true")
				passed += 1
			else:
				print("  FAIL: Dragonbound can_double_jump should be true")
				failed += 1
			if dragon.can_glide():
				print("  PASS: Dragonbound can_glide = true")
				passed += 1
			else:
				print("  FAIL: Dragonbound can_glide should be true")
				failed += 1
		else:
			print("  FAIL: Dragonbound is not CharacterBase")
			failed += 3

		var sm := dragon.get_node_or_null("StateMachine")
		if sm and sm.get_node_or_null("DoubleJump") and sm.get_node_or_null("Glide"):
			print("  PASS: Dragonbound has DoubleJump and Glide states")
			passed += 1
		else:
			print("  FAIL: Dragonbound missing DoubleJump/Glide states")
			failed += 1

		dragon.queue_free()
	else:
		print("  FAIL: Could not load Dragonbound.tscn")
		failed += 4

	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
