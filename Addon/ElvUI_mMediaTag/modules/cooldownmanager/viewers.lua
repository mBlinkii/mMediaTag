local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:GetModule("CooldownManager")

-- Cache WoW Globals
local hooksecurefunc = hooksecurefunc
local ipairs = ipairs
local next = next
local wipe = wipe
local tsort = table.sort
local ceil = math.ceil
local GetTime = GetTime

local LSM = module.LSM

function module:LayoutCooldownIcons(key, capture)
	local vdb = module:ViewerDB(key)

	module:LayoutIconViewer(key, capture, function(icon)
		module:HookGlow(icon)
		module:RefreshGlow(icon)
		module:ApplyKeybindText(icon, vdb)
		module:ApplyActiveState(icon, icon.GetBaseSpellID and icon:GetBaseSpellID())
	end)
end

function module:LayoutBuffIcons(capture)
	module:LayoutIconViewer("buff_icon", capture, function(icon)
		module:HookGlow(icon)
		module:RefreshGlow(icon)
	end)
end

-- Every time on a buff bar is secret in 12.1, the aura instance ID included, so the runtime is measured here
local barStart = {}
local barSeen = {}

local function StampBars(bars)
	wipe(barSeen)

	for _, frame in ipairs(bars) do
		local id = frame.cooldownID
		if id then
			barSeen[id] = true
			if not barStart[id] then barStart[id] = GetTime() end
		end
	end

	-- A bar that is gone loses its stamp and starts over on the next application
	for id in next, barStart do
		if not barSeen[id] then barStart[id] = nil end
	end
end

local function BarAge(frame)
	return frame.mmtDemoAge or (frame.cooldownID and barStart[frame.cooldownID]) or nil
end

local function BarSort(reverse)
	return function(a, b)
		local ageA, ageB = BarAge(a), BarAge(b)
		if ageA and ageB then
			if ageA ~= ageB then return (reverse and ageA > ageB) or (not reverse and ageA < ageB) end
		elseif ageA or ageB then
			return ageA ~= nil
		end

		return (a.layoutIndex or 0) < (b.layoutIndex or 0)
	end
end

local SORTERS = { TIME = BarSort(false), TIME_REVERSE = BarSort(true) }

-- Blizzard never colors the bar, its art carried the color; with an own texture the color has to come from here
local function BarColors(frame, vdb)
	local spellID = frame.GetBaseSpellID and frame:GetBaseSpellID()
	local override = spellID and module:GetSpellBarColor(spellID)
	if override and override.enable then return override.color, override.background end

	if vdb.class_color then
		local class = E:ClassColor(E.myclass)
		if class then return class, vdb.background_color end
	end

	return vdb.color, vdb.background_color
end

function module:ApplyBarStyle(frame, vdb)
	local bar = frame.Bar
	if not bar then return end

	local height = vdb.height or 20
	local showIcon = vdb.icon ~= false
	local side = frame.mmtIconSide or "LEFT"
	local icon = frame.Icon

	if icon then
		if showIcon then
			icon:Show()
			icon:ClearAllPoints()
			icon:SetSize(height, height)
			icon:SetPoint(side, frame, side, 0, 0)
			if icon.Icon then icon.Icon:SetAllPoints(icon) end
		else
			icon:Hide()
		end
	end

	bar:ClearAllPoints()
	bar:SetReverseFill(side == "RIGHT")

	if showIcon and icon then
		if side == "RIGHT" then
			bar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
			bar:SetPoint("BOTTOMRIGHT", icon, "BOTTOMLEFT", -(vdb.icon_gap or 2), 0)
		else
			bar:SetPoint("TOPLEFT", icon, "TOPRIGHT", vdb.icon_gap or 2, 0)
			bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
		end
	else
		bar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
		bar:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
	end

	local texture = bar:GetStatusBarTexture()
	if texture then
		texture:SetTexture(LSM:Fetch("statusbar", vdb.texture or "ElvUI Norm"))
		texture:ClearTextureSlice()
		texture:SetTextureSliceMode(0)
	end

	if bar.BarBG then
		bar.BarBG:SetTexture(LSM:Fetch("statusbar", vdb.texture or "ElvUI Norm"))
		bar.BarBG:ClearAllPoints()
		bar.BarBG:SetAllPoints(bar)
	end

	local color, background = BarColors(frame, vdb)
	bar:SetStatusBarColor(color.r, color.g, color.b)
	if bar.BarBG then bar.BarBG:SetVertexColor(background.r, background.g, background.b, background.a or 0.5) end

	if not frame.mmtBarColorHooked then
		frame.mmtBarColorHooked = true
		local SetColor = bar.SetStatusBarColor
		hooksecurefunc(bar, "SetStatusBarColor", function(self)
			if frame.mmtSettingColor then return end

			local settings = module:ViewerDB("buff_bar")
			if not settings then return end

			frame.mmtSettingColor = true
			local wanted = BarColors(frame, settings)
			SetColor(self, wanted.r, wanted.g, wanted.b)
			frame.mmtSettingColor = false
		end)
	end

	if bar.Pip and not bar.Pip.mmtKilled then
		bar.Pip.mmtKilled = true
		bar.Pip:SetAlpha(0)
		bar.Pip:Hide()
		hooksecurefunc(bar.Pip, "Show", function(self)
			self:SetAlpha(0)
		end)
	end

	if frame.CooldownFlash then frame.CooldownFlash:Hide() end

	if icon and not frame.mmtOverlayKilled then
		frame.mmtOverlayKilled = true
		for _, region in next, { icon:GetRegions() } do
			if region:IsObjectType("Texture") and region:GetAtlas() == "UI-HUD-CoolDownManager-IconOverlay" then region:SetAlpha(0) end
		end
	end

	if bar.Name then
		if vdb.name ~= false and vdb.name_text then
			bar.Name:Show()
			module:StyleText(bar.Name, vdb.name_text)
		else
			bar.Name:Hide()
		end
	end

	if bar.Duration then
		if vdb.timer ~= false and vdb.duration_text then
			bar.Duration:Show()
			module:StyleText(bar.Duration, vdb.duration_text)
		else
			bar.Duration:Hide()
		end
	end

	if icon and showIcon and vdb.stacks ~= false then module:ApplyCountText(icon, vdb.stacks_text) end

	module:ApplyDebuffBorder(frame, vdb)
