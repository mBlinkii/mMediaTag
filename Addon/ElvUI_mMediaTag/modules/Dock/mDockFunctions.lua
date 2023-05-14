local E = unpack(ElvUI)

--Lua functions
local format = format

--WoW API / Variables
local InCombatLockdown = InCombatLockdown

--Variables
local LSM = E.Libs.LSM
local FontSize = 12
local Font = LSM:Fetch("font", "PT Sans Narrow")

function mMT:CheckCombatLockdown()
	if InCombatLockdown() then
		return false
	else
		return true
	end
end

function mMT:mDockUpdateFont()
	FontSize = E.db.mMT.dockdatatext.fontSize
	Font = LSM:Fetch("font", E.db.mMT.dockdatatext.font)
end

local function mDockUpdateIcon(self)
	local Nr, Ng, Nb, Na =
		E.db.mMT.dockdatatext.normal.r,
		E.db.mMT.dockdatatext.normal.g,
		E.db.mMT.dockdatatext.normal.b,
		E.db.mMT.dockdatatext.normal.a

	if self.mSettings.icon.customcolor then
		Nr = self.mSettings.icon.color.r
		Ng = self.mSettings.icon.color.g
		Nb = self.mSettings.icon.color.b
		Na = self.mSettings.icon.color.a
	elseif E.db.mMT.dockdatatext.normal.style == "class" then
		Nr, Ng, Nb = mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b
	end

	self.mIcon:Size(self.mSettings.XY, self.mSettings.XY)
	self.mIcon:SetVertexColor(Nr, Ng, Nb, Na)

	if self.mSettings.text and self.mSettings.text.onlytext then
		self.mIcon:SetTexture(nil)
	else
		self.mIcon:SetTexture(self.mSettings.icon.texture)
	end
end

local function mDockCreatIcon(self)
	self.mIcon = self:CreateTexture(nil, "ARTWORK")
	self.mIcon:ClearAllPoints()
	self.mIcon:Point("CENTER")

	mDockUpdateIcon(self)
end

local function mDockUpdateNotifications(self)
	local XY = E.db.mMT.dockdatatext.notification.size
	local r, g, b, a =
		E.db.mMT.dockdatatext.notification.r,
		E.db.mMT.dockdatatext.notification.g,
		E.db.mMT.dockdatatext.notification.b,
		E.db.mMT.dockdatatext.notification.a

	if E.db.mMT.dockdatatext.notification.style == "class" then
		r, g, b, a = mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b, E.db.mMT.dockdatatext.notification.a
	end

	self.mNotifications:SetTexture(E.db.mMT.dockdatatext.notification.icon)
	self.mNotifications:Size(XY, XY)
	self.mNotifications:SetVertexColor(r, g, b, a)
	self.mNotifications:Hide()
end

local function mDockCreatmNotifications(self)
	self.mNotifications = self:CreateTexture(nil, "ARTWORK")
	self.mNotifications:ClearAllPoints()
	self.mNotifications:Point("TOPLEFT", self.mIcon, "TOPLEFT", 2, 2)

	mDockUpdateNotifications(self)
end

function mMT:mDockSetText(self, textA, textB, colorA, colorB)
	local textColorA = E.media.hexvaluecolor
	local textColorB = E.media.hexvaluecolor

	if E.db.mMT.dockdatatext.customfontcolor then
		if textA then
			textColorA = E.db.mMT.dockdatatext.fontcolor.hex
		end

		if textB then
			textColorA = E.db.mMT.dockdatatext.fontcolor.hex
		end
	else
		if textA and colorA then
			textColorA = colorA
		end

		if textB and colorB then
			textColorB = colorB
		end
	end

	if self.mIcon.TextA and textA then
		self.mIcon.TextA:SetText(format("%s%s|r", textColorA, textA))
	elseif self.mIcon.TextA then
		self.mIcon.TextA:SetText("")
	end

	if self.mIcon.TextB and textB then
		self.mIcon.TextB:SetText(format("%s%s|r", textColorB, textB))
	elseif self.mIcon.TextB then
		self.mIcon.TextB:SetText("")
	end
end

local function mDockUpdateText(self, A, B, textA, textB, colorA, colorB)
	if not E.db.mMT.dockdatatext.customfontzise then
		FontSize = self.mSettings.XY / 3
	end

	if A then
		self.mIcon.TextA:FontTemplate(Font, FontSize, E.db.mMT.dockdatatext.fontflag)
		self.mIcon.TextA:ClearAllPoints()
		self.mIcon.TextA:SetWordWrap(true)
	end

	if B then
		self.mIcon.TextB:FontTemplate(Font, FontSize, E.db.mMT.dockdatatext.fontflag)
		self.mIcon.TextB:ClearAllPoints()
		self.mIcon.TextB:SetWordWrap(true)
	end

	if self.mSettings.text.spezial then
		if A then
			self.mIcon.TextA:SetPoint("BOTTOM", self.mIcon, "BOTTOM", 0, 0)
			self.mIcon.TextA:SetJustifyH("CENTER")
		end

		if B then
			self.mIcon.TextB:SetPoint("TOP", self.mIcon, "TOP", 0, 0)
			self.mIcon.TextB:SetJustifyH("CENTER")
		end
	else
		if A then
			self.mIcon.TextA:SetPoint("BOTTOMRIGHT", self.mIcon, "BOTTOMRIGHT", 0, 0)
			self.mIcon.TextA:SetJustifyH("RIGHT")
		end

		if B then
			self.mIcon.TextB:SetPoint("BOTTOMLEFT", self.mIcon, "BOTTOMLEFT", 0, 0)
			self.mIcon.TextB:SetJustifyH("LEFT")
		end
	end

	mMT:mDockSetText(self, textA, textB, colorA, colorB)
