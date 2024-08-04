local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")

local _G = _G
local sort = sort
local tinsert = tinsert

local CloseAllWindows = CloseAllWindows
local CloseMenus = CloseMenus
local CreateFrame = CreateFrame
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = IsAddOnLoaded
local ShowUIPanel = ShowUIPanel
local ToggleFrame = ToggleFrame
local UIParentLoadAddOn = UIParentLoadAddOn
local MainMenuMicroButton = MainMenuMicroButton
local MainMenuMicroButton_SetNormal = MainMenuMicroButton_SetNormal
local PlayerSpellsUtil = _G.PlayerSpellsUtil

local menuList = nil
local menuFrame = CreateFrame("Frame", "mMT_SystemMenu", E.UIParent)
menuFrame:SetTemplate("Transparent", true)

local colors = {
	[1] = "|CFFFFFFFF",
	[2] = "|CFF0393FF",
	[3] = "|CFF496AF5",
	[4] = "|CFF5F5DF2",
	[5] = "|CFF8249ED",
	[6] = "|CFFAC30E7",
	[7] = "|CFFBE25E5",
	[8] = "|CFFDC14E1",
	[9] = "|CFFF903DD",
	[10] = "|CFFFF0068",
	[11] = "|CFFFF4E00",
	[12] = "|CFFFF6900",
	[13] = "|CFFFF8B00",
	[14] = "|CFFFFA800",
	[15] = "|CFFFFA900",
	[16] = "|CFFFFC900",
}
local function AddIcon(file)
	return E.db.mMT.gamemenu.menuicons and format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\%s.tga", file) or nil
end

local function AddColor(color)
	if color > 16 then
		color = 16
	end
	return E.db.mMT.gamemenu.color and colors[color] or colors[1]
end

local function BuildMenu()
	menuList = {
		{
			text = _G.CHARACTER_BUTTON,
			icon = AddIcon("face"),
			func = function()
				_G.ToggleCharacter("PaperDollFrame")
			end,
		},
		{
			text = E.Retail and _G.SPELLBOOK or _G.SPELLBOOK_ABILITIES_BUTTON,
			icon = AddIcon("literature"),
			func = function()
				if PlayerSpellsUtil then
					PlayerSpellsUtil.ToggleSpellBookFrame()
				else
					ToggleFrame(_G.SpellBookFrame)
				end
			end,
		},
		{
			text = _G.PROFESSIONS_BUTTON,
			icon = AddIcon("profession"),
			func = function()
				ToggleProfessionsBook()
			end,
		},
		{
			text = _G.TALENTS_BUTTON,
			icon = AddIcon("prize"),
			func = function()
				if PlayerSpellsUtil then
					PlayerSpellsUtil.ToggleClassTalentOrSpecFrame()
				else
					_G.ToggleTalentFrame()
				end
			end,
		},
		{
			text = _G.TIMEMANAGER_TITLE,
			icon = AddIcon("watches"),
			func = function()
				ToggleFrame(_G.TimeManagerFrame)
			end,
		},
		{
			text = _G.CHAT_CHANNELS,
			icon = AddIcon("chathistory"),
			func = function()
				_G.ToggleChannelFrame()
			end,
		},
		{
			text = _G.SOCIAL_BUTTON,
			icon = AddIcon("users"),
			func = function()
				_G.ToggleFriendsFrame()
			end,
		},
		{
			text = _G.GUILD,
			icon = AddIcon("homeshield"),
			func = function()
				_G.ToggleGuildFrame()
			end,
		},
	}

	if E.Retail or E.Cata then
		tinsert(menuList, {
			text = _G.LFG_TITLE,
			icon = AddIcon("eye"),
			func = function()
				if E.Retail then
					_G.ToggleLFDParentFrame()
				else
					_G.PVEFrame_ToggleFrame()
				end
			end,
		})
		tinsert(menuList, {
			text = _G.COLLECTIONS,
			icon = AddIcon("cube"),
			func = function()
				_G.ToggleCollectionsJournal()
			end,
		})
		tinsert(menuList, {
			text = _G.ENCOUNTER_JOURNAL,
			icon = AddIcon("magazine"),
			func = function()
				if not IsAddOnLoaded("Blizzard_EncounterJournal") then
					UIParentLoadAddOn("Blizzard_EncounterJournal")
				end
				ToggleFrame(_G.EncounterJournal)
			end,
		})
		tinsert(menuList, {
			text = _G.ACHIEVEMENT_BUTTON,
			icon = AddIcon("star"),
			func = function()
				_G.ToggleAchievementFrame()
			end,
		})
		tinsert(menuList, {
			text = L["Calendar"],
			icon = AddIcon("calendar"),
			func = function()
				_G.GameTimeFrame:Click()
			end,
		})
	end

	if E.Retail then
		tinsert(menuList, {
			text = _G.BLIZZARD_STORE,
			icon = AddIcon("store"),
			func = function()
				_G.StoreMicroButton:Click()
			end,
		})
		tinsert(menuList, {
			text = _G.GARRISON_TYPE_8_0_LANDING_PAGE_TITLE,
			icon = AddIcon("watches"),
			func = function()
				_G.ExpansionLandingPageMinimapButton:ToggleLandingPage()
			end,
		})
		tinsert(menuList, {
			text = _G.QUEST_LOG,
			icon = AddIcon("question"),
			func = function()
				ToggleFrame(_G.QuestLogFrame)
			end,
		})
	end

	if E.Cata and E.mylevel >= _G.SHOW_PVP_LEVEL then
		tinsert(menuList, {
			text = _G.PLAYER_V_PLAYER,
			icon = AddIcon("battle"),
			func = function()
				_G.TogglePVPFrame()
			end,
		})
	end

	sort(menuList, function(a, b)
		if a and b and a.text and b.text then
			return a.text < b.text
		end
		return false
	end)

	for i = 1, #menuList do
		menuList[i].color = AddColor(i + 1)
	end

	tinsert(menuList, { text = "", isTitle = true, notClickable = true, func = function() end })
	tinsert(menuList, {
		text = format(mMT.ClassColor.string, "ElvUI"),
		icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\elvui.tga",
		bottom = true,
		func = function()
			if not InCombatLockdown() then
				E:ToggleOptions()
				HideUIPanel(_G["GameMenuFrame"])
			end
		end,
	})
	tinsert(menuList, {
		text = mMT.Name,
		icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_icon.tga",
		bottom = true,
		func = function()
			if not InCombatLockdown() then
				E:ToggleOptions("mMT")
			end
		end,
	})
	tinsert(menuList, { text = "", isTitle = true, notClickable = true, func = function() end })
	tinsert(menuList, {
		text = _G.MAINMENU_BUTTON,
		color = AddColor(4),
		icon = AddIcon("gears"),
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
				ShowUIPanel(_G.GameMenuFrame)
			else
				HideUIPanel(_G.GameMenuFrame)

				if E.Retail then
					MainMenuMicroButton:SetButtonState("NORMAL")
				else
					MainMenuMicroButton_SetNormal()
				end
			end
		end,
	})

	tinsert(menuList, {
		text = _G.HELP_BUTTON,
		color = AddColor(4),
		icon = AddIcon("questionmark"),
		bottom = true,
		func = function()
			_G.ToggleHelpFrame()
		end,
	})
