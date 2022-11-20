local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...

--WoW API / Variables
local _G = _G
local GetItemIcon = GetItemIcon
local GetSpellInfo = GetSpellInfo

local function AddToolTipIconItem(tooltip, data)
	if data  then
		if data.id and tooltip:GetName() then
			local title = _G[tooltip:GetName() .. "TextLeft1"]
			local icon = GetItemIcon(data.id)
			title:SetFormattedText("|T%s:%d|t %s", icon, E.db[mPlugin].mTIconSize, title:GetText())
		end
	end
end

local function AddToolTipIconSpell(tooltip, data)
	if data  then
		if data.id and tooltip:GetName() then
			local title = _G[tooltip:GetName() .. "TextLeft1"]
			local icon = GetSpellTexture(data.id)
			title:SetFormattedText("|T%s:%d|t %s", icon, E.db[mPlugin].mTIconSize, title:GetText())
		end
	end
end

local function AddTooltipIcon(self, icon)
	if icon then
		local title = _G[self:GetName() .. "TextLeft1"]
		if title and not title:GetText():find("|T" .. icon) then
			title:SetFormattedText("|T%s:%d|t %s", icon, E.db[mPlugin].mTIconSize, title:GetText())
			title:Show()
		end
	end
end

local function hookTip(tip)
	if tip and not E.Retail then
		tip:HookScript("OnTooltipSetItem", function(self, ...)
			local _, link = self:GetItem()
			local icon = link and GetItemIcon(link)
			AddTooltipIcon(self, icon)
		end)

		tip:HookScript("OnTooltipSetSpell", function(self, ...)
			if self:GetSpell() then
				local _, spellID = self:GetSpell()
				local _, _, icon = GetSpellInfo(spellID)
				AddTooltipIcon(self, icon)
			end
		end)
	end
end

function mMT:TipIconSetup()
	if E.Retail then
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, AddToolTipIconItem)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, AddToolTipIconSpell)
	else
		hookTip(_G["GameTooltip"])
		hookTip(_G["ItemRefTooltip"])
		hookTip(_G["ShoppingTooltip1"])
		hookTip(_G["ShoppingTooltip2"])
		hookTip(_G["ShoppingTooltip3"])
	end
end
