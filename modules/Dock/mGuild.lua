local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local ipairs, select, sort, unpack, wipe, ceil = ipairs, select, sort, unpack, wipe, ceil
local format, strfind, strjoin, strsplit, strmatch = format, strfind, strjoin, strsplit, strmatch

--WoW API / Variables
local _G = _G
local GetDisplayedInviteType = GetDisplayedInviteType
local GetGuildFactionInfo = GetGuildFactionInfo
local GetGuildInfo = GetGuildInfo
local GetGuildRosterInfo = GetGuildRosterInfo
local GetGuildRosterMOTD = GetGuildRosterMOTD
local GetMouseFocus = GetMouseFocus
local GetNumGuildMembers = GetNumGuildMembers
local GetQuestDifficultyColor = GetQuestDifficultyColor
local C_GuildInfo_GuildRoster = C_GuildInfo.GuildRoster
local IsInGuild = IsInGuild
local IsShiftKeyDown = IsShiftKeyDown
local LoadAddOn = LoadAddOn
local SetItemRef = SetItemRef
local ToggleGuildFrame = ToggleGuildFrame
local ToggleFriendsFrame = ToggleFriendsFrame
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown

local InviteUnit = C_PartyInfo.InviteUnit or InviteUnit
local C_PartyInfo_RequestInviteFromUnit = C_PartyInfo.RequestInviteFromUnit

local COMBAT_FACTION_CHANGE = COMBAT_FACTION_CHANGE
local REMOTE_CHAT = REMOTE_CHAT
local GUILD_MOTD = GUILD_MOTD
local GUILD = GUILD

--Variables
local mText = format("Dock %s", L["Guild"])
local mTextName = "mGuild"
local tthead, ttsubh, ttoff = { r = 0.4, g = 0.78, b = 1 }, { r = 0.75, g = 0.9, b = 1 }, { r = 0.3, g = 1, b = 0.3 }
local activezone, inactivezone = { r = 0.3, g = 1.0, b = 0.3 }, { r = 0.65, g = 0.65, b = 0.65 }
local displayString = ""
local noGuildString = ""
local guildInfoString = "%s"
local guildInfoString2 = GUILD .. ": %d/%d"
local guildMotDString = "%s |cffaaaaaa- |cffffffff%s"
local levelNameString = "|cff%02x%02x%02x%d|r |cff%02x%02x%02x%s|r"
local levelNameStatusString = "|cff%02x%02x%02x%d|r %s%s %s"
local nameRankString = "%s |cff999999-|cffffffff %s"
local standingString = E:RGBToHex(ttsubh.r, ttsubh.g, ttsubh.b) .. "%s:|r |cFFFFFFFF%s/%s (%s%%)"
local moreMembersOnlineString = strjoin("", "+ %d ", _G.FRIENDS_LIST_ONLINE, "...")
local noteString = strjoin("", "|cff999999   ", _G.LABEL_NOTE, ":|r %s")
local officerNoteString = strjoin("", "|cff999999   ", _G.GUILD_RANK1_DESC, ":|r %s")
local guildTable, guildMotD = {}, ""

local function sortByRank(a, b)
	if a and b then
		if a.rankIndex == b.rankIndex then
			return a.name < b.name
		end
		return a.rankIndex < b.rankIndex
	end
end

local function sortByName(a, b)
	if a and b then
		return a.name < b.name
	end
end

local function SortGuildTable(shift)
	if shift then
		sort(guildTable, sortByRank)
	else
		sort(guildTable, sortByName)
	end
end

local onlinestatus = {
	[0] = "",
	[1] = format("|cffFFFFFF[|r|cffFF9900%s|r|cffFFFFFF]|r", L["AFK"]),
	[2] = format("|cffFFFFFF[|r|cffFF3333%s|r|cffFFFFFF]|r", L["DND"]),
}
local mobilestatus = {
	[0] = [[|TInterface\ChatFrame\UI-ChatIcon-ArmoryChat:14:14:0:0:16:16:0:16:0:16:73:177:73|t]],
	[1] = [[|TInterface\ChatFrame\UI-ChatIcon-ArmoryChat-AwayMobile:14:14:0:0:16:16:0:16:0:16|t]],
	[2] = [[|TInterface\ChatFrame\UI-ChatIcon-ArmoryChat-BusyMobile:14:14:0:0:16:16:0:16:0:16|t]],
}

