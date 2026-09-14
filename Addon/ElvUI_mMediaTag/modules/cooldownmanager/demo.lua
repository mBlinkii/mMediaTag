local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:GetModule("CooldownManager")

-- Cache WoW Globals
local ipairs = ipairs
local pairs = pairs
local format = format
local CreateFrame = CreateFrame
local GetTime = GetTime

local COUNTS = { essential = 8, utility = 6, buff_icon = 6, buff_bar = 4 }

local TEXTURES = {
	"Interface\\Icons\\Spell_Nature_Lightning",
	"Interface\\Icons\\Spell_Fire_FlameBolt",
	"Interface\\Icons\\Spell_Holy_HolyBolt",
	"Interface\\Icons\\Spell_Frost_FrostBolt02",
	"Interface\\Icons\\Spell_Shadow_ShadowBolt",
	"Interface\\Icons\\Ability_Warrior_Charge",
	"Interface\\Icons\\Ability_Rogue_Sprint",
	"Interface\\Icons\\Spell_Nature_Regeneration",
}

local KEYBINDS = { "1", "2", "3", "4", "S1", "S2", "C1", "C2" }

local frames = {}

local function CreateIcon(parent, key)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetFrameLevel(parent:GetFrameLevel() + 2)
	frame.mmtViewerKey = key

	frame.Icon = frame:CreateTexture(nil, "ARTWORK")
	frame.Icon:SetAllPoints(frame)
	frame.Icon:CreateBackdrop()

	frame.Cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
	frame.Cooldown:SetAllPoints(frame)
	frame.Cooldown:SetDrawEdge(false)
	frame.Cooldown.mmtDemo = true
	frame.Cooldown.mmtText = frame.Cooldown:CreateFontString(nil, "OVERLAY", "GameFontNormal")

	frame.Count = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")

	return frame
end

local function CreateBar(parent, key)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetFrameLevel(parent:GetFrameLevel() + 2)
	frame.mmtViewerKey = key

	frame.Icon = CreateFrame("Frame", nil, frame)
	frame.Icon.Icon = frame.Icon:CreateTexture(nil, "ARTWORK")
	frame.Icon.Icon:SetAllPoints(frame.Icon)
	frame.Icon.Icon:CreateBackdrop()
	frame.Icon.Count = frame.Icon:CreateFontString(nil, "OVERLAY", "GameFontNormal")

	frame.Bar = CreateFrame("StatusBar", nil, frame)
	frame.Bar:SetStatusBarTexture(E.media.normTex)
	frame.Bar:SetMinMaxValues(0, 1)

	frame.Bar.BarBG = frame.Bar:CreateTexture(nil, "BACKGROUND")
	frame.Bar.BarBG:CreateBackdrop("Transparent")
	frame.Bar.BarBG.backdrop:SetOutside()

	frame.Bar.Name = frame.Bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	frame.Bar.Duration = frame.Bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")

	return frame
end

local function FillIcon(frame, index, vdb)
	frame.Icon:SetTexture(TEXTURES[(index - 1) % #TEXTURES + 1])
	frame.Icon:SetTexCoord(E:GetTexCoords())

	frame.Cooldown:SetCooldown(GetTime() - index * 2, 30)
	frame.Cooldown.mmtText:SetText(30 - index * 2)
	frame.Count:SetText((index % 3 == 0 and index) or "")

	frame.mmtDemoKey = KEYBINDS[(index - 1) % #KEYBINDS + 1]
	frame.mmtDemoGlow = index == 1 and vdb.glow and vdb.glow.enable or nil
end

local function FillBar(frame, index, _)
	frame.Icon.Icon:SetTexture(TEXTURES[(index - 1) % #TEXTURES + 1])
	frame.Icon.Icon:SetTexCoord(E:GetTexCoords())
	frame.Icon.Count:SetText((index % 2 == 0 and index) or "")

	frame.Bar:SetValue(1 - index * 0.18)
	frame.Bar.Name:SetText(format("%s %d", L["Buff Name"], index))
	frame.Bar.Duration:SetText(format("%.1fs", 18 - index * 3.5))
end

function module:DemoFrames(key)
	return module.demoActive and frames[key] or nil
end

local function Build(key)
	local container = module.containers[key]
	if not container then return end

	local list = frames[key]
	if not list then
		list = {}
		frames[key] = list
	end

	local vdb = module:ViewerDB(key)
	local isBar = key == "buff_bar"

	for index = 1, COUNTS[key] do
		local frame = list[index]
		if not frame then
			frame = (isBar and CreateBar(container, key)) or CreateIcon(container, key)
			list[index] = frame
		end

		if isBar then
			FillBar(frame, index, vdb)
		else
			FillIcon(frame, index, vdb)
		end

		module.styled[frame] = nil
		frame:Show()
	end
end

local function Clear(key)
	local list = frames[key]
	if not list then return end

	for _, frame in ipairs(list) do
		module:StopGlow(frame)
		module:SetPandemic(frame, false)
		frame:Hide()
	end
end

-- Blizzards viewers are hidden while the demo runs, showing them again re-registers their events
function module:SetDemo(enabled)
	if module.demoActive == enabled then return end
	if enabled and module:IsDisabled() then return end
	module.demoActive = enabled

	for key in pairs(COUNTS) do
		if module.containers[key] and module:IsManaged(key) then
			local viewer = module:GetViewer(key)
			if viewer then viewer:SetShown(not enabled) end

			if enabled then
				Build(key)
			else
				Clear(key)
			end
		end
	end

	module:Refresh()

	if not enabled then return end

	for _, key in ipairs({ "buff_icon", "buff_bar" }) do
		local list = frames[key]
		if list and list[1] then module:SetPandemic(list[1], true) end
	end
end

-- Option changes run through Refresh, so the placeholder data has to be rebuilt with them
function module:RefreshDemo()
	if not module.demoActive then return end

	for key in pairs(COUNTS) do
		if module.containers[key] and module:IsManaged(key) then Build(key) end
	end
end

function module:ToggleDemo()
	module:SetDemo(not module.demoActive)
end
