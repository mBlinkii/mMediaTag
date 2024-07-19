local E = unpack(ElvUI)
local PlaySoundFile = PlaySoundFile
local GetTime = GetTime

local lastPlayed = {}

local module = mMT.Modules.ImportantSpells
if not module then
	return
end

local ImportantSpellIDs = {}

function BuildSpellFilters()
	wipe(ImportantSpellIDs)

	for filter, _ in pairs(E.db.mMT.importantspells.spells) do
		if E.db.mMT.importantspells.spells[filter] and E.db.mMT.importantspells.spells[filter].enable and E.db.mMT.importantspells.spells[filter].IDs then
			for id, _ in pairs(E.db.mMT.importantspells.spells[filter].IDs) do
				ImportantSpellIDs[id] = E.db.mMT.importantspells.spells[filter].functions
			end
		end
	end
end

function module:Initialize()
	BuildSpellFilters()
	module.needReloadUI = true
	module.loaded = true
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

function module:UpdateCastbar(castbar)
	if mMT.DevMode then
		mMT:Print("Spell ID:", castbar.spellID, "DB ID:", ImportantSpellIDs[castbar.spellID])
	end

	local Spell = ImportantSpellIDs[castbar.spellID] or false

	if castbar.mSpellIcon then
		castbar.mSpellIcon:Hide()
	end

	if Spell then
		if Spell.color.enable then
			if E.db.mMT.importantspells.gradient then
				mMT.Modules.Castbar:SetCastbarColor(castbar, Spell.color.a, Spell.color.b)
			else
				mMT.Modules.Castbar:SetCastbarColor(castbar, Spell.color.a)
			end
		end

		if Spell.sound.enable and Spell.sound.file and (Spell.sound.target and castbar.unit == "target") or not Spell.sound.target then
			local castTime = select(4, GetSpellInfo(castbar.spellID))
			local delay = 0.5
			lastPlayed[castbar.spellID] = lastPlayed[castbar.spellID] or { time = 0, queued = 0, willPlay = true }

			local willPlay, soundHandle = nil, nil

			if lastPlayed[castbar.spellID].willPlay and (lastPlayed[castbar.spellID].time + (castTime / 1000) + delay) < GetTime() then
				local file = E.LSM:Fetch("sound", Spell.sound.file)
				willPlay, soundHandle = PlaySoundFile(file, "Master")
			end

			if willPlay then
				lastPlayed[castbar.spellID].time = GetTime()
				lastPlayed[castbar.spellID].queued = soundHandle
			end
			lastPlayed[castbar.spellID].willPlay = not willPlay
		elseif lastPlayed[castbar.spellID] then
			lastPlayed[castbar.spellID].willPlay = true
		end

		if Spell.texture.enable and Spell.texture.texture then
			if not castbar.mTextureChanged then
				castbar.mTextureChanged = true
			end

			castbar:SetStatusBarTexture(E.LSM:Fetch("statusbar", Spell.texture.texture))
		end

		if Spell.icon.enable and Spell.icon.icon then
			SetSpellIcon(castbar, Spell.icon)
		end
	elseif castbar.mTextureChanged then
		castbar:SetStatusBarTexture(E.LSM:Fetch("statusbar", E.db.mMT.customtextures.castbar.enable and E.db.mMT.customtextures.castbar.texture or E.db.mMT.importantspells.default))
		castbar.mTextureChanged = false
	end
end