local function inGroup(name)
	return (UnitInParty(name) or UnitInRaid(name)) and "|cffaaaaaa*|r" or ""
end

local function BuildGuildTable()
	wipe(guildTable)

	local totalMembers = GetNumGuildMembers()
	for i = 1, totalMembers do
		local name, rank, rankIndex, level, _, zone, note, officerNote, connected, memberstatus, className, _, _, isMobile, _, _, guid =
			GetGuildRosterInfo(i)
		if not name then
			return
		end

		local statusInfo = isMobile and mobilestatus[memberstatus] or onlinestatus[memberstatus]
		zone = (isMobile and not connected) and REMOTE_CHAT or zone

		if connected or isMobile then
			guildTable[#guildTable + 1] = {
				name = E:StripMyRealm(name), --1
				rank = rank, --2
				level = level, --3
				zone = zone, --4
				note = note, --5
				officerNote = officerNote, --6
				online = connected, --7
				status = statusInfo, --8
				class = className, --9
				rankIndex = rankIndex, --10
				isMobile = isMobile, --11
				guid = guid, --12
			}
		end
	end
end

local function UpdateGuildMessage()
	guildMotD = GetGuildRosterMOTD()
end

local FRIEND_ONLINE = select(2, strsplit(" ", _G.ERR_FRIEND_ONLINE_SS, 2))
local resendRequest = false
local eventHandlers = {
	PLAYER_GUILD_UPDATE = C_GuildInfo_GuildRoster,
	CHAT_MSG_SYSTEM = function(_, arg1)
		if FRIEND_ONLINE ~= nil and arg1 and strfind(arg1, FRIEND_ONLINE) then
			resendRequest = true
		end
	end,
	-- when we enter the world and guildframe is not available then
	-- load guild frame, update guild message and guild xp
	PLAYER_ENTERING_WORLD = function()
		if not _G.GuildFrame and IsInGuild() then
			LoadAddOn("Blizzard_GuildUI")
			C_GuildInfo_GuildRoster()
		end
	end,
	-- Guild Roster updated, so rebuild the guild table
	GUILD_ROSTER_UPDATE = function(self)
		if resendRequest then
			resendRequest = false
			return C_GuildInfo_GuildRoster()
		else
			BuildGuildTable()
			UpdateGuildMessage()
			if GetMouseFocus() == self then
				self:GetScript("OnEnter")(self, nil, true)
			end
		end
	end,
	-- our guild message of the day changed
	GUILD_MOTD = function(_, arg1)
		guildMotD = arg1
	end,
}

local menuList = {
	{ text = _G.OPTIONS_MENU, isTitle = true, notCheckable = true },
	{ text = _G.INVITE, hasArrow = true, notCheckable = true },
	{ text = _G.CHAT_MSG_WHISPER_INFORM, hasArrow = true, notCheckable = true },
}

local function inviteClick(_, name, guid)
	E.EasyMenu:Hide()

	if not (name and name ~= "") then
		return
	end

	if guid then
		local inviteType = GetDisplayedInviteType(guid)
		if inviteType == "INVITE" or inviteType == "SUGGEST_INVITE" then
			InviteUnit(name)
		elseif inviteType == "REQUEST_INVITE" and E.Retail then
			C_PartyInfo_RequestInviteFromUnit(name)
		end
	else
		-- if for some reason guid isnt here fallback and just try to invite them
		-- this is unlikely but having a fallback doesnt hurt
		InviteUnit(name)
	end
end

