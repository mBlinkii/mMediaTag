local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format
local strjoin = strjoin

--WoW API / Variables
local _G = _G
local InCombatLockdown = InCombatLockdown

--Variables
local LSM = E.Libs.LSM
local _, unitClass = UnitClass("player")
local class = ElvUF.colors.class[unitClass]

function mMT:CheckCombatLockdown()
	if InCombatLockdown() then
		return false
	else
		return true
	end
end

function mMT:mClassColorString()
	return strjoin("", E:RGBToHex(class[1], class[2], class[3]), "%s|r")
end

local function mDockCreatIcon(self)
	local Nr, Ng, Nb, Na =
		E.db[mPlugin].mDock.normal.r,
		E.db[mPlugin].mDock.normal.g,
		E.db[mPlugin].mDock.normal.b,
		E.db[mPlugin].mDock.normal.a


	if self.mSettings.CustomColor then
		Nr = self.mSettings.IconColor.r
		Ng = self.mSettings.IconColor.g
		Nb = self.mSettings.IconColor.b
		Na = self.mSettings.IconColor.a
	elseif E.db[mPlugin].mDock.normal.style == "class" then
		Nr, Ng, Nb = class[1], class[2], class[3]
	end

	if not self.mIcon then
		self.mIcon = self:CreateTexture(nil, "ARTWORK")
	end

	if self.mSettings.OnlyText then
		self.mIcon:SetTexture(nil)
	else
		self.mIcon:SetTexture(self.mSettings.IconTexture)
	end

	self.mIcon:ClearAllPoints()
	self.mIcon:Point("CENTER")
	self.mIcon:Size(self.XY, self.XY)
	self.mIcon:SetVertexColor(Nr, Ng, Nb, Na)
end

local function mDockCreatmNotifications(self)
	local XY = E.db[mPlugin].mDock.nottification.size
	local r, g, b, a =
		E.db[mPlugin].mDock.nottification.r,
		E.db[mPlugin].mDock.nottification.g,
		E.db[mPlugin].mDock.nottification.b,
		E.db[mPlugin].mDock.nottification.a

	if E.db[mPlugin].mDock.nottification.style == "class" then
		r, g, b, a = class[1], class[2], class[3], E.db[mPlugin].mDock.nottification.a
	end

	if not self.mNotifications then
		self.mNotifications = self:CreateTexture(nil, "ARTWORK")
	end

	self.mNotifications:SetTexture(E.db[mPlugin].mDock.nottification.path)
	self.mNotifications:ClearAllPoints()
	self.mNotifications:Point("TOPLEFT", self.mIcon, "TOPLEFT", 2, 2)
	self.mNotifications:Size(XY, XY)
	self.mNotifications:SetVertexColor(r, g, b, a)
	self.mNotifications:Hide()
end

local function mDockCreatText(self)
	local FontSize = 12
	if E.db[mPlugin].mDock.customfontzise then
		FontSize = E.db[mPlugin].mDock.fontSize
	else
		FontSize = self.XY / 3
	end

	if not self.mIcon.TextA then
		self.mIcon.TextA = self:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	end
	self.mIcon.TextA:SetFont(LSM:Fetch("font", E.db[mPlugin].mDock.font), FontSize, E.db[mPlugin].mDock.fontflag)
	self.mIcon.TextA:ClearAllPoints()

	if not self.mIcon.TextB then
		self.mIcon.TextB = self:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	end
	self.mIcon.TextB:SetFont(LSM:Fetch("font", E.db[mPlugin].mDock.font), FontSize, E.db[mPlugin].mDock.fontflag)
	self.mIcon.TextB:ClearAllPoints()

	if self.mSettings.Spezial then
		self.mIcon.TextB:SetPoint("TOP", self.mIcon, "TOP", 0, 0)
		if self.mSettings.Center then
			self.mIcon.TextA:SetPoint("CENTER", self.mIcon, "CENTER", 0, 0)
		else
			self.mIcon.TextA:SetPoint("BOTTOM", self.mIcon, "BOTTOM", 0, 0)
		end
	else
		self.mIcon.TextA:SetPoint("BOTTOMRIGHT", self.mIcon, "BOTTOMRIGHT", 0, 0)
		self.mIcon.TextB:SetPoint("BOTTOMLEFT", self.mIcon, "BOTTOMLEFT", 0, 0)
	end

	if not self.mSettings.DontClearText then
		self.mIcon.TextA:SetText("")
		self.mIcon.TextB:SetText("")
	end
end

