local E, L, V, P, G = unpack(ElvUI)

local _G = _G
local tinsert = tinsert
local tconcat = _G.table.concat

local license_general_text = {
	mMT.Name .. " License",
	"",
	"Copyright ©2009-2024 The contents of this addon, excluding third-party resources, are",
	"copyrighted to their authors with all rights reserved.",
	"",
	"This addon is free to use and the authors hereby grants you the following rights:",
	"",
	"- 1. 	You may make modifications to this addon for private use only, you may not redistribute any part of this addon.",
	"",
	"- 2. 	You cannot change the name of this addon, including the addon folders.",
	"",
	"- 3. 	This copyright notice must appear in all copies of the software.",
	"",
	"- 4. 	You may not redistribute the textures of this addon.",
	"",
	"All rights not explicitly addressed in this license are reserved by",
	"the copyright holders.",
}

local license_general_string = tconcat(license_general_text, "|n")

local license_materialicons_text = {
	"Google - Material Design Icons are available under material.io.",
	"",
	"The symbols are available under the APACHE LICENSE, VERSION 2.0.",
	"",
	"Icons were resized to 64x64 pixel and the color was changed.",
}
local license_materialicons_string = tconcat(license_materialicons_text, "|n")

local thanks_text = {
	"Simpy",
	"Azilroka",
	"Repooc",
	"Luckyone",
	"Eltreum",
	"Tsxy",
	"Merathilis",
	"Dalerija",
	"Jiberish",
	"Trenchy",
	"ElioteMarcondes",
	"Dlarge",
	"Tukui Community",
}
local thanks_string = tconcat(thanks_text, "|n")

local function configTable()
	E.Options.args.mMT.args.about.args = {
		header_about = {
			order = 1,
			type = "header",
			name = format("%s %s |CFFFFFFFFVer.|r |CFFF7DC6F%s|r", mMT.Icon, mMT.Name, mMT.Version),
		},
		help = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Help"],
			args = {
				contact = {
					order = 1,
					type = "execute",
					name = L["Contact"],
					func = function()
						E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "mmediatag@gmx.de")
					end,
				},
				git = {
					order = 2,
					type = "execute",
					name = L["Git"],
					func = function()
						E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "https://github.com/mBlinkii/mMediaTag/tree/main")
					end,
				},
				changelog = {
					order = 3,
					type = "execute",
					name = L["Changelog"],
					func = function()
						E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "changelog")
					end,
				},
			},
		},
		license = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Licens"],
			args = {
				license_general = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = "|CFFF7DC6F" .. license_general_string .. "|r",
				},
				spacer_license_1 = {
					order = 2,
					type = "description",
					name = "\n\n\n",
				},
				license_materialicons = {
					order = 3,
					type = "description",
					fontSize = "medium",
					name = "|CFF00C6C6" .. license_materialicons_string .. "|r",
				},
				spacer_license_2 = {
					order = 4,
					type = "description",
					name = "\n\n\n",
				},
				license_icons8 = {
					order = 5,
					type = "description",
					fontSize = "medium",
					name = "|CFFFF6A00Icons8 https://icons8.com|r",
				},
			},
		},
		thx = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Thanks to:"],
			args = {
				thxto = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = thanks_string,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
