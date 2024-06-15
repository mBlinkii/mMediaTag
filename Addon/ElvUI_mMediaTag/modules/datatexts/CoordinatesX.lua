local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

local _G = _G
local format = format
local InCombatLockdown = InCombatLockdown

--Variables
local mText = format("%s X", L["Coords"])
local hexColor = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
local inRestrictedArea = false
local mapInfo = E.MapInfo

local function Update(self, elapsed)
	if inRestrictedArea or not mapInfo.coordsWatching then
		return
	end

	self.timeSinceUpdate = (self.timeSinceUpdate or 0) + elapsed

	if self.timeSinceUpdate > 0.1 then
		self.text:SetFormattedText(tostring(mapInfo.xText or 0):gsub("([/.])", hexColor .. "%1|r"))
		self.timeSinceUpdate = 0
	end
end

local function OnEvent(self)
	if mapInfo.x and mapInfo.y then
		inRestrictedArea = false
		self.text:SetFormattedText(tostring(mapInfo.xText or 0):gsub("([/.])", hexColor .. "%1|r"))
	else
		inRestrictedArea = true
		self.text:SetText("N/A")
	end
end

local function Click()
	if InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
		return
	end
	_G.ToggleFrame(_G.WorldMapFrame)
end

DT:RegisterDatatext("mCoordsX", "mMediaTag", { "LOADING_SCREEN_DISABLED", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA" }, OnEvent, Update, Click, nil, nil, mText, mapInfo, nil)
