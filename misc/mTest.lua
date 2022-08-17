local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)

-- local NP = E:GetModule('NamePlates')
local UF = E:GetModule('UnitFrames')
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
	print(ns.name .. "  " .. text)
end

local function CustomBackdrop(table, frame, r, g, b)
	-- print("--------------> Start")
	-- for k, v in pairs(table.backdrop) do
	-- 	print(k, v)
	-- end
if not table.backdrop.mTexture then
	--table.backdrop:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\textures\\a4.tga")
	table.bg:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\textures\\p6.tga")
	--table.bg.multiplier = 1
	--table.backdrop.mTexture:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\textures\\a4.tga")

	--table.backdrop.mTexture:ClearAllPoints()
	--table.backdrop.mTexture:Point("CENTER")
	--table.backdrop.mTexture:Size(self.XY, self.XY)
	--table.backdrop.mTexture:SetVertexColor(Nr, Ng, Nb, Na)
end
	
end

hooksecurefunc(UF, "PostUpdateHealthColor", CustomBackdrop)