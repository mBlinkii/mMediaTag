local E, _, V, P, G = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local function ResetSettings()
	E.db.mMT.dockdatatext = {
		autogrow = true,
		growsize = 8,
		customfontzise = false,
		font = "PT Sans Narrow",
		center = false,
		fontSize = 12,
		fontflag = "OUTLINE",
		customfontcolor = false,
		fontcolor = { r = 1, g = 1, b = 1 },
		normal = { r = 1, g = 1, b = 1, a = 1, style = "custom" },
		hover = { r = 0.5, g = 0.5, b = 0.5, a = 0.75, style = "custom" },
		click = { r = 0.2, g = 0.2, b = 0.2, a = 1, style = "custom" },
		tip = { enable = true },
		achievement = {
			icon = "COLOR45",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		mail = {
			icon = "MAIL19",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		blizzardstore = {
			icon = "COLOR01",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		character = {
			color = true,
			option = "none",
			icon = "COLOR19",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		collection = {
			icon = "COLOR24",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		encounter = {
			icon = "COLOR49",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		guild = {
			icon = "COLOR38",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		lfd = {
			score = true,
			cta = true,
			icon = "COLOR27",
			greatvault = true,
			affix = true,
			keystone = true,
			difficulty = true,
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		mainmenu = {
			icon = "COLOR11",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		quest = {
			icon = "COLOR26",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		spellbook = {
			icon = "COLOR46",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		talent = {
			showrole = true,
			icon = "COLOR40",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		friends = {
			icon = "COLOR58",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		fpsms = {
			text = "FPS",
			color = "default",
			option = "fps",
			icon = "COLOR31",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		durability = {
			color = true,
			icon = "COLOR53",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		itemlevel = {
			onlytext = false,
			text = "Ilvl",
			color = true,
			icon = "COLOR50",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		notification = {
			icon = "FILLED27",
			r = 0,
			g = 1,
			b = 0,
			a = 0.75,
			style = "custom",
			size = 16,
			auto = true,
			flash = true,
		},
		profession = {
			icon = "COLOR06",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		volume = {
			showtext = true,
			icon = "COLOR62",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		calendar = {
			option = "us",
			dateicon = "b",
			showyear = false,
			text = false,
			icon = "COLOR02",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
		},
		bag = {
			icon = "COLOR68",
			iconcolor = { r = 1, g = 1, b = 1, a = 0.75 },
			customcolor = false,
			text = 5,
		},
	}
end

local function ResetColors()
	ResetSettings()
end

local function DeletePanels()
	-- short db paths
	local globalDB = E.global.datatexts.customPanels
	local db = E.db.datatexts.panels

	local panels = { "mMT - Location", "mMT - Location X", "mMT - Location Y", "MaUI Currencies", "mMT Extra Clock", "mMT Extra Icons", "mMT Extra Infos", "mMT - Background", "mMT XIV Clock", "mMT XIV Info", "mMT XIV Left", "mMT XIV Right", "mMT XIV Talent", "mMT XIV Profession", "mMT Dock", "mMT Extra Infos", "mMT Extra Icons", "mMT Extra Clock", "MaUI Left", "MaUI Right", "MaUI Time", "MaUI Time Left", "MaUI Time Right", "mMT Databar Background", "mMT - CENTER", "mMT - EXTRA LEFT", "mMT - EXTRA RIGHT", "mMT - LEFT", "mMT - RIGHT" }
	for _, name in pairs(panels) do
		if globalDB[name] then
			E.Options.args.datatexts.args.panels.args[name] = nil
			db[name] = nil
			globalDB[name] = nil

			DT:ReleasePanel(name)
		end
	end
end

function mMT:DeleteAll()
	ResetSettings()

	DeletePanels()

	E:StaggeredUpdateAll(nil, true)
end

function mMT:XIV(settings)
	-- reset mmt settings
	ResetSettings()

	-- reset panels
	DeletePanels()

	-- short db paths
	local globalDB = E.global.datatexts.customPanels
	local db = E.db.datatexts.panels

	-- use default font settings if they are not set
	local font = settings.font or "Montserrat-SemiBold"
	local fontflag = settings.fontflag or "SHADOW"
	local size = settings.fontsize or 14

	-- setup durabilityIlevel datatext
	E.db.mMT.durabilityIlevel.colored.a.color.b = 0.027450982481241
	E.db.mMT.durabilityIlevel.colored.a.color.g = 0.61176472902298
	E.db.mMT.durabilityIlevel.colored.a.color.r = 0.92941182851791
	E.db.mMT.durabilityIlevel.colored.a.value = 40
	E.db.mMT.durabilityIlevel.colored.enable = true
	E.db.mMT.durabilityIlevel.whiteIcon = false

	-- setup teleports datatext
	E.db.mMT.teleports.customicon = "TP7"
	E.db.mMT.teleports.icon = true
	E.db.mMT.teleports.whiteText = true

	-- setup Gold datatext
	E.global.datatexts.settings.Gold.goldFormat = "SHORTSPACED"

	-- panels list and settings
	local panels = {}

	if settings.dock == "SIMPLE" then
		panels = {
			["mMT - CENTER"] = { width = 600, numPoints = 3 },
			["mMT - LEFT"] = { width = 540, numPoints = 12 },
			["mMT - RIGHT"] = { width = 540, numPoints = 4 },
		}
	else
		panels = {
			["mMT - CENTER"] = { width = 180, numPoints = 1, double = true },
			["mMT - EXTRA LEFT"] = { width = 644, numPoints = 3 },
			["mMT - EXTRA RIGHT"] = { width = 644, numPoints = 3 },
			["mMT - LEFT"] = { width = 540, numPoints = 12 },
			["mMT - RIGHT"] = { width = 540, numPoints = 4 },
		}
	end

	-- build custom panels
	for name, setting in pairs(panels) do
		if not globalDB[name] then
			E.DataTexts:BuildPanelFrame(name)
		end

		globalDB[name].backdrop = false
		globalDB[name].border = false
		globalDB[name].fonts.enable = true
		globalDB[name].fonts.font = font
		globalDB[name].fonts.fontOutline = fontflag
		globalDB[name].fonts.fontSize = setting.double and (size + size) or size
		globalDB[name].height = 32
		globalDB[name].name = name
		globalDB[name].numPoints = setting.numPoints
		globalDB[name].visibility = ""
		globalDB[name].width = setting.width
	end

	-- set the settings for the panels
	for name, _ in pairs(panels) do
		db[name].battleground = false
		db[name].enable = true
	end

	if (settings.dock ~= "SIMPLE") then
		db["mMT - EXTRA LEFT"][1] = "DurabilityIlevel"
		db["mMT - EXTRA LEFT"][2] = "Difficulty"
		db["mMT - EXTRA LEFT"][3] = "Talent/Loot Specialization"

		db["mMT - EXTRA RIGHT"][1] = "firstProf"
		db["mMT - EXTRA RIGHT"][2] = "secondProf"
		db["mMT - EXTRA RIGHT"][3] = "mProfessions"
	end

	if settings.dock == "MAUI" then
		db["mMT - LEFT"][1] = "mMT_Dock_Character"
		db["mMT - LEFT"][2] = "mMT_Dock_SpellBook"
		db["mMT - LEFT"][3] = "mMT_Dock_Guild"
		db["mMT - LEFT"][4] = "mMT_Dock_Friends"
		db["mMT - LEFT"][5] = "mMT_Dock_Achievement"
		db["mMT - LEFT"][6] = "mMT_Dock_Quest"
		db["mMT - LEFT"][7] = "mMT_Dock_LFDTool"
		db["mMT - LEFT"][8] = "mMT_Dock_EncounterJournal"
		db["mMT - LEFT"][9] = "mMT_Dock_CollectionsJournal"
		db["mMT - LEFT"][10] = "mMT_Dock_Volume"
		db["mMT - LEFT"][11] = "mMT_Dock_BlizzardStore"
		db["mMT - LEFT"][12] = "mMT_Dock_Calendar"
	elseif (settings.dock == "XIV") or (settings.dock == "XIVCOLOR") or (settings.dock == "SIMPLE") then
		db["mMT - LEFT"][1] = "mMT_Dock_MainMenu"
		db["mMT - LEFT"][2] = "mMT_Dock_Character"
		db["mMT - LEFT"][3] = "mMT_Dock_Guild"
		db["mMT - LEFT"][4] = "mMT_Dock_Friends"
		db["mMT - LEFT"][5] = "mMT_Dock_Achievement"
		db["mMT - LEFT"][6] = "mMT_Dock_SpellBook"
		db["mMT - LEFT"][7] = "mMT_Dock_LFDTool"
		db["mMT - LEFT"][8] = "mMT_Dock_EncounterJournal"
		db["mMT - LEFT"][9] = "mMT_Dock_Quest"
		db["mMT - LEFT"][10] = "mMT_Dock_CollectionsJournal"
		db["mMT - LEFT"][11] = "mMT_Dock_BlizzardStore"
		db["mMT - LEFT"][12] = "mMT_Dock_Calendar"
	end

	if (settings.dock == "XIV") or (settings.dock == "XIVCOLOR") or (settings.dock ~= "SIMPLE") then
		db["mMT - CENTER"][1] = "Time"
		db["mMT - RIGHT"][1] = "System"
		db["mMT - RIGHT"][2] = "M+ Score"
		db["mMT - RIGHT"][3] = "mTeleports"
		db["mMT - RIGHT"][4] = "Gold"
	elseif settings.dock == "SIMPLE" then
		db["mMT - CENTER"][1] = "DurabilityIlevel"
		db["mMT - CENTER"][2] = "System"
		db["mMT - CENTER"][3] = "mProfessions"

		db["mMT - RIGHT"][1] = ""
		db["mMT - RIGHT"][2] = ""
		db["mMT - RIGHT"][3] = "Date"
		db["mMT - RIGHT"][4] = "Time"
	end

	-- mmt dock font settings
	E.db.mMT.dockdatatext.font = font
	E.db.mMT.dockdatatext.fontSize = size
	E.db.mMT.dockdatatext.fontcolor.b = 0.10588236153126
	E.db.mMT.dockdatatext.fontcolor.g = 0.77254909276962
	E.db.mMT.dockdatatext.fontcolor.r = 0.086274512112141
	E.db.mMT.dockdatatext.fontflag = fontflag

	-- mmt dock settings
	if (settings.dock == "XIV") or (settings.dock == "XIVCOLOR") or (settings.dock == "SIMPLE") then
		E.db.mMT.dockdatatext.achievement.icon = "MATERIAL01"
		E.db.mMT.dockdatatext.blizzardstore.icon = "MATERIAL14"
		E.db.mMT.dockdatatext.calendar.dateicon = "none"
		E.db.mMT.dockdatatext.calendar.icon = "MATERIAL32"
		E.db.mMT.dockdatatext.calendar.option = "us"
		E.db.mMT.dockdatatext.calendar.showyear = true
		E.db.mMT.dockdatatext.center = true
		E.db.mMT.dockdatatext.character.icon = "MATERIAL12"
		E.db.mMT.dockdatatext.collection.icon = "MATERIAL33"
		E.db.mMT.dockdatatext.customfontcolor = true
		E.db.mMT.dockdatatext.customfontzise = true
		E.db.mMT.dockdatatext.encounter.icon = "MATERIAL42"
		E.db.mMT.dockdatatext.friends.icon = "MATERIAL28"
		E.db.mMT.dockdatatext.guild.icon = "MATERIAL35"
		E.db.mMT.dockdatatext.hover.style = "class"
		E.db.mMT.dockdatatext.itemlevel.onlytext = true
		E.db.mMT.dockdatatext.itemlevel.text = "GS "
		E.db.mMT.dockdatatext.lfd.icon = "MATERIAL11"
		E.db.mMT.dockdatatext.mainmenu.icon = "MATERIAL52"
		E.db.mMT.dockdatatext.profession.icon = "MATERIAL25"
		E.db.mMT.dockdatatext.quest.icon = "MATERIAL41"
		E.db.mMT.dockdatatext.spellbook.icon = "MATERIAL22"
	end

	if settings.dock == "XIVCOLOR" then
		E.db.mMT.dockdatatext.achievement.customcolor = true
		E.db.mMT.dockdatatext.achievement.iconcolor.b = 0.17254902422428
		E.db.mMT.dockdatatext.achievement.iconcolor.g = 0.16078431904316
		E.db.mMT.dockdatatext.achievement.iconcolor.r = 0.92549026012421
		E.db.mMT.dockdatatext.blizzardstore.customcolor = true
		E.db.mMT.dockdatatext.blizzardstore.iconcolor.b = 0.53333336114883
		E.db.mMT.dockdatatext.blizzardstore.iconcolor.g = 0.92549026012421
		E.db.mMT.dockdatatext.blizzardstore.iconcolor.r = 0
		E.db.mMT.dockdatatext.calendar.customcolor = true
		E.db.mMT.dockdatatext.calendar.iconcolor.b = 0.83529418706894
		E.db.mMT.dockdatatext.calendar.iconcolor.g = 0.92549026012421
		E.db.mMT.dockdatatext.calendar.iconcolor.r = 0
		E.db.mMT.dockdatatext.character.customcolor = true
		E.db.mMT.dockdatatext.character.iconcolor.b = 0.93725496530533
		E.db.mMT.dockdatatext.character.iconcolor.g = 0.20000001788139
		E.db.mMT.dockdatatext.character.iconcolor.r = 0.65098041296005
		E.db.mMT.dockdatatext.collection.customcolor = true
		E.db.mMT.dockdatatext.collection.iconcolor.b = 0
		E.db.mMT.dockdatatext.collection.iconcolor.g = 0.92549026012421
		E.db.mMT.dockdatatext.collection.iconcolor.r = 0.11372549831867
		E.db.mMT.dockdatatext.encounter.customcolor = true
		E.db.mMT.dockdatatext.encounter.iconcolor.b = 0
		E.db.mMT.dockdatatext.encounter.iconcolor.g = 0.7294117808342
		E.db.mMT.dockdatatext.encounter.iconcolor.r = 0.92549026012421
		E.db.mMT.dockdatatext.friends.customcolor = true
		E.db.mMT.dockdatatext.friends.iconcolor.b = 0.53333336114883
		E.db.mMT.dockdatatext.friends.iconcolor.g = 0.14117647707462
		E.db.mMT.dockdatatext.friends.iconcolor.r = 0.92549026012421
		E.db.mMT.dockdatatext.guild.customcolor = true
		E.db.mMT.dockdatatext.guild.iconcolor.b = 0.92549026012421
		E.db.mMT.dockdatatext.guild.iconcolor.g = 0.18823531270027
		E.db.mMT.dockdatatext.guild.iconcolor.r = 0.90196084976196
		E.db.mMT.dockdatatext.lfd.customcolor = true
		E.db.mMT.dockdatatext.lfd.iconcolor.b = 0
		E.db.mMT.dockdatatext.lfd.iconcolor.g = 0.50588238239288
		E.db.mMT.dockdatatext.lfd.iconcolor.r = 0.92549026012421
		E.db.mMT.dockdatatext.mainmenu.customcolor = true
		E.db.mMT.dockdatatext.mainmenu.iconcolor.b = 0.94509810209274
		E.db.mMT.dockdatatext.mainmenu.iconcolor.g = 0.20784315466881
		E.db.mMT.dockdatatext.mainmenu.iconcolor.r = 0.58823531866074
		E.db.mMT.dockdatatext.profession.customcolor = true
		E.db.mMT.dockdatatext.profession.iconcolor.b = 0.53333336114883
		E.db.mMT.dockdatatext.profession.iconcolor.g = 0.92549026012421
		E.db.mMT.dockdatatext.profession.iconcolor.r = 0
		E.db.mMT.dockdatatext.quest.customcolor = true
		E.db.mMT.dockdatatext.quest.iconcolor.b = 0
		E.db.mMT.dockdatatext.quest.iconcolor.g = 0.92549026012421
		E.db.mMT.dockdatatext.quest.iconcolor.r = 0.69019609689713
		E.db.mMT.dockdatatext.spellbook.customcolor = true
		E.db.mMT.dockdatatext.spellbook.iconcolor.b = 0
		E.db.mMT.dockdatatext.spellbook.iconcolor.g = 0.3137255012989
		E.db.mMT.dockdatatext.spellbook.iconcolor.r = 0.92549026012421
	elseif settings.dock == "MAUI" then
		E.db.mMT.dockdatatext.achievement.icon = "MAUI04"
		E.db.mMT.dockdatatext.blizzardstore.icon = "MAUI20"
		E.db.mMT.dockdatatext.calendar.option = "US"
		E.db.mMT.dockdatatext.calendar.showyear = true
		E.db.mMT.dockdatatext.center = true
		E.db.mMT.dockdatatext.character.icon = "MAUI15"
		E.db.mMT.dockdatatext.collection.icon = "MAUI31"
		E.db.mMT.dockdatatext.customfontcolor = true
		E.db.mMT.dockdatatext.customfontzise = true
		E.db.mMT.dockdatatext.encounter.icon = "MAUI33"
		E.db.mMT.dockdatatext.friends.icon = "MAUI40"
		E.db.mMT.dockdatatext.guild.icon = "MAUI01"
		E.db.mMT.dockdatatext.hover.b = 0.4078431725502
		E.db.mMT.dockdatatext.hover.g = 0.4078431725502
		E.db.mMT.dockdatatext.hover.r = 0.4078431725502
		E.db.mMT.dockdatatext.itemlevel.onlytext = true
		E.db.mMT.dockdatatext.itemlevel.text = "GS "
		E.db.mMT.dockdatatext.lfd.icon = "MAUI35"
		E.db.mMT.dockdatatext.mainmenu.icon = "MAUI17"
		E.db.mMT.dockdatatext.normal.a = 0.80718515813351
		E.db.mMT.dockdatatext.profession.icon = "COLOR06"
		E.db.mMT.dockdatatext.quest.icon = "MAUI10"
		E.db.mMT.dockdatatext.spellbook.icon = "MAUI26"
		E.db.mMT.dockdatatext.talent.icon = "MAUI03"
		E.db.mMT.dockdatatext.volume.icon = "MAUI16"
	end

	-- add bg
	if settings.bg then
		if not globalDB["mMT - Background"] then
			E.DataTexts:BuildPanelFrame("mMT - Background")
		end

		globalDB["mMT - Background"].frameStrata = "BACKGROUND"
		globalDB["mMT - Background"].height = 32
		globalDB["mMT - Background"].name = "mMT - Background"
		globalDB["mMT - Background"].numPoints = 1
		globalDB["mMT - Background"].panelTransparency = true
		globalDB["mMT - Background"].visibility = ""
		globalDB["mMT - Background"].width = GetScreenWidth() or 1920

		db["mMT - Background"][1] = ""
		db["mMT - Background"].battleground = false
		db["mMT - Background"].enable = true

		if settings.top then
			E.db["movers"]["DTPanelmMT - BackgroundMover"] = "TOP,ElvUIParent,TOP,0,-4"
		else
			E.db["movers"]["DTPanelmMT - BackgroundMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
		end
	elseif globalDB["mMT - Background"] then
		db["mMT - Background"].enable = false
	end

	-- setup the movers
	if settings.top then
		E.db.movers["DTPanelmMT - CENTERMover"] = "TOP,UIParent,TOP,0,4"
		E.db.movers["DTPanelmMT - LEFTMover"] = "TOPLEFT,UIParent,TOPLEFT,4,4"
		E.db.movers["DTPanelmMT - RIGHTMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-4,4"

		if settings.dock ~= "SIMPLE" then
			E.db.movers["DTPanelmMT - EXTRA LEFTMover"] = "TOP,ElvUIParent,TOP,-413,4"
			E.db.movers["DTPanelmMT - EXTRA RIGHTMover"] = "TOP,ElvUIParent,TOP,413,4"
		end
	else
		E.db.movers["DTPanelmMT - CENTERMover"] = "BOTTOM,UIParent,BOTTOM,0,4"
		E.db.movers["DTPanelmMT - LEFTMover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,4"
		E.db.movers["DTPanelmMT - RIGHTMover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-4,4"

		if settings.dock ~= "SIMPLE" then
			E.db.movers["DTPanelmMT - EXTRA LEFTMover"] = "BOTTOM,ElvUIParent,BOTTOM,-413,4"
			E.db.movers["DTPanelmMT - EXTRA RIGHTMover"] = "BOTTOM,ElvUIParent,BOTTOM,413,4"
		end
	end

	-- update elvui
	E:StaggeredUpdateAll(nil, true)
end

function mMT:Dock_Default(settings)
	-- reset mmt settings
	ResetSettings()

	-- reset panels
	DeletePanels()

	-- short db paths
	local globalDB = E.global.datatexts.customPanels
	local db = E.db.datatexts.panels

	if not globalDB["mMT Dock"] then
		E.DataTexts:BuildPanelFrame("mMT Dock")
	end

	globalDB["mMT Dock"].backdrop = settings.bg
	globalDB["mMT Dock"].border = true
	globalDB["mMT Dock"].panelTransparency = true
	globalDB["mMT Dock"].height = 32
	globalDB["mMT Dock"].name = "mMT Dock"
	globalDB["mMT Dock"].numPoints = 12
	globalDB["mMT Dock"].visibility = ""
	globalDB["mMT Dock"].width = 433

	db["mMT Dock"][1] = "mMT_Dock_Character"
	db["mMT Dock"][2] = "mMT_Dock_SpellBook"
	db["mMT Dock"][3] = E.Retail and "mMT_Dock_Talent" or "mMT_Dock_Friends"
	db["mMT Dock"][4] = "mMT_Dock_Achievement"
	db["mMT Dock"][5] = "mMT_Dock_Quest"
	db["mMT Dock"][6] = "mMT_Dock_LFDTool"
	db["mMT Dock"][7] = "mMT_Dock_EncounterJournal"
	db["mMT Dock"][8] = "mMT_Dock_CollectionsJournal"
	db["mMT Dock"][9] = "mMT_Dock_Calendar"
	db["mMT Dock"][10] = "mMT_Dock_Volume"
	db["mMT Dock"][11] = E.Cata and "mMT_Dock_Profession" or "mMT_Dock_BlizzardStore"
	db["mMT Dock"][12] = "mMT_Dock_MainMenu"
	db["mMT Dock"].battleground = false
	db["mMT Dock"].enable = true

	E.db.mMT.dockdatatext.achievement.icon = "COLOR35"
	E.db.mMT.dockdatatext.bag.icon = "COLOR68"
	E.db.mMT.dockdatatext.blizzardstore.icon = "COLOR01"
	E.db.mMT.dockdatatext.calendar.icon = "COLOR02"
	E.db.mMT.dockdatatext.character.icon = "COLOR19"
	E.db.mMT.dockdatatext.collection.icon = "COLOR05"
	E.db.mMT.dockdatatext.durability.icon = "COLOR53"
	E.db.mMT.dockdatatext.encounter.icon = "COLOR17"
	E.db.mMT.dockdatatext.fpsms.icon = "COLOR31"
	E.db.mMT.dockdatatext.friends.icon = "COLOR38"
	E.db.mMT.dockdatatext.friends.icon = "COLOR58"
	E.db.mMT.dockdatatext.guild.icon = "COLOR38"
	E.db.mMT.dockdatatext.itemlevel.icon = "COLOR50"
	E.db.mMT.dockdatatext.lfd.icon = "COLOR27"
	E.db.mMT.dockdatatext.mainmenu.icon = "COLOR11"
	E.db.mMT.dockdatatext.notification.icon = "FILLED27"
	E.db.mMT.dockdatatext.profession.icon = "COLOR06"
	E.db.mMT.dockdatatext.quest.icon = "COLOR26"
	E.db.mMT.dockdatatext.spellbook.icon = "COLOR46"
	E.db.mMT.dockdatatext.talent.icon = "COLOR45"
	E.db.mMT.dockdatatext.volume.icon = "COLOR62"

	E.db.mMT.dockdatatext.calendar.option = "de"
	E.db.mMT.dockdatatext.calendar.showyear = true
	E.db.mMT.dockdatatext.customfontzise = false
	E.db.mMT.dockdatatext.font = settings.font
	E.db.mMT.dockdatatext.fontSize = settings.fontSize
	E.db.mMT.dockdatatext.fontcolor.b = 0.10
	E.db.mMT.dockdatatext.fontcolor.g = 0
	E.db.mMT.dockdatatext.fontcolor.r = 0.96
	E.db.mMT.dockdatatext.fontflag = settings.fontflag
	E.db.mMT.dockdatatext.itemlevel.onlytext = true
	E.db.mMT.dockdatatext.itemlevel.text = "GS "

	if settings.top then
		E.db["movers"]["DTPanelmMT DockMover"] = "TOP,ElvUIParent,TOP,0,-5"
	else
		E.db["movers"]["DTPanelmMT DockMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,5"
	end

	E:StaggeredUpdateAll(nil, true)
end

function mMT:Dock_Extra(settings)
	-- reset mmt settings
	ResetSettings()

	-- reset panels
	DeletePanels()

	-- short db paths
	local globalDB = E.global.datatexts.customPanels
	local db = E.db.datatexts.panels

	-- use default font settings if they are not set
	local font = settings.font or "Montserrat-SemiBold"
	local fontflag = settings.fontflag or "SHADOW"
	local size = settings.fontsize or 14

	-- panels list and settings
	local panels = {
		["mMT Extra Clock"] = { width = 188, numPoints = 1, double = true, height = 30 },
		["mMT Extra Icons"] = { width = 428, numPoints = 10, double = false, height = 30 },
		["mMT Extra Infos"] = { width = 618, numPoints = 4, double = false, height = 22 },
	}

	-- build custom panels
	for name, setting in pairs(panels) do
		if not globalDB[name] then
			E.DataTexts:BuildPanelFrame(name)
		end

		globalDB[name].backdrop = settings.bg
		globalDB[name].border = settings.bg
		globalDB[name].fonts.enable = true
		globalDB[name].fonts.font = font
		globalDB[name].fonts.fontOutline = fontflag
		globalDB[name].fonts.fontSize = setting.double and (size + size) or size
		globalDB[name].height = setting.height
		globalDB[name].name = name
		globalDB[name].numPoints = setting.numPoints
		globalDB[name].panelTransparency = true
		globalDB[name].visibility = ""
		globalDB[name].width = setting.width
	end

	-- set the settings for the panels
	for name, _ in pairs(panels) do
		db[name].battleground = false
		db[name].enable = true
	end

	E.db.datatexts.panels["mMT Extra Clock"][1] = "Time"
	E.db.datatexts.panels["mMT Extra Clock"][2] = ""
	E.db.datatexts.panels["mMT Extra Clock"][3] = ""
	E.db.datatexts.panels["mMT Extra Clock"]["battleground"] = false
	E.db.datatexts.panels["mMT Extra Clock"]["enable"] = true

	E.db.datatexts.panels["mMT Extra Icons"][1] = "mMT_Dock_Character"
	E.db.datatexts.panels["mMT Extra Icons"][2] = "mMT_Dock_SpellBook"
	E.db.datatexts.panels["mMT Extra Icons"][3] = E.Retail and "mMT_Dock_Talent" or "mMT_Dock_Friends"
	E.db.datatexts.panels["mMT Extra Icons"][4] = "mMT_Dock_Achievement"
	E.db.datatexts.panels["mMT Extra Icons"][5] = "mMT_Dock_Quest"
	E.db.datatexts.panels["mMT Extra Icons"][6] = "mMT_Dock_LFDTool"
	E.db.datatexts.panels["mMT Extra Icons"][7] = "mMT_Dock_EncounterJournal"
	E.db.datatexts.panels["mMT Extra Icons"][8] = "mMT_Dock_CollectionsJournal"
	E.db.datatexts.panels["mMT Extra Icons"][9] = E.Cata and "mMT_Dock_Profession" or "mMT_Dock_BlizzardStore"
	E.db.datatexts.panels["mMT Extra Icons"][10] = "mMT_Dock_MainMenu"
	E.db.datatexts.panels["mMT Extra Icons"]["battleground"] = false
	E.db.datatexts.panels["mMT Extra Icons"]["enable"] = true

	E.db.datatexts.panels["mMT Extra Infos"][4] = "System"
	E.db.datatexts.panels["mMT Extra Infos"][3] = "secondProf"
	E.db.datatexts.panels["mMT Extra Infos"][2] = "firstProf"
	E.db.datatexts.panels["mMT Extra Infos"][1] = E.Retail and "Talent/Loot Specialization" or "Reputation"
	E.db.datatexts.panels["mMT Extra Infos"]["enable"] = true
	E.db.datatexts.panels["mMT Extra Infos"]["battleground"] = false

	E.db.mMT.dockdatatext.achievement.icon = "MATERIAL01"
	E.db.mMT.dockdatatext.blizzardstore.icon = "MATERIAL14"
	E.db.mMT.dockdatatext.calendar.option = "de"
	E.db.mMT.dockdatatext.calendar.showyear = true
	E.db.mMT.dockdatatext.character.icon = "MATERIAL30"
	E.db.mMT.dockdatatext.collection.icon = "MATERIAL33"
	E.db.mMT.dockdatatext.encounter.icon = "MATERIAL50"
	E.db.mMT.dockdatatext.font = font
	E.db.mMT.dockdatatext.fontSize = size
	E.db.mMT.dockdatatext.fontcolor.b = 0.10588236153126
	E.db.mMT.dockdatatext.fontcolor.g = 0
	E.db.mMT.dockdatatext.fontcolor.r = 0.96862751245499
	E.db.mMT.dockdatatext.fontflag = fontflag
	E.db.mMT.dockdatatext.friends.icon = "MATERIAL28"
	E.db.mMT.dockdatatext.hover.style = "custom"
	E.db.mMT.dockdatatext.itemlevel.onlytext = true
	E.db.mMT.dockdatatext.itemlevel.text = "GS "
	E.db.mMT.dockdatatext.lfd.icon = "MATERIAL48"
	E.db.mMT.dockdatatext.mainmenu.icon = "MATERIAL52"
	E.db.mMT.dockdatatext.profession.icon = "MATERIAL25"
	E.db.mMT.dockdatatext.quest.icon = "MATERIAL41"
	E.db.mMT.dockdatatext.spellbook.icon = "MATERIAL22"
	E.db.mMT.dockdatatext.talent.icon = "MATERIAL42"

	if settings.top then
		E.db["movers"]["DTPanelmMT Extra ClockMover"] = "TOP,ElvUIParent,TOP,-215,-4"
		E.db["movers"]["DTPanelmMT Extra IconsMover"] = "TOP,UIParent,TOP,95,-4"
		E.db["movers"]["DTPanelmMT Extra InfosMover"] = "TOP,UIParent,TOP,0,-36"
	else
		E.db["movers"]["DTPanelmMT Extra ClockMover"] = "BOTTOM,ElvUIParent,BOTTOM,-215,4"
		E.db["movers"]["DTPanelmMT Extra IconsMover"] = "BOTTOM,UIParent,BOTTOM,95,4"
		E.db["movers"]["DTPanelmMT Extra InfosMover"] = "BOTTOM,UIParent,BOTTOM,0,36"
	end

	E:StaggeredUpdateAll(nil, true)
end

function mMT:Currency(settings)
	-- short db paths
	local globalDB = E.global.datatexts.customPanels
	local db = E.db.datatexts.panels

	-- use default font settings if they are not set
	local font = settings.font or "Montserrat-SemiBold"
	local fontflag = settings.fontflag or "SHADOW"
	local size = settings.fontsize or 14

	-- build custom panels
	if not globalDB["MaUI Currencies"] then
		E.DataTexts:BuildPanelFrame("MaUI Currencies")
	end

	globalDB["MaUI Currencies"].backdrop = false
	globalDB["MaUI Currencies"].border = false
	globalDB["MaUI Currencies"].fonts.enable = true
	globalDB["MaUI Currencies"].fonts.font = font
	globalDB["MaUI Currencies"].fonts.fontOutline = fontflag
	globalDB["MaUI Currencies"].fonts.fontSize = size
	globalDB["MaUI Currencies"].growth = "VERTICAL"
	globalDB["MaUI Currencies"].height = 260
	globalDB["MaUI Currencies"].name = "MaUI Currencies"
	globalDB["MaUI Currencies"].numPoints = 12
	globalDB["MaUI Currencies"].textJustify = "LEFT"
	globalDB["MaUI Currencies"].width = 200

	db["MaUI Currencies"][1] = "mElementalOverflow"
	db["MaUI Currencies"][2] = "mDragonIslesSupplies"
	db["MaUI Currencies"][3] = "mFlightstones"
	db["MaUI Currencies"][4] = "mTimewarpedBadge"
	db["MaUI Currencies"][5] = "mWhelpling"
	db["MaUI Currencies"][6] = "mDrake"
	db["MaUI Currencies"][7] = "mWyrm"
	db["MaUI Currencies"][8] = "mAspect"
	db["MaUI Currencies"][9] = ""
	db["MaUI Currencies"][10] = ""
	db["MaUI Currencies"][11] = ""
	db["MaUI Currencies"][12] = ""
	db["MaUI Currencies"][13] = ""
	db["MaUI Currencies"][14] = ""
	db["MaUI Currencies"].battleground = false
	db["MaUI Currencies"].enable = true

	E.db["movers"]["DTPanelMaUI CurrenciesMover"] = "TOPLEFT,UIParent,TOPLEFT,4,-4"

	E:StaggeredUpdateAll(nil, true)
end

function mMT:Location(settings)
	-- short db paths
	local globalDB = E.global.datatexts.customPanels
	local db = E.db.datatexts.panels

	-- use default font settings if they are not set
	local font = settings.font or "Montserrat-SemiBold"
	local fontflag = settings.fontflag or "SHADOW"
	local size = settings.fontsize or 14

	-- panels list and settings
	local panels = {
		["mMT - Location"] = { width = 300, numPoints = 1, double = false, height = 32 },
		["mMT - Location X"] = { width = 100, numPoints = 1, double = false, height = 32 },
		["mMT - Location Y"] = { width = 100, numPoints = 1, double = false, height = 32 },
	}

	-- build custom panels
	for name, setting in pairs(panels) do
		if not globalDB[name] then
			E.DataTexts:BuildPanelFrame(name)
		end

		globalDB[name].backdrop = settings.bg
		globalDB[name].border = settings.bg
		globalDB[name].fonts.enable = true
		globalDB[name].fonts.font = font
		globalDB[name].fonts.fontOutline = fontflag
		globalDB[name].fonts.fontSize = setting.double and (size + size) or size
		globalDB[name].height = setting.height
		globalDB[name].name = name
		globalDB[name].numPoints = setting.numPoints
		globalDB[name].panelTransparency = true
		globalDB[name].visibility = ""
		globalDB[name].width = setting.width
	end

	db["mMT - Location"][1] = "Location"
	db["mMT - Location"]["battleground"] = false
	db["mMT - Location"]["enable"] = true
	db["mMT - Location X"][1] = "mCoordsX"
	db["mMT - Location X"]["battleground"] = false
	db["mMT - Location X"]["enable"] = true
	db["mMT - Location Y"][1] = "mCoordsY"
	db["mMT - Location Y"]["battleground"] = false
	db["mMT - Location Y"]["enable"] = true

	if settings.top then
		E.db["movers"]["DTPanelmMT - Location XMover"] = "TOP,ElvUIParent,TOP,-202,-4"
		E.db["movers"]["DTPanelmMT - Location YMover"] = "TOP,ElvUIParent,TOP,202,-4"
		E.db["movers"]["DTPanelmMT - LocationMover"] = "TOP,UIParent,TOP,0,-4"
	else
		E.db["movers"]["DTPanelmMT - Location XMover"] = "BOTTOM,ElvUIParent,BOTTOM,-202,-4"
		E.db["movers"]["DTPanelmMT - Location YMover"] = "BOTTOM,ElvUIParent,BOTTOM,202,-4"
		E.db["movers"]["DTPanelmMT - LocationMover"] = "BOTTOM,UIParent,BOTTOM,0,-4"
	end

	E:StaggeredUpdateAll(nil, true)
end
