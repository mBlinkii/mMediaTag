local E = unpack(ElvUI)

local ImportantSpellIDs = {}

function mMT:UpdateImportantSpells()
	ImportantSpellIDs = E.db.mMT.importantspells.spells
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

function mMT:ImportantSpells(castbar, np)
	local Spell = ImportantSpellIDs[castbar.spellID] and ImportantSpellIDs[castbar.spellID] or false

	if castbar.mSpellIcon then
		castbar.mSpellIcon:Hide()
	end

	if castbar.unit == "target" then
	end

	if Spell then
		if Spell.color.enable then
			if E.db.mMT.importantspells.gradient then
				mMT:SetCastbarColor(castbar, Spell.color.a, Spell.color.b)
			else
				mMT:SetCastbarColor(castbar, Spell.color.a)
			end
		end

		if (Spell.sound.enable and Spell.sound.file) and castbar.unit == "target" then
			PlaySoundFile(E.LSM:Fetch("sound", Spell.sound.file), "Master")
		end

		if Spell.texture.enable and Spell.texture.texture then
			if not castbar.mBackup and np then
				castbar.mBackup = castbar:GetStatusBarTexture()
				--mMT:DebugPrintTable(castbar.mBackup)
				--mMT:Print("BACKUP", castbar.mBackup)
			end

			castbar:SetStatusBarTexture(E.LSM:Fetch("statusbar", Spell.texture.texture))
		end

		if Spell.icon.enable and Spell.icon.icon then
			SetSpellIcon(castbar, Spell.icon)
		end
	else
		if castbar.mBackup and np then
			--mMT:Print("SET", castbar.mBackup)
			castbar:SetStatusBarTexture(castbar.mBackup)
			castbar.mBackup = nil
		end
	end
end
