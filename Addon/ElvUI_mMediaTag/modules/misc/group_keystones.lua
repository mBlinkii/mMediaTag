local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("GroupKeystones", { "AceEvent-3.0" })

-- Cache WoW Globals
local _G = _G
local unpack = unpack
local ipairs = ipairs
local LibStub = LibStub
local CreateFrame = CreateFrame
local format = format
local Ambiguate = Ambiguate
local GetNumGroupMembers = GetNumGroupMembers
local GetUnitName = GetUnitName
local IsInGroup = IsInGroup
local UnitClass = UnitClass
local UnitExists = UnitExists
local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local GetOwnedKeystoneChallengeMapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID
local GetOwnedKeystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel
local GetClassColor = C_ClassColor.GetClassColor

local MAX_ROWS = 5
local ROW_HEIGHT = 20
local PADDING = 6

local units = { "player", "party1", "party2", "party3", "party4" }
local libKeystoneData = {}
local listeners = {}
local LOR, LKS, sourcesReady

local function PlainValue(value)
	if not E:IsSecretValue(value) then return value end
end

local function ValidKey(level, challengeMapID)
	return level and challengeMapID and level > 0 and challengeMapID > 0
end

local function NotifyListeners()
	for _, func in ipairs(listeners) do
		func()
	end
end

local sourceHandler = { OnKeystoneUpdate = NotifyListeners }

-- Details! (LibOpenRaid) and BigWigs (LibKeystone) are hooked once and shared by every module that reads group keys
local function InitSources()
	if sourcesReady then return end
	sourcesReady = true

	LOR = LibStub("LibOpenRaid-1.0", true)
	if LOR then LOR.RegisterCallback(sourceHandler, "KeystoneUpdate", "OnKeystoneUpdate") end

	LKS = LibStub("LibKeystone", true)
	if LKS then
		LKS.Register(sourceHandler, function(level, challengeMapID, _, sender)
			libKeystoneData[sender] = ValidKey(level, challengeMapID) and { level = level, challengeMapID = challengeMapID } or nil
			NotifyListeners()
		end)
	end
end

-- Details! (LibOpenRaid) first, BigWigs (LibKeystone) as fallback
local function GetUnitKeystone(unit)
	if unit == "player" then return GetOwnedKeystoneLevel(), GetOwnedKeystoneChallengeMapID() end

	local info = LOR and LOR.GetKeystoneInfo(unit)
	if info and ValidKey(info.level, info.challengeMapID) then return info.level, info.challengeMapID end

	local name = PlainValue(GetUnitName(unit, true))
	info = name and libKeystoneData[Ambiguate(name, "none")]
	if info then return info.level, info.challengeMapID end
end

-- level and challengeMapID of a group member, nil when unknown (other players need Details! or BigWigs)
function mMT:GetUnitKeystone(unit)
	InitSources()
	local level, challengeMapID = GetUnitKeystone(unit)
	if ValidKey(level, challengeMapID) then return level, challengeMapID end
end

function mMT:RequestGroupKeystones()
	InitSources()
	if not IsInGroup() then return end
	if LOR then LOR.RequestKeystoneDataFromParty() end
	if LKS then LKS.Request("PARTY") end
end

