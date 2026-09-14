local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("CooldownManager", { "AceEvent-3.0", "AceHook-3.0" })

-- Cache WoW Globals
local _G = _G
local next = next
local type = type
local ipairs = ipairs
local LibStub = LibStub

module.LSM = E.Libs.LSM
module.LCG = LibStub("LibCustomGlow-1.0", true)

module.VIEWERS = {
	essential = { global = "EssentialCooldownViewer", label = L["Essential Cooldowns"], mover = "mMediaTag_CDM_Essential" },
	utility = { global = "UtilityCooldownViewer", label = L["Utility Cooldowns"], mover = "mMediaTag_CDM_Utility" },
	buff_icon = { global = "BuffIconCooldownViewer", label = L["Buff Icons"], mover = "mMediaTag_CDM_BuffIcon" },
	buff_bar = { global = "BuffBarCooldownViewer", label = L["Buff Bars"], mover = "mMediaTag_CDM_BuffBar" },
	custom = { global = nil, label = L["Custom Tracker"], mover = "mMediaTag_CDM_Custom" },
}

module.containers = {}
module.styled = {}
module.glowActive = {}
module.hookedGlow = {}
module.hookedPandemic = {}
module.pandemicVersion = 1
module.hookedSwipes = {}
module.hookedViewers = {}
module.hookedActiveState = {}
module.frameCache = {}
module.emptyViewers = {}
module.demoActive = false
module.inCombat = false

module.sortFunc = function(a, b)
	return (a.layoutIndex or 0) < (b.layoutIndex or 0)
end

-- A field is only copied when the target knows it, so a bar never pushes its own keys into an icon viewer
module.COPY_SECTIONS = {
	layout = { "keep_ratio", "width", "height", "spacing", "per_row", "growth", "icon", "icon_gap", "mirrored", "column_gap", "texture" },
	visibility = { "alpha", "visibility", "hide_delay", "fade_time" },
	text = { "cooldown_text", "count_text", "keybind_text", "name_text", "duration_text", "stacks_text" },
	glow = { "glow", "pandemic", "pandemic_color", "pandemic_glow" },
	color = { "debuff_border", "class_color", "color", "background_color" },
}

function module:GetDB()
	return E.db.mMediaTag and E.db.mMediaTag.cooldown_manager
end

function module:CopyViewerSettings(source, target, sections)
	local from, to = module:ViewerDB(source), module:ViewerDB(target)
	local schema = P.cooldown_manager.viewers[target]
	if not from or not to or not schema or source == target then return 0 end

	local copied = 0
	for section, fields in next, module.COPY_SECTIONS do
		if sections[section] then
			for _, field in ipairs(fields) do
				if from[field] ~= nil and schema[field] ~= nil then
					if type(from[field]) == "table" then
						if type(to[field]) ~= "table" then to[field] = {} end
						E:CopyTable(to[field], from[field])
					else
						to[field] = from[field]
					end
					copied = copied + 1
				end
			end
		end
	end

	return copied
end

function module:ViewerDB(key)
	local db = module:GetDB()
	return db and db.viewers and db.viewers[key]
end

function module:GetViewer(key)
	local info = module.VIEWERS[key]
	return info and info.global and _G[info.global]
end

-- The custom tracker owns its frames, the four Blizzard viewers are only touched when the user wants them managed
function module:IsManaged(key)
	local vdb = module:ViewerDB(key)
	if not vdb then return false end
	if key == "custom" then return vdb.enable or false end
	return vdb.manage ~= false
end

function module:IsDisabled()
	local db = module:GetDB()
	return not (db and db.enable)
end

module.SPELL_GLOW_DEFAULTS = { enable = false, type = "pixel", color = { r = 0.95, g = 0.95, b = 0.32, a = 1 }, lines = 8, speed = 0.25, thickness = 2, particles = 4, scale = 1 }
module.SPELL_BAR_COLOR_DEFAULTS = { enable = false, color = { r = 0.2, g = 0.6, b = 1 }, background = { r = 0.1, g = 0.1, b = 0.1, a = 0.5 } }
module.SPELL_ACTIVE_STATE_DEFAULTS = {
	mode = "default",
	swipe = "aura",
	swipe_color = { r = 1, g = 0.95, b = 0.57, a = 0.7 },
	text_color = { r = 1, g = 1, b = 1 },
	text_class_color = false,
	desaturate = false,
}

local function EnsureStore(name)
	local db = module:GetDB()
	if not db then return nil end
	if not db[name] then db[name] = {} end
	return db[name]
end

function module:GetSpellGlow(spellID)
	local db = module:GetDB()
	return db and db.spell_glow and db.spell_glow[spellID]
end

function module:GetOrCreateSpellGlow(spellID)
	local store = EnsureStore("spell_glow")
	if not store then return nil end
	if not store[spellID] then store[spellID] = {} end
	return E:CopyDefaults(store[spellID], module.SPELL_GLOW_DEFAULTS)
end

function module:GetSpellBarColor(spellID)
	local db = module:GetDB()
	return db and db.spell_bar_color and db.spell_bar_color[spellID]
end

function module:GetOrCreateSpellBarColor(spellID)
	local store = EnsureStore("spell_bar_color")
	if not store then return nil end
	if not store[spellID] then store[spellID] = {} end
	return E:CopyDefaults(store[spellID], module.SPELL_BAR_COLOR_DEFAULTS)
end

function module:GetSpellActiveState(spellID)
	local db = module:GetDB()
	return db and db.spell_active_state and db.spell_active_state[spellID]
end

function module:GetOrCreateSpellActiveState(spellID)
	local store = EnsureStore("spell_active_state")
	if not store then return nil end
	if not store[spellID] then store[spellID] = {} end
	return E:CopyDefaults(store[spellID], module.SPELL_ACTIVE_STATE_DEFAULTS)
end