function mMT:mOnEnter(self, timer)
	local mDock = self.mIcon
	mDock:Size(self.GrowXY, self.GrowXY)

	if self.mSettings.Text and mMT:CheckCombatLockdown() then
		if self.mIcon.TextA then
			E:UIFrameFadeOut(self.mIcon.TextA, 0.25, 1, 0)
		end

		if self.mIcon.TextB then
			E:UIFrameFadeOut(self.mIcon.TextB, 0.25, 1, 0)
		end
		self.isFaded = true
	end

	if mDock.isClicked then
		local Cr, Cg, Cb, Ca =
			E.db[mPlugin].mDock.click.r,
			E.db[mPlugin].mDock.click.g,
			E.db[mPlugin].mDock.click.b,
			E.db[mPlugin].mDock.click.a

		if E.db[mPlugin].mDock.click.style == "class" then
			Cr, Cg, Cb = class[1], class[2], class[3]
		end

		mDock:SetVertexColor(Cr, Cg, Cb, Ca)

		if not self.mIcon.isStarted and timer then
			self.CheckTimer = mMT:ScheduleRepeatingTimer(timer, 2, self)
			self.mIcon.isStarted = true
		end
	else
		local Hr, Hg, Hb, Ha =
			E.db[mPlugin].mDock.hover.r,
			E.db[mPlugin].mDock.hover.g,
			E.db[mPlugin].mDock.hover.b,
			E.db[mPlugin].mDock.hover.a

		if E.db[mPlugin].mDock.hover.style == "class" then
			Hr, Hg, Hb = class[1], class[2], class[3]
		end
		mDock:SetVertexColor(Hr, Hg, Hb,  Ha)
	end

	mDock.isHover = true
end

function mMT:ShowHideNotification(self, show, timer)
	if show then
		self.mNotifications:Show()
		if E.db[mPlugin].mDock.nottification.flash then
			E:Flash(self.mNotifications, 0.5, true)
		end
		if timer then
			if not self.mIcon.NotificationTimerisStarted then
				self.NotificationTimer = mMT:ScheduleRepeatingTimer(timer, 5, self)
			end
			self.mIcon.NotificationTimerisStarted = true
		end
	else
		self.mNotifications:Hide()
		if E.db[mPlugin].mDock.nottification.flash then
			E:StopFlash(self.mNotifications)
		end
		if timer then
			mMT:CancelTimer(self.NotificationTimer)
			self.mIcon.NotificationTimerisStarted = false
		end
	end
end

function mMT:NotificationTimer(self, option)
	if option then
		self.mNotifications:Hide()
		if E.db[mPlugin].mDock.nottification.flash then
			E:StopFlash(self.mNotifications)
		end
		mMT:CancelTimer(self.NotificationTimer)
		self.mIcon.NotificationTimerisStarted = false
	end
end

function mMT:mOnLeave(self)
	local mDock = self.mIcon
	mDock:Size(self.XY, self.XY)

	if self.mSettings.Text and self.isFaded then
		if self.mIcon.TextA then
			E:UIFrameFadeIn(self.mIcon.TextA, 0.75, 0, 1)
		end

		if self.mIcon.TextB then
			E:UIFrameFadeIn(self.mIcon.TextB, 0.75, 0, 1)
		end
		self.isFaded = false
	end

	if mDock.isClicked then
		local Cr, Cg, Cb, Ca =
			E.db[mPlugin].mDock.click.r,
			E.db[mPlugin].mDock.click.g,
			E.db[mPlugin].mDock.click.b,
			E.db[mPlugin].mDock.click.a

		if E.db[mPlugin].mDock.click.style == "class" then
			Cr, Cg, Cb = class[1], class[2], class[3]
		end

		mDock:SetVertexColor(Cr, Cg, Cb, Ca)
	else
		local Nr, Ng, Nb, Na =
			E.db[mPlugin].mDock.normal.r,
			E.db[mPlugin].mDock.normal.g,
			E.db[mPlugin].mDock.normal.b,
			E.db[mPlugin].mDock.normal.a

		if self.mSettings.CustomColor then
			Nr = self.mSettings.IconColor.r
			Ng = self.mSettings.IconColor.g
			Nb = self.mSettings.IconColor.b
			Na = self.mSettings.IconColor.a
		elseif E.db[mPlugin].mDock.normal.style == "class" then
			Nr, Ng, Nb = class[1], class[2], class[3]
		end

		mDock:SetVertexColor(Nr, Ng, Nb, Na)
	end

	mDock.isHover = false
end

