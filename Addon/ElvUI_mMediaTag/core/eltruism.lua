local E = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

function mMT:CheckEltruism()
	local elt_tbl = {
		loaded = IsAddOnLoaded("ElvUI_EltreumUI"),
		gradient = false,
		dark = false,
		colors = nil,
	}

	if elt_tbl.loaded then
		local db = E.db.ElvUI_EltreumUI.unitframes.gradientmode
		elt_tbl.gradient = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and db and db.enable
		elt_tbl.dark = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and E.db.ElvUI_EltreumUI.unitframes.darkmode

		elt_tbl.colors = {
			["WARRIOR"] = {
				a = { r = db.warriorcustomcolorR1, g = db.warriorcustomcolorG1, b = db.warriorcustomcolorB1, a = 1 },
				b = { r = db.warriorcustomcolorR2, g = db.warriorcustomcolorG2, b = db.warriorcustomcolorB2, a = 1 },
			},
			["PALADIN"] = {
				a = { r = db.paladincustomcolorR1, g = db.paladincustomcolorG1, b = db.paladincustomcolorB1, a = 1 },
				b = { r = db.paladincustomcolorR2, g = db.paladincustomcolorG2, b = db.paladincustomcolorB2, a = 1 },
			},
			["HUNTER"] = {
				a = { r = db.huntercustomcolorR1, g = db.huntercustomcolorG1, b = db.huntercustomcolorB1, a = 1 },
				b = { r = db.huntercustomcolorR2, g = db.huntercustomcolorG2, b = db.huntercustomcolorB2, a = 1 },
			},
			["ROGUE"] = {
				a = { r = db.roguecustomcolorR1, g = db.roguecustomcolorG1, b = db.roguecustomcolorB1, a = 1 },
				b = { r = db.roguecustomcolorR2, g = db.roguecustomcolorG2, b = db.roguecustomcolorB2, a = 1 },
			},
			["PRIEST"] = {
				a = { r = db.priestcustomcolorR1, g = db.priestcustomcolorG1, b = db.priestcustomcolorB1, a = 1 },
				b = { r = db.priestcustomcolorR2, g = db.priestcustomcolorG2, b = db.priestcustomcolorB2, a = 1 },
			},
			["DEATHKNIGHT"] = {
				a = { r = db.deathknightcustomcolorR1, g = db.deathknightcustomcolorG1, b = db.deathknightcustomcolorB1, a = 1 },
				b = { r = db.deathknightcustomcolorR2, g = db.deathknightcustomcolorG2, b = db.deathknightcustomcolorB2, a = 1 },
			},
			["SHAMAN"] = {
				a = { r = db.shamancustomcolorR1, g = db.shamancustomcolorG1, b = db.shamancustomcolorB1, a = 1 },
				b = { r = db.shamancustomcolorR2, g = db.shamancustomcolorG2, b = db.shamancustomcolorB2, a = 1 },
			},
			["MAGE"] = {
				a = { r = db.magecustomcolorR1, g = db.magecustomcolorG1, b = db.magecustomcolorB1, a = 1 },
				b = { r = db.magecustomcolorR2, g = db.magecustomcolorG2, b = db.magecustomcolorB2, a = 1 },
			},
			["WARLOCK"] = {
				a = { r = db.warlockcustomcolorR1, g = db.warlockcustomcolorG1, b = db.warlockcustomcolorB1, a = 1 },
				b = { r = db.warlockcustomcolorR2, g = db.warlockcustomcolorG2, b = db.warlockcustomcolorB2, a = 1 },
			},
			["MONK"] = {
				a = { r = db.monkcustomcolorR1, g = db.monkcustomcolorG1, b = db.monkcustomcolorB1, a = 1 },
				b = { r = db.monkcustomcolorR2, g = db.monkcustomcolorG2, b = db.monkcustomcolorB2, a = 1 },
			},
			["DRUID"] = {
				a = { r = db.druidcustomcolorR1, g = db.druidcustomcolorG1, b = db.druidcustomcolorB1, a = 1 },
				b = { r = db.druidcustomcolorR2, g = db.druidcustomcolorG2, b = db.druidcustomcolorB2, a = 1 },
			},
			["DEMONHUNTER"] = {
				a = { r = db.demonhuntercustomcolorR1, g = db.demonhuntercustomcolorG1, b = db.demonhuntercustomcolorB1, a = 1 },
				b = { r = db.demonhuntercustomcolorR2, g = db.demonhuntercustomcolorG2, b = db.demonhuntercustomcolorB2, a = 1 },
			},
			["EVOKER"] = {
				a = { r = db.evokercustomcolorR1, g = db.evokercustomcolorG1, b = db.evokercustomcolorB1, a = 1 },
				b = { r = db.evokercustomcolorR2, g = db.evokercustomcolorG2, b = db.evokercustomcolorB2, a = 1 },
			},
			["friendly"] = { a = { r = db.npcfriendlyR1, g = db.npcfriendlyG1, b = db.npcfriendlyB1, a = 1 }, b = { r = db.npcfriendlyR2, g = db.npcfriendlyG2, b = db.npcfriendlyB2, a = 1 } },
			["neutral"] = { a = { r = db.npcneutralR1, g = db.npcneutralG1, b = db.npcneutralB1, a = 1 }, b = { r = db.npcneutralR2, g = db.npcneutralG2, b = db.npcneutralB2, a = 1 } },
			["enemy"] = { a = { r = db.npchostileR1, g = db.npchostileG1, b = db.npchostileB1, a = 1 }, b = { r = db.npchostileR2, g = db.npchostileG2, b = db.npchostileB2, a = 1 } },
		}
	end

	return elt_tbl
end
