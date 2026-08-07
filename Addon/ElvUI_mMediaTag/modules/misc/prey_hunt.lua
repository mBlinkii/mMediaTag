local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM
local module = mMT:AddModule("PreyHunt", { "AceEvent-3.0" })

-- Cache WoW Globals
local _G = _G
local next = next
local format = format
local gsub = gsub
local strtrim = strtrim
local wipe = wipe
local hooksecurefunc = hooksecurefunc
local issecretvalue = _G.issecretvalue or function() return false end
local Enum = Enum
local GetAchievementNumCriteria = GetAchievementNumCriteria
local GetAchievementCriteriaInfo = GetAchievementCriteriaInfo

local GOTTA_HUNT_THEM_ALL = 62383 -- one criteria per prey target, account-wide

local containers = {
	"UIWidgetPowerBarContainerFrame",
	"UIWidgetTopCenterContainerFrame",
	"UIWidgetBelowMinimapContainerFrame",
	"UIWidgetCenterScreenContainerFrame",
}

local frames = {}
local hooked = {}
local targets = {}

local function MaxState()
	return (Enum and Enum.PreyHuntProgressState and Enum.PreyHuntProgressState.Final or 3) + 1
end

local function ProgressText(frame)
	local state = frame.progressState
	if state == nil or issecretvalue(state) then return "" end

	local current, total = state + 1, MaxState()
	local percent = current / total * 100

	if module.db.format == "percent" then
		return format("%d%%", percent)
	elseif module.db.format == "both" then
		return format("%d/%d (%d%%)", current, total, percent)
	end

	return format("%d/%d", current, total)
end

local function Attach(frame)
	if not frame.mMTProgress then
		local text = frame:CreateFontString(nil, "OVERLAY")
		text:SetDrawLayer("OVERLAY", 7)
		frame.mMTProgress = text
		frames[frame] = true
	end
end

local function UpdateFrame(frame)
	local db = module.db

	Attach(frame)

	local text = frame.mMTProgress
	E:SetFont(text, LSM:Fetch("font", db.font.font), db.font.size, db.font.fontFlag)
	text:SetTextColor(mMT:HexToRGB(db.color))
	text:ClearAllPoints()
	text:SetPoint(db.point, frame.StateTexture, db.point, db.x, db.y)
	text:SetText(ProgressText(frame))
	text:Show()
end

local function OnSetup(frame)
	hooked[frame] = true

	if not module.db or not module.db.enable then return end

	UpdateFrame(frame)
end

-- The XML mixin copies Setup onto each instance, so the table hook only reaches frames the pool builds afterwards.
local function HookFrame(frame)
	if not hooked[frame] then
		hooked[frame] = true
		hooksecurefunc(frame, "Setup", OnSetup)
	end

	UpdateFrame(frame)
end

local function ForEachWidget(func)
	for _, name in next, containers do
		local container = _G[name]
		if container and container.widgetFrames then
			for _, frame in next, container.widgetFrames do
				if frame.PlayTransitionAnim then func(frame) end
			end
		end
	end
end

local function UpdateTargets()
	wipe(targets)

	local count = GetAchievementNumCriteria and GetAchievementNumCriteria(GOTTA_HUNT_THEM_ALL) or 0
	for index = 1, count do
		local name, _, completed = GetAchievementCriteriaInfo(GOTTA_HUNT_THEM_ALL, index)
		if name and not issecretvalue(name) then targets[name] = not issecretvalue(completed) and completed or false end
	end
end

local function MarkButton(button)
	local text = button.GetText and button:GetText()
	if not text or issecretvalue(text) then return end

	local name = strtrim(gsub(gsub(text, "|c%x%x%x%x%x%x%x%x", ""), "|r", ""))
	if not targets[name] then return end

	-- ElvUI's gossip skin forces every SetTextColor back to white, so the color has to travel inside the string.
	button:SetText(format("|c%s%s|r", module.db.gossip_color, name))
end

local function OnGossipUpdate(scrollBox)
	if not module.db or not module.db.gossip then return end

	scrollBox:ForEachFrame(MarkButton)
end

function module:GOSSIP_SHOW()
	if not module.db or not module.db.gossip then return end

	UpdateTargets()
end

function module:Initialize()
	module.db = E.db.mMediaTag.prey_hunt

	if _G.UIWidgetTemplatePreyHuntProgressMixin then
		if module.db.enable then
			if not module.isHooked then
				hooksecurefunc(_G.UIWidgetTemplatePreyHuntProgressMixin, "Setup", OnSetup)
				module.isHooked = true
			end

			ForEachWidget(HookFrame)
		else
			for frame in next, frames do
				frame.mMTProgress:Hide()
			end
		end
	end

	local scrollBox = _G.GossipFrame and _G.GossipFrame.GreetingPanel and _G.GossipFrame.GreetingPanel.ScrollBox
	if not scrollBox then return end

	if module.db.gossip then
		if not module.isGossipHooked then
			hooksecurefunc(scrollBox, "Update", OnGossipUpdate)
			module.isGossipHooked = true
		end

		if not module.isEnabled then
			module:RegisterEvent("GOSSIP_SHOW")
			module.isEnabled = true
		end

		UpdateTargets()
	elseif module.isEnabled then
		module:UnregisterAllEvents()
		module.isEnabled = false
	end
end
