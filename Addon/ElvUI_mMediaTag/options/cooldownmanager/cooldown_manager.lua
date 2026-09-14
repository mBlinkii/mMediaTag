local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local tremove = table.remove
local format = format

local FONT_FLAGS = {
	NONE = "None",
	OUTLINE = "Outline",
	THICKOUTLINE = "Thick",
	SHADOW = "|cff888888Shadow|r",
	SHADOWOUTLINE = "|cff888888Shadow|r Outline",
	SHADOWTHICKOUTLINE = "|cff888888Shadow|r Thick",
	MONOCHROME = "|cFFAAAAAAMono|r",
	MONOCHROMEOUTLINE = "|cFFAAAAAAMono|r Outline",
	MONOCHROMETHICKOUTLINE = "|cFFAAAAAAMono|r Thick",
}

local POSITIONS = {
	CENTER = L["Center"],
	TOP = L["Top"],
	BOTTOM = L["Bottom"],
	LEFT = L["Left"],
	RIGHT = L["Right"],
	TOPLEFT = L["Top Left"],
	TOPRIGHT = L["Top Right"],
	BOTTOMLEFT = L["Bottom Left"],
	BOTTOMRIGHT = L["Bottom Right"],
}

local VISIBILITY = {
	ALWAYS = L["Always"],
	INCOMBAT = L["In Combat"],
	INPARTY = L["In Group"],
	FADER = L["Player Fader"],
	HIDDEN = L["Hidden"],
}

local GLOW_TYPES = { pixel = "Pixel", autocast = "Autocast", button = "Button", proc = "Proc" }

local function CDM()
	return E.db.mMediaTag.cooldown_manager
end

local function VDB(key)
	return E.db.mMediaTag.cooldown_manager.viewers[key]
end

local function Refresh()
	mMT:UpdateModule("CooldownManager")
end

local function Disabled()
	return not CDM().enable
end

local function Module()
	return mMT:GetModule("CooldownManager")
end

local function ViewerGeneral(key, order)
	return {
		order = order,
		type = "group",
		name = L["Settings"],
		inline = true,
		disabled = Disabled,
		args = {
			manage = {
				order = 1,
				type = "toggle",
				name = function()
					return VDB(key).manage and MEDIA.color.green:WrapTextInColorCode(L["Managed"]) or MEDIA.color.red:WrapTextInColorCode(L["Not Managed"])
				end,
				desc = L["Move this viewer into an mMT container. Turn it off to leave it to Blizzard and ElvUI."],
				get = function()
					return VDB(key).manage
				end,
				set = function(_, value)
					VDB(key).manage = value
					E:StaticPopup_Show("CONFIG_RL")
				end,
			},
			alpha = {
				order = 2,
				type = "range",
				name = L["Opacity"],
				min = 0.1,
				max = 1,
				step = 0.05,
				isPercent = true,
				disabled = function()
					return Disabled() or not VDB(key).manage
				end,
				get = function()
					return VDB(key).alpha
				end,
				set = function(_, value)
					VDB(key).alpha = value
					local module = Module()
					if module then module:UpdateVisibility() end
				end,
			},
		},
	}
end

local function TextGroup(name, order, key, field, hidden, disabled, toggle)
	local function text()
		return VDB(key)[field]
	end

	local group = {
		order = order,
		type = "group",
		name = name,
		inline = true,
		hidden = hidden,
		disabled = disabled or Disabled,
		args = {
			size = {
				order = 2,
				type = "range",
				name = L["Font size"],
				min = 6,
				max = 36,
				step = 1,
				get = function()
					return text().size
				end,
				set = function(_, value)
					text().size = value
					Refresh()
				end,
			},
			class_color = {
				order = 4,
				type = "toggle",
				name = L["Class Color"],
				get = function()
					return text().class_color
				end,
				set = function(_, value)
					text().class_color = value
					Refresh()
				end,
			},
			color = {
				order = 5,
				type = "color",
				name = L["Color"],
				disabled = function()
					return (disabled or Disabled)() or text().class_color
				end,
				get = function()
					local color = text().color
					return color.r, color.g, color.b
				end,
				set = function(_, r, g, b)
					local color = text().color
					color.r, color.g, color.b = r, g, b
					Refresh()
				end,
			},
			position = {
				order = 6,
				type = "select",
				name = L["Position"],
				values = POSITIONS,
				get = function()
					return text().position
				end,
				set = function(_, value)
					text().position = value
					Refresh()
				end,
			},
			x = {
				order = 7,
				type = "range",
				name = L["X-Offset"],
				min = -45,
				max = 45,
				step = 1,
				get = function()
					return text().x
				end,
				set = function(_, value)
					text().x = value
					Refresh()
				end,
			},
			y = {
				order = 8,
				type = "range",
				name = L["Y-Offset"],
				min = -45,
				max = 45,
				step = 1,
				get = function()
					return text().y
				end,
				set = function(_, value)
					text().y = value
					Refresh()
				end,
			},
		},
	}

	if toggle then
		local function off()
			return (disabled or Disabled)() or not VDB(key)[toggle]
		end

		for _, option in pairs(group.args) do
			option.disabled = off
		end

		group.args.color.disabled = function()
			return off() or text().class_color
		end

		group.args.enable = {
			order = 0,
			type = "toggle",
			name = function()
				return VDB(key)[toggle] and MEDIA.color.green:WrapTextInColorCode(L["Show"]) or MEDIA.color.red:WrapTextInColorCode(L["Hide"])
			end,
			disabled = Disabled,
			get = function()
				return VDB(key)[toggle]
			end,
			set = function(_, value)
				VDB(key)[toggle] = value
				Refresh()
			end,
		}
	end

	return group
