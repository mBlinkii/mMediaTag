local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

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
		E.db.mMT.dockdatatext.normal.r,
		E.db.mMT.dockdatatext.normal.g,
		E.db.mMT.dockdatatext.normal.b,
		E.db.mMT.dockdatatext.normal.a


	if self.mSettings.CustomColor then
		Nr = self.mSettings.IconColor.r
		Ng = self.mSettings.IconColor.g
		Nb = self.mSettings.IconColor.b
		Na = self.mSettings.IconColor.a
	elseif E.db.mMT.dockdatatext.normal.style == "class" then
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
	local XY = E.db.mMT.dockdatatext.nottification.size
	local r, g, b, a =
		E.db.mMT.dockdatatext.nottification.r,
		E.db.mMT.dockdatatext.nottification.g,
		E.db.mMT.dockdatatext.nottification.b,
		E.db.mMT.dockdatatext.nottification.a

	if E.db.mMT.dockdatatext.nottification.style == "class" then
		r, g, b, a = class[1], class[2], class[3], E.db.mMT.dockdatatext.nottification.a
	end

	if not self.mNotifications then
		self.mNotifications = self:CreateTexture(nil, "ARTWORK")
	end

	self.mNotifications:SetTexture(E.db.mMT.dockdatatext.nottification.icon)
	self.mNotifications:ClearAllPoints()
	self.mNotifications:Point("TOPLEFT", self.mIcon, "TOPLEFT", 2, 2)
	self.mNotifications:Size(XY, XY)
	self.mNotifications:SetVertexColor(r, g, b, a)
	self.mNotifications:Hide()
end

local function mDockCreatText(self)
	local FontSize = 12
	if E.db.mMT.dockdatatext.customfontzise then
		FontSize = E.db.mMT.dockdatatext.fontSize
	else
		FontSize = self.XY / 3
	end

	if not self.mIcon.TextA then
		self.mIcon.TextA = self:CreateFontString(nil, 'ARTWORK')
	end
	self.mIcon.TextA:FontTemplate(LSM:Fetch("font", E.db.mMT.dockdatatext.font), FontSize, E.db.mMT.dockdatatext.fontflag)
	self.mIcon.TextA:ClearAllPoints()
	self.mIcon.TextA:SetShadowColor(0, 0, 0, 0)
	self.mIcon.TextA.SetShadowColor = function() end

	if not self.mIcon.TextB then
		self.mIcon.TextB = self:CreateFontString(nil, 'ARTWORK')
	end
	self.mIcon.TextB:FontTemplate(LSM:Fetch("font", E.db.mMT.dockdatatext.font), FontSize, E.db.mMT.dockdatatext.fontflag)
	self.mIcon.TextB:ClearAllPoints()
	self.mIcon.TextB:SetShadowColor(0, 0, 0, 0)
	self.mIcon.TextB.SetShadowColor = function() end

	if self.mSettings.Spezial then
		self.mIcon.TextB:SetPoint("TOP", self.mIcon, "TOP", 0, 0)
		if self.mSettings.Center then
			self.mIcon.TextA:SetPoint("CENTER", self.mIcon, "CENTER", 0, 0)
		else
			self.mIcon.TextA:SetPoint("BOTTOM", self.mIcon, "BOTTOM", 0, 0)
		end
		self.mIcon.TextA:SetJustifyH('CENTER')
		self.mIcon.TextA:SetWordWrap(true)
		self.mIcon.TextB:SetJustifyH('CENTER')
		self.mIcon.TextB:SetWordWrap(true)
	else
		self.mIcon.TextA:SetPoint("BOTTOMRIGHT", self.mIcon, "BOTTOMRIGHT", 0, 0)
		self.mIcon.TextB:SetPoint("BOTTOMLEFT", self.mIcon, "BOTTOMLEFT", 0, 0)
		self.mIcon.TextA:SetJustifyH('RIGHT')
		self.mIcon.TextA:SetWordWrap(true)
		self.mIcon.TextB:SetJustifyH('LEFT')
		self.mIcon.TextB:SetWordWrap(true)
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
			E.db.mMT.dockdatatext.click.r,
			E.db.mMT.dockdatatext.click.g,
			E.db.mMT.dockdatatext.click.b,
			E.db.mMT.dockdatatext.click.a

		if E.db.mMT.dockdatatext.click.style == "class" then
			Cr, Cg, Cb = class[1], class[2], class[3]
		end

		mDock:SetVertexColor(Cr, Cg, Cb, Ca)

		if not self.mIcon.isStarted and timer then
			self.CheckTimer = mMT:ScheduleRepeatingTimer(timer, 2, self)
			self.mIcon.isStarted = true
		end
	else
		local Hr, Hg, Hb, Ha =
			E.db.mMT.dockdatatext.hover.r,
			E.db.mMT.dockdatatext.hover.g,
			E.db.mMT.dockdatatext.hover.b,
			E.db.mMT.dockdatatext.hover.a

		if E.db.mMT.dockdatatext.hover.style == "class" then
			Hr, Hg, Hb = class[1], class[2], class[3]
		end
		mDock:SetVertexColor(Hr, Hg, Hb,  Ha)
	end

	mDock.isHover = true
