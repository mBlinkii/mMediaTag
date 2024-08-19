local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

--Variables
local specDT = nil

local Config = {
	name = "mMT_Dock_Talent",
	localizedName = mMT.DockString .. " " .. TALENTS_BUTTON,
	category = "mMT-" .. mMT.DockString,
	text = {
		enable = true,
		center = false,
		a = true, -- first label
		b = false, -- second label
	},
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	mMT:Dock_OnEnter(self, Config)
	if E.db.mMT.dockdatatext.tip.enable and specDT then specDT.onEnter() end
end

local function OnEvent(self, event, loadoutID)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		Config.text.enable = E.db.mMT.dockdatatext.talent.showrole
		Config.text.a = E.db.mMT.dockdatatext.talent.showrole
		Config.icon.texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.talent.icon]
		Config.icon.color = E.db.mMT.dockdatatext.talent.customcolor and E.db.mMT.dockdatatext.talent.iconcolor or nil

		mMT:InitializeDockIcon(self, Config, event)
	end

	specDT = mMT:GetElvUIDataText("Talent/Loot Specialization")

	if specDT and specDT ~= "Data Broker" then specDT.eventFunc(self, event, loadoutID) end

	local text = nil
	if E.db.mMT.dockdatatext.talent.showrole and self.mMT_Dock and self.mMT_Dock.TextA then
		local customIcons = E.db.mMT.roleicons.enable
		if IsInGroup() then
			local Role = UnitGroupRolesAssigned("player")

			if Role == "TANK" then
				text = customIcons and E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.tank], ":14:14") or TANK_ICON
			elseif Role == "HEALER" then
				text = customIcons and E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.heal], ":14:14") or HEALER_ICON
			else
				text = customIcons and E:TextureString(mMT.Media.Role[E.db.mMT.roleicons.dd], ":14:14") or DPS_ICON
			end
			self.mMT_Dock.TextA:SetText(text)
		elseif self.mMT_Dock.TextA then
			self.mMT_Dock.TextA:SetText("")
		end
	end
	self.text:SetText("")
end

local function OnLeave(self)
	if E.db.mMT.dockdatatext.tip.enable then DT.tooltip:Hide() end

	mMT:Dock_OnLeave(self, Config)
end

local function OnClick(self, btn)
	if mMT:CheckCombatLockdown() then
		mMT:Dock_Click(self, Config)

		specDT = mMT:GetElvUIDataText("Talent/Loot Specialization")
		if specDT then specDT.onClick(self, btn) end
	end
end

DT:RegisterDatatext(
	Config.name,
	Config.category,
	{ "PLAYER_TALENT_UPDATE", "ACTIVE_TALENT_GROUP_CHANGED", "PLAYER_LOOT_SPEC_UPDATED", "TRAIT_CONFIG_DELETED", "TRAIT_CONFIG_UPDATED", "GROUP_ROSTER_UPDATE" },
	OnEvent,
	nil,
	OnClick,
	OnEnter,
	OnLeave,
	Config.localizedName,
	nil,
	nil
)
