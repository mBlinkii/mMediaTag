local mMT, E, L, V, P, G = unpack((select(2, ...)))

local tinsert = tinsert
local function configTable()
	local icons = {}
        local afk = {}
		local dnd = {}
		local dc = {}
		local death = {}
		local ghost = {}
	--}

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
					end,
					values = icons,
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
					end,
					values = icons,
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
					end,
					values = icons,
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
					end,
					values = icons,
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
					end,
					values = ghost,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