end

local function StyleBar(frame, vdb, capture, width, height, side)
	frame:SetScale(1)
	frame:SetSize(width, height)
	frame.mmtIconSide = side

	if capture or not module.styled[frame] then
		module:ApplyBarStyle(frame, vdb)
		module.styled[frame] = "buff_bar"
		frame.mmtViewerKey = "buff_bar"
	end

	-- A pooled bar can carry a different aura on every reuse, so the glow is resolved on every pass
	module:HookPandemic(frame)
	module:RefreshGlow(frame)
end

function module:LayoutBuffBars(capture)
	local key = "buff_bar"
	local container = module.containers[key]
	local vdb = module:ViewerDB(key)
	local viewer = module:GetViewer(key)
	local demo = module:DemoFrames(key)
	if not container or not vdb or module:IsDisabled() then return end
	if not demo and not (viewer and viewer.itemFramePool) then return end

	local width = vdb.width or 200
	local height = vdb.height or 20
	local spacing = vdb.spacing or 2
	local growUp = vdb.growth == "UP"

	local bars = module.frameCache[key]
	if not bars then
		bars = {}
		module.frameCache[key] = bars
	end
	wipe(bars)

	if demo then
		for index = 1, #demo do
			bars[index] = demo[index]
		end
	else
		for frame in viewer.itemFramePool:EnumerateActive() do
			if frame and frame:IsShown() then bars[#bars + 1] = frame end
		end
	end

	StampBars(bars)
	tsort(bars, SORTERS[vdb.sort] or module.sortFunc)

	local count = #bars
	module.emptyViewers[key] = count == 0
	module:UpdateContainerShown(key)

	if count == 0 then
		module:SetContainerSize(container, width, height)
		module:AnchorToMover(key, vdb.growth)
		return
	end

	local anchor = growUp and "BOTTOMLEFT" or "TOPLEFT"
	local direction = growUp and 1 or -1

	if vdb.mirrored and count >= 2 then
		local gap = vdb.column_gap or 4
		local columnWidth = (width - gap) / 2
		local rows = ceil(count / 2)
		module:SetContainerSize(container, width, rows * height + (rows - 1) * spacing)

		for row = 0, rows - 1 do
			local left = bars[row * 2 + 1]
			local right = bars[row * 2 + 2]
			local offset = direction * row * (height + spacing)

			StyleBar(left, vdb, capture, right and columnWidth or width, height, right and "RIGHT" or "LEFT")
			left:ClearAllPoints()
			left:SetPoint(anchor, container, anchor, 0, offset)

			if right then
				StyleBar(right, vdb, capture, columnWidth, height, "LEFT")
				right:ClearAllPoints()
				right:SetPoint(anchor, container, anchor, columnWidth + gap, offset)
			end
		end
	else
		module:SetContainerSize(container, width, count * height + (count - 1) * spacing)

		for index, frame in ipairs(bars) do
			StyleBar(frame, vdb, capture, width, height, "LEFT")
			frame:ClearAllPoints()
			frame:SetPoint(anchor, container, anchor, 0, direction * (index - 1) * (height + spacing))
		end
	end

	module:AnchorToMover(key, vdb.growth)
end
