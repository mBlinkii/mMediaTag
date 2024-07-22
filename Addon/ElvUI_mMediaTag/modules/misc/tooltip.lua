local E = unpack(ElvUI)

--WoW API / Variables
local _G = _G
local GetItemIcon = C_Item and C_Item.GetItemIconByID or GetItemIcon
local GetSpellInfo = C_Spell and C_Spell.GetSpellInfo or GetSpellInfo
local GetSpellTexture = C_Spell and C_Spell.GetSpellTexture or GetSpellTexture

--|TTexturePath:size1:size2:xoffset:yoffset:dimx:dimy:coordx1:coordx2:coordy1:coordy2|t
local function SetTooltipIcon(tooltip, icon, title)
	if icon then
		if E.db.mMT.tooltip.iconzoom then
			icon = format("|T%s:%d:%d:0:0:64:64:4:60:4:60|t", icon, E.db.mMT.tooltip.iconsize, E.db.mMT.tooltip.iconsize)
		else
			icon = format("|T%s:%d|t", icon, E.db.mMT.tooltip.iconsize)
		end

		if title and not strfind(title, "|T") then
			_G[tooltip:GetName() .. "TextLeft1"]:SetFormattedText("%s %s", icon, title)
		end
	end
end

local function AddToolTipIconMount(tooltip, data)
	if data and tooltip then
		local icon = select(3, C_MountJournal.GetMountInfoByID(data.id))
		SetTooltipIcon(tooltip, icon, _G[tooltip:GetName() .. "TextLeft1"]:GetText() or data.lines and data.lines[2] and data.lines[2].leftText)
	end
end

local function AddToolTipIconItem(tooltip, data)
	if data and tooltip then
		SetTooltipIcon(tooltip, GetItemIcon(data.id), _G[tooltip:GetName() .. "TextLeft1"]:GetText() or data.lines and data.lines[1] and data.lines[1].leftText)
	end
end

local function AddToolTipIconSpell(tooltip, data)
	if data and tooltip then
		SetTooltipIcon(tooltip, GetSpellTexture(data.id), _G[tooltip:GetName() .. "TextLeft1"]:GetText() or data.lines and data.lines[1] and data.lines[1].leftText)
	end
end

local function AddToolTipIconMacro(tooltip, data)
	if data and tooltip then
		local name = _G[tooltip:GetName() .. "TextLeft1"]:GetText()
		if name then
			local icon = select(2, GetMacroInfo(name)) or GetSpellTexture(name) or GetItemIcon(name)
			SetTooltipIcon(tooltip, icon, _G[tooltip:GetName() .. "TextLeft1"]:GetText() or data.lines and data.lines[1] and data.lines[1].leftText)
		end
	end
end

local function AddTooltipIcon(self, icon)
	if icon then
		local title = _G[self:GetName() .. "TextLeft1"]
		if title and not title:GetText():find("|T" .. icon) then
			if E.db.mMT.tooltip.iconzoom then
				title:SetFormattedText("|T%s:%d:%d:0:0:64:64:4:60:4:60|t %s", icon, E.db.mMT.tooltip.iconsize, E.db.mMT.tooltip.iconsize, title:GetText())
			else
				title:SetFormattedText("|T%s:%d|t %s", icon, E.db.mMT.tooltip.iconsize, title:GetText())
			end
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

function mMT:TipIcon()
	if E.Retail then
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, AddToolTipIconItem)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, AddToolTipIconSpell)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Toy, AddToolTipIconItem)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Mount, AddToolTipIconMount)
		TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Macro, AddToolTipIconMacro)
	else
		hookTip(_G["GameTooltip"])
		hookTip(_G["ItemRefTooltip"])
		hookTip(_G["ShoppingTooltip1"])
		hookTip(_G["ShoppingTooltip2"])
		hookTip(_G["ShoppingTooltip3"])
	end
end
