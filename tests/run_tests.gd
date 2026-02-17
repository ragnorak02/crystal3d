extends SceneTree
## Aggregating test runner — executes each suite as a subprocess, parses PASS/FAIL
## output, and prints a single JSON result conforming to the Studio OS contract.
##
## Usage: godot --headless --path <project> --script tests/run_tests.gd
## Output: JSON to stdout + tests/results.json

var _suites := [
	"test_project",
	"test_characters",
	"test_combat",
	"test_enemies",
	"test_save",
	"test_input",
	"test_ui",
	"test_performance",
	"test_assets",
]

var _pass_regex: RegEx
var _fail_regex: RegEx
var _results_regex: RegEx


func _init() -> void:
	_pass_regex = RegEx.new()
	_pass_regex.compile("^\\s+PASS:\\s+(.+)$")

	_fail_regex = RegEx.new()
	_fail_regex.compile("^\\s+FAIL:\\s+(.+)$")

	_results_regex = RegEx.new()
	_results_regex.compile("=== RESULTS: (\\d+) passed, (\\d+) failed ===")

	var start_time := Time.get_ticks_msec()
	var godot_path := OS.get_executable_path()
	var project_path := ProjectSettings.globalize_path("res://")

	var total_passed := 0
	var total_failed := 0
	var all_details: Array[Dictionary] = []

	for suite_name in _suites:
		var script_path := "tests/%s.gd" % suite_name
		var output: Array = []
		var args := PackedStringArray([
			"--headless",
			"--path", project_path,
			"--script", script_path,
		])
		var exit_code := OS.execute(godot_path, args, output, true)
		var stdout_text: String = output[0] if output.size() > 0 else ""

		if stdout_text.strip_edges() == "":
			all_details.append({
				"name": suite_name,
				"status": "fail",
				"message": "Suite failed to execute (empty output)",
			})
			total_failed += 1
			continue

		var lines := stdout_text.split("\n")
		var suite_pass := 0
		var suite_fail := 0
		var found_results := false

		for line in lines:
			var clean := line.strip_edges()

			var pass_match := _pass_regex.search(line)
			if pass_match:
				all_details.append({
					"name": "%s/%s" % [suite_name, pass_match.get_string(1).strip_edges()],
					"status": "pass",
					"message": "",
				})
				continue

			var fail_match := _fail_regex.search(line)
			if fail_match:
				all_details.append({
					"name": "%s/%s" % [suite_name, fail_match.get_string(1).strip_edges()],
					"status": "fail",
					"message": fail_match.get_string(1).strip_edges(),
				})
				continue

			var results_match := _results_regex.search(clean)
			if results_match:
				suite_pass = results_match.get_string(1).to_int()
				suite_fail = results_match.get_string(2).to_int()
				found_results = true

		if found_results:
			total_passed += suite_pass
			total_failed += suite_fail
		else:
			# No RESULTS line found — count from parsed details
			for detail in all_details:
				if detail["name"].begins_with(suite_name + "/"):
					if detail["status"] == "pass":
						total_passed += 1
					else:
						total_failed += 1

	var duration := Time.get_ticks_msec() - start_time
	var total := total_passed + total_failed
	var status := "pass" if total_failed == 0 else "fail"
	var timestamp := Time.get_datetime_string_from_system(true) + "Z"

	var result := {
		"status": status,
		"testsTotal": total,
		"testsPassed": total_passed,
		"durationMs": duration,
		"timestamp": timestamp,
		"details": all_details,
	}

	var json_str := JSON.stringify(result, "  ")

	# Write to file for launcher/CI consumption
	var file := FileAccess.open("res://tests/test-results.json", FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		file.close()

	print(json_str)
	quit()
