local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("ImportantCasts", { "AceHook-3.0" })

local IsSpellImportant = C_Spell and C_Spell.IsSpellImportant

local EDGE_FILE = [[Interface\BUTTONS\WHITE8X8]]
local backdropInfo = { edgeFile = EDGE_FILE, edgeSize = 2 }

local function GetOrCreateBorder(castbar)
    if castbar.TUI_ImportantBorder then return castbar.TUI_ImportantBorder end

    local border = CreateFrame('Frame', nil, castbar, 'BackdropTemplate')
    border:SetFrameLevel(castbar:GetFrameLevel() + 5)
    border:Hide()

    castbar.TUI_ImportantBorder = border
    return border
end

local function ApplyBorderStyle(border, castbar)
    local db = TUI.db.profile.nameplates.importantCast
    local thickness = db.thickness or 2

    border:ClearAllPoints()
    border:SetPoint('TOPLEFT', castbar, -thickness, thickness)
    border:SetPoint('BOTTOMRIGHT', castbar, thickness, -thickness)

    backdropInfo.edgeSize = thickness
    border:SetBackdrop(backdropInfo)

    local r, g, b, a
    if db.classColor then
        local c = E:ClassColor(E.myclass)
        r, g, b, a = c.r, c.g, c.b, db.color.a
    else
        r, g, b, a = db.color.r, db.color.g, db.color.b, db.color.a
    end
    border:SetBackdropBorderColor(r, g, b, a)
end

local function ShowImportantBorder(castbar)
    local border = GetOrCreateBorder(castbar)
    ApplyBorderStyle(border, castbar)
    border:Show()
end

local function HideImportantBorder(castbar)
    local border = castbar.TUI_ImportantBorder
    if border and border:IsShown() then border:Hide() end
end

local function CheckImportant(castbar)
    local spellID = castbar.spellID
    if not spellID then
        HideImportantBorder(castbar)
        return
    end

    -- IsSpellImportant may return a ConditionalSecret boolean; pass to SetAlphaFromBoolean if secret
    local isImportant = IsSpellImportant(spellID)
    if  E:IsSecretValue(isImportant) then
        -- Secret boolean — show the border and let alpha handle visibility
        local border = GetOrCreateBorder(castbar)
        ApplyBorderStyle(border, castbar)
        border:Show()
        border:SetAlphaFromBoolean(isImportant, 1, 0)
    elseif isImportant then
        ShowImportantBorder(castbar)
    else
        HideImportantBorder(castbar)
    end
end

function TUI:HookImportantCast()
    if self._hookedImportantCast then return end
    self._hookedImportantCast = true

    if not IsSpellImportant then return end

    hooksecurefunc(NP, 'Castbar_PostCastStart', function(castbar)
        if not castbar then return end
        CheckImportant(castbar)
    end)

    hooksecurefunc(NP, 'Castbar_PostCastStop', function(castbar)
        HideImportantBorder(castbar)
    end)

    hooksecurefunc(NP, 'Castbar_PostCastFail', function(castbar)
        HideImportantBorder(castbar)
    end)

    hooksecurefunc(NP, 'Castbar_PostCastInterrupted', function(castbar)
        HideImportantBorder(castbar)
    end)
end

function module:Initialize()
    if not E.db.mMediaTag.important_casts.enable then return end

end
