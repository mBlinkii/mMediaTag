local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local function IsDisabled()
	return not (IsAddOnLoaded("PremadeGroupsFilter") and E.db.mMediaTag.skins.premade_groups_filter.enable)
end

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
	header_checkbox = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Checkboxes"],
		hidden = function()
			return not IsAddOnLoaded("PremadeGroupsFilter")
		end,
		args = {
			size = {
				order = 1,
				type = "range",
				name = L["Size"],
				min = 10,
				max = 24,
				step = 1,
				disabled = IsDisabled,
				get = function(info)
					return E.db.mMediaTag.skins.premade_groups_filter.checkbox.size
				end,
				set = function(info, value)
					E.db.mMediaTag.skins.premade_groups_filter.checkbox.size = value
					mMT:UpdateModule("PremadeGroupsFilterSkin")
				end,
			},
			mode = {
				order = 2,
				type = "select",
				name = L["Color Style"],
				disabled = IsDisabled,
				values = {
					original = L["Original"],
					class = L["Class"],
					custom = L["Custom"],
				},
				get = function(info)
					return E.db.mMediaTag.skins.premade_groups_filter.checkbox.color.mode
				end,
				set = function(info, value)
					E.db.mMediaTag.skins.premade_groups_filter.checkbox.color.mode = value
					mMT:UpdateModule("PremadeGroupsFilterSkin")
				end,
			},
			color = {
				order = 3,
				type = "color",
				name = L["Custom color"],
				hasAlpha = true,
				disabled = function()
					return IsDisabled() or E.db.mMediaTag.skins.premade_groups_filter.checkbox.color.mode ~= "custom"
				end,
				get = function(info)
					local t = E.db.mMediaTag.skins.premade_groups_filter.checkbox.color.color
					return t.r, t.g, t.b, t.a
				end,
				set = function(info, r, g, b, a)
					local t = E.db.mMediaTag.skins.premade_groups_filter.checkbox.color.color
					t.r, t.g, t.b, t.a = r, g, b, a
					mMT:UpdateModule("PremadeGroupsFilterSkin")
				end,
			},
		},
	},
	info_missing = {
		order = 4,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: Premade Groups Filter is not installed."]),
		hidden = function()
			return IsAddOnLoaded("PremadeGroupsFilter")
		end,
	},
	info_scope = {
		order = 5,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: This skins the filter dialog, its panels, dropdowns and popups."]),
		hidden = function()
			return not IsAddOnLoaded("PremadeGroupsFilter")
		end,
	},
}
