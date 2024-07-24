local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

--Lua functions
local tonumber = tonumber
local format = format
local ipairs = ipairs
local tinsert = tinsert

--WoW API / Variables
local _G = _G
local SetCVar = SetCVar
local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local IsShiftKeyDown = IsShiftKeyDown
local ShowOptionsPanel = ShowOptionsPanel
local SOUND = SOUND

local Sound_GameSystem_GetOutputDriverNameByIndex = Sound_GameSystem_GetOutputDriverNameByIndex
local Sound_GameSystem_GetNumOutputDrivers = Sound_GameSystem_GetNumOutputDrivers
local Sound_GameSystem_RestartSoundSystem = Sound_GameSystem_RestartSoundSystem

--Variables
local AudioStreams = {
	{ Name = _G.MASTER, Volume = "Sound_MasterVolume", Enabled = "Sound_EnableAllSound" },
	{ Name = _G.SOUND_VOLUME or _G.FX_VOLUME, Volume = "Sound_SFXVolume", Enabled = "Sound_EnableSFX" },
	{ Name = _G.AMBIENCE_VOLUME, Volume = "Sound_AmbienceVolume", Enabled = "Sound_EnableAmbience" },
	{ Name = _G.DIALOG_VOLUME, Volume = "Sound_DialogVolume", Enabled = "Sound_EnableDialog" },
	{ Name = _G.MUSIC_VOLUME, Volume = "Sound_MusicVolume", Enabled = "Sound_EnableMusic" },
}

local panel
local activeIndex = 1
local activeStream = AudioStreams[activeIndex]
local menu = { { text = L["Select Volume Stream"], isTitle = true, notCheckable = true } }
local toggleMenu = { { text = L["Toggle Volume Stream"], isTitle = true, notCheckable = true } }
local deviceMenu = { { text = L["Output Audio Device"], isTitle = true, notCheckable = true } }

