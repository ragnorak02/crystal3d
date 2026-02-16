# Hybrid Nights — Game Direction

## Concept
3D action-adventure with character-switching, companion system, and lock-on combat.
Godot 4.6, GL Compatibility renderer, 1280x720 viewport.

## Playable Characters

| Character | Style | Unique Abilities | Companion |
|-----------|-------|------------------|-----------|
| Fighter | Balanced (blue) | Fireball magic | FairyCompanion |
| SpearAdept | Slow/powerful (green) | Long-reach thrust, 2 ATK | FairyCompanion |
| Dragonbound | Agile (purple) | Double jump, glide, dragon jump | DragonCompanion |

### Stats Snapshot
- **Fighter**: speed 7.0, sprint 11.0, ATK 1, HP 6
- **SpearAdept**: speed 5.5, sprint 8.0, ATK 2, HP 6
- **Dragonbound**: speed 7.5, sprint 12.0, ATK 1, HP 6, 2 air jumps + glide

## Core Systems

### Movement & States
State machine per character with these states:
Idle, Run, Sprint, Jump, Fall, Crouch, LongJump, HighJump, DoubleJump, DragonJump, Glide, Attack, MagicCharge, MagicRecovery

Jump mechanics: crouch+jump = high jump, sprint+jump = long jump, air jumps (Dragonbound only).

### Combat
- Hitbox/Hurtbox with collision layer separation
- Hitbox activates for duration, auto-deactivates
- Debug visualization (red transparent mesh) on hitbox activation
- Projectile system (Fireball scene)
- AttackData resource for damage/duration configuration
- HealthComponent with signals (health_changed, died)

### Companions
- Follow player with smooth lerp + bobbing motion
- FairyCompanion: circular drift for organic feel
- DragonCompanion: attack nearest enemy on Q, 3s cooldown, 2 damage, visual lunge + flash

### Lock-On
- Tab to toggle, 1/2 or scroll to cycle targets
- Camera orients toward lock-on target
- HUD indicator tracks target screen position
- Enemies auto-register via `lock_on_targets` group

### Enemies
- EnemyBase with state machine: Idle, Patrol, Chase, Attack, Die
- Detection via Area3D (body_entered/exited)
- MeleeGrunt: 3 HP, patrol radius behavior

### Save System
- JSON at `user://hybrid_nights_save.json`
- Versioned (v1), timestamped
- Saves: character_id, level_path, current_hp, max_hp
- Auto-saves on level entry

### UI Flow
```
TitleScreen -> MainMenu -> CharacterSelect -> GameLevel
                |-> Settings                   |-> PauseMenu
                |-> Continue (load save)       |-> HUD overlay
```

## What Exists vs. What's Needed

### Implemented (code-complete)
- Full state machine with 14 character states
- 3 playable characters with distinct abilities
- Hitbox/Hurtbox combat pipeline
- Fireball projectile
- 2 companion types with distinct behaviors
- Lock-on targeting system
- Camera rig with follow + lock-on
- Complete UI flow (title -> menu -> select -> game -> pause)
- HUD with hearts, ability label, control hints, lock-on indicator
- Save/load system with JSON persistence
- Settings (volume + fullscreen)
- Enemy AI with 5-state machine
- 15 input actions with keyboard + gamepad mapping

### Not Yet Implemented
- 3D model assets (currently colored capsules)
- Audio (no music, SFX, or ambient sounds)
- Sprite/texture UI assets (hearts are text labels)
- Animation system (AnimationPlayer/AnimationTree)
- Multiple levels / level transitions
- Inventory / item system
- Dialogue system
- Additional enemy types beyond MeleeGrunt
- Particle effects
- Post-processing / shaders
