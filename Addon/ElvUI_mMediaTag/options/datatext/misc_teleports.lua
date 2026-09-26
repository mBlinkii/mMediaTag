local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local function setFavorite(slot, value)
	if value == "none" then
		E.db.mMediaTag.datatexts.teleports.favorites[slot] = { id = "none", kind = "none" }
	else
		for _, category in pairs(mMT.knownTeleports) do
			if type(category) == "table" then
				for id, t in pairs(category) do
					if id == value then
						E.db.mMediaTag.datatexts.teleports.favorites[slot] = { id = id, kind = t.kind }
						break
					end
				end
			end
		end
	end
	E.db.mMediaTag.datatexts.teleports.favorites.enable = E.db.mMediaTag.datatexts.teleports.favorites.a.id ~= "none"
		or E.db.mMediaTag.datatexts.teleports.favorites.b.id ~= "none"
		or E.db.mMediaTag.datatexts.teleports.favorites.c.id ~= "none"
		or E.db.mMediaTag.datatexts.teleports.favorites.d.id ~= "none"
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

mMT.options.args.datatexts.args.misc_teleports.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			iconTexture = {
				order = 1,
				type = "select",
				name = L["Icon"],
				get = function(info)
					return E.db.mMediaTag.datatexts.teleports.icon
				end,
				set = function(info, value)
					E.db.mMediaTag.datatexts.teleports.icon = value
					DT:ForceUpdate_DataText("mMT - Teleports")
				end,
				values = function()
					local icons = {}
					icons.none = L["None"]
					for key, icon in pairs(MEDIA.icons.datatexts.teleport) do
						icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
					end
					return icons
				end,
			},
		},
	},
	highlight = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Highlight"],
		args = {
			current = {
				order = 1,
				type = "toggle",
				name = L["Current Dungeon"],
				desc = L["Highlights the dungeon you are listed for, joined or currently in."],
				get = function(info)
					return E.db.mMediaTag.datatexts.teleports.highlight.current.enable
				end,
				set = function(info, value)
					E.db.mMediaTag.datatexts.teleports.highlight.current.enable = value
				end,
			},
			current_color = {
				order = 2,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMediaTag.datatexts.teleports.highlight.current.enable
				end,
				get = function()
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.datatexts.teleports.highlight.current.color)
					return r, g, b
				end,
				set = function(_, r, g, b)
					E.db.mMediaTag.datatexts.teleports.highlight.current.color = E:RGBToHex(r, g, b, "ff")
				end,
			},
			spacer = {
				order = 3,
				type = "description",
				name = "",
				width = "full",
			},
			keystone = {
				order = 4,
				type = "toggle",
				name = L["My Keystone"],
				desc = L["Highlights the dungeon of your own keystone."],
				get = function(info)
					return E.db.mMediaTag.datatexts.teleports.highlight.keystone.enable
				end,
				set = function(info, value)
					E.db.mMediaTag.datatexts.teleports.highlight.keystone.enable = value
				end,
			},
			keystone_color = {
				order = 5,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMediaTag.datatexts.teleports.highlight.keystone.enable
				end,
				get = function()
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.datatexts.teleports.highlight.keystone.color)
					return r, g, b
				end,
				set = function(_, r, g, b)
					E.db.mMediaTag.datatexts.teleports.highlight.keystone.color = E:RGBToHex(r, g, b, "ff")
				end,
			},
		},
	},
	favorites = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Favorites"],
		args = {
			fav_a = {
				order = 1,
				type = "select",
				name = L["Slot"] .. " A",
				get = function(info)
					return E.db.mMediaTag.datatexts.teleports.favorites.a and E.db.mMediaTag.datatexts.teleports.favorites.a.id
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
					return E.db.mMediaTag.datatexts.teleports.favorites.b and E.db.mMediaTag.datatexts.teleports.favorites.b.id
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
					return E.db.mMediaTag.datatexts.teleports.favorites.c and E.db.mMediaTag.datatexts.teleports.favorites.c.id
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
					return E.db.mMediaTag.datatexts.teleports.favorites.d and E.db.mMediaTag.datatexts.teleports.favorites.d.id
				end,
				set = function(info, value)
					setFavorite("d", value)
				end,
				values = valuesFunction,
			},
		},
	},
}
