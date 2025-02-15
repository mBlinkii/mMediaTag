local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local module = mMT:AddModule("DiceButton")

-- Cache WoW Globals
local CreateFrame = CreateFrame
local RandomRoll = RandomRoll
local format = format

local function GetColor(colorConfig)
	if colorConfig.mode == "class" then
		return { r = MEDIA.classColor.r, g = MEDIA.classColor.g, b = MEDIA.classColor.b, a = colorConfig.color.a }
	else
		return colorConfig.color
	end
end

local function Update()
	module.db = E.db.mMT.dice_button

	local normalColor = GetColor(module.db.color.normal)
	local hoverColor = GetColor(module.db.color.hover)

	module.dice_button.color = {
		normal = normalColor,
		hover = hoverColor,
	}

	module.dice_button:Size(module.db.size, module.db.size)
	module.dice_button.texture:SetTexture(MEDIA.icons.dice[module.db.texture])
	module.dice_button.texture:SetVertexColor(normalColor.r, normalColor.g, normalColor.b, normalColor.a)
end

function module:Initialize()
	if E.db.mMT.dice_button.enable then
		if not module.dice_button then
			module.db = E.db.mMT.dice_button
			module.dice_button = CreateFrame("Button", "mMediaTag_Dice_Button", E.UIParent, "BackdropTemplate")
			module.dice_button.texture = module.dice_button:CreateTexture(nil, "ARTWORK")

			module.dice_button:Point("CENTER")
			module.dice_button.texture:SetAllPoints(module.dice_button)

			module.dice_button:RegisterForClicks("AnyDown")

			-- on click
			module.dice_button:SetScript("OnClick", function(_, btn)
				if btn == "RightButton" then
					RandomRoll(1, module.db.dice_range_b)
				else
					RandomRoll(1, module.db.dice_range_a)
				end
			end)

			-- on enter
			module.dice_button:SetScript("OnEnter", function()
				local hoverColor = module.dice_button.color.hover
				module.dice_button.texture:SetVertexColor(hoverColor.r, hoverColor.g, hoverColor.b, hoverColor.a)
				_G.GameTooltip:SetOwner(module.dice_button, "ANCHOR_RIGHT")
				_G.GameTooltip:AddLine(format("|CFFFFC800%s|r", L["Roll Button"]))
				_G.GameTooltip:AddLine(" ")
				_G.GameTooltip:AddDoubleLine(format("|CFFFFC800%s|r", L["Left Click to roll"]), "|CFF4C9CDE1-" .. module.db.dice_range_a .. "|r")
				_G.GameTooltip:AddDoubleLine(format("|CFFFFC800%s|r", L["Right Click to roll"]), "|CFF4C9CDE1-" .. module.db.dice_range_b .. "|r")
				_G.GameTooltip:Show()
			end)

			-- on leave
			module.dice_button:SetScript("OnLeave", function()
				local normalColor = module.dice_button.color.normal
				module.dice_button.texture:SetVertexColor(normalColor.r, normalColor.g, normalColor.b, normalColor.a)
				_G.GameTooltip:Hide()
			end)

			E:CreateMover(module.dice_button, "mMediaTag_Dice_Button_Mover", "mMediaTag_Dice_Button", nil, nil, nil, "ALL,MMEDIATAG", nil, "mMT,misc,dice_button", nil)
		end

		Update()
		module.dice_button:Show()
	else
		if module.dice_button then module.dice_button:Hide() end
	end
end
