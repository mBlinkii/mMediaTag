local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...

--Lua functions
local mInsert = table.insert

local name, mListDNDIcons, mListDNDPath, mListAFKIcon, mListAFKPath, mListSkullIcon, mListSkullPath, mListOfflineIcon, mListOfflinePath =
	{}, {}, {}, {}, {}, {}, {}, {}, {}

local function mReturnTagIconName(name)
	return format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\%s.tga:16:16:0:0:32:32|t", name)
end

local function mReturnTagIconPath(name)
	return format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\%s.tga", name)
end

local function mSetupTagIcons()
	mListDNDIcons = wipe(mListDNDIcons)
	mListDNDPath = wipe(mListDNDPath)
	mListAFKIcon = wipe(mListAFKIcon)
	mListAFKPath = wipe(mListAFKPath)
	mListSkullIcon = wipe(mListSkullIcon)
	mListSkullPath = wipe(mListSkullPath)
	mListOfflineIcon = wipe(mListOfflineIcon)
	mListOfflinePath = wipe(mListOfflinePath)
	--DND
	for i = 1, 17, 1 do
		name = "dnd" .. i
		mListDNDIcons["DND" .. i] = mReturnTagIconName(name)
		mListDNDPath["DND" .. i] = mReturnTagIconPath(name)
	end

	--AFK
	for i = 1, 17, 1 do
		name = "afk" .. i
		mListAFKIcon["AFK" .. i] = mReturnTagIconName(name)
		mListAFKPath["AFK" .. i] = mReturnTagIconPath(name)
	end

	--SKULL
	for i = 1, 16, 1 do
		name = "skull" .. i
		mListSkullIcon["SKULL" .. i] = mReturnTagIconName(name)
		mListSkullPath["SKULL" .. i] = mReturnTagIconPath(name)
	end

	--offline
	for i = 1, 4, 1 do
		name = "offline" .. i
		mListOfflineIcon["Offline" .. i] = mReturnTagIconName(name)
		mListOfflinePath["Offline" .. i] = mReturnTagIconPath(name)
	end
end

local function OptionsTags()
	mSetupTagIcons()
	E.Options.args.mMediaTag.args.tags.args = {
		tagcolor = {
			order = 10,
			type = "group",
			name = L["Colors"],
			args = {
				headertagcolor1 = {
					order = 1,
					type = "header",
					name = L["Class"],
				},
				colorrare = {
					type = "color",
					order = 2,
					name = "Rare",
					desc = L["Class Colors"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cClassRare
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cClassRare
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				colorrarelite = {
					type = "color",
					order = 3,
					name = "Rare Elite",
					desc = L["Class Colors"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cClassRareElite
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cClassRareElite
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				colorelite = {
					type = "color",
					order = 4,
					name = "Elite",
					desc = L["Class Colors"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cClassElite
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cClassElite
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				colorboss = {
					type = "color",
					order = 4,
					name = "Boss",
					desc = L["Class Colors"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cClassBoss
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cClassBoss
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				headertagcolor2 = {
					order = 5,
					type = "header",
					name = L["General"],
				},
				colorafk = {
					type = "color",
					order = 6,
					name = "AFK",
					desc = L["AFK Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cGeneralAFK
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cGeneralAFK
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				colortank = {
					type = "color",
					order = 7,
					name = "Tank",
					desc = L["Tank Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cGeneralTank
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cGeneralTank
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				colorheal = {
					type = "color",
					order = 8,
					name = "Heal",
					desc = L["Heal Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cGeneralHeal
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cGeneralHeal
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				colorzzz = {
					type = "color",
					order = 9,
					name = "Zzz",
					desc = L["Resting Zzz Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cGeneralZzz
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cGeneralZzz
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				colorlevel = {
					type = "color",
					order = 10,
					name = "Level ??",
					desc = L["Boss Level ?? Color"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].cGeneralLevel
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].cGeneralLevel
						t.r, t.g, t.b, t.color = r, g, b, E:RGBToHex(r, g, b)
					end,
				},
				headertagcolor3 = {
					order = 20,
					type = "header",
					name = L["mStatus:icon - AFK/ DND"],
				},
				afkicon = {
					order = 21,
					type = "select",
					name = L["AFK Icon"],
					get = function(info)
						return E.db[mPlugin].mTags.afkname
					end,
					set = function(info, value)
						E.db[mPlugin].mTags.afkname = value
						E.db[mPlugin].mTags.afkpath = mListAFKPath[value]
					end,
					values = mListAFKIcon,
				},
				dndicon = {
					order = 22,
					type = "select",
					name = L["DND Icon"],
					get = function(info)
						return E.db[mPlugin].mTags.dndname
					end,
					set = function(info, value)
						E.db[mPlugin].mTags.dndname = value
						E.db[mPlugin].mTags.dndpath = mListDNDPath[value]
					end,
					values = mListDNDIcons,
				},
				headertagcolor4 = {
					order = 30,
					type = "header",
					name = L["mStatus:icon - Oflline"],
				},
				offlineicon = {
					order = 31,
					type = "select",
					name = L["Offline Icon"],
					get = function(info)
						return E.db[mPlugin].mTags.offlinename
					end,
					set = function(info, value)
						E.db[mPlugin].mTags.offlinename = value
						E.db[mPlugin].mTags.offlinepath = mListOfflinePath[value]
					end,
					values = mListOfflineIcon,
				},
				headertagcolor5 = {
					order = 40,
					type = "header",
					name = L["mStatus:icon - Dead/ Ghost"],
				},
				skullicon = {
					order = 41,
					type = "select",
					name = L["Dead Icon"],
					get = function(info)
						return E.db[mPlugin].mTags.skullname
					end,
					set = function(info, value)
						E.db[mPlugin].mTags.skullname = value
						E.db[mPlugin].mTags.skullpath = mListSkullPath[value]
					end,
					values = mListSkullIcon,
				},
				ghosticon = {
					order = 42,
					type = "select",
					name = L["Ghost Icon"],
					get = function(info)
						return E.db[mPlugin].mTags.ghostname
					end,
					set = function(info, value)
						E.db[mPlugin].mTags.ghostname = value
						E.db[mPlugin].mTags.ghostpath = mListSkullPath[value]
					end,
					values = mListSkullIcon,
				},
			},
		},
	}
end

mInsert(ns.Config, OptionsTags)
