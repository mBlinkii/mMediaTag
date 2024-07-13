local E = unpack(ElvUI)

--Lua functions
local LSM = E.Libs.LSM

--Variables
local Defaults = {
	autogrow = true,
	click = { r = 0.2, g = 0.2, b = 0.2, a = 1 },
	customfontcolor = false,
	customfontzise = false,
	center = false,
	font = LSM:Fetch("font", "PT Sans Narrow"),
	fontSize = 12,
	fontcolor = { r = 1, g = 1, b = 1, hex = "|cffffffff" },
	fontflag = "OUTLINE",
	growsize = 8,
	hover = { r = 0.5, g = 0.5, b = 0.5, a = 0.75 },
	normal = { r = 1, g = 1, b = 1, a = 1 },
	tip = true,
	nfcolor = { r = 0, g = 1, b = 0, a = 0.75 },
	nfflash = true,
	nficon = mMT.Media.DockIcons["FILLED27"],
	nfsize = 16,
	nfauto = true,
	update = false,
}

function mMT:CheckCombatLockdown()
	if InCombatLockdown() then
		return false
	else
		return true
	end
end
function mMT:UpdateDockSettings()
	-- update settings
	Defaults.autogrow = E.db.mMT.dockdatatext.autogrow
	Defaults.customfontcolor = E.db.mMT.dockdatatext.customfontcolor
	Defaults.customfontzise = E.db.mMT.dockdatatext.customfontzise
	Defaults.center = E.db.mMT.dockdatatext.center
	Defaults.font = LSM:Fetch("font", E.db.mMT.dockdatatext.font)
	Defaults.fontSize = E.db.mMT.dockdatatext.fontSize
	Defaults.fontcolor = E.db.mMT.dockdatatext.fontcolor
	Defaults.fontflag = E.db.mMT.dockdatatext.fontflag
	Defaults.growsize = E.db.mMT.dockdatatext.growsize
	Defaults.tip = E.db.mMT.dockdatatext.tip.enable
	Defaults.nfflash = E.db.mMT.dockdatatext.notification.flash
	Defaults.nficon = mMT.Media.DockIcons[E.db.mMT.dockdatatext.notification.icon]
	Defaults.nfsize = E.db.mMT.dockdatatext.notification.size
	Defaults.nfauto = E.db.mMT.dockdatatext.notification.auto

	-- configure colors
	if E.db.mMT.dockdatatext.hover.style == "custom" then
		Defaults.hover = {
			r = E.db.mMT.dockdatatext.hover.r,
			g = E.db.mMT.dockdatatext.hover.g,
			b = E.db.mMT.dockdatatext.hover.b,
			a = E.db.mMT.dockdatatext.hover.a,
		}
	else
		Defaults.hover = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
	end

	if E.db.mMT.dockdatatext.click.style == "custom" then
		Defaults.click = {
			r = E.db.mMT.dockdatatext.click.r,
			g = E.db.mMT.dockdatatext.click.g,
			b = E.db.mMT.dockdatatext.click.b,
			a = E.db.mMT.dockdatatext.click.a,
		}
	else
		Defaults.click = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
	end

	if E.db.mMT.dockdatatext.normal.style == "custom" then
		Defaults.normal = {
			r = E.db.mMT.dockdatatext.normal.r,
			g = E.db.mMT.dockdatatext.normal.g,
			b = E.db.mMT.dockdatatext.normal.b,
			a = E.db.mMT.dockdatatext.normal.a,
		}
	else
		Defaults.normal = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
	end

	if E.db.mMT.dockdatatext.notification.style == "custom" then
		Defaults.nfcolor = {
			r = E.db.mMT.dockdatatext.notification.r,
			g = E.db.mMT.dockdatatext.notification.g,
			b = E.db.mMT.dockdatatext.notification.b,
			a = E.db.mMT.dockdatatext.notification.a,
		}
	else
		Defaults.nfcolor = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b }
	end

	-- safe update state for first time update
	Defaults.update = true
end

function mMT:SetTextureColor(icon, color)
	icon:SetVertexColor(color.r, color.g, color.b, color.a or 1)
end

local function SetupLabel(text, size, anchor, point, justify)
	-- configure label
	text.SetShadowColor = function() end
	text:FontTemplate(Defaults.font, Defaults.customfontzise and Defaults.fontSize or size / 3, Defaults.fontflag)
	text:ClearAllPoints()
	text:SetPoint(point, anchor, point, 0, 0)
	text:SetJustifyH(justify)
	text:SetWordWrap(true)

	local color = Defaults.customfontcolor and Defaults.fontcolor or { r = 1, g = 1, b = 1 }
	text:SetTextColor(color.r, color.g, color.b, 1)
