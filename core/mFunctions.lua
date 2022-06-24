local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local addon, ns = ...

--Lua functions
local tinsert = tinsert
local format = format
local tonumber = tonumber

--WoW API / Variables
local _G = _G

function mMT:mVersionCheck()
	local mElvVer = tonumber(E.version)
	local mMinVer = MediaTagGameVersion.elvui
	
	if mElvVer ~= nil then
		if mElvVer < mMinVer then
			local mErrorText = format(L["%sYour ElvUI (Ver. %s) version is no longer up to date, please update it to Ver.|r %s%s|r, %sto avoid problems with|r %s|r%s.|r"],ns.mColor5, mElvVer, ns.mColor6, mMinVer, ns.mColor5, ns.mName, ns.mColor5)
			print (mErrorText)
			
			StaticPopupDialogs["mERROR"] = {
				text = mErrorText,
				button1 = "OK",
				timeout = 120,
				whileDead = true,
				hideOnEscape = true,
				preferredIndex = 3,
			}
			
			StaticPopup_Show ("mERROR")
		end
	else
		local mErrorText = format(L["%sERROR! Versioncheck Faild!|r"],ns.mColor5)
		print (mErrorText)
		
		StaticPopupDialogs["mERROR"] = {
			text = mErrorText,
			button1 = "OK",
			timeout = 120,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
		}
		
		StaticPopup_Show ("mERROR")
	end
end

function mMT:mMisc()
	if E.db[mPlugin].mMsg then
		print (format(L["Welcome to %s version |CFF8E44AD%q|r, for |cff1784d1ElvUI|r!"],ns.mName, ns.mVersion))
	end
	
	if E.private.install_complete and E.db[mPlugin].mPluginVersion ~= ns.mVersion then
		mMT:Changelog()
	end
	
	if E.db[mPlugin].mClassNameplate == true and E.private["nameplates"]["enable"] and not IsAddOnLoaded('Plater') then
		mMT:mNamePlateBorderColor()
	end
	
	if E.db[mPlugin].mTIcon then
		mMT:TipIconSetup()
	end

	mMT:mLoadTools()

	if E.db[mPlugin].VolumeDisplay.enable then
		mMT:mVolumeDisplay()
	end

	if MediaTagGameVersion.retail then
		if E.db[mPlugin].mMythicPlusTools.keys then
			mMT:mStartKeysToChatt()
		end

		if E.db[mPlugin].mObjectiveTracker.enable and E.private.skins.blizzard.enable == true and not IsAddOnLoaded('!KalielsTracker') then
			if E.private.skins.blizzard.objectiveTracker == false then
				StaticPopupDialogs["mErrorSkin"] = {
					text = L["ElvUI skin must be enabled to activate mMediaTag Quest skins! Should it be activated?"],
					button1 = L["Yes"],
					button2 = L["No"],
					timeout = 120,
					whileDead = true,
					hideOnEscape = false,
					preferredIndex = 3,
					OnAccept = function()
						E.private.skins.blizzard.objectiveTracker = true
						C_UI.Reload()
					end,
					OnCancel = function()
						E.db[mPlugin].mObjectiveTracker.enable = false
						C_UI.Reload()
					end,
				}
				
				StaticPopup_Show ("mErrorSkin")
			end
			
			mMT:InitializemOBT()
		end

		if E.db[mPlugin].mCastbar.enable then
			mMT:mSetupCastbar()
		end
	end
	
	mMT:LoadTagSettings()
end

local mMediaTagLoader = CreateFrame('Frame')
--mMediaTagLoader:RegisterEvent('ADDON_LOADED')
mMediaTagLoader:RegisterEvent('PLAYER_ENTERING_WORLD')
mMediaTagLoader:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
mMediaTagLoader:SetScript('OnEvent', function(self, event)
	if MediaTagGameVersion.retail then
		if E.db[mPlugin].mRoleSymbols.enable then
			mMT:mStartRoleSmbols()
		end

		if event == "ACTIVE_TALENT_GROUP_CHANGED" then
			mMT:mUpdateKick()
		end
	end
end)

function mMT:mBackupNameplateSettings()
	if not E.db[mPlugin].mBackup then
		E.db[mPlugin].mBackupHover.cb = E.db["nameplates"]["colors"]["glowColor"]["b"]
		E.db[mPlugin].mBackupHover.cg = E.db["nameplates"]["colors"]["glowColor"]["r"]
		E.db[mPlugin].mBackupHover.cr = E.db["nameplates"]["colors"]["glowColor"]["g"]
		E.db[mPlugin].mBackupHover.bb = E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["b"]
		E.db[mPlugin].mBackupHover.bg = E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["g"]
		E.db[mPlugin].mBackupHover.br = E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["r"]
		E.db[mPlugin].mBackupHoverBorder = E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["border"]
		E.db[mPlugin].mBackup = true
	end
end

function mMT:mRestoreNameplateSettings()
	if E.db[mPlugin].mBackup then
		E.db["nameplates"]["colors"]["glowColor"]["b"] = E.db[mPlugin].mBackupHover.cb
		E.db["nameplates"]["colors"]["glowColor"]["r"] = E.db[mPlugin].mBackupHover.cg
		E.db["nameplates"]["colors"]["glowColor"]["g"] = E.db[mPlugin].mBackupHover.cr
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["b"] = E.db[mPlugin].mBackupHover.bb
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["g"] = E.db[mPlugin].mBackupHover.bg
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["r"] = E.db[mPlugin].mBackupHover.br
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["border"] = E.db[mPlugin].mBackupHoverBorder
	end
end

function mMT:mNamePlateBorderColor()
	local classColor
	classColor = E:ClassColor(E.myclass, true)
	
	if E.global["nameplates"]["filters"]["ElvUI_Target"] then
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["b"] = classColor.b
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["g"] = classColor.g
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["borderColor"]["r"] = classColor.r
		E.global["nameplates"]["filters"]["ElvUI_Target"]["actions"]["color"]["border"] = true
	end
	
	E.db["nameplates"]["colors"]["glowColor"]["b"] = classColor.b
	E.db["nameplates"]["colors"]["glowColor"]["r"] = classColor.r
	E.db["nameplates"]["colors"]["glowColor"]["g"] = classColor.g
end

function mMT:mIcon(icon) 
	return format ("|T%s:16:16:0:0:64:64:4:60:4:60|t", icon)
end

function mMT:mCurrencyLink(id)
	return format("|cffffffff|Hcurrency:%s|h|r", id)
end

function mMT:round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end