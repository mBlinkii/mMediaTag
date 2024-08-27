local E = unpack(ElvUI)
local L = mMT.Locales

local _G = _G
local role = nil

local StatNames = {
	[1] = _G.STRENGTH_COLON, --Strength
	[2] = _G.AGILITY_COLON, --Agility
	[3] = _G.STAMINA_COLON, --Stamina
	[4] = _G.INTELLECT_COLON, --Intellect
}

local PlayerStats = {
	values = {
		title = nil,
		lines = {},
		text = nil,
	},
	attributes = {
		title = nil,
		lines = {},
		text = nil,
	},
	enhancements = {
		title = nil,
		lines = {},
	},
	progress = {
		title = nil,
		lines = {},
		text = nil,
	},
}

local function formatMem(memory)
	if memory >= 1024 then
		return format("%.2f mb", memory / 1024)
	else
		return format("%d kb", memory)
	end
end

local function CleanMemory()
	local a, b, c = 0, 0, 0
	a = collectgarbage("count")
	collectgarbage("collect")
	ResetCPUUsage()
	b = collectgarbage("count")

	if a ~= b then
		c = a - b
		return formatMem(c)
	end
end

local function ConcatString(tbl)
	local text = nil

	for key, line in pairs(tbl) do
		if not text then
			text = line
		else
			text = text .. "\n" .. line
		end
	end

	return text or ""
end
local function UpdateTexts()
	PlayerStats = {
		values = {
			title = nil,
			lines = {},
			text = nil,
		},
		attributes = {
			title = nil,
			lines = {},
			text = nil,
		},
		enhancements = {
			title = nil,
			lines = {},
		},
		progress = {
			title = nil,
			lines = {},
			text = nil,
		},
		misc = {
			title = nil,
			lines = {},
			text = nil,
		},
	}

	PaperDollFrame_UpdateStats()

	if E.Retail or E.Cata then
		local DurabilityInfos = mMT:GetDurabilityInfo()

		PlayerStats.values.title = PET_BATTLE_STATS_LABEL
		tinsert(PlayerStats.values.lines, LEVEL .. ": |CFFFFFFFF" .. UnitLevel("player") .. "|r")
		tinsert(PlayerStats.values.lines, ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL .. ": |CFFFFFFFF" .. mMT:round(GetAverageItemLevel() or 0) .. "|r")
		tinsert(PlayerStats.values.lines, DURABILITY .. ": " .. DurabilityInfos.durability)
		if DurabilityInfos.repair then tinsert(PlayerStats.values.lines, REPAIR_COST .. " |CFFFFFFFF" .. DurabilityInfos.repair .. "|r") end

		PlayerStats.progress.title = L["Progress"]

		if E.Retail then tinsert(PlayerStats.progress.lines, DUNGEON_SCORE .. ": " .. mMT:GetDungeonScore()) end

		PlayerStats.attributes.title = STAT_CATEGORY_ATTRIBUTES
		PlayerStats.enhancements.title = STAT_CATEGORY_ENHANCEMENTS

		if E.Retail then
			for line in _G.CharacterStatsPane.statsFramePool:EnumerateActive() do
				local Label = line.Label:GetText()
				local Value = line.Value:GetText()
				if Label and Value then
					local Percent = string.find(Value, "%%")

					if not Percent then
						tinsert(PlayerStats.attributes.lines, Label .. " |CFFFFFFFF" .. Value .. "|r")
					elseif Percent then
						tinsert(PlayerStats.enhancements.lines, Label .. " |CFFFFFFFF" .. Value .. "|r")
					end
				end
			end
		end
	end

	if E.db.mMT.afk.garbage then
		local savedMemory = CleanMemory()
		if savedMemory then
			PlayerStats.misc.title = L["Misc"]
			tinsert(PlayerStats.misc.lines, L["Cleaned Memory"] .. ": |CFFFFFFFF" .. savedMemory .. "|r")
			PlayerStats.misc.text = ConcatString(PlayerStats.misc.lines)
		end
	end

	PlayerStats.values.text = ConcatString(PlayerStats.values.lines)
	PlayerStats.attributes.text = ConcatString(PlayerStats.attributes.lines)
	PlayerStats.enhancements.text = ConcatString(PlayerStats.enhancements.lines)
	PlayerStats.progress.text = ConcatString(PlayerStats.progress.lines)
end

local function CreateLabel(parent, isTitle, anchor, anchorPoint, color, offset)
	local label = parent:CreateFontString(nil, "OVERLAY")
	label:FontTemplate(nil, isTitle and 20 or 18, "SHADOW")
	label:SetText("")
	label:Point("TOPLEFT", anchor or parent, anchorPoint or "TOPLEFT", offset or 0, isTitle and -24 or -6)
	label:SetTextColor(color.r, color.g, color.b)
	label:SetJustifyH("LEFT")
	label:SetJustifyV("TOP")

	return label
