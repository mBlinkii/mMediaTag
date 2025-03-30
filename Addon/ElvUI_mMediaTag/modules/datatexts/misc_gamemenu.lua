local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local _G = _G
local sort = sort
local tinsert = tinsert

local CloseAllWindows = CloseAllWindows
local CloseMenus = CloseMenus
local HideUIPanel = HideUIPanel
local InCombatLockdown = InCombatLockdown
local ShowUIPanel = ShowUIPanel
local ToggleFrame = ToggleFrame
local UIParentLoadAddOn = UIParentLoadAddOn
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local StoreEnabled = C_StorePublic.IsEnabled
local PlayerSpellsUtil = _G.PlayerSpellsUtil
local MainMenuMicroButton = MainMenuMicroButton
local MainMenuMicroButton_SetNormal = MainMenuMicroButton_SetNormal

local textString = ""
local menuList = {}
local icons = {
	mmt = MEDIA.icon,
	colored = E:TextureString(MEDIA.icons.datatexts.menu_b, ":14:14"),
	white = E:TextureString(MEDIA.icons.datatexts.menu_a, ":14:14"),
}

local enteredFrame = false
local delay = 1

local path = "Interface\\Addons\\ElvUI_mMediaTag\\media\\options\\"
local menu_icons = {
	character = path .. "character.tga",
	book = path .. "book.tga",
	clock = path .. "clock.tga",
	chat = path .. "chat.tga",
	social = path .. "social.tga",
	talent = path .. "talent.tga",
	guild = path .. "guild.tga",
	pvp = path .. "pvp.tga",
	collection = path .. "collection.tga",
	achievement = path .. "achievement.tga",
	browser = path .. "browser.tga",
	calendar = path .. "calendar.tga",
	encounter = path .. "encounter.tga",
	shop = path .. "shop.tga",
	profession = path .. "professions.tga",
	missions = path .. "missions.tga",
	quest = path .. "quest.tga",
	elvui = path .. "elvui.tga",
	mmt = path .. "mmt_16.tga",
	menu = path .. "gamemenu.tga",
	help = path .. "help.tga",
}

-- Create the menu
local function BuildMenuList()
	local icon = E.db.mMT.datatexts.menu.menu_icons
	menuList = {
		{
			text = _G.CHARACTER_BUTTON,
			icon = icon and menu_icons.character,
			func = function()
				_G.ToggleCharacter("PaperDollFrame")
			end,
		},
		{
			text = E.Retail and _G.SPELLBOOK or _G.SPELLBOOK_ABILITIES_BUTTON,
			icon = icon and menu_icons.book,
			func = function()
				if PlayerSpellsUtil then
					PlayerSpellsUtil.ToggleSpellBookFrame()
				else
					ToggleFrame(_G.SpellBookFrame)
				end
			end,
		},
		{
			text = _G.TIMEMANAGER_TITLE,
			icon = icon and menu_icons.clock,
			func = function()
				ToggleFrame(_G.TimeManagerFrame)
			end,
		},
		{
			text = _G.CHAT_CHANNELS,
			icon = icon and menu_icons.chat,
			func = function()
				_G.ToggleChannelFrame()
			end,
		},
		{
			text = _G.SOCIAL_BUTTON,
			icon = icon and menu_icons.social,
			func = function()
				_G.ToggleFriendsFrame()
			end,
		},
		{
			text = _G.TALENTS_BUTTON,
			icon = icon and menu_icons.talent,
			func = function()
				if PlayerSpellsUtil then
					PlayerSpellsUtil.ToggleClassTalentFrame()
				else
					_G.ToggleTalentFrame()
				end
			end,
		},
		{
			text = _G.GUILD,
			icon = icon and menu_icons.guild,
			func = function()
				_G.ToggleGuildFrame()
			end,
		},
	}

	if E.Cata and E.mylevel >= _G.SHOW_PVP_LEVEL then tinsert(menuList, {
		text = _G.PLAYER_V_PLAYER,
		icon = icon and menu_icons.pvp,
		func = function()
			_G.TogglePVPFrame()
		end,
	}) end

	if E.Retail or E.Cata then
		tinsert(menuList, {
			text = _G.COLLECTIONS,
			icon = icon and menu_icons.collection,
			func = function()
				_G.ToggleCollectionsJournal()
			end,
		})
		tinsert(menuList, {
			text = _G.ACHIEVEMENT_BUTTON,
			icon = icon and menu_icons.achievement,
			func = function()
				_G.ToggleAchievementFrame()
			end,
		})
		tinsert(menuList, {
			text = _G.LFG_TITLE,
			icon = icon and menu_icons.browser,
			func = function()
				if E.Retail then
					_G.ToggleLFDParentFrame()
				else
					_G.PVEFrame_ToggleFrame()
				end
			end,
		})
		tinsert(menuList, {
			text = L["Calendar"],
			icon = icon and menu_icons.calendar,
			func = function()
				_G.GameTimeFrame:Click()
			end,
		}) -- Interface\Calendar\MeetingIcon
		tinsert(menuList, {
			text = _G.ENCOUNTER_JOURNAL,
			icon = icon and menu_icons.encounter,
			func = function()
				if not IsAddOnLoaded("Blizzard_EncounterJournal") then UIParentLoadAddOn("Blizzard_EncounterJournal") end
				ToggleFrame(_G.EncounterJournal)
			end,
		})
	end

	if E.Retail then
		if StoreEnabled and StoreEnabled() then tinsert(menuList, {
			text = _G.BLIZZARD_STORE,
			icon = icon and menu_icons.shop,
			func = function()
				_G.StoreMicroButton:Click()
			end,
		}) end

		tinsert(menuList, {
			text = _G.PROFESSIONS_BUTTON,
			icon = icon and menu_icons.profession,
			func = function()
				_G.ToggleProfessionsBook()
			end,
		})
		tinsert(menuList, {
			text = _G.GARRISON_TYPE_8_0_LANDING_PAGE_TITLE,
			icon = icon and menu_icons.missions,
			func = function()
				_G.ExpansionLandingPageMinimapButton:ToggleLandingPage()
			end,
		})
		tinsert(menuList, {
			text = _G.QUESTLOG_BUTTON,
			icon = icon and menu_icons.quest,
			func = function()
				_G.ToggleQuestLog()
			end,
		})
	else
		tinsert(menuList, {
			text = _G.QUEST_LOG,
			icon = icon and menu_icons.quest,
			func = function()
				ToggleFrame(_G.QuestLogFrame)
			end,
		})
	end

	sort(menuList, function(a, b)
		if a and b and a.text and b.text then return a.text < b.text end
	end)

	tinsert(menuList, { text = "", isTitle = true, notClickable = true })
	tinsert(menuList, {
		text = "ElvUI",
		icon = icon and menu_icons.elvui,
		func = function()
			if not InCombatLockdown() then
				E:ToggleOptions()
				HideUIPanel(_G["GameMenuFrame"])
			end
		end,
	})
	tinsert(menuList, {
		text = mMT.Name,
		icon = icon and menu_icons.mmt,
		func = function()
			if not InCombatLockdown() then E:ToggleOptions("mMT") end
		end,
	})

	tinsert(menuList, { text = "", isTitle = true, notClickable = true })
	-- want these two on the bottom
	tinsert(menuList, {
		text = _G.MAINMENU_BUTTON,
		icon = icon and menu_icons.menu,
		func = function()
			if not _G.GameMenuFrame:IsShown() then
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
		icon = icon and menu_icons.help,
		func = function()
			_G.ToggleHelpFrame()
		end,
	})
