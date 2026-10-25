local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local dispelUnits = {
	{ key = "player", name = L["Player"] },
	{ key = "target", name = L["Target"] },
	{ key = "focus", name = L["Focus"] },
	{ key = "targettarget", name = L["Target of Target"] },
	{ key = "pet", name = L["Pet"] },
	{ key = "party", name = L["Party"] },
	{ key = "raid1", name = L["Raid 1"] },
	{ key = "raid2", name = L["Raid 2"] },
	{ key = "raid3", name = L["Raid 3"] },
	{ key = "raidpet", name = L["Raid Pet"] },
	{ key = "tank", name = L["Tank"] },
	{ key = "assist", name = L["Assist"] },
}

-- vanilla has no focus frame
for i = #dispelUnits, 1, -1 do
	if dispelUnits[i].key == "focus" and not mMT.Supports.focus then table.remove(dispelUnits, i) end
end

local function IsDisabled()
	return not E.db.mMediaTag.dispel_icon.enable
end

local function Update()
	mMT:UpdateModule("DispelIcon")
end

local args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.dispel_icon.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.dispel_icon.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.dispel_icon.enable = value

			if value then
				Update()
			else
				E:StaticPopup_Show("CONFIG_RL")
			end
		end,
	},
	-- sits next to the reset button that options_core adds at toggle order + 0.1
	demo = {
		order = 1.15,
		type = "execute",
		name = function()
			local module = mMT:GetModule("DispelIcon")
			return (module and module.demoActive and MEDIA.color.green:WrapTextInColorCode(L["Demo"])) or L["Demo"]
		end,
		desc = L["Shows placeholder icons on every unitframe to set up the icons. Turns itself off when the options close."],
		disabled = IsDisabled,
		func = function()
			local module = mMT:GetModule("DispelIcon")
			if module then module:ToggleDemo() end
		end,
	},
}

local POINTS = {
	TOP = "TOP",
	BOTTOM = "BOTTOM",
	LEFT = "LEFT",
	RIGHT = "RIGHT",
	CENTER = L["CENTER"],
	TOPLEFT = "TOPLEFT",
	TOPRIGHT = "TOPRIGHT",
	BOTTOMLEFT = "BOTTOMLEFT",
	BOTTOMRIGHT = "BOTTOMRIGHT",
}

local SOURCES = { DISPELLABLE = L["Dispellable only"], ALL = L["All Types"] }
local TARGETS = { HEALTH = L["Health Bar"], FRAME = L["Unitframe"] }
local GLOWS = { NONE = L["None"], GLOW = L["Glow"], PIXEL = L["Pixel Glow"] }
local GROWTHS = { RIGHT = L["Right"], LEFT = L["Left"], UP = L["Up"], DOWN = L["Down"] }

-- a unitframe that is off in ElvUI cannot show icons
local function ElvUIDisabled(key)
	local elvui = E.db.unitframe.units[key]
	return not (E.private.unitframe.enable and elvui and elvui.enable)
end

local function UnitActive(key)
	return not IsDisabled() and not ElvUIDisabled(key) and E.db.mMediaTag.dispel_icon.units[key].enable
end

local function StateName(enabled)
	return enabled and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
end

local function Range(order, name, min, max, desc)
	return { order = order, type = "range", name = name, desc = desc, min = min, max = max, step = 1 }
end

-- a disabled group disables everything inside, so a toggle that unlocks a group sits next to it
local function Inline(order, name, children, disabled, hidden)
	return { order = order, type = "group", inline = true, name = name, disabled = disabled, hidden = hidden, args = children }
end

