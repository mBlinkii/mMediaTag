local E = unpack(ElvUI)
local _G = _G

local player = {
	enable = true,
	texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\round3.tga",
	size = 128,
	point = "RIGHT",
	relativePoint = "LEFT",
	x = 0,
	y = 0,
}

local Colors = {
	conf = {
		combat = true,
		gradient = false,
		ori = "HORIZONTAL",
		scale = 10
	},
	xx = {
		a = {},
		b = {},
	},
}



local function setColor(texture, color)
	if not color then
		color = Colors.default
	end

	if Colors.conf.gradient then
		texture:SetGradient(Colors.conf.ori, color.a, color.b)
	else
		--texture:SetVertexColor(color.a)
		texture:SetVertexColor(color.r, color.g, color.b, color.a)
	end
end

local function getColor(texture, unit)
	local exists = UnitExists(unit)
	if exists then
		local isPlayer = UnitIsPlayer(unit)
		local inCombat = Colors.conf.combat and UnitAffectingCombat(unit) or false
		if isPlayer then
			if inCombat then
				setColor(texture, Colors.combat)
			else
				local _, class = UnitClass(unit)
				setColor(texture, _G.RAID_CLASS_COLORS[class]) --Colors[class])
			end
		else
		end
	else
	end
end

local function CreatePortrait(parent, conf, unit)


	local frame = CreateFrame("Frame", "mMT_Portrait_" .. unit, parent)
	frame:SetSize(conf.size, conf.size)
	frame:SetPoint(conf.point, parent, conf.relativePoint, conf.x, conf.y)

	frame.texture = frame:CreateTexture("mMT_Border", "OVERLAY", nil, 2)
	frame.texture:SetAllPoints(frame)
	frame.texture:SetTexture(conf.texture)
	getColor(frame.texture, unit)

	frame.portrait = frame:CreateTexture("mMT_Portrait", "OVERLAY", nil, 1)
	--frame.portrait:SetAllPoints(frame)
	local yx = (conf.size- conf.size/(8 * E.perfect) )/(8 * E.perfect)
	frame.portrait:SetPoint("TOPLEFT", yx, -yx)
	frame.portrait:SetPoint("BOTTOMRIGHT", -yx, yx)
	--frame.portrait:Size(conf.size -40, conf.size -40)

	frame:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", "player")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED") -- Added
	frame:SetScript("OnEvent", function(self)
		SetPortraitTexture(self.portrait, "player", true)
		print(yx)
		--print("<<<<<", 32/8 * (E.perfect), 32 - (E.perfect/2), 768 / E.physicalHeight, E.perfect)
	end)

	return frame

	-- 	SetSize(70, 70)
	-- fp:SetPoint("CENTER", -100, -320)
	-- fp:SetAttributew("unit", "player")
	-- RegisterUnitWatch(fp)
	-- fp:SetAttribute("toggleForVehicle", true)
	-- fp:RegisterForClicks("AnyUp")
	-- fp:SetAttribute("*type1", "target")
	-- fp:SetAttribute("*type2", "togglemenu")
	-- fp:SetAttribute("*type3", "assist")
	-- fp.Texture = fp:CreateTexture("$parent_Texture", "BACKGROUND")
	-- fp.Texture:SetAllPoints()
	-- SetPortraitTexture(fp.Texture, "player")
	-- fp.Border = fp:CreateTexture("$parent_Border", "BORDER")
	-- fp.Border:SetPoint("TOPLEFT", -6, 4)
	-- fp.Border:SetPoint("BOTTOMRIGHT", 6, -10)
	-- fp.Border:SetTexture("Interface/PLAYERFRAME/UI-PlayerFrame-Deathknight-Ring")
	-- fp.Border:SetVertexColor(1, 1, 0, 1)
	-- fp:RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", "player")
	-- fp:RegisterEvent("PLAYER_TARGET_CHANGED") -- Added
	-- fp:SetScript("OnEvent", function(self)
	--     if event == "UNIT_PORTRAIT_UPDATE" then
	--         SetPortraitTexture(self.Texture, "player")
	--     else
	--         SetPortraitTexture(self.Target.Texture, "target") -- Added
	--     end
end

function mMT:UpdatePortraitSettings() end

function mMT:SetupPortraits()
	Colors.conf.scale = E:Scale(10)
	if not mMT.Portraits then
		mMT.Portraits = {}
	end

	if player.enable and not mMT.Portraits.Player then
		mMT.Portraits.Player = CreatePortrait(_G.ElvUF_Player, player, "player")
		mMT:DebugPrintTable(mMT.Portraits.Player)
	end
end
