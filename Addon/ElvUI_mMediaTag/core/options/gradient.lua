local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert

local function configTable()
	E.Options.args.mMT.args.cosmetic.args.gradient.args = {
		header_general = {
			order = 1,
			type = "group",
			inline = true,
			name = L["General"],
			args = {
				enable = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.gradient.enable
					end,
					set = function(info, value)
						E.db.mMT.gradient.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_settings = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Icon"],
			args = {
				perfixa = {
					order = 1,
					type = "select",
					name = L["Prefix A"],
					get = function(info)
						return E.db.mMT.gradient.color.a.prefix
					end,
					set = function(info, value)
						E.db.mMT.gradient.color.a.prefix = value
                        print(value)
                        mMT:mChatUpdateIcon()
					end,
					values = {
                        plus = "+ Addieren",
                        minus = "- Subtraieren",
                    },
				},
				a = {
					order = 2,
					name = L["A Multi"],
					type = "range",
					min = 0,
					max = 1,
					step = 0.01,
					get = function(info)
						return E.db.mMT.gradient.color.a.value
					end,
					set = function(info, value)
						E.db.mMT.gradient.color.a.value = value
                        mMT.Modules.test:Initialize()
                        E:StaticPopup_Show("CONFIG_RL")
					end,
				},
                perfixb = {
					order = 3,
					type = "select",
					name = L["Prefix B"],
					get = function(info)
						return E.db.mMT.gradient.color.b.prefix
					end,
					set = function(info, value)
						E.db.mMT.gradient.color.b.prefix = value
                        print(value, E.db.mMT.gradient.color.a.prefix, E.db.mMT.gradient.color.b.prefix)
                        mMT:mChatUpdateIcon()
					end,
					values = {
                        plus = "+ Addieren",
                        minus = "- Subtraieren",
                    },
				},
				b = {
					order = 4,
					name = L["B Multi"],
					type = "range",
					min = 0,
					max = 1,
					step = 0.01,
					get = function(info)
						return E.db.mMT.gradient.color.b.value
					end,
					set = function(info, value)
						E.db.mMT.gradient.color.b.value = value
                        mMT.Modules.test:Initialize()
                        E:StaticPopup_Show("CONFIG_RL")
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
