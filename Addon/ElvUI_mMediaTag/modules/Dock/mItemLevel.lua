local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
--Lua functions
local format = format
local pi = math.pi
--Variables
local _G = _G
local mText = format("Dock %s", L["Itemlevel"])
local mTextName = "mItemLevel"
local r, g, b = 1, 1, 1

local function colorize(num)
	if num >= 0 then
		return 0.1, 1, 0.1
	else
		return E:ColorGradient(-(pi / num), 1, 0.1, 0.1, 1, 1, 0.1, 0.1, 1, 0.1)
	end
end

local function mDockCheckFrame()
	return (CharacterFrame and CharacterFrame:IsShown())
end

function mMT:CheckFrameItemlevel(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnEnter(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameItemlevel")

	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:ClearLines()
		local avg, avgEquipped, avgPvp = GetAverageItemLevel()
		DT.tooltip:AddDoubleLine(STAT_AVERAGE_ITEM_LEVEL, format("%0.2f", avg), 1, 1, 1, 0.1, 1, 0.1)
		DT.tooltip:AddDoubleLine(GMSURVEYRATING3, format("%0.2f", avgEquipped), 1, 1, 1, colorize(avgEquipped - avg))
		DT.tooltip:AddDoubleLine(
			LFG_LIST_ITEM_LEVEL_INSTR_PVP_SHORT,
			format("%0.2f", avgPvp),
			1,
			1,
			1,
			colorize(avgPvp - avg)
		)

		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		text = {
			onlytext = E.db.mMT.dockdatatext.itemlevel.onlytext,
			special = true,
			textA = true,
			textB = true,
		},
		icon = {
			texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.itemlevel.icon],
			color = E.db.mMT.dockdatatext.itemlevel.iconcolor,
			customcolor = E.db.mMT.dockdatatext.itemlevel.customcolor,
		},
	}

	local color = nil
	local text = nil
	local _, avgEquipped = GetAverageItemLevel()
	text = mMT:round(avgEquipped or 0)
	if E.db.mMT.dockdatatext.itemlevel.color then
		r, g, b = GetItemLevelColor()
		color = E:RGBToHex(r, g, b)
	end

	if self.mSettings.text.onlytext then
		self.text:SetText(
			format(
				"%s %s",
				format("%s%s|r", mMT.ClassColor.hex, E.db.mMT.dockdatatext.itemlevel.text or ""),
				format("%s%s|r", color or "|cffffffff", text or 0)
			)
		)
		mMT:DockInitialization(self, event)
	else
		if self.text ~= "" then
			self.text:SetText("")
		end
		mMT:DockInitialization(self, event, text, E.db.mMT.dockdatatext.itemlevel.text, color)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
		mMT:mOnClick(self, "CheckFrameItemlevel")
		_G.ToggleCharacter("PaperDollFrame")
	end
end

DT:RegisterDatatext(
	mTextName,
	"mDock",
	{ "UPDATE_INVENTORY_DURABILITY" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	nil
)
