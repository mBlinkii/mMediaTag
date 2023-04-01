local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format

--WoW API / Variables
local _G = _G
local C_ChallengeMode = C_ChallengeMode
local C_MythicPlus = C_MythicPlus
local IsInInstance = IsInInstance
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded

--Variables
local mText = L["Game Menu"]
local menuList = {}
local menuFrame = CreateFrame("Frame", "mSystemMenu", E.UIParent, "BackdropTemplate")
local mIconPath = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\colored\\%s.tga"
local sizeString = ":16:16:0:0:64:64:4:60:4:60"
local mIconCHARACTER = E:TextureString(format(mIconPath, "colored71"), sizeString)
local mIconSPELLBOOK = E:TextureString(format(mIconPath, "colored74"), sizeString)
local mIconTALENTS = E:TextureString(format(mIconPath, "colored11"), sizeString)
local mIconACHIEVEMENT = E:TextureString(format(mIconPath, "colored73"), sizeString)
local mIconGARRISON = E:TextureString(format(mIconPath, "colored40"), sizeString)
local mIconCOLLECTIONS = E:TextureString(format(mIconPath, "colored41"), sizeString)
local mIconCALENDAR = E:TextureString(format(mIconPath, "colored14"), sizeString)
local mIconTIME = E:TextureString(format(mIconPath, "colored72"), sizeString)
local mIconGUILD = E:TextureString(format(mIconPath, "colored59"), sizeString)
local mIconSOCIAL = E:TextureString(format(mIconPath, "colored76"), sizeString)
local mIconLFG = E:TextureString(format(mIconPath, "colored27"), sizeString)
local mIconJOURNAL = E:TextureString(format(mIconPath, "colored47"), sizeString)
local mIconElvUI = E:TextureString(format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\elvui.tga"), sizeString)
local mIconMAINMENU = E:TextureString(format(mIconPath, "colored33"), sizeString)
local mIconSTORE = E:TextureString(format(mIconPath, "colored9"), sizeString)
local mIconHELP = E:TextureString(format(mIconPath, "colored54"), sizeString)

menuFrame:SetTemplate("Transparent", true)

local function mColor(color)
	local mSetting = E.db[mPlugin].mMenuColor
	if mSetting then
		if color == 1 then
			return ns.mColor1
		elseif color == 2 then
			return ns.mColor2
		elseif color == 3 then
			return ns.mColor3
		elseif color == 4 then
			return ns.mColor4
		elseif color == 5 then
			return ns.mColor5
		elseif color == 6 then
			return ns.mColor6
		elseif color == 7 then
			return ns.mColor7
		end
	else
		return ns.mColor1
	end
end

local function OnEvent(self)
	local TextString = mText
	if E.db[mPlugin].SystemMenu.showicon then
		TextString =
			format("|T%s:16:16:0:0:128:128|t %s", "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\colored\\colored57.tga", mText)
	end

	if E.db[mPlugin].InstancInfoName and E.Retail then
		local inInstance, _ = IsInInstance()
		if inInstance then
			if C_MythicPlus.IsMythicPlusActive() and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil) then
				self.text:SetText(format("%s +%s", mMT:DungeonInfoName(), mMT:MythPlusDifficultyShort()))
			else
				self.text:SetText(mMT:DungeonInfoName())
			end
		else
			self.text:SetFormattedText(mMT:mClassColorString(), TextString)
		end
	else
		self.text:SetFormattedText(mMT:mClassColorString(), TextString)
	end
end

local function mMenuIcons(icon)
	if E.db[mPlugin].SystemMenu.icons then
		return icon
	else
		return ""
	end
end

