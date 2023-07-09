local E, L = unpack(ElvUI)
local AFK = E:GetModule("AFK")

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

	if E.Retail then
		local Objects = CharacterStatsPane.statsFramePool.activeObjects
		local DurabilityInfos = mMT:GetDurabilityInfo()

		PlayerStats.values.title = PET_BATTLE_STATS_LABEL
		tinsert(PlayerStats.values.lines, LEVEL .. ": |CFFFFFFFF" .. UnitLevel("player") .. "|r")
		tinsert(
			PlayerStats.values.lines,
			ITEM_UPGRADE_STAT_AVERAGE_ITEM_LEVEL .. ": |CFFFFFFFF" .. mMT:round(GetAverageItemLevel() or 0) .. "|r"
		)
		tinsert(PlayerStats.values.lines, DURABILITY .. ": " .. DurabilityInfos.durability)
		if DurabilityInfos.repair then
			tinsert(PlayerStats.values.lines, REPAIR_COST .. " |CFFFFFFFF" .. DurabilityInfos.repair .. "|r")
		end

		PlayerStats.progress.title = L["Progress"]
		tinsert(PlayerStats.progress.lines, DUNGEON_SCORE .. ": |CFFFFFFFF" .. mMT:GetDungeonScore() .. "|r")

		PlayerStats.attributes.title = STAT_CATEGORY_ATTRIBUTES
		PlayerStats.enhancements.title = STAT_CATEGORY_ENHANCEMENTS

		for Table in pairs(Objects) do
			local Label = Table.Label:GetText()
			local Value = Table.Value:GetText()
			local Percent = string.find(Value, "%%")

			if not Percent then
				tinsert(PlayerStats.attributes.lines, Label .. " |CFFFFFFFF" .. Value .. "|r")
			elseif Percent then
				tinsert(PlayerStats.enhancements.lines, Label .. " |CFFFFFFFF" .. Value .. "|r")
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
	label:FontTemplate(nil, isTitle and 20 or 18)
	label:SetText("")
	label:Point("TOPLEFT", anchor or parent, anchorPoint or "TOPLEFT", offset or 0, isTitle and -24 or -6)
	label:SetTextColor(color.r, color.g, color.b)
	label:SetJustifyH("LEFT")
	label:SetJustifyV("TOP")

	return label
end

function mMT:DEBUGTEXT()
	UpdateTexts()
	mMT:Print(PlayerStats.values.title)
	mMT:DebugPrintTable(PlayerStats.values.lines)
	mMT:Print(PlayerStats.attributes.title)
	mMT:DebugPrintTable(PlayerStats.attributes.lines)
	mMT:Print(PlayerStats.enhancements.title)
	mMT:DebugPrintTable(PlayerStats.enhancements.lines)
end

