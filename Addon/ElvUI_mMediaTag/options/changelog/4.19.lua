local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[419] = {
	DATE = "TBD",
	NEW = {
		"[Enrage-Icon]: New module that shows enrage effects on the target, focus, boss and arena unitframes and on enemy nameplates as icons and can optionally highlight the frame.",
	},
	UPDATE = {
		"[Buff-Reminder]: The reminder can hide after a set time and shows again when you enter a dungeon, raid, delve or scenario or join a group.",
		"[Dispel-Icon]: The icons can be turned off to only use the frame highlight.",
		"[Cooldown-Manager]: The settings including the mover positions can be exported and imported.",
		"[Cooldown-Manager]: A max icon size keeps the icons of a fixed or matched size from getting too big when only a few are shown.",
	},
	FIX = {
		"[System]: Errors could show up right after switching the profile, for example in the Buff-Reminder, Objective-Tracker, Keystone-Teleports and Prey-Hunt.",
		"[Options]: The game froze when a right click on an mMT mover opened its settings page after the mMT settings had been open before.",
		"[Buff-Reminder]: Low level rogues were reminded of poisons they had not learned yet.",
		"[Buff-Reminder]: The weapon enchant was shown as missing although you had no weapon oil or weapon spell to apply.",
		"[Buff-Reminder]: Raid buffs, pet and weapon spells were reminded before you had learned them.",
		"[Keystone-Teleports]: The keys of the group members stayed in the list after a finished dungeon or after leaving the group.",
		"[DT-Game-Menu]: Entries like the spellbook and collections were missing in WoW Forever.",
		"[DT-Durability]: The item level was shown in Classic versions that have none.",
		"[DT-Tracker]: Items that were not cached yet could stay empty.",
	},
}
