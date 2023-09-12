local E, _, V, P, G = unpack(ElvUI)
local addon = ...

local EP = E.Libs.EP
local PI = E:GetModule("PluginInstaller")
local L = E.Libs.ACL:GetLocale("ElvUI", E.global.general.locale)

local _G = _G
local next, type = next, type
local print = print

local collectgarbage = collectgarbage
local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata

P.MT = {
	enable = true,
	color = { r = 1, g = 1, b = 1, a = 1 },
	text = "NO TEXT",
}

MTEST = E:NewModule(addon, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceConsole-3.0")

--Einstellungen
MTEST.Config = {}
MTEST.Modules = {}
MTEST.Name = addon
MTEST.Version = GetAddOnMetadata(addon, "Version")
MTEST.isRetail = E.Retail

local tinsert = tinsert

local function configTable()
	E.Options.args.MT = {
		type = "group",
		name = MTEST.Name,
		order = 6,
		args = {
			toggle_enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
				get = function(info)
					return E.db.MT.enable
				end,
				set = function(info, value)
					E.db.MT.enable = value
					MTEST.Modules.DEVTest:Update_Settings()
				end,
			},
			color_shadow = {
				type = "color",
				order = 2,
				name = L["Shadow Color"],
				hasAlpha = true,
				get = function(info)
					local t = E.db.MT.color
					return t.r, t.g, t.b, t.a
				end,
				set = function(info, r, g, b, a)
					local t = E.db.MT.color
					t.r, t.g, t.b, t.a = r, g, b, a
					MTEST.Modules.DEVTest:Update_Settings()
				end,
			},
			input_text = {
				order = 3,
				name = "Text",
				type = "input",
				width = "smal",
				get = function(info)
					return E.db.MT.text
				end,
				set = function(info, value)
					E.db.MT.text = value
					MTEST.Modules.DEVTest:Update_Settings()
				end,
			},
		},
	}
end

tinsert(MTEST.Config, configTable)

function MTEST:ConfigTable()
	E.Options.name = format("%s + %s |cff99ff33%s|r", E.Options.name, MTEST.Name, MTEST.Version)

	for _, func in pairs(MTEST.Config) do
		func()
	end
end

function ProfileDBUpdate(event, bole)
	print("IIIDIDD")
	MTEST.print("|CFF6559F1UPDATE|r", event, bole)
	MTEST.print("|CFF6559F1UPDATE|r", E.db.MT.enable, E.db.MT.color.r, E.db.MT.color.g, E.db.MT.color.b, E.db.MT.color.a, E.db.MT.text)
	MTEST.Modules.DEVTest:Init(E.db.MT)
end

function MTEST:Initialize()
	EP:RegisterPlugin(addon, MTEST.ConfigTable)

	hooksecurefunc(E, "UpdateAll", ProfileDBUpdate)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function MTEST:print(...)
	print("|CFFBC26E5!DEBUG PRINT MTEST:|r", ...)
end

local function CallbackInitialize()
	MTEST:Initialize()
end

function MTEST:PLAYER_ENTERING_WORLD(event)
	MTEST.print(event, E.db.MT.enable, E.db.MT.color.r, E.db.MT.color.g, E.db.MT.color.b, E.db.MT.color.a, E.db.MT.text)
	MTEST.Modules.DEVTest:Init()
	E:Delay(1, collectgarbage, "collect")
end

EP:HookInitialize(addon, CallbackInitialize)
