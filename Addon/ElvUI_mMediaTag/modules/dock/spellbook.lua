local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock

local _G = _G
local GetSpecialization = C_SpecializationInfo.GetSpecialization
local GetSpecializationInfo = C_SpecializationInfo.GetSpecializationInfo
local PlayerSpellsUtil = _G.PlayerSpellsUtil
local specializationIndex = nil

local config = {
	name = "mMT_Dock_SpellBook",
	localizedName = "|CFF01EEFFDock|r" .. " " .. (E.Retail and _G.SPELLBOOK or _G.SPELLBOOK_ABILITIES_BUTTON),
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMT.dock.tooltip then
		DT.tooltip:ClearLines()
		DT.tooltip:AddLine((E.Retail and _G.SPELLBOOK or _G.SPELLBOOK_ABILITIES_BUTTON), mMT:GetRGB("title"))
		DT.tooltip:AddLine(" ")

		if E.Retail then
			specializationIndex = specializationIndex or GetSpecialization()
			if specializationIndex then
				local _, name, description, icon, _, _, _, _, _, _ = GetSpecializationInfo(specializationIndex)
				DT.tooltip:AddDoubleLine(_G.SPECIALIZATION, E:TextureString(icon, ":14:14") .. " " .. name, mMT:GetRGB("text", "myclass"))
				DT.tooltip:AddLine(" ")
				DT.tooltip:AddLine(description, mMT:GetRGB("text"))
				DT.tooltip:AddLine(" ")
				DT.tooltip:AddLine(MEDIA.leftClick .. " " .. L["click to open the Spellbook."], mMT:GetRGB("tip"))
				if E.Retail then
					DT.tooltip:AddLine(" ")
					DT.tooltip:AddLine( L["Opening the spellbook via addons can lead to taints.\nThis occurs when protected Blizzard code is unintentionally modified or affected,\nwhich may result in malfunctions or UI restrictions."], mMT:GetRGB("tip") )
				end
			end
		end

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMT.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if not E:AlertCombat() then
		Dock:Click(self)
		if PlayerSpellsUtil then
			PlayerSpellsUtil.ToggleSpellBookFrame()
		else
			ToggleFrame(_G.SpellBookFrame)
		end
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		-- setup settings
		config.icon.texture = icons[E.db.mMT.dock.spellbook.style][E.db.mMT.dock.spellbook.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.spellbook.custom_color and MEDIA.color.dock.spellbook or nil

		Dock:CreateDockIcon(self, config, event)
	end

	specializationIndex = E.Retail and GetSpecialization() or nil
end

DT:RegisterDatatext(config.name, config.category, (E.Retail and { "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED" }), OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
