local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local _G = _G
local strjoin = strjoin
local NOT_APPLICABLE = NOT_APPLICABLE
local valueString = ""
local inRestrictedArea = false
local mapInfo = E.MapInfo

local function Update(self, elapsed)
	if inRestrictedArea or not mapInfo.coordsWatching then return end

	self.timeSinceUpdate = (self.timeSinceUpdate or 0) + elapsed

	if self.timeSinceUpdate > 0.1 then
		self.text:SetFormattedText(valueString, self.name == "mMT - Coordinate X" and (mapInfo.xText or 0) or (mapInfo.yText or 0))
		self.timeSinceUpdate = 0
	end
end

local function OnEvent(self)
	if mapInfo.x and mapInfo.y then
		inRestrictedArea = false
		self.text:SetFormattedText(valueString, self.name == "mMT - Coordinate X" and (mapInfo.xText or 0) or (mapInfo.yText or 0))
	else
		inRestrictedArea = true
		self.text:SetText(NOT_APPLICABLE)
	end
end

local function Click()
	if not E:AlertCombat() then
		_G.ToggleFrame(_G.WorldMapFrame)
	end
end

local function ValueColorUpdate(self, hex)
	local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or hex

	valueString = strjoin("", valueHex, "%.2f|r")
	OnEvent(self)
end

DT:RegisterDatatext( "mMT - Coordinate X", mMT.Name, { "LOADING_SCREEN_DISABLED", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA" }, OnEvent, Update, Click, nil, nil, L["Coordinate X"], mapInfo, ValueColorUpdate)
DT:RegisterDatatext( "mMT - Coordinate Y", mMT.Name, { "LOADING_SCREEN_DISABLED", "ZONE_CHANGED", "ZONE_CHANGED_INDOORS", "ZONE_CHANGED_NEW_AREA" }, OnEvent, Update, Click, nil, nil, L["Coordinate Y"], mapInfo, ValueColorUpdate)
