local L = LibStub("AceLocale-3.0"):NewLocale("mMediaTag", "enUS", true, true)
if not L then return end

-- core/functions.lua
L["Error decompressing data."] = true
L["Error deserializing:"] = true
L["Error importing profile. String is invalid or corrupted!"] = true

-- modules/datatexts/info_score.lua
L["Dungeon overview:"] = true
L["Keystones in your Group"] = true
L["Level: "] = true
L["No Keystone"] = true
L["Possible next upgrades:"] = true
L["This Week Affix"] = true

-- modules/datatexts/misc_coordinate.lua
L["Coordinate X"] = true
L["Coordinate Y"] = true

-- modules/datatexts/misc_dungeon.lua
L["Call to Arms:"] = true
L["Difficulty Infos:"] = true
L["Dungeon Infos:"] = true
L["Dungeon:"] = true
L["Guild Party:"] = true
L["Legacy Raid:"] = true
L["Name:"] = true
L["No"] = true
L["Raid:"] = true
L["This week's Affix"] = true
L["Yes"] = true

-- modules/datatexts/misc_gamemenu.lua
L["Framerate:"] = true
L["Game Menu"] = true
L["Latency:"] = true
L["left click to open the menu."] = true
L["right click to open LFD Browser"] = true

-- modules/datatexts/misc_individual_professions.lua
L["Archaeology"] = true
L["Cooking"] = true
L["Fishing"] = true
L["Not learned"] = true
L["Primary Profession"] = true
L["Secondary Profession"] = true

-- modules/datatexts/misc_professions.lua
L["click to open the menu."] = true
L["Main Professions"] = true
L["No Main Professions"] = true
L["No Secondary Professions"] = true
L["Secondary Professions"] = true

-- modules/datatexts/misc_teleports.lua
L["Dungeon Teleports"] = true
L["Engineering"] = true
L["Favorite"] = true
L["Items"] = true
L["Left click to open the Teleports menu."] = true
L["M+ Season"] = true
L["Mage Portals"] = true
L["Mage Teleports"] = true
L["Midnight"] = true
L["Other Portals"] = true
L["Other Teleports"] = true
L["Season Teleports"] = true
L["Spells"] = true
L["You can select your favourites in the settings."] = true
L["You currently have no important teleports."] = true

-- modules/dock/achievement.lua
L["Achievement points:"] = true
L["Completed"] = true
L["Guild Achievement points:"] = true
L["Missing"] = true
L["Tracked Achievements"] = true

-- modules/dock/calendar.lua
L["Date:"] = true

-- modules/dock/character.lua
L["Account total"] = true
L["Time played this level"] = true
L["Total play time"] = true

-- modules/dock/collection.lua
L["Collected"] = true
L["Mounts"] = true
L["Pets"] = true

-- modules/dock/encounter.lua
L["Progress:"] = true
L["Reisetagebuch"] = true

-- modules/dock/housing.lua
L["Neighborhood"] = true
L["No cached house information available."] = true
L["Owner"] = true

-- modules/dock/spellbook.lua
L["click to open the Spellbook."] = true
L["Opening the spellbook via addons can lead to taints.\nThis occurs when protected Blizzard code is unintentionally modified or affected,\nwhich may result in malfunctions or UI restrictions."] = true

-- modules/dock/store.lua
L["WoW Token:"] = true

-- modules/misc/auto_quest.lua
L["[AutoQuest] Auto-accept paused (SHIFT held)."] = true
L["[AutoQuest] Auto-turn-in paused (SHIFT held)."] = true
L["[AutoQuest] Quest accepted: %s"] = true
L["[AutoQuest] Quest turned in: %s"] = true

-- modules/misc/class_icons.lua
L["Could not add the texture."] = true
L["The style already exists."] = true
L["The texture coordinates must be passed as a table."] = true

-- modules/misc/details.lua
L["Click to hide Details frames."] = true
L["Details embedded toggle"] = true

-- modules/misc/dice_button.lua
L["Left Click to roll"] = true
L["Right Click to roll"] = true
L["Roll Button"] = true

-- modules/misc/greeting_message.lua
L["Welcome to %s %s version |CFFF7DC6F%s|r, type |CFF58D68D/mmt|r to access the in-game configuration menu or type |CFF58D68D/mmt help|r for an overview of all chat commands."] = true