end

local function DeleteLabel(text)
	-- delete label
	text:SetText("")
	text = nil
end

function mMT:UpdateNotificationState(DT, show)
	-- stop if notification does not exist
	if not DT.mMT_Dock.Notification then
		return
	end

	-- show/ flash and hide notification
	if show then
		DT.mMT_Dock.Notification:Show()

		if Defaults.nfflash then
			E:Flash(DT.mMT_Dock.Notification, 0.5, true)
			DT.mMT_Dock.Notification.flash = true
		end
	else
		DT.mMT_Dock.Notification:Hide()

		if DT.mMT_Dock.Notification.flash then
			E:StopFlash(DT.mMT_Dock.Notification)
		end
	end
end

function mMT:Dock_Click(DT, conf)
	mMT:SetTextureColor(DT.mMT_Dock.Icon, Defaults.click)
end

function mMT:Dock_OnEnter(DT, conf)
	DT.mMT_Dock.Icon:Size(DT.mMT_Dock.grow, DT.mMT_Dock.grow)
	mMT:SetTextureColor(DT.mMT_Dock.Icon, Defaults.hover)

	E:UIFrameFadeOut(DT.mMT_Dock.Icon, 0.25, DT.mMT_Dock.Icon:GetAlpha(), 1)

	-- fade texts out
	if DT.mMT_Dock.TextA then
		E:UIFrameFadeOut(DT.mMT_Dock.TextA, 0.25, 1, 0)
	end

	if DT.mMT_Dock.TextB then
		E:UIFrameFadeOut(DT.mMT_Dock.TextB, 0.25, 1, 0)
	end
end

function mMT:Dock_OnLeave(DT, conf)
	DT.mMT_Dock.Icon:Size(DT.mMT_Dock.size, DT.mMT_Dock.size)
	mMT:SetTextureColor(DT.mMT_Dock.Icon, conf.icon.color or Defaults.normal)
	E:UIFrameFadeIn(DT.mMT_Dock.Icon, 0.25, DT.mMT_Dock.Icon:GetAlpha(), 1)
	-- fade texts in
	if DT.mMT_Dock.TextA then
		E:UIFrameFadeIn(DT.mMT_Dock.TextA, 0.75, 0, 1)
	end

	if DT.mMT_Dock.TextB then
		E:UIFrameFadeIn(DT.mMT_Dock.TextB, 0.75, 0, 1)
	end
end


--** DOCK Config Table
-- local Config = {
-- 	name = "DEVICON",
-- 	localizedName = "Dock" .. "DEV ICON",
-- 	text = {
-- 		enable = true,
-- 		center = true,
-- 		a = true, -- first label
-- 		b = true, -- second label
-- 	},
-- 	icon = {
-- 		notification = true,
-- 		texture = mMT.IconSquare,
-- 		color = { r = 1, g = 1, b = 1, a = 1 },
-- 	},
-- 	misc = {
-- 		secure = true,
-- 		macroA = "/click EJMicroButton",
-- 		macroB = "/click SpellbookMicroButton",
-- 		funcOnEnter = nil,
-- 		funcOnLeave = nil,
-- 	},
-- }