-- every option key is the name of its setting, the groups hand get and set down to their options
local function UnitGroup(unit, order)
	local key = unit.key

	local function Settings()
		return E.db.mMediaTag.dispel_icon.units[key]
	end

	local function Highlight()
		return Settings().highlight
	end

	local function Accessors(source)
		return function(info)
			return source()[info[#info]]
		end, function(info, value)
			source()[info[#info]] = value
			Update()
		end
	end

	local unitGet, unitSet = Accessors(Settings)
	local highlightGet, highlightSet = Accessors(Highlight)

	-- the settings only matter for frame types that are switched on
	local function UnitDisabled()
		return not UnitActive(key)
	end

	local function HighlightDisabled()
		return UnitDisabled() or not Highlight().enable
	end

	local function GlowDisabled()
		return HighlightDisabled() or Highlight().glow == "NONE"
	end

	local highlight = Inline(5, L["Frame Highlight"], {
		enable = {
			order = 1,
			type = "toggle",
			name = function()
				return StateName(Highlight().enable)
			end,
			desc = L["Colors the border or adds a glow in the color of the debuff type the icons show."],
		},
		target = { order = 2, type = "select", name = L["Target"], values = TARGETS, disabled = HighlightDisabled },
		border = { order = 3, type = "toggle", name = L["Border"], disabled = HighlightDisabled },
		glow_settings = Inline(4, L["Glow"], {
			glow = { order = 1, type = "select", name = L["Glow"], values = GLOWS },
			glowDebuffColor = {
				order = 2,
				type = "toggle",
				name = L["Use Debuff Color"],
				desc = L["Lets the glow follow the color of the debuff type instead of its own color."],
				disabled = GlowDisabled,
			},
			glowColor = {
				order = 3,
				type = "color",
				name = L["Glow Color"],
				disabled = function()
					return GlowDisabled() or Highlight().glowDebuffColor
				end,
				get = function(info)
					local color = Highlight().glowColor
					return color.r, color.g, color.b
				end,
				set = function(info, r, g, b)
					local color = Highlight().glowColor
					color.r, color.g, color.b = r, g, b
					Update()
				end,
			},
		}, HighlightDisabled),
		-- only there while the pixel glow is picked
		pixel_settings = Inline(
			5,
			L["Pixel Glow"],
			{
				pixelSize = Range(1, L["Thickness"], 1, 6),
				pixelLines = Range(2, L["Lines"], 2, 12),
				pixelSpeed = Range(3, L["Speed"], 1, 10),
			},
			HighlightDisabled,
			function()
				return Highlight().glow ~= "PIXEL"
			end
		),
	}, UnitDisabled)
	highlight.get, highlight.set = highlightGet, highlightSet

	return {
		order = order,
		type = "group",
		-- green tabs are the frame types that show icons
		name = function()
			return (UnitActive(key) and MEDIA.color.green or MEDIA.color.gray):WrapTextInColorCode(unit.name)
		end,
		disabled = IsDisabled,
		get = unitGet,
		set = unitSet,
		args = {
			elvui_disabled = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = MEDIA.color.red:WrapTextInColorCode(L["This unitframe is disabled in ElvUI."]),
				hidden = function()
					return not ElvUIDisabled(key)
				end,
			},
			enable = {
				order = 2,
				type = "toggle",
				name = function()
					return StateName(Settings().enable)
				end,
				disabled = function()
					return IsDisabled() or ElvUIDisabled(key)
				end,
			},
			icons = Inline(3, L["Icons"], {
				source = { order = 1, type = "select", name = L["Show"], values = SOURCES },
				count = Range(2, L["Count"], 1, 8),
				size = Range(3, L["Size"], 8, 64),
				spacing = Range(4, L["Spacing"], 0, 20),
				growth = { order = 5, type = "select", name = L["Growth Direction"], values = GROWTHS },
			}, UnitDisabled),
			position = Inline(4, L["Position"], {
				point = { order = 1, type = "select", name = L["Anchor Point"], values = POINTS },
				x = Range(2, L["X offset"], -100, 100, L["Sets the offset according to the anchor."]),
				y = Range(3, L["Y offset"], -100, 100, L["Sets the offset according to the anchor."]),
			}, UnitDisabled),
			highlight = highlight,
		},
	}
end

for index, unit in ipairs(dispelUnits) do
	args[unit.key] = UnitGroup(unit, index + 2)
end

mMT.options.args.unitframes.args.dispel_icon.args = args
