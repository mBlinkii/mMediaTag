local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local addon, ns = ...
local LSM = E.Libs.LSM

if not MediaTagGameVersion.retail then return end
-- Lib Globals
local unpack = unpack

-- WoW Globals
local _G = _G
local ObjectiveTrackerFrame = _G.ObjectiveTrackerFrame
local ObjectiveTrackerBlocksFrame = _G.ObjectiveTrackerBlocksFrame
local WORLD_QUEST_TRACKER_MODULE = _G.WORLD_QUEST_TRACKER_MODULE
local BONUS_OBJECTIVE_TRACKER_MODULE = _G.BONUS_OBJECTIVE_TRACKER_MODULE
local maxNumQuestsCanAccept = C_QuestLog.GetMaxNumQuestsCanAccept()
local HeaderTitel = ObjectiveTrackerBlocksFrame.QuestHeader.Text:GetText()
local width = _G.ObjectiveTrackerFrame:GetWidth()
--local hight = _G.ObjectiveTrackerFrame:GetHight()



-- Variables
local _, unitClass = UnitClass("PLAYER")
local mClassColor = ElvUF.colors.class[unitClass]
local mFontFlags = {
	NONE = L["NONE"],
	OUTLINE = 'Outline',
	THICKOUTLINE = 'Thick',
	MONOCHROME = '|cffaaaaaaMono|r',
	MONOCHROMEOUTLINE = '|cffaaaaaaMono|r Outline',
	MONOCHROMETHICKOUTLINE = '|cffaaaaaaMono|r Thick',
}
local positionValues = {
	LEFT = 'LEFT',
	RIGHT = 'RIGHT',
	CENTER = 'CENTER',
	TOP = 'TOP',
	TOPLEFT = 'TOPLEFT',
	TOPRIGHT = 'TOPRIGHT',
	BOTTOM = 'BOTTOM',
	BOTTOMLEFT = 'BOTTOMLEFT',
	BOTTOMRIGHT = 'BOTTOMRIGHT',
}

local TextureList, mIconsList = nil, nil

local function mTGAtoIcon(file, i)
	return format("|T%s:16:16:0:0.8:64:64|t %s - %s", file, L["Icon"], i)
end

local function mGetTexturePath(file)
	return format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\dot%s.tga", file)
end

local function SetupDotIconList()
	if not mIconsList then
        local tmpIcon = {}
        for i=1, 16, 1 do
            local path = mGetTexturePath(i)
            tmpIcon[i] = {["file"] = path, ["icon"] = mTGAtoIcon(path, i)}
        end
        mIconsList = tmpIcon
    end
end

local function mTextureList()
	if not TextureList then
		SetupDotIconList()
        local tmpTexture = {}
        local i = 0
        for i in pairs(mIconsList) do
            tmpTexture[i] = mIconsList[i].icon
        end
        TextureList = tmpTexture
    end
	return TextureList
end

local function mDashIcon(icon) 
	return format ("|T%s:8:8:-1:-3.8:64:64|t", icon)
end

local mOTFont = nil
local mOTFontFlag = nil
local c = {r = 1, g = 1, b = 1}

local function mGetFont()
	mOTFont = LSM:Fetch('font', E.db[mPlugin].mObjectiveTracker.font)
	mOTFontFlag = E.db[mPlugin].mObjectiveTracker.fontflag
end

local function mSetGradient(obj, revers, orientation, minR, minG, minB, maxR, maxG, maxB)
	if obj then
		if revers then
			obj:GetStatusBarTexture():SetGradient(orientation, maxR, maxG, maxB, minR, minG, minB)
		else
			obj:GetStatusBarTexture():SetGradient(orientation, minR, minG, minB, maxR, maxG, maxB)
		end
	end
end

local function mSetupHeaderFont(headdertext)
	if headdertext then
		local QuestCount = E.db[mPlugin].mObjectiveTracker.header.questcount
		mGetFont()

		if (E.db[mPlugin].mObjectiveTracker.header.fontcolorstyle == "class") then
			c = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3]}
		else
			c = E.db[mPlugin].mObjectiveTracker.header.fontcolor
		end

		if QuestCount ~= "none" then
			local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
			local QuestCountText = format("%s/%s", numQuests, maxNumQuestsCanAccept)

			if (QuestCount == "colorleft") or (QuestCount == "colorright") then
				local cg = E.db[mPlugin].mObjectiveTracker.text.progresscolorgood
				local ct = E.db[mPlugin].mObjectiveTracker.text.progresscolortransit
				local cb = E.db[mPlugin].mObjectiveTracker.text.progresscolorbad
				local tmpPercent = mMT:round((tonumber(numQuests)/tonumber(maxNumQuestsCanAccept))*100 or 0)
				local r, g, b = E:ColorGradient(tmpPercent * 0.01, cg.r, cg.g, cg.b, ct.r, ct.g, ct.b, cb.r, cb.g, cb.b)
				local CountColorString = E:RGBToHex(r, g, b)
				
				if (QuestCount == "colorleft") then
					ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("[%s%s|r] %s", CountColorString, QuestCountText, HeaderTitel))
				elseif (QuestCount == "colorright")  then
					ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("%s [%s%s|r]", HeaderTitel, CountColorString, QuestCountText))
				end
			elseif (QuestCount == "left") then
				ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("[%s] %s", QuestCountText, HeaderTitel))
			elseif (QuestCount == "right")  then
				ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("%s [%s]", HeaderTitel, QuestCountText))
			end
		end

		headdertext:SetFont(mOTFont, E.db[mPlugin].mObjectiveTracker.header.fontsize, mOTFontFlag)
		headdertext:SetTextColor(c.r, c.g, c.b)

		if E.db[mPlugin].mObjectiveTracker.header.textshadow then
			headdertext:SetShadowColor(0, 0, 0, 1)
			headdertext:SetShadowOffset(1, -1)
		else
			headdertext:SetShadowColor(0, 0, 0, 0)
			headdertext.SetShadowColor = function() end
		end

		headdertext:SetWordWrap(headdertext)

		local TextHight = headdertext:GetStringHeight()
		if (headdertext:GetHeight() ~= TextHight) then
			headdertext:SetHeight(TextHight)
		end
	end