end

local function IconLayout(key, order)
	return {
		order = order,
		type = "group",
		name = L["Layout"],
		inline = true,
		disabled = Disabled,
		args = {
			keep_ratio = {
				order = 1,
				type = "toggle",
				name = L["Keep Size Ratio"],
				get = function()
					return VDB(key).keep_ratio
				end,
				set = function(_, value)
					VDB(key).keep_ratio = value
					Refresh()
				end,
			},
			width = {
				order = 2,
				type = "range",
				name = function()
					return VDB(key).keep_ratio and L["Icon Size"] or L["Icon Width"]
				end,
				min = 16,
				max = 80,
				step = 1,
				get = function()
					return VDB(key).width
				end,
				set = function(_, value)
					VDB(key).width = value
					Refresh()
				end,
			},
			height = {
				order = 3,
				type = "range",
				name = L["Icon Height"],
				min = 16,
				max = 80,
				step = 1,
				hidden = function()
					return VDB(key).keep_ratio
				end,
				get = function()
					return VDB(key).height
				end,
				set = function(_, value)
					VDB(key).height = value
					Refresh()
				end,
			},
			spacing = {
				order = 5,
				type = "range",
				name = L["Spacing"],
				min = 0,
				max = 20,
				step = 1,
				get = function()
					return VDB(key).spacing
				end,
				set = function(_, value)
					VDB(key).spacing = value
					Refresh()
				end,
			},
			per_row = {
				order = 6,
				type = "range",
				name = L["Icons Per Row"],
				min = 1,
				max = 20,
				step = 1,
				get = function()
					return VDB(key).per_row
				end,
				set = function(_, value)
					VDB(key).per_row = value
					Refresh()
				end,
			},
			growth = {
				order = 7,
				type = "select",
				name = L["Vertical Growth"],
				values = { DOWN = L["Down"], UP = L["Up"] },
				get = function()
					return VDB(key).growth
				end,
				set = function(_, value)
					VDB(key).growth = value
					Refresh()
				end,
			},
		},
	}
end

local function Visibility(key, order, keybind, auraOptions)
	local args = {
		visibility = {
			order = 1,
			type = "select",
			name = L["When to Show"],
			values = VISIBILITY,
			get = function()
				return VDB(key).visibility
			end,
			set = function(_, value)
				VDB(key).visibility = value
				local module = Module()
				if module then module:UpdateVisibility() end
			end,
		},
		hide_delay = {
			order = 8,
			type = "range",
			name = L["Hide Delay"],
			desc = L["How long the display stays up after its condition falls away."],
			min = 0,
			max = 30,
			step = 0.5,
			get = function()
				return VDB(key).hide_delay
			end,
			set = function(_, value)
				VDB(key).hide_delay = value
				Refresh()
			end,
		},
		fade_time = {
			order = 9,
			type = "range",
			name = L["Fade Time"],
			desc = L["How long fading in and out takes. Zero switches instantly."],
			min = 0,
			max = 2,
			step = 0.05,
			get = function()
				return VDB(key).fade_time
			end,
			set = function(_, value)
				VDB(key).fade_time = value
				Refresh()
			end,
		},
	}

	if keybind then
		args.keybind = {
			order = 3,
			type = "toggle",
			name = L["Show Keybind"],
			get = function()
				return VDB(key).keybind
			end,
			set = function(_, value)
				VDB(key).keybind = value
				Refresh()
			end,
		}
	end

	if auraOptions then
		args.debuff_border = {
			order = 4,
			type = "toggle",
			name = L["Debuff Border"],
			desc = L["Keeps Blizzards colored border on harmful auras."],
			get = function()
				return VDB(key).debuff_border
			end,
			set = function(_, value)
				VDB(key).debuff_border = value
				Refresh()
			end,
		}
	end

	return { order = order, type = "group", name = L["Visibility"], inline = true, disabled = Disabled, args = args }
