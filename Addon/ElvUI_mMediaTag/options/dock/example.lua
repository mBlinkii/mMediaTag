local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")

local dock_style, dock_top, dock_bg = "XIV", false, false

local preview = {
	XIV = "Interface\\Addons\\ElvUI_mMediaTag\\media\\preview\\xiv.tga",
	XIVCOLORED = "Interface\\Addons\\ElvUI_mMediaTag\\media\\preview\\xivcolored.tga",
	MAUI = "Interface\\Addons\\ElvUI_mMediaTag\\media\\preview\\maui.tga",
	DOCK = "Interface\\Addons\\ElvUI_mMediaTag\\media\\preview\\dock.tga",
	DOCKV2 = "Interface\\Addons\\ElvUI_mMediaTag\\media\\preview\\dockv2.tga",
}

local docks = {
	XIV = L["XIV Like"],
	XIVCOLORED = L["XVI Like colored"],
	MAUI = L["MAUI"],
	DOCK = L["Dock"],
	DOCKV2 = L["Dock V2"],
}

local function ResetDB()
	E.db.mMediaTag.dock = {}
	E.db.mMediaTag.dock = CopyTable(P.dock)

    E.db.mMediaTag.color.dock = {}
    E.db.mMediaTag.color.dock = CopyTable(P.color.dock)
end