-- modules/misc/lfg_invite_info.lua
L["Activity:"] = true
L["Group:"] = true
L["Location:"] = true
L["PVE"] = true
L["The Flame Burns Eternal"] = true
L["The Floodgate"] = true
L["The Rookery"] = true
L["Transmog farming"] = true
L["Weekly"] = true

-- modules/misc/tags.lua
L["Returns the classification icon of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-classification:icon{rare:elite}] will only show something if the unit is either rare or elite."] = true
L["Returns the classification of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-classification{rare:elite}] will only show something if the unit is either rare or elite."] = true
L["Returns the color of the unit. Players are colored by class, NPCs by classification. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-color{rare:elite}] will only show something if the unit is either rare or elite."] = true
L["Returns the current health of the unit (changes between current health and percent in combat)."] = true
L["Returns the current health of the unit."] = true
L["Returns the current health percent of the unit (in combat)."] = true
L["Same as mMT-color, but only for the units target."] = true
L["Same as mMT-deathcount, but only shows the count while the player is dead."] = true

-- modules/misc/tagsold.lua
L["Name"] = true
L["Returns icons of players currently targeting the unit, but only while in combat."] = true
L["Returns the classification icon of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mClass:icon{rare:elite}] will only show something if the unit is either rare or elite."] = true
L["Returns the classification of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mClass{rare:elite}] will only show something if the unit is either rare or elite."] = true
L["Returns the color of the unit. Players are colored by class, NPCs by classification. You can specify up to three arguments to display only certain classifications.\nFor example: [mColor{rare:elite}] will only show something if the unit is either rare or elite."] = true
L["Returns the current health and percent of the unit or it will return the status (AFK, DND, Offline, Dead, Ghost)."] = true
L["Returns the current health of the unit (changes between max health and percent in combat) including absorbs or it will return the status (AFK, DND, Offline, Dead, Ghost)."] = true
L["Returns the current health of the unit (changes between max health and percent in combat) or it will return the status (AFK, DND, Offline, Dead, Ghost)."] = true
L["Returns the current health of the unit (changes between max health and percent in combat). Does not return status."] = true
L["Returns the name of the unit. If in an instance, it will return the last word of the name."] = true
L["Returns the number of players currently targeting the unit, but only while in combat."] = true
L["Returns the raid target marker icon of the unit."] = true
L["Returns the status icon of the unit (AFK, DND, Offline, Dead, Ghost) or the name of the unit."] = true
L["Returns the status of the unit (AFK, DND, Offline, Dead, Ghost) or the name of the unit."] = true
L["Same as mColor, but only for the units target."] = true
L["Same as mDeathCount, but only shows the count while the player is dead."] = true
L["Short Version"] = true

-- options/about.lua
L["Contact"] = true
L["Help"] = true
L["Thanks to:"] = true

-- options/cast/important_casts.lua
L["Adds an Extra Icon to the Castbar."] = true
L["Border Color"] = true
L["Class Colors"] = true
L["Health Override"] = true
L["Override Health Bar Color"] = true
L["Position Settings"] = true
L["Sets the offset according to the anchor."] = true

-- options/changelog.lua
L["Fixes"] = true
L["Important"] = true
L["New"] = true
L["Released"] = true
L["Updates"] = true
L["Version"] = true

-- options/colors_difficulty.lua
L["Other"] = true

-- options/colors_tip_menu.lua
L["Title"] = true

-- options/datatext/misc_dungeon.lua
L["Dungeon Name"] = true

-- options/datatext/misc_individual_professions.lua
L["White"] = true

-- options/datatext/misc_tracker.lua
L["Delete ID"] = true
L["ID list"] = true

-- options/dock/durability.lua
L["Durability"] = true

-- options/dock/example.lua
L["Delete all"] = true
L["Dock on Top"] = true
L["Preview"] = true

-- options/dock/general.lua
L["Custom Font Size"] = true
L["Font Size"] = true

-- options/dock/volume.lua
L["Colored Text"] = true

-- options/misc/details.lua
L["Adds a button to show or hide details on click. The button is only visible on mouse over."] = true
L["Details embeded"] = true
L["Details Windows"] = true
L["Embedded Settings"] = true
L["Embedded to Chat"] = true
L["Left Chat"] = true
L["Right Chat"] = true
L["Toggle Button"] = true

