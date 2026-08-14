local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

mMT.options.args.skins.args.classcodex.args = {
	toggle_enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.skins.classcodex.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		disabled = function()
			return not IsAddOnLoaded("ClassCodex")
		end,
		get = function(info)
			return E.db.mMediaTag.skins.classcodex.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.classcodex.enable = value
			mMT:UpdateModule("ClassCodexSkin")
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
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: Class Codex is not installed."]),
		hidden = function()
			return IsAddOnLoaded("ClassCodex")
		end,
	},
	info_scope = {
		order = 4,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: This skins the codex panel, the compendium, the loadout dock and the talent pane widget. The copy dialog keeps its default look."]),
		hidden = function()
			return not IsAddOnLoaded("ClassCodex")
		end,
	},
}
