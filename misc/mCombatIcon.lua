local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)

local addon, ns = ...


local mInsert = table.insert

local function CustomCombatiocn()
	E.Options.args.mMediaTag.args.cosmetic.args.customcombaticon.args = {

	}

end

mInsert(ns.Config, CustomCombatiocn)