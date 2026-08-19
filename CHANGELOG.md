# Changelog - ElvUI_mMediaTag

## [ver. 4.10] - 19.08.2026
### 🐛 FIX
- FIX - [Datatext]: The Teleports and Professions datatexts threw an error when WoW returned a protected cooldown value.
- FIX - [Phaseicon]: The phase icon could taint when WoW returned a protected phase reason.
- FIX - [System]: Adapted to the current ElvUI, which renamed the unit field on its unit frames and nameplates.
- FIX - [Portraits]: Party, arena and boss portraits no longer updated after a roster change.
- FIX - [NP-Highlighters]: The target, focus and quest highlight was not applied to nameplates anymore.
- FIX - [Interrupt-On-CD]: The kick bar and the castbar color were not applied on nameplates anymore.
- FIX - [System]: mMediaTag threw an error on login when another UI profile overwrote a font setting with a plain string, the font settings now live in their own database entry and are migrated automatically.
- FIX - [Portraits]: Portraits threw an error on enemy players whose identity is hidden in combat.
### 🔧 UPDATE
- UPDATE - [DT-Teleports]: The season list now shows the Midnight Season 2 dungeons, and the missing Midnight dungeon portals were added to the Midnight and dungeon submenus.
- UPDATE - [DT-Tracker]: The default currency list is updated for Midnight Season 2, with the Mistcrests, Venomblight Manaflux, Tidal Spark Dust and Nebulous Voidcore.
- UPDATE - [Skins]: Auctionator's own confirmation, name and money dialogs now match ElvUI as well.
- UPDATE - [Skins]: The Premade Groups Filter checkboxes can be resized and colored, in ElvUI's color, your class color or a custom one, and the PGF button on the group finder is skinned as well.
- UPDATE - [Skins]: The Premade Groups Filter window now has a divider below its title, like the BugSack skin.
- UPDATE - [System]: The developer commands are only listed in /mmt help while DEV mode is active.
### ✨ NEW
- NEW - [Skins]: Class Codex now matches ElvUI, the codex panel, the compendium, every dropdown, the loadout dock and the widget in the talent frame.
- NEW - [Skins]: BigWigs now matches ElvUI, the keystone window and the timer bar below the dungeon invite, whose color can be BigWigs' own, your class color or a custom one.
- NEW - [Unitframe-Textures]: New module that sets the statusbar and the background texture per unit frame, separately for player, target, target of target, target of target of target, focus, pet, party, arena and boss.
- NEW - [Unitframe-Textures]: The castbar, incoming heal, absorb shield, heal absorb and power cost bars can each be given their own texture.
- NEW - [Unitframe-Textures]: The power bar and the background have their own switch per unit, so a texture change can stay on the health bar alone.
- NEW - [NP-Classification]: New module that gives nameplates their own statusbar texture per classification, for world bosses, elite bosses, elite minions, rare elites, rares and casters, each with its own switch.
### 📌 INFO
- INFO - Datatext slots that showed a Season 1 crest are empty after this update and need to be assigned again, the Season 2 crests replaced them.

