local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert

local function configTable()
	local icons = {}

	for key, icon in pairs(mMT.Media.ChatIcons) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.general.args.chat.args = {
		header_chat = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Chat Button"],
			args = {
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.chat.enable
					end,
					set = function(info, value)
						E.db.mMT.chat.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_chaticon = {
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
						return not E.db.mMT.chat.enable
					end,
					get = function(info)
						return E.db.mMT.chat.texture
					end,
					set = function(info, value)
						E.db.mMT.chat.texture = value
                        mMT:mChatUpdateIcon()
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
						return E.db.mMT.chat.size
					end,
					set = function(info, value)
						E.db.mMT.chat.size = value
                        mMT:mChatUpdateIcon()
					end,
					disabled = function()
						return not E.db.mMT.chat.enable
					end,
				},
			},
		},
		header_chatcolornormal = {
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
						return E.db.mMT.chat.colormodenormal
					end,
					set = function(info, value)
						E.db.mMT.chat.colormodenormal = value
                        mMT:mChatUpdateIcon()
					end,
					disabled = function()
						return not E.db.mMT.chat.enable
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
						local t = E.db.mMT.chat.colornormal
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.chat.colornormal
						t.r, t.g, t.b, t.a = r, g, b, a
                        mMT:mChatUpdateIcon()
					end,
					disabled = function()
						return E.db.mMT.chat.colormodenormal == "class"
					end,
				},
			},
		},
		header_chatcolorhover = {
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
						return E.db.mMT.chat.colormodehover
					end,
					set = function(info, value)
						E.db.mMT.chat.colormodehover = value
                        mMT:mChatUpdateIcon()
					end,
					disabled = function()
						return not E.db.mMT.chat.enable
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
						local t = E.db.mMT.chat.colorhover
						return t.r, t.g, t.b, t.a
					end,
					set = function(info, r, g, b, a)
						local t = E.db.mMT.chat.colorhover
						t.r, t.g, t.b, t.a = r, g, b, a
                        mMT:mChatUpdateIcon()
					end,
					disabled = function()
						return E.db.mMT.chat.colormodehover == "class"
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
