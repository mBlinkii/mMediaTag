local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local LSM = E.Libs.LSM

local _G = _G
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local function IsDisabled()
	return not (IsAddOnLoaded("BigWigs") and E.db.mMediaTag.skins.bigwigs.enable)
end

mMT.options.args.skins.args.bigwigs.args = {
	toggle_enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.skins.bigwigs.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		disabled = function()
			return not IsAddOnLoaded("BigWigs")
		end,
		get = function(info)
			return E.db.mMediaTag.skins.bigwigs.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.bigwigs.enable = value
			mMT:UpdateModule("BigWigsSkin")
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	spacer_1 = {
		order = 2,
		type = "description",
		name = "\n",
	},
	keystones = {
		order = 3,
		type = "toggle",
		name = L["Keystone Window"],
		disabled = IsDisabled,
		get = function(info)
			return E.db.mMediaTag.skins.bigwigs.keystones
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.bigwigs.keystones = value
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	queue_timer = {
		order = 4,
		type = "toggle",
		name = L["Queue Timer Bar"],
		disabled = IsDisabled,
		get = function(info)
			return E.db.mMediaTag.skins.bigwigs.queue_timer
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.bigwigs.queue_timer = value
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	texture_enable = {
		order = 5,
		type = "toggle",
		name = L["Custom Texture"],
		disabled = function()
			return IsDisabled() or not E.db.mMediaTag.skins.bigwigs.queue_timer
		end,
		get = function(info)
			return E.db.mMediaTag.skins.bigwigs.texture_enable
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.bigwigs.texture_enable = value
			mMT:UpdateModule("BigWigsSkin")
		end,
	},
	texture = {
		order = 6,
		type = "select",
		dialogControl = "LSM30_Statusbar",
		name = L["Texture"],
		values = LSM:HashTable("statusbar"),
		disabled = function()
			return IsDisabled() or not (E.db.mMediaTag.skins.bigwigs.queue_timer and E.db.mMediaTag.skins.bigwigs.texture_enable)
		end,
		get = function(info)
			return E.db.mMediaTag.skins.bigwigs.texture
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.bigwigs.texture = value
			mMT:UpdateModule("BigWigsSkin")
		end,
	},
	color_mode = {
		order = 7,
		type = "select",
		name = L["Color Style"],
		disabled = function()
			return IsDisabled() or not E.db.mMediaTag.skins.bigwigs.queue_timer
		end,
		values = {
			original = L["Original"],
			class = L["Class"],
			custom = L["Custom"],
		},
		get = function(info)
			return E.db.mMediaTag.skins.bigwigs.color.mode
		end,
		set = function(info, value)
			E.db.mMediaTag.skins.bigwigs.color.mode = value
			mMT:UpdateModule("BigWigsSkin")
		end,
	},
	color = {
		order = 8,
		type = "color",
		name = L["Custom color"],
		hasAlpha = true,
		disabled = function()
			return IsDisabled() or not E.db.mMediaTag.skins.bigwigs.queue_timer or E.db.mMediaTag.skins.bigwigs.color.mode ~= "custom"
		end,
		get = function(info)
			local t = E.db.mMediaTag.skins.bigwigs.color.color
			return t.r, t.g, t.b, t.a
		end,
		set = function(info, r, g, b, a)
			local t = E.db.mMediaTag.skins.bigwigs.color.color
			t.r, t.g, t.b, t.a = r, g, b, a
			mMT:UpdateModule("BigWigsSkin")
		end,
	},
	spacer_2 = {
		order = 9,
		type = "description",
		name = "\n",
	},
	info_missing = {
		order = 10,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: BigWigs is not installed."]),
		hidden = function()
			return IsAddOnLoaded("BigWigs")
		end,
	},
	info_scope = {
		order = 11,
		type = "description",
		name = MEDIA.color.info:WrapTextInColorCode(L["Info: The keystone window is the /key list, the queue timer is the bar below the dungeon invite popup. Boss bars keep their own BigWigs style."]),
		hidden = function()
			return not IsAddOnLoaded("BigWigs")
		end,
	},
}
