local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local function Settings()
	return E.db.mMediaTag.nameplates.combat_fade
end

local function UpdateModule()
	mMT:UpdateModule("NP-CombatFade")
end

local function Disabled()
	return not Settings().enable
end

mMT.options.args.nameplates.args.tools.args.combat_fade.args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return Settings().enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Fades or hides enemy nameplates of units that are not in combat while you are fighting."],
		get = function()
			return Settings().enable
		end,
		set = function(_, value)
			Settings().enable = value
			UpdateModule()
		end,
	},
	settings = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Settings"],
		disabled = Disabled,
		args = {
			alpha = {
				order = 1,
				type = "range",
				name = L["Opacity"],
				desc = L["0% hides the nameplates completely."],
				min = 0,
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
			scale = {
				order = 2,
				type = "range",
				name = L["Scale"],
				min = 0.3,
				max = 1.5,
				step = 0.05,
				isPercent = true,
				get = function()
					return Settings().scale
				end,
				set = function(_, value)
					Settings().scale = value
					UpdateModule()
				end,
			},
			instanceOnly = {
				order = 3,
				type = "toggle",
				name = L["Only in instances"],
				get = function()
					return Settings().instanceOnly
				end,
				set = function(_, value)
					Settings().instanceOnly = value
					UpdateModule()
				end,
			},
		},
	},
}
