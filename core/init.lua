local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:NewModule(mPlugin, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local EP = _G.LibStub("LibElvUIPlugin-1.0")
local addon, ns = ...

--Variables
local wipe = table.wipe
ns.mName = "|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r"
ns.mNameClassic = "|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r |cffff0066Classic|r"
ns.mColor1 = "|CFFFFFFFF" -- white
ns.mColor2 = "|CFFF7DC6F" -- yellow
ns.mColor3 = "|CFF8E44AD" -- purple
ns.mColor4 = "|CFFFE7B2C" -- orange
ns.mColor5 = "|CFFE74C3C" -- red
ns.mColor6 = "|CFF58D68D" -- green
ns.mColor7 = "|CFF3498DB" -- blue
ns.mColor8 = "|CFFB2BABB" -- gray
ns.normal = "|CFF82E0AA" -- nomral
ns.Heroic = "|CFF85C1E9 " -- HC
ns.Mythic = "|CFFBB8FCE" -- Mythic
ns.mVersion = GetAddOnMetadata(addon, "Version") -- addon version
ns.LeftButtonIcon = format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_l.tga") -- maus icon für ttip
ns.RightButtonIcon = format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_r.tga") -- maus icon für ttip
ns.MiddleButtonIcon = format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_m.tga") -- maus icon für ttip
ns.Config = {} -- addon einstellung werden hier gesammelt

-- einstellungen in elvui eintragen
function mMT:AddOptions()
	for _, func in pairs(ns.Config) do
		func()
	end
end

function mMT:Check_ElvUI_EltreumUI()
	return (IsAddOnLoaded("ElvUI_EltreumUI") and E.db.ElvUI_EltreumUI.unitframes.gradientmode.enable)
end

-- addon laden
function mMT:Initialize()
	if E.db[mPlugin].mCustomClassColors.enable and not mMT:Check_ElvUI_EltreumUI() then
		mMT:SetCustomColors()
	end

	if E.db[mPlugin].mCustomClassColors.emediaenable then
		mMT:SetElvUIMediaColor()
	end

	mMT:mMisc() -- module laden

	if E.Retail then
		if E.db[mPlugin].mHealthmarker.enable or E.db[mPlugin].mExecutemarker.enable then
			mMT:StartNameplateTools()
		end

		if E.db[mPlugin].mRoleSymbols.enable then
			mMT:RegisterEvent("PLAYER_ENTERING_WORLD") -- events registrieren
		end

		if E.db[mPlugin].mExecutemarker.auto or E.db[mPlugin].mCastbar.enable then
			mMT:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED") -- events registrieren
		end

		if E.db[mPlugin].mInstanceDifficulty.enable then
			mMT:RegisterEvent("UPDATE_INSTANCE_INFO")
			mMT:RegisterEvent("CHALLENGE_MODE_START")
			mMT:SetupInstanceDifficulty()
		end
	end

	EP:RegisterPlugin(addon, mMT:AddOptions()) -- einstellungen in elvui eintragen
	ns.Config = wipe(ns.Config) -- tabele löschen
end

function mMT:PLAYER_ENTERING_WORLD()
	if E.db[mPlugin] then
		if E.db[mPlugin].mRoleSymbols.enable then
			mMT:mStartRoleSmbols() -- rolensymbole ändern
		end
	end
end

function mMT:ACTIVE_TALENT_GROUP_CHANGED()
	if E.db[mPlugin].mCastbar.enable then
		mMT:mUpdateKick() -- castbar kick/ kick auf cd
	end

	if E.db[mPlugin].mExecutemarker.auto then
		mMT:updateAutoRange()
	end
end

function mMT:UPDATE_INSTANCE_INFO()
	mMT:UpdateText()
end

function mMT:CHALLENGE_MODE_START()
	mMT:UpdateText()
end

E:RegisterModule(mMT:GetName()) -- addon in elvui registrieren
