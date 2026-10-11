local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("KeystoneTeleports", { "AceEvent-3.0" })

-- Cache WoW Globals
local _G = _G
local unpack = unpack
local ipairs = ipairs
local CreateFrame = CreateFrame
local format = format
local GameTooltip = GameTooltip
local GetNumGroupMembers = GetNumGroupMembers
local GetUnitName = GetUnitName
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local min = math.min
local random = math.random
local select = select
local UnitClass = UnitClass
local UnitExists = UnitExists
local UnitIsGroupLeader = UnitIsGroupLeader
local GetMapUIInfo = C_ChallengeMode.GetMapUIInfo
local GetKeystoneLevelRarityColor = C_ChallengeMode.GetKeystoneLevelRarityColor
local GetClassColor = C_ClassColor.GetClassColor
local GetSpellTexture = C_Spell.GetSpellTexture
local GetSpellCooldownDuration = C_Spell.GetSpellCooldownDuration
local GetMapTable = C_ChallengeMode.GetMapTable
local C_Timer_After = C_Timer.After
local C_Timer_NewTimer = C_Timer.NewTimer
local RegisterStateDriver = RegisterStateDriver

local LSM = E.Libs.LSM

local MAX_ROWS = 5
local FULL_GROUP = 5
local PADDING = 6
local TITLE_SPACING = 4
local FADE_TIME = 0.3
local FLASH_PULSE = 0.4
local FLASH_TIME = 5

local units = { "player", "party1", "party2", "party3", "party4" }
local updateQueued
local entries = {}

local function OnEnter(row)
	GameTooltip:SetOwner(row, "ANCHOR_RIGHT")
	if row.spellID then
		GameTooltip:SetSpellByID(row.spellID)
	else
		GameTooltip:AddLine(row.dungeon or "")
		GameTooltip:AddLine(L["Teleport not learned"], 1, 0.2, 0.2)
	end
	GameTooltip:Show()
end

-- the rows are secure buttons, so the frame and its rows only change out of combat
local function CreateRow(frame)
	local row = CreateFrame("Button", nil, frame, "SecureActionButtonTemplate")
	row:RegisterForClicks("AnyUp", "AnyDown")

	row.highlight = row:CreateTexture(nil, "BACKGROUND")
	row.highlight:SetAllPoints()
	row.highlight:SetTexture(E.media.blankTex)

	-- base alpha 0, so a stopped flash leaves nothing behind
	row.flash = row:CreateTexture(nil, "BACKGROUND", nil, 1)
	row.flash:SetAllPoints()
	row.flash:SetTexture(E.media.blankTex)
	row.flash:SetAlpha(0)

	row.flashAnim = row.flash:CreateAnimationGroup()
	row.flashAnim:SetLooping("BOUNCE")
	local pulse = row.flashAnim:CreateAnimation("Alpha")
	pulse:SetFromAlpha(0)
	pulse:SetToAlpha(0.6)
	pulse:SetDuration(FLASH_PULSE)
	pulse:SetSmoothing("IN_OUT")

	row.holder = CreateFrame("Frame", nil, row, "BackdropTemplate")
	row.holder:Point("LEFT", row, "LEFT", 0, 0)
	row.holder:SetTemplate()

	row.icon = row.holder:CreateTexture(nil, "ARTWORK")
	row.icon:SetInside()
	row.icon:SetTexCoord(unpack(E.TexCoords))

	row.cooldown = CreateFrame("Cooldown", nil, row.holder, "CooldownFrameTemplate")
	row.cooldown:SetInside()

	row.name = row:CreateFontString(nil, "OVERLAY")
	row.name:Point("RIGHT", row, "RIGHT", -4, 0)
	row.name:SetJustifyH("RIGHT")

	row.key = row:CreateFontString(nil, "OVERLAY")
	row.key:Point("LEFT", row.holder, "RIGHT", 6, 0)
	row.key:Point("RIGHT", row.name, "LEFT", -4, 0)
	row.key:SetJustifyH("LEFT")
	row.key:SetWordWrap(false)

	row:SetScript("OnEnter", OnEnter)
	row:SetScript("OnLeave", _G.GameTooltip_Hide)

	return row
end

local function CreateFade(frame, from, to)
	local group = frame:CreateAnimationGroup()
	group:SetToFinalAlpha(true)

	local alpha = group:CreateAnimation("Alpha")
	alpha:SetFromAlpha(from)
	alpha:SetToAlpha(to)
	alpha:SetDuration(FADE_TIME)
	alpha:SetSmoothing(to > from and "OUT" or "IN")

	return group
end

