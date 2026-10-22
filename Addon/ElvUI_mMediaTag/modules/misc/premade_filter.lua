local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("PremadeFilter", { "AceEvent-3.0" })

local S = E:GetModule("Skins")

-- Cache WoW Globals
local _G = _G
local CreateFrame = CreateFrame
local format = format
local hooksecurefunc = hooksecurefunc
local GetSearchResultInfo = C_LFGList.GetSearchResultInfo
local GetSearchResultMemberCounts = C_LFGList.GetSearchResultMemberCounts
local GetActivityInfoTable = C_LFGList.GetActivityInfoTable
local GetApplicationInfo = C_LFGList.GetApplicationInfo
local GetMapTable = C_ChallengeMode.GetMapTable
local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local GetPlayerMythicPlusRatingSummary = C_PlayerInfo.GetPlayerMythicPlusRatingSummary
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local GetDungeonScoreRarityColor = C_ChallengeMode.GetDungeonScoreRarityColor
local GetSpecificDungeonOverallScoreRarityColor = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitExists = UnitExists
local IsInGroup = IsInGroup
local ipairs = ipairs
local pairs = pairs
local sort = sort
local wipe = wipe
local max = max
local unpack = unpack

local DUNGEON_CATEGORY = 2
local WIDTH, INNER, BUTTON, COLUMNS = 560, 536, 131, 4
local ICON = 36
local CELL_HEIGHT, CELL_GAP = 46, 6
local PADDING = 12
local HEADER = 44
local GAP = 4
local PLAYSTYLES = { "generalPlaystyle1", "generalPlaystyle2", "generalPlaystyle3", "generalPlaystyle4" }
local LUST_CLASSES = { "SHAMAN", "MAGE", "HUNTER", "EVOKER" }
local NEEDS = { TANK = "TANK_REMAINING", HEALER = "HEALER_REMAINING", DAMAGER = "DAMAGER_REMAINING" }
local ENUM_NEEDS = { [Enum.LFGRole.Tank] = "TANK_REMAINING", [Enum.LFGRole.Healer] = "HEALER_REMAINING", [Enum.LFGRole.Damage] = "DAMAGER_REMAINING" }
local SLOTS = { TANK_REMAINING = { "TANK", 1 }, HEALER_REMAINING = { "HEALER", 1 }, DAMAGER_REMAINING = { "DAMAGER", 3 } }
local GROUP_UNITS = { "player", "party1", "party2", "party3", "party4" }
local DIFFICULTIES = {
	{ value = 0, label = _G.ALL },
	{ value = 1, label = _G.PLAYER_DIFFICULTY1 },
	{ value = 2, label = _G.PLAYER_DIFFICULTY2 },
	{ value = 3, label = _G.PLAYER_DIFFICULTY6 },
	{ value = 4, label = "Mythic+" },
}
local DECLINED = { declined = true, declined_delisted = true }
local INACTIVE = { cancelled = true, failed = true, timedout = true, invitedeclined = true }
local INVITED = { invited = true, inviteaccepted = true }
local TOGGLES = {
	{ key = "myRole", label = L["My Role"], tip = L["Only shows groups with a free slot for your role."] },
	{ key = "fit", label = L["Party Fit"], tip = L["Only shows groups your whole party fits into."] },
	{ key = "lust", label = L["Lust"], tip = L["Only shows groups that already have a Bloodlust effect."] },
	{ key = "tank", label = _G.TANK, tip = L["Only shows groups with a free tank slot."] },
	{ key = "healer", label = _G.HEALER, tip = L["Only shows groups with a free healer slot."] },
}

local METRICS = { row = 32, section = 26, check = 24, tail = 30, cell = 46, gap = 6, textGap = 4, countGap = 2 }

local BLIZZARD_TOGGLES = {
	{ key = "needsMyClass", label = L["Class Available"], tip = format(_G.LFG_LIST_CLASS_AVAILABLE, (UnitClass("player"))) },
	{ key = "hasTank", label = _G.LFG_LIST_HAS_TANK, tip = _G.LFG_LIST_HAS_TANK },
	{ key = "hasHealer", label = _G.LFG_LIST_HAS_HEALER, tip = _G.LFG_LIST_HAS_HEALER },
}

local SORTS = {
	{ value = "score", label = L["Score: high to low"] },
	{ value = "score_low", label = L["Score: low to high"] },
	{ value = "new", label = L["Newest"] },
	{ value = "old", label = L["Oldest"] },
}

local DIFFICULTY_LABELS = {
	{ "isMythicPlusActivity", "M+", 8 },
	{ "isMythicActivity", "M", 23 },
	{ "isHeroicActivity", "HC", 2 },
	{ "isNormalActivity", "NHC", 1 },
}

local dungeons = {}
local metrics = METRICS
local dungeonCells = {}
local languageButtons = {}

local function GetFilter(categoryID)
	local categories = module.db.categories
	categories[categoryID] = categories[categoryID] or {}
	return categories[categoryID]
end

local function CurrentFilter()
	local categoryID = _G.LFGListFrame.SearchPanel.categoryID
	return categoryID and GetFilter(categoryID) or {}
end

local function IsDungeonCategory()
	return _G.LFGListFrame.SearchPanel.categoryID == DUNGEON_CATEGORY
end

local function HasBlizzardFilter()
	return _G.GameRulesUtil and _G.GameRulesUtil.IsPlayerAtEffectiveMaxLevel() and IsDungeonCategory()
