local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

-- empty slot placeholder, only clears what a dock left on this slot
local function OnEvent(self)
	M.Dock:ReleaseDock(self)
end

DT:RegisterDatatext("mMT_Dock_None", mMT.NameShort .. " - |CFF01EEFFDock|r", nil, OnEvent, nil, nil, nil, nil, "|CFF01EEFFDock|r" .. " " .. L["None"] .. "|r", nil, nil)