end

local function OnClick(self, button)
	if not mMT.menu then mMT:BuildMenus() end
	BuildMenuList()

	DT.tooltip:Hide()
	if button == "LeftButton" then
		mMT:DropDown(menuList, mMT.menu, self, 160, 2)
	else
		if E.Retail then
			_G.ToggleLFDParentFrame()
		elseif E.Cata then
			_G.PVEFrame_ToggleFrame()
		end
	end
end

local statusColor = {
	"FF00F957",
	"FFFEA101",
	"FFFF4000",
}

local function OnEnter(self, slow)
	enteredFrame = true

	if slow == 1 or not slow then
		DT.tooltip:ClearLines()

		-- Tooltip Header
		DT.tooltip:AddLine(mMT:TC(L["Game Menu"], "title"))
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(mMT.Name, mMT:TC("Ver.", "title") .. " " .. mMT:TC(mMT.Version, "mark"))

		-- mMT Systeminfo
		if E.db.mMT.datatexts.menu.show_systeminfo then
			mMT:MMTSystemInfo()
			DT.tooltip:AddLine(" ")
		end

		-- Latency
		local function GetLatencyColor(latency)
			return statusColor[latency < 100 and 1 or (latency < 200 and 2 or 3)]
		end

		local function AddLatencyInfo(title, latency, color)
			DT.tooltip:AddDoubleLine(mMT:TC(L[title]), string.format("|c%s %d ms|r", color, latency))
		end

		local _, _, latencyHome, latencyWorld = GetNetStats()
		DT.tooltip:AddLine(mMT:TC(L["Latency:"], "title"))
		AddLatencyInfo("Home", latencyHome, GetLatencyColor(latencyHome))
		AddLatencyInfo("World", latencyWorld, GetLatencyColor(latencyWorld))
		DT.tooltip:AddLine(" ")

		-- FPS
		local function AddFramerateInfo(fps)
			local fps_color = statusColor[fps > 55 and 1 or (fps > 29 and 2 or 3)]
			DT.tooltip:AddDoubleLine(mMT:TC(L["Framerate:"]), string.format("|c%s %.0f FPS|r", fps_color, fps))
		end
		AddFramerateInfo(GetFramerate())
		DT.tooltip:AddLine(" ")

		-- CPU/ Memory usage
		if E.db.mMT.datatexts.menu.show_systeminfo then
			mMT:SystemInfo()
			DT.tooltip:AddLine(" ")
		end

		DT.tooltip:AddLine(MEDIA.leftClick .. " " .. mMT:TC(L["left click to open the menu."], "tip"))
		if E.Retail or E.Cata then DT.tooltip:AddLine(MEDIA.rightClick .. " " .. mMT:TC(L["right click to open LFD Browser"], "tip")) end

		DT.tooltip:Show()
	end
end

local function OnLeave()
	enteredFrame = false
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

local function OnUpdate(self, elapsed)
	if not enteredFrame then return end
	delay = delay - elapsed
	if delay <= 0 then
		OnEnter(self)
		delay = 1
	end
end

DT:RegisterDatatext("mMT - Game menu", mMT.Name, nil, OnEvent, OnUpdate, OnClick, OnEnter, OnLeave, L["Game Menu"], nil, ValueColorUpdate)