end

local function mSetupTitleFont(titletext)
	if titletext then
		mGetFont()
		if (E.db[mPlugin].mObjectiveTracker.title.fontcolorstyle == "class") then
			c = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3]}
		else
			c = E.db[mPlugin].mObjectiveTracker.title.fontcolor
		end
		titletext:SetFont(mOTFont, E.db[mPlugin].mObjectiveTracker.title.fontsize, mOTFontFlag)
		titletext:SetTextColor(c.r, c.g, c.b)

		if E.db[mPlugin].mObjectiveTracker.title.textshadow then
			titletext:SetShadowColor(0, 0, 0, 1)
			titletext:SetShadowOffset(1, -1)
		else
			titletext:SetShadowColor(0, 0, 0, 0)
			titletext.SetShadowColor = function() end
		end

		titletext:SetWordWrap(titletext)

		local TextHight = titletext:GetStringHeight()
		if (titletext:GetHeight() ~= TextHight) then
			titletext:SetHeight(TextHight)
		end
	end
end

local function mSetupQuestFont(linetext)
	if linetext then
		mGetFont()
		if (E.db[mPlugin].mObjectiveTracker.text.fontcolorstyle == "class") then
			c = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3]}
		else
			c = E.db[mPlugin].mObjectiveTracker.text.fontcolor
		end
		linetext:SetFont(mOTFont, E.db[mPlugin].mObjectiveTracker.text.fontsize, mOTFontFlag)
		linetext:SetTextColor(c.r, c.g, c.b)

		if E.db[mPlugin].mObjectiveTracker.text.textshadow then
			linetext:SetShadowColor(0, 0, 0, 1)
			linetext:SetShadowOffset(1, -1)
		else
			linetext:SetShadowColor(0, 0, 0, 0)
			linetext.SetShadowColor = function() end
		end

		linetext:SetWordWrap(linetext)
		local TextHight = linetext:GetStringHeight()
		if (linetext:GetHeight() ~= TextHight) then
			linetext:SetHeight(TextHight)
		end
	end
end

local function mCreatBar(modul)
	local BarStyle, BarColorStyle, BarColor, BarShadow, BarGardient, BarGardientReverse, mEltreumUI= "none", "class", {r =1, g = 1, b = 1}, true, true, false, false
	BarStyle = E.db[mPlugin].mObjectiveTracker.header.barstyle
	BarColor = E.db[mPlugin].mObjectiveTracker.header.barcolor
	BarColorStyle = E.db[mPlugin].mObjectiveTracker.header.barcolorstyle
	BarShadow = E.db[mPlugin].mObjectiveTracker.header.barshadow
	BarGardient = E.db[mPlugin].mObjectiveTracker.header.gradient
	BarGardientReverse = E.db[mPlugin].mObjectiveTracker.header.reverse
	mEltreumUI = E.db[mPlugin].mObjectiveTracker.header.eltreumui

	if (BarStyle == "one") or (BarStyle == "two") or (BarStyle == "onebig") or (BarStyle == "twobig") then
		if BarColorStyle == "class" then
			BarColor = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3]}
		end
		local BarTexture = LSM:Fetch("statusbar", "Solid")

		if E.db[mPlugin].mObjectiveTracker.header.dark then
			BarTexture = LSM:Fetch("statusbar", "mMediaTag A2")
		elseif ns.eltreumui and mEltreumUI then
			BarTexture = LSM:Fetch("statusbar", E.db.ElvUI_EltreumUI.gradientmode.texture)
		end

		local mBarOne = CreateFrame("StatusBar", nil, modul)
		mBarOne:SetFrameStrata("BACKGROUND")
		if (BarStyle == "onebig") or (BarStyle == "twobig") then
			mBarOne:SetSize(width, 5)
		else
			mBarOne:SetSize(width, 1)
		end
		mBarOne:SetPoint("BOTTOM", 0, 0)
		mBarOne:SetStatusBarTexture(BarTexture)
		mBarOne:SetStatusBarColor(BarColor.r, BarColor.g, BarColor.b)
		mBarOne:CreateBackdrop()

		if BarGardient then
			if ns.eltreumui and mEltreumUI then
				mSetGradient(mBarOne, BarGardientReverse, "HORIZONTAL", ns.unitframecustomgradients[E.myclass]["r1"], ns.unitframecustomgradients[E.myclass]["g1"], ns.unitframecustomgradients[E.myclass]["b1"], ns.unitframecustomgradients[E.myclass]["r2"], ns.unitframecustomgradients[E.myclass]["g2"], ns.unitframecustomgradients[E.myclass]["b2"])
			else
				mSetGradient(mBarOne, BarGardientReverse, "HORIZONTAL", BarColor.r-0.5, BarColor.g-0.5, BarColor.b-0.5, BarColor.r, BarColor.g, BarColor.b)
			end
		end

		if BarShadow then
			mBarOne:CreateShadow()
		end

		if (BarStyle == "two") or (BarStyle == "twobig") then
			local mBarTwo = CreateFrame("StatusBar", nil, modul)
			mBarTwo:SetFrameStrata("BACKGROUND")
			if BarStyle == "twobig" then
				mBarTwo:SetSize(width, 5)
			else
				mBarTwo:SetSize(width, 1)
			end
			mBarTwo:SetPoint("TOP", 0, 0)
			mBarTwo:SetStatusBarTexture(BarTexture)
			mBarTwo:SetStatusBarColor(BarColor.r, BarColor.g, BarColor.b)
			mBarTwo:CreateBackdrop()
			
			if ns.eltreumui and mEltreumUI then
				mSetGradient(mBarTwo, BarGardientReverse, "HORIZONTAL", ns.unitframecustomgradients[E.myclass]["r1"], ns.unitframecustomgradients[E.myclass]["g1"], ns.unitframecustomgradients[E.myclass]["b1"], ns.unitframecustomgradients[E.myclass]["r2"], ns.unitframecustomgradients[E.myclass]["g2"], ns.unitframecustomgradients[E.myclass]["b2"])
			else
				mSetGradient(mBarTwo, BarGardientReverse, "HORIZONTAL", BarColor.r-0.5, BarColor.g-0.5, BarColor.b-0.5, BarColor.r, BarColor.g, BarColor.b)
			end

			if BarShadow then
				mBarTwo:CreateShadow()
			end
		end
	end
