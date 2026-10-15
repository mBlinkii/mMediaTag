local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

mMT.Changelog[417] = {
	DATE = "15.10.2026",
	FIX = {
		"[Buff-Reminder]: Midnight weapon oils were not found in the bags, so the weapon enchant icon could not use them.",
		"[Cooldown-Manager]: The pandemic highlight cost CPU time on every frame for each aura, it now only reacts when an aura enters or leaves the pandemic window.",
	},
	UPDATE = {
		"[Buff-Reminder]: Each check can be limited to the open world, dungeons, raids or delves and scenarios.",
		"[Dock]: The mail dock opens a menu with your mailbox toys and auction house mounts on click, a random ready toy on top, and shows the toy cooldowns in the tooltip.",
		"[Dock]: Right click on the character dock switches equipment sets and its tooltip lists them, on the collections dock summons a random favorite mount or pet or opens a collection tab, and on the housing dock teleports you to your plot.",
		"[Dock]: CTRL + left click on the volume dock sets the master volume.",
		"[DT-Dungeon]: Right click on the dungeon and M+ score datatexts and the dungeon dock opens a menu for the Dungeon Finder, Raid Finder, Premade Groups, Mythic+, PvP and the Great Vault.",
		"[DT-Durability]: Right click on the datatext and the durability dock opens a menu with all your repair mounts and a random one on top, the mount no longer has to be chosen in the settings.",
		"[Keystone-Teleports]: Warns when the group leader has left the group or the dungeon difficulty is not set to Mythic.",
	},
}
