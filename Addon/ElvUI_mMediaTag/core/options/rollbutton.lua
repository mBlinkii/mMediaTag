local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.RollIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.general.args.roll.args = {
		header_roll = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Roll Button"],
			args = {
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.roll.enable
					end,
					set = function(info, value)
						E.db.mMT.roll.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_rollicon = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Icon"],
			args = {
				icon = {
					order = 4,
					type = "select",
					name = L["Icon"],
					disabled = function()
						return not E.db.mMT.roll.enable
					end,
					get = function(info)
						return E.db.mMT.roll.texture
					end,
					set = function(info, value)
						E.db.mMT.roll.texture = value
                        mMT:mRollUpdateIcon()
					end,
					values = icons,
				},
				growsize = {
					order = 5,
					name = L["Icon Size"],
					type = "range",
					min = 2,
					max = 128,
					step = 2,
					softMin = 2,
					softMax = 128,
					get = function(info)
						return E.db.mMT.roll.size
					end,
					set = function(info, value)
						E.db.mMT.roll.size = value
                        mMT:mRollUpdateIcon()
					end,
					disabled = function()
						return not E.db.mMT.roll.enable
					end,
				},
			},
		},
		header_rollcolornormal = {
			order = 6,
			type = "group",
			inline = true,
			name = L["Color Normal"],
			args = {
				colornormalmode = {
					order = 7,
					type = "select",
					name = L["Color Style"],
					get = function(info)
						return E.db.mMT.roll.colormodenormal
					end,
					set = function(info, value)
						E.db.mMT.roll.colormodenormal = value
                        mMT:mRollUpdateIcon()
					end,
					disabled = function()
						return not E.db.mMT.roll.enable
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				colornormal = {
					type = "color",
					order = 8,
					name = L["Custom color"],
					hasAlpha = true,
					get = function(info)
						local t = E.db.mMT.roll.colornormal
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.roll.colornormal
						t.r, t.g, t.b, t.a = r, g, b, a
                        mMT:mRollUpdateIcon()
					end,
					disabled = function()
						return E.db.mMT.roll.colormodenormal == "class"
					end,
				},
			},
		},
		header_rollcolorhover = {
			order = 9,
			type = "group",
			inline = true,
			name = L["Color Hover"],
			args = {
				colorhoverlmode = {
					order = 10,
					type = "select",
					name = L["Hover Color Style"],
					get = function(info)
						return E.db.mMT.roll.colormodehover
					end,
					set = function(info, value)
						E.db.mMT.roll.colormodehover = value
                        mMT:mRollUpdateIcon()
					end,
					disabled = function()
						return not E.db.mMT.roll.enable
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				colorhover = {
					type = "color",
					order = 11,
					name = L["Hover Custom Color"],
					hasAlpha = true,
					get = function(info)
						local t = E.db.mMT.roll.colorhover
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.roll.colorhover
						t.r, t.g, t.b, t.a = r, g, b, a
                        mMT:mRollUpdateIcon()
					end,
					disabled = function()
						return E.db.mMT.roll.colormodehover == "class"
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