local function whisperClick(_, playerName)
	E.EasyMenu:Hide()
	SetItemRef("player:" .. playerName, format("|Hplayer:%1$s|h[%1$s]|h", playerName), "LeftButton")
end

local function mDockCheckFrame()
	return (CommunitiesFrame and CommunitiesFrame:IsShown())
		or (GuildFrame and GuildFrame:IsShown())
		or (LookingForGuildFrame and LookingForGuildFrame:IsShown())
end

function mMT:CheckFrameGuild(self)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:DockTimer(self)
end

local function OnClick(self, btn)
	mMT:mOnClick(self, "CheckFrameGuild")

	if btn == "RightButton" and IsInGuild() then
		local menuCountWhispers = 0
		local menuCountInvites = 0

		menuList[2].menuList = {}
		menuList[3].menuList = {}

		for _, info in ipairs(guildTable) do
			if (info.online or info.isMobile) and info.name ~= E.myname then
				local classc, levelc = E:ClassColor(info.class), GetQuestDifficultyColor(info.level)
				if not classc then
					classc = levelc
				end

				local name = format(
					levelNameString,
					levelc.r * 255,
					levelc.g * 255,
					levelc.b * 255,
					info.level,
					classc.r * 255,
					classc.g * 255,
					classc.b * 255,
					info.name
				)
				if inGroup(info.name) ~= "" then
					name = name .. " |cffaaaaaa*|r"
				elseif not (info.isMobile and info.zone == REMOTE_CHAT) then
					menuCountInvites = menuCountInvites + 1
					menuList[2].menuList[menuCountInvites] =
						{ text = name, arg1 = info.name, arg2 = info.guid, notCheckable = true, func = inviteClick }
				end

				menuCountWhispers = menuCountWhispers + 1
				menuList[3].menuList[menuCountWhispers] =
					{ text = name, arg1 = info.name, notCheckable = true, func = whisperClick }
			end
		end

		E:SetEasyMenuAnchor(E.EasyMenu, self)
		_G.EasyMenu(menuList, E.EasyMenu, nil, nil, nil, "MENU")
	elseif InCombatLockdown() then
		_G.UIErrorsFrame:AddMessage(E.InfoColor .. _G.ERR_NOT_IN_COMBAT)
	elseif E.Retail then
		ToggleGuildFrame()
	else
		ToggleFriendsFrame(3)
	end

	mMT:ShowHideNotification(self, false)
end

