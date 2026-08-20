local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("AussyLootSkin")

-- Cache WoW Globals
local _G = _G
local unpack = unpack
local hooksecurefunc = hooksecurefunc
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or _G.IsAddOnLoaded

local function Fill(color, r, g, b, a)
	if not color then return end

	color[1], color[2], color[3], color[4] = r, g, b, a
end

local function AccentColor()
	local db = module.db.color

	if db.mode == "class" then
		return MEDIA.myclass.r, MEDIA.myclass.g, MEDIA.myclass.b, db.color.a
	elseif db.mode == "custom" then
		return db.color.r, db.color.g, db.color.b, db.color.a
	elseif db.mode == "value" then
		local r, g, b = unpack(E.media.rgbvaluecolor)
		return r, g, b, db.color.a
	end
end

-- AussyLoot reads its palette while it builds a page, so the tables are filled in place instead of replaced
local function ApplyPalette(AL)
	local colors = AL.Color
	if not colors then return end

	local backdrop = E.media.backdropcolor
	local fade = E.media.backdropfadecolor
	local border = E.media.bordercolor

	Fill(colors.recessed, fade[1], fade[2], fade[3], fade[4])
	Fill(colors.canvas, fade[1], fade[2], fade[3], fade[4])
	Fill(colors.panel, fade[1], fade[2], fade[3], fade[4])
	Fill(colors.panelAlt, fade[1], fade[2], fade[3], fade[4])
	Fill(colors.header, backdrop[1], backdrop[2], backdrop[3], 1)
	Fill(colors.raised, backdrop[1], backdrop[2], backdrop[3], 1)
	Fill(colors.edge, border[1], border[2], border[3], 1)
	Fill(colors.edgeStrong, border[1], border[2], border[3], 1)

	local r, g, b, a = AccentColor()
	if not r then return end

	-- brand, accent and venom are the same table in AussyLoot, the others are status and category colors and stay
	Fill(colors.venom, r, g, b, a)
	Fill(colors.brand, r, g, b, a)
	Fill(colors.accent, r, g, b, a)
end

local function ApplyFont(AL)
	local fonts = AL.Fonts
	if not fonts then return end

	fonts.body, fonts.display, fonts.dense, fonts.title = E.media.normFont, E.media.normFont, E.media.normFont, E.media.normFont
end

-- the window is unnamed and only built on the first open, its gradient, material and corner brackets are all regions of the frame itself
local function SkinWindow()
	local AL = _G.AussyLoot
	local frame = AL and AL.MainWindow

	if not frame or frame.mmt_skinned then return end

	frame.mmt_skinned = true

	frame:StripTextures()
	frame:SetTemplate("Transparent")
end

function module:Initialize()
	module.db = E.db.mMediaTag.skins.aussyloot

	if not (module.db and module.db.enable) or not IsAddOnLoaded("AussyLoot") then return end

	local AL = _G.AussyLoot
	if not AL then return end

	ApplyPalette(AL)
	ApplyFont(AL)
	SkinWindow()

	if module.isRegistered or not AL.CreateMainWindow then return end

	module.isRegistered = true

	hooksecurefunc(AL, "CreateMainWindow", SkinWindow)
end
