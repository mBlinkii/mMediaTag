local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local DT = E:GetModule("DataTexts");
local addon, ns = ...

--Lua functions
local format = format

--Variables
local stream = { Name = _G.MASTER, Volume = 'Sound_MasterVolume', Enabled = 'Sound_EnableAllSound' }
local mText = format("Dock %s", L["Volume"])
local mTextName = "mVolume"

local function mTip()
	if E.db[mPlugin].mDock.tip.enable then
        local _, _, _, _, _, _, tip = mMT:mColorDatatext()
        local VolumeInfo = mMT:VolumeToolTip()
        DT.tooltip:ClearLines()
        DT.tooltip:AddDoubleLine(VolumeInfo.name, VolumeInfo.level)
        DT.tooltip:AddLine(" ")
        DT.tooltip:AddLine(format("%s %s%s|r", ns.MiddleButtonIcon, tip, L["Change volume with the mouse wheel"]))
		DT.tooltip:Show()
	end
end

local function OnMouseWheel(self, delta)
	mMT:SetVolume(delta)
    mTip()
    if E.db[mPlugin].mDock.volume.showtext then
        local VolumeInfo = mMT:VolumeToolTip()
        self.mIcon.TextA:SetFormattedText(mMT:mClassColorString(), VolumeInfo.level)
    end
end

local function OnEnter(self)
	mTip()
    mMT:mOnEnter(self)
end

local function OnEvent(self, event, ...)
	self.mSettings = {
		Name = mTextName,
		IconTexture = E.db[mPlugin].mDock.volume.path,
		Notifications = false,
		Text = E.db[mPlugin].mDock.volume.showtext,
		Spezial = E.db[mPlugin].mDock.volume.showtext,
	}

    local level = GetCVar(stream.Volume) * 100
    
    if level == 0 or GetCVarBool(stream.Enabled) == false then
        self.mSettings.IconTexture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\system44.tga"
    end

	mMT:DockInitialisation(self)
    local VolumeInfo = mMT:VolumeToolTip()
    if E.db[mPlugin].mDock.volume.showtext then
     self.mIcon.TextA:SetFormattedText(mMT:mClassColorString(), VolumeInfo.level)
    end
    self:EnableMouseWheel(true)
	self:SetScript('OnMouseWheel', OnMouseWheel)
end

local function OnLeave(self)
	if E.db[mPlugin].mDock.tip.enable then
		DT.tooltip:Hide()
	end
    mMT:mOnLeave(self)
end

local function OnClick(self)
	if mMT:CheckCombatLockdown() then
        local color = GetCVarBool(stream.Enabled) and GetCVarBool(stream.Enabled) and '00FF00' or 'FF3333'
        local level = GetCVar(stream.Volume) * 100
    
        if level == 0 or GetCVarBool(stream.Enabled) == false then
            self.mSettings.IconTexture = E.db[mPlugin].mDock.volume.path
        else
            self.mSettings.IconTexture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\system44.tga"
        end

        mMT:DockInitialisation(self)
        mMT:MuteVolume()

        if E.db[mPlugin].mDock.volume.showtext then
            local VolumeInfo = mMT:VolumeToolTip()
            self.mIcon.TextA:SetFormattedText(mMT:mClassColorString(), VolumeInfo.level)
        end
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, OnClick, OnEnter, OnLeave, mText, nil, nil)