-- options/misc/dice_button.lua
L["Color Hover"] = true
L["Color Normal"] = true
L["Custom color"] = true
L["Hover Color Style"] = true
L["Hover Custom Color"] = true
L["Left Click"] = true
L["Right Click"] = true

-- options/misc/difficulty_info.lua
L["LEFT"] = true
L["RIGHT"] = true

-- options/misc/phase_icon.lua
L["Phasing"] = true
L["Sharding"] = true

-- options/misc/ready_check_icon.lua
L["Not Ready"] = true
L["Waiting"] = true

-- options/misc/summon_icon.lua
L["Accepted"] = true
L["Available"] = true
L["Rejected"] = true

-- options/misc/tags.lua
L["Cross"] = true
L["Moon"] = true
L["Skull"] = true
L["Star"] = true
L["Triangle"] = true

-- options/options_core.lua
L["About"] = true
L["Custom Docks"] = true
L["Example"] = true
L["Individual Professions"] = true
L["Keystone to Chat"] = true
L["License"] = true
L["Nameplates"] = true
L["Notification"] = true
L["Open Settings"] = true
L["Phase Icon"] = true
L["Portraits"] = true
L["Professions"] = true
L["Ready Check Icons"] = true
L["Unitframes"] = true

-- options/portraits/portraits.lua
L["Anchor Point"] = true
L["Arena"] = true
L["Background color shift"] = true
L["Cast Icon"] = true
L["Class colored"] = true
L["Custom Textures"] = true
L["Death"] = true
L["Enable"] = true
L["Enable Class colored Background"] = true
L["Focus"] = true
L["Frame Level"] = true
L["Frame Strata"] = true
L["Mask"] = true
L["Party"] = true
L["Pet"] = true
L["Player"] = true
L["Reaction"] = true
L["Shadow"] = true
L["Target"] = true
L["Target of Target"] = true

-- options/skin/data_panel_skin.lua
L["Alpha"] = true
L["Change Texture"] = true
L["Dark Class"] = true
L["Delete all Settings"] = true
L["Disable"] = true
L["Export"] = true
L["Import"] = true
L["Import/ Export of this Settings"] = true
L["Info: The Skin can be affected by other addons if they add a skin for all windows. To fix the problem, the skin must be deactivated in the other addon. This is not a bug of mMT."] = true
L["Output/ Input"] = true
L["Panels"] = true
L["Reset"] = true

-- media/media.lua
L["Octagon"] = true

-- Shared / multiple files
L["+"] = true
L["AFK"] = true
L["Anchor"] = true
L["Apply"] = true
L["B"] = true
L["Background"] = true
L["Bags"] = true
L["Border"] = true
L["Boss"] = true
L["Calendar"] = true
L["CENTER"] = true
L["Changelog"] = true
L["Circle"] = true
L["Class"] = true
L["Classification"] = true
L["Color"] = true
L["Color Style"] = true
L["Colors"] = true
L["Combat/Arena Time"] = true
L["Custom"] = true
L["Dead"] = true
L["Default"] = true
L["Diamond"] = true
L["Difficulty:"] = true
L["DND"] = true
L["Dock"] = true
L["DPS"] = true
L["Dungeon"] = true
L["Elite"] = true
L["Favorites"] = true
L["Font"] = true
L["Font contour"] = true
L["Friends"] = true
L["General"] = true
L["Ghost"] = true
L["Guild"] = true
L["Healer"] = true
L["Health"] = true
L["Housing"] = true
L["Icon"] = true
L["Icon Size"] = true
L["Icons"] = true
L["Keystone"] = true
L["Keystones on your Account"] = true
L["left click to open Character Frame"] = true
L["left click to open LFD Frame"] = true
L["Level"] = true
L["LFG Invite Info"] = true
L["M+ Score"] = true
L["Misc"] = true
L["Miscellaneous"] = true
L["My Info"] = true
L["Mythic"] = true
L["Mythic+"] = true
L["No Professions"] = true
L["None"] = true
L["Normal"] = true
L["Offline"] = true
L["Power"] = true
L["R"] = true
L["R+"] = true
L["Raid"] = true
L["Rare"] = true
L["Rare Elite"] = true
L["Ready"] = true
L["Repair Mount"] = true
L["Returns a PvP icon if the unit is flagged for PvP and belongs to either the Horde or Alliance faction."] = true
L["Returns a quest icon if the unit is a quest mob."] = true
L["Returns the class icon of the unit. You can specify a size between 16 and 128 (default is 64). Example: mClassIcon:style{32}"] = true
L["Returns the current power percent of the unit, but only while in combat."] = true
L["Returns the faction icon of the unit (Horde or Alliance), but only if it's the opposite faction of the player."] = true
L["Returns the faction icon of the unit (Horde or Alliance)."] = true
L["Returns the faction of the unit (Horde or Alliance), but only if it's the opposite faction of the player."] = true
L["Returns the faction of the unit (Horde or Alliance)."] = true
L["Returns the level of the unit. If the unit is at max level or the same level as you, it will return nothing. If the player is resting, it will return a Zzz."] = true
L["Returns the level of the unit. If the unit is at max level. If the player is resting, it will return a Zzz."] = true
L["Returns the number of times the player has died since you entered the instance. Resets when you leave the instance."] = true
L["Returns the role icon of the unit (Tank, Healer, DPS)."] = true
L["Returns the role of the unit (Tank, Healer, DPS)."] = true
L["Returns the status icon of the unit (AFK, DND, Offline, Dead, Ghost)."] = true
L["Returns the status of the unit (AFK, DND, Offline, Dead, Ghost)."] = true
L["right click to open Great Vault"] = true
L["right click to use:"] = true
L["Role Icons"] = true
L["Settings"] = true
L["SHIFT + right click to clear all saved keystones."] = true
L["Short Version."] = true
L["Show Icon"] = true
L["Size"] = true
L["Square"] = true
L["Status"] = true
L["Style"] = true
L["Tank"] = true
L["Teleports"] = true
L["Text"] = true
L["Texture"] = true
L["Tooltip"] = true
L["Toys"] = true
L["Volume"] = true
L["X offset"] = true
L["Y offset"] = true

