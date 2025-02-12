local mMT, DB, M, E, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local IsShiftKeyDown = IsShiftKeyDown
local format = format
local GameTooltip = GameTooltip
local UIParent = UIParent

function ElvUI_mMediaTag_OnAddonCompartmentClick(addonName, buttonName, menuButtonFrame)
	if IsShiftKeyDown() then
		DB.debug.debugMode = not DB.debug.debugMode
		mMT:SetDebugMode(DB.debug.debugMode, false)
	else
		E:ToggleOptions("mMT")
	end
end

function ElvUI_mMediaTag_OnAddonCompartmentEnter(addonName, menuButtonFrame)
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_RIGHT")
	GameTooltip:AddDoubleLine(mMT.Name, format("|CFFF7DC6FVer. %s|r", mMT.Version))
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(format("|CFFF7DC6F %s|r %s", L["SHIFT + Click"], L["for debug mode."])) --WIP
	GameTooltip:Show()
end

function ElvUI_mMediaTag_OnAddonCompartmentLeave(addonName, menuButtonFrame)
	GameTooltip:Hide()
end
