local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("BigWigsSkin")

local S = E:GetModule("Skins")
local LSM = E.Libs.LSM

-- Cache WoW Globals
local _G = _G
local ipairs = ipairs
local unpack = unpack
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local RETRY_DELAY = 2
local BAR_HEIGHT, BAR_OFFSET = 20, 2

-- the keystone window stays local and unnamed in BigWigs, its own title is the only stable marker
local function FindKeystoneWindow()
	local locale = _G.BigWigsAPI and _G.BigWigsAPI:GetLocale("BigWigs")
	local title = locale and locale.keystoneTitle
	if not title then return end

	for _, frame in ipairs({ _G.UIParent:GetChildren() }) do
		-- Blizzard keeps restricted frames under UIParent, every method call on them throws from addon code
		if not frame:IsForbidden() then
			local container = frame.PortraitContainer and frame.TitleContainer
			local text = container and container.TitleText

			if text and text.GetText and not text:IsForbidden() and text:GetText() == title then return frame end
		end
	end
end

local function SkinKeystoneWindow()
	if module.keystonesSkinned then return true end

	local frame = FindKeystoneWindow()
	if not frame then return end

	module.keystonesSkinned = true

	S:HandlePortraitFrame(frame)

	-- PortraitContainer is not part of ElvUI's strip list
	if frame.PortraitContainer then frame.PortraitContainer:Hide() end

	for _, child in ipairs({ frame:GetChildren() }) do
		if child.ScrollBar then
			S:HandleTrimScrollBar(child.ScrollBar)
		elseif child.LeftActive and child.Text then -- the tabs keep their selected state art on these keys
			S:HandleTab(child)
		end
	end

	return true
end

local function ApplyBarColor(frame)
	local db = module.db.color

	if db.mode == "class" then
		frame:SetStatusBarColor(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b, db.color.a)
	elseif db.mode == "custom" then
		frame:SetStatusBarColor(db.color.r, db.color.g, db.color.b, db.color.a)
	else
		frame:SetStatusBarColor(unpack(frame.mmt_color))
	end
end

local function ApplyBarStyle(frame)
	local db = module.db

	frame:SetStatusBarTexture(db.texture_enable and LSM:Fetch("statusbar", db.texture) or E.media.normTex)
	ApplyBarColor(frame)
end

local function SkinQueueTimer(frame)
	module.queueTimer = frame
	frame.mmt_color = { frame:GetStatusBarColor() } -- BigWigs' own red, for the original color mode

	frame:StripTextures() -- kills the castbar border, spark and background in one pass
	ApplyBarStyle(frame) -- the texture swap drops the color BigWigs set, so the color follows it
	frame:CreateBackdrop("Transparent")

	-- BigWigs pins a fixed 190px width, both sides follow the popup instead, inset by its border
	local popup = frame:GetParent()

	frame:ClearAllPoints()
	frame:Point("TOPLEFT", popup, "BOTTOMLEFT", E.Border, -BAR_OFFSET)
	frame:Point("TOPRIGHT", popup, "BOTTOMRIGHT", -E.Border, -BAR_OFFSET)
	frame:Height(BAR_HEIGHT)

	if frame.text then frame.text:FontTemplate() end
end

local function OnFrameCreated(_, frame, name)
	if name == "QueueTimer" and module.db.queue_timer then SkinQueueTimer(frame) end
end

function module:Initialize()
	module.db = E.db.mMediaTag.skins.bigwigs

	if not (module.db and module.db.enable) or not IsAddOnLoaded("BigWigs") then return end

	if module.queueTimer then ApplyBarStyle(module.queueTimer) end

	if module.isRegistered then return end

	module.isRegistered = true

	if module.db.keystones and not SkinKeystoneWindow() then E:Delay(RETRY_DELAY, SkinKeystoneWindow) end

	-- BigWigs announces the queue timer on the first dungeon invite, this is the callback its author asks skins to use
	if _G.BigWigsLoader then _G.BigWigsLoader.RegisterMessage(module, "BigWigs_FrameCreated", OnFrameCreated) end
end