-- core/addoncompartment.lua
L["SHIFT + Click"] = true
L["for debug mode."] = true

-- core/cmd.lua
L["Added dev GUID:"] = true
L["Available commands:"] = true
L["DEV mode active"] = true
L["GUID:"] = true
L["Lua errors off."] = true
L["Show the current version"] = true
L["Show this help message"] = true
L["Show your player GUID"] = true
L["Toggle debug mode"] = true
L["Toggle debug mode with safe addons"] = true
L["Unable to detect player GUID."] = true
L["unknown"] = true
L["unknownIDS cleared."] = true
L["Version:"] = true

-- core/functions.lua
L["!! ERROR - Round:"] = true
L["AddOn Memory:"] = true
L["CPU overall:"] = true
L["CPU peak:"] = true
L["Memory/ CPU usage:"] = true

-- core/retail.lua
L["No current Mythic+ affixes found."] = true

-- media/media.lua
L["Blizzard Portrait"] = true
L["Blizzard Portrait v2"] = true
L["Blizzard Portrait v3"] = true
L["Blizzard Portrait v4"] = true
L["Cardinal v1"] = true
L["Cardinal v2"] = true
L["Cardinal v3"] = true
L["Cardinal v4"] = true
L["Cardinal v5"] = true
L["Cardinal v6"] = true
L["Cardinal v7"] = true
L["Hexagon"] = true
L["Parallelogram"] = true
L["Parallelogram v2"] = true
L["Parallelogram v3"] = true
L["Square Rounded"] = true
L["Window"] = true
L["Zigzag"] = true
L["Zigzag v2"] = true

-- modules/datatexts/info_score.lua
L["middle click to open M+ Frame"] = true

-- modules/misc/dice_button.lua
L["Dice Button"] = true

-- options/cast/important_casts.lua
L["Disabled"] = true
L["Enabled"] = true

-- options/cast/interrupt_on_cd.lua
L["Background Multiplier"] = true
L["Change BG color"] = true
L["Enable to change the background color of the castbar."] = true
L["Marker"] = true
L["On CD"] = true
L["Set the background color multiplier for the castbar."] = true
L["The marker color for in time interrupts."] = true

-- options/colors_difficulty.lua
L["Delve"] = true
L["Follower"] = true
L["H"] = true
L["Heroic"] = true
L["LFR"] = true
L["M"] = true
L["M+"] = true
L["N"] = true
L["PVP"] = true
L["Quest"] = true
L["SC"] = true
L["Scenario"] = true
L["Story"] = true
L["TW"] = true
L["Timewalking"] = true

-- options/colors_tip_menu.lua
L["Mark"] = true
L["Tip"] = true