end

function mMT:ShowHideNotification(self, show, timer)
	if show then
		self.mNotifications:Show()
		if E.db.mMT.dockdatatext.nottification.flash then
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
		if E.db.mMT.dockdatatext.nottification.flash then
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
		if E.db.mMT.dockdatatext.nottification.flash then
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
			E.db.mMT.dockdatatext.click.r,
			E.db.mMT.dockdatatext.click.g,
			E.db.mMT.dockdatatext.click.b,
			E.db.mMT.dockdatatext.click.a

		if E.db.mMT.dockdatatext.click.style == "class" then
			Cr, Cg, Cb = class[1], class[2], class[3]
		end

		mDock:SetVertexColor(Cr, Cg, Cb, Ca)
	else
		local Nr, Ng, Nb, Na =
			E.db.mMT.dockdatatext.normal.r,
			E.db.mMT.dockdatatext.normal.g,
			E.db.mMT.dockdatatext.normal.b,
			E.db.mMT.dockdatatext.normal.a

		if self.mSettings.CustomColor then
			Nr = self.mSettings.IconColor.r
			Ng = self.mSettings.IconColor.g
			Nb = self.mSettings.IconColor.b
			Na = self.mSettings.IconColor.a
		elseif E.db.mMT.dockdatatext.normal.style == "class" then
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
				E.db.mMT.dockdatatext.hover.r,
				E.db.mMT.dockdatatext.hover.g,
				E.db.mMT.dockdatatext.hover.b,
				E.db.mMT.dockdatatext.hover.a

			if E.db.mMT.dockdatatext.hover.style == "class" then
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
			E.db.mMT.dockdatatext.click.r,
			E.db.mMT.dockdatatext.click.g,
			E.db.mMT.dockdatatext.click.b,
			E.db.mMT.dockdatatext.click.a

		if E.db.mMT.dockdatatext.click.style == "class" then
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
			E.db.mMT.dockdatatext.click.r,
			E.db.mMT.dockdatatext.click.g,
			E.db.mMT.dockdatatext.click.b,
			E.db.mMT.dockdatatext.click.a

		if E.db.mMT.dockdatatext.click.style == "class" then
			Cr, Cg, Cb = class[1], class[2], class[3]
		end

		mDock:SetVertexColor(Cr, Cg, Cb, Ca)
	else
		local Nr, Ng, Nb, Na =
			E.db.mMT.dockdatatext.normal.r,
			E.db.mMT.dockdatatext.normal.g,
			E.db.mMT.dockdatatext.normal.b,
			E.db.mMT.dockdatatext.normal.a

		if self.mSettings.CustomColor then
			Nr = self.mSettings.IconColor.r
			Ng = self.mSettings.IconColor.g
			Nb = self.mSettings.IconColor.b
			Na = self.mSettings.IconColor.a
		elseif E.db.mMT.dockdatatext.normal.style == "class" then
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
		E.db.mMT.dockdatatext.normal.r,
		E.db.mMT.dockdatatext.normal.g,
		E.db.mMT.dockdatatext.normal.b,
		E.db.mMT.dockdatatext.normal.a
		
	if self.mSettings.CustomColor then
		Nr = self.mSettings.IconColor.r
		Ng = self.mSettings.IconColor.g
		Nb = self.mSettings.IconColor.b
		Na = self.mSettings.IconColor.a
	elseif E.db.mMT.dockdatatext.normal.style == "class" then
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
	if E.db.mMT.dockdatatext.autogrow then
		self.GrowXY = self.XY / 2 + self.XY
	else
		self.GrowXY = E.db.mMT.dockdatatext.growsize + self.XY
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
