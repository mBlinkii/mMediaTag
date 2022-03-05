local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local mSkin = E:GetModule("Skins")
local addon, ns = ...

--Lua functions
local format = format
local mInsert = table.insert

--Variables
local stream = { Name = _G.MASTER, Volume = 'Sound_MasterVolume', Enabled = 'Sound_EnableAllSound' }
local _, unitClass = UnitClass('player')
local class = ElvUF.colors.class[unitClass]
local statusbar = nil
local VolumeFrame = nil
local VolumeText = nil
local VolumeIcon = nil
local VolumeLevel = {}
local mVolume = GetCVar('Sound_MasterVolume') * 100
local VolumeTexture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\system43.tga"
local MuteTexture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\system44.tga"
local LevelTexture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\system45.tga"

function mMT:MuteVolume()
	SetCVar(stream.Enabled, GetCVarBool(stream.Enabled) and 0 or 1)
	mMT:mVolumeShow()
end

function mMT:VolumeToolTip()
	local color = GetCVarBool(stream.Enabled) and GetCVarBool(stream.Enabled) and '00FF00' or 'FF3333'
	local level = GetCVar(stream.Volume) * 100

	return {name = stream.Name, level = format('|cFF%s%.f%%|r', color, level)}
end

function mMT:SetVolume(delta)
	local vol = GetCVar('Sound_MasterVolume')
	local scale = 100

	if IsShiftKeyDown() then
		scale = 10
	end

	vol = vol + (delta / scale)

	if vol >= 1 then
		vol = 1
	elseif vol <= 0 then
		vol = 0
	end

	mMT:mVolumeShow()
	SetCVar('Sound_MasterVolume', vol)
end

function mMT:mVolumeCloseTimer(self)
	mMT:mVolumeHide()
end

function mMT:mVolumeHidesTimer(self)
	VolumeFrame:Hide()
end

function mMT:mVolumeShow()
    local color = GetCVarBool(stream.Enabled) and GetCVarBool(stream.Enabled) and '00FF00' or 'FF3333'
	local level = GetCVar(stream.Volume) * 100
	
    mMT:CancelTimer(VolumeFrame.CloseTimer)
	mMT:CancelTimer(VolumeFrame.CloseHide)

	if level == 0 or GetCVarBool(stream.Enabled) == false then
		VolumeIcon:SetVertexColor(1, 0, 0, 1)
		VolumeIcon:SetTexture(MuteTexture)
		for i=1, 20, 1 do
			VolumeLevel[i]:SetVertexColor(1, 0, 0, 1)
		end
	else
		VolumeIcon:SetVertexColor(class[1], class[2], class[3], 1)
		VolumeIcon:SetTexture(VolumeTexture)
		for i=1, 20, 1 do
			VolumeLevel[i]:SetVertexColor(class[1], class[2], class[3], 1)
		end
	end

	for i=1, 20, 1 do
		if ((level/5) <= 1 and (level/5) ~= 0) then
			VolumeLevel[1]:Show()
		elseif i <= (level/5) then
			VolumeLevel[i]:Show()
		else
			VolumeLevel[i]:Hide()
		end
	end

	VolumeText:SetText(format('|cFF%s%.f%%|r', color, level))
	VolumeFrame.CloseTimer = mMT:ScheduleTimer("mVolumeCloseTimer", 2, self)
	VolumeFrame:Show()
	VolumeFrame.bar:Show()
	VolumeText:Show()

	if VolumeFrame:GetAlpha() == 0 then
        E:UIFrameFadeIn(VolumeFrame, .25, 0, 1)
    end
end

function mMT:mVolumeHide()
    mMT:CancelTimer(VolumeFrame.CloseHide)
    VolumeFrame.CloseHide = mMT:ScheduleTimer("mVolumeHidesTimer", 2, self)
    E:UIFrameFadeOut(VolumeFrame, .25, 1, 0)
end

function mMT:mVolumeDisplay()
	local Font = GameFontHighlightSmall:GetFont()
	local color = GetCVarBool(stream.Enabled) and GetCVarBool(stream.Enabled) and '00FF00' or 'FF3333'
	local level = GetCVar(stream.Volume) * 100

	VolumeFrame = CreateFrame("Frame", "mMediaTagVolume", E.UIParent, nil)
	VolumeFrame:Point("CENTER")
	VolumeFrame:Size(444, 80)

	VolumeIcon = VolumeFrame:CreateTexture(nil, "ARTWORK")
	VolumeIcon:SetPoint("LEFT", 0, 0)
	VolumeIcon:SetTexture(VolumeTexture)
	VolumeIcon:SetVertexColor(class[1], class[2], class[3], 1)
	
	for i=1, 20, 1 do
		VolumeLevel[i] = VolumeFrame:CreateTexture(nil, "ARTWORK")
		if i == 1 then
			VolumeLevel[i]:SetPoint("LEFT", VolumeIcon, "RIGHT", 0, 0)
		else
			VolumeLevel[i]:SetPoint("LEFT", VolumeLevel[i-1], "RIGHT", -50, 0)
		end
		VolumeLevel[i]:SetTexture(LevelTexture)
		VolumeLevel[i]:SetVertexColor(class[1], class[2], class[3], 1)

		if ((level/5) <= 1 and (level/5) ~= 0) then
			VolumeLevel[1]:Show()
		elseif i <= (level/5) then
			VolumeLevel[i]:Show()
		else
			VolumeLevel[i]:Hide()
		end
	end

	VolumeFrame.bar = VolumeFrame:CreateTexture(nil, "ARTWORK")
	VolumeFrame.bar:SetPoint("TOPLEFT", VolumeLevel[1], "BOTTOMLEFT", 31, 0)
	VolumeFrame.bar:SetSize(270, 2)
	VolumeFrame.bar:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\dock\\system\\system46.tga")
	VolumeFrame.bar:SetVertexColor(class[1], class[2], class[3], 1)
	VolumeFrame.bar:Show()

	VolumeText = VolumeFrame:CreateFontString(VolumeFrame, "OVERLAY", "GameTooltipText")
	VolumeText:SetFont(Font, 18)
	VolumeText:SetPoint("RIGHT", 0, 0)
	VolumeText:SetText(format('|cFF%s%.f%%|r', color, level))
	VolumeText:Show()

	VolumeFrame:Hide()

    E:CreateMover(VolumeFrame, "mMediaTagVolumeMover", "mMediaTagVolume", nil, nil, nil, "ALL", nil, "mMediaTag,general,tools,mvolumedisplay", nil)
end

local function mVolumeDisplayptions()
	E.Options.args.mMediaTag.args.general.args.tools.args.mvolumedisplay.args = {
		enable = {
			order = 10,
			type = 'toggle',
			name = L["Enable Volumedisplay"],
			get = function(info)
				return E.db[mPlugin].VolumeDisplay.enable
			end,
			set = function(info, value)
				E.db[mPlugin].VolumeDisplay.enable = value
                E:StaticPopup_Show("CONFIG_RL")
			end,
		},
	}
end

mInsert(ns.Config, mVolumeDisplayptions)