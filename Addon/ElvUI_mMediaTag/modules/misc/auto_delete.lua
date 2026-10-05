local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("AutoDelete")

local _G = _G
local hooksecurefunc = hooksecurefunc

-- DELETE_ITEM_CONFIRM_STRING is localized by the client, so this works in every language
local dialogs = {
	DELETE_GOOD_ITEM = true,
	DELETE_GOOD_QUEST_ITEM = true,
}

local function FillConfirmText(which)
	if not (module.db and module.db.enable and dialogs[which]) then return end

	local dialog = _G.StaticPopup_FindVisible(which)
	local editBox = dialog and dialog.GetEditBox and dialog:GetEditBox()
	if editBox then editBox:SetText(_G.DELETE_ITEM_CONFIRM_STRING) end
end

function module:Initialize()
	module.db = E.db.mMediaTag.auto_delete

	if not module.hooked and module.db and module.db.enable then
		hooksecurefunc("StaticPopup_Show", FillConfirmText)
		module.hooked = true
	end
end