local Config = {
	name = "mMT_Dock_Volume",
	localizedName = mMT.DockString .. " " .. L["Volume"],
	category = "mMT-" .. mMT.DockString,
	text = {
		enable = true,
		center = false,
		a = true, -- first label
		b = false, -- second label
	},
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function GetStreamString(stream, tooltip)
	if not stream then
		stream = AudioStreams[1]
	end

	local color = GetCVarBool(AudioStreams[1].Enabled) and GetCVarBool(stream.Enabled) and "00FF00" or "FF3333"
	local level = (GetCVar(stream.Volume) or 0) * 100

	return (tooltip and format("|cFF%s%.f%%|r", color, level)) or format("%s: |cFF%s%.f%%|r", stream.Name, color, level)
end

local function SelectStream(_, ...)
	activeIndex = ...
	activeStream = AudioStreams[activeIndex]

	if E.db.mMT.dockdatatext.volume.showtext then
		panel.mMT_Dock.TextA:SetFormattedText(mMT.ClassColor.string, GetStreamString(activeStream or "Sound_MasterVolume", true))
	end
end

local function ToggleStream(_, ...)
	local Stream = AudioStreams[...]

	SetCVar(Stream.Enabled, GetCVarBool(Stream.Enabled) and 0 or 1, "MMT_ELVUI_VOLUME")

	if E.db.mMT.dockdatatext.volume.showtext then
		panel.mMT_Dock.TextA:SetFormattedText(mMT.ClassColor.string, GetStreamString(activeStream or "Sound_MasterVolume", true))
	end
end

for Index, Stream in ipairs(AudioStreams) do
	tinsert(menu, {
		text = Stream.Name,
		checked = function()
			return Index == activeIndex
		end,
		func = SelectStream,
		arg1 = Index,
	})
	tinsert(toggleMenu, {
		text = Stream.Name,
		checked = function()
			return GetCVarBool(Stream.Enabled)
		end,
		func = ToggleStream,
		arg1 = Index,
	})
end

local function SelectSoundOutput(_, ...)
	SetCVar("Sound_OutputDriverIndex", ..., "MMT_ELVUI_VOLUME")
	Sound_GameSystem_RestartSoundSystem()
end

for i = 0, Sound_GameSystem_GetNumOutputDrivers() - 1 do
	tinsert(deviceMenu, {
		text = Sound_GameSystem_GetOutputDriverNameByIndex(i),
		checked = function()
			return i == tonumber(GetCVar("Sound_OutputDriverIndex"))
		end,
		func = SelectSoundOutput,
		arg1 = i,
	})
end

local function mVolumeTip()
	DT.tooltip:ClearLines()

	DT.tooltip:AddLine(L["Active Output Audio Device"], 1, 1, 1)
	DT.tooltip:AddLine(Sound_GameSystem_GetOutputDriverNameByIndex(GetCVar("Sound_OutputDriverIndex")))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(L["Volume Streams"], 1, 1, 1)

	for _, Stream in ipairs(AudioStreams) do
		DT.tooltip:AddDoubleLine(Stream.Name, GetStreamString(Stream, true))
	end

	DT.tooltip:AddLine(" ")

	DT.tooltip:AddLine(L["|cFFffffffLeft Click:|r Select Volume Stream"])
	DT.tooltip:AddLine(L["|cFFffffffMiddle Click:|r Toggle Mute Master Stream"])
	DT.tooltip:AddLine(L["|cFFffffffRight Click:|r Toggle Volume Stream"])
	DT.tooltip:AddLine(L["|cFFffffffShift + Left Click:|r Open System Audio Panel"])
	DT.tooltip:AddLine(L["|cFFffffffShift + Right Click:|r Select Output Audio Device"])

	DT.tooltip:Show()
end

local function OnMouseWheel(self, delta)
	local vol = GetCVar(activeStream.Volume)
	local scale = 100

	if IsShiftKeyDown() then
		scale = 10
	end

	vol = vol + (delta / scale)

	if vol >= 1 then
		vol = 1
	elseif vol <= 0 then
		vol = 0
	end

	SetCVar(activeStream.Volume, vol, "MMT_ELVUI_VOLUME")

	if E.db.mMT.dockdatatext.volume.showtext then
		self.mMT_Dock.TextA:SetFormattedText(mMT.ClassColor.string, GetStreamString(activeStream or "Sound_MasterVolume", true))
	end

	mVolumeTip()
end

local function OnEnter(self)
	mMT:Dock_OnEnter(self, Config)
	mVolumeTip()
end

local function OnEvent(self, event)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.text.enable = E.db.mMT.dockdatatext.volume.showtext
		Config.text.a = E.db.mMT.dockdatatext.volume.showtext
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.volume.icon]
		Config.icon.color = E.db.mMT.dockdatatext.volume.customcolor and E.db.mMT.dockdatatext.volume.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

	activeStream = AudioStreams[activeIndex]
	panel = self

	if not self.mScript then
		self:EnableMouseWheel(true)
		self:SetScript("OnMouseWheel", OnMouseWheel)
		self.mScript = true
	end

	local text = nil
	if E.db.mMT.dockdatatext.volume.showtext then
		text = GetStreamString(activeStream or "Sound_MasterVolume", true)
		self.mMT_Dock.TextA:SetText(text)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end
	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self, button)
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)
		if button == "LeftButton" then
			if IsShiftKeyDown() then
				if E.Retail then
					_G.Settings.OpenToCategory(_G.Settings.AUDIO_CATEGORY_ID)
				else
					ShowOptionsPanel(_G.VideoOptionsFrame, _G.GameMenuFrame, SOUND)
				end
				return
			end

			E:SetEasyMenuAnchor(E.EasyMenu, self)
			E:ComplicatedMenu(menu, E.EasyMenu, nil, nil, nil, 'MENU')
		elseif button == "MiddleButton" then
			SetCVar(AudioStreams[1].Enabled, GetCVarBool(AudioStreams[1].Enabled) and 0 or 1, "MMT_ELVUI_VOLUME")
		elseif button == "RightButton" then
			E:SetEasyMenuAnchor(E.EasyMenu, self)
			E:ComplicatedMenu(IsShiftKeyDown() and deviceMenu or toggleMenu, E.EasyMenu, nil, nil, nil, "MENU")
		end
	end
end

DT:RegisterDatatext(Config.name, Config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, Config.localizedName, nil, nil)
