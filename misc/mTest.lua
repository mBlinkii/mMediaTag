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
