local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("Dock")
local InCombatLockdown = InCombatLockdown
local LSM = E.Libs.LSM
local colors = MEDIA.color.dock

local function SetupDockIcon(datatext, config)
	-- Determine icon size
	local isVertical = datatext.db and datatext.db.growth == "VERTICAL"
	local baseSize = isVertical and datatext:GetWidth() or datatext:GetHeight()
	local size = baseSize + 4

	-- Initialize Dock table
	datatext.mMT_Dock = datatext.mMT_Dock or {}
	local dock = datatext.mMT_Dock
	dock.size = size

	-- Create or update icon texture
	if not dock.Icon then
		dock.Icon = datatext:CreateTexture(nil, "ARTWORK")
		dock.Icon:ClearAllPoints()
		dock.Icon:Point("CENTER")
	end

	dock.Icon:Size(size, size)
	dock.Icon:SetTexture(config.icon.texture)

	local color = config.icon.color or module.db.class.normal and MEDIA.myclass or colors.normal
	dock.color = color
	dock.Icon:SetVertexColor(color.r, color.g, color.b, color.a or 1)
end

local function SetupLabel(text, size, anchor, point, justify)
	-- configure label
	local db = module.db.font
	text.SetShadowColor = function() end
	text:FontTemplate(LSM:Fetch("font", db.font), db.custom_font_size and db.fontSize or size / 3, db.fontFlag)
	text:ClearAllPoints()
	text:SetPoint(point, anchor, point, 0, 0)
	text:SetJustifyH(justify)
	text:SetWordWrap(true)

	local color = db.custom_font_color and colors.font or MEDIA.myclass
	text:SetTextColor(color.r, color.g, color.b, 1)
end

local function DeleteLabel(text)
	-- delete label
	text:SetText("")
	text = nil
end

local function SetupDockText(datatext, config)
	local dock = datatext.mMT_Dock
	local textConfig = config.text

	local icon = dock.Icon
	local center = textConfig.center or module.db.center

	local function SetupText(labelKey, anchorPoint, justifyH)
		dock[labelKey] = dock[labelKey] or datatext:CreateFontString(nil, "ARTWORK")
		SetupLabel(dock[labelKey], dock.size, icon, anchorPoint, justifyH)
	end

	if textConfig.a then
		local point = center and "BOTTOM" or "BOTTOMRIGHT"
		local justify = center and "CENTER" or "RIGHT"
		SetupText("TextA", point, justify)
	elseif dock.TextA then
		DeleteLabel(dock.TextA)
	end

	if textConfig.b then
		local point = center and "TOP" or "BOTTOMLEFT"
		local justify = center and "CENTER" or "LEFT"
		SetupText("TextB", point, justify)
	elseif dock.TextB then
		DeleteLabel(dock.TextB)
	end
end

local function SetupDockNotification(datatext, config)
	local dock = datatext.mMT_Dock
	local db = module.db.notification

	if not config.icon.notification then
		if dock.Notification then
			dock.Notification:Hide()
			dock.Notification = nil
		end
		return
	end

	-- initialize notification icon if not available
	if not dock.Notification then
		dock.Notification = datatext:CreateTexture(nil, "ARTWORK")
		dock.Notification:ClearAllPoints()
		dock.Notification:Point("CENTER", dock.Icon, "TOPLEFT", 0, 0)
		dock.Notification:SetDrawLayer("OVERLAY", 0)
	end

	-- calculate size and set properties
	local size = db.auto and ((datatext:GetHeight() + 4) / 4) or db.size
	local color = module.db.class.notification and MEDIA.myclass or colors.notification
	dock.Notification:Size(size, size)
	dock.Notification:SetTexture(db.icon)
	dock.Notification.SetVertexColor(color.r, color.g, color.b, color.a or 1)
	dock.Notification:Hide()
end

