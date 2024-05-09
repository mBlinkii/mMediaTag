local E = unpack(ElvUI)

SLASH_MMT1 = "/mmt"
SlashCmdList.MMT = function(msg, editBox)
	msg = strlower(msg)
	if msg == "dev" and not mMT.DevMode and mMT.DEVNames[UnitName("player")] then
		mMT:Print("|CFFFFC900DEV - Tools:|r |CFF00E360Enabled|r")
		mMT.DevMode = true
		mMT.DB.dev.enabled = true
		mMT:DevTools()
	elseif msg == "dev" and mMT.DevMode then
		mMT:Print("|CFFFFC900DEV - Tools:|r |CFFF62A0ADisabled|r")
		mMT.DevMode = false
		mMT.DB.dev.enabled = false
		mMT:DevTools()
	elseif msg == "debug" or msg == "debug safe" then
		mMT.DB.debugMode = not mMT.DB.debugMode
		mMT:SetDebugMode(mMT.DB.debugMode, msg == "debug safe")
	else
		if not InCombatLockdown() then
			E:ToggleOptions("mMT")
			HideUIPanel(_G["GameMenuFrame"])
		end
	end
end
