local E, L = unpack(ElvUI)

local ImportantSpellsInterrupt = {}
local ImportantSpellsStun = {}

function mMT:UpdateImportantSpells()
	ImportantSpellsInterrupt = E.db.mMT.importantspells.interrupt.ids
	ImportantSpellsStun = E.db.mMT.importantspells.stun.ids
end

local function IconColor(icon, stun, auto)
	local color = { 1, 1, 1 }
	if auto then
		if stun then
			color = E.db.mMT.importantspells.stun.colora
			icon:SetVertexColor(color.r, color.g, color.b, 1)
		else
			color = E.db.mMT.importantspells.interrupt.colora
			icon:SetVertexColor(color.r, color.g, color.b, 1)
		end
	else
		icon:SetVertexColor(1, 1, 1, 1)
	end
end

local function ImportantSpellIcon(castbar, interrupt, stun)
	if interrupt or stun then
		if not castbar.mImportantIcon then
			castbar.mImportantIcon = castbar:CreateTexture("ImportantSpellIcon", "OVERLAY")
			castbar.mImportantIcon:SetWidth(E.db.mMT.importantspells.icon.sizeX)
			castbar.mImportantIcon:SetHeight(E.db.mMT.importantspells.icon.sizeY)
			castbar.mImportantIcon:SetPoint(
				E.db.mMT.importantspells.icon.anchor,
				E.db.mMT.importantspells.icon.posX,
				E.db.mMT.importantspells.icon.posY
			)
		else
			castbar.mImportantIcon:ClearAllPoints()
			castbar.mImportantIcon:SetWidth(E.db.mMT.importantspells.icon.sizeX)
			castbar.mImportantIcon:SetHeight(E.db.mMT.importantspells.icon.sizeY)
			castbar.mImportantIcon:SetPoint(
				E.db.mMT.importantspells.icon.anchor,
				E.db.mMT.importantspells.icon.posX,
				E.db.mMT.importantspells.icon.posY
			)
		end

		castbar.mImportantIcon:Hide()

		if interrupt or stun then
			if stun then
				castbar.mImportantIcon:SetTexture(mMT.Media.Castbar[E.db.mMT.importantspells.icon.stun])
			elseif interrupt then
				castbar.mImportantIcon:SetTexture(mMT.Media.Castbar[E.db.mMT.importantspells.icon.interrupt])
			end
			castbar.mImportantIcon:Show()
		end

		IconColor(castbar.mImportantIcon, stun, E.db.mMT.importantspells.icon.auto)
	elseif castbar.mImportantIcon then
		castbar.mImportantIcon:Hide()
	end
end

local function ImportantSpellIconReplace(castbar, interrupt, stun)
	if castbar.ButtonIcon then
		if interrupt or stun then
			if stun then
				castbar.ButtonIcon:SetTexture(mMT.Media.Castbar[E.db.mMT.importantspells.icon.stun])
			elseif interrupt then
				castbar.ButtonIcon:SetTexture(mMT.Media.Castbar[E.db.mMT.importantspells.icon.interrupt])
			end
			IconColor(castbar.ButtonIcon, stun, E.db.mMT.importantspells.icon.auto)
		end
	end
end

function mMT:ImportantSpells(castbar)
	local ImportantInterrupt = ImportantSpellsInterrupt[castbar.spellID]
	local ImportantStun = ImportantSpellsStun[castbar.spellID]

	if ImportantInterrupt and ImportantStun and ImportantInterrupt == ImportantStun then
		mMT:Print(L["Error, Interrupt and Stun Spell IDs are the same!"])
		return
	end

    if castbar.mImportantIcon then
		castbar.mImportantIcon:Hide()
	end

	if E.db.mMT.importantspells.interrupt.enable then
		if ImportantInterrupt then
			if E.db.mMT.importantspells.gradient then
				mMT:SetCastbarColor(
					castbar,
					E.db.mMT.importantspells.interrupt.colora,
					E.db.mMT.importantspells.interrupt.colorb
				)
			else
				mMT:SetCastbarColor(castbar, E.db.mMT.importantspells.interrupt.colora)
			end
		elseif ImportantStun then
			if E.db.mMT.importantspells.gradient then
				mMT:SetCastbarColor(castbar, E.db.mMT.importantspells.stun.colora, E.db.mMT.importantspells.stun.colorb)
			else
				mMT:SetCastbarColor(castbar, E.db.mMT.importantspells.stun.colora)
			end
		end
	end

	if E.db.mMT.importantspells.icon.replace then
		ImportantSpellIconReplace(castbar, ImportantInterrupt, ImportantStun)
	end

	if E.db.mMT.importantspells.icon.enable then
		ImportantSpellIcon( castbar, ImportantInterrupt,ImportantStun )
    end
end
