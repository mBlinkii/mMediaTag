local E = unpack(ElvUI)

local DEVNames = {
	["Blinkii"] = true,
	["Flinkii"] = true,
	["Raeldan"] = true,
}

SLASH_MMT1 = "/mmt"
SlashCmdList.MMT = function(msg, editBox)
	msg = strlower(msg)

	if msg == "dev" and (not mMT.DevMode) and DEVNames[UnitName("player")] then
		mMT:Print("|CFFFFC900DEV - Tools:|r |CFF00E360enabld|r")
		mMT.DevMode = true
	elseif	msg == "dev" and mMT.DevMode then
		mMT:Print("|CFFFFC900DEV - Tools:|r |CFFF62A0Adisabled|r")
		mMT.DevMode = false
	else
		if not InCombatLockdown() then
			E:ToggleOptions("mMT")
			HideUIPanel(_G["GameMenuFrame"])
		end
	end
end