local function OnClick(self, button)
	DT.tooltip:Hide()
	if button == "LeftButton" then
		if E.Retail then
			menuList = {
				{
					text = format("%s %s%s|r", mMenuIcons(mIconCHARACTER), mColor(2), CHARACTER_BUTTON),
					isTitle = false,
					func = function()
						ToggleCharacter("PaperDollFrame")
					end,
				},
				{
					text = format("%s %s%s|r", mMenuIcons(mIconSPELLBOOK), mColor(2), SPELLBOOK_ABILITIES_BUTTON),
					isTitle = false,
					func = function()
						if not SpellBookFrame:IsShown() then
							ShowUIPanel(SpellBookFrame)
						else
							HideUIPanel(SpellBookFrame)
						end
					end,
				},
				{
					text = format("%s %s%s|r", mMenuIcons(mIconTALENTS), mColor(2), TALENTS_BUTTON),
					isTitle = false,
					func = function()
						local frame = _G.ClassTalentFrame
						if not frame then
							LoadAddOn('Blizzard_ClassTalentUI')
							frame = _G.ClassTalentFrame
						end

						if frame:IsShown() then
							HideUIPanel(frame)
						else
							ShowUIPanel(frame)
						end
					end,
				},
				{
					text = format("%s %s%s|r", mMenuIcons(mIconACHIEVEMENT), mColor(2), ACHIEVEMENT_BUTTON),
					isTitle = false,
					func = function()
						ToggleAchievementFrame()
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s %s%s|r", mMenuIcons(mIconGARRISON), mColor(7), GARRISON_LANDING_PAGE_TITLE),
					isTitle = false,
					func = function()
						GarrisonLandingPageMinimapButton_OnClick()
					end,
				},
				{
					text = format("%s %s%s|r", mMenuIcons(mIconCOLLECTIONS), mColor(7), COLLECTIONS),
					isTitle = false,
					func = function()
						ToggleCollectionsJournal()
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s %s%s|r", mMenuIcons(mIconTIME), mColor(1), TIMEMANAGER_TITLE),
					isTitle = false,
					func = function()
						ToggleFrame(TimeManagerFrame)
					end,
				},
				{
					text = format("%s %s%s|r", mMenuIcons(mIconCALENDAR), mColor(1), L["Calendar"]),
					isTitle = false,
					func = function()
						GameTimeFrame:Click()
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s %s%s|r", mMenuIcons(mIconSOCIAL), mColor(6), SOCIAL_BUTTON),
					isTitle = false,
					func = function()
						ToggleFriendsFrame()
					end,
				},
				{
					text = format("%s %s%s|r", mMenuIcons(mIconGUILD), mColor(6), ACHIEVEMENTS_GUILD_TAB),
					isTitle = false,
					func = function()
						ToggleGuildFrame()
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s %s%s|r", mMenuIcons(mIconLFG), mColor(7), LFG_TITLE),
					isTitle = false,
					func = function()
						ToggleLFDParentFrame()
					end,
				},
				{
					text = format("%s %s%s|r", mMenuIcons(mIconJOURNAL), mColor(7), ENCOUNTER_JOURNAL),
					isTitle = false,
					func = function()
						if not IsAddOnLoaded("Blizzard_EncounterJournal") then
							EncounterJournal_LoadUI()
						end
						ToggleFrame(EncounterJournal)
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s %s%s|r", mMenuIcons(mIconElvUI), mColor(4), "ElvUI"),
					isTitle = false,
					func = function()
						if InCombatLockdown() then
							_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
							return
						end
						E:ToggleOptions()
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s %s%s|r", mMenuIcons(mIconMAINMENU), mColor(1), MAINMENU_BUTTON),
					isTitle = false,
					func = function()
						if not _G.GameMenuFrame:IsShown() then
							if not E.Retail then
								if _G.VideoOptionsFrame:IsShown() then
									_G.VideoOptionsFrameCancel:Click()
								elseif _G.AudioOptionsFrame:IsShown() then
									_G.AudioOptionsFrameCancel:Click()
								elseif _G.InterfaceOptionsFrame:IsShown() then
									_G.InterfaceOptionsFrameCancel:Click()
								end
							end
			
							CloseMenus()
							CloseAllWindows()
							PlaySound(850) --IG_MAINMENU_OPEN
							ShowUIPanel(_G.GameMenuFrame)
						else
							PlaySound(854) --IG_MAINMENU_QUIT
							HideUIPanel(_G.GameMenuFrame)
			
							if E.Retail then
								MainMenuMicroButton:SetButtonState("NORMAL")
							else
								MainMenuMicroButton_SetNormal()
							end
						end
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s %s%s|r", mMenuIcons(mIconSTORE), mColor(5), BLIZZARD_STORE),
					isTitle = false,
					func = function()
						StoreMicroButton:Click()
					end,
				},
				{
					text = format("%s %s%s|r", mMenuIcons(mIconHELP), mColor(5), HELP_BUTTON),
					isTitle = false,
					func = function()
						ToggleHelpFrame()
					end,
				},
			}
		else
			menuList = {
				{
					text = format("%s%s|r", mColor(2), CHARACTER_BUTTON),
					isTitle = false,
					func = function()
						ToggleCharacter("PaperDollFrame")
					end,
				},
				{
					text = format("%s%s|r", mColor(2), SPELLBOOK_ABILITIES_BUTTON),
					isTitle = false,
					func = function()
						if not SpellBookFrame:IsShown() then
							ShowUIPanel(SpellBookFrame)
						else
							HideUIPanel(SpellBookFrame)
						end
					end,
				},
				{
					text = format("%s%s|r", mColor(2), TALENTS_BUTTON),
					isTitle = false,
					func = function()
						if not PlayerTalentFrame then
							TalentFrame_LoadUI()
						end

						if not PlayerTalentFrame:IsShown() then
							ShowUIPanel(PlayerTalentFrame)
						else
							HideUIPanel(PlayerTalentFrame)
						end
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s%s|r", mColor(1), TIMEMANAGER_TITLE),
					isTitle = false,
					func = function()
						ToggleFrame(TimeManagerFrame)
					end,
				},

				{ text = "", isTitle = true, func = function() end },

				{
					text = format("%s%s|r", mColor(6), SOCIAL_BUTTON),
					isTitle = false,
					func = function()
						ToggleFriendsFrame()
					end,
				},
				{
					text = format("%s%s|r", mColor(6), ACHIEVEMENTS_GUILD_TAB),
					isTitle = false,
					func = function()
						ToggleGuildFrame()
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s%s|r", mColor(4), "ElvUI"),
					isTitle = false,
					func = function()
						if InCombatLockdown() then
							_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
							return
						end
						E:ToggleOptions()
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s%s|r", mColor(1), MAINMENU_BUTTON),
					isTitle = false,
					func = function()
						if not GameMenuFrame:IsShown() then
							if VideoOptionsFrame:IsShown() then
								VideoOptionsFrameCancel:Click()
							elseif AudioOptionsFrame:IsShown() then
								AudioOptionsFrameCancel:Click()
							elseif InterfaceOptionsFrame:IsShown() then
								InterfaceOptionsFrameCancel:Click()
							end
							CloseMenus()
							CloseAllWindows()
							ShowUIPanel(GameMenuFrame)
						else
							HideUIPanel(GameMenuFrame)
							MainMenuMicroButton_SetNormal()
						end
					end,
				},

				{ text = "", isTitle = true, notClickable = true, func = function() end },

				{
					text = format("%s%s|r", mColor(5), HELP_BUTTON),
					isTitle = false,
					func = function()
						ToggleHelpFrame()
					end,
				},
			}
		end

		mMT:mDropDown(menuList, menuFrame, self, 160, 2)
		menuList = wipe(menuList)
	elseif E.Retail then
		ToggleLFDParentFrame()
	end
