local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:NewModule(mPlugin, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local EP = _G.LibStub("LibElvUIPlugin-1.0")
local addon, ns = ...

--Variables
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

-- addon laden
function mMT:Initialize()
	mMT:mMisc() -- module laden

	if E.Retail then
		if E.db[mPlugin].mHealthmarker.enable or E.db[mPlugin].mExecutemarker.enable then
			mMT:StartNameplateTools()
		end
		mMT:RegisterEvent("PLAYER_ENTERING_WORLD") -- events registrieren
		mMT:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED") -- events registrieren
	end

	EP:RegisterPlugin(addon, mMT:AddOptions()) -- einstellungen in elvui eintragen
	ns.Config = {} -- tabele löschen
end

function mMT:PLAYER_ENTERING_WORLD()
	if E.Retail then
		if E.db[mPlugin] then
			if E.db[mPlugin].mRoleSymbols.enable then
				mMT:mStartRoleSmbols() -- rolensymbole ändern
			end
		end
	end
end

function mMT:ACTIVE_TALENT_GROUP_CHANGED()
	if E.Retail then
		mMT:mUpdateKick() -- castbar kick/ kick auf cd
	end
end

E:RegisterModule(mMT:GetName()) -- addin in elvui registrieren