## [ver. 4.09] - 12.08.2026
### 🐛 FIX
- FIX - [Objective-Tracker]: Completed objectives kept the normal text color instead of the completed color.
- FIX - [Portraits]: Portraits no longer turn solid black while a unit's model is still loading, for example during quest or item transformations.
- FIX - [DT-Dungeon]: The tooltip threw an error when no dungeon or raid difficulty had been set.
- FIX - [Interrupt-On-CD]: The castbar could keep the mMT color after the interrupt was used or after a cast was interrupted or failed, instead of returning to ElvUI's color.
- FIX - [Important-Casts]: Important casts were not marked on nameplates at all unless the health bar color override was enabled.
- FIX - [Tags]: The mMT-health:current tag was listed without a description.
- FIX - [System]: An export string that belongs to another setting was silently ignored on import, now it is rejected with a message in the chat.
- FIX - [System]: Opening the Great Vault, the Encounter Journal or the weekly affix tooltip threw an error on WoW 12.1.
- FIX - [Tags]: The role, PvP, faction, class icon and spec icon tags threw an error on units whose identity is hidden in combat, which also stopped the other tags in the same text from updating.
- FIX - [Portraits]: Class icon portraits threw an error on units whose identity is hidden in combat.
- FIX - [DT-Score]: The group tooltip threw an error on units whose identity is hidden in combat.
### 🔧 UPDATE
- UPDATE - [System]: Updated for WoW 12.1.
- UPDATE - [System]: Adapted to the current ElvUI, which reworked its font handling, media updates, module loading and frame templates - fonts, nameplates, the tracker skin, the interrupt spell of the current spec and the datatext panel skin are applied correctly again without a reload.
- UPDATE - [DT-Skin]: Export strings use a new format, so strings created by earlier versions can no longer be imported.
- UPDATE - [Media-Pack]: Removed the duplicate statusbar textures B17 and N15, they were identical to B11 and N4.
- UPDATE - [Media-Pack]: Renamed the chat backgrounds to close a numbering gap, Chat11 and Chat12 now show the images previously named Chat12 and Chat13.
- UPDATE - [Media-Pack]: Reduced the addon size by about 2 MB without any visible change to the textures, and packs are no longer registered twice while loading.
### ✨ NEW
- NEW - [Auto-Quest]: New Auto Gossip option, selects gossip entries by type - quest label, cinematic, or single option.
- NEW - [Objective-Tracker]: Completed quest objectives now show a check icon, like the dungeon objectives.
- NEW - [Media-Pack]: Texture packs can now be enabled and disabled individually, in the mMT options under Media Pack or in the standalone panel that /mmtmp opens, each with a preview.
- NEW - [Media-Pack]: The Caith UI, MaUIv3 and mMT textures can now be enabled separately as the Misc pack.
- NEW - [Skins]: New Skins section in the options, collecting skins for other addons.
- NEW - [Skins]: BugSack now matches ElvUI, with an optional line showing the ElvUI, mMT and WoW versions next to the page counter.
- NEW - [Skins]: Auctionator now matches ElvUI on the Shopping, Selling, Cancelling and Auctionator tabs, including result lists, the item bag and the dialogs.
- NEW - [Prey-Hunt]: New module showing the current hunt stage as text on the prey icon, as 1/4, 1/4 (25%) or 25%.
- NEW - [Prey-Hunt]: Prey targets you have already defeated can be colored in the target list of the hunt gossip.
- NEW - [Addon-Manager]: New module that adds a bar below Blizzard's addon list, where you can save your enabled addons as named profiles, switch between them and filter the list.
### 📌 INFO
- INFO - This version requires ElvUI 15.19 or newer and will not load correctly on earlier releases.
- INFO - The BugSack skin is adapted from LuckyoneUI, thanks to Luckyone.

## [ver. 4.08] - 23.07.2026
### 🐛 FIX
- FIX - [Difficulty-Info]: Fix anchor position and background rendering.
- FIX - [Difficulty-Colors]: Difficulty colors and Difficulty Info did not update immediately when changed in options.
- FIX - [Portraits]: Prevent nil error when class/spec icon texture coordinates are missing (falls back to the default portrait).
- FIX - [Portraits]: Force a full update on model, vehicle and portrait-update events so the previous unit's texture is never left showing.
### 🔧 UPDATE
- UPDATE - [System]: Update Dungeon and Raid short names for Midnight.
- UPDATE - [System]: Add flexible Mythic raid size difficulty color/tag.
- UPDATE - [Portraits]: Optimized color gradient handling (reuse tables instead of allocating new ones every update).
- UPDATE - [Portraits]: Party portraits now use unit-filtered event registration, instead of listening for every unit in the game.
- UPDATE - [Portraits]: Late-arriving spec info (INSPECT_READY) now updates the portrait of newly joined party members.
- UPDATE - [Interrupt-On-CD]: Minor optimization, resolve unit/attackability once per update.
- UPDATE - [Tags]: Removed the legacy TAGs module (tagsold.lua), fully replaced by the current tags module.
- UPDATE - [Tags]: Removed the mMT-deathcount tag, replaced by the Death-Counter module.
### ✨ NEW
- NEW - [Execute-Marker]: New Nameplates module, shows a marker on enemy nameplates at your spec's execute threshold.
- NEW - [Objective-Tracker]: New module to skin the Objective Tracker.
- NEW - [Spec-Icons]: Added a new "Clean" spec icon style.

