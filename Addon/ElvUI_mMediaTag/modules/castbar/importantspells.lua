local E = unpack(ElvUI)
local PlaySoundFile = PlaySoundFile
local GetTime = GetTime

local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo

local lastPlayed = {}
local textureNP = nil
local textureUF = nil

local module = mMT.Modules.ImportantSpells
if not module then return end

local ImportantSpellIDs = {}

function BuildSpellFilters()
	wipe(ImportantSpellIDs)

	for filter, _ in pairs(E.db.mMT.importantspells.spells) do
		if E.db.mMT.importantspells.spells[filter] and E.db.mMT.importantspells.spells[filter].enable and E.db.mMT.importantspells.spells[filter].IDs then
			for id, _ in pairs(E.db.mMT.importantspells.spells[filter].IDs) do
				ImportantSpellIDs[id] = E.db.mMT.importantspells.spells[filter].functions
				ImportantSpellIDs[id].sound.soundFile = E.LSM:Fetch("sound", ImportantSpellIDs[id].sound.file)
				ImportantSpellIDs[id].texture.textureFile = E.LSM:Fetch("statusbar", ImportantSpellIDs[id].texture.texture)
			end
		end
	end
end

local function SetPoint(icon, settings)
	local size = icon.mSize
	local pos = 0

	if settings.size.auto then
		icon:SetWidth(size)
		icon:SetHeight(size)
	else
		icon:SetWidth(settings.size.sizeXY)
		icon:SetHeight(settings.size.sizeXY)
	end

	if settings.anchor.auto then
		if settings.anchor.point == "CENTER" then
			icon:SetPoint(settings.anchor.point, pos, pos)
		elseif settings.anchor.point == "TOP" then
			pos = size / 2
			icon:SetPoint(settings.anchor.point, 0, pos)
		elseif settings.anchor.point == "BOTTOM" then
			pos = size / 2 - size
			icon:SetPoint(settings.anchor.point, 0, pos)
		elseif settings.anchor.point == "LEFT" then
			pos = size / 2 - size
			icon:SetPoint(settings.anchor.point, pos, 0)
		elseif settings.anchor.point == "RIGHT" then
			pos = size / 2
			icon:SetPoint(settings.anchor.point, pos, 0)
		end
	else
		icon:SetPoint(settings.anchor.point, settings.anchor.posX, settings.anchor.posY)
	end
end

local function SetSpellIcon(castbar, settings)
	if not castbar.mSpellIcon then
		castbar.mSpellIcon = castbar:CreateTexture("ImportantSpellIcon", "OVERLAY")
		castbar.mSpellIcon.mSize = settings.size.auto and castbar:GetHeight() or settings.size.sizeXY
		SetPoint(castbar.mSpellIcon, settings)
	else
		castbar.mSpellIcon:ClearAllPoints()
		castbar.mSpellIcon.mSize = settings.size.auto and castbar:GetHeight() or settings.size.sizeXY
		SetPoint(castbar.mSpellIcon, settings)
	end

	castbar.mSpellIcon:SetTexture(mMT.Media.Castbar[settings.icon])
	castbar.mSpellIcon:SetVertexColor(settings.color.r, settings.color.g, settings.color.b, 1)

	castbar.mSpellIcon:Show()
end

function module:UpdateCastbar(castbar, isNP)
	if mMT.DevMode then mMT:Print("Spell ID:", castbar.spellID, "DB ID:", ImportantSpellIDs[castbar.spellID]) end

	local Spell = ImportantSpellIDs[castbar.spellID]

	if castbar.mSpellIcon then castbar.mSpellIcon:Hide() end

	if Spell then
		if Spell.color.enable then
			local colorA = Spell.color.a
			local colorB = Spell.color.b
			local gradient = E.db.mMT.importantspells.gradient
			mMT.Modules.Castbar:SetCastbarColor(castbar, colorA, gradient and colorB or nil)
		end

		if Spell.sound.enable and Spell.sound.file then
			local isTarget = Spell.sound.target and castbar.unit == "target"
			if isTarget or not Spell.sound.target then
				local spellInfo = GetSpellInfo(castbar.spellID)
				local delay = 0.5
				lastPlayed[castbar.spellID] = lastPlayed[castbar.spellID] or { time = 0, queued = 0, willPlay = true }

				local willPlay, soundHandle = nil, nil

				if lastPlayed[castbar.spellID].willPlay and (lastPlayed[castbar.spellID].time + (spellInfo.castTime / 1000) + delay) < GetTime() then
					willPlay, soundHandle = PlaySoundFile(Spell.sound.soundFile, "Master")
				end

				if willPlay then
					lastPlayed[castbar.spellID].time = GetTime()
					lastPlayed[castbar.spellID].queued = soundHandle
				end
				lastPlayed[castbar.spellID].willPlay = not willPlay
			elseif lastPlayed[castbar.spellID] then
				lastPlayed[castbar.spellID].willPlay = true
			end
		end

		if Spell.texture.enable and Spell.texture.texture then
			castbar.mTextureChanged = true
			castbar:SetStatusBarTexture(Spell.texture.textureFile)
		end

		if Spell.icon.enable and Spell.icon.icon then SetSpellIcon(castbar, Spell.icon) end
	elseif castbar.mTextureChanged then
		castbar:SetStatusBarTexture(isNP and textureNP or textureUF)
		castbar.mTextureChanged = false
	end
end

function module:Initialize()
	textureNP = E.LSM:Fetch("statusbar", E.db.mMT.customtextures.castbar.enable and E.db.mMT.customtextures.castbar.texture or E.db.nameplates.statusbar)
	textureUF = E.LSM:Fetch("statusbar", E.db.mMT.customtextures.castbar.enable and E.db.mMT.customtextures.castbar.texture or E.db.unitframe.statusbar)

	BuildSpellFilters()
	module.needReloadUI = true
	module.loaded = true
end
