local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")
local addon, ns = ...

local floor, format, strjoin = floor, format, strjoin
local GetInstanceInfo = GetInstanceInfo
local GetTime = GetTime

--Variables
local mText = L["mCombatTime"]
local hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
local timer, startTime, inEncounter = 0, 0, nil
local mIconUpdate = nil
local clear = false
local texturelist = {
	CI1 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat1.tga',':20:20'),
	CI2 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat2.tga',':20:20'),
	CI3 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat3.tga',':20:20'),
	CI4 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat4.tga',':20:20'),
	CI5 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat5.tga',':20:20'),
	CI6 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat6.tga',':20:20'),
	CI7 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat7.tga',':20:20'),
	CI8 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat8.tga',':20:20'),
	CI9 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat9.tga',':20:20'),
	CI10 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat10.tga',':20:20'),
	CI12 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat11.tga',':20:20'),
}

local function UpdateText()
	return format(format("%02d:%02d", floor(timer / 60), timer % 60)):gsub("([/:])", hexColor .. "%1|r")
end

local function OnUpdate(self)
	timer = GetTime() - startTime
	self.text:SetText(mIconUpdate .. UpdateText())
end

function mMT:mCleartText(self)
	self.text:SetText("")
	clear = true
end

local function DelayOnUpdate(self, elapsed)
	startTime = startTime - elapsed
	if startTime <= 0 then
		timer, startTime = 0, GetTime()
		self:SetScript("OnUpdate", OnUpdate)
	end
end

local function OnEvent(self, event, _, timeSeconds)
	local _, instanceType = GetInstanceInfo()
	local inArena, started, ended = instanceType == "arena", event == "ENCOUNTER_START", event == "ENCOUNTER_END"

	if inArena and event == "START_TIMER" then
		mIconUpdate = texturelist[E.db.mMT.combattime.ooctexture]
		clear = false
		mMT:CancelAllTimers(self.mTimer)
		timer, startTime = 0, timeSeconds
		self.text:SetText("00:00")
		self:SetScript("OnUpdate", DelayOnUpdate)
	elseif not inArena and ((not inEncounter and event == "PLAYER_REGEN_ENABLED") or ended) then
		mIconUpdate = texturelist[E.db.mMT.combattime.ictexture]
		clear = false
		self.text:SetText(mIconUpdate .. UpdateText())
		self:SetScript("OnUpdate", nil)
		if ended then
			inEncounter = nil
		end
		if clear == false then
			self.mTimer = mMT:ScheduleTimer("mCleartText", 30, self)
		end
	elseif not inArena and (event == "PLAYER_REGEN_DISABLED" or started) then
		mIconUpdate = texturelist[E.db.mMT.combattime.ooctexture]
		clear = false
		mMT:CancelAllTimers(self.mTimer)
		timer, startTime = 0, GetTime()
		self:SetScript("OnUpdate", OnUpdate)
		if started then
			inEncounter = true
		end
	elseif not self.text:GetText() then
		self.text:SetText("")
		if clear == false then
			self.mTimer = mMT:ScheduleTimer("mCleartText", 30, self)
		end
	end
end

DT:RegisterDatatext(
	"mCombatTime",
	"mMediaTag",
	{ "START_TIMER", "ENCOUNTER_START", "ENCOUNTER_END", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED" },
	OnEvent,
	nil,
	nil,
	nil,
	nil,
	mText,
	nil,
	nil
)