end

local function PlaystyleNone(enabled)
	for _, key in ipairs(PLAYSTYLES) do
		if enabled[key] then return false end
	end

	return true
end

local function SaveSearch()
	_G.LFGListSearchPanel_DoSearch(_G.LFGListFrame.SearchPanel)
end

local function SaveBlizzardFilter(enabled)
	C_LFGList.SaveAdvancedFilter(enabled)
	SaveSearch()
end

local function ActiveCount()
	local filter = CurrentFilter()
	local count = 0
	for _, toggle in ipairs(TOGGLES) do
		if filter[toggle.key] then count = count + 1 end
	end

	if filter.blocked then count = count + 1 end
	if filter.noLeaver then count = count + 1 end
	if filter.notDeclined then count = count + 1 end
	if (filter.difficulty or 0) > 0 then count = count + 1 end
	if IsDungeonCategory() and next(filter.off or {}) then count = count + 1 end

	if HasBlizzardFilter() then
		local enabled = C_LFGList.GetAdvancedFilter()
		if enabled.needsMyClass then count = count + 1 end
		if enabled.hasTank then count = count + 1 end
		if enabled.hasHealer then count = count + 1 end
		if not PlaystyleNone(enabled) and not (enabled.generalPlaystyle1 and enabled.generalPlaystyle2 and enabled.generalPlaystyle3 and enabled.generalPlaystyle4) then count = count + 1 end
	end

	return count
end

local function IsActive(filter, dungeon)
	for _, toggle in ipairs(TOGGLES) do
		if filter[toggle.key] then return true end
	end

	if filter.blocked or filter.notDeclined or filter.noLeaver or (filter.difficulty or 0) > 0 then return true end

	return dungeon and next(filter.off or {}) ~= nil
end

-- roles of your whole party, or your own spec when solo
local function PartyNeeds()
	local needs = { TANK_REMAINING = 0, HEALER_REMAINING = 0, DAMAGER_REMAINING = 0 }
	if IsInGroup() then
		for _, unit in ipairs(GROUP_UNITS) do
			if UnitExists(unit) then
				local key = NEEDS[UnitGroupRolesAssigned(unit)] or NEEDS.DAMAGER
				needs[key] = needs[key] + 1
			end
		end
	else
		local key = ENUM_NEEDS[_G.GetSpecializationRoleEnum(C_SpecializationInfo.GetSpecialization())] or NEEDS.DAMAGER
		needs[key] = 1
	end

	return needs
end

local function Status(id, info)
	local _, appStatus, pendingStatus = GetApplicationInfo(id)
	local declines = _G.LFGListFrame.declines
	local recorded = declines and info and declines[info.partyGUID]
	local effective = appStatus
	if recorded and not (DECLINED[appStatus] or appStatus == "declined_full") then effective = recorded end

	if effective == "declined_full" then return "full" end
	if DECLINED[effective] then return "declined" end
	if INACTIVE[appStatus] or INACTIVE[pendingStatus] then return end
	if INVITED[appStatus] then return "invited" end
	if appStatus ~= "none" or pendingStatus then return "applied" end
end

-- dungeons count from the members present like the Blizzard filter does, other groups use the remaining counts
local function Remaining(counts, key, dungeon)
	if dungeon then
		local role, slots = unpack(SLOTS[key])
		return max(0, slots - (counts[role] or 0))
	end

	return counts[key] or 0
end

local function HasLust(counts)
	for _, class in ipairs(LUST_CLASSES) do
		if (counts[class] or 0) > 0 then return true end
	end
end

local function Matches(filter, id, info, ctx)
	local counts = GetSearchResultMemberCounts(id)

	if filter.myRole or filter.tank or filter.healer or filter.fit or filter.lust then
		if not counts then return false end

		if filter.myRole and ctx.myRole and Remaining(counts, ctx.myRole, ctx.dungeon) == 0 then return false end
		if filter.tank and Remaining(counts, "TANK_REMAINING", ctx.dungeon) == 0 then return false end
		if filter.healer and Remaining(counts, "HEALER_REMAINING", ctx.dungeon) == 0 then return false end
		if filter.lust and not HasLust(counts) then return false end

		if filter.fit then
			for key, amount in pairs(ctx.needs) do
				if amount > Remaining(counts, key, ctx.dungeon) then return false end
			end
		end
	end

	if filter.notDeclined and Status(id, info) == "declined" then return false end

	if filter.noLeaver then
		for index = 1, info.numMembers do
			local member = C_LFGList.GetSearchResultPlayerInfo(id, index)
			if member and member.isLeaver then return false end
		end
	end
	if filter.blocked and info.leaderName and C_FriendList.IsIgnored(info.leaderName) then return false end

	local difficulty = filter.difficulty or 0
	local excluded = ctx.dungeon and filter.off
	if difficulty > 0 or (excluded and next(excluded)) then
		local activityID = info.activityIDs[1]
		local activity = activityID and GetActivityInfoTable(activityID)
		if not activity then return false end

		if difficulty == 4 and not activity.isMythicPlusActivity then return false end
		if difficulty == 3 and not (activity.isMythicActivity and not activity.isMythicPlusActivity) then return false end
		if difficulty == 2 and not activity.isHeroicActivity then return false end
		if difficulty == 1 and not activity.isNormalActivity then return false end
		if excluded and excluded[activity.mapID] then return false end
	end

	return true
end

