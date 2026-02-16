# Hybrid Nights (formerly Hwarang)

## Engine & Paths
- Godot 4.6 (GL Compatibility renderer)
- Godot executable: `Z:/Godot/Godot_v4.6-stable_win64_console.exe`
- Project path: `Z:/Development/Games/hwarang`

## Architecture
- 3 autoloads: GameManager, InputManager, SaveManager
- State machine pattern: StateMachine node + CharacterState children
- Character hierarchy: CharacterBase -> Fighter, SpearAdept, Dragonbound
- Enemy hierarchy: EnemyBase -> MeleeGrunt (Idle/Patrol/Chase/Attack/Die states)
- Companion hierarchy: CompanionBase -> FairyCompanion, DragonCompanion
- Hitbox/Hurtbox combat system using collision layers 1-9
- 25% scale characters (capsule r=0.0875, h=0.35) in full-size world

## Scene Flow
TitleScreen -> MainMenu -> CharacterSelect -> GameLevel (with HUD + PauseMenu)

## Input Actions (15)
move_forward, move_backward, move_left, move_right, jump, crouch, run, attack, magic_charge, companion_action, lock_on_toggle, lock_on_next, lock_on_prev, ui_confirm, ui_back

## Testing
- Run all tests: `"Z:/Godot/Godot_v4.6-stable_win64_console.exe" --headless --path "Z:/Development/Games/hwarang" --script tests/test_<name>.gd`
- Autoload singletons are NOT available in `--script` mode; tests must load scripts manually
- GDScript closures don't capture primitives by reference; use Dictionary wrapper for signal testing
- `character` var in CharacterState is untyped to avoid cyclic class_name resolution issues

## Conventions
- Use GDScript (not C#)
- Follow Godot style: snake_case for functions/variables, PascalCase for classes/nodes
- Prefer signals over direct references for decoupling
- Keep state logic inside CharacterState scripts, not in CharacterBase