end

local function GlowGroup(key, order, field, name, hidden)
	field = field or "glow"

	local function glow()
		return VDB(key)[field]
	end

	local function glowDisabled()
		return Disabled() or (field == "glow" and not glow().enable)
	end

	local function typeHidden(style)
		return function()
			return glow().type ~= style
		end
	end

	local group = {
		order = order,
		type = "group",
		name = name or L["Proc Glow"],
		inline = true,
		hidden = hidden,
		disabled = Disabled,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				hidden = field ~= "glow",
				name = function()
					return glow().enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function()
					return glow().enable
				end,
				set = function(_, value)
					glow().enable = value
					Refresh()
				end,
			},
			type = {
				order = 2,
				type = "select",
				name = L["Type"],
				values = GLOW_TYPES,
				disabled = glowDisabled,
				get = function()
					return glow().type
				end,
				set = function(_, value)
					glow().type = value
					Refresh()
				end,
			},
			color = {
				order = 3,
				type = "color",
				hasAlpha = true,
				name = L["Color"],
				disabled = glowDisabled,
				get = function()
					local color = glow().color
					return color.r, color.g, color.b, color.a
				end,
				set = function(_, r, g, b, a)
					local color = glow().color
					color.r, color.g, color.b, color.a = r, g, b, a
					Refresh()
				end,
			},
			speed = {
				order = 4,
				type = "range",
				name = L["Speed"],
				min = 0.05,
				max = 2,
				step = 0.05,
				disabled = glowDisabled,
				get = function()
					return glow().speed
				end,
				set = function(_, value)
					glow().speed = value
					Refresh()
				end,
			},
			lines = {
				order = 5,
				type = "range",
				name = L["Lines"],
				min = 1,
				max = 20,
				step = 1,
				disabled = glowDisabled,
				hidden = typeHidden("pixel"),
				get = function()
					return glow().lines
				end,
				set = function(_, value)
					glow().lines = value
					Refresh()
				end,
			},
			thickness = {
				order = 6,
				type = "range",
				name = L["Thickness"],
				min = 1,
				max = 8,
				step = 1,
				disabled = glowDisabled,
				hidden = typeHidden("pixel"),
				get = function()
					return glow().thickness
				end,
				set = function(_, value)
					glow().thickness = value
					Refresh()
				end,
			},
			particles = {
				order = 7,
				type = "range",
				name = L["Particles"],
				min = 1,
				max = 16,
				step = 1,
				disabled = glowDisabled,
				hidden = typeHidden("autocast"),
				get = function()
					return glow().particles
				end,
				set = function(_, value)
					glow().particles = value
					Refresh()
				end,
			},
			scale = {
				order = 8,
				type = "range",
				name = L["Scale"],
				min = 0.5,
				max = 3,
				step = 0.1,
				disabled = glowDisabled,
				hidden = typeHidden("autocast"),
				get = function()
					return glow().scale
				end,
				set = function(_, value)
					glow().scale = value
					Refresh()
				end,
			},
		},
	}

	return group
end

local function PandemicGroup(key, order)
	return {
		order = order,
		type = "group",
		name = L["Pandemic"],
		inline = true,
		disabled = Disabled,
		args = {
			pandemic = {
				order = 1,
				type = "select",
				name = L["Style"],
				desc = L["What to show while the aura is inside its refresh window."],
				values = { blizzard = L["Blizzard"], glow = L["Glow"], none = L["None"] },
				sorting = { "blizzard", "glow", "none" },
				get = function()
					local style = VDB(key).pandemic
					if style == true then return "blizzard" end
					if style == false then return "none" end
					return style
				end,
				set = function(_, value)
					VDB(key).pandemic = value
					Refresh()
				end,
			},
			pandemic_color = {
				order = 2,
				type = "color",
				name = L["Color"],
				hidden = function()
					return VDB(key).pandemic ~= "blizzard" and VDB(key).pandemic ~= true
				end,
				get = function()
					local color = VDB(key).pandemic_color
					return color.r, color.g, color.b
				end,
				set = function(_, r, g, b)
					local color = VDB(key).pandemic_color
					color.r, color.g, color.b = r, g, b
					Refresh()
				end,
			},
		},
	}
