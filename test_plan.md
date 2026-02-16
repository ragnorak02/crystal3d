# Hybrid Nights — Test Plan

## How to Run Tests

Single suite:
```bash
"Z:/Godot/Godot_v4.6-stable_win64_console.exe" --headless --path "Z:/Development/Games/crystal3d" --script tests/test_characters.gd
```

All suites (run each separately — Godot `--script` exits after one):
```bash
for test in test_project test_characters test_combat test_enemies test_save test_input test_ui; do
  "Z:/Godot/Godot_v4.6-stable_win64_console.exe" --headless --path "Z:/Development/Games/crystal3d" --script "tests/${test}.gd"
done
```

## Testing Constraints
- Autoload singletons (GameManager, InputManager, SaveManager) are **not available** in `--script` mode
- Tests must `load()` scripts manually and instantiate nodes directly
- GDScript closures don't capture primitives by reference — use `Dictionary` wrapper for signal tracking
- `CharacterState.character` is untyped to avoid cyclic `class_name` resolution

## Existing Test Suites

| File | What It Tests | Assertions |
|------|--------------|------------|
| `test_project.gd` | Project structure: autoloads, scenes exist, input actions defined | ~10 |
| `test_characters.gd` | Fighter/SpearAdept/Dragonbound: load, type check, capsule size, StateMachine, Hitbox, Hurtbox, abilities | ~15 |
| `test_combat.gd` | Fireball scene structure, AttackData defaults, HealthComponent damage+death signal | ~7 |
| `test_enemies.gd` | MeleeGrunt: type, StateMachine states (5), DetectionArea, Hitbox, Hurtbox, HP | ~8 |
| `test_save.gd` | SaveManager round-trip: has_save, save_game, load_game, delete_save, version/timestamp | ~7 |
| `test_input.gd` | InputManager script loads, input actions exist in ProjectSettings | ~16 |
| `test_ui.gd` | UI scenes load with correct types and expected child nodes | ~10 |

**Total: ~73 assertions across 7 suites**

## Test Coverage Map

| System | Covered | Not Covered |
|--------|---------|-------------|
| Character loading/structure | Yes | Runtime state transitions |
| Combat components | Partial (load + HealthComponent) | Hitbox/Hurtbox collision interaction |
| Enemy structure | Yes | AI behavior (patrol, chase, attack) |
| Save system | Full round-trip | Edge cases (corrupt file, version migration) |
| Input mapping | Action existence | Actual input processing, buffering |
| UI scenes | Structure/type checks | Button callbacks, scene transitions |
| Companions | Not tested | Follow behavior, DragonCompanion attack |
| Camera/Lock-on | Not tested | Camera rig, lock-on targeting |
| State machine | Not tested | State transitions, physics processing |
| Game level | Not tested | Character spawning, companion spawning |

## Recommended Future Tests

### Priority 1 — State Machine
- Verify initial state is "Idle" after setup
- Verify Idle -> Run transition on movement input
- Verify Run -> Sprint transition on run held
- Verify ground -> Jump -> Fall -> land cycle

### Priority 2 — Companion System
- FairyCompanion follows player position
- DragonCompanion attacks enemy on action
- DragonCompanion respects cooldown timer

### Priority 3 — Integration
- GameLevel spawns correct character based on GameManager.selected_character_id
- Hitbox activation deals damage to Hurtbox
- Enemy dies and emits signal at 0 HP
- Save/load preserves game state across scene reload