## [ver. 4.07] - 12.06.2026
### 🐛 FIX
- FIX - [Details-Embedded]: Fix issues with ElvUI chat datatext panels.
- FIX - [Portraits]: Add missing event.
- FIX - [Portraits]: Prevent nil error with extra textures.
- FIX - [Dice-Button]: Was not always displayed.
- FIX - [Role-Icons]: Fix role icons causes Party Frames to not have pet/target frames.
### 🔧 UPDATE
- UPDATE - [LFG-Info]: Update styles.
- UPDATE - [System]: Optimized weekly reset function.
- UPDATE - [Dice-Button]: Add dice range.
### ✨ NEW
- NEW - [Death-Counter]: Death Counter module for M+ Dungeons like the Difficulty module.

## [ver. 4.06] - 10.05.2026
### 🐛 FIX
- FIX - [Media-Pack]: Removed unused font entries.
- FIX - [Portraits]: Add Pet events, to prevent wrong Portraits.
### 🔧 UPDATE
- UPDATE - [DT-Teleports]: New menu entry use Random Hearthstone.
- UPDATE - [DT-Teleports]: Updated Teleports.
### ✨ NEW
- NEW - [Portraits]: New Spec icons HD and Simple Textures.
- NEW - [Tags]: Spec icon Tags are now available.

## [ver. 4.05] - 19.04.2026
### 🐛 FIX
- FIX - [LFG-Info]: Fixed visibility logic for the popup.
- FIX - [Highlighters]: Fix stack overflow.
- FIX - [System]: Update guild identification logic to use isGuildParty for consistency across modules.
### 🔧 UPDATE
- UPDATE - [System]: Refactor greeting message initialization logic.
- UPDATE - [System]: Minor code optimizations.
- UPDATE - [DT-Score]: Fallback for Group overview tooltip, uses now Blizzard api ift LOR is not available.
- UPDATE - [Details-Embedded]: The tooltip is now moved up so that there is no overlap..
### ✨ NEW
- NEW - [Auto-Sing-Up]: Auto Sing Up & Role check accept module.
- NEW - [Important-Casts]: Can now Highlight the healthbar of the Unit.

## [ver. 4.04] - 10.03.2026
### 🐛 FIX
- FIX - [LFG-Info]: Fix sometimes not showing the LFG infos.
- FIX - [Highlighters]: Fix stack overflow.
### 🔧 UPDATE
- UPDATE - [Teleports]: Update names.
- UPDATE - [System]: Update Dungeon short names.
- UPDATE - [Dock-Character]: Can now show your played time in the tooltip.
- UPDATE - [Dock-Housing]: Can now show your house infos.
- UPDATE - [System]: Update localization.

## [ver. 4.03] - 07.03.2026
### 🐛 FIX
- FIX - [Portraits]: Prevent nil error with Boss Portraits.
- FIX - [Portraits]: Load Custom Class icons sooner.
- FIX - [Portraits]: Cast icons if class icons are enabled.
### 🔧 UPDATE
- UPDATE - [Portraits]: Update Boss Portraits amount.
- UPDATE - [Portraits]: Optimized Settings behavior.
- UPDATE - [Portraits]: Death check optimized.
- UPDATE - [NP-Highlighters]: Take care of ElvUI changes.
- UPDATE - [NP-Highlighters]: Optimized the Highlighters.
- UPDATE - [NP-Highlighters]: Add Border color functionality.
- UPDATE - [NP-Highlighters]: Separated the config.
### ✨ NEW
- NEW - [Portraits]: Add Spec icons.
- NEW - [Important-Casts]: Show Important cast, thx to Trenchy.