end

local function SkinQuestText(text)
	local QuestCount = E.db[mPlugin].mObjectiveTracker.header.questcount
	if QuestCount ~= "none" then
		local _, numQuests = C_QuestLog.GetNumQuestLogEntries()
		local QuestCountText = format("%s/%s", numQuests, maxNumQuestsCanAccept)

		if (QuestCount == "colorleft") or (QuestCount == "colorright") then
			local cg = E.db[mPlugin].mObjectiveTracker.text.progresscolorgood
			local ct = E.db[mPlugin].mObjectiveTracker.text.progresscolortransit
			local cb = E.db[mPlugin].mObjectiveTracker.text.progresscolorbad
			local tmpPercent = mMT:round((tonumber(numQuests)/tonumber(maxNumQuestsCanAccept))*100 or 0)
			local r, g, b = E:ColorGradient(tmpPercent * 0.01, cg.r, cg.g, cg.b, ct.r, ct.g, ct.b, cb.r, cb.g, cb.b)
			local CountColorString = E:RGBToHex(r, g, b)
			
			if (QuestCount == "colorleft") then
				ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("[%s%s|r] %s", CountColorString, QuestCountText, HeaderTitel))
			elseif (QuestCount == "colorright")  then
				ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("%s [%s%s|r]", HeaderTitel, CountColorString, QuestCountText))
			end
		elseif (QuestCount == "left") then
			ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("[%s] %s", QuestCountText, HeaderTitel))
		elseif (QuestCount == "right")  then
			ObjectiveTrackerBlocksFrame.QuestHeader.Text:SetText(format("%s [%s]", HeaderTitel, QuestCountText))
		end
	end

	local current, required, details = strmatch(text, "^(%d-)/(%d-) (.+)")
	if (current == nil) or (required == nil) or (details == nil) then
		details, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end

	if (current == nil) or (required == nil) or (details == nil) then
		return
	end
	
	if (current ~= nil) or (required ~= nil) or (details ~= nil) then
		local tmpPercent = mMT:round((tonumber(current)/tonumber(required))*100 or 0)

		if E.db[mPlugin].mObjectiveTracker.text.progresscolor then
			local cg = E.db[mPlugin].mObjectiveTracker.text.progresscolorgood
			local ct = E.db[mPlugin].mObjectiveTracker.text.progresscolortransit
			local cb = E.db[mPlugin].mObjectiveTracker.text.progresscolorbad
			local r, g, b = E:ColorGradient(tmpPercent * 0.01, cb.r, cb.g, cb.b, ct.r, ct.g, ct.b, cg.r, cg.g, cg.b)
			local ColorString = E:RGBToHex(r, g, b)

			
			if E.db[mPlugin].mObjectiveTracker.text.progresscolor and E.db[mPlugin].mObjectiveTracker.text.progrespercent and (tonumber(required) >= 2) then
				if E.db[mPlugin].mObjectiveTracker.text.cleantext then
					return format("%s%s/%s|r - %s%s|r %s", ColorString, current, required, ColorString, tmpPercent .. "%", details)
				else
					return format("%s%s/%s|r - %s%s|r %s", ColorString, current, required, ColorString, tmpPercent .. "%", details)
				end
			else
				if E.db[mPlugin].mObjectiveTracker.text.cleantext then
					return format("%s%s/%s|r %s", ColorString, current, required, details)
				else
					return format("[%s%s/%s|r] %s", ColorString, current, required, details)
				end
			end
		else
			if E.db[mPlugin].mObjectiveTracker.text.progrespercent and (tonumber(required) >= 2) then
				if E.db[mPlugin].mObjectiveTracker.text.cleantext then
					return format("%s/%s - %s %s", current, required, tmpPercent .. "%", details)
				else
					return format("[%s/%s] - %s %s", current, required, tmpPercent .. "%", details)
				end
			else
				if E.db[mPlugin].mObjectiveTracker.text.cleantext then
					return format("%s/%s %s", current, required, details)
				else
					return format("[%s/%s] %s", current, required, details)
				end
			end
		end
	else
		return text
	end
