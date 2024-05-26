local E, L, V, P, G = unpack(ElvUI)
local EP = E.Libs.EP

local PI = E:GetModule("PluginInstaller")
local CH = E:GetModule("Chat")

local _G = _G
local next = next
local unpack = unpack
local format = format
local strsub = strsub
local tinsert = tinsert

local ReloadUI = ReloadUI
local PlaySound = PlaySound
local CreateFrame = CreateFrame
local UIFrameFadeOut = UIFrameFadeOut
local ChangeChatColor = ChangeChatColor
local FCF_DockFrame = FCF_DockFrame
local FCF_SetWindowName = FCF_SetWindowName
local FCF_StopDragging = FCF_StopDragging
local FCF_UnDockFrame = FCF_UnDockFrame
local FCF_OpenNewWindow = FCF_OpenNewWindow
local FCF_ResetChatWindow = FCF_ResetChatWindow
local FCF_ResetChatWindows = FCF_ResetChatWindows
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local SetChatColorNameByClass = SetChatColorNameByClass
local ChatFrame_AddChannel = ChatFrame_AddChannel
local ChatFrame_RemoveChannel = ChatFrame_RemoveChannel
local ChatFrame_AddMessageGroup = ChatFrame_AddMessageGroup
local ChatFrame_RemoveAllMessageGroups = ChatFrame_RemoveAllMessageGroups
local VoiceTranscriptionFrame_UpdateEditBox = VoiceTranscriptionFrame_UpdateEditBox
local VoiceTranscriptionFrame_UpdateVisibility = VoiceTranscriptionFrame_UpdateVisibility
local VoiceTranscriptionFrame_UpdateVoiceTab = VoiceTranscriptionFrame_UpdateVoiceTab

local CLASS, CONTINUE, PREVIOUS = CLASS, CONTINUE, PREVIOUS
local VOICE, LOOT, GENERAL, TRADE = VOICE, LOOT, GENERAL, TRADE
local GUILD_EVENT_LOG = GUILD_EVENT_LOG

local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata

local S = E:GetModule("Skins")

-- Addon Name and Namespace
local addonName, _ = ...

