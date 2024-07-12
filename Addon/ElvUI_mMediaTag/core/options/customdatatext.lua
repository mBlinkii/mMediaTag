local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local tinsert = tinsert

--Lua functions
local pairs = pairs
local format = format
local tonumber = tonumber
local strjoin = strjoin
local select = select

--Variables
local LSM = LibStub("LibSharedMedia-3.0")
local FontFlags = {
	NONE = "None",
	OUTLINE = "Outline",
	THICKOUTLINE = "Thick",
	SHADOW = "|cff888888Shadow|r",
	SHADOWOUTLINE = "|cff888888Shadow|r Outline",
	SHADOWTHICKOUTLINE = "|cff888888Shadow|r Thick",
	MONOCHROME = "|cFFAAAAAAMono|r",
	MONOCHROMEOUTLINE = "|cFFAAAAAAMono|r Outline",
	MONOCHROMETHICKOUTLINE = "|cFFAAAAAAMono|r Thick",
}

local docks = {
	XIV = L["XIV"],
	XIVCOLOR = L["XIV Colored"],
}

local previewPath = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\xiv.tga"

local settings = { dock = "XIV", top = false, font = "Montserrat-SemiBold", fontflag = "SHADOW", fontsize = 14 }
local function configTable()
	E.Options.args.mMT.args.misc.args = {
		customDocks = {
			order = 10,
			type = "group",
			name = L["Custom Docks"],
			args = {
				header_settings = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Settings"],
					args = {
						select_typ = {
							order = 1,
							type = "select",
							name = L["Dock"],
							get = function(info)
								return settings.dock
							end,
							set = function(info, value)
								settings.dock = value

								local preview = {
									XIV = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\xiv.tga",
									XIVCOLOR = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\dockb.tga",
								}
								previewPath = preview[value]
							end,
							values = docks,
						},
						toggle_top = {
							order = 2,
							type = "toggle",
							name = L["Dock on Top"],
							get = function(info)
								return settings.top
							end,
							set = function(info, value)
								settings.top = value
							end,
						},
						spacer_1 = {
							order = 3,
							type = "description",
							name = "\n",
						},
						select_font = {
							type = "select",
							dialogControl = "LSM30_Font",
							order = 4,
							name = L["Font"],
							values = LSM:HashTable("font"),
							get = function(info)
								return settings.font
							end,
							set = function(info, value)
								settings.font = value
							end,
						},
						select_fontflag = {
							type = "select",
							order = 5,
							name = L["Font contour"],
							values = FontFlags,
							get = function(info)
								return settings.fontflag
							end,
							set = function(info, value)
								settings.fontflag = value
							end,
						},
						range_fontsize = {
							order = 6,
							name = L["Font Size"],
							type = "range",
							min = 1,
							max = 64,
							step = 1,
							softMin = 8,
							softMax = 32,
							get = function(info)
								return settings.fontsize
							end,
							set = function(info, value)
								settings.fontsize = value
							end,
						},
					},
				},
				header_preview = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Preview"],
					args = {
						preview = {
							type = "description",
							name = "",
							order = 1,
							image = function()
								return previewPath
							end,
							imageWidth = 512,
							imageHeight = 128,
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
