extends SceneTree
## Test: Verify combat components load correctly.

func _init() -> void:
	print("=== COMBAT TESTS ===")
	print("")
	var passed := 0
	var failed := 0

	# Test Fireball scene loads
	print("[Fireball]")
	var fireball_scene := load("res://scenes/combat/Fireball.tscn") as PackedScene
	if fireball_scene:
		var fireball := fireball_scene.instantiate()
		if fireball is CharacterBody3D:
			print("  PASS: Fireball is CharacterBody3D")
			passed += 1
		else:
			print("  FAIL: Fireball wrong type")
			failed += 1

		var hit_area := fireball.get_node_or_null("HitArea")
		if hit_area and hit_area is Area3D:
			print("  PASS: Fireball has HitArea")
			passed += 1
		else:
			print("  FAIL: Fireball missing HitArea")
			failed += 1

		var mesh := fireball.get_node_or_null("Mesh")
		if mesh and mesh is MeshInstance3D:
			print("  PASS: Fireball has Mesh")
			passed += 1
		else:
			print("  FAIL: Fireball missing Mesh")
			failed += 1

		var light := fireball.get_node_or_null("Light")
		if light and light is OmniLight3D:
			print("  PASS: Fireball has Light")
			passed += 1
		else:
			print("  FAIL: Fireball missing Light")
			failed += 1

		fireball.queue_free()
	else:
		print("  FAIL: Could not load Fireball.tscn")
		failed += 4

	# Test AttackData resource
	print("")
	print("[AttackData]")
	var atk := AttackData.new()
	if atk.damage == 1 and atk.duration > 0.0:
		print("  PASS: AttackData defaults valid")
		passed += 1
	else:
		print("  FAIL: AttackData defaults invalid")
		failed += 1

	# Test HealthComponent
	print("")
	print("[HealthComponent]")
	var health := HealthComponent.new()
	health.max_hp = 6
	health._ready()
	if health.current_hp == 6:
		print("  PASS: HealthComponent starts at max HP")
		passed += 1
	else:
		print("  FAIL: HealthComponent start HP wrong")
		failed += 1

	var signal_data := {"fired": false}
	health.died.connect(func(): signal_data["fired"] = true)
	health.take_damage(6)
	if health.current_hp == 0 and signal_data["fired"]:
		print("  PASS: HealthComponent died at 0 HP")
		passed += 1
	else:
		print("  FAIL: HealthComponent death not triggered")
		failed += 1

	print("")
	print("=== RESULTS: %d passed, %d failed ===" % [passed, failed])
	if failed > 0:
		print("STATUS: SOME TESTS FAILED")
	else:
		print("STATUS: ALL TESTS PASSED")
	print("")
	quit()
