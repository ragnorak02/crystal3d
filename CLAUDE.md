# Hybrid Nights (formerly Hwarang)

## Engine & Paths
- Godot 4.6 (GL Compatibility renderer)
- Godot executable: `Z:/Godot/Godot_v4.6-stable_win64_console.exe`
- Project path: `Z:/Development/Games/crystal3d`

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

## Collision Layers
1=Environment, 2=PlayerBody, 3=EnemyBody, 4=PlayerAttacks, 5=EnemyAttacks, 6=PlayerHurtbox, 7=EnemyHurtbox, 8=Projectiles, 9=LockOn

## Testing
- Run a test: `"Z:/Godot/Godot_v4.6-stable_win64_console.exe" --headless --path "Z:/Development/Games/crystal3d" --script tests/test_<name>.gd`
- Test suites: test_characters, test_combat, test_enemies, test_save, test_ui, test_project, test_input
- Autoload singletons are NOT available in `--script` mode; tests must load scripts manually
- GDScript closures don't capture primitives by reference; use Dictionary wrapper for signal testing
- `character` var in CharacterState is untyped to avoid cyclic class_name resolution issues

## Conventions
- Use GDScript (not C#)
- Follow Godot style: snake_case for functions/variables, PascalCase for classes/nodes
- Prefer signals over direct references for decoupling
- Keep state logic inside CharacterState scripts, not in CharacterBase

## Key Files
| System | Script | Scene |
|--------|--------|-------|
| Game flow | `scripts/autoload/game_manager.gd` | — |
| Input | `scripts/autoload/input_manager.gd` | — |
| Save | `scripts/autoload/save_manager.gd` | — |
| Character base | `scripts/characters/character_base.gd` | `scenes/characters/CharacterBase.tscn` |
| Fighter | `scripts/characters/fighter.gd` | `scenes/characters/Fighter.tscn` |
| SpearAdept | `scripts/characters/spear_adept.gd` | `scenes/characters/SpearAdept.tscn` |
| Dragonbound | `scripts/characters/dragonbound.gd` | `scenes/characters/Dragonbound.tscn` |
| Enemy base | `scripts/enemies/enemy_base.gd` | — |
| MeleeGrunt | `scripts/enemies/melee_grunt.gd` | `scenes/enemies/MeleeGrunt.tscn` |
| Hitbox | `scripts/combat/hitbox.gd` | — |
| Hurtbox | `scripts/combat/hurtbox.gd` | — |
| Camera | `scripts/camera/camera_rig.gd` | — |
| Lock-on | `scripts/camera/lock_on_system.gd` | — |
| HUD | `scripts/ui/hud.gd` | `scenes/ui/HUD.tscn` |
| Game level | `scripts/ui/game_level.gd` | `scenes/levels/GameLevel.tscn` |

## Current Repo State (Auto-Detected)
- `assets/` directory is empty — no art, audio, or model files present
- All characters use colored capsule meshes as placeholder models (no 3D art)
- HUD hearts rendered as text labels `[F]`/`[H]`/`[E]` — no sprite assets
- No audio system — no SFX, music, or AudioStreamPlayer nodes
- `DragonCompanion` does not extend `CompanionBase`; duplicates follow logic standalone
- `CompanionBase.on_companion_action()` is an empty virtual (`pass`) — not yet wired
- Settings menu is minimal: master volume slider + fullscreen toggle only
- No TODO/FIXME comments found in any script
- 7 test suites exist (characters, combat, enemies, save, UI, project, input) — all structural/load tests
- `CharacterState` base methods (enter/exit/process_physics/process_frame) are `pass` stubs by design