end

function mMT:mMT_AFKScreen()
	if E.db.general.afk then
		-- ElvUI AFK Screen Elements
		-- Insperated by Eltruism AFK Screen

		local db = E.db.mMT.afk

		-- Frame
		if db.logo then
			_G.ElvUIAFKFrame.bottom:SetWidth(E.screenWidth / 1.75)
			_G.ElvUIAFKFrame.bottom:SetHeight(E.screenHeight * 0.075)
			_G.ElvUIAFKFrame.bottom:SetPoint("BOTTOM", _G.ElvUIAFKFrame, "BOTTOM", 0, 50)

			-- Logo
			_G.ElvUIAFKFrame.bottom.LogoTop:SetSize(E.screenHeight * 0.1, E.screenHeight * 0.05)
			_G.ElvUIAFKFrame.bottom.LogoTop:ClearAllPoints()
			_G.ElvUIAFKFrame.bottom.LogoTop:Point("RIGHT", _G.ElvUIAFKFrame.bottom, "CENTER", -10, 0)

			_G.ElvUIAFKFrame.bottom.LogoBottom:SetSize(E.screenHeight * 0.1, E.screenHeight * 0.05)
			_G.ElvUIAFKFrame.bottom.LogoBottom:ClearAllPoints()
			_G.ElvUIAFKFrame.bottom.LogoBottom:Point("RIGHT", _G.ElvUIAFKFrame.bottom, "CENTER", -10, 0)

			-- Time
			_G.ElvUIAFKFrame.bottom.time:ClearAllPoints()
			_G.ElvUIAFKFrame.bottom.time:Point("RIGHT", _G.ElvUIAFKFrame.bottom, "RIGHT", -10, 0)
			_G.ElvUIAFKFrame.bottom.time:SetTextColor(0.36, 0.53, 1)

			-- Icon
			_G.ElvUIAFKFrame.bottom.faction:ClearAllPoints()
			_G.ElvUIAFKFrame.bottom.faction:Point("LEFT", _G.ElvUIAFKFrame.bottom, "LEFT", 0, 0)
			_G.ElvUIAFKFrame.bottom.faction:Size(E.screenHeight * 0.05, E.screenHeight * 0.05)

			-- Name
			_G.ElvUIAFKFrame.bottom.name:ClearAllPoints()
			_G.ElvUIAFKFrame.bottom.name:Point("TOPLEFT", _G.ElvUIAFKFrame.bottom.faction, "TOPRIGHT", 10, -2)

			-- Guild
			_G.ElvUIAFKFrame.bottom.guild:SetTextColor(0, 0.82, 0.1)

			-- Model
			local point, relativeTo, relativePoint, _, yOfs = _G.ElvUIAFKFrame.bottom.modelHolder:GetPoint()
			_G.ElvUIAFKFrame.bottom.modelHolder:ClearAllPoints()
			_G.ElvUIAFKFrame.bottom.modelHolder:Point(point, relativeTo, relativePoint, 250, yOfs + 10)
			_G.ElvUIAFKFrame.bottom.model:SetScale(0.9)

			if not _G.ElvUIAFKFrame.mMT_Logo then
				local mMT_Logo = _G.ElvUIAFKFrame:CreateTexture(nil, "OVERLAY")
				mMT_Logo:Size(E.screenHeight * 0.2, E.screenHeight * 0.05)
				mMT_Logo:Point("CENTER", _G.ElvUIAFKFrame.bottom)
				mMT_Logo:SetTexture((not (db.texture == "")) and db.texture or "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_logo.tga")
				mMT_Logo:Point("LEFT", _G.ElvUIAFKFrame.bottom, "CENTER", 10, 0)
				_G.ElvUIAFKFrame.mMT_Logo = mMT_Logo
			end
		end

		if db.infoscreen then
			-- Chat
			_G.ElvUIAFKFrame.chat:ClearAllPoints()
			_G.ElvUIAFKFrame.chat:Point("TOP", _G.ElvUIAFKFrame, "TOP", 0, -4)

			if not _G.ElvUIAFKFrame.mMT_AFK_InfoScreen then
				local mMT_AFK_InfoScreen = CreateFrame("Frame", nil, _G.ElvUIAFKFrame)
				mMT_AFK_InfoScreen:SetFrameLevel(0)
				mMT_AFK_InfoScreen:SetTemplate("Transparent")
				mMT_AFK_InfoScreen:Point("LEFT", _G.ElvUIAFKFrame, "LEFT", 20, 0)
				mMT_AFK_InfoScreen:Width(5)
				mMT_AFK_InfoScreen:SetBackdropColor(mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b, 1)

				if db.values.enable then
					mMT_AFK_InfoScreen.TitleA = CreateLabel(mMT_AFK_InfoScreen, true, mMT_AFK_InfoScreen, "TOPLEFT", { r = db.title.r, g = db.title.g, b = db.title.b }, 10)
					mMT_AFK_InfoScreen.BlockA = CreateLabel(mMT_AFK_InfoScreen, false, mMT_AFK_InfoScreen.TitleA, "BOTTOMLEFT", { r = db.values.r, g = db.values.g, b = db.values.b })
				end

				if db.attributes.enable then
					mMT_AFK_InfoScreen.TitleB = CreateLabel(mMT_AFK_InfoScreen, true, mMT_AFK_InfoScreen.BlockA, "BOTTOMLEFT", { r = db.title.r, g = db.title.g, b = db.title.b })
					mMT_AFK_InfoScreen.BlockB = CreateLabel(mMT_AFK_InfoScreen, false, mMT_AFK_InfoScreen.TitleB, "BOTTOMLEFT", { r = db.attributes.r, g = db.attributes.g, b = db.attributes.b })
				end

				if db.enhancements.enable then
					mMT_AFK_InfoScreen.TitleC = CreateLabel(mMT_AFK_InfoScreen, true, mMT_AFK_InfoScreen.BlockB, "BOTTOMLEFT", { r = db.title.r, g = db.title.g, b = db.title.b })
					mMT_AFK_InfoScreen.BlockC = CreateLabel(mMT_AFK_InfoScreen, false, mMT_AFK_InfoScreen.TitleC, "BOTTOMLEFT", { r = db.enhancements.r, g = db.enhancements.g, b = db.enhancements.b })
				end

				if db.progress.enable then
					mMT_AFK_InfoScreen.TitleD = CreateLabel(mMT_AFK_InfoScreen, true, mMT_AFK_InfoScreen.BlockC, "BOTTOMLEFT", { r = db.title.r, g = db.title.g, b = db.title.b })
					mMT_AFK_InfoScreen.BlockD = CreateLabel(mMT_AFK_InfoScreen, false, mMT_AFK_InfoScreen.TitleD, "BOTTOMLEFT", { r = db.progress.r, g = db.progress.g, b = db.progress.b })
				end

				if db.misc.enable then
					mMT_AFK_InfoScreen.TitleE = CreateLabel(mMT_AFK_InfoScreen, true, mMT_AFK_InfoScreen.BlockD, "BOTTOMLEFT", { r = db.title.r, g = db.title.g, b = db.title.b })
					mMT_AFK_InfoScreen.BlockE = CreateLabel(mMT_AFK_InfoScreen, false, mMT_AFK_InfoScreen.TitleE, "BOTTOMLEFT", { r = db.misc.r, g = db.misc.g, b = db.misc.b })
				end

				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen = mMT_AFK_InfoScreen
			end

			UpdateTexts()

			local size = 0
			if db.values.enable then
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleA:SetText(PlayerStats.values.title)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockA:SetText(PlayerStats.values.text)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleA:SetTextColor(db.title.r, db.title.g, db.title.b)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockA:SetTextColor(db.values.r, db.values.g, db.values.b)
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleA:GetStringHeight() + 20
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockA:GetStringHeight() + 18
			end

			if db.attributes.enable then
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleB:SetText(PlayerStats.attributes.title)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockB:SetText(PlayerStats.attributes.text)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleB:SetTextColor(db.title.r, db.title.g, db.title.b)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockB:SetTextColor(db.attributes.r, db.attributes.g, db.attributes.b)
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleB:GetStringHeight() + 20
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockB:GetStringHeight() + 18
			end

			if db.enhancements.enable then
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleC:SetText(PlayerStats.enhancements.title)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockC:SetText(PlayerStats.enhancements.text)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleC:SetTextColor(db.title.r, db.title.g, db.title.b)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockC:SetTextColor(db.enhancements.r, db.enhancements.g, db.enhancements.b)
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleC:GetStringHeight() + 20
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockC:GetStringHeight() + 18
			end

			if db.progress.enable then
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleD:SetText(PlayerStats.progress.title)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockD:SetText(PlayerStats.progress.text)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleD:SetTextColor(db.title.r, db.title.g, db.title.b)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockD:SetTextColor(db.progress.r, db.progress.g, db.progress.b)
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleD:GetStringHeight() + 20
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockD:GetStringHeight() + 18
			end

			if db.misc.enable then
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleE:SetText(PlayerStats.misc.title)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockE:SetText(PlayerStats.misc.text)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleE:SetTextColor(db.title.r, db.title.g, db.title.b)
				_G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockE:SetTextColor(db.misc.r, db.misc.g, db.misc.b)
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.TitleE:GetStringHeight() + 20
				size = size + _G.ElvUIAFKFrame.mMT_AFK_InfoScreen.BlockE:GetStringHeight() + 18
			end
			_G.ElvUIAFKFrame.mMT_AFK_InfoScreen:Height(size)
		end
	end
end