end

local COPY_SECTIONS = { layout = L["Layout"], visibility = L["Visibility"], text = L["Texts"], glow = L["Glow"], color = L["Colors"] }

local copyState = {}

local function CopyState(key)
	local state = copyState[key]
	if not state then
		state = { sections = { layout = true, visibility = true, text = true, glow = true, color = true } }
		copyState[key] = state
	end

	return state
end

local function CopySources(key)
	local module = Module()
	local values = {}
	if not module then return values end

	for other, info in pairs(module.VIEWERS) do
		if other ~= key then values[other] = info.label end
	end

	return values
end

local function CopyGroup(key, order)
	return {
		order = order,
		type = "group",
		name = L["Copy Settings"],
		inline = true,
		disabled = Disabled,
		args = {
			source = {
				order = 1,
				type = "select",
				name = L["Copy From"],
				desc = L["Only settings this display knows are taken over, everything else stays untouched."],
				values = function()
					return CopySources(key)
				end,
				get = function()
					return CopyState(key).source
				end,
				set = function(_, value)
					CopyState(key).source = value
				end,
			},
			sections = {
				order = 2,
				type = "multiselect",
				name = L["Sections"],
				values = COPY_SECTIONS,
				get = function(_, section)
					return CopyState(key).sections[section]
				end,
				set = function(_, section, value)
					CopyState(key).sections[section] = value or nil
				end,
			},
			apply = {
				order = 3,
				type = "execute",
				name = L["Copy"],
				disabled = function()
					return Disabled() or not CopyState(key).source
				end,
				func = function()
					local module = Module()
					local state = CopyState(key)
					if not module or not state.source then return end

					local copied = module:CopyViewerSettings(state.source, key, state.sections)
					mMT:Print(format(L["Took over %d settings from %s."], copied, module.VIEWERS[state.source].label))
					Refresh()
				end,
			},
		},
	}
end

local function IconViewer(key, withKeybind)
	local args = {
		general = ViewerGeneral(key, 1),
		layout = IconLayout(key, 2),
		visibility = Visibility(key, 3, withKeybind, not withKeybind),
		cooldown_text = TextGroup(L["Cooldown Text"], 4, key, "cooldown_text"),
		count_text = TextGroup(L["Count Text"], 5, key, "count_text"),
		copy = CopyGroup(key, 20),
	}

	if not withKeybind then
		args.pandemic = PandemicGroup(key, 3.5)
		args.pandemic_glow = GlowGroup(key, 3.6, "pandemic_glow", L["Pandemic Glow"], function()
			return VDB(key).pandemic ~= "glow"
		end)
	end

	if withKeybind then
		args.keybind_text = TextGroup(L["Keybind Text"], 6, key, "keybind_text", function()
			return not VDB(key).keybind
		end)
		args.glow = GlowGroup(key, 7)
	end

	return args
end

