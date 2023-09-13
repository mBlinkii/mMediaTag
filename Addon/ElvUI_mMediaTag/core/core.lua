local E = unpack(ElvUI)
local strjoin = strjoin

-- AddonCompartment Functions
function ElvUI_mMediaTag_OnAddonCompartmentClick()
	E:ToggleOptions("mMT")
end

function ElvUI_mMediaTag_OnAddonCompartmentOnEnter()
	GameTooltip:ClearLines()
	GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR_RIGHT")
	GameTooltip:AddDoubleLine(mMT.Name, format("|CFFF7DC6FVer. %s|r", mMT.Version))
	GameTooltip:Show()
end

function ElvUI_mMediaTag_OnAddonCompartmentOnLeave()
	GameTooltip:Hide()
end

function mMT:UpdateClassColor()
	local class = E:ClassColor(E.myclass)
	local hex = E:RGBToHex(class.r, class.g, class.b)
	return { r = class.r, g = class.g, b = class.b, hex = hex, string = strjoin("", hex, "%s|r") }
end

function mMT:CheckEltruism()
    local isLoaded = IsAddOnLoaded("ElvUI_EltreumUI")
    if isLoaded then
    	return {
            loaded = IsAddOnLoaded("ElvUI_EltreumUI"),
            gradient = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and E.db.ElvUI_EltreumUI.unitframes.gradientmode and E.db.ElvUI_EltreumUI.unitframes.gradientmode.enable,
            dark = E.db.ElvUI_EltreumUI and E.db.ElvUI_EltreumUI.unitframes and E.db.ElvUI_EltreumUI.unitframes.darkmode,
        }
    else
        return {
            loaded = IsAddOnLoaded("ElvUI_EltreumUI"),
            gradient = false,
            dark = false,
        }
    end
end

function mMT:GetDevNames()
	return {
		["Blinkii"] = true,
		["Flinkii"] = true,
		["Raeldan"] = true,
	}
end
