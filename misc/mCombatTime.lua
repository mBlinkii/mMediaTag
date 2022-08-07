local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

local floor, format, strjoin = floor, format, strjoin
local GetInstanceInfo = GetInstanceInfo
local GetTime = GetTime

--Variables
local mText = L["mCombatTime"]
local hexColor, lastPanel = "", nil
local timer, startTime, inEncounter = 0, 0, nil
local mCombatIcon = format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\combaticon.tga")
local mCombatLeaveIcon =
	format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\outofcombaticon.tga")
local mIconUpdate = mCombatIcon
local clear = false

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
		mIconUpdate = mCombatIcon
		clear = false
		mMT:CancelAllTimers(self.mTimer)
		timer, startTime = 0, timeSeconds
		self.text:SetText("00:00")
		self:SetScript("OnUpdate", DelayOnUpdate)
	elseif not inArena and ((not inEncounter and event == "PLAYER_REGEN_ENABLED") or ended) then
		mIconUpdate = mCombatLeaveIcon
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
		mIconUpdate = mCombatIcon
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

	lastPanel = self
end

local function ValueColorUpdate(hex)
	hexColor = hex

	if lastPanel then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

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
	ValueColorUpdate
)