-- an animation group does not start on a frame shown in the same tick, so it starts on the next one
local function PlayFadeIn()
	local frame = module.frame
	if frame:IsVisible() and not frame.fadeOut:IsPlaying() then frame.fadeIn:Play() end
	if not frame.fadeIn:IsPlaying() and not frame.fadeOut:IsPlaying() then frame:SetAlpha(1) end
end

local function FadeIn()
	if not module.db.animation then return end
	module.frame:SetAlpha(0)
	C_Timer_After(0, PlayFadeIn)
end

local function CreateTeleportFrame()
	-- the rows are secure, so only a state driver may hide them in combat
	local holder = CreateFrame("Frame", nil, E.UIParent)
	holder:SetAllPoints(E.UIParent)
	RegisterStateDriver(holder, "visibility", "[combat] hide; show")

	local frame = CreateFrame("Frame", "mMediaTag_KeystoneTeleports", holder, "BackdropTemplate")
	frame:Size(260, 40)
	frame:Point("LEFT", E.UIParent, "LEFT", 20, 120)
	frame:Hide()

	frame.title = frame:CreateFontString(nil, "OVERLAY")

	frame.rows = {}
	for i = 1, MAX_ROWS do
		frame.rows[i] = CreateRow(frame)
	end

	frame.fadeIn = CreateFade(frame, 0, 1)
	frame.fadeOut = CreateFade(frame, 1, 0)
	-- OnFinished also fires on Stop(), requested tells the two apart
	frame.fadeOut:SetScript("OnFinished", function(_, requested)
		if requested then return end
		if InCombatLockdown() then
			module:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end
		frame:Hide()
		frame:SetAlpha(1)
	end)

	E:CreateMover(frame, "mMediaTag_KeystoneTeleports_Mover", "mMT " .. L["Keystone Teleports"], nil, nil, nil, "ALL,MMEDIATAG", function()
		return E.db.mMediaTag.keystone_teleports.enable
	end, "mMT,group,keystones")

	frame.holder = holder
	module.frame = frame
end

local function UpdateCooldowns()
	if not (module.frame and module.frame:IsShown()) then return end

	for _, row in ipairs(module.frame.rows) do
		local duration = row.spellID and GetSpellCooldownDuration(row.spellID)
		if duration then
			row.cooldown:SetCooldownFromDurationObject(duration)
		else
			row.cooldown:Clear()
		end
	end
end

local function StopFlash()
	if module.flashTimer then
		module.flashTimer:Cancel()
		module.flashTimer = nil
	end
	for _, row in ipairs(module.frame.rows) do
		row.flashAnim:Stop()
	end
end

-- like the fade, the animation does not start on a frame shown in the same tick
local function PlayFlash()
	for _, row in ipairs(module.frame.rows) do
		if row.active and row:IsShown() then
			row.flashAnim:Play()
			module.flashTimer = C_Timer_NewTimer(FLASH_TIME, StopFlash)
			return
		end
	end
end

-- flashes the dungeon of the group once, as soon as its row is known
local function CheckFlash(count)
	if not module.flashPending then return end
	for i = 1, count do
		if module.frame.rows[i].active then
			module.flashPending = nil
			StopFlash()
			C_Timer_After(0, PlayFlash)
			return
		end
	end
end

local function HighlightColor()
	if module.db.highlight.class then return MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b end
	return mMT:HexToRGB(module.db.highlight.color)
end

-- size, anchors and backdrop of the secure rows, so only out of combat
local function ApplyLayout()
	local frame, db = module.frame, module.db
	local font = LSM:Fetch("font", db.text.font)
	local padding = db.background and PADDING or 0

	frame:SetTemplate(db.background and "Transparent" or "NoBackdrop")
	frame:Width(db.width)

	E:SetFont(frame.title, font, db.text.size, db.text.fontFlag)
	frame.title:SetText(mMT:TC(L["Keystone Teleports"], "title"))
	frame.title:ClearAllPoints()
	frame.title:Point("TOPLEFT", frame, "TOPLEFT", padding, -padding)
	frame.title:SetShown(db.title)
	module.top = padding + (db.title and (frame.title:GetStringHeight() + TITLE_SPACING) or 0)
	module.padding = padding

	for i, row in ipairs(frame.rows) do
		row:ClearAllPoints()
		-- protected frames can not anchor to font strings, so offset from the frame by the title height
		row:Point("TOPLEFT", frame, "TOPLEFT", padding, -module.top - (i - 1) * (db.size + db.spacing))
		row:Point("RIGHT", frame, "RIGHT", -padding, 0)
		row:Height(db.size)
		row.holder:Size(db.size)
		E:SetFont(row.key, font, db.text.size, db.text.fontFlag)
		E:SetFont(row.name, font, db.text.size, db.text.fontFlag)
	end