mMT.options.args.cooldownmanager.args.general.args = {
	description = {
		order = 1,
		type = "description",
		fontSize = "medium",
		name = L["Moves Blizzards cooldown manager icons into mMT containers with own movers and text settings. Blizzards cooldown manager has to be enabled under Options > Gameplay Enhancements."],
	},
	enable = {
		order = 2,
		type = "toggle",
		name = function()
			return CDM().enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function()
			return CDM().enable
		end,
		set = function(_, value)
			CDM().enable = value
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	demo = {
		order = 3,
		type = "execute",
		name = function()
			local module = Module()
			return (module and module.demoActive and MEDIA.color.green:WrapTextInColorCode(L["Demo"])) or L["Demo"]
		end,
		desc = L["Fills every managed viewer with placeholder icons and bars that follow your settings live. Turns itself off when the options close."],
		disabled = Disabled,
		func = function()
			local module = Module()
			if module then module:ToggleDemo() end
		end,
	},
	font = {
		order = 4,
		type = "select",
		dialogControl = "LSM30_Font",
		name = L["Font"],
		values = LSM:HashTable("font"),
		disabled = Disabled,
		get = function()
			return CDM().font
		end,
		set = function(_, value)
			CDM().font = value
			Refresh()
		end,
	},
	font_flag = {
		order = 5,
		type = "select",
		name = L["Font contour"],
		values = FONT_FLAGS,
		disabled = Disabled,
		get = function()
			return CDM().font_flag
		end,
		set = function(_, value)
			CDM().font_flag = value
			Refresh()
		end,
	},
	hide_swipe = {
		order = 6,
		type = "toggle",
		name = L["Hide GCD Swipe"],
		disabled = Disabled,
		get = function()
			return CDM().hide_swipe
		end,
		set = function(_, value)
			CDM().hide_swipe = value
			Refresh()
		end,
	},
}

mMT.options.args.cooldownmanager.args.essential.args = IconViewer("essential", true)
mMT.options.args.cooldownmanager.args.utility.args = IconViewer("utility", true)
mMT.options.args.cooldownmanager.args.buff_icon.args = IconViewer("buff_icon", false)

mMT.options.args.cooldownmanager.args.buff_bar.args = {
	general = ViewerGeneral("buff_bar", 1),
	layout = {
		order = 2,
		type = "group",
		name = L["Layout"],
		inline = true,
		disabled = Disabled,
		args = {
			width = {
				order = 1,
				type = "range",
				name = L["Bar Width"],
				min = 80,
				max = 400,
				step = 1,
				get = function()
					return VDB("buff_bar").width
				end,
				set = function(_, value)
					VDB("buff_bar").width = value
					Refresh()
				end,
			},
			height = {
				order = 2,
				type = "range",
				name = L["Bar Height"],
				min = 10,
				max = 40,
				step = 1,
				get = function()
					return VDB("buff_bar").height
				end,
				set = function(_, value)
					VDB("buff_bar").height = value
					Refresh()
				end,
			},
			spacing = {
				order = 3,
				type = "range",
				name = L["Spacing"],
				min = 0,
				max = 20,
				step = 1,
				get = function()
					return VDB("buff_bar").spacing
				end,
				set = function(_, value)
					VDB("buff_bar").spacing = value
					Refresh()
				end,
			},
			icon = {
				order = 4,
				type = "toggle",
				name = L["Show Icon"],
				get = function()
					return VDB("buff_bar").icon
				end,
				set = function(_, value)
					VDB("buff_bar").icon = value
					Refresh()
				end,
			},
			icon_gap = {
				order = 5,
				type = "range",
				name = L["Icon Gap"],
				min = 0,
				max = 10,
				step = 1,
				disabled = function()
					return Disabled() or not VDB("buff_bar").icon
				end,
				get = function()
					return VDB("buff_bar").icon_gap
				end,
				set = function(_, value)
					VDB("buff_bar").icon_gap = value
					Refresh()
				end,
			},
			mirrored = {
				order = 7,
				type = "toggle",
				name = L["Mirrored Columns"],
				get = function()
					return VDB("buff_bar").mirrored
				end,
				set = function(_, value)
					VDB("buff_bar").mirrored = value
					Refresh()
				end,
			},
			column_gap = {
				order = 8,
				type = "range",
				name = L["Column Gap"],
				min = 0,
				max = 20,
				step = 1,
				disabled = function()
					return Disabled() or not VDB("buff_bar").mirrored
				end,
				get = function()
					return VDB("buff_bar").column_gap
				end,
				set = function(_, value)
					VDB("buff_bar").column_gap = value
					Refresh()
				end,
			},
			growth = {
				order = 9,
				type = "select",
				name = L["Vertical Growth"],
				values = { DOWN = L["Down"], UP = L["Up"] },
				get = function()
					return VDB("buff_bar").growth
				end,
				set = function(_, value)
					VDB("buff_bar").growth = value
					Refresh()
				end,
			},
		},
	},
	visibility = Visibility("buff_bar", 3, false, true),
	pandemic = PandemicGroup("buff_bar", 3.5),
	pandemic_glow = GlowGroup("buff_bar", 3.6, "pandemic_glow", L["Pandemic Glow"], function()
		return VDB("buff_bar").pandemic ~= "glow"
	end),
	colors = {
		order = 4,
		type = "group",
		name = L["Colors"],
		inline = true,
		disabled = Disabled,
		args = {
			texture = {
				order = 0,
				type = "select",
				dialogControl = "LSM30_Statusbar",
				name = L["Texture"],
				values = LSM:HashTable("statusbar"),
				get = function()
					return VDB("buff_bar").texture
				end,
				set = function(_, value)
					VDB("buff_bar").texture = value
					Refresh()
				end,
			},
			class_color = {
				order = 1,
				type = "toggle",
				name = L["Class Color"],
				get = function()
					return VDB("buff_bar").class_color
				end,
				set = function(_, value)
					VDB("buff_bar").class_color = value
					Refresh()
				end,
			},
			color = {
				order = 2,
				type = "color",
				name = L["Bar Color"],
				disabled = function()
					return Disabled() or VDB("buff_bar").class_color
				end,
				get = function()
					local color = VDB("buff_bar").color
					return color.r, color.g, color.b
				end,
				set = function(_, r, g, b)
					local color = VDB("buff_bar").color
					color.r, color.g, color.b = r, g, b
					Refresh()
				end,
			},
			background_color = {
				order = 3,
				type = "color",
				hasAlpha = true,
				name = L["Background Color"],
				get = function()
					local color = VDB("buff_bar").background_color
					return color.r, color.g, color.b, color.a
				end,
				set = function(_, r, g, b, a)
					local color = VDB("buff_bar").background_color
					color.r, color.g, color.b, color.a = r, g, b, a
					Refresh()
				end,
			},
			note = {
				order = 4,
				type = "description",
				name = L["A single aura can override this with a right click in Blizzards cooldown manager."],
			},
		},
	},
	name_text = TextGroup(L["Name Text"], 6, "buff_bar", "name_text", nil, nil, "name"),
	duration_text = TextGroup(L["Duration Text"], 7, "buff_bar", "duration_text", nil, nil, "timer"),
	stacks_text = TextGroup(L["Stacks Text"], 8, "buff_bar", "stacks_text", nil, nil, "stacks"),
	copy = CopyGroup("buff_bar", 20),
}

local function CustomDisabled()
	return Disabled() or not VDB("custom").enable
end

local ENTRY_TYPES = { spell = L["Spell"], item = L["Item"], slot = L["Equipment Slot"] }

local entryState = { type = "spell", slot = 13 }

local function Entries()
	local vdb = VDB("custom")
	if not vdb.entries then vdb.entries = {} end

	return vdb.entries
end

local function EntryValues()
	local module = Module()
	local values = {}
	if not module then return values end

	for index, entry in ipairs(Entries()) do
		local name, texture = module:CustomEntryInfo(entry)
		local icon = (texture and format("|T%s:14|t ", texture)) or ""
		values[index] = format("%d. %s%s", index, icon, name or format("%s %s", ENTRY_TYPES[entry.type] or "?", entry.id or "?"))
	end

	return values
end

local function SlotValues()
	local module = Module()
	local values = {}
	if not module then return values end

	for _, slot in ipairs(module.EQUIPMENT_SLOTS) do
		values[slot.id] = slot.label
	end

	return values
end

local function MoveEntry(step)
	local entries = Entries()
	local from = entryState.selected
	local to = from and from + step
	if not from or not entries[from] or not entries[to] then return end

	entries[from], entries[to] = entries[to], entries[from]
	entryState.selected = to
	Refresh()
end

local function EntriesGroup(order)
	return {
		order = order,
		type = "group",
		name = L["Own Entries"],
		inline = true,
		disabled = CustomDisabled,
		args = {
			type = {
				order = 1,
				type = "select",
				name = L["Type"],
				values = ENTRY_TYPES,
				sorting = { "spell", "item", "slot" },
				get = function()
					return entryState.type
				end,
				set = function(_, value)
					entryState.type = value
				end,
			},
			id = {
				order = 2,
				type = "input",
				name = L["Spell or Item ID"],
				hidden = function()
					return entryState.type == "slot"
				end,
				get = function()
					return entryState.id
				end,
				set = function(_, value)
					entryState.id = value
				end,
			},
			slot = {
				order = 2,
				type = "select",
				name = L["Equipment Slot"],
				values = SlotValues,
				hidden = function()
					return entryState.type ~= "slot"
				end,
				get = function()
					return entryState.slot
				end,
				set = function(_, value)
					entryState.slot = value
				end,
			},
			add = {
				order = 3,
				type = "execute",
				name = L["Add"],
				func = function()
					local module = Module()
					if not module then return end

					local id = (entryState.type == "slot" and entryState.slot) or tonumber(entryState.id)
					if not id or not module:ValidCustomEntry(entryState.type, id) then
						mMT:Print(L["No spell or item found for this ID."])
						return
					end

					local entries = Entries()
					entries[#entries + 1] = { type = entryState.type, id = id }
					entryState.selected = #entries
					entryState.id = nil
					Refresh()
				end,
			},
			selected = {
				order = 4,
				type = "select",
				name = L["Entries"],
				values = EntryValues,
				get = function()
					return entryState.selected
				end,
				set = function(_, value)
					entryState.selected = value
				end,
			},
			up = {
				order = 5,
				type = "execute",
				name = L["Move Up"],
				disabled = function()
					return CustomDisabled() or not entryState.selected
				end,
				func = function()
					MoveEntry(-1)
				end,
			},
			down = {
				order = 6,
				type = "execute",
				name = L["Move Down"],
				disabled = function()
					return CustomDisabled() or not entryState.selected
				end,
				func = function()
					MoveEntry(1)
				end,
			},
			remove = {
				order = 7,
				type = "execute",
				name = L["Remove"],
				disabled = function()
					return CustomDisabled() or not entryState.selected
				end,
				func = function()
					local entries = Entries()
					if not entries[entryState.selected] then return end

					tremove(entries, entryState.selected)
					entryState.selected = entries[entryState.selected] and entryState.selected or nil
					Refresh()
				end,
			},
		},
	}
end

mMT.options.args.cooldownmanager.args.custom.args = {
	general = {
		order = 1,
		type = "group",
		name = L["Settings"],
		inline = true,
		disabled = Disabled,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = function()
					return VDB("custom").enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
				end,
				get = function()
					return VDB("custom").enable
				end,
				set = function(_, value)
					VDB("custom").enable = value
					E:StaticPopup_Show("CONFIG_RL")
				end,
			},
			racials = {
				order = 2,
				type = "toggle",
				name = L["Show Racials"],
				disabled = CustomDisabled,
				get = function()
					return VDB("custom").racials
				end,
				set = function(_, value)
					VDB("custom").racials = value
					Refresh()
				end,
			},
			healthstone = {
				order = 3,
				type = "toggle",
				name = L["Show Healthstone"],
				disabled = CustomDisabled,
				get = function()
					return VDB("custom").healthstone
				end,
				set = function(_, value)
					VDB("custom").healthstone = value
					Refresh()
				end,
			},
			potions = {
				order = 4,
				type = "toggle",
				name = L["Show Healing Potions"],
				disabled = CustomDisabled,
				get = function()
					return VDB("custom").potions
				end,
				set = function(_, value)
					VDB("custom").potions = value
					Refresh()
				end,
			},
			combat_potions = {
				order = 5,
				type = "toggle",
				name = L["Show Combat Potions"],
				disabled = CustomDisabled,
				get = function()
					return VDB("custom").combat_potions
				end,
				set = function(_, value)
					VDB("custom").combat_potions = value
					Refresh()
				end,
			},
			weyrnstone = {
				order = 6,
				type = "toggle",
				name = L["Show Weyrnstone"],
				desc = L["Tracks the cooldown of the Weyrnstone while it is in your bags."],
				disabled = CustomDisabled,
				get = function()
					return VDB("custom").weyrnstone
				end,
				set = function(_, value)
					VDB("custom").weyrnstone = value
					Refresh()
				end,
			},
			belt_tinker = {
				order = 7,
				type = "toggle",
				name = L["Show Belt Tinker"],
				disabled = CustomDisabled,
				get = function()
					return VDB("custom").belt_tinker
				end,
				set = function(_, value)
					VDB("custom").belt_tinker = value
					Refresh()
				end,
			},
			trinkets = {
				order = 8,
				type = "select",
				name = L["Trinkets"],
				values = { both = L["Both"], slot1 = L["Trinket 1"], slot2 = L["Trinket 2"], none = L["None"] },
				sorting = { "both", "slot1", "slot2", "none" },
				disabled = CustomDisabled,
				get = function()
					return VDB("custom").trinkets
				end,
				set = function(_, value)
					VDB("custom").trinkets = value
					Refresh()
				end,
			},
			known_only = {
				order = 10,
				type = "toggle",
				name = L["Known Spells Only"],
				desc = L["Hides own spell entries the character has not learned."],
				disabled = CustomDisabled,
				get = function()
					return VDB("custom").known_only
				end,
				set = function(_, value)
					VDB("custom").known_only = value
					Refresh()
				end,
			},
			on_use_only = {
				order = 9,
				type = "toggle",
				name = L["On-Use Only"],
				desc = L["Hides passive and proc trinkets without an activatable cooldown."],
				disabled = function()
					return CustomDisabled() or VDB("custom").trinkets == "none"
				end,
				get = function()
					return VDB("custom").on_use_only
				end,
				set = function(_, value)
					VDB("custom").on_use_only = value
					Refresh()
				end,
			},
		},
	},
	entries = EntriesGroup(1.5),
	layout = {
		order = 2,
		type = "group",
		name = L["Layout"],
		inline = true,
		disabled = CustomDisabled,
		args = {
			keep_ratio = {
				order = 1,
				type = "toggle",
				name = L["Keep Size Ratio"],
				get = function()
					return VDB("custom").keep_ratio
				end,
				set = function(_, value)
					VDB("custom").keep_ratio = value
					Refresh()
				end,
			},
			width = {
				order = 2,
				type = "range",
				name = function()
					return VDB("custom").keep_ratio and L["Icon Size"] or L["Icon Width"]
				end,
				min = 16,
				max = 80,
				step = 1,
				get = function()
					return VDB("custom").width
				end,
				set = function(_, value)
					VDB("custom").width = value
					Refresh()
				end,
			},
			height = {
				order = 3,
				type = "range",
				name = L["Icon Height"],
				min = 16,
				max = 80,
				step = 1,
				hidden = function()
					return VDB("custom").keep_ratio
				end,
				get = function()
					return VDB("custom").height
				end,
				set = function(_, value)
					VDB("custom").height = value
					Refresh()
				end,
			},
			spacing = {
				order = 5,
				type = "range",
				name = L["Spacing"],
				min = 0,
				max = 20,
				step = 1,
				get = function()
					return VDB("custom").spacing
				end,
				set = function(_, value)
					VDB("custom").spacing = value
					Refresh()
				end,
			},
			per_row = {
				order = 6,
				type = "range",
				name = L["Icons Per Row"],
				min = 1,
				max = 20,
				step = 1,
				get = function()
					return VDB("custom").per_row
				end,
				set = function(_, value)
					VDB("custom").per_row = value
					Refresh()
				end,
			},
			growth = {
				order = 7,
				type = "select",
				name = L["Growth Direction"],
				values = { CENTER = L["Center"], LEFT = L["Left"], RIGHT = L["Right"], UP = L["Up"], DOWN = L["Down"] },
				sorting = { "CENTER", "LEFT", "RIGHT", "UP", "DOWN" },
				get = function()
					return VDB("custom").growth
				end,
				set = function(_, value)
					VDB("custom").growth = value
					Refresh()
				end,
			},
		},
	},
	visibility = {
		order = 3,
		type = "group",
		name = L["Visibility"],
		inline = true,
		disabled = CustomDisabled,
		args = {
			visibility = {
				order = 1,
				type = "select",
				name = L["When to Show"],
				values = VISIBILITY,
				get = function()
					return VDB("custom").visibility
				end,
				set = function(_, value)
					VDB("custom").visibility = value
					local module = mMT:GetModule("CooldownManager")
					if module then module:UpdateVisibility() end
				end,
			},
			alpha = {
				order = 2,
				type = "range",
				name = L["Opacity"],
				min = 0.1,
				max = 1,
				step = 0.05,
				isPercent = true,
				get = function()
					return VDB("custom").alpha
				end,
				set = function(_, value)
					VDB("custom").alpha = value
					local module = mMT:GetModule("CooldownManager")
					if module then module:UpdateVisibility() end
				end,
			},
			hide_delay = {
				order = 2.5,
				type = "range",
				name = L["Hide Delay"],
				desc = L["How long the display stays up after its condition falls away."],
				min = 0,
				max = 30,
				step = 0.5,
				get = function()
					return VDB("custom").hide_delay
				end,
				set = function(_, value)
					VDB("custom").hide_delay = value
					Refresh()
				end,
			},
			fade_time = {
				order = 2.6,
				type = "range",
				name = L["Fade Time"],
				desc = L["How long fading in and out takes. Zero switches instantly."],
				min = 0,
				max = 2,
				step = 0.05,
				get = function()
					return VDB("custom").fade_time
				end,
				set = function(_, value)
					VDB("custom").fade_time = value
					Refresh()
				end,
			},
			tooltips = {
				order = 3,
				type = "toggle",
				name = L["Show Tooltips"],
				get = function()
					return VDB("custom").tooltips
				end,
				set = function(_, value)
					VDB("custom").tooltips = value
				end,
			},
		},
	},
	cooldown_text = TextGroup(L["Cooldown Text"], 4, "custom", "cooldown_text", nil, CustomDisabled),
	count_text = TextGroup(L["Count Text"], 5, "custom", "count_text", nil, CustomDisabled),
	copy = CopyGroup("custom", 20),
}
