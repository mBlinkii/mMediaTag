local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local DT = E:GetModule("DataTexts");
local addon, ns = ...

--Lua functions
local format = format
local pi = math.pi

--Variables
local mText = format("Dock %s", L["Itemlevel"])
local mTextName = "mItemLevel"
local r, g, b = 1, 1, 1

local function colorize(num)
	if num >= 0 then
		return .1, 1, .1
	else
		return E:ColorGradient(-(pi/num), 1, .1, .1, 1, 1, .1, .1, 1, .1)
	end
end

local function mDockCheckFrame()
	return ( CharacterFrame and CharacterFrame:IsShown() )
end

function mMT:CheckFrameItemlevel(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameItemlevel")

	if E.db[mPlugin].mDock.tip.enable then
        DT.tooltip:ClearLines()
		local avg, avgEquipped, avgPvp = GetAverageItemLevel()
		DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format('%0.2f', avg), 1, 1, 1, .1, 1, .1)
		DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format('%0.2f', avgEquipped), 1, 1, 1, colorize(avgEquipped - avg))
		DT.tooltip:AddDoubleLine(LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT, format('%0.2f', avgPvp), 1, 1, 1, colorize(avgPvp - avg))

		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = E.db[mPlugin].mDock.itemlevel.path,
		Notifications = false,
		Text = true,
		Center = false,
		Spezial = true,
		OnlyText = E.db[mPlugin].mDock.itemlevel.onlytext,
	}

	mMT:DockInitialisation(self)

	local Color = E.db[mPlugin].mDock.itemlevel.color
	local TextColor = mMT:mClassColorString()

    local avg, avgEquipped = GetAverageItemLevel()
    if Color == "default" then
        local r, g, b = E:ColorGradient(mMT:round((avgEquipped/260)*100 or 0) * .01, 0, 1, .11, 0, .4, .8, .63, .18, .78)
		TextColor = strjoin("", E:RGBToHex(r, g, b), "%s|r")
    elseif Color == "custom" then
		r, g, b = E.db[mPlugin].mDock.fontcolor.r, E.db[mPlugin].mDock.fontcolor.g, E.db[mPlugin].mDock.fontcolor.b
		TextColor = strjoin("", E:RGBToHex(r, g, b), "%s|r")
	end

	if self.mSettings.OnlyText then
		self.text:SetText(format("%s%s", E.db[mPlugin].mDock.itemlevel.text, format(TextColor, mMT:round(avgEquipped or 0))))
	else
		if self.text ~= "" then
			self.text:SetText("")
		end
		self.mIcon.TextA:SetFormattedText(TextColor, mMT:round(avgEquipped or 0))
		self.mIcon.TextB:SetText(E.db[mPlugin].mDock.itemlevel.text)
	end
end

local function OnLeave(self)
	if E.db[mPlugin].mDock.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:mOnClick(self, "CheckFrameItemlevel")
		ToggleCharacter("PaperDollFrame")
	end
end

DT:RegisterDatatext(mTextName, "mDock", {'UPDATE_INVENTORY_DURABILITY', 'MERCHANT_SHOW'}, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)