end

local function SkinOBTScenario(numCriteria, objectiveBlock)
	if _G.ScenarioObjectiveBlock then
        local childs = {_G.ScenarioObjectiveBlock:GetChildren()}
        for _, child in pairs(childs) do
			if child.Text then
				mSetupQuestFont(child.Text)
			end
        end
    end
end

local function SkinOBTText(_, line)
	if line then
		if line.HeaderText then
			mSetupTitleFont(line.HeaderText)
		end

		if line.currentLine then
			if line.currentLine.objectiveKey == 0 then
				mSetupTitleFont(line.currentLine.Text)
			else
				local DashStyle = E.db[mPlugin].mObjectiveTracker.dash.style
				if line.currentLine.Dash then
					if DashStyle ~= "blizzard" then
						if DashStyle == "custom" then
							line.currentLine.Dash:SetText(E.db[mPlugin].mObjectiveTracker.dash.customstring)
						elseif DashStyle == "icon" then
							line.currentLine.Dash:SetText(mDashIcon(mIconsList[E.db[mPlugin].mObjectiveTracker.dash.texture].file))
						else
							line.currentLine.Dash:Hide()
							line.currentLine.Text:ClearAllPoints()
							line.currentLine.Text:Point("TOPLEFT", line.currentLine.Dash, "TOPLEFT", 0, 0)
						end
					end
				end

				local CheckTexture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\check.tga"
				local CheckColor = E.db[mPlugin].mObjectiveTracker.text.completecolor

				if line.currentLine.Check then
					if DashStyle == "none" then
						line.currentLine.Check:ClearAllPoints()
						line.currentLine.Check:Point("TOPRIGHT", line.currentLine.Dash, "TOPLEFT", 0, 0)
					end
					line.currentLine.Check:SetTexture(CheckTexture)
					line.currentLine.Check:SetVertexColor(CheckColor.r, CheckColor.g, CheckColor.b, 1)
				end
				
				-- if line.ScrollContents then
				-- end

				if line.currentLine.Text then
					local LineText = line.currentLine.Text:GetText()

					if LineText ~= nil then
						LineText = SkinQuestText(LineText)
						if LineText ~= nil then
							line.currentLine.Text:SetText(LineText)
						end
					end
					mSetupQuestFont(line.currentLine.Text)
				end
			end
		end
	end
end

local function SkinOBT()
	local Frame = ObjectiveTrackerFrame.MODULES
	if (Frame) then
		for i = 1, #Frame do	
			local Modules = Frame[i]
			if (Modules) then
				mSetupHeaderFont(Modules.Header.Text)
				if not (Modules.IsSkinned) then
					if E.db[mPlugin].mObjectiveTracker.header.barstyle ~= "none" then
						mCreatBar(Modules.Header)
					end
					hooksecurefunc(Modules, "AddObjective", SkinOBTText)
					Modules.IsSkinned = true
				end
			end
		end
	end
end

local function mSenario()
	local mTitelEnable = E.db[mPlugin].mObjectiveTracker.quests.titel.enable
	local mTitelFontColor = {r = E.db[mPlugin].mObjectiveTracker.quests.titel.fontcolor.r, g = E.db[mPlugin].mObjectiveTracker.quests.titel.fontcolor.g, b = E.db[mPlugin].mObjectiveTracker.quests.titel.fontcolor.b,}
	local QuestDotIcon = mDashIcon(E.db[mPlugin].mObjectiveTracker.quests.questtext.dashdottexture)
	
	if E.db[mPlugin].mObjectiveTracker.quests.titel.fontstyle == "class" then
		mTitelFontColor = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3],}
	end

	local mQuestEnable = E.db[mPlugin].mObjectiveTracker.quests.other.enable
	local mQuestFontColor = {r = E.db[mPlugin].mObjectiveTracker.quests.other.fontcolor.r, g = E.db[mPlugin].mObjectiveTracker.quests.other.fontcolor.g, b = E.db[mPlugin].mObjectiveTracker.quests.other.fontcolor.b,}
	
	if E.db[mPlugin].mObjectiveTracker.quests.other.fontstyle == "class" then
		mQuestFontColor = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3],}
	end

	local DashStyle = E.db[mPlugin].mObjectiveTracker.quests.questtext.dashstyle
	local DashCustom = E.db[mPlugin].mObjectiveTracker.quests.questtext.dashcustom

	if _G.ScenarioObjectiveBlock then
        local childs = {_G.ScenarioObjectiveBlock:GetChildren()}
        for _, child in pairs(childs) do
            if child.Text then
				mSetupTitleFont(child.Text)

				if child.Check then
					child.Check:SetTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\misc\\check.tga")
					child.Check:SetVertexColor(0, 1, 0, 1)
				end

				if (child.Icon) and DashStyle ~= "blizzard" and DashStyle ~= "none" then
					if DashStyle == "dot" then
						child.Icon:SetText(QuestDotIcon)
					elseif DashStyle == "custom" then
						child.Icon:SetText(DashCustom)
					end
				elseif DashStyle == "none" then
					child.Icon:Hide()
					child.Text:ClearAllPoints()
					child.Text:Point("TOPLEFT", child.Icon, "TOPLEFT", 0, 0)
				end
				child:SetHeight(child:GetHeight())
            end
        end
    end
