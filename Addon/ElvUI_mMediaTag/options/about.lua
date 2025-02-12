local mMT, DB, M, E, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local format = format
local tconcat = table.concat

local credits = {
	"|cff0070DEAzilroka|r",
	"|cff00c0faDlarge|r",
	E:TextGradient("Eltreum", 0.50, 0.70, 1, 0.67, 0.95, 1),
	"|cff0DB1D0J|r|cff18A2D2i|r|cff2494D4b|r|cff2F86D7e|r|cff3B78D9r|r|cff4669DBi|r|cff525BDEs|r|cff5D4DE0h|r",
	"|cff4beb2cLuckyone|r",
	"|cFFAAD372Tsxy|r",
	"|cffff7d0aMerathilis|r",
	"|cfff48cbaRepooc|r",
	E:TextGradient("Simpy but my name needs to be longer.", 0.18, 1.00, 0.49, 0.32, 0.85, 1.00, 0.55, 0.38, 0.85, 1.00, 0.55, 0.71, 1.00, 0.68, 0.32),
	"|cff18a8ffToxi|r",
	"|cffec1000Trenchy|r",
	"Dalerija",
	"ElioteMarcondes",
	"Heyallo", -- thank you for the troubleshooting
	"Pastafarian",
	"Tukui Community - tukui.org",
}
local CREDITS_TEXT = tconcat(credits, "|n")

local icons = {
	discord = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\discord.tga:16:16|t",
	github = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\github.tga:16:16|t",
	log = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\log.tga:16:16|t",
	mail = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\mail.tga:16:16|t",
}

mMT.options.args.about.args = {
	header_about = {
		order = 1,
		type = "header",
		name = format("%s %s |CFFFFFFFFVer.|r |CFFF7DC6F%s|r", MEDIA.icon16, mMT.Name, mMT.Version),
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
				name = icons.mail .. " " .. L["Contact"],
				func = function()
					E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "mmediatag@gmx.de")
				end,
			},
			git = {
				order = 2,
				type = "execute",
				name = icons.github .. " " .. "GitHub",
				func = function()
					E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "https://github.com/mBlinkii/mMediaTag")
				end,
			},
			discord = {
				order = 3,
				type = "execute",
				name = icons.discord .. " " .. "Discord",
				func = function()
					E:StaticPopup_Show("ELVUI_EDITBOX", nil, nil, "https://discord.com/invite/AE9XebMU49")
				end,
			},
			changelog = {
				order = 4,
				type = "execute",
				name = icons.log .. " " .. L["Changelog"],
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", "changelog")
				end,
			},
		},
	},
	thx = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Thanks to:"],
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = CREDITS_TEXT,
			},
		},
	},
}
