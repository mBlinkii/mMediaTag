local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local _G = _G
local sort = sort
local tinsert = tinsert

local CloseAllWindows = CloseAllWindows
local CloseMenus = CloseMenus
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or IsAddOnLoaded
local ShowUIPanel = ShowUIPanel
local ToggleFrame = ToggleFrame
local UIParentLoadAddOn = UIParentLoadAddOn
local PlayerSpellsUtil = _G.PlayerSpellsUtil

local textString = ""
local menuList = nil

local icons = {
	mmt = MEDIA.icon,
	colored = E:TextureString(MEDIA.icons.datatexts.menu_b, ":14:14"),
	icon = E:TextureString(MEDIA.icons.datatexts.menu_a, ":14:14"),
}
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
	if color > 16 then color = 16 end
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
				if not IsAddOnLoaded("Blizzard_EncounterJournal") then UIParentLoadAddOn("Blizzard_EncounterJournal") end
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

	if E.Cata and E.mylevel >= _G.SHOW_PVP_LEVEL then tinsert(menuList, {
		text = _G.PLAYER_V_PLAYER,
		icon = AddIcon("battle"),
		func = function()
			_G.TogglePVPFrame()
		end,
	}) end

	sort(menuList, function(a, b)
		if a and b and a.text and b.text then return a.text < b.text end
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
			if not InCombatLockdown() then E:ToggleOptions("mMT") end
		end,
	})
	tinsert(menuList, { text = "", isTitle = true, notClickable = true, func = function() end })
	tinsert(menuList, {
		text = _G.MAINMENU_BUTTON,
		color = AddColor(4),
		icon = AddIcon("gears"),
		func = function()
			if not _G.GameMenuFrame:IsShown() then
				CloseMenus()
				CloseAllWindows()
				ShowUIPanel(_G.GameMenuFrame)
			else
				HideUIPanel(_G.GameMenuFrame)
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

local function OnClick(self, button)
    if not mMT.menu then mMT:BuildMenus() end

	if not menuList or event == "ELVUI_FORCE_UPDATE" then BuildMenu() end

	DT.tooltip:Hide()
	if button == "LeftButton" then
		mMT:mDropDown(menuList, menuFrame, self, 160, 2)
	else
		if E.Retail then
			_G.ToggleLFDParentFrame()
		elseif E.Cata then
			if not IsAddOnLoaded("Blizzard_LookingForGroupUI") then UIParentLoadAddOn("Blizzard_LookingForGroupUI") end
			_G.ToggleLFGParentFrame()
		end
	end
end

local function OnEnter(self)
	DT.tooltip:AddLine(L["Game Menu"])
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddDoubleLine(mMT.Name, mMT:TC("Ver.", "title") .. " " .. mMT:TC(mMT.Version, "mark"))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine(MEDIA.leftClick .. " " .. mMT:TC(L["left click to open the menu."], "tip"))
	if E.Retail or E.Cata then DT.tooltip:AddLine(MEDIA.rightClick .. " " .. mMT:TC(L["right click to open LFD Browser"], "tip")) end
	DT.tooltip:Show()
end

local function OnLeave()
	DT.tooltip:Hide()
end

local function OnEvent(self)
	local iconPath = E.db.mMT.datatexts.menu.icon
	local label = L["Game Menu"]

	if iconPath ~= "none" then label = icons[iconPath] .. " " .. label end

	self.text:SetFormattedText(textString, label)
end

local function ValueColorUpdate(self, hex)
	local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or hex
	textString = strjoin("", textHex, "%s|r")
	OnEvent(self)
end

DT:RegisterDatatext("mMT - Game menu", mMT.Name, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, L["Game Menu"], nil, ValueColorUpdate)
