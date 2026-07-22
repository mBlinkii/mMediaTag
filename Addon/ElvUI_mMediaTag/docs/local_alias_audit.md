# Local Alias Audit

This is a first-pass audit of frequently used globals/APIs that are currently used without a local alias.

Notes:
- The common bootstrap line `local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)` is intentionally ignored here.
- One-off usages were skipped when they do not add readability or measurable value.
- This list is grouped by module family so cleanup can happen incrementally.

## Core

### `core/dropdown.lua`
- `ipairs`
- `max`

### `core/functions.lua`
- `ipairs`
- `time`
- `date`
- `tonumber`
- `floor`
- `max`
- `min`
- `gsub`

### `core/retail.lua`
- `format`
- `pairs`
- `ipairs`
- `tonumber`
- `tostring`
- `match`

## Cast

### `modules/cast/interrupt_on_cd.lua`
- `ipairs`
- `select`

## Datatexts

### `modules/datatexts/info_combat_time.lua`
- `format`
- `floor`

### `modules/datatexts/info_durability_itemlevel.lua`
- `pairs`
- `wipe`
- `tonumber`
- `select`

### `modules/datatexts/info_score.lua`
- `next`

### `modules/datatexts/misc_dungeon.lua`
- `pairs`
- `next`

### `modules/datatexts/misc_gamemenu.lua`
- `format`

### `modules/datatexts/misc_individual_professions.lua`
- `pairs`
- `select`

### `modules/datatexts/misc_professions.lua`
- `format`
- `pairs`
- `tinsert`
- `floor`
- `select`

### `modules/datatexts/misc_teleports.lua`
- `format`
- `type`
- `floor`

### `modules/datatexts/misc_tracker.lua`
- `format`
- `pairs`
- `next`
- `tonumber`

## Dock

### `modules/dock/character.lua`
- `format`
- `wipe`

### `modules/dock/collection.lua`
- `ipairs`

### `modules/dock/durability.lua`
- `format`
- `pairs`
- `wipe`
- `tonumber`
- `select`

### `modules/dock/encounter.lua`
- `ipairs`

### `modules/dock/friends.lua`
- `select`

### `modules/dock/guild.lua`
- `select`

### `modules/dock/housing.lua`
- `type`

### `modules/dock/lfd.lua`
- `strupper`

### `modules/dock/volume.lua`
- `match`

## Misc

### `modules/misc/class_icons.lua`
- `format`

### `modules/misc/details.lua`
- `ipairs`

### `modules/misc/elvui_icons.lua`
- `pairs`

### `modules/misc/lfg_invite_info.lua`
- `max`
- `random`
- `match`

### `modules/misc/tagsold.lua`
- `format`
- `pairs`
- `type`
- `tonumber`
- `tostring`
- `select`

### `modules/misc/tooltip.lua`
- `format`
- `ipairs`
- `select`
- `find`

## Portraits

### `modules/portraits/functions.lua`
- `pairs`

## Skin

### `modules/skin/data_panel_skin.lua`
- `pairs`
