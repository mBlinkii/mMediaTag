local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
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
local function mmb()
	print("D")
	MainMenuMicroButton:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\collection\\collection10.tga")
end

function SkinMicroMenu()
	local buttons = {
		CharacterMicroButton,
		SpellbookMicroButton,
		TalentMicroButton,
		AchievementMicroButton,
		QuestLogMicroButton,
		GuildMicroButton,
		LFDMicroButton,
		EJMicroButton,
		CollectionsMicroButton,
		MainMenuMicroButton,
		HelpMicroButton,
		StoreMicroButton,
	}

	for _, button in ipairs(buttons) do
		local regions = { button:GetRegions() }
		-- local config = aura_env.config[button:GetDebugName()]

		for _, region in pairs(regions) do
			-- only colour textured regions. This is a workaround for ElvUI and any other addons that might add children to the button
			if region:GetAtlas() then
				--region:SetVertexColor(1,.6,0)
				region:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\social\\social1.tga")
				region:SetTexCoord(0, 1, 0, 1)
				--region:ClearAllPoints()
				-- region:SetSize(32, 32)
				--region:SetPoint("CENTER")
				--region:Size(self.XY, self.XY)
				-- if region == MainMenuMicroButton then
				--     hooksecurefunc(region, "OnUpdate", mmb)
				-- end
			end
		end
	end
end
--hooksecurefunc(MainMenuMicroButton, "OnUpdate", mmb)
--AB:SecureHook('UpdateMicroButtons')
--hooksecurefunc(UF, "Update_StatusBar", FGM)
hooksecurefunc(AB, "UpdateMicroButtons", SkinMicroMenu)