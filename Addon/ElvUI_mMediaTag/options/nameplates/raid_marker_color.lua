local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local MARKERS = { "star", "circle", "diamond", "triangle", "moon", "square", "cross", "skull" }

local function Settings()
	return E.db.mMediaTag.nameplates.raid_marker_color
end

local function UpdateModule()
	mMT:UpdateModule("NP-RaidMarkerColor")
end

local function Disabled()
	return not Settings().enable
end

local markerArgs = {}
for index, key in ipairs(MARKERS) do
	local label = format("|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_%d:14:14|t %s", index, _G["RAID_TARGET_" .. index] or key)

	markerArgs[key] = {
		order = index * 2 - 1,
		type = "toggle",
		name = label,
		get = function()
			return Settings().markers[key]
		end,
		set = function(_, value)
			Settings().markers[key] = value
			UpdateModule()
		end,
	}

	markerArgs[key .. "_color"] = {
		order = index * 2,
		type = "color",
		name = L["Color"],
		hasAlpha = false,
		disabled = function()
			return Disabled() or not Settings().markers[key]
		end,
		get = function()
			local r, g, b = mMT:HexToRGB(E.db.mMediaTag.color.raid_markers[key])
			return r, g, b
		end,
		set = function(_, r, g, b)
			local hex = E:RGBToHex(r, g, b, "ff")
			E.db.mMediaTag.color.raid_markers[key] = hex
			MEDIA.color.raid_markers[key] = CreateColorFromHexString(hex)
			MEDIA.color.raid_markers[key].hex = hex
			UpdateModule()
		end,
	}

	markerArgs[key .. "_break"] = {
		order = index * 2 + 0.5,
		type = "description",
		name = "",
		width = "full",
	}
end

mMT.options.args.nameplates.args.markers.args.raid_marker_color.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return Settings().enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return Settings().enable
		end,
		set = function(_, value)
			Settings().enable = value
			UpdateModule()
		end,
	},
	text = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = L["Colors the health bar of nameplates with a raid marker in the color of that marker."],
	},
	settings = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Settings"],
		disabled = Disabled,
		args = {
			alpha = {
				order = 1,
				type = "range",
				name = L["Opacity"],
				min = 0.1,
				max = 1,
				step = 0.05,
				isPercent = true,
				get = function()
					return Settings().alpha
				end,
				set = function(_, value)
					Settings().alpha = value
					UpdateModule()
				end,
			},
		},
	},
	markers = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Raid Markers"],
		disabled = Disabled,
		args = markerArgs,
	},
}