local function SetupDock()
	ResetDB()

	-- XIV DOCKS
	if dock_style == "XIV" or dock_style == "XIVCOLORED" or dock_style == "MAUI" then
		-- global
		if not E.global["datatexts"]["customPanels"]["mMT - CENTER"] then E.DataTexts:BuildPanelFrame("mMT - CENTER") end
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["backdrop"] = false
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["border"] = false
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["fonts"]["enable"] = true
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["fonts"]["fontOutline"] = "SHADOW"
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["fonts"]["fontSize"] = 28
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["height"] = 32
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["name"] = "mMT - CENTER"
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["numPoints"] = 1
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["visibility"] = ""
		E.global["datatexts"]["customPanels"]["mMT - CENTER"]["width"] = 180

		if not E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"] then E.DataTexts:BuildPanelFrame("mMT - EXTRA LEFT") end
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["backdrop"] = false
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["border"] = false
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["fonts"]["enable"] = true
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["fonts"]["fontOutline"] = "SHADOW"
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["fonts"]["fontSize"] = 14
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["height"] = 32
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["name"] = "mMT - EXTRA LEFT"
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["visibility"] = ""
		E.global["datatexts"]["customPanels"]["mMT - EXTRA LEFT"]["width"] = 644

		if not E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"] then E.DataTexts:BuildPanelFrame("mMT - EXTRA RIGHT") end
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["backdrop"] = false
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["border"] = false
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["fonts"]["enable"] = true
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["fonts"]["fontOutline"] = "SHADOW"
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["fonts"]["fontSize"] = 14
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["height"] = 32
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["name"] = "mMT - EXTRA RIGHT"
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["visibility"] = ""
		E.global["datatexts"]["customPanels"]["mMT - EXTRA RIGHT"]["width"] = 644

		if not E.global["datatexts"]["customPanels"]["mMT - LEFT"] then E.DataTexts:BuildPanelFrame("mMT - LEFT") end
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["backdrop"] = false
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["border"] = false
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["fonts"]["enable"] = true
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["fonts"]["fontOutline"] = "SHADOW"
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["fonts"]["fontSize"] = 14
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["height"] = 32
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["name"] = "mMT - LEFT"
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["numPoints"] = 12
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["visibility"] = ""
		E.global["datatexts"]["customPanels"]["mMT - LEFT"]["width"] = 540

		if not E.global["datatexts"]["customPanels"]["mMT - RIGHT"] then E.DataTexts:BuildPanelFrame("mMT - RIGHT") end
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["backdrop"] = false
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["border"] = false
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["fonts"]["enable"] = true
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["fonts"]["fontOutline"] = "SHADOW"
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["fonts"]["fontSize"] = 14
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["height"] = 32
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["name"] = "mMT - RIGHT"
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["numPoints"] = 4
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["visibility"] = ""
		E.global["datatexts"]["customPanels"]["mMT - RIGHT"]["width"] = 540

		-- movers
		if dock_top then
			E.db["movers"]["DTPanelmMT - CENTERMover"] = "TOP,UIParent,TOP,0,4"
			E.db["movers"]["DTPanelmMT - EXTRA LEFTMover"] = "TOP,ElvUIParent,TOP,-413,4"
			E.db["movers"]["DTPanelmMT - EXTRA RIGHTMover"] = "TOP,ElvUIParent,TOP,413,4"
			E.db["movers"]["DTPanelmMT - LEFTMover"] = "TOPLEFT,UIParent,TOPLEFT,4,4"
			E.db["movers"]["DTPanelmMT - RIGHTMover"] = "TOPRIGHT,UIParent,TOPRIGHT,-4,4"
		else
			E.db["movers"]["DTPanelmMT - CENTERMover"] = "BOTTOM,UIParent,BOTTOM,0,4"
			E.db["movers"]["DTPanelmMT - EXTRA LEFTMover"] = "BOTTOM,ElvUIParent,BOTTOM,-413,4"
			E.db["movers"]["DTPanelmMT - EXTRA RIGHTMover"] = "BOTTOM,ElvUIParent,BOTTOM,413,4"
			E.db["movers"]["DTPanelmMT - LEFTMover"] = "BOTTOMLEFT,UIParent,BOTTOMLEFT,4,4"
			E.db["movers"]["DTPanelmMT - RIGHTMover"] = "BOTTOMRIGHT,UIParent,BOTTOMRIGHT,-4,4"
		end

		-- settings
		E.db["datatexts"]["panels"]["mMT - RIGHT"][1] = "System"
		E.db["datatexts"]["panels"]["mMT - RIGHT"][2] = "mMT - M+ Score"
		E.db["datatexts"]["panels"]["mMT - RIGHT"][3] = "mMT - Teleports"
		E.db["datatexts"]["panels"]["mMT - RIGHT"][4] = "Gold"
		E.db["datatexts"]["panels"]["mMT - RIGHT"]["battleground"] = false
		E.db["datatexts"]["panels"]["mMT - RIGHT"]["enable"] = true

		E.db["datatexts"]["panels"]["mMT - CENTER"][1] = "Time"
		E.db["datatexts"]["panels"]["mMT - CENTER"][2] = ""
		E.db["datatexts"]["panels"]["mMT - CENTER"][3] = ""
		E.db["datatexts"]["panels"]["mMT - CENTER"]["battleground"] = false
		E.db["datatexts"]["panels"]["mMT - CENTER"]["enable"] = true

		E.db["datatexts"]["panels"]["mMT - EXTRA LEFT"][1] = "mMT - Durability & ItemLevel"
		E.db["datatexts"]["panels"]["mMT - EXTRA LEFT"][2] = "Difficulty"
		E.db["datatexts"]["panels"]["mMT - EXTRA LEFT"][3] = "Talent/Loot Specialization"
		E.db["datatexts"]["panels"]["mMT - EXTRA LEFT"]["battleground"] = false
		E.db["datatexts"]["panels"]["mMT - EXTRA LEFT"]["enable"] = true

		E.db["datatexts"]["panels"]["mMT - EXTRA RIGHT"][1] = "mMT - Primary Professions"
		E.db["datatexts"]["panels"]["mMT - EXTRA RIGHT"][2] = "mMT - Secondary Professions"
		E.db["datatexts"]["panels"]["mMT - EXTRA RIGHT"][3] = "mMT - Professions"
		E.db["datatexts"]["panels"]["mMT - EXTRA RIGHT"]["battleground"] = false
		E.db["datatexts"]["panels"]["mMT - EXTRA RIGHT"]["enable"] = true

		if dock_style == "XIV" or dock_style == "XIVCOLORED" then E.db["mMediaTag"]["datatexts"]["professions"]["icon"] = "prof_f" end

		if dock_style == "XIV" or dock_style == "XIVCOLORED" then
			E.db["datatexts"]["panels"]["mMT - LEFT"][1] = "mMT_Dock_Menu"
			E.db["datatexts"]["panels"]["mMT - LEFT"][2] = "mMT_Dock_Character"
			E.db["datatexts"]["panels"]["mMT - LEFT"][3] = "mMT_Dock_Friends"
			E.db["datatexts"]["panels"]["mMT - LEFT"][4] = "mMT_Dock_Guild"
			E.db["datatexts"]["panels"]["mMT - LEFT"][5] = "mMT_Dock_Achievement"
			E.db["datatexts"]["panels"]["mMT - LEFT"][6] = "mMT_Dock_SpellBook"
			E.db["datatexts"]["panels"]["mMT - LEFT"][7] = "mMT_Dock_LFD"
			E.db["datatexts"]["panels"]["mMT - LEFT"][8] = "mMT_Dock_EncounterJournal"
			E.db["datatexts"]["panels"]["mMT - LEFT"][9] = "mMT_Dock_Quest"
			E.db["datatexts"]["panels"]["mMT - LEFT"][10] = "mMT_Dock_CollectionsJournal"
			E.db["datatexts"]["panels"]["mMT - LEFT"][11] = "mMT_Dock_BlizzardStore"
			E.db["datatexts"]["panels"]["mMT - LEFT"][12] = "mMT_Dock_Mail"
			E.db["datatexts"]["panels"]["mMT - LEFT"]["battleground"] = false
			E.db["datatexts"]["panels"]["mMT - LEFT"]["enable"] = true
		end

		if dock_style == "XIVCOLORED" then
			E.db["mMediaTag"]["color"]["dock"]["achievement"] = "FFff0026"
			E.db["mMediaTag"]["color"]["dock"]["character"] = "FFf200ff"
			E.db["mMediaTag"]["color"]["dock"]["collection"] = "FF4dff00"
			E.db["mMediaTag"]["color"]["dock"]["encounter"] = "FFffd300"
			E.db["mMediaTag"]["color"]["dock"]["friends"] = "FFff00ad"
			E.db["mMediaTag"]["color"]["dock"]["guild"] = "FFff0075"
			E.db["mMediaTag"]["color"]["dock"]["lfd"] = "FFff8c00"
			E.db["mMediaTag"]["color"]["dock"]["mail"] = "FF00ff99"
			E.db["mMediaTag"]["color"]["dock"]["menu"] = "FFc000ff"
			E.db["mMediaTag"]["color"]["dock"]["quests"] = "FFcfff00"
			E.db["mMediaTag"]["color"]["dock"]["spellbook"] = "FFff4a00"
			E.db["mMediaTag"]["color"]["dock"]["store"] = "FF00ff41"

			E.db["mMediaTag"]["dock"]["achievement"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["character"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["collection"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["encounter"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["friends"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["guild"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["lfd"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["mail"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["menu"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["quests"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["spellbook"]["custom_color"] = true
			E.db["mMediaTag"]["dock"]["store"]["custom_color"] = true
		end

		if dock_style == "MAUI" then
			E.db["mMediaTag"]["color"]["dock"]["hover"] = "FF464646"

			E.db["mMediaTag"]["datatexts"]["durability_itemLevel"]["style"] = "d"

			E.db["mMediaTag"]["dock"]["class"]["hover"] = false

			E.db["mMediaTag"]["dock"]["achievement"]["icon"] = "maui_34"
			E.db["mMediaTag"]["dock"]["achievement"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["calendar"]["icon"] = "maui"
			E.db["mMediaTag"]["dock"]["character"]["icon"] = "maui_42"
			E.db["mMediaTag"]["dock"]["character"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["collection"]["icon"] = "maui_20"
			E.db["mMediaTag"]["dock"]["collection"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["encounter"]["icon"] = "maui_41"
			E.db["mMediaTag"]["dock"]["encounter"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["friends"]["icon"] = "maui_23"
			E.db["mMediaTag"]["dock"]["friends"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["guild"]["icon"] = "maui_03"
			E.db["mMediaTag"]["dock"]["guild"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["lfd"]["icon"] = "maui_18"
			E.db["mMediaTag"]["dock"]["lfd"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["mail"]["icon"] = "maui_25"
			E.db["mMediaTag"]["dock"]["mail"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["quests"]["icon"] = "maui_04"
			E.db["mMediaTag"]["dock"]["quests"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["spellbook"]["icon"] = "maui_40"
			E.db["mMediaTag"]["dock"]["spellbook"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["store"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["volume"]["icon"] = "maui_38"
			E.db["mMediaTag"]["dock"]["volume"]["style"] = "maui"

			E.db["datatexts"]["panels"]["mMT - LEFT"][1] = "mMT_Dock_Character"
			E.db["datatexts"]["panels"]["mMT - LEFT"][2] = "mMT_Dock_SpellBook"
			E.db["datatexts"]["panels"]["mMT - LEFT"][3] = "mMT_Dock_Friends"
			E.db["datatexts"]["panels"]["mMT - LEFT"][4] = "mMT_Dock_Guild"
			E.db["datatexts"]["panels"]["mMT - LEFT"][5] = "mMT_Dock_Achievement"
			E.db["datatexts"]["panels"]["mMT - LEFT"][6] = "mMT_Dock_Quest"
			E.db["datatexts"]["panels"]["mMT - LEFT"][7] = "mMT_Dock_LFD"
			E.db["datatexts"]["panels"]["mMT - LEFT"][8] = "mMT_Dock_EncounterJournal"
			E.db["datatexts"]["panels"]["mMT - LEFT"][9] = "mMT_Dock_CollectionsJournal"
			E.db["datatexts"]["panels"]["mMT - LEFT"][10] = "mMT_Dock_Volume"
			E.db["datatexts"]["panels"]["mMT - LEFT"][11] = "mMT_Dock_Calendar"
			E.db["datatexts"]["panels"]["mMT - LEFT"][12] = "mMT_Dock_Mail"
		end
	end

	-- DOCK

	if dock_style == "DOCK" or dock_style == "DOCKV2" then
		-- globals
		if not E.global["datatexts"]["customPanels"]["mMT - DOCK"] then E.DataTexts:BuildPanelFrame("mMT - DOCK") end
		E.global["datatexts"]["customPanels"]["mMT - DOCK"]["backdrop"] = false
		E.global["datatexts"]["customPanels"]["mMT - DOCK"]["height"] = 38
		E.global["datatexts"]["customPanels"]["mMT - DOCK"]["name"] = "mMT - DOCK"
		E.global["datatexts"]["customPanels"]["mMT - DOCK"]["numPoints"] = 12
		E.global["datatexts"]["customPanels"]["mMT - DOCK"]["width"] = 600

		if not E.global["datatexts"]["customPanels"]["mMT - DOCK COSMETICK"] then E.DataTexts:BuildPanelFrame("mMT - DOCK COSMETICK") end
		E.global["datatexts"]["customPanels"]["mMT - DOCK COSMETICK"]["height"] = 12
		E.global["datatexts"]["customPanels"]["mMT - DOCK COSMETICK"]["name"] = "mMT - DOCK COSMETICK"
		E.global["datatexts"]["customPanels"]["mMT - DOCK COSMETICK"]["numPoints"] = 1
		E.global["datatexts"]["customPanels"]["mMT - DOCK COSMETICK"]["panelTransparency"] = true
		E.global["datatexts"]["customPanels"]["mMT - DOCK COSMETICK"]["width"] = 640

		-- settings
		E.db["datatexts"]["panels"]["mMT - DOCK COSMETICK"][1] = ""
		E.db["datatexts"]["panels"]["mMT - DOCK COSMETICK"][2] = ""
		E.db["datatexts"]["panels"]["mMT - DOCK COSMETICK"][3] = ""
		E.db["datatexts"]["panels"]["mMT - DOCK COSMETICK"]["battleground"] = false
		E.db["datatexts"]["panels"]["mMT - DOCK COSMETICK"]["enable"] = true
		E.db["datatexts"]["panels"]["mMT - DOCK"]["battleground"] = false
		E.db["datatexts"]["panels"]["mMT - DOCK"]["enable"] = true

		if dock_style == "DOCK" then
			E.db["datatexts"]["panels"]["mMT - DOCK"][1] = "mMT_Dock_Character"
			E.db["datatexts"]["panels"]["mMT - DOCK"][2] = "mMT_Dock_SpellBook"
			E.db["datatexts"]["panels"]["mMT - DOCK"][3] = "mMT_Dock_Friends"
			E.db["datatexts"]["panels"]["mMT - DOCK"][4] = "mMT_Dock_Guild"
			E.db["datatexts"]["panels"]["mMT - DOCK"][5] = "mMT_Dock_Achievement"
			E.db["datatexts"]["panels"]["mMT - DOCK"][6] = "mMT_Dock_Quest"
			E.db["datatexts"]["panels"]["mMT - DOCK"][7] = "mMT_Dock_LFD"
			E.db["datatexts"]["panels"]["mMT - DOCK"][8] = "mMT_Dock_EncounterJournal"
			E.db["datatexts"]["panels"]["mMT - DOCK"][9] = "mMT_Dock_CollectionsJournal"
			E.db["datatexts"]["panels"]["mMT - DOCK"][10] = "mMT_Dock_Volume"
			E.db["datatexts"]["panels"]["mMT - DOCK"][11] = "mMT_Dock_BlizzardStore"
			E.db["datatexts"]["panels"]["mMT - DOCK"][12] = "mMT_Dock_Mail"
		else
			E.db["mMediaTag"]["dock"]["achievement"]["icon"] = "maui_34"
			E.db["mMediaTag"]["dock"]["achievement"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["calendar"]["icon"] = "maui"
			E.db["mMediaTag"]["dock"]["character"]["icon"] = "maui_42"
			E.db["mMediaTag"]["dock"]["character"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["class"]["hover"] = false
			E.db["mMediaTag"]["dock"]["collection"]["icon"] = "maui_20"
			E.db["mMediaTag"]["dock"]["collection"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["encounter"]["icon"] = "maui_41"
			E.db["mMediaTag"]["dock"]["encounter"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["friends"]["icon"] = "maui_23"
			E.db["mMediaTag"]["dock"]["friends"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["guild"]["icon"] = "maui_03"
			E.db["mMediaTag"]["dock"]["guild"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["lfd"]["icon"] = "maui_18"
			E.db["mMediaTag"]["dock"]["lfd"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["mail"]["icon"] = "maui_25"
			E.db["mMediaTag"]["dock"]["mail"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["quests"]["icon"] = "maui_04"
			E.db["mMediaTag"]["dock"]["quests"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["spellbook"]["icon"] = "maui_40"
			E.db["mMediaTag"]["dock"]["spellbook"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["store"]["style"] = "maui"
			E.db["mMediaTag"]["dock"]["volume"]["icon"] = "maui_38"
			E.db["mMediaTag"]["dock"]["volume"]["style"] = "maui"

			E.db["datatexts"]["panels"]["mMT - DOCK"][1] = "mMT_Dock_Character"
			E.db["datatexts"]["panels"]["mMT - DOCK"][2] = "mMT_Dock_SpellBook"
			E.db["datatexts"]["panels"]["mMT - DOCK"][3] = "mMT_Dock_Friends"
			E.db["datatexts"]["panels"]["mMT - DOCK"][4] = "mMT_Dock_Guild"
			E.db["datatexts"]["panels"]["mMT - DOCK"][5] = "mMT_Dock_Achievement"
			E.db["datatexts"]["panels"]["mMT - DOCK"][6] = "mMT_Dock_Quest"
			E.db["datatexts"]["panels"]["mMT - DOCK"][7] = "mMT_Dock_LFD"
			E.db["datatexts"]["panels"]["mMT - DOCK"][8] = "mMT_Dock_EncounterJournal"
			E.db["datatexts"]["panels"]["mMT - DOCK"][9] = "mMT_Dock_CollectionsJournal"
			E.db["datatexts"]["panels"]["mMT - DOCK"][10] = "mMT_Dock_Volume"
			E.db["datatexts"]["panels"]["mMT - DOCK"][11] = "mMT_Dock_Calendar"
			E.db["datatexts"]["panels"]["mMT - DOCK"][12] = "mMT_Dock_Mail"
		end

		-- movers
		if dock_top then
			E.db["movers"]["DTPanelmMT - DOCK COSMETICKMover"] = "TOP,UIParent,TOP,0,4"
			E.db["movers"]["DTPanelmMT - DOCKMover"] = "TOP,ElvUIParent,TOP,0,8"
		else
			E.db["movers"]["DTPanelmMT - DOCK COSMETICKMover"] = "BOTTOM,UIParent,BOTTOM,0,4"
			E.db["movers"]["DTPanelmMT - DOCKMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,8"
		end
	end

	-- update elvui
	E:StaggeredUpdateAll(nil, true)
end

local function DeleteDock() end

mMT.options.args.misc.args.custom_docks.args = {
	execute_apply = {
		order = 1,
		type = "execute",
		name = L["Apply"],
		func = function()
			SetupDock()
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	execute_delete = {
		order = 2,
		type = "execute",
		name = L["Delete all"],
		func = function()
			DeleteDock()
			E:StaticPopup_Show("CONFIG_RL")
		end,
	},
	Settings = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			dock_style = {
				order = 1,
				type = "select",
				name = L["Dock"],
				get = function(info)
					return dock_style
				end,
				set = function(info, value)
					dock_style = value
				end,
				values = docks,
			},
			top = {
				order = 2,
				type = "toggle",
				name = L["Dock on Top"],
				get = function(info)
					return dock_top
				end,
				set = function(info, value)
					dock_top = value
				end,
			},
		},
	},
	preview = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Preview"],
		args = {
			preview = {
				type = "description",
				name = "",
				order = 1,
				image = function()
					return preview[dock_style]
				end,
				imageWidth = 512,
				imageHeight = 128,
			},
		},
	},
}
