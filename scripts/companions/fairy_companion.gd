extends CompanionBase
## Fairy companion with gentle bobbing and circular drift.


func _get_follow_position(_delta: float) -> Vector3:
	var pos := target.global_position + offset
	pos.y += sin(time_elapsed * bob_speed) * bob_amplitude
	# Subtle circular drift for organic feel
	pos.x += cos(time_elapsed * 1.3) * 0.05
	pos.z += sin(time_elapsed * 1.1) * 0.05
	return pos