-- options/datatext/datatexts.lua
L["Change Colors"] = true
L["Override Text Color"] = true
L["Override Value Color"] = true
L["Text Color"] = true
L["These colors are used for the tooltips of the datatexts."] = true
L["colors"] = true

-- options/datatext/info_combat_time.lua
L["Hide delay"] = true
L["In Combat"] = true
L["Out of Combat"] = true

-- options/datatext/info_durability_itemlevel.lua
L["Force withe Text"] = true
L["Repair Threshold"] = true
L["Threshold value for the repair color, if this is active then you should repair your gear."] = true
L["Threshold value for the repair color, if this is active, you should repair your equipment soon."] = true
L["Warning colors"] = true
L["Warning Threshold"] = true

-- options/datatext/info_score.lua
L["Keystone level"] = true
L["Score"] = true
L["Show Party Keystones"] = true
L["Show Upgrades"] = true
L["Sort method"] = true

-- options/datatext/misc_dungeon.lua
L["Change Text to Dungeon Name."] = true

-- options/datatext/misc_gamemenu.lua
L["Menu Text color"] = true
L["Show Menu Icons"] = true
L["Show Systeminfo"] = true
L["colored"] = true

-- options/datatext/misc_individual_professions.lua
L["Colored"] = true
L["Icon Style"] = true

-- options/datatext/misc_professions.lua
L["Menu Icons"] = true

-- options/datatext/misc_teleports.lua
L["Slot"] = true

-- options/datatext/misc_tracker.lua
L["!!Error - this is not an ID."] = true
L["Add Currency or Item ID"] = true
L["Color the text"] = true
L["Custom IDs"] = true
L["Enter a Currency or Item it accepts only Numbers."] = true
L["Here you can add custom IDs for the tracker. You can add currencies or items. This will add DataTexts for each ID to ElvUI."] = true
L["Is Currency"] = true
L["Short large numbers"] = true
L["Show Name"] = true
L["Show max amount"] = true

-- options/dock/common
L["Custom Color"] = true
L["Use a custom color for the icon."] = true

-- options/dock/bags.lua
L["Free Slots"] = true
L["Gold Infos"] = true
L["Money"] = true
L["Money / Free Slots"] = true
L["Show gold infos instead of bag slots in the tooltip."] = true
L["Used / Total Slots"] = true
L["Used Slots"] = true

-- options/dock/character.lua
L["Show durability percentage as text."] = true
L["Threshold"] = true

-- options/dock/durability.lua
L["Durability / Item level"] = true
L["Item level"] = true

-- options/dock/example.lua
L["Dock V2"] = true
L["MAUI"] = true
L["XIV Like"] = true
L["XVI Like colored"] = true

-- options/dock/friends.lua
L["Show number of online friends on the icon."] = true

-- options/dock/general.lua
L["Auto grow"] = true
L["Automatically adjust the growth size based on the icon size. When you hover over the icon."] = true
L["Class Color"] = true
L["Clicked"] = true
L["Font Color"] = true
L["Font Outline"] = true
L["Growth size"] = true
L["Hover"] = true
L["Set the clicked color of the icon."] = true
L["Set the font for dock text."] = true
L["Set the font outline for dock text."] = true
L["Set the font size for dock text."] = true
L["Set the growth size of the dock icon. This is the distance between the icons."] = true
L["Set the hover color of the icon."] = true
L["Set the normal color of the icon."] = true
L["Show a tooltip when you hover over the icon."] = true
L["Use a custom color for dock text. If disabled, the font color will be class colored."] = true
L["Use a custom font size for dock text. If disabled, the font size will be set to one third of the icon size."] = true
L["Use class color for the icon."] = true

-- options/dock/guild.lua
L["Show number of online Guild members on the icon."] = true

-- options/dock/lfd.lua
L["Call to the arms"] = true
L["Show difficulty or call to the arms on the icon."] = true
L["Show icons for call to the arms."] = true

-- options/dock/notification.lua
L["Auto size"] = true
L["ClassColor"] = true

-- options/dock/volume.lua
L["Color the text with the ElvUI color."] = true

-- options/misc/auto_quest.lua
L["Auto Accept"] = true
L["Auto Quest"] = true
L["Auto Turn-In"] = true
L["Automatically accepts quest dialogs from NPCs."] = true
L["Automatically turns in completed quests. If the quest has multiple reward choices, the dialog stays open for you to choose."] = true
L["Chat Messages"] = true
L["Disables auto accept/turn-in while you are in combat."] = true
L["Prints a message to chat whenever a quest is auto-accepted or turned in."] = true
L["Skip in Combat"] = true

