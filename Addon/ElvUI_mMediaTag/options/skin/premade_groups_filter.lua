local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

mMT.options.args.skins.args.premade_groups_filter.args = {
	toggle_enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.skins.premade_groups_filter.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		disabled = function()
			return not IsAddOnLoaded("PremadeGroupsFilter")
		end,
		get = function(info)
			return E.db.mMediaTag.skins.premade_groups_filter.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.premade_groups_filter.enable = value
			mMT:UpdateModule("PremadeGroupsFilterSkin")
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	spacer_1 = {
		order = 2,
		type = "description",
		name = "\n",
	},
	info_missing = {
		order = 3,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: Premade Groups Filter is not installed."]),
		hidden = function()
			return IsAddOnLoaded("PremadeGroupsFilter")
		end,
	},
	info_scope = {
		order = 4,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: This skins the filter dialog, its panels, dropdowns and popups."]),
		hidden = function()
			return not IsAddOnLoaded("PremadeGroupsFilter")
		end,
	},
}