end
local function mDockCreatText(self, A, B, textA, textB, colorA, colorB)
	if A and not self.mIcon.TextA then
		self.mIcon.TextA = self:CreateFontString(nil, "ARTWORK")
		self.mIcon.TextA.SetShadowColor = function() end
	end

	if B and not self.mIcon.TextB then
		self.mIcon.TextB = self:CreateFontString(nil, "ARTWORK")
		self.mIcon.TextB.SetShadowColor = function() end
	end

	mDockUpdateText(self, A, B, textA, textB, colorA, colorB)
end

function mMT:mOnEnter(self, timer)
	local mDock = self.mIcon
	mDock:Size(self.mSettings.GrowXY, self.mSettings.GrowXY)

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
		mDock:SetVertexColor(Hr, Hg, Hb, Ha)
	end

	mDock.isHover = true
end

function mMT:ShowHideNotification(self, show, timer)
	if show then
		self.mNotifications:Show()
		if E.db.mMT.dockdatatext.notification.flash then
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
		if E.db.mMT.dockdatatext.notification.flash then
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
		if E.db.mMT.dockdatatext.notification.flash then
			E:StopFlash(self.mNotifications)
		end
		mMT:CancelTimer(self.NotificationTimer)
		self.mIcon.NotificationTimerisStarted = false
	end
end

function mMT:mOnLeave(self)
	local mDock = self.mIcon
	mDock:Size(self.mSettings.XY, self.mSettings.XY)

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

-- ** Dock Settings
-- self.mSettings = {
-- 	Name = mTextName,
-- 	text = {
-- 		onlytext = false,
-- 		spezial = true,
-- 		textA = E.db.mMT.dockdatatext.bag.text ~= 5 and E.db.mMT.dockdatatext.bag.text or false,
-- 		textB = false,
-- 	},
-- 	icon = {
-- 		texture = mMT.Media.DockIcons[E.db.mMT.dockdatatext.bag.icon],
-- 		color = E.db.mMT.dockdatatext.bag.iconcolor,
-- 		customcolor = E.db.mMT.dockdatatext.bag.customcolor,
-- 	},
-- 	Notifications = false,
-- }

function mMT:DockInitialisation(self, event, textA, textB, colorA, colorB)
	self.mSettings.XY = self:GetHeight() + 4
	if E.db.mMT.dockdatatext.autogrow then
		self.mSettings.GrowXY = self.mSettings.XY / 2 + self.mSettings.XY
	else
		self.mSettings.GrowXY = E.db.mMT.dockdatatext.growsize + self.mSettings.XY
	end
	if event == "ELVUI_FORCE_UPDATE" then
		if not self.mIcon then
			mDockCreatIcon(self)

			if self.mSettings.Notifications and not self.mNotifications then
				mDockCreatmNotifications(self)
			end

			if
				self.mSettings.text
				and not self.mSettings.text.onlytext
				and (not self.mIcon.TextA or not self.mIcon.TextB)
			then
				mDockCreatText(self, self.mSettings.text.textA, self.mSettings.text.textB, textA, textB, colorA, colorB)
			else
				if self.mIcon.TextA then
					self.mIcon.TextA:SetText("")
				end

				if self.mIcon.TextB then
					self.mIcon.TextB:SetText("")
				end
			end
		else
			mDockUpdateIcon(self)

			if self.mSettings.Notifications and self.mNotifications then
				mDockUpdateNotifications(self)
			elseif self.mNotifications and not self.mSettings.Notifications then
				self.mNotifications:Hide()
				self.mNotifications = nil
			end

			if
				self.mSettings.text
				and not self.mSettings.text.onlytext
				and (not self.mIcon.TextA or not self.mIcon.TextB)
			then
				mDockCreatText(self, self.mSettings.text.textA, self.mSettings.text.textB, textA, textB, colorA, colorB)
			elseif
				self.mSettings.text
				and not self.mSettings.text.onlytext
				and (self.mIcon.TextA or self.mIcon.TextB)
			then

				mDockUpdateText(
					self,
					self.mSettings.text.textA,
					self.mSettings.text.textB,
					textA,
					textB,
					colorA,
					colorB
				)
			else
				if self.mIcon.TextA then
					self.mIcon.TextA:SetText("")
				end

				if self.mIcon.TextB then
					self.mIcon.TextB:SetText("")
				end
			end
		end
	end
end