MAUI = E:NewModule(addonName, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
-- Settings
MAUI.Version = GetAddOnMetadata(addonName, "Version")
MAUI.Name = "|CFF29C0E3M|r|CFF5493FFa|r|CFF854FE3U|r|CFFA632E3I|r"
MAUI.Icon = "|TInterface\\Addons\\MaUI\\media\\maui_icon.tga:14:14|t"
MAUI.Logo = "Interface\\Addons\\MaUI\\media\\maui_logo.tga"
MAUI.InstallerData = nil
local globalProfile = nil
local layoutVersion = nil

P["MaUI"] = {}

function MAUI:Print(...)
	print(MAUI.Name .. ":", ...)
end

local function SetupComplete()
	--E.db["MaUI"].install = true
	--E.db["MaUI"].version = MAUI.Version

	ReloadUI()
end

local function SetupSkip()
	if E.db["MaUI"].skiped then
		E.private.install_complete = nil
	end

	SetupComplete()
end

local function ToggleChatColorNamesByClassGroup(checked, group)
	local info = _G.ChatTypeGroup[group]
	if info then
		for _, value in next, info do
			SetChatColorNameByClass(strsub(value, 10), checked)
		end
	else
		SetChatColorNameByClass(group, checked)
	end
end

local function SetupChat()
	local chats = _G.CHAT_FRAMES
	FCF_ResetChatWindows()

	local voiceChat = _G[chats[3]]
	FCF_ResetChatWindow(voiceChat, VOICE)
	FCF_DockFrame(voiceChat, 3)

	local tradeChat = FCF_OpenNewWindow(LOOT)
	local groupChat = FCF_OpenNewWindow(GROUP)
	local whisperChat = FCF_OpenNewWindow(WHISPER)

	for id, name in next, chats do
		local frame = _G[name]

		if E.private.chat.enable then
			CH:FCFTab_UpdateColors(CH:GetTab(frame))
		end

		if id == 1 then
			frame:ClearAllPoints()
			frame:Point("BOTTOMLEFT", _G.LeftChatToggleButton, "TOPLEFT", 1, 3)
		elseif id == 2 then
			FCF_SetWindowName(frame, GUILD_EVENT_LOG)
		elseif id == 3 then
			VoiceTranscriptionFrame_UpdateVisibility(frame)
			VoiceTranscriptionFrame_UpdateVoiceTab(frame)
			VoiceTranscriptionFrame_UpdateEditBox(frame)
		elseif id == 4 then
			FCF_SetWindowName(frame, LOOT .. " / " .. TRADE)
		elseif id == 5 then
			FCF_SetWindowName(frame, GROUP)
		elseif id == 6 then
			FCF_SetWindowName(frame, WHISPER)
		end

		FCF_SetChatWindowFontSize(nil, frame, 12)
		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
	end

	-- keys taken from `ChatTypeGroup` but doesnt add: 'OPENING', 'TRADESKILLS', 'PET_INFO', 'COMBAT_MISC_INFO', 'COMMUNITIES_CHANNEL', 'PET_BATTLE_COMBAT_LOG', 'PET_BATTLE_INFO', 'TARGETICONS'
	local chatGroup = { "SYSTEM", "CHANNEL", "SAY", "EMOTE", "YELL", "MONSTER_SAY", "MONSTER_YELL", "MONSTER_EMOTE", "MONSTER_WHISPER", "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER", "ERRORS", "AFK", "DND", "IGNORED", "BG_HORDE", "BG_ALLIANCE", "BG_NEUTRAL", "ACHIEVEMENT", "GUILD_ACHIEVEMENT", "BN_INLINE_TOAST_ALERT" }
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame1)
	for _, v in next, chatGroup do
		ChatFrame_AddMessageGroup(_G.ChatFrame1, v)
	end

	-- keys taken from `ChatTypeGroup` which weren't added above to ChatFrame1
	chatGroup = { E.Retail and "PING" or nil, "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT", "CURRENCY", "MONEY" }
	ChatFrame_RemoveAllMessageGroups(tradeChat)
	for _, v in next, chatGroup do
		ChatFrame_AddMessageGroup(tradeChat, v)
	end

	local chatGroup = { "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "GUILD", "OFFICER" }
	ChatFrame_RemoveAllMessageGroups(groupChat)
	for _, v in next, chatGroup do
		ChatFrame_AddMessageGroup(groupChat, v)
	end

	local chatGroup = { "WHISPER", "BN_WHISPER" }
	ChatFrame_RemoveAllMessageGroups(whisperChat)
	for _, v in next, chatGroup do
		ChatFrame_AddMessageGroup(whisperChat, v)
	end

	ChatFrame_AddChannel(_G.ChatFrame1, GENERAL)
	ChatFrame_RemoveChannel(_G.ChatFrame1, TRADE)
	ChatFrame_AddChannel(tradeChat, TRADE)
	ChatFrame_AddChannel(groupChat, GROUP)
	ChatFrame_AddChannel(whisperChat, WHISPER)

	-- set the chat groups names in class color to enabled for all chat groups which players names appear
	chatGroup = { "SAY", "EMOTE", "YELL", "WHISPER", "PARTY", "PARTY_LEADER", "RAID", "RAID_LEADER", "RAID_WARNING", "INSTANCE_CHAT", "INSTANCE_CHAT_LEADER", "GUILD", "OFFICER", "ACHIEVEMENT", "GUILD_ACHIEVEMENT", "COMMUNITIES_CHANNEL" }
	for i = 1, _G.MAX_WOW_CHAT_CHANNELS do
		tinsert(chatGroup, "CHANNEL" .. i)
	end

	for _, v in next, chatGroup do
		ToggleChatColorNamesByClassGroup(true, v)
	end

	-- Adjust Chat Colors
	ChangeChatColor("CHANNEL1", 0.76, 0.90, 0.91) -- General
	ChangeChatColor("CHANNEL2", 0.91, 0.62, 0.47) -- Trade
	ChangeChatColor("CHANNEL3", 0.91, 0.89, 0.47) -- Local Defense

	if E.private.chat.enable then
		CH:PositionChats()
	end

	if E.db.RightChatPanelFaded then
		_G.RightChatToggleButton:Click()
	end

	if E.db.LeftChatPanelFaded then
		_G.LeftChatToggleButton:Click()
	end

	if _G.InstallStepComplete then
		_G.InstallStepComplete.message = L["Chat Set"]
		_G.InstallStepComplete:Show()
	end
end

local function FirstStep()
	E:SetupCVars()
	SetupChat()
	if E.Retail then
		ChatFrame_RemoveChannel(_G.ChatFrame1, "services")
	end
end

local function OnEnter(pic)
	_G.PluginInstallFrame.mauiPreview.bg:SetTexture("Interface\\Addons\\MaUI\\media\\" .. pic, "REPEAT", "REPEAT", "TRILINEAR")
	_G.PluginInstallFrame.mauiPreview:Show()
	E:UIFrameFadeIn(_G.PluginInstallFrame.mauiPreview, 0.25, 0, 1)
end

local function OnLeave()
	_G.PluginInstallFrame.mauiPreview:Hide()
end

local function SetupProfile(layout, global)
	if global then
		E.data:SetProfile("MaUI-" .. layout .. " (" .. MAUI.Version .. ")")
	else
		E.data:SetProfile("MaUI-" .. layout .. " - " .. E.mynameRealm .. " (" .. MAUI.Version .. ")")
	end
end

local function SelectionCheck()
	if globalProfile == nil then
		MAUI:Print("|CFFFF006CERROR:|r", "Profile has not been created, please choose between character specific or global profile.")
		PI:SetPage(3, 2)
	elseif not layoutVersion then
		MAUI:Print("|CFFFF006CERROR:|r", "Layout has not been selected, please select a layout.")
		PI:SetPage(4, 3)
	else
		return true
	end
	return false
end

local function SetupLayout(role)
	if SelectionCheck() then
		SetupProfile(role, globalProfile)
		if layoutVersion == "V6" then
		elseif layoutVersion == "V7" then

		end
	end
end

MAUI.InstallerData = {
	Title = MAUI.Name .. " Ver.: |CFFF7DC6F" .. MAUI.Version .. "|r",
	Name = MAUI.Name,
	tutorialImage = MAUI.Logo,
	tutorialImageSize = { 512, 128 },
	Pages = {
		[1] = function()
			_G.PluginInstallFrame.SubTitle:SetFormattedText("Welcome to the installation for %s.", MAUI.Name)
			_G.PluginInstallFrame.Desc1:SetText("This installation process will guide you through a few steps and apply the settings to a new ElvUI profile. To protect your current profile, make a backup copy of the profile before going through this installation process.")
			_G.PluginInstallFrame.Desc2:SetText("Please press the continue button if you wish to go through the installation process, otherwise click the 'Skip Process' button.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", SetupSkip)
			_G.PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			_G.PluginInstallFrame.Option1:SetScript("OnLeave", OnLeave)
			_G.PluginInstallFrame.Option1:SetText("Skip Process")
		end,
		[2] = function()
			_G.PluginInstallFrame.SubTitle:SetText("CVars & Chat")
			_G.PluginInstallFrame.Desc1:SetText("This part of the installation process sets up your World of Warcraft default options & Chat it is recommended you should do this step for everything to behave properly.")
			_G.PluginInstallFrame.Desc2:SetText("Please click the button below to setup your CVars & Chat.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffFF3333High|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("Setup CVars & Chat")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", FirstStep)
			_G.PluginInstallFrame.Option1:SetScript("OnEnter", function()
				OnEnter("pic1.png")
			end)
		end,
		[3] = function()
			_G.PluginInstallFrame.SubTitle:SetText("Profile Settings")
			_G.PluginInstallFrame.Desc1:SetText("Please click the button below to setup your Profile Settings.")
			_G.PluginInstallFrame.Desc2:SetText("New Profile will create a fresh profile for this character." .. "\n" .. "Shared Profile will select the default profile.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffFF3333High|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("Shared Profile")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				globalProfile = true
			end)
			_G.PluginInstallFrame.Option2:Show()
			_G.PluginInstallFrame.Option2:SetText("New Profile")
			_G.PluginInstallFrame.Option2:SetScript("OnClick", function()
				globalProfile = false
			end)
		end,
		[4] = function()
			_G.PluginInstallFrame.SubTitle:SetText("MaUI Layout Version")
			_G.PluginInstallFrame.Desc1:SetText("Please click the button below to setup your MaUI Layout Version.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffFF3333High|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("MaUI v6")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				layoutVersion = "V6"
			end)
			_G.PluginInstallFrame.Option2:Show()
			_G.PluginInstallFrame.Option2:SetText("MaUI v7")
			_G.PluginInstallFrame.Option2:SetScript("OnClick", function()
				layoutVersion = "V7"
			end)
		end,
		[5] = function()
			_G.PluginInstallFrame.SubTitle:SetText("Layout")
			_G.PluginInstallFrame.Desc1:SetText("You can now choose what layout you wish to use based on your combat role.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffD3CF00Medium|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetText("Tank/ DD")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				SetupLayout("Tank/ DD")
			end)
			_G.PluginInstallFrame.Option2:Show()
			_G.PluginInstallFrame.Option2:SetText("Heal Center")
			_G.PluginInstallFrame.Option2:SetScript("OnClick", function()
				SetupLayout("Heal Center")
			end)
			_G.PluginInstallFrame.Option3:Show()
			_G.PluginInstallFrame.Option3:SetText("Heal Left")
			_G.PluginInstallFrame.Option3:SetScript("OnClick", function()
				SetupLayout("Heal Left")
			end)
		end,
		[20] = function()
			_G.PluginInstallFrame.SubTitle:SetText("Installation Complete")
			_G.PluginInstallFrame.Desc1:SetText("You have completed the installation process.")
			_G.PluginInstallFrame.Desc2:SetText("Please click the button below in order to finalize the process and automatically reload your UI.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", SetupComplete)
			_G.PluginInstallFrame.Option1:SetScript("OnEnter", nil)
			_G.PluginInstallFrame.Option1:SetScript("OnLeave", OnLeave)
			_G.PluginInstallFrame.Option1:SetText("Finished")
		end,
	},
	StepTitles = {
		[1] = "Welcome",
		[2] = "CVars & Chat",
		[3] = "Profile Settings",
		[4] = "MaUI Layout Version",
		[5] = "Layout",
		[20] = "Installation Complete",
	},
	StepTitlesColor = { 0.8, 0.8, 0.8 },
	StepTitlesColorSelected = { 0, 0.93, 1 },
	StepTitleWidth = 200,
	StepTitleButtonWidth = 180,
	StepTitleTextJustification = "CENTER",
}

local function CreateBGTexture(texture, frame, file, color, point, pointb)
	if point then
		texture:SetPoint(unpack(point))
		if pointb then
			texture:SetPoint(unpack(pointb))
		end
	else
		texture:SetAllPoints(frame)
	end
	texture:SetTexture("Interface\\Addons\\MaUI\\media\\" .. file, "REPEAT", "REPEAT", "TRILINEAR")
	texture:SetHorizTile(true)
	texture:SetVertTile(true)
	if color then
		texture:SetVertexColor(unpack(color))
	end
end

local function SetupPluginInstaller()
	if not _G.PluginInstallFrame.mauiBG then
		_G.PluginInstallFrame.mauiBG = _G.PluginInstallFrame:CreateTexture()
	end

	if not _G.PluginInstallFrame.side.mauiBG then
		_G.PluginInstallFrame.side.mauiBG = _G.PluginInstallFrame.side:CreateTexture()
	end

	if not _G.PluginInstallFrame.mauiPreview then
		_G.PluginInstallFrame.mauiPreview = CreateFrame("Frame", "MaUI_Installer_Preview", E.UIParent)
		_G.PluginInstallFrame.mauiPreview:SetTemplate("Transparent", true)
		_G.PluginInstallFrame.mauiPreview:SetPoint("RIGHT", _G.PluginInstallFrame, "LEFT", E.PixelMode and -1 or -3, 0, 0)
		_G.PluginInstallFrame.mauiPreview:Size(400, 400)
		_G.PluginInstallFrame.mauiPreview:SetFrameStrata("TOOLTIP")
		_G.PluginInstallFrame.mauiPreview:Hide()
	end

	if not _G.PluginInstallFrame.mauiPreview.bg then
		_G.PluginInstallFrame.mauiPreview.bg = _G.PluginInstallFrame.mauiPreview:CreateTexture()
	end

	CreateBGTexture(_G.PluginInstallFrame.mauiBG, _G.PluginInstallFrame, "frameBG.png", { 0.44, 0.34, 0.34, 0.2 })
	CreateBGTexture(_G.PluginInstallFrame.side.mauiBG, _G.PluginInstallFrame.side, "frameBG.png", { 0.44, 0.34, 0.34, 0.2 })
	CreateBGTexture(_G.PluginInstallFrame.mauiPreview.bg, _G.PluginInstallFrame.mauiPreview, "blank.tga", { 1, 1, 1, 0.8 }, { "TOPLEFT", _G.PluginInstallFrame.mauiPreview, "TOPLEFT", 2, -2 }, { "BOTTOMRIGHT", _G.PluginInstallFrame.mauiPreview, "BOTTOMRIGHT", -2, 2 })

	_G.PluginInstallFrame.Status:SetStatusBarTexture("Interface\\Addons\\MaUI\\media\\statusbar.tga")
end

function MAUI:Initialize()
	E.db["MaUI"].install = nil
	E.db["MaUI"].version = nil

	SetupPluginInstaller()

	if not E.db["MaUI"].install then
		if not E.private.install_complete then
			E.db["MaUI"].skiped = true
			E.private.install_complete = E.version
		end

		PI:Queue(MAUI.InstallerData)
	end
end

local function CallbackInitialize()
	EP:RegisterPlugin(addonName)

	MAUI:Initialize()
end

E:RegisterModule(MAUI:GetName(), CallbackInitialize)