-- options/misc/difficulty_info.lua
L["Alignment"] = true
L["Difficulty Info"] = true
L["Font size, top line"] = true
L["Show Frame"] = true

-- options/misc/greeting_message.lua
L["Show a greeting message in the chat when you log in."] = true

-- options/misc/keystone_to_chat.lua
L["Post your keystone to the chat when someone types !key or !keys into the chat."] = true

-- options/misc/lfg_invite_info.lua
L["Fade out delay"] = true
L["First line color"] = true
L["Font size, bottom line"] = true
L["Second line color"] = true
L["Show in chat"] = true
L["Third line color"] = true

-- options/misc/phase_icon.lua
L["Chromie Time"] = true
L["Timerunning World"] = true
L["War Mode"] = true

-- options/misc/tags.lua
L["DC/ Offline"] = true
L["Health trashhold 1"] = true
L["Health trashhold 2"] = true
L["PvP"] = true
L["Raidtarget Markers"] = true
L["Set the first health trashhold."] = true
L["Set the second health trashhold."] = true
L["Targeting Players"] = true

-- options/misc/tooltip.lua
L["Icon Zoom"] = true

-- options/nameplates/shared
L["Border color"] = true
L["Health color"] = true
L["Ignore threat color"] = true

-- options/nameplates/nameplate_tools.lua
L["ElvUI Color Settings"] = true
L["Open the ElvUI color settings to adjust the colors used for nameplates."] = true
L["Sets automatically your class color for glow and border color on nameplates for the target unit."] = true
L["Target & Glow color"] = true

-- options/options_core.lua
L["Data Panel Skin"] = true
L["Datatexts"] = true
L["Details embedded"] = true
L["Difficulty"] = true
L["Durability & Item Level"] = true
L["Focus Highlight"] = true
L["Gamemenu"] = true
L["Greeting Message"] = true
L["In WoW Classic, the docks may appear differently because not all modules are available in this version. However, you can still customize the docks through the ElvUI settings."] = true
L["Interrupt On CD"] = true
L["Minimap Skin"] = true
L["Quest Highlight"] = true
L["Resurrection Icon"] = true
L["Summon Icon"] = true
L["TAGs"] = true
L["Target Highlight"] = true
L["These are just examples of how to create your own dock using ElvUIâ€™s custom data text bars..."] = true
L["Tip/ Menu"] = true
L["Tracker"] = true

-- options/portraits/portraits.lua
L["BG"] = true
L["BG Style"] = true
L["Choose the background style for the transparent Class icons."] = true
L["Class icon"] = true
L["Custom Extra Texture"] = true
L["Death Knight"] = true
L["Demon Hunter"] = true
L["Desaturate"] = true
L["Druid"] = true
L["Embellishment"] = true
L["Enable Custom Textures for Portrait."] = true
L["Enable Cast Icons."] = true
L["Enable Custom extra Textures for Portrait."] = true
L["Enable and select a class icon style for the portrait."] = true
L["Enable Extra Texture"] = true
L["Enable the Shadow for the Portraits."] = true
L["Enable the Unit Portrait."] = true
L["Enable this to show the Extra Texture on top of the Unit Portrait."] = true
L["Enable custom Position and size settings for Extra Texture."] = true
L["Enemy"] = true
L["Evoker"] = true
L["Extra"] = true
L["Extra Mask"] = true
L["Extra Settings"] = true
L["Extra Shadow"] = true
L["Force Extra Texture"] = true
L["Forces the default color for all texture."] = true
L["Frame Level/ Strata"] = true
L["Friendly"] = true
L["Hunter"] = true
L["It will override the default extra texture, but will take care of rare/elite/boss units."] = true
L["Mage"] = true
L["Monk"] = true
L["Neutral"] = true
L["On Top"] = true
L["Paladin"] = true
L["Portrait Scale"] = true
L["Priest"] = true
L["Put your custom textures in the Addon folder and add the path here (example MyMediaFolder\\MyTexture.tga)."] = true
L["Reset all colors"] = true
L["Reset class colors"] = true
L["Rogue"] = true
L["Select a extra texture style for boss units."] = true
L["Select a extra texture style for elite units."] = true
L["Select a extra texture style for player."] = true
L["Select a extra texture style for rare elite units."] = true
L["Select a extra texture style for rare units."] = true
L["Select a portrait texture style."] = true
L["Shadow Alpha"] = true
L["Shaman"] = true
L["Shows the Extra Texture (rare/elite) for the Unit Portrait."] = true
L["Texture Style settings for Extra texture (Rare/Elite/Boss/player)."] = true
L["Texture Styles"] = true
L["TIP: If you use the Blizzard textures and change the classification color to white, you will see the extra texture with the original colors."] = true
L["Unitcolor for Extra"] = true
L["Use Default color"] = true
L["Use Spec icons"] = true
L["Use the unit color for the Extra (Rare/Elite) Texture."] = true
L["Warlock"] = true
L["Warrior"] = true
L["Will always desaturate the portraits."] = true
L["Will show the embellishment on the portraits, if the Style has an embellishment."] = true