function mMT:mOnClick(self, timer)
	local mDock = self.mIcon
	if mDock.isClicked then
		if mDock.isHover then
			local Hr, Hg, Hb, Ha =
				E.db[mPlugin].mDock.hover.r,
				E.db[mPlugin].mDock.hover.g,
				E.db[mPlugin].mDock.hover.b,
				E.db[mPlugin].mDock.hover.a

			if E.db[mPlugin].mDock.hover.style == "class" then
				Hr, Hg, Hb = class[1], class[2], class[3]
			end
			mDock:SetVertexColor(Hr, Hg, Hb, Ha)
		end
		mDock.isClicked = false
		if timer then
			mMT:CancelTimer(self.CheckTimer)
			self.mIcon.isStarted = false
		end
	else
		local Cr, Cg, Cb, Ca =
			E.db[mPlugin].mDock.click.r,
			E.db[mPlugin].mDock.click.g,
			E.db[mPlugin].mDock.click.b,
			E.db[mPlugin].mDock.click.a

		if E.db[mPlugin].mDock.click.style == "class" then
			Cr, Cg, Cb = class[1], class[2], class[3]
		end

		mDock.isClicked = true
		mDock:SetVertexColor(Cr, Cg, Cb, Ca)
		if timer then
			if not self.mIcon.isStarted then
				self.CheckTimer = mMT:ScheduleRepeatingTimer(timer, 2, self)
			end
			self.mIcon.isStarted = true
		end
	end
end

function mMT:DockTimer(self)
	local mDock = self.mIcon

	if mDock.isClicked then
		local Cr, Cg, Cb, Ca =
			E.db[mPlugin].mDock.click.r,
			E.db[mPlugin].mDock.click.g,
			E.db[mPlugin].mDock.click.b,
			E.db[mPlugin].mDock.click.a

		if E.db[mPlugin].mDock.click.style == "class" then
			Cr, Cg, Cb = class[1], class[2], class[3]
		end

		mDock:SetVertexColor(Cr, Cg, Cb, Ca)
	else
		local Nr, Ng, Nb, Na =
			E.db[mPlugin].mDock.normal.r,
			E.db[mPlugin].mDock.normal.g,
			E.db[mPlugin].mDock.normal.b,
			E.db[mPlugin].mDock.normal.a

		if self.mSettings.CustomColor then
			Nr = self.mSettings.IconColor.r
			Ng = self.mSettings.IconColor.g
			Nb = self.mSettings.IconColor.b
			Na = self.mSettings.IconColor.a
		elseif E.db[mPlugin].mDock.normal.style == "class" then
			Nr, Ng, Nb = class[1], class[2], class[3]
		end

		mDock:SetVertexColor(Nr, Ng, Nb, Na)
		mMT:CancelTimer(self.CheckTimer)
		mDock.isClicked = false
		self.mIcon.isStarted = false
	end
end

function mMT:DockNormalColor(self)
	local Nr, Ng, Nb, Na =
		E.db[mPlugin].mDock.normal.r,
		E.db[mPlugin].mDock.normal.g,
		E.db[mPlugin].mDock.normal.b,
		E.db[mPlugin].mDock.normal.a
		
	if self.mSettings.CustomColor then
		Nr = self.mSettings.IconColor.r
		Ng = self.mSettings.IconColor.g
		Nb = self.mSettings.IconColor.b
		Na = self.mSettings.IconColor.a
	elseif E.db[mPlugin].mDock.normal.style == "class" then
		Nr, Ng, Nb = class[1], class[2], class[3]
	end
	self.mIcon:SetVertexColor(Nr, Ng, Nb, Na)
end

function mMT:DockCustomColor(self, r, g, b, a)
	self.mIcon:SetVertexColor(r, g, b, a)
end

function mMT:DockInitialisation(self)
	if self.mIcon then
		if self.mIcon.TextA and self.mIcon.TextB and not self.mSettings.DontClearText then
			self.mIcon.TextA:SetText("")
			self.mIcon.TextB:SetText("")
		end

		if self.mNotifications and not self.mSettings.Notifications then
			self.mNotifications:Hide()
		end
	end

	self.XY = self:GetHeight() + 4
	if E.db[mPlugin].mDock.autogrow then
		self.GrowXY = self.XY / 2 + self.XY
	else
		self.GrowXY = E.db[mPlugin].mDock.growsize + self.XY
	end

	mDockCreatIcon(self)

	if self.mSettings.Notifications then
		mDockCreatmNotifications(self)
	end

	if self.mSettings.Text then
		mDockCreatText(self)
	end

	self.mDockLoaded = true
	self.CheckIcon = self.mSettings.Name
end