local function UpdateCount(shown, total)
	if not module.panel then return end

	module.panel.count:SetText(shown and format("%d / %d", shown, total) or "")
	module.panel.footer:SetText(format(L["%d filters active"], ActiveCount()))
end

-- the number of listings per dungeon, counted before our filter
local function CountDungeons(results)
	wipe(module.counts)
	local cache = {}
	for _, id in ipairs(results) do
		local info = GetSearchResultInfo(id)
		if not info or E:IsSecretValue(info.name) then return end

		local activityID = info.activityIDs[1]
		if activityID then
			if cache[activityID] == nil then
				local activity = GetActivityInfoTable(activityID)
				cache[activityID] = activity and activity.mapID or false
			end

			local mapID = cache[activityID]
			if mapID then module.counts[mapID] = (module.counts[mapID] or 0) + 1 end
		end
	end
end

local function IsGroupFull(info)
	if E:IsSecretValue(info.name) then return false end

	local activityID = info.activityIDs[1]
	local activity = activityID and GetActivityInfoTable(activityID)

	return activity and activity.maxNumPlayers > 0 and info.numMembers >= activity.maxNumPlayers
end

local RANKS = { applied = 0, invited = 0, declined = 1, full = 1 }

local function Apply(panel)
	if not module.isEnabled then return end

	local results = panel.results
	if not results then return end

	local dungeon = panel.categoryID == DUNGEON_CATEGORY
	if dungeon then
		CountDungeons(results)
		module:UpdateDungeonCells()
	end

	local filter = module.db.categories[panel.categoryID] or {}
	local active = IsActive(filter, dungeon)
	local ctx = {
		dungeon = dungeon,
		myRole = ENUM_NEEDS[_G.GetSpecializationRoleEnum(C_SpecializationInfo.GetSpecialization())],
		needs = filter.fit and PartyNeeds(),
	}

	-- your applications go on top, even when their group dropped out of the results
	local ids, seen = {}, {}
	for _, id in ipairs(results) do
		ids[#ids + 1] = id
		seen[id] = true
	end

	for _, id in ipairs(panel.applications or {}) do
		if not seen[id] and C_LFGList.HasSearchResultInfo(id) then ids[#ids + 1] = id end
	end

	local kept, keys, ranks, order = {}, {}, {}, {}
	local ranked
	for index, id in ipairs(ids) do
		local info = GetSearchResultInfo(id)
		-- results are secret inside an instance, leave the list alone then
		if not info or E:IsSecretValue(info.name) then
			UpdateCount()
			return
		end

		local status = Status(id, info)
		if status == "applied" and IsGroupFull(info) then status = "full" end

		local rank = RANKS[status] or 2
		if rank < 2 then ranked = true end

		if rank == 0 or not active or Matches(filter, id, info, ctx) then
			kept[#kept + 1] = id
			ranks[id] = rank
			order[id] = index
			keys[id] = (filter.sort == "score" or filter.sort == "score_low") and (info.leaderOverallDungeonScore or 0) or info.age or 0
		end
	end

	if not (active or ranked or filter.sort or #ids ~= #results) then
		UpdateCount()
		return
	end

	local descending = filter.sort == "score" or filter.sort == "old"
	sort(kept, function(a, b)
		if ranks[a] ~= ranks[b] then return ranks[a] < ranks[b] end
		if filter.sort and keys[a] ~= keys[b] then
			if descending then return keys[a] > keys[b] end

			return keys[a] < keys[b]
		end

		return order[a] < order[b]
	end)

	if active then
		UpdateCount(#kept, #ids)
	else
		UpdateCount()
	end

	panel.results = kept
	panel.applications = {}
	panel.totalResults = #kept
	_G.LFGListSearchPanel_UpdateResults(panel)
end

local function Refresh()
	local panel = _G.LFGListFrame.SearchPanel
	if panel:IsShown() and not panel.searching then _G.LFGListSearchPanel_UpdateResultList(panel) end
end

local function UpdateScore(button, info)
	local text = button.mMTScore
	local score = info and module.db.leader_score and info.leaderOverallDungeonScore
	if not score or E:IsSecretValue(score) or score <= 0 then
		if text then text:Hide() end
		return
	end

	if not text then
		text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		text:SetPoint("TOPRIGHT", button, "TOPRIGHT", -10, -6)
		button.mMTScore = text
	end

	local color = GetDungeonScoreRarityColor(score) or _G.HIGHLIGHT_FONT_COLOR
	text:SetText(color:WrapTextInColorCode(score))
	text:Show()
end

local function UpdateDifficulty(button, info)
	if not (info and module.db.short_difficulty) then return end

	local activityID = info.activityIDs[1]
	local activity = activityID and GetActivityInfoTable(activityID)
	local text = button.ActivityName:GetText()
	if not activity or not text or E:IsSecretValue(text) then return end

	local name, found = text:gsub("%s*%b()%s*$", "")
	if found == 0 then return end

	for _, entry in ipairs(DIFFICULTY_LABELS) do
		if activity[entry[1]] then
			local difficulty = mMT:GetShortDifficulty(entry[3])
			local label = difficulty and difficulty.color:WrapTextInColorCode(entry[2]) or entry[2]
			button.ActivityName:SetText(format("%s (%s)", name, label))
			return
		end
	end
end

local function ColorEntry(button)
	if not module.isEnabled and not button.mMTStatus and not button.mMTScore then return end

	local tint = button.mMTStatus
	local id = button.resultID
	local info = module.isEnabled and id and C_LFGList.HasSearchResultInfo(id) and GetSearchResultInfo(id)
	local status = info and Status(id, info)
	-- a pending application to a full group, or one Blizzard marks as no longer matching
	if status == "applied" and (button.isNowFilteredOut or IsGroupFull(info)) then status = "full" end

	UpdateScore(button, info)
	UpdateDifficulty(button, info)

	if not status then
		if tint then tint:Hide() end
		return
	end

	if not tint then
		tint = button:CreateTexture(nil, "BACKGROUND")
		tint:SetPoint("TOPLEFT", 1, -1)
		tint:SetPoint("BOTTOMRIGHT", -1, 1)
		tint:SetTexture(E.media.blankTex)
		button.mMTStatus = tint
	end

	local r, g, b = 0.2, 0.8, 0.3
	if status ~= "invited" then
		r, g, b = mMT:HexToRGB(module.db.colors[status])
	end
	tint:SetVertexColor(r, g, b, 0.28)
	tint:Show()
	button.BackgroundTexture:Hide()
end

local function Tooltip(frame, text)
	frame:HookScript("OnEnter", function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_TOP")
		_G.GameTooltip:SetText(text, 1, 1, 1, 1, true)
		_G.GameTooltip:Show()
	end)
	frame:HookScript("OnLeave", _G.GameTooltip_Hide)
end

local function CreateLabel(parent, text, template)
	local label = parent:CreateFontString(nil, "OVERLAY", template or "GameFontNormalSmall")
	label:SetText(text)
	label:SetJustifyH("LEFT")

	return label
end

local function CreateSection(parent, text)
	local label = CreateLabel(parent, mMT:TC(text, "line_a"), "GameFontNormal")
	local line = parent:CreateTexture(nil, "ARTWORK")
	line:SetTexture(E.media.blankTex)
	line:SetHeight(1)
	line:SetVertexColor(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b, 0.6)
	label.line = line

	return label
end

local function CreateCheck(parent, label, onClick)
	local check = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
	S:HandleCheckBox(check)
	check:Size(20)
	check:SetScript("OnClick", onClick)

	check.text = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	check.text:SetPoint("LEFT", check, "RIGHT", 4, 0)
	check.text:SetText(label)

	return check
end

local function SetButtonState(button, on)
	button.active = on
	if not button.toggle then
		button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		button.text:SetTextColor(1, 1, 1)
	elseif on then
		button:SetBackdropBorderColor(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b)
		button.text:SetTextColor(1, 1, 1)
	else
		button:SetBackdropBorderColor(unpack(E.media.bordercolor))
		button.text:SetTextColor(0.65, 0.65, 0.65)
	end
end

local function CreateButton(parent, text, width, onClick, toggle)
	local button = CreateFrame("Button", nil, parent, "BackdropTemplate")
	button.toggle = toggle
	button:SetTemplate("Default")
	button:Size(width, 22)

	button.text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	button.text:SetPoint("CENTER")
	button.text:SetText(text)

	button:SetScript("OnClick", onClick)
	button:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b)
	end)
	button:SetScript("OnLeave", function(self)
		SetButtonState(self, self.active)
	end)
	SetButtonState(button, false)

	return button
end

local function BuildDungeons()
	wipe(dungeons)
	for _, challengeMapID in ipairs(GetMapTable() or {}) do
		local name, _, _, texture, _, instanceID = GetMapUIInfo(challengeMapID)
		if name and instanceID then dungeons[#dungeons + 1] = { name = name, texture = texture, instanceID = instanceID, challengeMapID = challengeMapID } end
	end

	sort(dungeons, function(a, b)
		return a.name < b.name
	end)
end

local function StoreDungeons(states)
	local off = {}
	for _, dungeon in ipairs(dungeons) do
		if not states[dungeon.instanceID] then off[dungeon.instanceID] = true end
	end

	CurrentFilter().off = next(off) and off or nil
	module:UpdateDungeonCells()
	Refresh()
end

local function CreateDungeonCell(panel, index)
	local cell = CreateFrame("Button", nil, panel, "BackdropTemplate")
	cell:Size((INNER - CELL_GAP * (COLUMNS - 1)) / COLUMNS, CELL_HEIGHT)
	cell:SetTemplate("Default")

	cell.icon = cell:CreateTexture(nil, "ARTWORK")
	cell.icon:Size(ICON)
	cell.icon:SetPoint("LEFT", 5, 0)
	cell.icon:SetTexCoord(unpack(E.TexCoords))

	cell.name = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cell.name:SetPoint("TOPLEFT", cell.icon, "TOPRIGHT", 8, 0)
	cell.name:SetPoint("RIGHT", cell, "RIGHT", -4, 0)
	cell.name:SetJustifyH("LEFT")
	cell.name:SetWordWrap(false)

	cell.level = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cell.level:SetPoint("TOPLEFT", cell.name, "BOTTOMLEFT", 0, -4)
	cell.level:SetFont(cell.level:GetFont(), 12, "OUTLINE")

	cell.score = cell:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	cell.score:SetPoint("LEFT", cell.level, "LEFT", 44, 0)

	cell.track = cell:CreateTexture(nil, "ARTWORK")
	cell.track:SetTexture(E.media.blankTex)
	cell.track:SetVertexColor(1, 1, 1, 0.1)
	cell.track:SetHeight(6)

	cell.bar = cell:CreateTexture(nil, "OVERLAY")
	cell.bar:SetTexture(E.media.blankTex)
	cell.bar:SetHeight(6)
	cell.bar:SetPoint("TOPLEFT", cell.track, "TOPLEFT")

	cell:SetScript("OnClick", function(self)
		local off = CurrentFilter().off or {}
		local states = {}
		for _, dungeon in ipairs(dungeons) do
			states[dungeon.instanceID] = not off[dungeon.instanceID]
		end

		states[self.instanceID] = not states[self.instanceID]
		StoreDungeons(states)
	end)

	cell:SetScript("OnEnter", function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_TOP")
		_G.GameTooltip:SetText(self.dungeonName, 1, 1, 1)
		_G.GameTooltip:AddLine(format("%s: %d", L["Groups"], self.groups), 1, 1, 1)
		_G.GameTooltip:Show()
	end)
	cell:SetScript("OnLeave", _G.GameTooltip_Hide)

	dungeonCells[index] = cell

	return cell
end

function module:UpdateDungeonCells()
	local panel = module.panel
	if not (panel and panel.dungeonLabel:IsShown()) then return end

	local off = CurrentFilter().off or {}
	local summary = GetPlayerMythicPlusRatingSummary("player")
	local runs = {}
	for _, run in ipairs(summary and summary.runs or {}) do
		runs[run.challengeModeID] = run
	end

	local overall = summary and summary.currentSeasonScore or 0
	local overallColor = GetDungeonScoreRarityColor(overall) or _G.HIGHLIGHT_FONT_COLOR
	panel.rating:SetText(format("%s %s", L["Score"], overallColor:WrapTextInColorCode(overall)))

	local width = (INNER - CELL_GAP * (COLUMNS - 1)) / COLUMNS
	local maxGroups = 1
	for _, dungeon in ipairs(dungeons) do
		maxGroups = max(maxGroups, module.counts[dungeon.instanceID] or 0)
	end

	for index, dungeon in ipairs(dungeons) do
		local cell = dungeonCells[index] or CreateDungeonCell(panel, index)
		local enabled = not off[dungeon.instanceID]
		local run = runs[dungeon.challengeMapID]
		local groups = module.counts[dungeon.instanceID] or 0
		local r, g, b = MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b

		cell.instanceID = dungeon.instanceID
		cell.dungeonName = dungeon.name
		cell.groups = groups
		cell.bestLevel = run and run.bestRunLevel or 0
		cell.icon:SetTexture(dungeon.texture)
		cell.icon:SetDesaturated(not enabled)
		cell.name:SetText(dungeon.name)
		cell.bar:SetVertexColor(r, g, b, 0.9)
		cell.bar:SetWidth(max(1, (width - ICON - 21) * groups / maxGroups))
		cell.bar:SetShown(groups > 0)
		cell:SetAlpha(enabled and 1 or 0.5)

		if enabled then
			cell:SetBackdropBorderColor(r, g, b)
		else
			cell:SetBackdropBorderColor(unpack(E.media.bordercolor))
		end

		if cell.bestLevel > 0 then
			local color = run.finishedSuccess and GetKeystoneLevelRarityColor(cell.bestLevel) or _G.GRAY_FONT_COLOR
			local scoreColor = GetSpecificDungeonOverallScoreRarityColor(run.mapScore) or _G.HIGHLIGHT_FONT_COLOR
			cell.level:SetText(color:WrapTextInColorCode("+" .. cell.bestLevel))
			cell.score:SetText(scoreColor:WrapTextInColorCode(run.mapScore))
		else
			cell.level:SetText("")
			cell.score:SetText("")
		end

		cell:SetSize(width, CELL_HEIGHT)
		cell.level:ClearAllPoints()
		cell.level:SetPoint("TOPLEFT", cell.name, "BOTTOMLEFT", 0, -metrics.textGap)
		cell.track:ClearAllPoints()
		cell.track:SetPoint("TOPLEFT", cell.level, "BOTTOMLEFT", 0, -metrics.countGap - 3)
		cell.track:SetPoint("RIGHT", cell, "RIGHT", -8, 0)
		cell:ClearAllPoints()
		cell:SetPoint("TOPLEFT", panel.dungeonLabel, "BOTTOMLEFT", ((index - 1) % COLUMNS) * (width + CELL_GAP), -8 - math.floor((index - 1) / COLUMNS) * (CELL_HEIGHT + CELL_GAP))
		cell:Show()
	end

	for index = #dungeons + 1, #dungeonCells do
		dungeonCells[index]:Hide()
	end
end

local function SelectDungeons(isEnabled)
	local off = CurrentFilter().off or {}
	local lowest
	for index, cell in ipairs(dungeonCells) do
		if dungeons[index] then lowest = math.min(lowest or cell.bestLevel, cell.bestLevel) end
	end

	local states = {}
	for index, dungeon in ipairs(dungeons) do
		states[dungeon.instanceID] = isEnabled(not off[dungeon.instanceID], dungeonCells[index].bestLevel == lowest)
	end

	StoreDungeons(states)
end

local function LanguageState(lang)
	return C_LFGList.GetLanguageSearchFilter()[lang] or C_LFGList.GetDefaultLanguageSearchFilter()[lang]
end

local function UpdateLanguages()
	local all = true
	for lang, button in pairs(languageButtons) do
		if lang ~= "any" then
			local on = LanguageState(lang) and true or false
			SetButtonState(button, on)
			all = all and on
		end
	end

	if languageButtons.any then SetButtonState(languageButtons.any, all) end
end

local function BuildLanguages(panel)
	if panel.languagesBuilt then return end

	local available = C_LFGList.GetAvailableLanguageSearchFilter()
	if not (available and #available > 0) then return end

	panel.languagesBuilt = true
	local width = (INNER - GAP * #available) / (#available + 1)

	languageButtons.any = CreateButton(panel, _G.ALL, width, function()
		local enabled = C_LFGList.GetLanguageSearchFilter()
		for _, lang in ipairs(available) do
			enabled[lang] = true
		end

		C_LFGList.SaveLanguageSearchFilter(enabled)
		UpdateLanguages()
		SaveSearch()
	end, true)

	for _, lang in ipairs(available) do
		local button = CreateButton(panel, lang:sub(1, 2):upper(), width, function()
			if C_LFGList.GetDefaultLanguageSearchFilter()[lang] then return end

			local enabled = C_LFGList.GetLanguageSearchFilter()
			enabled[lang] = not LanguageState(lang)
			C_LFGList.SaveLanguageSearchFilter(enabled)
			UpdateLanguages()
			SaveSearch()
		end, true)
		languageButtons[lang] = button
	end

	panel.languageOrder = available
end

local function AnchorRaiderIO(restore)
	local anchor = _G.RaiderIO_ProfileTooltipAnchor
	local panel = module.panel
	if not (anchor and panel) or module.anchoring or anchor:GetParent() ~= _G.PVEFrame then return end

	module.anchoring = true
	anchor:ClearAllPoints()
	if module.isEnabled and panel:IsVisible() and restore ~= true then
		anchor:SetPoint("TOPLEFT", panel, "TOPRIGHT", -12, 0)
	else
		anchor:SetPoint("TOPLEFT", _G.PVEFrame, "TOPRIGHT", -16, 0)
	end
	module.anchoring = false
end

local function HookRaiderIO()
	local anchor = _G.RaiderIO_ProfileTooltipAnchor
	if module.raiderIOHooked or not anchor then return end

	hooksecurefunc(anchor, "SetPoint", AnchorRaiderIO)
	module.raiderIOHooked = true
end

-- Raider.IO creates and places its anchor after the frame shows
local function SyncRaiderIO()
	HookRaiderIO()
	AnchorRaiderIO()
	C_Timer.After(0.2, function()
		HookRaiderIO()
		AnchorRaiderIO()
	end)
end

local function Layout()
	COLUMNS = module.db.columns or 4
	WIDTH = max(400, 24 + COLUMNS * 130 + (COLUMNS - 1) * 6)
	INNER = WIDTH - 24
	BUTTON = (INNER - 12) / 4
	local panel = module.panel
	local dungeon = IsDungeonCategory()
	local y = -HEADER
	CELL_HEIGHT, CELL_GAP = metrics.cell, metrics.gap

	local function Place(frame, x, offset)
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", panel, "TOPLEFT", x or PADDING, y)
		if offset then y = y - offset end
	end

	local function PlaceSection(section)
		Place(section, nil, 0)
		section.line:ClearAllPoints()
		section.line:SetPoint("TOPLEFT", section, "BOTTOMLEFT", 0, -3)
		section.line:SetWidth(INNER)
		y = y - metrics.section
	end

	local checks = {}
	for _, check in ipairs(panel.toggles) do
		checks[#checks + 1] = check
	end

	local blizzard = HasBlizzardFilter() and true or false
	for _, check in ipairs(panel.blizzardToggles) do
		check:SetShown(blizzard)
		if blizzard then checks[#checks + 1] = check end
	end

	for index, check in ipairs(checks) do
		Place(check, PADDING + ((index - 1) % 3) * (INNER / 3))
		if index % 3 == 0 or index == #checks then y = y - metrics.check end
	end
	y = y - 8

	panel.difficulty:SetWidth(INNER / 2 - 2)
	panel.sort:SetWidth(INNER / 2 - 2)
	Place(panel.difficulty, nil, 0)
	Place(panel.sort, PADDING + INNER / 2 + 2, metrics.row)

	BuildLanguages(panel)
	local showLanguages = panel.languagesBuilt and _G.LFGListCanChangeLanguages and _G.LFGListCanChangeLanguages()
	panel.regionLabel:SetShown(showLanguages and true or false)
	for _, button in pairs(languageButtons) do
		button:SetShown(showLanguages and true or false)
	end

	if showLanguages then
		local order = { languageButtons.any }
		for _, lang in ipairs(panel.languageOrder) do
			order[#order + 1] = languageButtons[lang]
		end

		-- bottom aligned, directly above the footer
		local buttonWidth = (INNER - GAP * #panel.languageOrder) / (#panel.languageOrder + 1)
		for _, button in ipairs(order) do
			button:SetWidth(buttonWidth)
		end

		for index, button in ipairs(order) do
			button:ClearAllPoints()
			button:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", PADDING + (index - 1) * (buttonWidth + GAP), PADDING + 36)
		end

		panel.regionLabel:ClearAllPoints()
		panel.regionLabel:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", PADDING, PADDING + 36 + 22 + 10)
		panel.regionLabel.line:ClearAllPoints()
		panel.regionLabel.line:SetPoint("TOPLEFT", panel.regionLabel, "BOTTOMLEFT", 0, -3)
		panel.regionLabel.line:SetWidth(INNER)
		panel.regionLabel.line:Show()

		UpdateLanguages()
	else
		panel.regionLabel.line:Hide()
	end

	panel.dungeonLabel:SetShown(dungeon)
	panel.dungeonLabel.line:SetShown(dungeon)
	panel.rating:SetShown(dungeon)
	for _, button in ipairs(panel.dungeonButtons) do
		button:SetShown(dungeon)
	end
	if dungeon then
		BuildDungeons()
		PlaceSection(panel.dungeonLabel)
		module:UpdateDungeonCells()
		y = y - math.ceil(#dungeons / COLUMNS) * (CELL_HEIGHT + CELL_GAP) - 12
		for index, button in ipairs(panel.dungeonButtons) do
			button:SetWidth(BUTTON)
			Place(button, PADDING + (index - 1) * (BUTTON + GAP))
		end
		y = y - 30
	else
		for _, cell in ipairs(dungeonCells) do
			cell:Hide()
		end
	end

	if showLanguages then y = y - metrics.section - metrics.row end

	local height = -y + metrics.tail + PADDING
	panel.reset:SetWidth(BUTTON)

	panel.footer:ClearAllPoints()
	panel.footer:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", PADDING, PADDING + 5)
	panel.filterMenu:ClearAllPoints()
	panel.filterMenu:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -PADDING - BUTTON - GAP, PADDING - 2)
	panel.reset:ClearAllPoints()
	panel.reset:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -PADDING, PADDING)
	panel:SetSize(WIDTH, max(height, _G.PVEFrame:GetHeight()))
end

local function LoadCategory()
	local panel = module.panel
	if not (panel and _G.LFGListFrame.SearchPanel.categoryID) then return end

	HookRaiderIO()

	local filter = CurrentFilter()
	for _, button in ipairs(panel.toggles) do
		button:SetChecked(filter[button.key] and true or false)
	end

	if HasBlizzardFilter() then
		local enabled = C_LFGList.GetAdvancedFilter()
		for _, button in ipairs(panel.blizzardToggles) do
			button:SetChecked(enabled[button.key] and true or false)
		end
	end

	panel.difficulty:GenerateMenu()
	panel.sort:GenerateMenu()
	panel.filterMenu:GenerateMenu()

	UpdateCount()
	Layout()
end

local function CreatePanel()
	local searchPanel = _G.LFGListFrame.SearchPanel
	local panel = CreateFrame("Frame", "mMediaTag_PremadeFilter", searchPanel, "BackdropTemplate")
	module.panel = panel
	panel:SetTemplate("Transparent")
	panel:SetPoint("TOPLEFT", _G.PVEFrame, "TOPRIGHT", 4, 0)

	local title = CreateLabel(panel, mMT:TC(L["Premade Filter"], "line_a"), "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", PADDING, -14)

	local line = panel:CreateTexture(nil, "ARTWORK")
	line:SetTexture(E.media.blankTex)
	line:SetHeight(2)
	line:SetPoint("TOPLEFT", PADDING, -38)
	line:SetPoint("TOPRIGHT", -PADDING, -38)
	line:SetVertexColor(MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b, 1)

	panel.rating = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	panel.rating:SetPoint("TOP", panel, "TOP", 0, -17)

	panel.count = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	panel.count:SetPoint("TOPRIGHT", -PADDING - 28, -17)

	local settings = CreateButton(panel, "", 22, function()
		if not E:AlertCombat() then E:ToggleOptions("mMT,group,premade_filter") end
	end)
	settings:SetPoint("TOPRIGHT", -PADDING, -12)
	settings.icon = settings:CreateTexture(nil, "ARTWORK")
	settings.icon:Size(14)
	settings.icon:SetPoint("CENTER")
	settings.icon:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tags\\settings.tga")
	Tooltip(settings, L["Settings"])

	panel.toggles = {}
	for index, toggle in ipairs(TOGGLES) do
		local button = CreateCheck(panel, toggle.label, function(self)
			local filter = CurrentFilter()
			filter[toggle.key] = self:GetChecked() and true or nil
			panel.filterMenu:GenerateMenu()
			Refresh()
		end)
		button.key = toggle.key
		Tooltip(button, toggle.tip)
		panel.toggles[index] = button
	end

	panel.blizzardToggles = {}
	for index, toggle in ipairs(BLIZZARD_TOGGLES) do
		local button = CreateCheck(panel, toggle.label, function(self)
			local enabled = C_LFGList.GetAdvancedFilter()
			enabled[toggle.key] = self:GetChecked() and true or false
			SaveBlizzardFilter(enabled)
		end)
		button.key = toggle.key
		Tooltip(button, toggle.tip)
		panel.blizzardToggles[index] = button
	end

	panel.difficulty = CreateFrame("DropdownButton", nil, panel, "WowStyle1DropdownTemplate")
	panel.difficulty:Height(22)
	panel.difficulty:SetupMenu(function(_, root)
		for _, option in ipairs(DIFFICULTIES) do
			root:CreateRadio(option.label, function()
				return (CurrentFilter().difficulty or 0) == option.value
			end, function()
				CurrentFilter().difficulty = option.value > 0 and option.value or nil
				Refresh()
			end)
		end
	end)
	S:HandleDropDownBox(panel.difficulty, INNER / 2 - 2)
	panel.difficulty:SetHeight(26)

	panel.sort = CreateFrame("DropdownButton", nil, panel, "WowStyle1DropdownTemplate")
	panel.sort:SetupMenu(function(_, root)
		root:CreateRadio(_G.DEFAULT, function()
			return not CurrentFilter().sort
		end, function()
			CurrentFilter().sort = nil
			Refresh()
		end)

		for _, option in ipairs(SORTS) do
			root:CreateRadio(option.label, function()
				return CurrentFilter().sort == option.value
			end, function()
				CurrentFilter().sort = option.value
				Refresh()
			end)
		end
	end)
	S:HandleDropDownBox(panel.sort, INNER / 2 - 2)
	panel.sort:SetHeight(26)
	panel.sort:SetSelectionText(function()
		local value = CurrentFilter().sort
		for _, option in ipairs(SORTS) do
			if option.value == value then return L["Sort"] .. ": " .. option.label end
		end

		return L["Sort"]
	end)

	panel.regionLabel = CreateSection(panel, L["Region"])
	panel.dungeonLabel = CreateSection(panel, L["Season Dungeons"])

	panel.dungeonButtons = {
		CreateButton(panel, _G.ALL, BUTTON, function()
			SelectDungeons(function()
				return true
			end)
		end),
		CreateButton(panel, _G.NONE, BUTTON, function()
			SelectDungeons(function()
				return false
			end)
		end),
		CreateButton(panel, L["Invert"], BUTTON, function()
			SelectDungeons(function(enabled)
				return not enabled
			end)
		end),
		CreateButton(panel, L["Lowest"], BUTTON, function()
			SelectDungeons(function(_, isLowest)
				return isLowest
			end)
		end),
	}

	panel.footer = CreateLabel(panel, "", "GameFontHighlightSmall")

	panel.filterMenu = CreateFrame("DropdownButton", nil, panel, "WowStyle1DropdownTemplate")
	panel.filterMenu:Height(22)
	panel.filterMenu:SetDefaultText("+ " .. L["Filter"])
	panel.filterMenu:SetupMenu(function(_, root)
		local function Check(parent, text, get, set)
			parent:CreateCheckbox(text, get, function()
				set()
				panel.filterMenu:GenerateMenu()
			end)
		end

		if HasBlizzardFilter() then
			local playstyle = root:CreateButton(_G.GROUP_FINDER_FILTER_PLAYSTYLE)
			for index, key in ipairs(PLAYSTYLES) do
				Check(playstyle, _G["GROUP_FINDER_GENERAL_PLAYSTYLE" .. index], function()
					local enabled = C_LFGList.GetAdvancedFilter()
					return PlaystyleNone(enabled) or enabled[key]
				end, function()
					local enabled = C_LFGList.GetAdvancedFilter()
					local none = PlaystyleNone(enabled)
					for _, other in ipairs(PLAYSTYLES) do
						if none then enabled[other] = true end
					end

					enabled[key] = not enabled[key]
					SaveBlizzardFilter(enabled)
				end)
			end
		end

		Check(root, L["Hide groups with a deserter"], function()
			return CurrentFilter().noLeaver
		end, function()
			local filter = CurrentFilter()
			filter.noLeaver = (not filter.noLeaver) or nil
			Refresh()
		end)

		local blocked = root:CreateButton(L["Blocked"])
		Check(blocked, L["Hide leaders I blocked"], function()
			return CurrentFilter().blocked
		end, function()
			local filter = CurrentFilter()
			filter.blocked = (not filter.blocked) or nil
			Refresh()
		end)
		Check(blocked, L["Hide groups that declined me"], function()
			return CurrentFilter().notDeclined
		end, function()
			local filter = CurrentFilter()
			filter.notDeclined = (not filter.notDeclined) or nil
			Refresh()
		end)
	end)
	S:HandleDropDownBox(panel.filterMenu, 130)
	panel.filterMenu:SetHeight(26)
	panel.filterMenu:SetSelectionText(function()
		return "+ " .. L["Filter"]
	end)

	panel.reset = CreateButton(panel, _G.RESET, BUTTON, function()
		module.db.categories[searchPanel.categoryID] = nil
		LoadCategory()
		Refresh()
	end)

	panel:SetShown(module.isEnabled)
end

local function SetupHooks()
	if module.hooked then return true end

	local lfgFrame = _G.LFGListFrame
	if not (lfgFrame and lfgFrame.SearchPanel and _G.PVEFrame and type(_G.LFGListSearchPanel_UpdateResultList) == "function") then return end

	module.counts = module.counts or {}
	CreatePanel()
	hooksecurefunc("LFGListSearchPanel_UpdateResultList", Apply)
	hooksecurefunc("LFGListSearchPanel_SetCategory", LoadCategory)
	hooksecurefunc("LFGListSearchEntry_Update", ColorEntry)
	lfgFrame.SearchPanel:HookScript("OnShow", LoadCategory)
	module.panel:HookScript("OnShow", SyncRaiderIO)
	_G.PVEFrame:HookScript("OnShow", SyncRaiderIO)
	module.panel:HookScript("OnHide", function()
		AnchorRaiderIO(true)
	end)
	module.hooked = true

	return true
end

function module:ADDON_LOADED()
	if SetupHooks() then
		module:UnregisterEvent("ADDON_LOADED")
		LoadCategory()
	end
end

function module:Initialize()
	module.db = E.db.mMediaTag.premade_filter
	module.isEnabled = module.db.enable

	if module.isEnabled and not SetupHooks() then module:RegisterEvent("ADDON_LOADED") end
	if not module.hooked then return end

	module.panel:SetShown(module.isEnabled)
	LoadCategory()
	Refresh()
end
