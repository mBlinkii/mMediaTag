local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local NP = E:GetModule("NamePlates")
local addon, ns = ...

--Lua functions
local format = format
local mInsert = table.insert

--Variables
local _, unitClass = UnitClass("player")
local class = ElvUF.colors.class[unitClass]
local ColorTitel = "|cffffc800"

local function mRoll()
	local mColorNormal = {
		r = E.db[mPlugin].mRoll.colornormal.r,
		g = E.db[mPlugin].mRoll.colornormal.g,
		b = E.db[mPlugin].mRoll.colornormal.b,
		a = E.db[mPlugin].mRoll.colornormal.a,
	}
	local mColorHover = {
		r = E.db[mPlugin].mRoll.colorhover.r,
		g = E.db[mPlugin].mRoll.colorhover.g,
		b = E.db[mPlugin].mRoll.colorhover.b,
		a = E.db[mPlugin].mRoll.colorhover.a,
	}
	local mSize = E.db[mPlugin].mRoll.size

	if E.db[mPlugin].mRoll.colormodenormal == "class" then
		mColorNormal = { r = class[1], g = class[2], b = class[3], a = E.db[mPlugin].mRoll.colornormal.a }
	end

	if E.db[mPlugin].mRoll.colormodehover == "class" then
		mColorHover = { r = class[1], g = class[2], b = class[3], a = E.db[mPlugin].mRoll.colorhover.a }
	end

	local mRollFrame = CreateFrame("Button", "mMediaTagRoll", E.UIParent, "BackdropTemplate")
	mRollFrame:Point("CENTER")
	mRollFrame:Size(mSize, mSize)
	mRollFrame:RegisterForClicks("AnyDown")
	mRollFrame:SetScript("OnClick", function(self)
		RandomRoll(1, 100)
	end)
	mRollFrame:SetScript("OnEnter", function(self)
		mRollFrame.Texture:SetVertexColor(mColorHover.r, mColorHover.g, mColorHover.b, mColorHover.a)
		_G.GameTooltip:SetOwner(mRollFrame, "ANCHOR_RIGHT")
		_G.GameTooltip:AddLine(format("%s%s|r", ColorTitel, L["Click to roll 1-100"]))
		_G.GameTooltip:Show()
	end)
	mRollFrame:SetScript("OnLeave", function(self)
		mRollFrame.Texture:SetVertexColor(mColorNormal.r, mColorNormal.g, mColorNormal.b, mColorNormal.a)
		_G.GameTooltip:Hide()
	end)

	mRollFrame.Texture = mRollFrame:CreateTexture(nil, "ARTWORK")
	mRollFrame.Texture:Size(mSize, mSize)
	mRollFrame.Texture:ClearAllPoints()
	mRollFrame.Texture:Point("CENTER")
	mRollFrame.Texture:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\roll.tga")
	mRollFrame.Texture:SetVertexColor(mColorNormal.r, mColorNormal.g, mColorNormal.b, mColorNormal.a)

	E:CreateMover(
		mRollFrame,
		"mMediaTagRollMover",
		"mMediaTagRoll",
		nil,
		nil,
		nil,
		"ALL",
		nil,
		"mMediaTag,general,tools,mroll",
		nil
	)
end

