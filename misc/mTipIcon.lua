local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...

--WoW API / Variables
local _G = _G
local GetItemIcon = GetItemIcon
local GetSpellInfo = GetSpellInfo

local function AddToolTipIconItem(tooltip, data)
	if data and tooltip then
		local icon = GetItemIcon(data.id)
		local title = data.lines and data.lines[1] and data.lines[1].leftText or _G[tooltip:GetName() .. "TextLeft1"]
		if icon and title then
			_G[tooltip:GetName() .. "TextLeft1"]:SetFormattedText("|T%s:%d|t %s", icon, E.db[mPlugin].mTIconSize, title)
		end
	end
end

local function AddToolTipIconSpell(tooltip, data)
	if data and tooltip then
		local icon = GetSpellTexture(data.id)
		local title = data.lines and data.lines[1] and data.lines[1].leftText or _G[tooltip:GetName() .. "TextLeft1"]
		if icon and title then
			_G[tooltip:GetName() .. "TextLeft1"]:SetFormattedText("|T%s:%d|t %s", icon, E.db[mPlugin].mTIconSize, title)
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
			if icon then
				AddTooltipIcon(self, icon)
			end
		end)

		tip:HookScript("OnTooltipSetSpell", function(self, ...)
			if self:GetSpell() then
				local _, spellID = self:GetSpell()
				local _, _, icon = GetSpellInfo(spellID)
				if icon then
					AddTooltipIcon(self, icon)
				end
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