local function SetupDockSecureButton(datatext, conf)
	local dock = datatext.mMT_Dock
	local secureConf = conf.misc

	if not dock.SecureBtn then
		dock.SecureBtn = CreateFrame("Button", "mMT_Dock_SecureButton", datatext, "SecureActionButtonTemplate")
		dock.SecureBtn.__owner = datatext

		if secureConf.macroA or secureConf.macroB then
			--dock.SecureBtn:SetAttribute("type*", "macro")
			dock.SecureBtn:SetAttribute("type1", "macro") -- Linksklick
			--dock.SecureBtn:SetAttribute("spell1", "Feuerball")

			dock.SecureBtn:SetAttribute("type2", "macro") -- Rechtsklick
			--dock.SecureBtn:SetAttribute("macrotext2", "/s Hallo Welt")
		end
		--dock.SecureBtn:RegisterForClicks("AnyUp", "AnyDown")
		dock.SecureBtn:RegisterForClicks("LeftButtonDown", "RightButtonDown")
	end

	dock.SecureBtn:Height(dock.size)
	dock.SecureBtn:Width(dock.size)
	dock.SecureBtn:Point("CENTER")

	if secureConf.macroA or secureConf.macroB then
		dock.SecureBtn:SetAttribute("macrotext1", secureConf.macroA)
		dock.SecureBtn:SetAttribute("macrotext2", secureConf.macroB or secureConf.macroA)
	end

	if secureConf.funcOnEnter then dock.SecureBtn:SetScript("OnEnter", secureConf.funcOnEnter) end
	if secureConf.funcOnLeave then dock.SecureBtn:SetScript("OnLeave", secureConf.funcOnLeave) end
	if secureConf.funcOnClick then dock.SecureBtn:SetScript("OnClick", secureConf.funcOnClick) end
	dock.SecureBtn:Show()
end

function module:Click(datatext)
	local icon = datatext.mMT_Dock.Icon
	local color = module.db.class.clicked and MEDIA.myclass or colors.clicked
	icon:SetVertexColor(color.r, color.g, color.b, color.a or 1)
end

function module:OnEnter(datatext)
	local icon = datatext.mMT_Dock.Icon
	local size = datatext.mMT_Dock.size
	local color = module.db.class.hover and MEDIA.myclass or colors.hover
	local growSize = module.db.auto_grow and (size * 1.5) or (module.db.grow_size + size)

	icon:Size(growSize, growSize)
	icon:SetVertexColor(color.r, color.g, color.b, color.a or 1)

	E:UIFrameFadeOut(icon, 0.25, icon:GetAlpha(), 1)

	-- fade texts out
	if datatext.mMT_Dock.TextA then E:UIFrameFadeOut(datatext.mMT_Dock.TextA, 0.25, 1, 0) end
	if datatext.mMT_Dock.TextB then E:UIFrameFadeOut(datatext.mMT_Dock.TextB, 0.25, 1, 0) end
end

function module:OnLeave(datatext)
	local icon = datatext.mMT_Dock.Icon
	local color = datatext.mMT_Dock.color
	local size = datatext.mMT_Dock.size

	icon:Size(size, size)
	icon:SetVertexColor(color.r, color.g, color.b, color.a or 1)
	E:UIFrameFadeIn(icon, 0.25, icon:GetAlpha(), 1)

	-- fade texts in
	if datatext.mMT_Dock.TextA then E:UIFrameFadeIn(datatext.mMT_Dock.TextA, 0.75, 0, 1) end
	if datatext.mMT_Dock.TextB then E:UIFrameFadeIn(datatext.mMT_Dock.TextB, 0.75, 0, 1) end
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
-- 		funcOnClick = nil,
-- 	},
-- }

function module:CreateDockIcon(datatext, config)
	if not config or not datatext then return end
	module.db = E.db.mMT.dock

	datatext.text:SetText("")

	SetupDockIcon(datatext, config)

	if config.text and config.text.enable then
		SetupDockText(datatext, config)
	elseif datatext.mMT_Dock then
		if datatext.mMT_Dock.TextA then DeleteLabel(datatext.mMT_Dock.TextA) end
		if datatext.mMT_Dock.TextB then DeleteLabel(datatext.mMT_Dock.TextB) end
	end

	if config.icon and config.icon.notification then SetupDockNotification(datatext, config) end

	if not InCombatLockdown() then
		if config.misc and config.misc.secure then
			SetupDockSecureButton(datatext, config)
		elseif datatext.mMT_Dock and datatext.mMT_Dock.SecureBtn then
			datatext.mMT_Dock.SecureBtn:Hide()
			datatext.mMT_Dock.SecureBtn:SetScript("OnEnter", nil)
			datatext.mMT_Dock.SecureBtn:SetScript("OnLeave", nil)
			datatext.mMT_Dock.SecureBtn:SetScript("OnClick", nil)
			datatext.mMT_Dock.SecureBtn:SetParent(nil)
			datatext.mMT_Dock.SecureBtn:ClearAllPoints()
			datatext.mMT_Dock.SecureBtn = nil
		end
	end
end
