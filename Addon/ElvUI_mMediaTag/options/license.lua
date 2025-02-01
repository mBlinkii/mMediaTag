local mMT, DB, M, F, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local tconcat = table.concat

local licenses = {
	mMT = {
		"Copyright ©2009-2025 The contents of this addon, excluding third-party resources, are copyrighted to their authors with all rights reserved.",
		" ",
		"This addon is free to use and the authors hereby grants you the following rights:",
		"   - 1. You may make modifications to this addon for private use only, you may not redistribute any part of this addon.",
		"   - 2. You cannot change the name of this addon, including the addon folders.",
		"   - 3. This copyright notice must appear in all copies of the software.",
		"   - 4. You may not redistribute the textures of this addon.",
		" ",
		"All rights not explicitly addressed in this license are reserved by the copyright holders.",
	},
	google = {
		"Google - Material Design Icons are available under https://material.io./",
		"The symbols are available under the APACHE LICENSE, VERSION 2.0. (https://www.apache.org/licenses/LICENSE-2.0.txt)",
		"The icons have been resized and the color has been changed.",
	},
	fonts = {
		"Inter - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
		"Lemon - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
		"Montserrat - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
		"NotoSans - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
		"Oswald - SIL OPEN FONT LICENSE Version 1.1 - 26 February 2007 - https://openfontlicense.org/open-font-license-official-text/",
		"Ubuntu - UBUNTU FONT LICENSE Version 1.0 - https://ubuntu.com/legal/font-licence",
	},
	other = {
		"Icons by |cff1FB141Icons8|r - https://icons8.de/",
	},
}

local LICENSE_MMT = tconcat(licenses.mMT, "|n")
local LICENSE_GOOGLE = tconcat(licenses.google, "|n")
local LICENSE_FONTS = tconcat(licenses.fonts, "|n")
local LICENSE_OTHER = tconcat(licenses.other, "|n")

mMT.options.args.license.args = {
	license_mmt = {
		order = 1,
		type = "group",
		name = mMT.Name,
		guiInline = true,
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = LICENSE_MMT,
			},
		},
	},
	license_google = {
		order = 2,
		type = "group",
		name = "Google",
		guiInline = true,
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = LICENSE_GOOGLE,
			},
		},
	},
	license_fonts = {
		order = 3,
		type = "group",
		name = "Fonts",
		guiInline = true,
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = LICENSE_FONTS,
			},
		},
	},
	license_other = {
		order = 4,
		type = "group",
		name = "Other",
		guiInline = true,
		args = {
			text = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = LICENSE_OTHER,
			},
		},
	},
}