function mMT:MaUI_AFKScreen()
	if E.db.general.afk then
		-- ElvUI AFK Screen Elements
		-- Insperated by Eltruism AFK Screen
		-- Frame
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

		if not _G.ElvUIAFKFrame.MaUI_Logo then
			local MaUI_Logo = _G.ElvUIAFKFrame:CreateTexture(nil, "OVERLAY")
			MaUI_Logo:Size(E.screenHeight * 0.2, E.screenHeight * 0.05)
			MaUI_Logo:Point("CENTER", _G.ElvUIAFKFrame.bottom)
			MaUI_Logo:SetTexture("Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\maui_logo.tga")
			MaUI_Logo:Point("LEFT", _G.ElvUIAFKFrame.bottom, "CENTER", 10, 0)
			_G.ElvUIAFKFrame.MaUI_Logo = MaUI_Logo
		end

		local db = E.db.mMT.afk

		if not _G.ElvUIAFKFrame.MaUI_AFK_InfoScreen then
			local MaUI_AFK_InfoScreen = CreateFrame("Frame", nil, _G.ElvUIAFKFrame)
			MaUI_AFK_InfoScreen:SetFrameLevel(0)
			MaUI_AFK_InfoScreen:SetTemplate("Transparent")
			MaUI_AFK_InfoScreen:Point("LEFT", _G.ElvUIAFKFrame, "LEFT", 20, 0)
			MaUI_AFK_InfoScreen:Width(5)
			MaUI_AFK_InfoScreen:Height(E.screenHeight / 1.75)
			MaUI_AFK_InfoScreen:SetBackdropColor(mMT.ClassColor.r, mMT.ClassColor.g, mMT.ClassColor.b, 1)

			if db.values.enable then
				MaUI_AFK_InfoScreen.TitleA = CreateLabel(
					MaUI_AFK_InfoScreen,
					true,
					MaUI_AFK_InfoScreen,
					"TOPLEFT",
					{ r = db.title.r, g = db.title.g, b = db.title.b, },
					10
				)
				MaUI_AFK_InfoScreen.BlockA = CreateLabel(
					MaUI_AFK_InfoScreen,
					false,
					MaUI_AFK_InfoScreen.TitleA,
					"BOTTOMLEFT",
					{ r = db.values.r, g = db.values.g, b = db.values.b }
				)
			end

			if db.attributes.enable then
				MaUI_AFK_InfoScreen.TitleB = CreateLabel(
					MaUI_AFK_InfoScreen,
					true,
					MaUI_AFK_InfoScreen.BlockA,
					"BOTTOMLEFT",
					{ r = db.title.r, g = db.title.g, b = db.title.b,}
				)
				MaUI_AFK_InfoScreen.BlockB = CreateLabel(
					MaUI_AFK_InfoScreen,
					false,
					MaUI_AFK_InfoScreen.TitleB,
					"BOTTOMLEFT",
					{ r = db.attributes.r, g = db.attributes.g, b = db.attributes.b }
				)
			end

			if db.enhancements.enable then
				MaUI_AFK_InfoScreen.TitleC = CreateLabel(
					MaUI_AFK_InfoScreen,
					true,
					MaUI_AFK_InfoScreen.BlockB,
					"BOTTOMLEFT",
					{ r = db.title.r, g = db.title.g, b = db.title.b,}
				)
				MaUI_AFK_InfoScreen.BlockC = CreateLabel(
					MaUI_AFK_InfoScreen,
					false,
					MaUI_AFK_InfoScreen.TitleC,
					"BOTTOMLEFT",
					{ r = db.enhancements.r, g = db.enhancements.g, b = db.enhancements.b }
				)
			end

			if db.progress.enable then
				MaUI_AFK_InfoScreen.TitleD = CreateLabel(
					MaUI_AFK_InfoScreen,
					true,
					MaUI_AFK_InfoScreen.BlockC,
					"BOTTOMLEFT",
					{ r = db.title.r, g = db.title.g, b = db.title.b,}
				)
				MaUI_AFK_InfoScreen.BlockD = CreateLabel(
					MaUI_AFK_InfoScreen,
					false,
					MaUI_AFK_InfoScreen.TitleD,
					"BOTTOMLEFT",
					{ r = db.progress.r, g = db.progress.g, b = db.progress.b }
				)
			end

			if db.misc.enable then
				MaUI_AFK_InfoScreen.TitleE = CreateLabel(
					MaUI_AFK_InfoScreen,
					true,
					MaUI_AFK_InfoScreen.BlockD,
					"BOTTOMLEFT",
					{ r = db.title.r, g = db.title.g, b = db.title.b,}
				)
				MaUI_AFK_InfoScreen.BlockE = CreateLabel(
					MaUI_AFK_InfoScreen,
					false,
					MaUI_AFK_InfoScreen.TitleE,
					"BOTTOMLEFT",
					{ r = db.misc.r, g = db.misc.g, b = db.misc.b }
				)
			end

			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen = MaUI_AFK_InfoScreen
		end

		UpdateTexts()

		if db.values.enable then
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.TitleA:SetText(PlayerStats.values.title)
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.BlockA:SetText(PlayerStats.values.text)
		end

		if db.attributes.enable then
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.TitleB:SetText(PlayerStats.attributes.title)
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.BlockB:SetText(PlayerStats.attributes.text)
		end

		if db.enhancements.enable then
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.TitleC:SetText(PlayerStats.enhancements.title)
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.BlockC:SetText(PlayerStats.enhancements.text)
		end

		if db.progress.enable then
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.TitleD:SetText(PlayerStats.progress.title)
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.BlockD:SetText(PlayerStats.progress.text)
		end

		if db.misc.enable then
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.TitleE:SetText(PlayerStats.misc.title)
			_G.ElvUIAFKFrame.MaUI_AFK_InfoScreen.BlockE:SetText(PlayerStats.misc.text)
		end
	end
end

--hooksecurefunc(AFK, "Initialize", MaUI_AFKScreen)