end

local function SetRow(row, unit, level, challengeMapID, targetMapID, leader, own)
	local dungeon, _, _, texture, _, instanceMapID = GetMapUIInfo(challengeMapID)
	local spellID = mMT:GetSeasonTeleport(challengeMapID)
	local name = GetUnitName(unit, false)
	if E:IsSecretValue(name) or not name then name = "" end
	local _, class = UnitClass(unit)
	local classColor = class and GetClassColor(class)
	local levelColor = GetKeystoneLevelRarityColor(level)
	local levelText = "+" .. level
	local active = targetMapID and instanceMapID == targetMapID

	row.spellID = spellID
	row.dungeon = dungeon
	row:SetAttribute("type", spellID and "spell" or nil)
	row:SetAttribute("spell", spellID)

	row.icon:SetTexture(spellID and GetSpellTexture(spellID) or texture)
	row.icon:SetDesaturated(not spellID)
	local r, g, b = HighlightColor()
	dungeon = dungeon or ""
	row.key:SetText(format("%s %s", levelColor and levelColor:WrapTextInColorCode(levelText) or levelText, active and E:RGBToHex(r, g, b) .. dungeon .. "|r" or dungeon))
	name = classColor and classColor:WrapTextInColorCode(name) or name
	local iconSize = format(":%d:%d", module.db.text.size, module.db.text.size)
	local icons = (leader and E:TextureString(MEDIA.icons.leader.leader01, iconSize) .. " " or "") .. (own and E:TextureString(MEDIA.icons.keystone.keystone01, iconSize) .. " " or "")
	row.name:SetText(icons .. name)

	row.active = active
	row.highlight:SetVertexColor(r, g, b, 0.25)
	row.highlight:SetShown(active)
	row.flash:SetVertexColor(r, g, b)
	if active then
		row.holder:SetBackdropBorderColor(r, g, b)
	else
		row.holder:SetBackdropBorderColor(unpack(E.media.bordercolor))
	end

	row:Show()
end

