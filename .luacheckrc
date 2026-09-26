std = "lua51+wow"
max_line_length = false
codes = true

exclude_files = {
	"Addon/ElvUI_mMediaTag/lib/",
	"Addon/!mMT_MediaPack/libs/",
}

ignore = {
	"212", -- unused argument, callbacks have fixed signatures
	"213", -- unused loop variable
	"432/self", -- hook callbacks take self inside methods
	"211/mMT",
	"211/DB",
	"211/M",
	"211/E",
	"211/P",
	"211/L",
	"211/MEDIA",
}

globals = {
	"MMTDATA",
	"mMTSettings",
	"SLASH_MMT1",
	"SLASH_MMTMP1",
	"SlashCmdList",
	"StaticPopupDialogs",
	"ElvUI_mMediaTag_OnAddonCompartmentClick",
	"ElvUI_mMediaTag_OnAddonCompartmentEnter",
	"ElvUI_mMediaTag_OnAddonCompartmentLeave",
}

-- newer APIs that the .luarc.json list does not know yet
local extra = {
	"AddOnUtil",
	"C_ActionBar",
	"C_AddOnProfiler",
	"C_ClassColor",
	"C_ColorUtil",
	"C_ContentTracking",
	"C_CurveUtil",
	"C_CVar",
	"C_EncodingUtil",
	"C_PerksActivities",
	"C_SpecializationInfo",
	"C_Spell",
	"C_SpellActivationOverlay",
	"C_SpellBook",
	"C_StringUtil",
	"C_TooltipInfo",
	"CreateAbbreviateConfig",
	"CreateAtlasMarkup",
	"CreateTextureMarkup",
	"CreateTreeDataProvider",
	"GetDetailedItemLevelInfo",
	"IsUnitModelReadyForUI",
	"issecretvalue",
	"Item",
	"ScrollBoxConstants",
	"Settings",
	"UnitCastingDuration",
	"UnitChannelDuration",
	"UnitEmpoweredChannelDuration",
	"UnitHasPowerType",
	"UnitHealthMissing",
	"UnitInPartyIsAI",
	"WrapTextInColorCode",
}

-- the WoW API list is read from .luarc.json, so the language server and luacheck share one list
local wow = {}
local function add(name)
	local root, field = name:match("^([%w_]+)%.([%w_]+)$")
	local key = root or name:match("^[%w_]+$")
	if not key then return end

	wow[key] = wow[key] or {}
	if root then
		wow[key].fields = wow[key].fields or {}
		wow[key].fields[field] = {}
	else
		wow[key].other_fields = true
	end
end

local luarc = io.open(".luarc.json", "r")
if luarc then
	local list = luarc:read("*a"):match('"diagnostics%.globals"%s*:%s*(%b[])') or ""
	luarc:close()

	for name in list:gmatch('"([^"]+)"') do
		add(name)
	end
end

for _, name in ipairs(extra) do
	add(name)
end

stds.wow = { read_globals = wow }
