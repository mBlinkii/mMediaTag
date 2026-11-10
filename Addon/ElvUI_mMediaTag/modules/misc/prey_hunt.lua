local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM
local module = mMT:AddModule("PreyHunt")

-- Cache WoW Globals
local _G = _G
local next = next
local format = format
local hooksecurefunc = hooksecurefunc
local issecretvalue = issecretvalue
local Enum = Enum

local containers = {
	"UIWidgetPowerBarContainerFrame",
	"UIWidgetTopCenterContainerFrame",
	"UIWidgetBelowMinimapContainerFrame",
	"UIWidgetCenterScreenContainerFrame",
}

local frames = {}
local hooked = {}

local function MaxState()
	return (Enum and Enum.PreyHuntProgressState and Enum.PreyHuntProgressState.Final or 3) + 1
end

local function IsComplete(frame)
	local state = frame.progressState
	if state == nil or issecretvalue(state) then return false end

	return (state + 1) >= MaxState()
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
	local complete = IsComplete(frame)

	if complete and not db.ready then
		text:Hide()
		return
	end

	E:SetFont(text, LSM:Fetch("font", db.text.font), db.text.size, db.text.fontFlag)

	if complete then
		text:SetTextColor(MEDIA.color.green:GetRGB())
	else
		text:SetTextColor(mMT:HexToRGB(db.color))
	end

	text:ClearAllPoints()
	text:SetPoint(db.point, frame.StateTexture, db.point, db.x, db.y)
	text:SetText(complete and L["Ready"] or ProgressText(frame))
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

local function RebindProfile()
	module.db = E.db.mMediaTag.prey_hunt
end

function module:Initialize()
	module.db = E.db.mMediaTag.prey_hunt
	mMT:OnProfileSwitch(RebindProfile)

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
end
