local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	local class = {}
	local afk = {}
	local dnd = {}
	local dc = {}
	local death = {}
	local ghost = {}
	local targetmarker = {}

	for key, icon in pairs(mMT.Media.ClassIcons) do
		class[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	for key, icon in pairs(mMT.Media.AFKIcons) do
		afk[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	for key, icon in pairs(mMT.Media.DNDIcons) do
		dnd[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	for key, icon in pairs(mMT.Media.DCIcons) do
		dc[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	for key, icon in pairs(mMT.Media.DeathIcons) do
		death[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	for key, icon in pairs(mMT.Media.GhostIcons) do
		ghost[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	for key, icon in pairs(mMT.Media.TargetMarkers) do
		targetmarker[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.tags.args.icon.args = {
		header_class = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Class Icons"],
			args = {
				icon_rare = {
					order = 1,
					type = "select",
					name = L["Rare"],
					get = function(info)
						return E.db.mMT.tags.icons.rare
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.rare = value
						mMT:UpdateTagSettings()
					end,
					values = class,
				},
				icon_relite = {
					order = 2,
					type = "select",
					name = L["Rare Elite"],
					get = function(info)
						return E.db.mMT.tags.icons.relite
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.relite = value
						mMT:UpdateTagSettings()
					end,
					values = class,
				},
				icon_elite = {
					order = 3,
					type = "select",
					name = L["Elite"],
					get = function(info)
						return E.db.mMT.tags.icons.elite
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.elite = value
						mMT:UpdateTagSettings()
					end,
					values = class,
				},
				icon_boss = {
					order = 4,
					type = "select",
					name = L["Boss"],
					get = function(info)
						return E.db.mMT.tags.icons.boss
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.boss = value
						mMT:UpdateTagSettings()
					end,
					values = class,
				},
			},
		},
		header_status = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Status Icons"],
			args = {
				icon_afk = {
					order = 1,
					type = "select",
					name = L["AFK"],
					get = function(info)
						return E.db.mMT.tags.icons.afk
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.afk = value
						mMT:UpdateTagSettings()
					end,
					values = afk,
				},
				icon_dnd = {
					order = 2,
					type = "select",
					name = L["DND"],
					get = function(info)
						return E.db.mMT.tags.icons.dnd
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.dnd = value
						mMT:UpdateTagSettings()
					end,
					values = dnd,
				},
				icon_offline = {
					order = 3,
					type = "select",
					name = L["Offline"],
					get = function(info)
						return E.db.mMT.tags.icons.offline
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.offline = value
						mMT:UpdateTagSettings()
					end,
					values = dc,
				},
				icon_death = {
					order = 4,
					type = "select",
					name = L["Death"],
					get = function(info)
						return E.db.mMT.tags.icons.death
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.death = value
						mMT:UpdateTagSettings()
					end,
					values = death,
				},
				icon_ghost = {
					order = 5,
					type = "select",
					name = L["Ghost"],
					get = function(info)
						return E.db.mMT.tags.icons.ghost
					end,
					set = function(info, value)
						E.db.mMT.tags.icons.ghost = value
						mMT:UpdateTagSettings()
					end,
					values = ghost,
				},
			},
		},
		header_raidtartegticons = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Targetmarker Icons"],
			args = {
				icon_star = {
					order = 1,
					type = "select",
					name = L["Star"],
					get = function(info)
						return E.db.mMT.tags.targetmarker[1]
					end,
					set = function(info, value)
						E.db.mMT.tags.targetmarker[1] = value
						mMT:UpdateTagSettings()
					end,
					values = targetmarker,
				},
				icon_circle = {
					order = 2,
					type = "select",
					name = L["Circle"],
					get = function(info)
						return E.db.mMT.tags.targetmarker[2]
					end,
					set = function(info, value)
						E.db.mMT.tags.targetmarker[2] = value
						mMT:UpdateTagSettings()
					end,
					values = targetmarker,
				},
				icon_diamond = {
					order = 3,
					type = "select",
					name = L["Diamond"],
					get = function(info)
						return E.db.mMT.tags.targetmarker[3]
					end,
					set = function(info, value)
						E.db.mMT.tags.targetmarker[3] = value
						mMT:UpdateTagSettings()
					end,
					values = targetmarker,
				},
				icon_triangle = {
					order = 4,
					type = "select",
					name = L["Triangle"],
					get = function(info)
						return E.db.mMT.tags.targetmarker[4]
					end,
					set = function(info, value)
						E.db.mMT.tags.targetmarker[4] = value
						mMT:UpdateTagSettings()
					end,
					values = targetmarker,
				},
				icon_moon = {
					order = 5,
					type = "select",
					name = L["Moon"],
					get = function(info)
						return E.db.mMT.tags.targetmarker[5]
					end,
					set = function(info, value)
						E.db.mMT.tags.targetmarker[5] = value
						mMT:UpdateTagSettings()
					end,
					values = targetmarker,
				},
				icon_square = {
					order = 6,
					type = "select",
					name = L["Square"],
					get = function(info)
						return E.db.mMT.tags.targetmarker[6]
					end,
					set = function(info, value)
						E.db.mMT.tags.targetmarker[6] = value
						mMT:UpdateTagSettings()
					end,
					values = targetmarker,
				},
				icon_cross = {
					order = 7,
					type = "select",
					name = L["Cross"],
					get = function(info)
						return E.db.mMT.tags.targetmarker[7]
					end,
					set = function(info, value)
						E.db.mMT.tags.targetmarker[7] = value
						mMT:UpdateTagSettings()
					end,
					values = targetmarker,
				},
				icon_skull = {
					order = 8,
					type = "select",
					name = L["Skull"],
					get = function(info)
						return E.db.mMT.tags.targetmarker[8]
					end,
					set = function(info, value)
						E.db.mMT.tags.targetmarker[8] = value
						mMT:UpdateTagSettings()
					end,
					values = targetmarker,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
