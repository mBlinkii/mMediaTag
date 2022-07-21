local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:NewModule(mPlugin, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");
local EP = LibStub("LibElvUIPlugin-1.0")
local addon, ns = ...
local Version = GetAddOnMetadata(addon, "Version")

--Variables
ns.mName 			= "|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r"
ns.mNameClassic 	= "|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r |cffff0066Classic|r"
ns.mVersion 		= Version
ns.mColor1 			= "|CFFFFFFFF"	-- white
ns.mColor2 			= "|CFFF7DC6F" 	-- yellow
ns.mColor3 			= "|CFF8E44AD"	-- purple
ns.mColor4 			= "|CFFFE7B2C" 	-- orange
ns.mColor5 			= "|CFFE74C3C" 	-- red
ns.mColor6 			= "|CFF58D68D" 	-- green
ns.mColor7 			= "|CFF3498DB" 	-- blue
ns.mColor8 			= "|CFFB2BABB" 	-- gray
ns.normal			= "|CFF82E0AA"	-- nomral
ns.Heroic			= "|CFF85C1E9 "	-- HC
ns.Mythic 			= "|CFFBB8FCE"	-- Mythic
ns.LeftButtonIcon 	= format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_l.tga")
ns.RightButtonIcon 	= format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_r.tga")
ns.MiddleButtonIcon = format("|T%s:16:16:0:0:32:32|t", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\mouse_m.tga")
ns.eltreumui		= false
ns.Config			= {}

--E.Media.Textures.RolesHQ = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\RolesHQ.tga"
--E.Media.Textures.RoleIcons = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\RoleIcons.tga"
--E.Media.Textures.LeaderHQ = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\LeaderHQ.tga"

function mMT:AddOptions()
	for _, func in pairs(ns.Config) do
		func()
	end
end

function mMT:Initialize()
	-- WoW Version Check
	mMT:mVersionCheck()

		-- Load Miscs
		mMT:mMisc()

	EP:RegisterPlugin(addon, mMT:AddOptions())

	mMT:RegisterEvent('PLAYER_ENTERING_WORLD')
	mMT:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
end

function mMT:PLAYER_ENTERING_WORLD()
	if MediaTagGameVersion.retail then
		E.Media.Textures.RolesHQ = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\RolesHQ.tga"
		E.Media.Textures.RoleIcons = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\RoleIcons.tga"
		E.Media.Textures.LeaderHQ = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\LeaderHQ.tga"
		if E.db[mPlugin] then
			if E.db[mPlugin].mRoleSymbols.enable then
				mMT:mStartRoleSmbols()
			end
		end
	end
end

function mMT:ACTIVE_TALENT_GROUP_CHANGED()
	if MediaTagGameVersion.retail then
		mMT:mUpdateKick()
	end
end

E:RegisterModule(mMT:GetName())