end
local function OnEvent(self, event)
	if not menuList or event == "ELVUI_FORCE_UPDATE" then
		BuildMenu()
	end

	local hex = E:RGBToHex(E.db.general.valuecolor.r, E.db.general.valuecolor.g, E.db.general.valuecolor.b)
	local string = strjoin("", hex, "%s|r")

	self.text:SetFormattedText(string, E.db.mMT.gamemenu.icon and format("|TInterface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\misc\\gears.tga:16:16:0:0:64:64|t %s", L["Game Menu"]) or L["Game Menu"])
end
local function OnClick(self, button)
	if not menuList then
		BuildMenu()
	end

	DT.tooltip:Hide()
	if button == "LeftButton" then
		mMT:mDropDown(menuList, menuFrame, self, 160, 2)
	else
		if E.Retail then
			_G.ToggleLFDParentFrame()
		elseif E.Cata then
			if not IsAddOnLoaded("Blizzard_LookingForGroupUI") then
				UIParentLoadAddOn("Blizzard_LookingForGroupUI")
			end
			_G.ToggleLFGParentFrame()
		end
	end
end

local function OnEnter(self)
	local nhc, hc, myth, mythp, other, title, tip = mMT:mColorDatatext()

	DT.tooltip:AddLine(L["Game Menu"])
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(mMT.Name, format("%sVer.|r %s%s|r", title, other, mMT.Version))
	DT.tooltip:AddLine(" ")

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["LEFT"]), tip, L["left click to open the menu."]))
	if E.Retail or E.Cata then
		DT.tooltip:AddLine(format("%s %s%s|r", mMT:mIcon(mMT.Media.Mouse["RIGHT"]), tip, L["right click to open LFD Window"]))
	end
	DT.tooltip:Show()
end

local function OnLeave(self)
	DT.tooltip:Hide()
end

DT:RegisterDatatext("mGameMenu", "mMediaTag", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Game Menu"], nil, nil)
