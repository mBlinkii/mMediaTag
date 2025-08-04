local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("Tooltip")

-- WoW API / Variablen
local _G = _G
local GetItemIcon = C_Item and C_Item.GetItemIconByID or GetItemIcon
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture
local GetCurrencyInfo = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo or GetCurrencyInfo

local function GetIconString(icon)
	if not icon then return "" end
	local size = (module.db and module.db.size) or 16
	if module.db and module.db.zoom then
		return ("|T%s:%d:%d:0:0:64:64:4:60:4:60|t"):format(icon, size, size)
	else
		return ("|T%s:%d|t"):format(icon, size)
	end
end

local function SetTooltipIcon(tooltip, icon)
	if not icon or icon == "" then return end
	local title = _G[tooltip:GetName() .. "TextLeft1"]
	if not title then return end
	local text = title:GetText()

	if not text or text:find("^|T") then return end
	title:SetFormattedText("%s %s", GetIconString(icon), text)
end

-- Classic/BC/WotLK: Tooltip-Hooks
local function AddTooltipIcon(self, icon)
	SetTooltipIcon(self, icon)
end

local function hookTip(tip)
	if not tip or E.Retail then return end

	tip:HookScript("OnTooltipSetItem", function(self)
		local _, link = self:GetItem()
		local icon = link and GetItemIcon(link)
		if icon then AddTooltipIcon(self, icon) end
	end)

	tip:HookScript("OnTooltipSetSpell", function(self)
		local _, spellID = self:GetSpell()
		local icon = spellID and select(3, GetSpellInfo(spellID))
		if icon then AddTooltipIcon(self, icon) end
	end)
end

local function GetCurrencyIcon(id)
	local info = GetCurrencyInfo(id)
	if info then return info.iconFileID end
end

local function ItemIcon(tooltip, data)
	if data and tooltip and data.id and tooltip.ItemTooltip then SetTooltipIcon(tooltip, GetItemIcon(data.id)) end
end

local function SpellIcon(tooltip, data)
	if data and tooltip and data.id then SetTooltipIcon(tooltip, GetSpellTexture(data.id)) end
end

local function MountIcon(tooltip, data)
	if data and tooltip and data.id then SetTooltipIcon(tooltip, select(3, C_MountJournal.GetMountInfoByID(data.id))) end
end

local function MacroIcon(tooltip)
	if tooltip then
		local name = _G[tooltip:GetName() .. "TextLeft1"]:GetText()
		if name then
			local icon = select(2, GetMacroInfo(name)) or GetSpellTexture(name) or GetItemIcon(name)
			SetTooltipIcon(tooltip, icon)
		end
	end
end

local function CurrencyIcon(tooltip, data)
	if data and tooltip and data.id then
		local icon = GetCurrencyIcon(data.id)
		if icon then SetTooltipIcon(tooltip, icon) end
	end
end

function module:Initialize()
	if E.db.mMT.tooltip.enable then
		if E.Retail then
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, ItemIcon)
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, SpellIcon)
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Toy, ItemIcon)
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Mount, MountIcon)
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, MacroIcon)
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Currency, CurrencyIcon)
		else
			for _, name in ipairs({ "GameTooltip", "ItemRefTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ShoppingTooltip3" }) do
				hookTip(_G[name])
			end
		end

		module.db = E.db.mMT.tooltip
	end
end
