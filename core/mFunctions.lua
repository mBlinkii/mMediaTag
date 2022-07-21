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

		if E.db[mPlugin].mObjectiveTracker.header.eltreumui then
			if IsAddOnLoaded('ElvUI_EltreumUI') then
				ns.eltreumui = true
				ns.unitframecustomgradients = {
					["WARRIOR"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.warriorcustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.warriorcustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.warriorcustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.warriorcustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.warriorcustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.warriorcustomcolorB2},
					["PALADIN"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.paladincustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.paladincustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.paladincustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.paladincustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.paladincustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.paladincustomcolorB2},
					["HUNTER"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.huntercustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.huntercustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.huntercustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.huntercustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.huntercustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.huntercustomcolorB2},
					["ROGUE"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.roguecustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.roguecustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.roguecustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.roguecustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.roguecustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.roguecustomcolorB2},
					["PRIEST"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.priestcustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.priestcustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.priestcustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.priestcustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.priestcustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.priestcustomcolorB2},
					["DEATHKNIGHT"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.deathknightcustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.deathknightcustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.deathknightcustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.deathknightcustomcolorR2, g2= E.db.ElvUI_EltreumUI.gradientmode.deathknightcustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.deathknightcustomcolorB2},
					["SHAMAN"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.shamancustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.shamancustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.shamancustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.shamancustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.shamancustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.shamancustomcolorB2},
					["MAGE"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.magecustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.magecustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.magecustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.magecustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.magecustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.magecustomcolorB2},
					["WARLOCK"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.warlockcustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.warlockcustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.warlockcustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.warlockcustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.warlockcustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.warlockcustomcolorB2},
					["MONK"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.monkcustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.monkcustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.monkcustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.monkcustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.monkcustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.monkcustomcolorB2},
					["DRUID"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.druidcustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.druidcustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.druidcustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.druidcustomcolorR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.druidcustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.druidcustomcolorB2},
					["DEMONHUNTER"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.demonhuntercustomcolorR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.demonhuntercustomcolorG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.demonhuntercustomcolorB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.demonhuntercustomcolorR2, g2= E.db.ElvUI_EltreumUI.gradientmode.demonhuntercustomcolorG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.demonhuntercustomcolorB2},
					["NPCFRIENDLY"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.npcfriendlyR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.npcfriendlyG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.npcfriendlyB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.npcfriendlyR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.npcfriendlyG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.npcfriendlyB2},
					["NPCNEUTRAL"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.npcneutralR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.npcneutralG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.npcneutralB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.npcneutralR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.npcneutralG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.npcneutralB2},
					["NPCUNFRIENDLY"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.npcunfriendlyR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.npcunfriendlyG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.npcunfriendlyB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.npcunfriendlyR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.npcunfriendlyG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.npcunfriendlyB2},
					["NPCHOSTILE"] = {r1 = E.db.ElvUI_EltreumUI.gradientmode.npchostileR1, g1 = E.db.ElvUI_EltreumUI.gradientmode.npchostileG1, b1 = E.db.ElvUI_EltreumUI.gradientmode.npchostileB1, r2 = E.db.ElvUI_EltreumUI.gradientmode.npchostileR2, g2 = E.db.ElvUI_EltreumUI.gradientmode.npchostileG2, b2 = E.db.ElvUI_EltreumUI.gradientmode.npchostileB2},
				}
			else
				ns.eltreumui = false
			end
		end
	end
	
	mMT:LoadTagSettings()
end

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
	if number then
    	return (("%%.%df"):format(decimals)):format(number)
	end
end