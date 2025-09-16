local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock

local _G = _G
local GetPerksActivitiesInfo = C_PerksActivities.GetPerksActivitiesInfo
local IsAddOnLoaded = _G.C_AddOns and _G.C_AddOns.IsAddOnLoaded or IsAddOnLoaded

local config = {
	name = "mMT_Dock_EncounterJournal",
	localizedName = "|CFF01EEFFDock|r" .. " " .. ENCOUNTER_JOURNAL,
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
		DT.tooltip:AddLine(ENCOUNTER_JOURNAL, mMT:GetRGB("title"))
		DT.tooltip:AddLine(" ")

		local activities = GetPerksActivitiesInfo()
		if activities then
			DT.tooltip:AddDoubleLine(L["Reisetagebuch"], activities.displayMonthName, mMT:GetRGB("text", "text"))
			local completed, total = 0, #activities.activities

			for _, activity in ipairs(activities.activities) do
				if activity.completed then completed = completed + 1 end
			end
			DT.tooltip:AddDoubleLine(L["Progress:"], completed .. "/" .. total, mMT:GetRGB("text", "text"))
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
		if not IsAddOnLoaded("Blizzard_EncounterJournal") then UIParentLoadAddOn("Blizzard_EncounterJournal") end
		ToggleFrame(_G.EncounterJournal)
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		-- setup settings
		config.icon.texture = icons[E.db.mMT.dock.encounter.style][E.db.mMT.dock.encounter.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.encounter.custom_color and MEDIA.color.dock.encounter or nil

		Dock:CreateDockIcon(self, config, event)
	end
end

DT:RegisterDatatext(config.name, config.category, nil, OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
