local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local M = E:GetModule("Minimap")
local addon, ns = ...

--Lua functions
local tinsert = tinsert
local format = format
local wipe = wipe
local UF = E:GetModule("UnitFrames")
local LSM = LibStub("LibSharedMedia-3.0")
local AB = E:GetModule("ActionBars")

local function SetCustomTexture(statusbar, texture, class)
	print(class)
	if class == "PRIEST" then
		statusbar.Health:SetStatusBarTexture(LSM:Fetch("statusbar", "mMediaTag R4"))
	else
		statusbar.Health:SetStatusBarTexture(texture)
	end
end

function FGM(name, tbl, r, g, b, h, k)
	if _G["ElvUF_" .. "Target"] then
		SetCustomTexture(
			_G["ElvUF_" .. "Target"],
			LSM:Fetch("statusbar", "mMediaTag R2"),
			select(2, UnitClass("target"))
		)
	end

	if _G["ElvUF_" .. "Player"] then
		SetCustomTexture(
			_G["ElvUF_" .. "Player"],
			LSM:Fetch("statusbar", "mMediaTag R2"),
			select(2, UnitClass("player"))
		)
	end
end

--hooksecurefunc(MainMenuMicroButton, "OnUpdate", mmb)
--AB:SecureHook('UpdateMicroButtons')
--hooksecurefunc(UF, "Update_StatusBar", FGM)