end

local function mOBTFontColors()
	local mQuestFontColor = E.db[mPlugin].mObjectiveTracker.text.fontcolor
	local mQuestCompleteFontColor = E.db[mPlugin].mObjectiveTracker.text.completecolor
	local mQuestFailedFontColor = E.db[mPlugin].mObjectiveTracker.text.failedcolor
	local mTitelFontColor = E.db[mPlugin].mObjectiveTracker.title.fontcolor

	if E.db[mPlugin].mObjectiveTracker.text.fontcolorstyle == "class" then
		mQuestFontColor = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3],}
	end

	if E.db[mPlugin].mObjectiveTracker.title.fontcolorstyle == "class" then
		mTitelFontColor = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3],}
	end

	OBJECTIVE_TRACKER_COLOR = {
		["Normal"] = { r = mQuestFontColor.r, g = mQuestFontColor.g, b = mQuestFontColor.b },
		["NormalHighlight"] = { r = mQuestFontColor.r + .2, g = mQuestFontColor.g + .2, b = mQuestFontColor.b +.2 },
		["Failed"] = { r = mQuestFailedFontColor.r, g = mQuestFailedFontColor.g, b = mQuestFailedFontColor.b },
		["FailedHighlight"] = { r = mQuestFailedFontColor.r +.2, g = mQuestFailedFontColor.g +.2, b = mQuestFailedFontColor.b +.2},
		["Header"] = {r = mTitelFontColor.r, g = mTitelFontColor.g, b = mTitelFontColor.b},
		["HeaderHighlight"] = { r = mTitelFontColor.r +.2, g = mTitelFontColor.g +.2, b = mTitelFontColor.b +.2},
		["Complete"] = { r = mQuestCompleteFontColor.r, g = mQuestCompleteFontColor.g, b = mQuestCompleteFontColor.b},
		["TimeLeft"] = { r = DIM_RED_FONT_COLOR.r, g = DIM_RED_FONT_COLOR.g, b = DIM_RED_FONT_COLOR.b },
		["TimeLeftHighlight"] = { r = RED_FONT_COLOR.r, g = RED_FONT_COLOR.g, b = RED_FONT_COLOR.b },
	};
	OBJECTIVE_TRACKER_COLOR["Normal"].reverse = OBJECTIVE_TRACKER_COLOR["NormalHighlight"];
	OBJECTIVE_TRACKER_COLOR["NormalHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Normal"];
	OBJECTIVE_TRACKER_COLOR["Failed"].reverse = OBJECTIVE_TRACKER_COLOR["FailedHighlight"];
	OBJECTIVE_TRACKER_COLOR["FailedHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Failed"];
	OBJECTIVE_TRACKER_COLOR["Header"].reverse = OBJECTIVE_TRACKER_COLOR["HeaderHighlight"];
	OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Header"];
	OBJECTIVE_TRACKER_COLOR["TimeLeft"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeftHighlight"];
	OBJECTIVE_TRACKER_COLOR["TimeLeftHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeft"];
	OBJECTIVE_TRACKER_COLOR["Complete"] = OBJECTIVE_TRACKER_COLOR["Complete"];
	OBJECTIVE_TRACKER_COLOR["CompleteHighlight"] = OBJECTIVE_TRACKER_COLOR["Complete"];
end

local function mObjectiveTrackerOptions()
	E.Options.args.mMediaTag.args.cosmetic.args.objectivetracker.args = {
		objectivetrackerenable = {
			order = 1,
			type = 'toggle',
			name = L["Enable"],
			desc = L["Enable ObjectiveTracker (Questwatch) Skin."],
			get = function(info)
				return E.db[mPlugin].mObjectiveTracker.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mObjectiveTracker.enable = value
				if value == true and E.private.skins.blizzard.objectiveTracker == false then
					E.private.skins.blizzard.objectiveTracker = true
				end
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},

		generalgroup = {
			order = 10,
			type = "group",
			name = L['Font'],
			disabled = function() return not E.db[mPlugin].mObjectiveTracker.enable end,
			args = {
				generalfont = {
					type = 'select', dialogControl = 'LSM30_Font',
					order = 1,
					name = L["Default Font"],
					values = LSM:HashTable('font'),
					get = function(info) return E.db[mPlugin].mObjectiveTracker.font end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.font = value; end,
				},
				generalfontflag = {
					type = 'select',
					order = 2,
					name = L["Font contour"],
					values = mFontFlags,
					get = function(info) return E.db[mPlugin].mObjectiveTracker.fontflag end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.fontflag = value; end,
				},
			},
		},

		headergroup = {
			order = 20,
			type = "group",
			name = L['Header'],
			disabled = function() return not E.db[mPlugin].mObjectiveTracker.enable end,
			args = {
				headerfontsize = {
					order = 1,
					name = L["Font Size"],
					type = 'range',
					min = 6, max = 64, step = 1,
					softMin = 8, softMax = 32,
					get = function(info) return E.db[mPlugin].mObjectiveTracker.header.fontsize end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.header.fontsize = value; end,
				},
				headerfontcolorstyle = {
					order = 2,
					type = 'select',
					name = L["Fontcolor Style"],
					get = function(info) return E.db[mPlugin].mObjectiveTracker.header.fontcolorstyle end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.header.fontcolorstyle = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				headerfontcolor = {
					type = 'color',
					order = 3,
					name = L["Fontcolor"],
					hasAlpha = false,
					disabled = function() return (E.db[mPlugin].mObjectiveTracker.header.fontcolorstyle == "class") end,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.header.fontcolor
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.header.fontcolor
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				headerfontshadow = {
					order = 4,
					type = 'toggle',
					name = L["Font shadow"],
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.header.textshadow
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.header.textshadow = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				headerheader1 = {
					order = 5,
					type = "header",
					name = L[""],
				},
				headerbarstyle = {
					order = 6,
					type = 'select',
					name = L["Bar Style"],
					get = function(info) return E.db[mPlugin].mObjectiveTracker.header.barstyle end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.header.barstyle = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						one = L["One"],
						two = L["Two"],
						onebig = L["One big"],
						twobig = L["Two big"],
						none = L["None"],
					},
				},
				headerbarcolorstyle = {
					order = 7,
					type = 'select',
					name = L["Barcolor Style"],
					disabled = function() return (E.db[mPlugin].mObjectiveTracker.header.barstyle == "none") end,
					get = function(info) return E.db[mPlugin].mObjectiveTracker.header.barcolorstyle end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.header.barcolorstyle = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				headerbarcolor = {
					type = 'color',
					order = 8,
					name = L["Barcolor"],
					hasAlpha = false,
					disabled = function() return (E.db[mPlugin].mObjectiveTracker.header.barcolorstyle == "class") end,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.header.barcolor
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.header.barcolor
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				headerbarshadow = {
					order = 9,
					type = 'toggle',
					name = L["Bar Shadow"],
					disabled = function() return (E.db[mPlugin].mObjectiveTracker.header.barstyle == "none") end,
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.header.barshadow
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.header.barshadow = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				headerbargardient = {
					order = 10,
					type = 'toggle',
					name = L["Bar Gardient"],
					disabled = function() return (E.db[mPlugin].mObjectiveTracker.header.barstyle == "none") end,
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.header.gradient
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.header.gradient = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				headerbargardientreverse = {
					order = 11,
					type = 'toggle',
					name = L["Bar Gardient reverse"],
					disabled = function() return (E.db[mPlugin].mObjectiveTracker.header.barstyle == "none") end,
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.header.reverse
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.header.reverse = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				headerbargardienteltreumui = {
					order = 12,
					type = 'toggle',
					name = L["Bar Gardient EltreumUI custom colors"],
					disabled = function() return (E.db[mPlugin].mObjectiveTracker.header.barstyle == "none") end,
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.header.eltreumui
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.header.eltreumui = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				headerbardark = {
					order = 13,
					type = 'toggle',
					name = L["dark Bar"],
					disabled = function() return (E.db[mPlugin].mObjectiveTracker.header.barstyle == "none") end,
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.header.dark
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.header.dark = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				headerheader2 = {
					order = 14,
					type = "header",
					name = L[""],
				},
				headerquestamount = {
					order = 15,
					type = 'select',
					name = L["Show Quest Amount"],
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.header.questcount
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.header.questcount = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						none = L["None"],
						left = L["left"],
						right = L["right"],
						colorleft = L["Colorful left"],
						colorright = L["Colorful right"],
					},
				},
			},
		},

		titlegroup = {
			order = 30,
			type = "group",
			name = L['Title'],
			disabled = function() return not E.db[mPlugin].mObjectiveTracker.enable end,
			args = {
				titlefontsize = {
					order = 1,
					name = L["Font Size"],
					type = 'range',
					min = 6, max = 64, step = 1,
					softMin = 8, softMax = 32,
					get = function(info) return E.db[mPlugin].mObjectiveTracker.title.fontsize end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.title.fontsize = value; end,
				},
				titlefontcolorstyle = {
					order = 2,
					type = 'select',
					name = L["Fontcolor Style"],
					get = function(info) return E.db[mPlugin].mObjectiveTracker.title.fontcolorstyle end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.title.fontcolorstyle = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				titlefontcolor = {
					type = 'color',
					order = 3,
					name = L["Fontcolor"],
					hasAlpha = false,
					disabled = function() return not E.db[mPlugin].mObjectiveTracker.title.fontcolorstyle == "class" end,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.title.fontcolor
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.title.fontcolor
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				titlefontshadow = {
					order = 4,
					type = 'toggle',
					name = L["Font shadow"],
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.title.textshadow
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.title.textshadow = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},

		textgroup = {
			order = 40,
			type = "group",
			name = L['Quest Text'],
			disabled = function() return not E.db[mPlugin].mObjectiveTracker.enable end,
			args = {
				textfontsize = {
					order = 1,
					name = L["Font Size"],
					type = 'range',
					min = 6, max = 64, step = 1,
					softMin = 8, softMax = 32,
					get = function(info) return E.db[mPlugin].mObjectiveTracker.text.fontsize end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.text.fontsize = value; end,
				},
				textfontcolorstyle = {
					order = 2,
					type = 'select',
					name = L["Fontcolor Style"],
					get = function(info) return E.db[mPlugin].mObjectiveTracker.text.fontcolorstyle end,
					set = function(info, value) E.db[mPlugin].mObjectiveTracker.text.fontcolorstyle = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						class = L["Class"],
						custom = L["Custom"],
					},
				},
				textfontcolor = {
					type = 'color',
					order = 3,
					name = L["Fontcolor"],
					hasAlpha = false,
					disabled = function() return not E.db[mPlugin].mObjectiveTracker.text.fontcolorstyle == "class" end,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.text.fontcolor
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.text.fontcolor
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textfontshadow = {
					order = 4,
					type = 'toggle',
					name = L["Font shadow"],
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.text.textshadow
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.text.textshadow = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textheader1 = {
					order = 5,
					type = "header",
					name = L[""],
				},
				textfontcolorcomplete = {
					type = 'color',
					order = 6,
					name = L["Complete Fontcolor"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.text.completecolor
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.text.completecolor
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textfontcolorfailed = {
					type = 'color',
					order = 7,
					name = L["Failed Fontcolor"],
					hasAlpha = false,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.text.failedcolor
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.text.failedcolor
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textprogresscolorgood = {
					type = 'color',
					order = 8,
					name = L["God color"],
					hasAlpha = false,
					disabled = function() return not E.db[mPlugin].mObjectiveTracker.text.progresscolor end,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.text.progresscolorgood
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.text.progresscolorgood
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textprogresscolortransit = {
					type = 'color',
					order = 9,
					name = L["Transit color"],
					hasAlpha = false,
					disabled = function() return not E.db[mPlugin].mObjectiveTracker.text.progresscolor end,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.text.progresscolortransit
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.text.progresscolortransit
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textprogresscolorbad = {
					type = 'color',
					order = 10,
					name = L["Bad color"],
					hasAlpha = false,
					disabled = function() return not E.db[mPlugin].mObjectiveTracker.text.progresscolor end,
					get = function(info)
						local t = E.db[mPlugin].mObjectiveTracker.text.progresscolorbad
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db[mPlugin].mObjectiveTracker.text.progresscolorbad
						t.r, t.g, t.b = r, g, b
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textheader2 = {
					order = 11,
					type = "header",
					name = L[""],
				},
				textprogresspercent = {
					order = 12,
					type = 'toggle',
					name = L["Progress in percent"],
					desc = L["Show Progress in percent"],
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.text.progrespercent
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.text.progrespercent = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textprogresscolor = {
					order = 13,
					type = 'toggle',
					name = L["Colorful Progress"],
					desc = L["Colorful Progress"],
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.text.progresscolor
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.text.progresscolor = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				textonlyprogresstext = {
					order = 14,
					type = 'toggle',
					name = L["Clean Text"],
					desc = L["Shows the Text without []"],
					get = function(info)
						return E.db[mPlugin].mObjectiveTracker.text.cleantext
					end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.text.cleantext = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},

		dashgroup = {
			order = 50,
			type = "group",
			name = L['Dash'],
			disabled = function() return not E.db[mPlugin].mObjectiveTracker.enable end,
			args = {
				dashstyle = {
					order = 1,
					type = 'select',
					name = L["Dash Style"],
					get = function(info) return E.db[mPlugin].mObjectiveTracker.dash.style end,
					set = function(info, value) 
						E.db[mPlugin].mObjectiveTracker.dash.style = value
							E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						blizzard = L["Blizzard"],
						icon = L["Icon"],
						custom = L["Custom"],
						none = L["None"],
					},
				},
				dashtexture = {
					order = 2,
					type = 'select',
					name = L["Icon"],
					disabled = function() return not (E.db[mPlugin].mObjectiveTracker.dash.style == "icon") end,
					get = function(info) return E.db[mPlugin].mObjectiveTracker.dash.texture end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.dash.texture = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = mTextureList(),
				},
				dashcustom = {
					order = 3,
					name = L["Custom Dash Symbol"],
					desc = L["Custom Dash Symbol, enter any character you want."],
					type = 'input',
					width = 'smal',
					disabled = function() return not (E.db[mPlugin].mObjectiveTracker.dash.style == "custom") end,
					get = function() return E.db[mPlugin].mObjectiveTracker.dash.customstring end,
					set = function(info, value)
						E.db[mPlugin].mObjectiveTracker.dash.customstring = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	}
end

function mMT:InitializemOBT()
	if E.db[mPlugin].mObjectiveTracker.enable  == true then
		mOBTFontColors()

		hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", SkinOBT)
		hooksecurefunc("ObjectiveTracker_Update", SkinOBT)
		hooksecurefunc(_G.SCENARIO_CONTENT_TRACKER_MODULE, "UpdateCriteria", SkinOBTScenario)
	end
end

function mMT:mStartObjectiveTracker()
	if E.db[mPlugin].mObjectiveTracker.enable  == true then
		local mFontStyle = E.db[mPlugin].mObjectiveTracker.titel.fontstyle
		local HeaderFontColor = {r = E.db[mPlugin].mObjectiveTracker.titel.fontcolor.r, g = E.db[mPlugin].mObjectiveTracker.titel.fontcolor.g, b = E.db[mPlugin].mObjectiveTracker.titel.fontcolor.b,}
		if mFontStyle == "class" then
			HeaderFontColor = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3],}
		end

		local mTitelEnable = E.db[mPlugin].mObjectiveTracker.quests.titel.enable
		local mTitelFontColor = {r = E.db[mPlugin].mObjectiveTracker.quests.titel.fontcolor.r, g = E.db[mPlugin].mObjectiveTracker.quests.titel.fontcolor.g, b = E.db[mPlugin].mObjectiveTracker.quests.titel.fontcolor.b,}
		if E.db[mPlugin].mObjectiveTracker.quests.titel.fontstyle == "class" then
			mTitelFontColor = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3],}
		end

		local mQuestEnable = E.db[mPlugin].mObjectiveTracker.quests.other.enable
		local mQuestFontColor = {r = E.db[mPlugin].mObjectiveTracker.quests.other.fontcolor.r, g = E.db[mPlugin].mObjectiveTracker.quests.other.fontcolor.g, b = E.db[mPlugin].mObjectiveTracker.quests.other.fontcolor.b,}
		local mQuestCompleteFontColor = {r = E.db[mPlugin].mObjectiveTracker.quests.other.completefontcolor.r, g = E.db[mPlugin].mObjectiveTracker.quests.other.completefontcolor.g, b = E.db[mPlugin].mObjectiveTracker.quests.other.completefontcolor.b,}
		local mQuestFailedFontColor = {r = E.db[mPlugin].mObjectiveTracker.quests.other.failedfontcolor.r, g = E.db[mPlugin].mObjectiveTracker.quests.other.failedfontcolor.g, b = E.db[mPlugin].mObjectiveTracker.quests.other.failedfontcolor.b,}
		if E.db[mPlugin].mObjectiveTracker.quests.other.fontstyle == "class" then
			mQuestFontColor = {r = mClassColor[1], g = mClassColor[2], b = mClassColor[3],}
		end

		OBJECTIVE_TRACKER_COLOR = {
			["Normal"] = { r = mQuestFontColor.r, g = mQuestFontColor.g, b = mQuestFontColor.b },
			["NormalHighlight"] = { r = mQuestFontColor.r + .2, g = mQuestFontColor.g + .2, b = mQuestFontColor.b +.2 },
			["Failed"] = { r = mQuestFailedFontColor.r, g = mQuestFailedFontColor.g, b = mQuestFailedFontColor.b },
			["FailedHighlight"] = { r = mQuestFailedFontColor.r +.2, g = mQuestFailedFontColor.g +.2, b = mQuestFailedFontColor.b +.2},
			["Header"] = {r = mTitelFontColor.r, g = mTitelFontColor.g, b = mTitelFontColor.b},
			["HeaderHighlight"] = { r = mTitelFontColor.r +.2, g = mTitelFontColor.g +.2, b = mTitelFontColor.b +.2},
			["Complete"] = { r = mQuestCompleteFontColor.r, g = mQuestCompleteFontColor.g, b = mQuestCompleteFontColor.b},
			["TimeLeft"] = { r = DIM_RED_FONT_COLOR.r, g = DIM_RED_FONT_COLOR.g, b = DIM_RED_FONT_COLOR.b },
			["TimeLeftHighlight"] = { r = RED_FONT_COLOR.r, g = RED_FONT_COLOR.g, b = RED_FONT_COLOR.b },
		};

		OBJECTIVE_TRACKER_COLOR["Normal"].reverse = OBJECTIVE_TRACKER_COLOR["NormalHighlight"];
		OBJECTIVE_TRACKER_COLOR["NormalHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Normal"];
		OBJECTIVE_TRACKER_COLOR["Failed"].reverse = OBJECTIVE_TRACKER_COLOR["FailedHighlight"];
		OBJECTIVE_TRACKER_COLOR["FailedHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Failed"];
		OBJECTIVE_TRACKER_COLOR["Header"].reverse = OBJECTIVE_TRACKER_COLOR["HeaderHighlight"];
		OBJECTIVE_TRACKER_COLOR["HeaderHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["Header"];
		OBJECTIVE_TRACKER_COLOR["TimeLeft"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeftHighlight"];
		OBJECTIVE_TRACKER_COLOR["TimeLeftHighlight"].reverse = OBJECTIVE_TRACKER_COLOR["TimeLeft"];
		OBJECTIVE_TRACKER_COLOR["Complete"] = OBJECTIVE_TRACKER_COLOR["Complete"];
		OBJECTIVE_TRACKER_COLOR["CompleteHighlight"] = OBJECTIVE_TRACKER_COLOR["Complete"];

		--hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", mSkinObjectiveTrackerFrame)
		--hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", mSkinObjectiveTrackerFrame)
		--hooksecurefunc(CAMPAIGN_QUEST_TRACKER_MODULE, "AddObjective", mSkinObjectiveTrackerFrame)
		--hooksecurefunc("ObjectiveTracker_Update", mSkinObjectiveTrackerFrame)
		hooksecurefunc(_G.SCENARIO_CONTENT_TRACKER_MODULE, "UpdateCriteria", mSenario)
	end
end

table.insert(ns.Config, mObjectiveTrackerOptions)