function mMT:InitializeDockIcon(DT, conf, event)
	if not conf then
		return
	end

	-- first time update settings
	if not Defaults.update then
		mMT:UpdateDockSettings()
	end

	-- delete datatext text
	DT.text:SetText("")

	-- create mDock table
	if not DT.mMT_Dock then
		DT.mMT_Dock = {}
	end

	-- set defaults
	DT.mMT_Dock.size = ((DT.db and DT.db.growth == "VERTICAL") and DT:GetWidth() or DT:GetHeight()) + 4
	DT.mMT_Dock.grow = Defaults.autogrow and (DT.mMT_Dock.size / 2 + DT.mMT_Dock.size) or Defaults.growsize + DT.mMT_Dock.size

	-- create texture
	if not DT.mMT_Dock.Icon then
		DT.mMT_Dock.Icon = DT:CreateTexture(nil, "ARTWORK")
		DT.mMT_Dock.Icon:ClearAllPoints()
		DT.mMT_Dock.Icon:Point("CENTER")
	end

	-- setup icon
	DT.mMT_Dock.Icon:Size(DT.mMT_Dock.size, DT.mMT_Dock.size)
	DT.mMT_Dock.Icon:SetTexture(conf.icon.texture, "CLAMP", "CLAMP", "TRILINEAR")
	mMT:SetTextureColor(DT.mMT_Dock.Icon, conf.icon.color or Defaults.normal)

	-- create texts
	if conf.text and conf.text.enable then
		local point, justify = "CENTER", "CENTER"

		-- text a
		if conf.text.a then
			if not DT.mMT_Dock.TextA then
				DT.mMT_Dock.TextA = DT:CreateFontString(nil, "ARTWORK")
			end
			point = (conf.text.center or Defaults.center) and "BOTTOM" or "BOTTOMRIGHT"
			justify = conf.text.center and "CENTER" or "RIGHT"
			SetupLabel(DT.mMT_Dock.TextA, DT.mMT_Dock.size, DT.mMT_Dock.Icon or DT.mMT_Dock.macroBtn.Icon, point, justify)
		elseif DT.mMT_Dock.TextA then
			DeleteLabel(DT.mMT_Dock.TextA)
		end

		-- text b
		if conf.text.b then
			if not DT.mMT_Dock.TextB then
				DT.mMT_Dock.TextB = DT:CreateFontString(nil, "ARTWORK")
			end
			point = conf.text.center and "TOP" or "BOTTOMLEFT"
			justify = conf.text.center and "CENTER" or "LEFT"
			SetupLabel(DT.mMT_Dock.TextB, DT.mMT_Dock.size, DT.mMT_Dock.Icon or DT.mMT_Dock.macroBtn.Icon, point, justify)
		elseif DT.mMT_Dock.TextB then
			DeleteLabel(DT.mMT_Dock.TextB)
		end
	else
		-- delete texts
		if DT.mMT_Dock.TextA then
			DeleteLabel(DT.mMT_Dock.TextA)
		end

		if DT.mMT_Dock.TextB then
			DeleteLabel(DT.mMT_Dock.TextB)
		end
	end

	-- create notification
	if conf.icon.notification then
		-- create texture
		if not DT.mMT_Dock.Notification then
			DT.mMT_Dock.Notification = DT:CreateTexture(nil, "ARTWORK")
			DT.mMT_Dock.Notification:ClearAllPoints()
			DT.mMT_Dock.Notification:Point("CENTER", DT.mMT_Dock.Icon, "TOPLEFT", 0, 0)
			DT.mMT_Dock.Notification:SetDrawLayer("OVERLAY", 0)
		end

		-- setup icon
		local size = Defaults.nfauto and ((DT:GetHeight() + 4) / 4) or Defaults.nfsize
		DT.mMT_Dock.Notification:Size(size, size)
		DT.mMT_Dock.Notification:SetTexture(Defaults.nficon, "CLAMP", "CLAMP", "TRILINEAR")
		mMT:SetTextureColor(DT.mMT_Dock.Notification, Defaults.nfcolor)
		DT.mMT_Dock.Notification:Hide()
	elseif DT.mMT_Dock.Notification then
		DT.mMT_Dock.Notification:Hide()
		DT.mMT_Dock.Notification = nil
	end

	-- create secure button
	if conf.misc and conf.misc.secure then
		-- create macro Button
		if not DT.mMT_Dock.macroBtn then
			DT.mMT_Dock.macroBtn = CreateFrame("Button", "mMT_Dock_MacroBtn", DT, "SecureActionButtonTemplate")
			DT.mMT_Dock.macroBtn:SetAttribute("type*", "macro") -- click causes macro
			DT.mMT_Dock.macroBtn:RegisterForClicks("LeftButtonDown", "RightButtonDown")
		end

		-- configure button
		DT.mMT_Dock.macroBtn:Height(DT.mMT_Dock.size)
		DT.mMT_Dock.macroBtn:Width(DT.mMT_Dock.size)
		DT.mMT_Dock.macroBtn:Point("CENTER")

		-- set macro actions
		DT.mMT_Dock.macroBtn:SetAttribute("macrotext1", conf.misc.macroA) -- text for macro on left click
		DT.mMT_Dock.macroBtn:SetAttribute("macrotext2", conf.misc.macroB or conf.misc.macroA) -- text for macro on right click

		-- set enter and leave functions
		DT.mMT_Dock.macroBtn:SetScript("OnEnter", conf.misc.funcOnEnter or nil)
		DT.mMT_Dock.macroBtn:SetScript("OnLeave", conf.misc.funcOnLeave or nil)

		-- show button
		DT.mMT_Dock.macroBtn:Show()
	elseif DT.mMT_Dock.macroBtn then
		-- delete macro button
		DT.mMT_Dock.macroBtn:Hide()
		DT.mMT_Dock.macroBtn:SetScript("OnEnter", nil)
		DT.mMT_Dock.macroBtn:SetScript("OnLeave", nil)
		DT.mMT_Dock.macroBtn = nil
	end
end
