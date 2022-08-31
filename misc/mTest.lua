local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)

local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")
-- local LSM = E.Libs.LSM

-- local ipairs = ipairs
-- local unpack = unpack
-- local UnitPlayerControlled = UnitPlayerControlled
-- local UnitIsTapDenied = UnitIsTapDenied
-- local UnitClass = UnitClass
-- local UnitReaction = UnitReaction
-- local UnitIsConnected = UnitIsConnected
-- local CreateFrame = CreateFrame
local addon, ns = ...

local function mPrint(text)
	print("|CFF8E44ADm|r|CFF2ECC71Media|r|CFF3498DBTag|r" .. "  " .. text)
end

local mInsert = table.insert

local function mcg(color)
	local shift = 0.5
	local absr = 0.3
	local absg = 0.7
	local absb = 0.6
	local colorA = { color[1] - 0.3, color[2] - 0.3, color[3] - 0.3 }
	if color[1] > color[2] and color[1] > color[3] then
		colorA = { color[1] + absr, color[2] - absr, color[3] - absr }
	elseif color[2] > color[1] and color[2] > color[3] then
		colorA = { color[1] - absg, color[2] + absg, color[3] - absg }
	elseif color[3] > color[1] and color[3] > color[2] then
		colorA = { color[1] - absb, color[2] - absb, color[3] + absb }
	elseif color[1] == color[2] and color[1] == color[3] then
		colorA = { color[1] - absb - shift, color[2] - absb - shift, color[3] - absb - shift }
	else
		colorA = { color[1] - absr, color[2] - absg, color[3] - absb }
	end


	local colorB = color
	local gardientColor = {}
	gardientColor[1] = colorA[1] + shift * (colorB[1] - colorA[1])
	gardientColor[2] = colorA[2] + shift * (colorB[2] - colorA[2])
	gardientColor[3] = colorA[3] + shift * (colorB[3] - colorA[3])

	return gardientColor
end

local function CustomBackdrop(table, frame, r, g, b)
	-- print("--------------> Start")
	-- for k, v in pairs(table) do
	-- 	print(k, v)
	-- end
	--table.backdrop:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\textures\\a4.tga")
	-- if r and g and b then
	-- 	local c = mcg({r, g, b})
	-- 		table:GetStatusBarTexture():SetGradient("HORIZONTAL", c[1], c[2], c[3], r, g, b)
	-- end
	if table.bg then
		-- table:SetBackdrop({bgFile = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\textures\\a4.tga",
		-- edgeFile = nil,
		-- tile = true, tileSize = 16, edgeSize = 16,
		-- insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		--MinimapCluster:SetBackdropColor(0,0,0,1);

		-- local bg = table.bg
		-- if not bg.customBG then
		-- 	bg.customBG = CreateFrame('StatusBar', nil, bg)--("Interface\\AddOns\\ElvUI_mMediaTag\\media\\textures\\p6.tga", "overlay")
		-- 	bg.customBG:SetColorTexture(1, 1, 1)
		-- end

		-- bg.customBG:Show()
		-- bg.customBG:SetSize(bg:GetWidth(), bg:GetHeight())
		-- bg.customBG:SetPoint("right", table.bg, "left", 0, 0)
		-- bg.customBG:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\textures\\p6.tga")
		-- bg.customBG:SetVertexColor(r, g, b)
		-- bg.customBG:SetAlpha(1)

		table.bg:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\textures\\p6.tga")
	end
end
--CUSTOM_CLASS_COLORS r g b colorStr
local function mhealtmarkerOptions()

end

--mInsert(ns.Config, mhealtmarkerOptions)
--hooksecurefunc(NP, "Health_UpdateColor", CustomBackdrop)
hooksecurefunc(UF, "PostUpdateHealthColor", CustomBackdrop)

