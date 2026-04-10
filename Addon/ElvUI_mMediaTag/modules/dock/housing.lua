local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local icons = MEDIA.icons.dock

local _G = _G
local ipairs = ipairs
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

		DT.tooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self)
	if E.db.mMediaTag.dock.tooltip then DT.tooltip:Hide() end
end

local function OnClick(self)
	if not E:AlertCombat() then
		if _G.Kiosk.IsEnabled() then return end

		if not _G.KeybindFrames_InQuickKeybindMode() then _G.HousingFramesUtil.ToggleHousingDashboard() end
	end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		-- setup settings
		config.icon.texture = icons[E.db.mMediaTag.dock.housing.style][E.db.mMediaTag.dock.housing.icon] or MEDIA.fallback
		config.icon.color = E.db.mMediaTag.dock.housing.custom_color and MEDIA.color.dock.housing or nil

		Dock:CreateDockIcon(self, config, event)
		return
	end

	if event == "PLAYER_HOUSE_LIST_UPDATED" then
		CachePlayerHouses(...)
	end
end

DT:RegisterDatatext(config.name, config.category, "PLAYER_HOUSE_LIST_UPDATED", OnEvent, nil, OnClick, OnEnter, OnLeave, config.localizedName, nil, nil)
