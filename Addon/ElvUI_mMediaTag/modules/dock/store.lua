local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local _G = _G
local icons = MEDIA.icons.dock
local GetCurrentTokenMarketPrice = C_WowTokenPublic.GetCurrentMarketPrice

local config = {
	name = "mMT_Dock_BlizzardStore",
	localizedName = "|CFF01EEFFDock|r" .. " " .. BLIZZARD_STORE,
	category = mMT.NameShort .. " - |CFF01EEFFDock|r",
	icon = {
		notification = false,
		texture = mMT.IconSquare,
		color = { r = 1, g = 1, b = 1, a = 1 },
	},
	misc = {
		secure = true,
		macroA = "/click StoreMicroButton",
		funcOnEnter = nil,
		funcOnLeave = nil,
	},
}

local function OnEnter(self)
	Dock:OnEnter(self.__owner)

	if E.db.mMT.dock.tooltip then
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:AddLine(mMT:TC(BLIZZARD_STORE, "title"))

		if E.Retail or E.Mists then
			local price = E:FormatMoney(GetCurrentTokenMarketPrice() or 0, "BLIZZARD", false)
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(mMT:TC(L["WoW Token:"], "mark"), price)
		end
		GameTooltip:Show()
	end
end

local function OnLeave(self)
	Dock:OnLeave(self.__owner)
	if E.db.mMT.dock.tooltip then GameTooltip:Hide() end
end

local function OnEvent(self, event, ...)
	if event == "ELVUI_FORCE_UPDATE" then
		--setup settings
		config.icon.texture = icons[E.db.mMT.dock.store.style][E.db.mMT.dock.store.icon] or MEDIA.fallback
		config.icon.color = E.db.mMT.dock.store.custom_color and MEDIA.color.dock.store or nil
		config.misc.funcOnEnter = OnEnter
		config.misc.funcOnLeave = OnLeave

		Dock:CreateDockIcon(self, config, event)
	end
end

DT:RegisterDatatext(config.name, config.category, nil, OnEvent, nil, nil, nil, nil, config.localizedName, nil, nil)