end

local function OnEnter(self)
	local nhc, hc, myth, mythp, other, titel, tip = mMT:mColorDatatext()

	DT.tooltip:AddLine(mText)
	if E.db[mPlugin].InstancInfoToolTip then
		if E.Retail then
			local mInctanceInfo = mMT:InctanceInfo()
			if mInctanceInfo then
				DT.tooltip:AddLine(" ")
				DT.tooltip:AddLine(mInctanceInfo[1] or "-")
				DT.tooltip:AddLine(mInctanceInfo[2] or "-")
				DT.tooltip:AddLine(mInctanceInfo[3] or "-")
			end

			local inInstance, _ = IsInInstance()
			if inInstance then
				local infoinInstance = mMT:DungeonInfo()
				DT.tooltip:AddLine(" ")
				DT.tooltip:AddLine(infoinInstance[1] or "-")
				DT.tooltip:AddLine(infoinInstance[2] or "-")
				DT.tooltip:AddLine(infoinInstance[3] or "-")
			end
		end

		if
			E.Retail
			and C_MythicPlus.IsMythicPlusActive()
			and (C_ChallengeMode.GetActiveChallengeMapID() ~= nil)
		then
			local infoMythicPlus = mMT:MythicPlusDungeon()
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(infoMythicPlus[1] or "-")
			DT.tooltip:AddLine(infoMythicPlus[2] or "-")
		end
	end

	if E.Retail and E.db[mPlugin].SKeystone then
		local key = mMT:OwenKeystone()
		if key then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(key[1] or "-")
			DT.tooltip:AddLine(key[2] or "-")
		end
	end

	if E.Retail and E.db[mPlugin].SystemMenu.score then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(DUNGEON_SCORE, mMT:GetDungeonScore())
	end

	if E.Retail and E.db[mPlugin].SAffix then
		local mAffixes = mMT:WeeklyAffixes()
		if mAffixes then
			DT.tooltip:AddLine(" ")
			if mAffixes[3] then
				DT.tooltip:AddLine(mAffixes[3])
			else
				DT.tooltip:AddLine(mAffixes[1])
				DT.tooltip:AddLine(mAffixes[2])
			end
		end
	end

	if E.Retail and E.db[mPlugin].mSystemMenu.greatvault then
		local vaultinfohighest, ok = 0, false
		local vaultinforaidText, vaultinfomplusText, vaultinfopvpText, vaultinfohighest, ok = mMT:mGetVaultInfo()
		if ok then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format("%s%s|r", titel, GREAT_VAULT_REWARDS))

			if vaultinfohighest then
				DT.tooltip:AddDoubleLine(format("%sAktuelle Belohnung:|r", other), vaultinfohighest or "-")
			end

			if vaultinforaidText[1] then
				DT.tooltip:AddDoubleLine(
					format("%sRaid|r", myth),
					format(
						"%s, %s, %s",
						vaultinforaidText[1] or "-",
						vaultinforaidText[2] or "-",
						vaultinforaidText[3] or "-"
					)
				)
			end

			if vaultinfomplusText[1] then
				DT.tooltip:AddDoubleLine(
					format("%sMyth+|r", mythp),
					format(
						"%s, %s, %s",
						vaultinfomplusText[1] or "-",
						vaultinfomplusText[2] or "-",
						vaultinfomplusText[3] or "-"
					)
				)
			end

			if vaultinfopvpText[1] then
				DT.tooltip:AddDoubleLine(
					format("%sPvP|r", hc),
					format(
						"%s, %s, %s",
						vaultinfopvpText[1] or "-",
						vaultinfopvpText[2] or "-",
						vaultinfopvpText[3] or "-"
					)
				)
			end
		end
		if C_WeeklyRewards.HasAvailableRewards() then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format("%s%s|r", titel, GREAT_VAULT_REWARDS_WAITING))
		end
	end

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(ns.mName, format("%sVer.|r %s%s|r", titel, other, ns.mVersion))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s %s%s|r", ns.LeftButtonIcon, tip, L["Click left to open the main menu."]))
	if E.Retail then
		DT.tooltip:AddLine(format("%s %s%s|r", ns.RightButtonIcon, tip, L["right click to open LFD Window"]))
	end
	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext(
	"mGameMenu",
	"mMediaTag",
	{ "CHALLENGE_MODE_START", "CHALLENGE_MODE_COMPLETED", "PLAYER_ENTERING_WORLD", "UPDATE_INSTANCE_INFO" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	nil
)