-- func runs whenever a group member's keystone arrives
function mMT:AddGroupKeystoneListener(func)
	InitSources()
	listeners[#listeners + 1] = func
end

local function CreateRow(frame, index)
	local row = CreateFrame("Frame", nil, frame)
	row:Height(ROW_HEIGHT)
	row:Point("TOPLEFT", frame.title, "BOTTOMLEFT", 0, -2 - (index - 1) * ROW_HEIGHT)
	row:Point("RIGHT", frame, "RIGHT", -PADDING, 0)

	row.icon = row:CreateTexture(nil, "ARTWORK")
	row.icon:Size(ROW_HEIGHT - 4)
	row.icon:Point("LEFT", row, "LEFT", 2, 0)
	row.icon:SetTexCoord(unpack(E.TexCoords))

	row.key = row:CreateFontString(nil, "OVERLAY")
	row.key:FontTemplate(nil, 12, "OUTLINE")
	row.key:Point("LEFT", row.icon, "RIGHT", 4, 0)
	row.key:SetJustifyH("LEFT")

	row.name = row:CreateFontString(nil, "OVERLAY")
	row.name:FontTemplate(nil, 12, "OUTLINE")
	row.name:Point("RIGHT", row, "RIGHT", -2, 0)
	row.name:SetJustifyH("RIGHT")
	row.key:Point("RIGHT", row.name, "LEFT", -4, 0)

	return row
end

-- sits below the Raider.IO profile tooltip, which is anchored to the top right of the PVEFrame
local function CreateKeystoneFrame()
	local frame = CreateFrame("Frame", "mMediaTag_GroupKeystones", _G.LFGListFrame.EntryCreation, "BackdropTemplate")
	frame:Width(260)
	frame:Point("BOTTOMLEFT", _G.PVEFrame, "BOTTOMRIGHT", 2, 0)
	frame:SetTemplate("Transparent")

	frame.title = frame:CreateFontString(nil, "OVERLAY")
	frame.title:FontTemplate(nil, 12, "OUTLINE")
	frame.title:Point("TOPLEFT", frame, "TOPLEFT", PADDING, -PADDING)
	frame.title:SetText(mMT:TC(L["Group Keystones"], "title"))

	frame.rows = {}
	for i = 1, MAX_ROWS do
		frame.rows[i] = CreateRow(frame, i)
	end

	module.frame = frame
end

local function SetRow(row, unit)
	local level, challengeMapID = GetUnitKeystone(unit)
	local _, class = UnitClass(unit)
	local name = PlainValue(GetUnitName(unit, false)) or ""
	local classColor = class and GetClassColor(class)
	row.name:SetText(classColor and classColor:WrapTextInColorCode(name) or name)

	if ValidKey(level, challengeMapID) then
		local dungeon, _, _, icon = GetMapUIInfo(challengeMapID)
		local levelColor = GetKeystoneLevelRarityColor(level)
		local levelText = "+" .. level
		row.key:SetText(format("%s %s", levelColor and levelColor:WrapTextInColorCode(levelText) or levelText, dungeon or ""))
		row.icon:SetTexture(icon)
		row.icon:Show()
	else
		row.key:SetText(mMT:TC(L["No Keystone"], "gray"))
		row.icon:Hide()
	end

	row:Show()
end

local function UpdateFrame()
	local frame = module.frame
	if not (frame and frame:IsVisible()) then return end

	local count = 0
	for i = 1, IsInGroup() and GetNumGroupMembers() or 1 do
		local unit = units[i]
		if unit and UnitExists(unit) then
			count = count + 1
			SetRow(frame.rows[count], unit)
		end
	end

	for i = count + 1, MAX_ROWS do
		frame.rows[i]:Hide()
	end

	frame:Height(PADDING * 2 + frame.title:GetStringHeight() + 2 + count * ROW_HEIGHT)
end

local function RequestKeystones()
	mMT:RequestGroupKeystones()
	UpdateFrame()
end

function module:GROUP_ROSTER_UPDATE()
	if module.frame:IsVisible() then RequestKeystones() end
end

function module:Initialize()
	if not (E.Retail and E.db.mMediaTag.group_keystones.enable) then
		if module.isEnabled then
			module:UnregisterEvent("GROUP_ROSTER_UPDATE")
			module.frame:Hide()
			module.isEnabled = false
		end
		return
	end

	if not module.frame then
		CreateKeystoneFrame()
		module.frame:SetScript("OnShow", RequestKeystones)
		mMT:AddGroupKeystoneListener(UpdateFrame)
	end

	if not module.isEnabled then
		module:RegisterEvent("GROUP_ROSTER_UPDATE")
		module.frame:Show()
		module.isEnabled = true
	end
end
