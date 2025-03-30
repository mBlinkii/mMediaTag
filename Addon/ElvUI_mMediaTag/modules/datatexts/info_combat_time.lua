local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local floor, strjoin = floor, strjoin
local GetInstanceInfo = GetInstanceInfo
local GetTime = GetTime

--Variables
local textString, valueString = "", ""
local timer, startTime, inEncounter = 0, 0, nil
local in_combat, out_of_combat = nil, nil
local dt_icons = {
	combat_01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_1.tga",
	combat_02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_2.tga",
	combat_03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_3.tga",
	combat_04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_4.tga",
	combat_05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_5.tga",
	combat_06 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_6.tga",
	combat_07 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_7.tga",
	combat_08 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_8.tga",
	combat_09 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_9.tga",
	combat_10 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_10.tga",
	combat_11 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_11.tga",
	combat_12 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_12.tga",
	combat_13 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_13.tga",
	combat_14 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_14.tga",
	combat_15 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_15.tga",
	combat_16 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_16.tga",
	combat_17 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_17.tga",
	combat_18 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_18.tga",
	combat_19 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_19.tga",
	combat_20 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_20.tga",
}

local function CancelTimer(self)
	if self.hide_timer then
		self.hide_timer:Cancel()
		self.hide_timer = nil
	end
end
local function ClearText(self)
	CancelTimer(self)
	self.text:SetText("")
end

local function UpdateText()
	return format("%02d%s%02d", floor(timer / 60), format(valueString, ":"), timer % 60)
end

local function OnUpdate(self)
	timer = GetTime() - startTime
	self.text:SetFormattedText(textString, in_combat .. " " .. UpdateText())
end

local function DelayOnUpdate(self, elapsed)
	startTime = startTime - elapsed
	if startTime <= 0 then
		timer, startTime = 0, GetTime()
		self:SetScript("OnUpdate", OnUpdate)
	end
end

local function OnEvent(self, event, _, timeSeconds)
	in_combat = E.db.mMT.datatexts.combat_time.in_combat ~= "none" and E:TextureString(dt_icons[E.db.mMT.datatexts.combat_time.in_combat], ":14:14") or nil
	out_of_combat = E.db.mMT.datatexts.combat_time.out_of_combat ~= "none" and E:TextureString(dt_icons[E.db.mMT.datatexts.combat_time.out_of_combat], ":14:14") or nil
	local _, instanceType = GetInstanceInfo()
	local inArena, started, ended = instanceType == "arena", event == "ENCOUNTER_START", event == "ENCOUNTER_END"

	if inArena and event == "START_TIMER" then
		timer, startTime = 0, timeSeconds
		CancelTimer(self)
		self.text:SetFormattedText(textString, in_combat .. " " .. UpdateText())
		self:SetScript("OnUpdate", DelayOnUpdate)
	elseif not inArena and ((not inEncounter and event == "PLAYER_REGEN_ENABLED") or ended) then
		self.text:SetFormattedText(textString, out_of_combat .. " " .. UpdateText())
		self:SetScript("OnUpdate", nil)
		if ended then inEncounter = nil end
		if (E.db.mMT.datatexts.combat_time.hide_delay ~= 0) and not self.hide_timer then self.hide_timer = C_Timer.NewTicker(E.db.mMT.datatexts.combat_time.hide_delay, function()
			ClearText(self)
		end) end
	elseif not inArena and ((not inEncounter and event == "PLAYER_REGEN_DISABLED") or started) then
		timer, startTime = 0, GetTime()
		CancelTimer(self)
		self:SetScript("OnUpdate", OnUpdate)
		if started then inEncounter = true end
	elseif E.db.mMT.datatexts.combat_time.hide_delay == 0 then
		if not self.text:GetText() or event == 'ELVUI_FORCE_UPDATE' then
			self.text:SetFormattedText(textString, out_of_combat .. " " .. UpdateText())
		end
	end
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or hex
	textString = strjoin("", textHex, "%s|r")
	valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext( "mMT - CombatTimer", mMT.Name, { "START_TIMER", "ENCOUNTER_START", "ENCOUNTER_END", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED" }, OnEvent, nil, nil, nil, nil, L["Combat/Arena Time"], nil, ValueColorUpdate )
