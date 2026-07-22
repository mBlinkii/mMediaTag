local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local NP = E:GetModule("NamePlates")

local function UpdateModule()
	mMT:UpdateModule("NP-ExecuteMarker")
	NP:ConfigureAll()
end

mMT.options.args.nameplates.args.execute_marker.args = {
	text = {
		order = 1,
		type = "description",
		fontSize = "medium",
		name = L["Shows a marker on enemy nameplates at the execute threshold of your spec. Because of the Midnight API restrictions the marker is hidden via clipping once the unit drops below the threshold, health values are never read."],
	},
	enable = {
		order = 2,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.nameplates.execute.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.nameplates.execute.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.nameplates.execute.enable = value
			UpdateModule()
		end,
	},
	settings = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Settings"],
		disabled = function()
			return not E.db.mMediaTag.nameplates.execute.enable
		end,
		args = {
			auto = {
				order = 1,
				type = "toggle",
				name = L["Automatic range"],
				desc = L["Determines the execute range automatically based on your class, spec and talents."],
				get = function(info)
					return E.db.mMediaTag.nameplates.execute.auto
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.execute.auto = value
					UpdateModule()
				end,
			},
			range = {
				order = 2,
				type = "range",
				name = L["Execute range"],
				min = 1,
				max = 99,
				step = 1,
				disabled = function()
					return E.db.mMediaTag.nameplates.execute.auto
				end,
				get = function(info)
					return E.db.mMediaTag.nameplates.execute.range
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.execute.range = value
					UpdateModule()
				end,
			},
			onlyCombat = {
				order = 3,
				type = "toggle",
				name = L["Only in combat"],
				get = function(info)
					return E.db.mMediaTag.nameplates.execute.onlyCombat
				end,
				set = function(info, value)
					E.db.mMediaTag.nameplates.execute.onlyCombat = value
					UpdateModule()
				end,
			},
			color = {
				order = 4,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.nameplates.execute_color)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMediaTag.color.nameplates.execute_color = hex
					MEDIA.color.nameplates.execute_color = CreateColorFromHexString(hex)
					MEDIA.color.nameplates.execute_color.hex = hex
					UpdateModule()
				end,
			},
		},
	},
}
