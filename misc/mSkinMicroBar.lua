local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...

--Lua functions
local mInsert = tinsert
local AB = E:GetModule("ActionBars")
local texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\MicroBar.tga"

function HandleMicroTextures(elv, button, name)
    if not E.db[mPlugin].mMicroBarSkin.enable and not E.db.actionbar.microbar.enable then return end

	local normal = button:GetNormalTexture()
	local pushed = button:GetPushedTexture()

	normal:SetTexture(texture)
	pushed:SetTexture(texture)

	normal:SetInside(button.backdrop)
	pushed:SetInside(button.backdrop)

	local color = E.media.rgbvaluecolor
	if color then
		pushed:SetVertexColor(color.r * 1.5, color.g * 1.5, color.b * 1.5)
	end

	local highlight = button:GetHighlightTexture()
	highlight:SetColorTexture(1, 1, 1, 0.2)

	local disabled = button:GetDisabledTexture()
	if disabled then
		disabled:SetTexture(texture)
		disabled:SetDesaturated(true)
		disabled:SetInside(button.backdrop)
	end

	if button.FlashBorder then
		button.FlashBorder:SetInside(button.backdrop)

		button.FlashBorder:SetColorTexture(1, 1, 1, 0.2)
	end

	if button.FlashContent then
		button.FlashContent:SetTexture()
	end

	if button.Flash then
		button.Flash:SetTexture()
	end
end

function mMT:SetupMicroBarSkin()
	local mbs = E.db[mPlugin].mMicroBarSkin.skin

	if mbs == 1 or mbs == 2 then
		if mbs == 1 then
			E.db.actionbar.microbar.useIcons = true
		else
			E.db.actionbar.microbar.useIcons = false
		end
		texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\MicroBar.tga"
	else
		if mbs == 3 then
			E.db.actionbar.microbar.useIcons = true
		else
			E.db.actionbar.microbar.useIcons = false
		end
		texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\MicroBar2.tga"
	end

	hooksecurefunc(AB, "HandleMicroTextures", HandleMicroTextures)
	AB:UpdateMicroBarTextures()
end

local function mSkinMacroBarOptions()
	E.Options.args.mMediaTag.args.cosmetic.args.microbarskin.args = {
		microbarskintoggle = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable the Microbar Skins"],
			get = function(info)
				return E.db[mPlugin].mMicroBarSkin.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mMicroBarSkin.enable = value
				if value then
					mMT:SetupMicroBarSkin()
				end
				AB:UpdateMicroBarTextures()
			end,
		},
		spacer = {
			order = 11,
			type = "description",
			name = "\n\n",
		},
		skins = {
			order = 12,
			type = "select",
			name = L["Skin"],
			disabled = function()
				return not E.db[mPlugin].mMicroBarSkin.enable
			end,
			get = function(info)
				return E.db[mPlugin].mMicroBarSkin.skin
			end,
			set = function(info, value)
				E.db[mPlugin].mMicroBarSkin.skin = value

				if value == 1 or value == 2 then
					if value == 1 then
						E.db.actionbar.microbar.useIcons = true
					else
						E.db.actionbar.microbar.useIcons = false
					end
					texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\MicroBar.tga"
				else
                    if value == 3 then
                        E.db.actionbar.microbar.useIcons = true
                    else
                        E.db.actionbar.microbar.useIcons = false
                    end
					texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\MicroBar2.tga"
				end

				AB:UpdateMicroBarTextures()
			end,
			values = {
				[1] = "Skin 1",
				[2] = "Skin 2",
				[3] = "Skin 3",
				[4] = "Skin 4",
			},
		},
	}
end

mInsert(ns.Config, mSkinMacroBarOptions)