## [ver. 4.02] - 29.03.2026
### 🐛 FIX
- FIX - [DT-Professions]: Prevent nil Bug.
- FIX - [DT-Skin]: Prevent nil Bug.
- FIX - [DT-Tracker]: Colors does not Update correctly.
- FIX - [Details-Embedded]: Embedding does not work correctly.
- FIX - [Keystone-To-Chat]: Prevent Secret value Bug.
- FIX - [Minimap-Skin]: Bug with Skin Square round.
- FIX - [Phaseicon]: wrong BG texture.
- FIX - [Tags]: Status icon and PvP icon colors does not work.
- FIX - [Tooltip-Icon]: Add missing Settings for this module.
- FIX - [Tooltip-Icon]: Prevent bug with secret values.
### 🔧 UPDATE
- UPDATE - [Details-Embedded]: Fade in/out effect.
- UPDATE - [Details-Embedded]: Removed auto hide function.
- UPDATE - [LFG-Info]: Update hide function.
- UPDATE - [Portraits]: Removed leftover color settings.
- UPDATE - [System]: Removed unused colors from the DB.
### ✨ NEW
- NEW - [Dock]: Dock icon for Housing.
- NEW - [Portraits]: Texture Pixel.
- NEW - [Tags]: A few new icons.
### 📌 INFO
- INFO - A completely new update for Midnight, almost everything has been optimized and restructured.
- INFO - Some modules and features are still missing, but this is a fully functional and working version for Midnight. There will be no version for Classic, where the 3.xx version should still work. I will continue to add more features over time.

## [ver. 4.01] - 17.03.2026
### 🔧 UPDATE
- UPDATE - [System]: Update Logo & Icon.
- UPDATE - [Intrrupt-On-CD]: Rework and Optimized, it should now work correctly.
### ✨ NEW
- NEW - [Tags]: New Health Tags hide out of combat and no decimal.
- NEW - [Class-Icons]: Add mMT Class Icons to Details.
- NEW - [Details-Embedded]: Details Embedded module is back.
- NEW - [Auto-Quest]: Auto accept and tur in Quests.
### 📌 INFO
- INFO - A completely new update for Midnight, almost everything has been optimized and restructured.
- INFO - Some modules and features are still missing, but this is a fully functional and working version for Midnight. There will be no version for Classic, where the 3.xx version should still work. I will continue to add more features over time.

## [ver. 4.00] - 13.03.2026
### 🔧 UPDATE
- UPDATE - [Portraits]: Many new Textures and removed Old versions.
- UPDATE - [Intrrupt-On-CD]: Update for Midnight.
- UPDATE - [Unitframe-Icons]: New Icons and removed some old ones.
- UPDATE - [Nameplate]: Auto set Target glow color is Back.
- UPDATE - [Nameplate]: Highlighter for Quest, Focus and Target Units.
- UPDATE - [Datatext]: Reworked almost all Datatext, you can Now easily Track custom items or currency's.
- UPDATE - [Datatext]: IDs and Teleports for Midnight.
- UPDATE - [Dock]: Update Textures and removed some.
- UPDATE - [Tags]: Update for Midnight and removed the ones that can't be done now in Midnight. Cleanup.
### 📌 INFO
- INFO - A completely new update for Midnight, almost everything has been optimized and restructured.
- INFO - Some modules and features are still missing, but this is a fully functional and working version for Midnight. There will be no version for Classic, where the 3.xx version should still work. I will continue to add more features over time.
