local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local tinsert = tinsert

local function setFavorite(slot, value)
	if value == "none" then
		E.db.mMT.datatexts.teleports.favorites[slot] = { id = "none", kind = "none" }
	else
		for _, category in pairs(mMT.knownTeleports) do
			if type(category) == "table" then
				for id, t in pairs(category) do
					if id == value then
						E.db.mMT.datatexts.teleports.favorites[slot] = { id = id, kind = t.kind }
						break
					end
				end
			end
		end
	end
	E.db.mMT.datatexts.teleports.favorites.enable = E.db.mMT.datatexts.teleports.favorites.a.id ~= "none"
		or E.db.mMT.datatexts.teleports.favorites.b.id ~= "none"
		or E.db.mMT.datatexts.teleports.favorites.c.id ~= "none"
		or E.db.mMT.datatexts.teleports.favorites.d.id ~= "none"
end

local function valuesFunction()
	mMT:UpdateTeleports()
	local icons = { none = L["None"] }
	for _, category in pairs(mMT.knownTeleports) do
		if type(category) == "table" and category.available then
			for id, t in pairs(category) do
				if type(t) == "table" then icons[id] = E:TextureString(t.icon, ":14:14") .. " " .. t.name end
			end
		end
	end
	return icons
end

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.TeleportIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.datatexts.args.teleports.args = {
		header_teleports = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Teleports"],
			args = {
				iconTexture = {
					order = 1,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.datatexts.teleports.icon
					end,
					set = function(info, value)
						E.db.mMT.datatexts.teleports.icon = value
						DT:ForceUpdate_DataText("mTeleports")
					end,
					values = function()
						local icons = {}
						icons.none = L["None"]
						for key, icon in pairs(mMT.Media.TeleportIcons) do
							icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
						end
						return icons
					end,
				},
				icon_teleports = {
					order = 2,
					type = "select",
					name = L["Icon"],
					get = function(info)
						return E.db.mMT.teleports.customicon
					end,
					set = function(info, value)
						E.db.mMT.teleports.customicon = value
						DT:ForceUpdate_DataText("mTeleports")
					end,
					values = icons,
				},
				text = {
					order = 3,
					name = L["white Text"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.teleports.whiteText
					end,
					set = function(info, value)
						E.db.mMT.teleports.whiteText = value
						DT:ForceUpdate_DataText("mTeleports")
					end,
				},
				favorites = {
					order = 4,
					type = "group",
					inline = true,
					name = L["Favorites"],
					args = {
						fav_a = {
							order = 1,
							type = "select",
							name = L["Slot"] .. " A",
							get = function(info)
								return E.db.mMT.datatexts.teleports.favorites.a and E.db.mMT.datatexts.teleports.favorites.a.id
							end,
							set = function(info, value)
								setFavorite("a", value)
							end,
							values = valuesFunction,
						},
						fav_b = {
							order = 2,
							type = "select",
							name = L["Slot"] .. " B",
							get = function(info)
								return E.db.mMT.datatexts.teleports.favorites.b and E.db.mMT.datatexts.teleports.favorites.b.id
							end,
							set = function(info, value)
								setFavorite("b", value)
							end,
							values = valuesFunction,
						},
						fav_c = {
							order = 3,
							type = "select",
							name = L["Slot"] .. " C",
							get = function(info)
								return E.db.mMT.datatexts.teleports.favorites.c and E.db.mMT.datatexts.teleports.favorites.c.id
							end,
							set = function(info, value)
								setFavorite("c", value)
							end,
							values = valuesFunction,
						},
						fav_d = {
							order = 4,
							type = "select",
							name = L["Slot"] .. " D",
							get = function(info)
								return E.db.mMT.datatexts.teleports.favorites.d and E.db.mMT.datatexts.teleports.favorites.d.id
							end,
							set = function(info, value)
								setFavorite("d", value)
							end,
							values = valuesFunction,
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