local function mRollOptions()
	E.Options.args.mMediaTag.args.general.args.tools.args.mroll.args = {
		enable = {
			order = 10,
			type = "toggle",
			name = L["Enable Roll Icon"],
			get = function(info)
				return E.db[mPlugin].mRoll.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mRoll.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		growsize = {
			order = 20,
			name = L["Icon Size"],
			type = "range",
			min = 2,
			max = 128,
			step = 2,
			softMin = 2,
			softMax = 128,
			get = function(info)
				return E.db[mPlugin].mRoll.size
			end,
			set = function(info, value)
				E.db[mPlugin].mRoll.size = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return not E.db[mPlugin].mRoll.enable
			end,
		},
		colornormalmode = {
			order = 30,
			type = "select",
			name = L["Color Style"],
			get = function(info)
				return E.db[mPlugin].mRoll.colormodenormal
			end,
			set = function(info, value)
				E.db[mPlugin].mRoll.colormodenormal = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return not E.db[mPlugin].mRoll.enable
			end,
			values = {
				class = L["class"],
				custom = L["custom"],
			},
		},
		colornormal = {
			type = "color",
			order = 31,
			name = L["Custom Color"],
			hasAlpha = true,
			get = function(info)
				local t = E.db[mPlugin].mRoll.colornormal
				return t.r, t.g, t.b, t.a
			end,
			set = function(info, r, g, b, a)
				local t = E.db[mPlugin].mRoll.colornormal
				t.r, t.g, t.b, t.a = r, g, b, a
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return E.db[mPlugin].mRoll.colormodenormal == "class"
			end,
		},
		colorhoverlmode = {
			order = 40,
			type = "select",
			name = L["Hover Color Style"],
			get = function(info)
				return E.db[mPlugin].mRoll.colormodehover
			end,
			set = function(info, value)
				E.db[mPlugin].mRoll.colormodehover = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return not E.db[mPlugin].mRoll.enable
			end,
			values = {
				class = L["class"],
				custom = L["custom"],
			},
		},
		colorhover = {
			type = "color",
			order = 41,
			name = L["Hover Custom Color"],
			hasAlpha = true,
			get = function(info)
				local t = E.db[mPlugin].mRoll.colorhover
				return t.r, t.g, t.b, t.a
			end,
			set = function(info, r, g, b, a)
				local t = E.db[mPlugin].mRoll.colorhover
				t.r, t.g, t.b, t.a = r, g, b, a
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return E.db[mPlugin].mRoll.colormodehover == "class"
			end,
		},
	}
end

local function mChattMenuUpdate()
	_G.ChatMenu:ClearAllPoints()
	_G.ChatMenu:Point("BOTTOMLEFT", "mMediaTagChatMenu", "TOPLEFT", 0, 0)
end

local function mChatMenu()
	local mColorNormal = {
		r = E.db[mPlugin].mChatMenu.colornormal.r,
		g = E.db[mPlugin].mChatMenu.colornormal.g,
		b = E.db[mPlugin].mChatMenu.colornormal.b,
		a = E.db[mPlugin].mChatMenu.colornormal.a,
	}
	local mColorHover = {
		r = E.db[mPlugin].mChatMenu.colorhover.r,
		g = E.db[mPlugin].mChatMenu.colorhover.g,
		b = E.db[mPlugin].mChatMenu.colorhover.b,
		a = E.db[mPlugin].mChatMenu.colorhover.a,
	}
	local mSize = E.db[mPlugin].mChatMenu.size

	if E.db[mPlugin].mChatMenu.colormodenormal == "class" then
		mColorNormal = { r = class[1], g = class[2], b = class[3], a = E.db[mPlugin].mChatMenu.colornormal.a }
	end

	if E.db[mPlugin].mChatMenu.colormodehover == "class" then
		mColorHover = { r = class[1], g = class[2], b = class[3], a = E.db[mPlugin].mChatMenu.colorhover.a }
	end

	local mChatMenuFrame = CreateFrame("Button", "mMediaTagChatMenu", E.UIParent, "BackdropTemplate")
	mChatMenuFrame:Point("CENTER")
	mChatMenuFrame:Size(mSize, mSize)
	mChatMenuFrame:RegisterForClicks("AnyDown")
	mChatMenuFrame:SetScript("OnClick", function(self)
		_G.ChatMenu:SetShown(not _G.ChatMenu:IsShown())
	end)
	mChatMenuFrame:SetScript("OnEnter", function(self)
		mChatMenuFrame.Texture:SetVertexColor(mColorHover.r, mColorHover.g, mColorHover.b, mColorHover.a)
		_G.GameTooltip:SetOwner(mChatMenuFrame, "ANCHOR_RIGHT")
		_G.GameTooltip:AddLine(format("%s%s|r", ColorTitel, L["Chat Menu"]))
		_G.GameTooltip:Show()
	end)
	mChatMenuFrame:SetScript("OnLeave", function(self)
		mChatMenuFrame.Texture:SetVertexColor(mColorNormal.r, mColorNormal.g, mColorNormal.b, mColorNormal.a)
		_G.GameTooltip:Hide()
	end)

	mChatMenuFrame.Texture = mChatMenuFrame:CreateTexture(nil, "ARTWORK")
	mChatMenuFrame.Texture:Size(mSize, mSize)
	mChatMenuFrame.Texture:ClearAllPoints()
	mChatMenuFrame.Texture:Point("CENTER")
	mChatMenuFrame.Texture:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\chat.tga")
	mChatMenuFrame.Texture:SetVertexColor(mColorNormal.r, mColorNormal.g, mColorNormal.b, mColorNormal.a)

	E:CreateMover(
		mChatMenuFrame,
		"mMediaTagChatMenuMover",
		"mMediaTagChatMenu",
		nil,
		nil,
		nil,
		"ALL",
		nil,
		"mMediaTag,general,tools,mchatmenu",
		nil
	)
end

local function mChatMenuOptions()
	E.Options.args.mMediaTag.args.general.args.tools.args.mchatmenu.args = {
		enable = {
			order = 10,
			type = "toggle",
			name = L["Enable Chatmenu Icon"],
			get = function(info)
				return E.db[mPlugin].mChatMenu.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mChatMenu.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		growsize = {
			order = 20,
			name = L["Icon Size"],
			type = "range",
			min = 2,
			max = 128,
			step = 2,
			softMin = 2,
			softMax = 128,
			get = function(info)
				return E.db[mPlugin].mChatMenu.size
			end,
			set = function(info, value)
				E.db[mPlugin].mChatMenu.size = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return not E.db[mPlugin].mChatMenu.enable
			end,
		},
		colornormalmode = {
			order = 30,
			type = "select",
			name = L["Color Style"],
			get = function(info)
				return E.db[mPlugin].mChatMenu.colormodenormal
			end,
			set = function(info, value)
				E.db[mPlugin].mChatMenu.colormodenormal = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return not E.db[mPlugin].mChatMenu.enable
			end,
			values = {
				class = L["Class"],
				custom = L["Custom"],
			},
		},
		colornormal = {
			type = "color",
			order = 31,
			name = L["Custom Color"],
			hasAlpha = true,
			get = function(info)
				local t = E.db[mPlugin].mChatMenu.colornormal
				return t.r, t.g, t.b, t.a
			end,
			set = function(info, r, g, b, a)
				local t = E.db[mPlugin].mChatMenu.colornormal
				t.r, t.g, t.b, t.a = r, g, b, a
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return E.db[mPlugin].mChatMenu.colormodenormal == "class"
			end,
		},
		colorhoverlmode = {
			order = 40,
			type = "select",
			name = L["Hover Color Style"],
			get = function(info)
				return E.db[mPlugin].mChatMenu.colormodehover
			end,
			set = function(info, value)
				E.db[mPlugin].mChatMenu.colormodehover = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return not E.db[mPlugin].mChatMenu.enable
			end,
			values = {
				class = L["Class"],
				custom = L["Custom"],
			},
		},
		colorhover = {
			type = "color",
			order = 41,
			name = L["Hover Custom Color"],
			hasAlpha = true,
			get = function(info)
				local t = E.db[mPlugin].mChatMenu.colorhover
				return t.r, t.g, t.b, t.a
			end,
			set = function(info, r, g, b, a)
				local t = E.db[mPlugin].mChatMenu.colorhover
				t.r, t.g, t.b, t.a = r, g, b, a
				E:StaticPopup_Show("CONFIG_RL")
			end,
			disabled = function()
				return E.db[mPlugin].mChatMenu.colormodehover == "class"
			end,
		},
	}
end

mInsert(ns.Config, mRollOptions)
mInsert(ns.Config, mChatMenuOptions)

local function mNamplate(self, nameplate)
	local frameName = nameplate:GetName()
	-- local debuffs = frameName..'Debuffs'
	nameplate[frameName .. "Debuffs"]:ClearAllPoints()
	nameplate[frameName .. "Debuffs"]:SetPoint("TOP", self, "TOP", 0, 0)
end

function mMT:mLoadTools()
	--hooksecurefunc(NP, "UpdatePlate", mNamplate)

	if E.db[mPlugin].mRoll.enable then
		mRoll()
	end

	if E.db[mPlugin].mChatMenu.enable then
		mChatMenu()
		_G.ChatMenu:HookScript("OnShow", mChattMenuUpdate)
	end
end