local function OnEnter(self, _, noUpdate)
	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnEnter(self, "CheckFrameGuild")

	if E.db.mMT.dockdatatext.tip.enable then
		if not IsInGuild() then
			return
		end
		DT.tooltip:ClearLines()

		local shiftDown = IsShiftKeyDown()
		local total, _, online = GetNumGuildMembers()
		if #guildTable == 0 then
			BuildGuildTable()
		end

		SortGuildTable(shiftDown)

		local guildName, guildRank = GetGuildInfo("player")
		if guildName and guildRank then
			DT.tooltip:AddDoubleLine(
				format(guildInfoString, guildName),
				format(guildInfoString2, online, total),
				tthead.r,
				tthead.g,
				tthead.b,
				tthead.r,
				tthead.g,
				tthead.b
			)
			DT.tooltip:AddLine(guildRank, unpack(tthead))
		end

		if guildMotD ~= "" then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format(guildMotDString, GUILD_MOTD, guildMotD), ttsubh.r, ttsubh.g, ttsubh.b, 1)
		end

		if E.Retail then
			local _, _, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
			if standingID ~= 8 then -- Not Max Rep
				barMax = barMax - barMin
				barValue = barValue - barMin
				DT.tooltip:AddLine(
					format(
						standingString,
						COMBAT_FACTION_CHANGE,
						E:ShortValue(barValue),
						E:ShortValue(barMax),
						ceil((barValue / barMax) * 100)
					)
				)
			end
		end

		local zonec

		DT.tooltip:AddLine(" ")
		for i, info in ipairs(guildTable) do
			-- if more then 30 guild members are online, we don't Show any more, but inform user there are more
			if 30 - i < 1 then
				if online - 30 > 1 then
					DT.tooltip:AddLine(format(moreMembersOnlineString, online - 30), ttsubh.r, ttsubh.g, ttsubh.b)
				end
				break
			end

			if E.MapInfo.zoneText and (E.MapInfo.zoneText == info.zone) then
				zonec = activezone
			else
				zonec = inactivezone
			end

			local classc, levelc = E:ClassColor(info.class), GetQuestDifficultyColor(info.level)
			if not classc then
				classc = levelc
			end

			if shiftDown then
				DT.tooltip:AddDoubleLine(
					format(nameRankString, info.name, info.rank),
					info.zone,
					classc.r,
					classc.g,
					classc.b,
					zonec.r,
					zonec.g,
					zonec.b
				)
				if info.note ~= "" then
					DT.tooltip:AddLine(format(noteString, info.note), ttsubh.r, ttsubh.g, ttsubh.b, 1)
				end
				if info.officerNote ~= "" then
					DT.tooltip:AddLine(format(officerNoteString, info.officerNote), ttoff.r, ttoff.g, ttoff.b, 1)
				end
			else
				DT.tooltip:AddDoubleLine(
					format(
						levelNameStatusString,
						levelc.r * 255,
						levelc.g * 255,
						levelc.b * 255,
						info.level,
						strmatch(info.name, "([^%-]+).*"),
						inGroup(info.name),
						info.status
					),
					info.zone,
					classc.r,
					classc.g,
					classc.b,
					zonec.r,
					zonec.g,
					zonec.b
				)
			end
		end

		if not noUpdate then
			C_GuildInfo_GuildRoster()
		end

		DT.tooltip:Show()
	end
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.guild.icon],
		Notifications = true,
		Text = true,
		Spezial = false,
		IconColor = E.db.mMT.dockdatatext.guild.iconcolor,
		CustomColor = E.db.mMT.dockdatatext.guild.customcolor,
	}

	mMT:DockInitialisation(self)

	if E.db.mMT.dockdatatext.guild.color == "custom" then
		local r, g, b =
			E.db.mMT.dockdatatext.fontcolor.r, E.db.mMT.dockdatatext.fontcolor.g, E.db.mMT.dockdatatext.fontcolor.b
		TextColor = strjoin("", E:RGBToHex(r, g, b), "%s|r")
	end

	if IsInGuild() then
		local func = eventHandlers[event]
		if func then
			func(self, ...)
		end

		if not IsAltKeyDown() and event == "MODIFIER_STATE_CHANGED" and GetMouseFocus() == self then
			OnEnter(self)
		end

		if E.db.mMT.dockdatatext.guild.color == "default" then
			self.mIcon.TextA:SetFormattedText(mMT:mClassColorString(), #guildTable)
		else
			self.mIcon.TextA:SetFormattedText(
				strjoin(
					"",
					E:RGBToHex(
						E.db.mMT.dockdatatext.fontcolor.r,
						E.db.mMT.dockdatatext.fontcolor.g,
						E.db.mMT.dockdatatext.fontcolor.b
					),
					"%s|r"
				),
				#guildTable
			)
		end
	else
		self.mIcon.TextA:SetText("")
	end

	if E.Retail then
		mMT:ShowHideNotification(
			self,
			(GuildMicroButtonMixin:HasUnseenInvitations() or CommunitiesUtil.DoesAnyCommunityHaveUnreadMessages())
		)
	end
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then
		DT.tooltip:Hide()
	end

	self.mIcon.isClicked = mDockCheckFrame()
	mMT:mOnLeave(self)
end

DT:RegisterDatatext(
	mTextName,
	"mDock",
	{'CHAT_MSG_SYSTEM', 'GUILD_ROSTER_UPDATE', 'PLAYER_GUILD_UPDATE', 'GUILD_MOTD', 'MODIFIER_STATE_CHANGED'},
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	mText,
	nil,
	nil
)
