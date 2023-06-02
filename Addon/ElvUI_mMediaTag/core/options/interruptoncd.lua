local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.castbar.args.interrupt.args = {
		header_interruptoncd = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Interrupt on CD"],
			args = {
				toggle_interruptoncd = {
					order = 2,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable Interrupt on CD colors for Castbar"],
					get = function(info)
						return E.db.mMT.interruptoncd.enable
					end,
					set = function(info, value)
						E.db.mMT.interruptoncd.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				spacer1 = {
					order = 3,
					type = "description",
					name = "\n\n",
				},
				description = {
					order = 4,
					type = "description",
					name = L["Here you can set the color of the castbar when your own interrupt spell is on CD or will be ready."],
				},
			},
		},
		header_settings = {
			order = 5,
			type = "group",
			inline = true,
			name = L["Interrupt on CD Settings"],
			args = {
				gardient = {
					order = 6,
					type = "toggle",
					name = L["Gradient  Mode"],
					get = function(info)
						return E.db.mMT.interruptoncd.gradient
					end,
					set = function(info, value)
						E.db.mMT.interruptoncd.gradient = value
					end,
				},
				outofrange = {
					order = 6,
					type = "toggle",
					name = L["Cast is out of range"],
					desc = L["Changes the color of the castbar when the unit is out of range and interruptible."],
					get = function(info)
						return E.db.mMT.interruptoncd.outofrange
					end,
					set = function(info, value)
						E.db.mMT.interruptoncd.outofrange = value
					end,
				},
				inactivetime = {
					order = 7,
					name = L["Inactivetime"],
					desc = L["do not show when the interrupt spell is ready in X seconds."],
					type = "range",
					min = 0,
					max = 4,
					step = 0.1,
					get = function(info)
						return E.db.mMT.interruptoncd.inactivetime
					end,
					set = function(info, value)
						E.db.mMT.interruptoncd.inactivetime = value
					end,
				},
			},
		},
		header_colorintime = {
			order = 8,
			type = "group",
			inline = true,
			name = L["Interrupt in time color"],
			args = {
				color_intimea = {
					type = "color",
					order = 9,
					name = L["Color"] .. " 1",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.interruptoncd.intimecolor.colora
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.interruptoncd.intimecolor.colora
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_intimeb = {
					type = "color",
					order = 10,
					name = L["Color"] .. " 2",
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.interruptoncd.gradient
					end,
					get = function(info)
						local t = E.db.mMT.interruptoncd.intimecolor.colorb
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.interruptoncd.intimecolor.colorb
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
		header_coloroncd = {
			order = 11,
			type = "group",
			inline = true,
			name = L["Interrupt on cd color"],
			args = {

				color_oncda = {
					type = "color",
					order = 12,
					name = L["Color"] .. " 1",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.interruptoncd.oncdcolor.colora
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.interruptoncd.oncdcolor.colora
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_oncdb = {
					type = "color",
					order = 13,
					name = L["Color"] .. " 2",
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.interruptoncd.gradient
					end,
					get = function(info)
						local t = E.db.mMT.interruptoncd.oncdcolor.colorb
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.interruptoncd.oncdcolor.colorb
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
		header_coloroutofrange = {
			order = 14,
			type = "group",
			inline = true,
			name = L["Interrupt out of range color"],
			args = {

				color_outofrangea = {
					type = "color",
					order = 15,
					name = L["Color"] .. " 1",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.interruptoncd.outofrangecolor.colora
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.interruptoncd.outofrangecolor.colora
						t.r, t.g, t.b = r, g, b
					end,
				},
				color_outofrangeb = {
					type = "color",
					order = 16,
					name = L["Color"] .. " 2",
					hasAlpha = false,
					disabled = function()
						return not E.db.mMT.interruptoncd.gradient
					end,
					get = function(info)
						local t = E.db.mMT.interruptoncd.outofrangecolor.colorb
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.interruptoncd.outofrangecolor.colorb
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
		header_colorradymarker = {
			order = 17,
			type = "group",
			inline = true,
			name = L["Readymarker color"],
			args = {

				color_radymarker = {
					type = "color",
					order = 18,
					name = L["Color"],
					desc = L["Shows a marker on the castbar when the interrupt spell will be ready."],
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.interruptoncd.readymarkercolor
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.interruptoncd.readymarkercolor
						t.r, t.g, t.b = r, g, b
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
