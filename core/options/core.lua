local mMT, E, L, V, P, G = unpack((select(2, ...)))

local  tinsert =  tinsert

local function configTable()
	E.Options.args.mMT = {
		type = "group",
		name = mMT.Icon .. " " .. mMT.Name,
		order = 6,
		args = {
			logo = {
				type = "description",
				name = "",
				order = 1,
				image = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_logo.tga", 256, 128 end,
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\general.tga",
				childGroups = "tab",
				args = {
					greeting = {
						order = 1,
						type = "group",
						name = L["Welcome text"],
						args = {},
					},
				},
			},
			datatexts = {
				order = 3,
				type = "group",
				name = L["DatatTexts"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\datatexts.tga",
				childGroups = "tab",
				args = {
					colors = {
						order = 1,
						type = "group",
						name = mMT.Name .. " " .. L["Datatext Colors"],
						args = {},
					},
					combat = {
						order = 2,
						type = "group",
						name = L["Combat Icon and Time"],
						args = {},
					},
				},
			},
			tags = {
				order = 4,
				type = "group",
				name = L["Tags"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\tags.tga",
				childGroups = "tab",
				args = {
				},
			},
			dock = {
				order = 5,
				type = "group",
				name = L["Dock"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\dock.tga",
				childGroups = "tab",
				args = {
				},
			},
			castbar = {
				order = 6,
				type = "group",
				name = L["Castbar"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\castbar.tga",
				childGroups = "tab",
				args = {
				},
			},
			nameplates = {
				order = 7,
				type = "group",
				name = L["Nameplates"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\nameplates.tga",
				childGroups = "tab",
				args = {
				},
			},
			cosmetic = {
				order = 8,
				type = "group",
				name = L["Cosmetic"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\cosmetic.tga",
				childGroups = "tab",
				args = {
					tooltip = {
						order = 1,
						type = "group",
						name = L["Tooltip Icon"],
						args = {},
					},
					background = {
						order = 2,
						type = "group",
						name = L["Custom Unitframe Backgrounds"],
						args = {},
					},
					classcolor = {
						order = 3,
						type = "group",
						name = L["Custom Class colors"],
						args = {},
					},
				},
			},
			about = {
				order = 9,
				type = "group",
				name = format("|CFF05E464%s|r", L["About"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\about.tga",
				childGroups = "tab",
				args = {
				},
			},
			setup = {
				order = 10,
				type = "group",
				name = format("|CFF0094FF%s|r", L["Setup"]),
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\setup.tga",
				childGroups = "tab",
				args = {
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)