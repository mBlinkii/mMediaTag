local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock

local _G = _G
local format = format
local ipairs = ipairs
local type = type
local tinsert = tinsert
local UNKNOWN = UNKNOWN
local OWNER_COLOR = { 0.35, 0.85, 1 }
local NEIGHBORHOOD_COLOR = { 1, 0.82, 0.35 }
local playerHouses

local function AddDoubleLine(left, right, r, g, b)
	DT.tooltip:AddDoubleLine(left, right, 1, 1, 1, r or 1, g or 1, b or 1)
end

local function CachePlayerHouses(houseInfos)
	if type(houseInfos) ~= "table" then return end

	playerHouses = {}
	for _, houseInfo in ipairs(houseInfos) do
		playerHouses[#playerHouses + 1] = houseInfo
	end
end

local function AddKnownHouseList()
	if not (playerHouses and #playerHouses > 0) then
		DT.tooltip:AddLine(L["No cached house information available."], 1, 1, 1)
		return
	end

	for _, houseInfo in ipairs(playerHouses) do
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(houseInfo.houseName or UNKNOWN, mMT:GetRGB("title"))
		AddDoubleLine(L["Owner"], houseInfo.ownerName or UNKNOWN, OWNER_COLOR[1], OWNER_COLOR[2], OWNER_COLOR[3])
		AddDoubleLine(L["Neighborhood"], houseInfo.neighborhoodName or UNKNOWN, NEIGHBORHOOD_COLOR[1], NEIGHBORHOOD_COLOR[2], NEIGHBORHOOD_COLOR[3])
	end
end

local config = {
	name = "mMT_Dock_Housing",
	localizedName = "|CFF01EEFFDock|r" .. " " .. L["Housing"],
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = MEDIA.fallback,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
}

local function OnEnter(self)
	Dock:OnEnter(self)

	if E.db.mMediaTag.dock.tooltip then
		DT.tooltip:ClearLines()
		DT.tooltip:AddLine(L["Housing"], mMT:GetRGB("title"))
		AddKnownHouseList()

		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(MEDIA.rightClick .. " " .. L["right click to open the menu."], mMT:GetRGB("tip"))
		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMediaTag.dock.tooltip then DT.tooltip:Hide() end
end

local function ToggleDashboard()
	if not _G.KeybindFrames_InQuickKeybindMode() then _G.HousingFramesUtil.ToggleHousingDashboard() end
end

-- the teleports run through Blizzard's secure housing actions
local function OpenMenu(self)
	local cooldownInfo = C_Housing.GetVisitCooldownInfo()
	local cooldown = cooldownInfo and mMT:CooldownStateText(cooldownInfo.isActive)
	local menu = { mMT:MenuTitle(L["Housing"]) }

	-- the list arrives with PLAYER_HOUSE_LIST_UPDATED, the next open shows the houses
	if not playerHouses then C_Housing.GetPlayerOwnedHouses() end

	if playerHouses then
		for _, houseInfo in ipairs(playerHouses) do
			if houseInfo.neighborhoodGUID and houseInfo.houseGUID and houseInfo.plotID then tinsert(menu, {
				text = format("%s: %s", _G.HOUSING_DASHBOARD_TELEPORT_TO_PLOT, houseInfo.houseName or UNKNOWN),
				right_text = cooldown,
				attributes = {
					type = "teleporthome",
					["house-neighborhood-guid"] = houseInfo.neighborhoodGUID,
					["house-guid"] = houseInfo.houseGUID,
					["house-plot-id"] = houseInfo.plotID,
				},
			}) end
		end
	end

	if C_HousingNeighborhood.CanReturnAfterVisitingHouse() then tinsert(menu, {
		text = _G.HOUSING_DASHBOARD_RETURN,
		attributes = { type = "returnhome" },
	}) end

	tinsert(menu, mMT:MenuSpacer())
	tinsert(menu, { text = _G.HOUSING_DASHBOARD_CATALOG_FRAMETITLE, func = ToggleDashboard })

	mMT:ShowMenu(menu, self)
end

local function OnClick(self, btn)
	if not E:AlertCombat() then
		if _G.Kiosk.IsEnabled() then return end

		if btn == "RightButton" then
			OpenMenu(self)
		else
			ToggleDashboard()
		end
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		config.icon.texture = icons[E.db.mMediaTag.dock.housing.style][E.db.mMediaTag.dock.housing.icon] or MEDIA.fallback
		config.icon.color = E.db.mMediaTag.dock.housing.custom_color and MEDIA.color.dock.housing or nil

		Dock:CreateDockIcon(self, config, event)
		return
	end

	if event == "PLAYER_HOUSE_LIST_UPDATED" then CachePlayerHouses(...) end
end

DT:RegisterDatatext(config.name, config.category, "PLAYER_HOUSE_LIST_UPDATED", OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
