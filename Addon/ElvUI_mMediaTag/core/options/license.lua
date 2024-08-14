local E, _, _, _, _ = unpack(ElvUI)
local L = mMT.Locales

local _G = _G
local tinsert = tinsert
local tconcat = _G.table.concat
local tsort = table.sort

local licens_mMT = {
	"Copyright ©2009-2024 The contents of this addon, excluding third-party resources, are copyrighted to their authors with all rights reserved.",
	" ",
	"This addon is free to use and the authors hereby grants you the following rights:",
	"   - 1. You may make modifications to this addon for private use only, you may not redistribute any part of this addon.",
	"   - 2. You cannot change the name of this addon, including the addon folders.",
	"   - 3. This copyright notice must appear in all copies of the software.",
	"   - 4. You may not redistribute the textures of this addon.",
	" ",
	"All rights not explicitly addressed in this license are reserved by the copyright holders.",
}

local license_google = {
	"Google - Material Design Icons are available under https://material.io./",
	" ",
	"The symbols are available under the APACHE LICENSE, VERSION 2.0. (https://www.apache.org/licenses/LICENSE-2.0.txt)",
	" ",
	"The icons have been resized and the color has been changed.",
}

local license_fonts = {
	"Inter - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
	" ",
	"Lemon - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
	" ",
	"Montserrat - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
	" ",
	"NotoSans - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
	" ",
	"Oswald - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
	" ",
	"Ubuntu - UBUNTU FONT LICENCE Version 1.0 - https://ubuntu.com/legal/font-licence",
}

local license_other = {
	"Icons by |cff1FB141Icons8|r - https://icons8.de/",
}

local LICENS_MMT = tconcat(licens_mMT, "|n")
local LICENS_GOOGLE = tconcat(license_google, "|n")
local LICENS_FONTS = tconcat(license_fonts, "|n")
local LICENS_OTHER = tconcat(license_other, "|n")

local function configTable()
	E.Options.args.mMT.args.license.args = {
		licens_mmt = {
			order = 1,
			type = "group",
			name = mMT.Name,
			guiInline = true,
			args = {
				licens = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = format("|cffF2EAE1%s|r", LICENS_MMT),
				},
			},
		},
		licens_google = {
			order = 2,
			type = "group",
			name = "|cff4285F4G|r|cffEA4335o|r|cffFBBC05o|r|cff4285F4g|r|cff34A853l|r|cffEA4335e|r",
			guiInline = true,
			args = {
				licens = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = format("|cffF2EAE1%s|r", LICENS_GOOGLE),
				},
			},
		},
		licens_fonts = {
			order = 3,
			type = "group",
			name = format("|cffffe4b9%s|r", L["Font"]),
			guiInline = true,
			args = {
				licens = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = format("|cffF2EAE1%s|r", LICENS_FONTS),
				},
			},
		},
		licens_other = {
			order = 4,
			type = "group",
			name = format("|cffffb5ff%s|r", L["Other"]),
			guiInline = true,
			args = {
				licens = {
					order = 1,
					type = "description",
					fontSize = "medium",
					name = format("|cffF2EAE1%s|r", LICENS_OTHER),
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