-- options/skin/data_panel_skin.lua
L["Delete the actual Settings"] = true
L["Info: This Settings will override the ElvUI Data Panel settings."] = true
L["Reset all"] = true

-- options/skin/minimap.lua
L["Cardinal Icon"] = true

-- options/datatext/misc_gamemenu.lua
L["white"] = true

-- options/options_core.lua
L["These are just examples of how to create your own dock using ElvUI’s custom data text bars.\n\nTo set up a custom bar:\nOpen ElvUI and navigate to ElvUI > Datatext > Bars.\nEnter a name for your new bar, click OK, and then click Add.\nSet the width of the bar based on how many icons you want to display.\nSet the height, which also determines the icon size.\nChoose the number of data text slots you want.\n\nAssign icons to each slot. For example:\nSlot 1 = Dock Calendar\nSlot 2 = Dock Profession\nSlot 3 = Dock Spec\n…and so on.\n\nThis setup allows you to build a personalized dock that fits your UI and gameplay needs.\n\n"] = true

-- modules/portraits/texture_db.lua
L["Antik"] = true
L["BG 1"] = true
L["BG 2"] = true
L["BG 3"] = true
L["BG 4"] = true
L["BG 5"] = true
L["BG 6"] = true
L["Blizzard Boss"] = true
L["Blizzard Boss Neutral"] = true
L["Blizzard Elite"] = true
L["Blizzard Rare"] = true
L["Blizzard Rare/ Elite Neutral"] = true
L["Blizzard Round"] = true
L["Blizzard Round Thick"] = true
L["Blizzard Round UP"] = true
L["Blizzard Round UP Thick"] = true
L["Blizzard Sharp"] = true
L["Blizzard Sharp Thick"] = true
L["Blizzard Sharp UP"] = true
L["Blizzard Sharp UP Thick"] = true
L["Circle Thick"] = true
L["Climbing Plant"] = true
L["Climbing Plant V2"] = true
L["Cookie"] = true
L["Diamond Thick"] = true
L["Dog Any"] = true
L["Dog Pack"] = true
L["Dog Pack color"] = true
L["Dogs"] = true
L["Dogs color"] = true
L["Dragon Blue"] = true
L["Dragon Boss"] = true
L["Dragon Elite"] = true
L["Dragon Green"] = true
L["Dragon Purple"] = true
L["Leaf"] = true
L["Leaf Mirrored"] = true
L["Pad"] = true
L["Parallelogram Mirrored"] = true
L["Pentagon"] = true
L["Pixel"] = true
L["Rectangular"] = true
L["Round - Leaf"] = true
L["Round - Monster"] = true
L["Round - Pulse"] = true
L["Round - Star"] = true
L["Round - Tech"] = true
L["Round - Zickzack"] = true
L["Shield"] = true
L["Snake"] = true
L["Snake Blue"] = true
L["Snake Green"] = true
L["Snake Purple"] = true
L["Snake Red"] = true
L["Space"] = true
L["Space color"] = true
L["Square Leaf"] = true
L["Square Loop"] = true
L["Square Round"] = true
L["Square Round Thick"] = true
L["Square Spikes"] = true
L["Square Stars"] = true
L["Square Thick"] = true
L["Tear"] = true
L["Tear down"] = true
L["Tear down Mirrored"] = true
L["Tear Mirrored"] = true
L["Trapezoid"] = true
L["Trapezoid Mirrored"] = true
