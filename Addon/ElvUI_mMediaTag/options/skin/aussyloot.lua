local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local function IsDisabled()
	return not (IsAddOnLoaded("AussyLoot") and E.db.mMediaTag.skins.aussyloot.enable)
end

mMT.options.args.skins.args.aussyloot.args = {
	toggle_enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.skins.aussyloot.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		disabled = function()
			return not IsAddOnLoaded("AussyLoot")
		end,
		get = function(info)
			return E.db.mMediaTag.skins.aussyloot.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.aussyloot.enable = value
			mMT:UpdateModule("AussyLootSkin")
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	info_missing = {
		order = 2,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: AussyLoot is not installed."]),
		hidden = function()
			return IsAddOnLoaded("AussyLoot")
		end,
	},
	info_scope = {
		order = 3,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(
			L["Info: This replaces AussyLoot's own surface, border and accent colors with the ElvUI ones and its fonts with the ElvUI font. The window is rebuilt on the next reload, the item quality, crest and status colors keep their own meaning."]
		),
		hidden = function()
			return not IsAddOnLoaded("AussyLoot")
		end,
	},
	settings = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			color_mode = {
				order = 1,
				type = "select",
				name = L["Color Style"],
				disabled = IsDisabled,
				values = {
					original = L["Original"],
					value = L["Value Color"],
					class = L["Class"],
					custom = L["Custom"],
				},
				get = function(info)
					return E.db.mMediaTag.skins.aussyloot.color.mode
				end,
				set = function(info, value)
					E.db.mMediaTag.skins.aussyloot.color.mode = value
					mMT:UpdateModule("AussyLootSkin")
					E:StaticPopup_Show("CONFIG_RL")
				end,
			},
			color = {
				order = 2,
				type = "color",
				name = L["Custom color"],
				hasAlpha = true,
				disabled = function()
					return IsDisabled() or E.db.mMediaTag.skins.aussyloot.color.mode == "original"
				end,
				get = function(info)
					local t = E.db.mMediaTag.skins.aussyloot.color.color
					return t.r, t.g, t.b, t.a
				end,
				set = function(info, r, g, b, a)
					local t = E.db.mMediaTag.skins.aussyloot.color.color
					t.r, t.g, t.b, t.a = r, g, b, a
					mMT:UpdateModule("AussyLootSkin")
					E:StaticPopup_Show("CONFIG_RL")
				end,
			},
		},
	},
}
