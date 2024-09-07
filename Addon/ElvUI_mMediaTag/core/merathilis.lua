local E = unpack(ElvUI)
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

function mMT:CheckMerathilisUI()
	local mui_tbl = {
		loaded = IsAddOnLoaded("ElvUI_MerathilisUI"),
		gradient = false,
		custom = false,
		colors = nil,
	}

	if mui_tbl.loaded then
		mui_tbl.gradient = E.db.mui.gradient and E.db.mui.gradient.enable
		mui_tbl.custom = E.db.mui.gradient and E.db.mui.gradient.customColor.enableClass
		local c = mui_tbl.custom and E.db.mui.gradient.customColor or _G.ElvUI_MerathilisUI[2].ClassGradient

		if mui_tbl.custom then
			mui_tbl.colors = {
				["WARRIOR"] = { a = { r = c.warriorcolorR1, g = c.warriorcolorG1, b = c.warriorcolorB1, a = 1 }, b = { r = c.warriorcolorR2, g = c.warriorcolorG2, b = c.warriorcolorB2, a = 1 } },
				["PALADIN"] = { a = { r = c.paladincolorR1, g = c.paladincolorG1, b = c.paladincolorB1, a = 1 }, b = { r = c.paladincolorR2, g = c.paladincolorG2, b = c.paladincolorB2, a = 1 } },
				["HUNTER"] = { a = { r = c.huntercolorR1, g = c.huntercolorG1, b = c.huntercolorB1, a = 1 }, b = { r = c.huntercolorR2, g = c.huntercolorG2, b = c.huntercolorB2, a = 1 } },
				["ROGUE"] = { a = { r = c.roguecolorR1, g = c.roguecolorG1, b = c.roguecolorB1, a = 1 }, b = { r = c.roguecolorR2, g = c.roguecolorG2, b = c.roguecolorB2, a = 1 } },
				["PRIEST"] = { a = { r = c.priestcolorR1, g = c.priestcolorG1, b = c.priestcolorB1, a = 1 }, b = { r = c.priestcolorR2, g = c.priestcolorG2, b = c.priestcolorB2, a = 1 } },
				["DEATHKNIGHT"] = {
					a = { r = c.deathknightcolorR1, g = c.deathknightcolorG1, b = c.deathknightcolorB1, a = 1 },
					b = { r = c.deathknightcolorR2, g = c.deathknightcolorG2, b = c.deathknightcolorB2, a = 1 },
				},
				["SHAMAN"] = { a = { r = c.shamancolorR1, g = c.shamancolorG1, b = c.shamancolorB1, a = 1 }, b = { r = c.shamancolorR2, g = c.shamancolorG2, b = c.shamancolorB2, a = 1 } },
				["MAGE"] = { a = { r = c.magecolorR1, g = c.magecolorG1, b = c.magecolorB1, a = 1 }, b = { r = c.magecolorR2, g = c.magecolorG2, b = c.magecolorB2, a = 1 } },
				["WARLOCK"] = { a = { r = c.warlockcolorR1, g = c.warlockcolorG1, b = c.warlockcolorB1, a = 1 }, b = { r = c.warlockcolorR2, g = c.warlockcolorG2, b = c.warlockcolorB2, a = 1 } },
				["MONK"] = { a = { r = c.monkcolorR1, g = c.monkcolorG1, b = c.monkcolorB1, a = 1 }, b = { r = c.monkcolorR2, g = c.monkcolorG2, b = c.monkcolorB2, a = 1 } },
				["DRUID"] = { a = { r = c.druidcolorR1, g = c.druidcolorG1, b = c.druidcolorB1, a = 1 }, b = { r = c.druidcolorR2, g = c.druidcolorG2, b = c.druidcolorB2, a = 1 } },
				["DEMONHUNTER"] = {
					a = { r = c.demonhuntercolorR1, g = c.demonhuntercolorG1, b = c.demonhuntercolorB1, a = 1 },
					b = { r = c.demonhuntercolorR2, g = c.demonhuntercolorG2, b = c.demonhuntercolorB2, a = 1 },
				},
				["EVOKER"] = { a = { r = c.evokercolorR1, g = c.evokercolorG1, b = c.evokercolorB1, a = 1 }, b = { r = c.evokercolorR2, g = c.evokercolorG2, b = c.evokercolorB2, a = 1 } },
				["friendly"] = { a = { r = c.npcfriendlyR1, g = c.npcfriendlyG1, b = c.npcfriendlyB1, a = 1 }, b = { r = c.npcfriendlyR2, g = c.npcfriendlyG2, b = c.npcfriendlyB2, a = 1 } },
				["neutral"] = { a = { r = c.npcneutralR1, g = c.npcneutralG1, b = c.npcneutralB1, a = 1 }, b = { r = c.npcneutralR2, g = c.npcneutralG2, b = c.npcneutralB2, a = 1 } },
				["enemy"] = { a = { r = c.npchostileR1, g = c.npchostileG1, b = c.npchostileB1, a = 1 }, b = { r = c.npchostileR2, g = c.npchostileG2, b = c.npchostileB2, a = 1 } },
			}
		else
			mui_tbl.colors = {
				["WARRIOR"] = { a = { r = c.WARRIOR.r1, g = c.WARRIOR.g1, b = c.WARRIOR.b1, a = 1 }, b = { r = c.WARRIOR.r2, g = c.WARRIOR.g2, b = c.WARRIOR.b2, a = 1 } },
				["PALADIN"] = { a = { r = c.PALADIN.r1, g = c.PALADIN.g1, b = c.PALADIN.b1, a = 1 }, b = { r = c.PALADIN.r2, g = c.PALADIN.g2, b = c.PALADIN.b2, a = 1 } },
				["HUNTER"] = { a = { r = c.HUNTER.r1, g = c.HUNTER.g1, b = c.HUNTER.b1, a = 1 }, b = { r = c.HUNTER.r2, g = c.HUNTER.g2, b = c.HUNTER.b2, a = 1 } },
				["ROGUE"] = { a = { r = c.ROGUE.r1, g = c.ROGUE.g1, b = c.ROGUE.b1, a = 1 }, b = { r = c.ROGUE.r2, g = c.ROGUE.g2, b = c.ROGUE.b2, a = 1 } },
				["PRIEST"] = { a = { r = c.PRIEST.r1, g = c.PRIEST.g1, b = c.PRIEST.b1, a = 1 }, b = { r = c.PRIEST.r2, g = c.PRIEST.g2, b = c.PRIEST.b2, a = 1 } },
				["DEATHKNIGHT"] = { a = { r = c.DEATHKNIGHT.r1, g = c.DEATHKNIGHT.g1, b = c.DEATHKNIGHT.b1, a = 1 }, b = { r = c.DEATHKNIGHT.r2, g = c.DEATHKNIGHT.g2, b = c.DEATHKNIGHT.b2, a = 1 } },
				["SHAMAN"] = { a = { r = c.SHAMAN.r1, g = c.SHAMAN.g1, b = c.SHAMAN.b1, a = 1 }, b = { r = c.SHAMAN.r2, g = c.SHAMAN.g2, b = c.SHAMAN.b2, a = 1 } },
				["MAGE"] = { a = { r = c.MAGE.r1, g = c.MAGE.g1, b = c.MAGE.b1, a = 1 }, b = { r = c.MAGE.r2, g = c.MAGE.g2, b = c.MAGE.b2, a = 1 } },
				["WARLOCK"] = { a = { r = c.WARLOCK.r1, g = c.WARLOCK.g1, b = c.WARLOCK.b1, a = 1 }, b = { r = c.WARLOCK.r2, g = c.WARLOCK.g2, b = c.WARLOCK.b2, a = 1 } },
				["MONK"] = { a = { r = c.MONK.r1, g = c.MONK.g1, b = c.MONK.b1, a = 1 }, b = { r = c.MONK.r2, g = c.MONK.g2, b = c.MONK.b2, a = 1 } },
				["DRUID"] = { a = { r = c.DRUID.r1, g = c.DRUID.g1, b = c.DRUID.b1, a = 1 }, b = { r = c.DRUID.r2, g = c.DRUID.g2, b = c.DRUID.b2, a = 1 } },
				["DEMONHUNTER"] = { a = { r = c.DEMONHUNTER.r1, g = c.DEMONHUNTER.g1, b = c.DEMONHUNTER.b1, a = 1 }, b = { r = c.DEMONHUNTER.r2, g = c.DEMONHUNTER.g2, b = c.DEMONHUNTER.b2, a = 1 } },
				["EVOKER"] = { a = { r = c.EVOKER.r1, g = c.EVOKER.g1, b = c.EVOKER.b1, a = 1 }, b = { r = c.EVOKER.r2, g = c.EVOKER.g2, b = c.EVOKER.b2, a = 1 } },
				["friendly"] = { a = { r = c.NPCFRIENDLY.r1, g = c.NPCFRIENDLY.g1, b = c.NPCFRIENDLY.b1, a = 1 }, b = { r = c.NPCFRIENDLY.r2, g = c.NPCFRIENDLY.g2, b = c.NPCFRIENDLY.b2, a = 1 } },
				["neutral"] = { a = { r = c.NPCNEUTRAL.r1, g = c.NPCNEUTRAL.g1, b = c.NPCNEUTRAL.b1, a = 1 }, b = { r = c.NPCNEUTRAL.r2, g = c.NPCNEUTRAL.g2, b = c.NPCNEUTRAL.b2, a = 1 } },
				["enemy"] = { a = { r = c.NPCHOSTILE.r1, g = c.NPCHOSTILE.g1, b = c.NPCHOSTILE.b1, a = 1 }, b = { r = c.NPCHOSTILE.r2, g = c.NPCHOSTILE.g2, b = c.NPCHOSTILE.b2, a = 1 } },
			}
		end
	end

	return mui_tbl
end