local function AddEntry(unit, level, challengeMapID, leader, own)
	entries[#entries + 1] = { unit = unit, level = level, challengeMapID = challengeMapID, leader = leader, own = own }
end

-- unit, level and dungeon per row, returns the row count and the dungeon of the group
local function CollectEntries()
	for i = #entries, 1, -1 do
		entries[i] = nil
	end

	if module.demo then
		-- own name on the dungeons of the season, the first one as the dungeon of the group
		local maps = GetMapTable() or {}
		for i = 1, min(#maps, MAX_ROWS) do
			AddEntry("player", 8 + i * 2, maps[i], i == module.demoLeader, i == module.demoOwn)
		end
		return #entries, maps[1] and select(6, GetMapUIInfo(maps[1]))
	end

	if not (module.active and IsInGroup() and not IsInRaid() and not IsInInstance()) then return 0 end

	for _, unit in ipairs(units) do
		if UnitExists(unit) then
			local level, challengeMapID = mMT:GetUnitKeystone(unit)
			if level then AddEntry(unit, level, challengeMapID, E:NotSecretUnit(unit) and UnitIsGroupLeader(unit), unit == "player") end
		end
	end
	return #entries, mMT:GetTeleportTargetMapID()
end

local function ShowFrame()
	local frame = module.frame
	local appearing = not frame:IsShown() or frame.fadeOut:IsPlaying()

	frame.fadeOut:Stop()
	frame:SetAlpha(1)
	frame:Show()
	if appearing then FadeIn() end
end

local function HideFrame()
	local frame = module.frame
	if not frame:IsShown() or frame.fadeOut:IsPlaying() then return end

	frame.fadeIn:Stop()
	if module.isEnabled and module.db.animation and frame:IsVisible() and frame:GetAlpha() > 0 then
		frame.fadeOut:Play()
	else
		frame:Hide()
		frame:SetAlpha(1)
	end
end

local function Update()
	updateQueued = nil
	local frame = module.frame
	if not frame then return end

	if InCombatLockdown() then
		module:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	local count, targetMapID = 0, nil
	if module.isEnabled then
		count, targetMapID = CollectEntries()
	end

	-- the rows stay as they are while the list fades out
	if count == 0 then
		HideFrame()
		return
	end

	ApplyLayout()

	for i, entry in ipairs(entries) do
		SetRow(frame.rows[i], entry.unit, entry.level, entry.challengeMapID, targetMapID, entry.leader, entry.own)
	end

	for i = count + 1, MAX_ROWS do
		local row = frame.rows[i]
		row.spellID = nil
		row.active = nil
		row.flashAnim:Stop()
		row:SetAttribute("type", nil)
		row:Hide()
	end

	local db = module.db
	frame:Height(module.top + module.padding + count * (db.size + db.spacing) - db.spacing)
	ShowFrame()
	UpdateCooldowns()
	CheckFlash(count)
end

-- runs a frame later, the group finder target in misc_teleports.lua is set from the same events
local function QueueUpdate()
	if updateQueued then return end
	updateQueued = true
	C_Timer_After(0, Update)
end

local function StopTimer()
	if module.hideTimer then
		module.hideTimer:Cancel()
		module.hideTimer = nil
	end
end

local function Expire()
	module.hideTimer = nil
	module.active = false
	QueueUpdate()
end

-- shown after joining a group or once it is full, until the set time runs out (0 keeps it)
local function Activate()
	StopTimer()
	module.active = true
	if module.db.duration > 0 then module.hideTimer = C_Timer_NewTimer(module.db.duration * 60, Expire) end

	mMT:RequestGroupKeystones()
	QueueUpdate()
end

local function Deactivate()
	StopTimer()
	module.active = false
	module.members = 0
	module.flashPending = nil
	QueueUpdate()
end

-- joining as the last member fills the group without a roster change from below five
local function QueueFlash(members)
	module.flashPending = members >= FULL_GROUP and module.db.highlight.flash or nil
end

function module:GROUP_JOINED()
	module.members = GetNumGroupMembers()
	QueueFlash(module.members)
	Activate()
end

function module:GROUP_ROSTER_UPDATE()
	local members = GetNumGroupMembers()
	local previous = module.members or 0
	local filled = members >= FULL_GROUP and previous < FULL_GROUP
	module.members = members

	if filled then
		QueueFlash(members)
		Activate()
	else
		if members < FULL_GROUP then module.flashPending = nil end
		-- the roster event also fires for zone, online and role changes, only a new member needs a request
		if members > previous then mMT:RequestGroupKeystones() end
		QueueUpdate()
	end
end

-- a reload or login inside a group never fires GROUP_JOINED, so the list starts again from here
function module:PLAYER_ENTERING_WORLD(_, isInitialLogin, isReloadingUi)
	if (isInitialLogin or isReloadingUi) and IsInGroup() then
		module.members = GetNumGroupMembers()
		Activate()
	else
		QueueUpdate()
	end
end

function module:PLAYER_REGEN_ENABLED()
	module:UnregisterEvent("PLAYER_REGEN_ENABLED")
	Update()
end

function module:Initialize(demo)
	if not (E.Retail and E.db.mMediaTag.keystone_teleports.enable) then
		module.demo = nil
		if module.isEnabled then
			module:UnregisterAllEvents()
			module.isEnabled = false
			StopTimer()
			module.active = false
			module.flashPending = nil
			Update()
		end
		return
	end

	module.db = E.db.mMediaTag.keystone_teleports
	if demo then
		module.demo = not module.demo
		module.flashPending = module.demo and module.db.highlight.flash or nil
		-- the demo rows are all the player, so random ones get the leader crown and the own key
		module.demoLeader = random(MAX_ROWS)
		module.demoOwn = random(MAX_ROWS)
	end

	if not module.frame then
		CreateTeleportFrame()
		-- entering combat hides it at once, leaving combat fades it back in or drops it when its time ran out meanwhile
		module.frame.holder:HookScript("OnShow", function()
			if module.frame:IsShown() then FadeIn() end
			QueueUpdate()
		end)
		mMT:AddGroupKeystoneListener(QueueUpdate)
	end

	if not module.isEnabled then
		module:RegisterEvent("GROUP_JOINED")
		module:RegisterEvent("GROUP_ROSTER_UPDATE")
		module:RegisterEvent("GROUP_LEFT", Deactivate)
		module:RegisterEvent("PLAYER_ENTERING_WORLD")
		module:RegisterEvent("ZONE_CHANGED_NEW_AREA", QueueUpdate)
		module:RegisterEvent("LFG_LIST_JOINED_GROUP", Activate)
		module:RegisterEvent("LFG_LIST_ACTIVE_ENTRY_UPDATE", QueueUpdate)
		module:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED", QueueUpdate)
		module:RegisterEvent("SPELLS_CHANGED", QueueUpdate)
		module:RegisterEvent("SPELL_UPDATE_COOLDOWN", UpdateCooldowns)
		module.isEnabled = true
		module.members = GetNumGroupMembers()
		mMT:RequestGroupKeystones()
	end

	QueueUpdate()
end
