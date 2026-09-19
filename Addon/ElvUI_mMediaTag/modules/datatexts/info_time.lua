local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- Cache WoW Globals
local format, strjoin = format, strjoin
local floor, select = floor, select
local GetTime = GetTime
local GetInstanceInfo = GetInstanceInfo

local timeDT
local textString, valueString = "", ""
local dt_icons = MEDIA.icons.datatexts.combat
local combatStart, holdUntil, inCombat, inEncounter

local function GetIcon(key)
	return (key and key ~= "none" and dt_icons[key]) and (E:TextureString(dt_icons[key], ":14:14") .. " ") or ""
end

local function CombatText(elapsed)
	local sep = format(valueString, ":")
	local minutes, seconds = floor(elapsed / 60), floor(elapsed % 60)

	if minutes >= 60 then return format("%d%s%02d%s%02d", floor(minutes / 60), sep, minutes % 60, sep, seconds) end

	return format("%02d%s%02d", minutes, sep, seconds)
end

local function Connect(self)
	if not self.mmtTimeFrame then
		self.mmtTimeFrame = {
			name = "Time", -- keeps ElvUI's Time datatext on its own settings instead of ours
			anim = { IsPlaying = E.noop, Play = E.noop, Stop = E.noop }, -- E:Flash would build an animation group on this table
			text = {
				SetFormattedText = function(_, fmt, ...)
					self.mmtClock = format(fmt, ...)
				end,
			},
		}

		mMT:ConnectVirtualFrameToDataText("Time", self.mmtTimeFrame)
	end

	timeDT = mMT:GetElvUIDataText("Time")
end

local function Display(self)
	local db = E.db.mMediaTag.datatexts.time
	local now = GetTime()

	if combatStart and (inCombat or (holdUntil and now < holdUntil)) then
		local elapsed = now - combatStart
		self.text:SetFormattedText(textString, GetIcon(db.in_combat) .. CombatText(elapsed > 0 and elapsed or 0))
		return
	end

	combatStart, holdUntil = nil, nil
	self.text:SetFormattedText(textString, GetIcon(db.icon) .. (self.mmtClock or ""))
end

local function OnEnter()
	if timeDT then timeDT.onEnter() end
end

local function OnLeave()
	if timeDT then timeDT.onLeave() end
	DT.tooltip:Hide()
end

local function OnClick(self, button)
	if timeDT then timeDT.onClick(self, button) end
end

local function OnUpdate(self, elapsed)
	if timeDT and self.mmtTimeFrame then timeDT.onUpdate(self.mmtTimeFrame, elapsed) end

	self.mmtElapsed = (self.mmtElapsed or 1) + elapsed
	if self.mmtElapsed < 0.2 then return end
	self.mmtElapsed = 0

	Display(self)
end

local function OnEvent(self, event, ...)
	local hold = E.db.mMediaTag.datatexts.time.hold_delay
	local _, instanceType = GetInstanceInfo()
	local inArena = instanceType == "arena"

	if event == "ELVUI_FORCE_UPDATE" then Connect(self) end

	if inArena and event == "START_TIMER" then
		combatStart, inCombat, holdUntil = GetTime() + (select(2, ...) or 0), true, nil
	elseif event == "ENCOUNTER_START" then
		combatStart, inCombat, holdUntil, inEncounter = GetTime(), true, nil, true
	elseif event == "ENCOUNTER_END" then
		inCombat, holdUntil, inEncounter = false, GetTime() + hold, nil
	elseif not inArena and not inEncounter and event == "PLAYER_REGEN_DISABLED" then
		combatStart, inCombat, holdUntil = GetTime(), true, nil
	elseif not inArena and not inEncounter and event == "PLAYER_REGEN_ENABLED" then
		inCombat, holdUntil = false, GetTime() + hold
	elseif event and timeDT and self.mmtTimeFrame then
		timeDT.eventFunc(self.mmtTimeFrame, event)
	end

	Display(self)
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMediaTag.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	local valueHex = E.db.mMediaTag.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or hex
	textString = strjoin("", textHex, "%s|r")
	valueString = strjoin("", valueHex, "%s|r")

	Connect(self)
	if timeDT and self.mmtTimeFrame then timeDT.applySettings(self.mmtTimeFrame, valueHex) end

	OnEvent(self)
end

DT:RegisterDatatext( "mMT - Time", mMT.Name, { "START_TIMER", "ENCOUNTER_START", "ENCOUNTER_END", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "LOADING_SCREEN_ENABLED", "UPDATE_INSTANCE_INFO", "BOSS_KILL" }, OnEvent, OnUpdate, OnClick, OnEnter, OnLeave, L["Time"], nil, ValueColorUpdate )
