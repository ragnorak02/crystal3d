# Achievement System Integration Guide

## Overview

The achievement system is data-driven via `achievements.json` at the project root. Game code reads/writes this file to track player milestones. No engine-specific code is included — this document is the contract for implementers.

## Data Source

| Item | Value |
|------|-------|
| File | `achievements.json` |
| Format | JSON, strict schema |
| Location | Project root |
| Dashboard | `status.html` (Achievements card) |

## Menu Integration

### Recommended Setup

Add an **"Achievements"** button to `MainMenu` (`scenes/ui/MainMenu.tscn`).

```
MainMenu
  VBoxContainer
    ...existing buttons...
    AchievementsButton  <-- new
```

**Label**: `"Achievements"`
**Position**: Below "Settings", above "Quit" (or as fits the menu layout)
**Action**: Open an Achievements overlay/screen

### Achievements Screen Layout

```
+------------------------------------------+
|  Achievements          [X] Close         |
|  Progress: 45 / 345 pts   (5/24)        |
|  [========-------] 13%                   |
|------------------------------------------|
|  [icon] First Steps           5 pts  [x] |
|  [icon] Choose Your Fighter  10 pts  [x] |
|  [icon] Blade Dancer         10 pts  [ ] |
|  [icon] Lance Bearer         10 pts  [ ] |
|  ...                                      |
+------------------------------------------+
```

**Requirements:**
- Scroll list of all achievements
- Unlocked items show checkmark + unlock timestamp
- Locked items show greyed-out icon + description
- Header shows total points earned / possible
- Progress bar for visual completion
- Close via `ui_back` action or X button

### Reading Data (GDScript pseudocode)

```gdscript
func load_achievements() -> Dictionary:
    var file := FileAccess.open("res://achievements.json", FileAccess.READ)
    if not file:
        return {}
    var json := JSON.new()
    json.parse(file.get_as_text())
    return json.data if json.data is Dictionary else {}
```

### Unlocking an Achievement (GDScript pseudocode)

```gdscript
func unlock_achievement(achievement_id: String) -> void:
    var data := load_achievements()
    for ach in data.get("achievements", []):
        if ach["id"] == achievement_id and not ach["unlocked"]:
            ach["unlocked"] = true
            ach["unlockedAt"] = Time.get_datetime_string_from_system()
            _recalculate_points(data)
            _save_achievements(data)
            show_toast(ach)
            break

func _recalculate_points(data: Dictionary) -> void:
    var total := 0
    for ach in data.get("achievements", []):
        if ach["unlocked"]:
            total += ach["points"]
    data["meta"]["totalPointsEarned"] = total
    data["meta"]["lastUpdated"] = Time.get_datetime_string_from_system()
```

### Unlock Flow

1. Game detects milestone condition (e.g., enemy died signal)
2. Call `unlock_achievement("first_blood")`
3. Function checks if already unlocked (idempotent — skips if so)
4. Sets `unlocked: true`, writes ISO timestamp to `unlockedAt`
5. Recalculates `meta.totalPointsEarned`
6. Updates `meta.lastUpdated`
7. Saves JSON back to disk
8. Triggers toast popup

### Where to Hook Unlocks

| Achievement | Signal / Location |
|-------------|-------------------|
| `first_steps` | `TitleScreen` — on any key press transition |
| `choose_your_fighter` | `GameLevel._spawn_character()` completes |
| `blade_dancer` | `GameLevel._spawn_character()` when `character_id == 0` |
| `lance_bearer` | `GameLevel._spawn_character()` when `character_id == 1` |
| `dragon_pact` | `GameLevel._spawn_character()` when `character_id == 2` |
| `well_rounded` | Check all 3 character achievements unlocked |
| `first_blood` | `EnemyBase.died` signal |
| `fireball` | `MagicChargeState` fires projectile |
| `sky_walker` | `DoubleJumpState.enter()` |
| `glider` | `GlideState.enter()` |
| `dragon_dive` | `DragonJumpState.enter()` |
| `high_flyer` | `HighJumpState.enter()` |
| `long_jumper` | `LongJumpState.enter()` |
| `companion_call` | `InputManager.companion_just_pressed` consumed |
| `dragon_strike` | `DragonCompanion._perform_attack()` kills enemy |
| `locked_on` | `LockOnSystem` acquires first target |
| `target_swap` | `LockOnSystem` cycles to different target |
| `survivor` | `CharacterBase.take_damage()` leaves `current_hp == 1` |
| `full_recovery` | `CharacterBase.heal()` restores to `max_hp` |
| `save_scribe` | `SaveManager.save_game()` first call |
| `grunt_slayer` | Track MeleeGrunt kill count, fire at 10 |
| `untouchable` | Enemy dies while player has full HP |
| `settings_tweaker` | Any settings slider/toggle change |
| `night_warrior` | All other 23 achievements unlocked |

## Overlay Toast Specification

### Behavior

When an achievement unlocks, display a small non-blocking popup:

```
+------------------------------------+
|  [icon]  Achievement Unlocked!     |
|          Sky Walker       +10 pts  |
+------------------------------------+
```

### Requirements

| Property | Value |
|----------|-------|
| Position | Top-center or top-right of viewport |
| Size | ~400x80 px (scale with viewport) |
| Layer | CanvasLayer above HUD (layer 10+) |
| Animation | Slide in from top, hold, slide out |
| Duration | 3 seconds visible, 0.3s enter, 0.3s exit |
| Queue | If multiple unlock simultaneously, queue and show sequentially |
| Input | Non-blocking — does not pause game or capture input |
| Sound | Optional unlock chime (when audio system exists) |

### Visual Spec

| Element | Style |
|---------|-------|
| Background | Semi-transparent dark panel (`Color(0.1, 0.1, 0.15, 0.9)`) |
| Border | 1px gold/yellow accent (`Color(1.0, 0.85, 0.3)`) |
| Icon | 48x48 px, left-aligned |
| Title | "Achievement Unlocked!" — small, gold text |
| Name | Achievement name — white, bold |
| Points | "+N pts" — gold, right-aligned |

### Implementation Notes (for future)

- Create as a standalone scene: `scenes/ui/AchievementToast.tscn`
- Root: `CanvasLayer` > `PanelContainer`
- Use `Tween` for slide animation
- Auto-`queue_free()` after animation completes
- Managed by an autoload or the HUD script

## Safe Update Rules

These rules MUST be followed when modifying `achievements.json`:

1. **Only append** new achievements — never reorder or remove existing entries
2. **Never reset** `unlocked: true` back to `false`
3. **Never clear** `unlockedAt` timestamps
4. **Always recalculate** `meta.totalPointsEarned` from actual unlocked items
5. **Always update** `meta.lastUpdated` on any write
6. **Validate before write** — ensure all `id` values are unique
7. **Preserve user data** — if merging new achievements into an existing file, keep all unlocked state intact
