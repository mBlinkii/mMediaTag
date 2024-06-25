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

local colors = {
	selected = "|CFF5BDD04",
	deselected = "|CFF7A7A7A",
	highlight = "|CFF29C0E3",
	red = "|CFFE40606",
}

local icons = {
	selected = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\done3.tga:14:14|t ",
	deselected = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\x4.tga:14:14|t ",
}

local installSettings = {
	currency = false,
	dock = false,
	global = false,
	shared = false,
	v6 = false,
	v7 = false,
	mythicPlus = false,
	tank = false,
	heal1 = false,
	heal2 = false,
	dd = false,
	fct = false,
	dbm = false,
	details = false,
	name = nil,
	elvui = nil,
}

P["MaUI"] = {}

StaticPopupDialogs["PROFILE_EXIST"] = {
	text = "The profile already exists. Change the name or use the existing profile, otherwise the existing profile will be overwritten.",
	button1 = "Change name",
	button2 = "Overwrite",
	button3 = "Abort",
	OnButton1 = function()
		StaticPopup_Show("CHANGE_NAME")
	end,
	OnButton2 = function()
		print("Overwrite")
	end,
	OnButton3 = function()
		print("ABORT")
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["CHANGE_NAME"] = {
	text = "Enter a new name for your profile.",
	button1 = ACCEPT,
	hasEditBox = 1,
	editBoxWidth = 350,
	maxLetters = 127,
	OnAccept = function(popup)
		MAUI:Print(popup.editBox:GetText())
	end,
	OnShow = function(popup)
		popup.editBox:SetText(installSettings.name)
		popup.editBox:SetFocus()
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1,
	preferredIndex = 3,
}

StaticPopupDialogs["OVERWRITE"] = {
	text = "The profile already exists. Change the name or use the existing profile, otherwise the existing profile will be overwritten.",
	button1 = "Change name",
	button2 = "Overwrite",
	button3 = "Abort",
	OnButton1 = function()
		StaticPopup_Show("CHANGE_NAME")
	end,
	OnButton2 = function()
		print("Overwrite")
	end,
	OnButton3 = function()
		print("ABORT")
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

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
		E.private.install_complete = installSettings.elvui or nil
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

	-- keys taken from `ChatTypeGroup` but doesnt add: "OPENING", "TRADESKILLS", "PET_INFO", "COMBAT_MISC_INFO", "COMMUNITIES_CHANNEL", "PET_BATTLE_COMBAT_LOG", "PET_BATTLE_INFO", "TARGETICONS"
	local chatGroup = { "SYSTEM", "CHANNEL", "SAY", "EMOTE", "YELL", "MONSTER_SAY", "MONSTER_YELL", "MONSTER_EMOTE", "MONSTER_WHISPER", "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER", "ERRORS", "AFK", "DND", "IGNORED", "BG_HORDE", "BG_ALLIANCE", "BG_NEUTRAL", "ACHIEVEMENT", "GUILD_ACHIEVEMENT", "BN_INLINE_TOAST_ALERT" }
	ChatFrame_RemoveAllMessageGroups(_G.ChatFrame1)
	for _, v in next, chatGroup do
		ChatFrame_AddMessageGroup(_G.ChatFrame1, v)
	end

	-- keys taken from `ChatTypeGroup` which weren"t added above to ChatFrame1
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

local function OnEnter(button)
	if button.pic then
		_G.PluginInstallFrame.mauiPreview.bg:SetTexture("Interface\\Addons\\MaUI\\media\\" .. button.pic, "CLAMP", "CLAMP", "TRILINEAR")
		_G.PluginInstallFrame.mauiPreview:Show()
		E:UIFrameFadeIn(_G.PluginInstallFrame.mauiPreview, 0.25, 0, 1)
	end

	if button.backdrop then
		button = button.backdrop
	end
	if button.SetBackdropBorderColor then
		button:SetBackdropBorderColor(unpack(E.media.rgbvaluecolor))
	end
end

local function OnLeave(button)
	if button.pic then
		_G.PluginInstallFrame.mauiPreview:Hide()
	end

	if button.backdrop then
		button = button.backdrop
	end
	if button.SetBackdropBorderColor then
		button:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end
end

local function GetOverviewText()
	local install = "will be installed"
	local notInstall = "will not be installed"

	local profile = "Profile: "
	if (installSettings.global or installSettings.shared) and (installSettings.tank or installSettings.dd or installSettings.heal1 or installSettings.heal2) then
		if installSettings.global then
			profile = profile .. colors.selected .. "Shared Profile" .. "|r"
		else
			profile = profile .. colors.selected .. "New Profile" .. "|r"
		end
	else
		profile = profile .. colors.red .. notInstall .. "|r"
	end

	local layout = "Layout: "
	if (installSettings.v6 or installSettings.v7) and (installSettings.tank or installSettings.dd or installSettings.heal1 or installSettings.heal2) then
		if installSettings.v6 then
			layout = layout .. colors.selected .. "MaUI v6" .. "|r"
		else
			layout = layout .. colors.selected .. "MaUI v7" .. "|r"
		end
	else
		layout = layout .. colors.red .. notInstall .. "|r"
	end

	local role = "Role: "
	if installSettings.tank or installSettings.dd or installSettings.heal1 or installSettings.heal2 then
		if installSettings.tank or installSettings.dd then
			role = role .. colors.selected .. "Tank/ DD" .. "|r"
		elseif installSettings.heal1 then
			role = role .. colors.selected .. "Heal Center" .. "|r"
		else
			role = role .. colors.selected .. "Heal Left" .. "|r"
		end
	else
		role = role .. colors.red .. notInstall .. "|r"
	end

	local dock = "Dock: " .. (installSettings.dock and colors.selected or colors.red) .. (installSettings.dock and install or notInstall) .. "|r"
	local currency = "Currency: " .. (installSettings.currency and colors.selected or colors.red) .. (installSettings.currency and install or notInstall) .. "|r"
	local mythicPlus = "Mythic Plus Filters: " .. (installSettings.mythicPlus and colors.selected or colors.red) .. (installSettings.mythicPlus and install or notInstall) .. "|r"

	local fct = "FCT: " .. (installSettings.fct and colors.selected or colors.red) .. (installSettings.fct and install or notInstall) .. "|r"
	local details = "Details: " .. (installSettings.details and colors.selected or colors.red) .. (installSettings.details and install or notInstall) .. "|r"
	local dbm = "DBM: " .. (installSettings.dbm and colors.selected or colors.red) .. (installSettings.dbm and install or notInstall) .. "|r"

	local warning = nil

	if ((installSettings.global or installSettings.shared) and (installSettings.v6 or installSettings.v7)) and not (installSettings.tank or installSettings.dd or installSettings.heal1 or installSettings.heal2) then
		warning = colors.red .. "MaUI Profile will not be installed because no role has been selected!"
	end

	local part1 = colors.highlight .. "Profile:" .. "|r" .. "\n" .. profile .. "\n" .. layout .. "\n" .. role
	local part2 = colors.highlight .. "Features:" .. "|r" .. "\n" .. dock .. "\n" .. currency .. "\n" .. mythicPlus
	local part3 = colors.highlight .. "Addons:" .. "|r" .. "\n" .. fct .. "\n" .. details .. "\n" .. dbm
	return part1 .. "\n\n" .. part2 .. "\n\n" .. part3 .. "\n" .. (warning and "\n" .. warning or "")
end

local function GetOptionText(text, available)
	local icon = available and icons.selected or icons.deselected
	local color = available and colors.selected or colors.deselected
	return icon .. color .. text .. "|r"
end

local function ErrorMessages(global, layout)
	if global == false then
		MAUI:Print("|CFFFF006CERROR:|r", "Profile has not been selected, please choose between character specific or global profile.")
	end

	if layout == false then
		MAUI:Print("|CFFFF006CERROR:|r", "Layout has not been selected, please select a layout.")
	end
end

local function SetEvents()
	_G.PluginInstallFrame.Option1:SetScript("OnEnter", nil)
	_G.PluginInstallFrame.Option1:SetScript("OnLeave", nil)
	_G.PluginInstallFrame.Option2:SetScript("OnEnter", nil)
	_G.PluginInstallFrame.Option2:SetScript("OnLeave", nil)
	_G.PluginInstallFrame.Option3:SetScript("OnEnter", nil)
	_G.PluginInstallFrame.Option3:SetScript("OnLeave", nil)

	_G.PluginInstallFrame.Option1:SetScript("OnEnter", OnEnter)
	_G.PluginInstallFrame.Option1:SetScript("OnLeave", OnLeave)
	_G.PluginInstallFrame.Option2:SetScript("OnEnter", OnEnter)
	_G.PluginInstallFrame.Option2:SetScript("OnLeave", OnLeave)
	_G.PluginInstallFrame.Option3:SetScript("OnEnter", OnEnter)
	_G.PluginInstallFrame.Option3:SetScript("OnLeave", OnLeave)
end

local function SetPrivateProfile(name)
	ElvPrivateDB.profiles[name] = {}
	ElvPrivateDB.profileKeys[E.mynameRealm] = name
end

local function InstallLayout()
	E:SetupCVars()
	SetupChat()
	if E.Retail then
		ChatFrame_RemoveChannel(_G.ChatFrame1, "services")
	end

	if not E.db.movers then E.db.movers = {} end

	if installSettings.v6 then
	elseif installSettings.v7 then
		MAUI:Player_v7()
		MAUI:Arena_v7()
		MAUI:Unitframes_v7()
		MAUI:Boss_v7()
		MAUI:Focus_v7()
		MAUI:Party_v7()
		MAUI:Pet_v7()
		MAUI:Raid_v7()
		MAUI:Target_v7()
		MAUI:Other_v7()
		MAUI:Actionbar_v7()
		MAUI:Bags_v7()
		MAUI:Chat_v7()
		MAUI:General_v7()
		MAUI:Datatexts_v7()
		--MAUI:MMT_v7()
		MAUI:Movers_v7()
		MAUI:Nameplates_v7()
	end
	E:StaggeredUpdateAll()
end

local function CheckInstall()
	-- backup current profile
	local currentProfile = ElvDB.profileKeys[E.mynameRealm]
	local currentPrivateProfile = ElvPrivateDB.profileKeys[E.mynameRealm]
	ElvDB.profiles["MAUI_BACKUP " .. E.mynameRealm] = ElvDB.profiles[currentProfile]
	ElvPrivateDB.profileKeys["MAUI_BACKUP " .. E.mynameRealm] = ElvPrivateDB.profiles[currentPrivateProfile]

	if ((installSettings.global or installSettings.shared) and (installSettings.v6 or installSettings.v7)) and (installSettings.tank or installSettings.dd or installSettings.heal1 or installSettings.heal2) then
		local layout = (installSettings.v6 and "v6" or (installSettings.v7 and "v7" or ""))
		local role = ((installSettings.tank or installSettings.dd) and "Tank/ DD" or (installSettings.heal1 and "Heal Center" or (installSettings.heal2 and "Heal Left" or "")))
		local profileName = ""

		if installSettings.global then
			profileName = "MaUI " .. layout .. " " .. role
		elseif installSettings.shared then
			profileName = "MaUI " .. layout .. " " .. role .. " - " .. E.mynameRealm
		end

		if ElvDB.profiles[profileName] then
			StaticPopup_Show("PROFILE_EXIST")
		else
			E.data:SetProfile(profileName)
			SetPrivateProfile("MaUI " .. layout .. " " .. role)
			InstallLayout()
		end
	else
	end
end

MAUI.InstallerData = {
	Title = MAUI.Name .. " Ver.: |CFFF7DC6F" .. MAUI.Version .. "|r",
	Name = MAUI.Name,
	tutorialImage = MAUI.Logo,
	tutorialImageSize = { 512, 128 },
	Pages = {
		[1] = function()
			_G.PluginInstallFrame.tutorialImage:Show()
			_G.PluginInstallFrame.SubTitle:SetFormattedText("Welcome to the installation for %s.", MAUI.Name)
			_G.PluginInstallFrame.Desc1:SetText("This installation process will guide you through a few steps and apply the settings to a new ElvUI profile. To protect your current profile, make a backup copy of the profile before going through this installation process.")
			_G.PluginInstallFrame.Desc2:SetText("Please press the continue button if you wish to go through the installation process, otherwise click the > Skip Process < button.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1.pic = nil
			_G.PluginInstallFrame.Option1:SetText("Skip Process")
		end,
		[2] = function()
			_G.PluginInstallFrame.Option1:SetScript("OnClick", SetupSkip)
			_G.PluginInstallFrame.tutorialImage:Show()
			_G.PluginInstallFrame.SubTitle:SetText("Profile Settings")
			_G.PluginInstallFrame.Desc1:SetText("Please click the button below to choose your Profile Settings.")
			_G.PluginInstallFrame.Desc2:SetText("New Profile will create a fresh profile for this character." .. "\n" .. "Shared Profile will create a Global MaUI Profile.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffFF3333High|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1.pic = "pic1.png"
			_G.PluginInstallFrame.Option1:SetText(GetOptionText("Shared Profile", installSettings.global))
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				installSettings.global = not installSettings.global
				installSettings.shared = installSettings.global and false
				_G.PluginInstallFrame.Option1:SetText(GetOptionText("Shared Profile", installSettings.global))
				_G.PluginInstallFrame.Option2:SetText(GetOptionText("New Profile", installSettings.shared))
			end)
			_G.PluginInstallFrame.Option2:Show()
			_G.PluginInstallFrame.Option2.pic = "pic2.png"
			_G.PluginInstallFrame.Option2:SetText(GetOptionText("New Profile", installSettings.shared))
			_G.PluginInstallFrame.Option2:SetScript("OnClick", function()
				installSettings.shared = not installSettings.shared
				installSettings.global = installSettings.shared and false
				_G.PluginInstallFrame.Option1:SetText(GetOptionText("Shared Profile", installSettings.global))
				_G.PluginInstallFrame.Option2:SetText(GetOptionText("New Profile", installSettings.shared))
			end)
		end,
		[3] = function()
			_G.PluginInstallFrame.tutorialImage:Show()
			_G.PluginInstallFrame.SubTitle:SetText("MaUI Layout Version")
			_G.PluginInstallFrame.Desc1:SetText("Please click the button below to choose your MaUI Layout Version.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffFF3333High|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1.pic = "pic3.png"
			_G.PluginInstallFrame.Option1:SetText(GetOptionText("MaUI v6", installSettings.v6))
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				if installSettings.shared or installSettings.global then
					installSettings.v6 = not installSettings.v6
					installSettings.v7 = installSettings.v6 and false
					_G.PluginInstallFrame.Option1:SetText(GetOptionText("MaUI v6", installSettings.v6))
					_G.PluginInstallFrame.Option2:SetText(GetOptionText("MaUI v7", installSettings.v7))
				else
					ErrorMessages((installSettings.shared or installSettings.global))
				end
			end)
			_G.PluginInstallFrame.Option2:Show()
			_G.PluginInstallFrame.Option2.pic = "pic1.png"
			_G.PluginInstallFrame.Option2:SetText(GetOptionText("MaUI v7", installSettings.v7))
			_G.PluginInstallFrame.Option2:SetScript("OnClick", function()
				if installSettings.shared or installSettings.global then
					installSettings.v7 = not installSettings.v7
					installSettings.v6 = installSettings.v7 and false
					_G.PluginInstallFrame.Option1:SetText(GetOptionText("MaUI v6", installSettings.v6))
					_G.PluginInstallFrame.Option2:SetText(GetOptionText("MaUI v7", installSettings.v7))
				else
					ErrorMessages((installSettings.shared or installSettings.global))
				end
			end)
		end,
		[4] = function()
			_G.PluginInstallFrame.tutorialImage:Show()
			_G.PluginInstallFrame.SubTitle:SetText("Role Layout")
			_G.PluginInstallFrame.Desc1:SetText("You can now choose the layout you want to use based on your combat role.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffFF3333High|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1.pic = "pic2.png"
			_G.PluginInstallFrame.Option1:SetText(GetOptionText("Tank/ DD", installSettings.tank))
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				if (installSettings.shared or installSettings.global) and (installSettings.v6 or installSettings.v7) then
					installSettings.tank = not installSettings.tank
					installSettings.heal1 = installSettings.tank and false
					installSettings.heal2 = installSettings.tank and false
					_G.PluginInstallFrame.Option1:SetText(GetOptionText("Tank/ DD", installSettings.tank))
					_G.PluginInstallFrame.Option2:SetText(GetOptionText("Heal Center", installSettings.heal1))
					_G.PluginInstallFrame.Option3:SetText(GetOptionText("Heal Left", installSettings.heal2))
				else
					ErrorMessages((installSettings.shared or installSettings.global), (installSettings.v6 or installSettings.v7))
				end
			end)
			_G.PluginInstallFrame.Option2:Show()
			_G.PluginInstallFrame.Option2.pic = "pic3.png"
			_G.PluginInstallFrame.Option2:SetText(GetOptionText("Heal Center", installSettings.heal1))
			_G.PluginInstallFrame.Option2:SetScript("OnClick", function()
				if (installSettings.shared or installSettings.global) and (installSettings.v6 or installSettings.v7) then
					installSettings.tank = installSettings.heal1 and false
					installSettings.heal1 = not installSettings.heal1
					installSettings.heal2 = installSettings.heal1 and false
					_G.PluginInstallFrame.Option1:SetText(GetOptionText("Tank/ DD", installSettings.tank))
					_G.PluginInstallFrame.Option2:SetText(GetOptionText("Heal Center", installSettings.heal1))
					_G.PluginInstallFrame.Option3:SetText(GetOptionText("Heal Left", installSettings.heal2))
				else
					ErrorMessages((installSettings.shared or installSettings.global), (installSettings.v6 or installSettings.v7))
				end
			end)
			_G.PluginInstallFrame.Option3:Show()
			_G.PluginInstallFrame.Option3.pic = "pic1.png"
			_G.PluginInstallFrame.Option3:SetText(GetOptionText("Heal Left", installSettings.heal2))
			_G.PluginInstallFrame.Option3:SetScript("OnClick", function()
				if (installSettings.shared or installSettings.global) and (installSettings.v6 or installSettings.v7) then
					installSettings.tank = installSettings.heal2 and false
					installSettings.heal1 = installSettings.heal2 and false
					installSettings.heal2 = not installSettings.heal2
					_G.PluginInstallFrame.Option1:SetText(GetOptionText("Tank/ DD", installSettings.tank))
					_G.PluginInstallFrame.Option2:SetText(GetOptionText("Heal Center", installSettings.heal1))
					_G.PluginInstallFrame.Option3:SetText(GetOptionText("Heal Left", installSettings.heal2))
				else
					ErrorMessages((installSettings.shared or installSettings.global), (installSettings.v6 or installSettings.v7))
				end
			end)
		end,
		[5] = function()
			_G.PluginInstallFrame.tutorialImage:Hide()
			_G.PluginInstallFrame.SubTitle:SetText("MaUI Misc")
			_G.PluginInstallFrame.Desc1:SetText("Please click the button below to setup your Additional features.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffD3CF00Medium|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1.pic = nil
			_G.PluginInstallFrame.Option1:SetText(GetOptionText("Dock", installSettings.dock))
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				installSettings.dock = not installSettings.dock
				_G.PluginInstallFrame.Option1:SetText(GetOptionText("Dock", installSettings.dock))
			end)
			_G.PluginInstallFrame.Option2:Show()
			_G.PluginInstallFrame.Option2.pic = nil
			_G.PluginInstallFrame.Option2:SetText(GetOptionText("Currency", installSettings.currency))
			_G.PluginInstallFrame.Option2:SetScript("OnClick", function()
				installSettings.currency = not installSettings.currency
				_G.PluginInstallFrame.Option2:SetText(GetOptionText("Currency", installSettings.currency))
			end)
			_G.PluginInstallFrame.Option3:Show()
			_G.PluginInstallFrame.Option3.pic = nil
			_G.PluginInstallFrame.Option3:SetText(GetOptionText("Mythic Plus Filters", installSettings.mythicPlus))
			_G.PluginInstallFrame.Option3:SetScript("OnClick", function()
				installSettings.mythicPlus = not installSettings.mythicPlus
				_G.PluginInstallFrame.Option3:SetText(GetOptionText("Mythic Plus Filters", installSettings.mythicPlus))
			end)
		end,
		[6] = function()
			_G.PluginInstallFrame.tutorialImage:Hide()
			_G.PluginInstallFrame.SubTitle:SetText("Addons")
			_G.PluginInstallFrame.Desc1:SetText("Please click the button below to setup your Additional Addons.")
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffD3CF00Medium|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1.pic = nil
			_G.PluginInstallFrame.Option1:SetText(GetOptionText("FCT", installSettings.fct))
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				installSettings.fct = not installSettings.fct
				_G.PluginInstallFrame.Option1:SetText(GetOptionText("FCT", installSettings.fct))
			end)
			_G.PluginInstallFrame.Option2:Show()
			_G.PluginInstallFrame.Option2.pic = nil
			_G.PluginInstallFrame.Option2:SetText(GetOptionText("Details", installSettings.details))
			_G.PluginInstallFrame.Option2:SetScript("OnClick", function()
				installSettings.details = not installSettings.details
				_G.PluginInstallFrame.Option2:SetText(GetOptionText("Currency", installSettings.details))
			end)
			_G.PluginInstallFrame.Option3:Show()
			_G.PluginInstallFrame.Option3.pic = nil
			_G.PluginInstallFrame.Option3:SetText(GetOptionText("DBM", installSettings.dbm))
			_G.PluginInstallFrame.Option3:SetScript("OnClick", function()
				installSettings.dbm = not installSettings.dbm
				_G.PluginInstallFrame.Option3:SetText(GetOptionText("DBM", installSettings.dbm))
			end)
		end,
		[7] = function()
			_G.PluginInstallFrame.tutorialImage:Hide()
			_G.PluginInstallFrame.SubTitle:SetText("Installation Overview")
			_G.PluginInstallFrame.Desc1:SetText(GetOverviewText())
			_G.PluginInstallFrame.Desc3:SetText("Importance: |cffFF3333High|r")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1.pic = nil
			_G.PluginInstallFrame.Option1:SetText("Install")
			_G.PluginInstallFrame.Option1:SetScript("OnClick", function()
				CheckInstall()
			end)
		end,
		[20] = function()
			_G.PluginInstallFrame.SubTitle:SetText("Installation Complete")
			_G.PluginInstallFrame.Desc1:SetText("You have completed the installation process.")
			_G.PluginInstallFrame.Desc2:SetText("Please click the button below in order to finalize the process and automatically reload your UI.")
			_G.PluginInstallFrame.Option1:Show()
			_G.PluginInstallFrame.Option1.pic = nil
			_G.PluginInstallFrame.Option1:SetScript("OnClick", SetupComplete)
			_G.PluginInstallFrame.Option1:SetText("Finished")
		end,
	},
	StepTitles = {
		[1] = "Welcome",
		[2] = "Profile Settings",
		[3] = "MaUI Layout Version",
		[4] = "Role Layout",
		[5] = "MaUI Misc",
		[6] = "Addons",
		[7] = "Overview",
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
	SetEvents()

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
		if E.private.install_complete then
			installSettings.elvui = E.private.install_complete
		end

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
