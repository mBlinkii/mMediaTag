local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local function ResetColors()
	E.db["mMT"]["dockdatatext"]["achievement"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["blizzardstore"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["character"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["collection"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["encounter"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["friends"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["guild"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["lfd"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["mainmenu"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["quest"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["spellbook"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["r"] = 1

	E.db["mMT"]["dockdatatext"]["profession"]["customcolor"] = false
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["b"] = 1
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["g"] = 1
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["r"] = 1
end

function mMT:DeleteAll()
	ResetColors()

	if E.global.datatexts.customPanels["mMT XIV Clock"] then
		E.Options.args.datatexts.args.panels.args["mMT XIV Clock"] = nil
		E.db.datatexts.panels["mMT XIV Clock"] = nil
		E.global.datatexts.customPanels["mMT XIV Clock"] = nil

		DT:ReleasePanel("mMT XIV Clock")
	end

	if E.global.datatexts.customPanels["mMT XIV Info"] then
		E.Options.args.datatexts.args.panels.args["mMT XIV Info"] = nil
		E.db.datatexts.panels["mMT XIV Info"] = nil
		E.global.datatexts.customPanels["mMT XIV Info"] = nil

		DT:ReleasePanel("mMT XIV Info")
	end

	if E.global.datatexts.customPanels["mMT XIV Left"] then
		E.Options.args.datatexts.args.panels.args["mMT XIV Left"] = nil
		E.db.datatexts.panels["mMT XIV Left"] = nil
		E.global.datatexts.customPanels["mMT XIV Left"] = nil

		DT:ReleasePanel("mMT XIV Left")
	end

	if E.global.datatexts.customPanels["mMT XIV Right"] then
		E.Options.args.datatexts.args.panels.args["mMT XIV Right"] = nil
		E.db.datatexts.panels["mMT XIV Right"] = nil
		E.global.datatexts.customPanels["mMT XIV Right"] = nil

		DT:ReleasePanel("mMT XIV Right")
	end

	if E.global.datatexts.customPanels["mMT XIV Talent"] then
		E.Options.args.datatexts.args.panels.args["mMT XIV Talent"] = nil
		E.db.datatexts.panels["mMT XIV Talent"] = nil
		E.global.datatexts.customPanels["mMT XIV Talent"] = nil

		DT:ReleasePanel("mMT XIV Talent")
	end

	if E.global.datatexts.customPanels["mMT XIV Profession"] then
		E.Options.args.datatexts.args.panels.args["mMT XIV Profession"] = nil
		E.db.datatexts.panels["mMT XIV Profession"] = nil
		E.global.datatexts.customPanels["mMT XIV Profession"] = nil

		DT:ReleasePanel("mMT XIV Profession")
	end

	if E.global.datatexts.customPanels["mMT Dock"] then
		E.Options.args.datatexts.args.panels.args["mMT Dock"] = nil
		E.db.datatexts.panels["mMT Dock"] = nil
		E.global.datatexts.customPanels["mMT Dock"] = nil

		DT:ReleasePanel("mMT Dock")
	end

	if E.global.datatexts.customPanels["mMT Extra Infos"] then
		E.Options.args.datatexts.args.panels.args["mMT Extra Infos"] = nil
		E.db.datatexts.panels["mMT Extra Infos"] = nil
		E.global.datatexts.customPanels["mMT Extra Infos"] = nil

		DT:ReleasePanel("mMT Extra Infos")
	end

	if E.global.datatexts.customPanels["mMT Extra Icons"] then
		E.Options.args.datatexts.args.panels.args["mMT Extra Icons"] = nil
		E.db.datatexts.panels["mMT Extra Icons"] = nil
		E.global.datatexts.customPanels["mMT Extra Icons"] = nil

		DT:ReleasePanel("mMT Extra Icons")
	end

	if E.global.datatexts.customPanels["mMT Extra Clock"] then
		E.Options.args.datatexts.args.panels.args["mMT Extra Clock"] = nil
		E.db.datatexts.panels["mMT Extra Clock"] = nil
		E.global.datatexts.customPanels["mMT Extra Clock"] = nil

		DT:ReleasePanel("mMT Extra Clock")
	end

	if E.global.datatexts.customPanels["MaUI Left"] then
		E.Options.args.datatexts.args.panels.args["MaUI Left"] = nil
		E.db.datatexts.panels["MaUI Left"] = nil
		E.global.datatexts.customPanels["MaUI Left"] = nil

		DT:ReleasePanel("MaUI Left")
	end

	if E.global.datatexts.customPanels["MaUI Right"] then
		E.Options.args.datatexts.args.panels.args["MaUI Right"] = nil
		E.db.datatexts.panels["MaUI Right"] = nil
		E.global.datatexts.customPanels["MaUI Right"] = nil

		DT:ReleasePanel("MaUI Right")
	end

	if E.global.datatexts.customPanels["MaUI Time"] then
		E.Options.args.datatexts.args.panels.args["MaUI Time"] = nil
		E.db.datatexts.panels["MaUI Time"] = nil
		E.global.datatexts.customPanels["MaUI Time"] = nil

		DT:ReleasePanel("MaUI Time")
	end

	if E.global.datatexts.customPanels["MaUI Time Left"] then
		E.Options.args.datatexts.args.panels.args["MaUI Time Left"] = nil
		E.db.datatexts.panels["MaUI Time Left"] = nil
		E.global.datatexts.customPanels["MaUI Time Left"] = nil

		DT:ReleasePanel("MaUI Time Left")
	end

	if E.global.datatexts.customPanels["MaUI Time Right"] then
		E.Options.args.datatexts.args.panels.args["MaUI Time Right"] = nil
		E.db.datatexts.panels["MaUI Time Right"] = nil
		E.global.datatexts.customPanels["MaUI Time Right"] = nil

		DT:ReleasePanel("MaUI Time Right")
	end

	if E.global.datatexts.customPanels["mMT Databar Background"] then
		E.Options.args.datatexts.args.panels.args["mMT Databar Background"] = nil
		E.db.datatexts.panels["mMT Databar Background"] = nil
		E.global.datatexts.customPanels["mMT Databar Background"] = nil

		DT:ReleasePanel("mMT Databar Background")
	end
end

function mMT:Dock_Default(top)
	ResetColors()

	E.DataTexts:BuildPanelFrame("mMT Dock")
	E.global.datatexts.customPanels["mMT Dock"]["backdrop"] = false
	E.global.datatexts.customPanels["mMT Dock"]["border"] = false
	E.global.datatexts.customPanels["mMT Dock"]["height"] = 32
	E.global.datatexts.customPanels["mMT Dock"]["name"] = "mMT Dock"
	E.global.datatexts.customPanels["mMT Dock"]["numPoints"] = 12
	E.global.datatexts.customPanels["mMT Dock"]["visibility"] = "[petbattle][combat]  hide; show"
	E.global.datatexts.customPanels["mMT Dock"]["width"] = 433

	E.db["datatexts"]["panels"]["mMT Dock"][1] = "mMT_Dock_Character"
	E.db["datatexts"]["panels"]["mMT Dock"][2] = "mMT_Dock_SpellBook"
	E.db["datatexts"]["panels"]["mMT Dock"][3] = E.Retail and "mMT_Dock_Talent" or "mMT_Dock_Friends"
	E.db["datatexts"]["panels"]["mMT Dock"][4] = "mMT_Dock_Achievement"
	E.db["datatexts"]["panels"]["mMT Dock"][5] = "mMT_Dock_Quest"
	E.db["datatexts"]["panels"]["mMT Dock"][6] = "mMT_Dock_LFDTool"
	E.db["datatexts"]["panels"]["mMT Dock"][7] = "mMT_Dock_EncounterJournal"
	E.db["datatexts"]["panels"]["mMT Dock"][8] = "mMT_Dock_CollectionsJournal"
	E.db["datatexts"]["panels"]["mMT Dock"][9] = "mMT_Dock_Calendar"
	E.db["datatexts"]["panels"]["mMT Dock"][10] = "mMT_Dock_Volume"
	E.db["datatexts"]["panels"]["mMT Dock"][11] = E.Cata and "mMT_Dock_Profession" or "mMT_Dock_BlizzardStore"
	E.db["datatexts"]["panels"]["mMT Dock"][12] = "mMT_Dock_MainMenu"
	E.db["datatexts"]["panels"]["mMT Dock"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT Dock"]["enable"] = true

	E.db["mMT"]["dockdatatext"]["achievement"]["icon"] = "COLOR35"
	E.db["mMT"]["dockdatatext"]["collection"]["icon"] = "COLOR05"
	E.db["mMT"]["dockdatatext"]["encounter"]["icon"] = "COLOR17"
	E.db["mMT"]["dockdatatext"]["talent"]["icon"] = "COLOR45"
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["icon"] = "COLOR01"
	E.db["mMT"]["dockdatatext"]["character"]["icon"] = "COLOR19"
	E.db["mMT"]["dockdatatext"]["guild"]["icon"] = "COLOR38"
	E.db["mMT"]["dockdatatext"]["lfd"]["icon"] = "COLOR27"
	E.db["mMT"]["dockdatatext"]["mainmenu"]["icon"] = "COLOR11"
	E.db["mMT"]["dockdatatext"]["quest"]["icon"] = "COLOR26"
	E.db["mMT"]["dockdatatext"]["spellbook"]["icon"] = "COLOR46"
	E.db["mMT"]["dockdatatext"]["friends"]["icon"] = "COLOR58"
	E.db["mMT"]["dockdatatext"]["fpsms"]["icon"] = "COLOR31"
	E.db["mMT"]["dockdatatext"]["durability"]["icon"] = "COLOR53"
	E.db["mMT"]["dockdatatext"]["itemlevel"]["icon"] = "COLOR50"
	E.db["mMT"]["dockdatatext"]["notification"]["icon"] = "FILLED27"
	E.db["mMT"]["dockdatatext"]["profession"]["icon"] = "COLOR06"
	E.db["mMT"]["dockdatatext"]["volume"]["icon"] = "COLOR62"
	E.db["mMT"]["dockdatatext"]["calendar"]["icon"] = "COLOR02"
	E.db["mMT"]["dockdatatext"]["bag"]["icon"] = "COLOR68"
	E.db["mMT"]["dockdatatext"]["friends"]["icon"] = "COLOR38"

	E.db["mMT"]["dockdatatext"]["calendar"]["option"] = "de"
	E.db["mMT"]["dockdatatext"]["calendar"]["showyear"] = true
	E.db["mMT"]["dockdatatext"]["fontSize"] = 12
	E.db["mMT"]["dockdatatext"]["customfontzise"] = false
	E.db["mMT"]["dockdatatext"]["fontcolor"]["b"] = 0.10
	E.db["mMT"]["dockdatatext"]["fontcolor"]["g"] = 0
	E.db["mMT"]["dockdatatext"]["fontcolor"]["r"] = 0.96
	E.db["mMT"]["dockdatatext"]["fontflag"] = "NONE"
	E.db["mMT"]["dockdatatext"]["itemlevel"]["onlytext"] = true
	E.db["mMT"]["dockdatatext"]["itemlevel"]["text"] = "GS "

	if top then
		E.db["movers"]["DTPanelmMT DockMover"] = "TOP,ElvUIParent,TOP,0,-5"
	else
		E.db["movers"]["DTPanelmMT DockMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,5"
	end

	E:StaggeredUpdateAll(nil, true)
end

function mMT:Dock_MaUI(top)
	ResetColors()

	E.DataTexts:BuildPanelFrame("MaUI Left")
	E.global["datatexts"]["customPanels"]["MaUI Left"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["MaUI Left"]["height"] = 32
	E.global["datatexts"]["customPanels"]["MaUI Left"]["name"] = "MaUI Left"
	E.global["datatexts"]["customPanels"]["MaUI Left"]["numPoints"] = 12
	E.global["datatexts"]["customPanels"]["MaUI Left"]["textJustify"] = "LEFT"
	E.global["datatexts"]["customPanels"]["MaUI Left"]["width"] = 460

	E.db["datatexts"]["panels"]["MaUI Left"][1] = "mMT_Dock_Character"
	E.db["datatexts"]["panels"]["MaUI Left"][2] = "mMT_Dock_SpellBook"
	E.db["datatexts"]["panels"]["MaUI Left"][3] = "mMT_Dock_Guild"
	E.db["datatexts"]["panels"]["MaUI Left"][4] = "mMT_Dock_Friends"
	E.db["datatexts"]["panels"]["MaUI Left"][5] = "mMT_Dock_Achievement"
	E.db["datatexts"]["panels"]["MaUI Left"][6] = "mMT_Dock_Quest"
	E.db["datatexts"]["panels"]["MaUI Left"][7] = "mMT_Dock_LFDTool"
	E.db["datatexts"]["panels"]["MaUI Left"][8] = "mMT_Dock_EncounterJournal"
	E.db["datatexts"]["panels"]["MaUI Left"][9] = "mMT_Dock_CollectionsJournal"
	E.db["datatexts"]["panels"]["MaUI Left"][10] = "mMT_Dock_Volume"
	E.db["datatexts"]["panels"]["MaUI Left"][11] = E.Cata and "mMT_Dock_Profession" or "mMT_Dock_BlizzardStore"
	E.db["datatexts"]["panels"]["MaUI Left"][12] = "mMT_Dock_Calendar"
	E.db["datatexts"]["panels"]["MaUI Left"]["battleground"] = false
	E.db["datatexts"]["panels"]["MaUI Left"]["enable"] = true

	E.DataTexts:BuildPanelFrame("MaUI Right")
	E.global["datatexts"]["customPanels"]["MaUI Right"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["MaUI Right"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["MaUI Right"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["MaUI Right"]["fonts"]["fontSize"] = 16
	E.global["datatexts"]["customPanels"]["MaUI Right"]["height"] = 32
	E.global["datatexts"]["customPanels"]["MaUI Right"]["name"] = "MaUI Right"
	E.global["datatexts"]["customPanels"]["MaUI Right"]["numPoints"] = 4
	E.global["datatexts"]["customPanels"]["MaUI Right"]["textJustify"] = "RIGHT"
	E.global["datatexts"]["customPanels"]["MaUI Right"]["width"] = 460

	E.db["datatexts"]["panels"]["MaUI Right"][1] = "System"
	E.db["datatexts"]["panels"]["MaUI Right"][2] = E.Retail and "M+ Score" or "Currencies"
	E.db["datatexts"]["panels"]["MaUI Right"][3] = E.Retail and "mTeleports" or "mGameMenu"
	E.db["datatexts"]["panels"]["MaUI Right"][4] = "Gold"
	E.db["datatexts"]["panels"]["MaUI Right"]["battleground"] = false
	E.db["datatexts"]["panels"]["MaUI Right"]["enable"] = true

	E.DataTexts:BuildPanelFrame("MaUI Time")
	E.global["datatexts"]["customPanels"]["MaUI Time"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["MaUI Time"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["MaUI Time"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["MaUI Time"]["fonts"]["fontSize"] = 32
	E.global["datatexts"]["customPanels"]["MaUI Time"]["height"] = 32
	E.global["datatexts"]["customPanels"]["MaUI Time"]["name"] = "MaUI Time"
	E.global["datatexts"]["customPanels"]["MaUI Time"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["MaUI Time"]["width"] = 128

	E.db["datatexts"]["panels"]["MaUI Time"][1] = "Time"
	E.db["datatexts"]["panels"]["MaUI Time"][2] = ""
	E.db["datatexts"]["panels"]["MaUI Time"][3] = ""
	E.db["datatexts"]["panels"]["MaUI Time"]["battleground"] = false
	E.db["datatexts"]["panels"]["MaUI Time"]["enable"] = true

	E.DataTexts:BuildPanelFrame("MaUI Time Left")
	E.global["datatexts"]["customPanels"]["MaUI Time Left"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["MaUI Time Left"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["MaUI Time Left"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["MaUI Time Left"]["fonts"]["fontSize"] = 16
	E.global["datatexts"]["customPanels"]["MaUI Time Left"]["height"] = 32
	E.global["datatexts"]["customPanels"]["MaUI Time Left"]["name"] = "MaUI Time Left"
	E.global["datatexts"]["customPanels"]["MaUI Time Left"]["numPoints"] = 2
	E.global["datatexts"]["customPanels"]["MaUI Time Left"]["width"] = 430

	E.db["datatexts"]["panels"]["MaUI Time Left"][1] = "DurabilityIlevel"
	E.db["datatexts"]["panels"]["MaUI Time Left"][2] = E.Retail and "Talent/Loot Specialization" or "Reputation"
	E.db["datatexts"]["panels"]["MaUI Time Left"][3] = ""
	E.db["datatexts"]["panels"]["MaUI Time Left"]["battleground"] = false
	E.db["datatexts"]["panels"]["MaUI Time Left"]["enable"] = true

	E.DataTexts:BuildPanelFrame("MaUI Time Right")
	E.global["datatexts"]["customPanels"]["MaUI Time Right"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["MaUI Time Right"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["MaUI Time Right"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["MaUI Time Right"]["fonts"]["fontSize"] = 16
	E.global["datatexts"]["customPanels"]["MaUI Time Right"]["height"] = 32
	E.global["datatexts"]["customPanels"]["MaUI Time Right"]["name"] = "MaUI Time Right"
	E.global["datatexts"]["customPanels"]["MaUI Time Right"]["numPoints"] = 2
	E.global["datatexts"]["customPanels"]["MaUI Time Right"]["width"] = 430

	E.db["datatexts"]["panels"]["MaUI Time Right"][1] = "firstProf"
	E.db["datatexts"]["panels"]["MaUI Time Right"][2] = "secondProf"
	E.db["datatexts"]["panels"]["MaUI Time Right"][3] = ""
	E.db["datatexts"]["panels"]["MaUI Time Right"]["battleground"] = false
	E.db["datatexts"]["panels"]["MaUI Time Right"]["enable"] = true

	E.db["mMT"]["dockdatatext"]["achievement"]["icon"] = "MAUI04"
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["b"] = 0.17254902422428
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["g"] = 0.16078431904316
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["r"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["icon"] = "MAUI20"
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["b"] = 0.53333336114883
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["g"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["r"] = 0
	E.db["mMT"]["dockdatatext"]["calendar"]["option"] = "de"
	E.db["mMT"]["dockdatatext"]["calendar"]["showyear"] = true
	E.db["mMT"]["dockdatatext"]["center"] = true
	E.db["mMT"]["dockdatatext"]["character"]["icon"] = "MAUI15"
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["b"] = 0.93725496530533
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["g"] = 0.20000001788139
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["r"] = 0.65098041296005
	E.db["mMT"]["dockdatatext"]["collection"]["icon"] = "MAUI31"
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["g"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["r"] = 0.11372549831867
	E.db["mMT"]["dockdatatext"]["customfontcolor"] = true
	E.db["mMT"]["dockdatatext"]["customfontzise"] = true
	E.db["mMT"]["dockdatatext"]["encounter"]["icon"] = "MAUI33"
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["g"] = 0.7294117808342
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["r"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["fontSize"] = 14
	E.db["mMT"]["dockdatatext"]["fontcolor"]["b"] = 0.10588236153126
	E.db["mMT"]["dockdatatext"]["fontcolor"]["g"] = 0.77254909276962
	E.db["mMT"]["dockdatatext"]["fontcolor"]["r"] = 0.086274512112141
	E.db["mMT"]["dockdatatext"]["fontflag"] = "SHADOW"
	E.db["mMT"]["dockdatatext"]["friends"]["icon"] = "MAUI40"
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["b"] = 0.53333336114883
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["g"] = 0.14117647707462
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["r"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["guild"]["icon"] = "MAUI01"
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["b"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["g"] = 0.18823531270027
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["r"] = 0.90196084976196
	E.db["mMT"]["dockdatatext"]["profession"]["icon"] = "COLOR06"
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["b"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["g"] = 0.18823531270027
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["r"] = 0.90196084976196
	E.db["mMT"]["dockdatatext"]["hover"]["b"] = 0.4078431725502
	E.db["mMT"]["dockdatatext"]["hover"]["g"] = 0.4078431725502
	E.db["mMT"]["dockdatatext"]["hover"]["r"] = 0.4078431725502
	E.db["mMT"]["dockdatatext"]["itemlevel"]["onlytext"] = true
	E.db["mMT"]["dockdatatext"]["itemlevel"]["text"] = "GS "
	E.db["mMT"]["dockdatatext"]["lfd"]["icon"] = "MAUI35"
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["g"] = 0.50588238239288
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["r"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["mainmenu"]["icon"] = "MAUI17"
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["b"] = 0.94509810209274
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["g"] = 0.20784315466881
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["r"] = 0.58823531866074
	E.db["mMT"]["dockdatatext"]["normal"]["a"] = 0.80718515813351
	E.db["mMT"]["dockdatatext"]["quest"]["icon"] = "MAUI10"
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["g"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["r"] = 0.69019609689713
	E.db["mMT"]["dockdatatext"]["spellbook"]["icon"] = "MAUI26"
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["g"] = 0.3137255012989
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["r"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["talent"]["icon"] = "MAUI03"
	E.db["mMT"]["dockdatatext"]["volume"]["icon"] = "MAUI16"

	if top then
		E.db["movers"]["DTPanelMaUI LeftMover"] = "TOPLEFT,UIParent,TOPLEFT,4,-4"
		E.db["movers"]["DTPanelMaUI RightMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-4,-4"
		E.db["movers"]["DTPanelMaUI Time LeftMover"] = "TOP,ElvUIParent,TOP,-280,-4"
		E.db["movers"]["DTPanelMaUI Time RightMover"] = "TOP,ElvUIParent,TOP,280,-1"
		E.db["movers"]["DTPanelMaUI TimeMover"] = "TOP,UIParent,TOP,0,-4"
	else
		E.db["movers"]["DTPanelMaUI LeftMover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,4"
		E.db["movers"]["DTPanelMaUI RightMover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-4,4"
		E.db["movers"]["DTPanelMaUI Time LeftMover"] = "BOTTOM,ElvUIParent,BOTTOM,-280,4"
		E.db["movers"]["DTPanelMaUI Time RightMover"] = "BOTTOM,ElvUIParent,BOTTOM,280,4"
		E.db["movers"]["DTPanelMaUI TimeMover"] = "BOTTOM,UIParent,BOTTOM,0,1"
	end

	E:StaggeredUpdateAll(nil, true)
end

function mMT:Dock_BG(top)
	E.DataTexts:BuildPanelFrame("mMT Databar Background")
	E.global["datatexts"]["customPanels"]["mMT Databar Background"]["frameStrata"] = "BACKGROUND"
	E.global["datatexts"]["customPanels"]["mMT Databar Background"]["height"] = 32
	E.global["datatexts"]["customPanels"]["mMT Databar Background"]["name"] = "mMT Databar Background"
	E.global["datatexts"]["customPanels"]["mMT Databar Background"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mMT Databar Background"]["panelTransparency"] = true
	E.global["datatexts"]["customPanels"]["mMT Databar Background"]["width"] = GetScreenWidth() or 1920

	E.db["datatexts"]["panels"]["mMT Databar Background"][1] = ""
	E.db["datatexts"]["panels"]["mMT Databar Background"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT Databar Background"]["enable"] = true

	if top then
		E.db["movers"]["DTPanelmMT Databar BackgroundMover"] = "TOP,ElvUIParent,TOP,0,-4"
	else
		E.db["movers"]["DTPanelmMT Databar BackgroundMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
	end
	E:StaggeredUpdateAll(nil, true)
end

function mMT:Dock_XIVLike(top)
	ResetColors()

	E.DataTexts:BuildPanelFrame("mMT XIV Clock")
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["border"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["fonts"]["font"] = "Montserrat-SemiBold"
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["fonts"]["fontSize"] = 32
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["name"] = "mMT XIV Clock"
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mMT XIV Clock"]["width"] = 125

	E.DataTexts:BuildPanelFrame("mMT XIV Info")
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["border"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["fonts"]["font"] = "Montserrat-Medium"
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["fonts"]["fontSize"] = 16
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["height"] = 28
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["name"] = "mMT XIV Info"
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mMT XIV Info"]["width"] = 162

	E.DataTexts:BuildPanelFrame("mMT XIV Left")
	E.global["datatexts"]["customPanels"]["mMT XIV Left"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Left"]["border"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Left"]["height"] = 28
	E.global["datatexts"]["customPanels"]["mMT XIV Left"]["name"] = "mMT XIV Left"
	E.global["datatexts"]["customPanels"]["mMT XIV Left"]["numPoints"] = 11
	E.global["datatexts"]["customPanels"]["mMT XIV Left"]["width"] = 440

	E.DataTexts:BuildPanelFrame("mMT XIV Right")
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["border"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["fonts"]["font"] = "Montserrat-Medium"
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["fonts"]["fontSize"] = 14
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["height"] = 28
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["name"] = "mMT XIV Right"
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["numPoints"] = 4
	E.global["datatexts"]["customPanels"]["mMT XIV Right"]["width"] = 440

	E.DataTexts:BuildPanelFrame("mMT XIV Talent")
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["border"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["fonts"]["font"] = "Montserrat-Medium"
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["fonts"]["fontSize"] = 14
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["height"] = 28
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["name"] = "mMT XIV Talent"
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mMT XIV Talent"]["width"] = 240

	E.DataTexts:BuildPanelFrame("mMT XIV Profession")
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["border"] = false
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["fonts"]["font"] = "Montserrat-Medium"
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["fonts"]["fontOutline"] = "SHADOW"
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["fonts"]["fontSize"] = 14
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["height"] = 28
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["name"] = "mMT XIV Profession"
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["numPoints"] = 2
	E.global["datatexts"]["customPanels"]["mMT XIV Profession"]["width"] = 430

	E.db["datatexts"]["panels"]["mMT XIV Clock"][1] = "Time"
	E.db["datatexts"]["panels"]["mMT XIV Clock"][2] = ""
	E.db["datatexts"]["panels"]["mMT XIV Clock"][3] = ""
	E.db["datatexts"]["panels"]["mMT XIV Clock"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT XIV Clock"]["enable"] = true

	E.db["datatexts"]["panels"]["mMT XIV Info"][1] = "DurabilityIlevel"
	E.db["datatexts"]["panels"]["mMT XIV Info"][2] = ""
	E.db["datatexts"]["panels"]["mMT XIV Info"][3] = ""
	E.db["datatexts"]["panels"]["mMT XIV Info"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT XIV Info"]["enable"] = true

	E.db["datatexts"]["panels"]["mMT XIV Left"][1] = "mMT_Dock_MainMenu"
	E.db["datatexts"]["panels"]["mMT XIV Left"][2] = "mMT_Dock_Character"
	E.db["datatexts"]["panels"]["mMT XIV Left"][3] = "mMT_Dock_Guild"
	E.db["datatexts"]["panels"]["mMT XIV Left"][4] = "mMT_Dock_Friends"
	E.db["datatexts"]["panels"]["mMT XIV Left"][5] = "mMT_Dock_Achievement"
	E.db["datatexts"]["panels"]["mMT XIV Left"][6] = "mMT_Dock_SpellBook"
	E.db["datatexts"]["panels"]["mMT XIV Left"][7] = "mMT_Dock_LFDTool"
	E.db["datatexts"]["panels"]["mMT XIV Left"][8] = "mMT_Dock_EncounterJournal"
	E.db["datatexts"]["panels"]["mMT XIV Left"][9] = "mMT_Dock_Quest"
	E.db["datatexts"]["panels"]["mMT XIV Left"][10] = "mMT_Dock_CollectionsJournal"
	E.db["datatexts"]["panels"]["mMT XIV Left"][11] = E.Cata and "mMT_Dock_Profession" or "mMT_Dock_BlizzardStore"
	E.db["datatexts"]["panels"]["mMT XIV Left"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT XIV Left"]["enable"] = true

	E.db["datatexts"]["panels"]["mMT XIV Right"][1] = "mFPS"
	E.db["datatexts"]["panels"]["mMT XIV Right"][2] = E.Retail and "M+ Score" or "Currencies"
	E.db["datatexts"]["panels"]["mMT XIV Right"][3] = E.Retail and "mTeleports" or "mGameMenu"
	E.db["datatexts"]["panels"]["mMT XIV Right"][4] = "Gold"
	E.db["datatexts"]["panels"]["mMT XIV Right"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT XIV Right"]["enable"] = true

	E.db["datatexts"]["panels"]["mMT XIV Talent"][1] = E.Retail and "Talent/Loot Specialization" or "Reputation"
	E.db["datatexts"]["panels"]["mMT XIV Talent"][2] = ""
	E.db["datatexts"]["panels"]["mMT XIV Talent"][3] = ""
	E.db["datatexts"]["panels"]["mMT XIV Talent"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT XIV Talent"]["enable"] = true

	E.db["datatexts"]["panels"]["mMT XIV Profession"][1] = "firstProf"
	E.db["datatexts"]["panels"]["mMT XIV Profession"][2] = "secondProf"
	E.db["datatexts"]["panels"]["mMT XIV Profession"][3] = ""
	E.db["datatexts"]["panels"]["mMT XIV Profession"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT XIV Profession"]["enable"] = true

	E.db["mMT"]["dockdatatext"]["achievement"]["icon"] = "MATERIAL01"
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["icon"] = "MATERIAL14"
	E.db["mMT"]["dockdatatext"]["character"]["icon"] = "MATERIAL12"
	E.db["mMT"]["dockdatatext"]["collection"]["icon"] = "MATERIAL33"
	E.db["mMT"]["dockdatatext"]["encounter"]["icon"] = "MATERIAL42"
	E.db["mMT"]["dockdatatext"]["friends"]["icon"] = "MATERIAL28"
	E.db["mMT"]["dockdatatext"]["guild"]["icon"] = "MATERIAL35"
	E.db["mMT"]["dockdatatext"]["lfd"]["icon"] = "MATERIAL11"
	E.db["mMT"]["dockdatatext"]["mainmenu"]["icon"] = "MATERIAL52"
	E.db["mMT"]["dockdatatext"]["quest"]["icon"] = "MATERIAL41"
	E.db["mMT"]["dockdatatext"]["spellbook"]["icon"] = "MATERIAL22"
	E.db["mMT"]["dockdatatext"]["profession"]["icon"] = "MATERIAL25"

	E.db["mMT"]["dockdatatext"]["calendar"]["option"] = "de"
	E.db["mMT"]["dockdatatext"]["calendar"]["showyear"] = true

	E.db["mMT"]["dockdatatext"]["center"] = true
	E.db["mMT"]["dockdatatext"]["customfontcolor"] = true
	E.db["mMT"]["dockdatatext"]["customfontzise"] = true

	E.db["mMT"]["dockdatatext"]["font"] = "Montserrat-SemiBold"
	E.db["mMT"]["dockdatatext"]["fontSize"] = 14
	E.db["mMT"]["dockdatatext"]["fontflag"] = "SHADOW"
	E.db["mMT"]["dockdatatext"]["fontcolor"]["b"] = 0.10588236153126
	E.db["mMT"]["dockdatatext"]["fontcolor"]["g"] = 0.77254909276962
	E.db["mMT"]["dockdatatext"]["fontcolor"]["r"] = 0.086274512112141

	E.db["mMT"]["dockdatatext"]["hover"]["style"] = "class"

	E.db["mMT"]["dockdatatext"]["itemlevel"]["onlytext"] = true
	E.db["mMT"]["dockdatatext"]["itemlevel"]["text"] = "GS "

	if top then
		E.db["movers"]["DTPanelmDockMover"] = "TOP,ElvUIParent,TOP,0,-4"

		E.db["movers"]["DTPanelmMT XIV ClockMover"] = "TOP,ElvUIParent,TOP,0,-10"
		E.db["movers"]["DTPanelmMT XIV InfoMover"] = "TOPLEFT,UIParent,TOPLEFT,467,-4"
		E.db["movers"]["DTPanelmMT XIV LeftMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,14,-4"
		E.db["movers"]["DTPanelmMT XIV RightMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-4,-4"
		E.db["movers"]["DTPanelmMT XIV TalentMover"] = "TOP,UIParent,TOP,-204,-4"
		E.db["movers"]["DTPanelmMT XIV ProfessionMover"] = "TOP,UIParent,TOP,286,-4"
	else
		E.db["movers"]["DTPanelmMT XIV ClockMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,10"
		E.db["movers"]["DTPanelmMT XIV InfoMover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,467,4"
		E.db["movers"]["DTPanelmMT XIV LeftMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,14,4"
		E.db["movers"]["DTPanelmMT XIV RightMover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-4,4"
		E.db["movers"]["DTPanelmMT XIV TalentMover"] = "BOTTOM,UIParent,BOTTOM,-204,4"
		E.db["movers"]["DTPanelmMT XIV ProfessionMover"] = "BOTTOM,UIParent,BOTTOM,286,4"
	end

	E:StaggeredUpdateAll(nil, true)
end

function mMT:Dock_XIVLike_Color(top)
	mMT:Dock_XIVLike(top)

	E.db["mMT"]["dockdatatext"]["achievement"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["b"] = 0.17254902422428
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["g"] = 0.16078431904316
	E.db["mMT"]["dockdatatext"]["achievement"]["iconcolor"]["r"] = 0.92549026012421

	E.db["mMT"]["dockdatatext"]["blizzardstore"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["b"] = 0.53333336114883
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["g"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["iconcolor"]["r"] = 0

	E.db["mMT"]["dockdatatext"]["profession"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["b"] = 0.53333336114883
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["g"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["profession"]["iconcolor"]["r"] = 0

	E.db["mMT"]["dockdatatext"]["character"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["b"] = 0.93725496530533
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["g"] = 0.20000001788139
	E.db["mMT"]["dockdatatext"]["character"]["iconcolor"]["r"] = 0.65098041296005

	E.db["mMT"]["dockdatatext"]["collection"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["g"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["collection"]["iconcolor"]["r"] = 0.11372549831867

	E.db["mMT"]["dockdatatext"]["encounter"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["g"] = 0.7294117808342
	E.db["mMT"]["dockdatatext"]["encounter"]["iconcolor"]["r"] = 0.92549026012421

	E.db["mMT"]["dockdatatext"]["friends"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["b"] = 0.53333336114883
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["g"] = 0.14117647707462
	E.db["mMT"]["dockdatatext"]["friends"]["iconcolor"]["r"] = 0.92549026012421

	E.db["mMT"]["dockdatatext"]["guild"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["b"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["g"] = 0.18823531270027
	E.db["mMT"]["dockdatatext"]["guild"]["iconcolor"]["r"] = 0.90196084976196

	E.db["mMT"]["dockdatatext"]["lfd"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["g"] = 0.50588238239288
	E.db["mMT"]["dockdatatext"]["lfd"]["iconcolor"]["r"] = 0.92549026012421

	E.db["mMT"]["dockdatatext"]["mainmenu"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["b"] = 0.94509810209274
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["g"] = 0.20784315466881
	E.db["mMT"]["dockdatatext"]["mainmenu"]["iconcolor"]["r"] = 0.58823531866074

	E.db["mMT"]["dockdatatext"]["quest"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["g"] = 0.92549026012421
	E.db["mMT"]["dockdatatext"]["quest"]["iconcolor"]["r"] = 0.69019609689713

	E.db["mMT"]["dockdatatext"]["spellbook"]["customcolor"] = true
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["b"] = 0
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["g"] = 0.3137255012989
	E.db["mMT"]["dockdatatext"]["spellbook"]["iconcolor"]["r"] = 0.92549026012421
end

function mMT:Dock_Extra(top)
	ResetColors()

	E.DataTexts:BuildPanelFrame("mMT Extra Clock")
	E.global.datatexts.customPanels["mMT Extra Clock"]["fonts"]["enable"] = true
	E.global.datatexts.customPanels["mMT Extra Clock"]["fonts"]["font"] = "Montserrat-Bold"
	E.global.datatexts.customPanels["mMT Extra Clock"]["fonts"]["fontOutline"] = "SHADOW"
	E.global.datatexts.customPanels["mMT Extra Clock"]["fonts"]["fontSize"] = 32
	E.global.datatexts.customPanels["mMT Extra Clock"]["height"] = 30
	E.global.datatexts.customPanels["mMT Extra Clock"]["name"] = "mMT Extra Clock"
	E.global.datatexts.customPanels["mMT Extra Clock"]["numPoints"] = 1
	E.global.datatexts.customPanels["mMT Extra Clock"]["panelTransparency"] = true
	E.global.datatexts.customPanels["mMT Extra Clock"]["width"] = 188

	E.DataTexts:BuildPanelFrame("mMT Extra Icons")
	E.global.datatexts.customPanels["mMT Extra Icons"]["height"] = 30
	E.global.datatexts.customPanels["mMT Extra Icons"]["name"] = "mMT Extra Icons"
	E.global.datatexts.customPanels["mMT Extra Icons"]["numPoints"] = 10
	E.global.datatexts.customPanels["mMT Extra Icons"]["panelTransparency"] = true
	E.global.datatexts.customPanels["mMT Extra Icons"]["width"] = 428

	E.DataTexts:BuildPanelFrame("mMT Extra Infos")
	E.global.datatexts.customPanels["mMT Extra Infos"]["fonts"]["enable"] = true
	E.global.datatexts.customPanels["mMT Extra Infos"]["fonts"]["font"] = "Montserrat-SemiBold"
	E.global.datatexts.customPanels["mMT Extra Infos"]["fonts"]["fontOutline"] = "SHADOW"
	E.global.datatexts.customPanels["mMT Extra Infos"]["name"] = "mMT Extra Infos"
	E.global.datatexts.customPanels["mMT Extra Infos"]["numPoints"] = 4
	E.global.datatexts.customPanels["mMT Extra Infos"]["panelTransparency"] = true
	E.global.datatexts.customPanels["mMT Extra Infos"]["width"] = 618

	E.db["datatexts"]["panels"]["mMT Extra Clock"][1] = "Time"
	E.db["datatexts"]["panels"]["mMT Extra Clock"][2] = ""
	E.db["datatexts"]["panels"]["mMT Extra Clock"][3] = ""
	E.db["datatexts"]["panels"]["mMT Extra Clock"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT Extra Clock"]["enable"] = true

	E.db["datatexts"]["panels"]["mMT Extra Icons"][1] = "mMT_Dock_Character"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][2] = "mMT_Dock_SpellBook"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][3] = E.Retail and "mMT_Dock_Talent" or "mMT_Dock_Friends"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][4] = "mMT_Dock_Achievement"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][5] = "mMT_Dock_Quest"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][6] = "mMT_Dock_LFDTool"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][7] = "mMT_Dock_EncounterJournal"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][8] = "mMT_Dock_CollectionsJournal"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][9] = E.Cata and "mMT_Dock_Profession" or "mMT_Dock_BlizzardStore"
	E.db["datatexts"]["panels"]["mMT Extra Icons"][10] = "mMT_Dock_MainMenu"
	E.db["datatexts"]["panels"]["mMT Extra Icons"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT Extra Icons"]["enable"] = true

	E.db["datatexts"]["panels"]["mMT Extra Infos"][1] = E.Retail and "Talent/Loot Specialization" or "Reputation"
	E.db["datatexts"]["panels"]["mMT Extra Infos"][2] = "firstProf"
	E.db["datatexts"]["panels"]["mMT Extra Infos"][3] = "secondProf"
	E.db["datatexts"]["panels"]["mMT Extra Infos"][4] = "System"
	E.db["datatexts"]["panels"]["mMT Extra Infos"]["battleground"] = false
	E.db["datatexts"]["panels"]["mMT Extra Infos"]["enable"] = true

	E.db["mMT"]["dockdatatext"]["achievement"]["icon"] = "MATERIAL01"
	E.db["mMT"]["dockdatatext"]["blizzardstore"]["icon"] = "MATERIAL14"
	E.db["mMT"]["dockdatatext"]["calendar"]["option"] = "de"
	E.db["mMT"]["dockdatatext"]["calendar"]["showyear"] = true
	E.db["mMT"]["dockdatatext"]["character"]["icon"] = "MATERIAL30"
	E.db["mMT"]["dockdatatext"]["collection"]["icon"] = "MATERIAL33"
	E.db["mMT"]["dockdatatext"]["encounter"]["icon"] = "MATERIAL50"
	E.db["mMT"]["dockdatatext"]["font"] = "Montserrat-SemiBold"
	E.db["mMT"]["dockdatatext"]["fontSize"] = 20
	E.db["mMT"]["dockdatatext"]["fontcolor"]["b"] = 0.10588236153126
	E.db["mMT"]["dockdatatext"]["fontcolor"]["g"] = 0
	E.db["mMT"]["dockdatatext"]["fontcolor"]["r"] = 0.96862751245499
	E.db["mMT"]["dockdatatext"]["fontflag"] = "NONE"
	E.db["mMT"]["dockdatatext"]["hover"]["style"] = "custom"
	E.db["mMT"]["dockdatatext"]["itemlevel"]["onlytext"] = true
	E.db["mMT"]["dockdatatext"]["itemlevel"]["text"] = "GS "
	E.db["mMT"]["dockdatatext"]["lfd"]["icon"] = "MATERIAL48"
	E.db["mMT"]["dockdatatext"]["mainmenu"]["icon"] = "MATERIAL52"
	E.db["mMT"]["dockdatatext"]["quest"]["icon"] = "MATERIAL41"
	E.db["mMT"]["dockdatatext"]["spellbook"]["icon"] = "MATERIAL22"
	E.db["mMT"]["dockdatatext"]["talent"]["icon"] = "MATERIAL42"
	E.db["mMT"]["dockdatatext"]["profession"]["icon"] = "MATERIAL25"
	E.db["mMT"]["dockdatatext"]["friends"]["icon"] = "MATERIAL28"

	if top then
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
