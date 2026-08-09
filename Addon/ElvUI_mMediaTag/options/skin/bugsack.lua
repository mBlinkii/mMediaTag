local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

mMT.options.args.skins.args.bugsack.args = {
	toggle_enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.skins.bugsack.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		disabled = function()
			return not IsAddOnLoaded("BugSack")
		end,
		get = function(info)
			return E.db.mMediaTag.skins.bugsack.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.bugsack.enable = value
			mMT:UpdateModule("BugSackSkin")
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	spacer_1 = {
		order = 2,
		type = "description",
		name = "\n",
	},
	info = {
		order = 3,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: BugSack is not installed."]),
		hidden = function()
			return IsAddOnLoaded("BugSack")
		end,
	},
	settings = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Settings"],
		disabled = function()
			return not (E.db.mMediaTag.skins.bugsack.enable and IsAddOnLoaded("BugSack"))
		end,
		args = {
			version_label = {
				order = 1,
				type = "toggle",
				width = "full",
				name = L["Version Info"],
				desc = L["Shows the ElvUI, mMT and WoW version left of the page counter."],
				get = function(info)
					return E.db.mMediaTag.skins.bugsack.version_label
				end,
				set = function(info, value)
					E.db.mMediaTag.skins.bugsack.version_label = value
					E:StaticPopup_Show("CONFIG_RL")
				end,
			},
		},
	},
}
