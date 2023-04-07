local function mCastbarOptions()
	E.Options.args.mMediaTag.args.cosmetic.args.castbar.args = {
		cosmetics = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable Interrupt on CD colors for Castbars"],
			get = function(info)
				return E.db[mPlugin].mCastbar.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mCastbar.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		spacer = {
			order = 2,
			type = "description",
			name = "\n\n",
		},
		description = {
			order = 3,
			type = "description",
			name = L["Here you can set the color of the castbar when the own kick is on CD."],
		},
		spacer2 = {
			order = 4,
			type = "description",
			name = "\n\n",
		},
		gardient = {
			order = 5,
			type = "toggle",
			name = L["Gradient  Mode"],
			get = function(info)
				return E.db[mPlugin].mCastbar.gardient
			end,
			set = function(info, value)
				E.db[mPlugin].mCastbar.gardient = value
			end,
		},
		inactivetime = {
			order = 6,
			name = L["Inactivetime"],
			desc = L["do not show when the interrupt cast is ready in x seconds"],
			type = "range",
			min = 0,
			max = 4,
			step = 0.1,
			get = function(info)
				return E.db[mPlugin].mCastbar.inactivetime
			end,
			set = function(info, value)
				E.db[mPlugin].mCastbar.inactivetime = value
			end,
		},
		spacer4 = {
			order = 7,
			type = "description",
			name = "\n\n",
		},
		colorkickcd = {
			type = "color",
			order = 11,
			name = L["Interrupt on CD"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.kickcd
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.kickcd
				t.r, t.g, t.b = r, g, b
			end,
		},
		colorkickcdb = {
			type = "color",
			order = 13,
			name = L["Gradient color"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.kickcdb
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.kickcdb
				t.r, t.g, t.b = r, g, b
			end,
		},
		spacer3 = {
			order = 14,
			type = "description",
			name = "\n\n",
		},
		colorInterruptinTime = {
			type = "color",
			order = 15,
			name = L["Kick ready in Time"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.kickintime
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.kickintime
				t.r, t.g, t.b = r, g, b
			end,
		},
		colorInterruptinTimeb = {
			type = "color",
			order = 16,
			name = L["Gradient color"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.kickintimeb
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.kickintimeb
				t.r, t.g, t.b = r, g, b
			end,
		},
		spacer5 = {
			order = 20,
			type = "description",
			name = "\n\n",
		},
		marker = {
			type = "color",
			order = 21,
			name = L["Readymarker"],
			hasAlpha = false,
			get = function(info)
				local t = E.db[mPlugin].mCastbar.readymarker
				return t.r, t.g, t.b
			end,
			set = function(info, r, g, b)
				local t = E.db[mPlugin].mCastbar.readymarker
				t.r, t.g, t.b = r, g, b
			end,
		},
	}
end

--mInsert(ns.Config, mCastbarOptions)
