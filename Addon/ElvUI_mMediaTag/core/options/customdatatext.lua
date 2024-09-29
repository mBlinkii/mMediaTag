local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert

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
	MAUI = L["MaUI"],
	MMTDOCK = L["mMT Dock"],
	MMTEXTRA = L["mMT Extra"],
	CURRENCY = L["Currency"],
	LOCATION = L["Location"],
	SIMPLE = L["Simple"],
}

local previewPath = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\xiv.tga"

local settings = { dock = "XIV", top = false, font = "Montserrat-SemiBold", fontflag = "SHADOW", fontsize = 14, bg = false }
local function configTable()
	E.Options.args.mMT.args.misc.args.customDocks.args = {
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
							XIVCOLOR = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\xivcolored.tga",
							MAUI = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\maui.tga",
							MMTDOCK = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\mmt.tga",
							MMTEXTRA = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\extra.tga",
							CURRENCY = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\currency.tga",
							LOCATION = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\location.tga",
							SIMPLE = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\simple.tga",
						}

						previewPath = preview[value]

						if settings.dock == "MMTEXTRA" then
							settings.bg = true
						elseif settings.dock == "LOCATION" then
							settings.bg = true
							settings.fontsize = 16
							settings.top = true
						end
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
				toggle_bg = {
					order = 3,
					type = "toggle",
					name = L["Background"],
					get = function(info)
						return settings.bg
					end,
					set = function(info, value)
						settings.bg = value
					end,
				},
				spacer_1 = {
					order = 4,
					type = "description",
					name = "\n",
				},
				select_font = {
					type = "select",
					dialogControl = "LSM30_Font",
					order = 5,
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
					order = 6,
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
					order = 7,
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
				spacer_2 = {
					order = 8,
					type = "description",
					name = "\n",
				},
				execute_apply = {
					order = 9,
					type = "execute",
					name = L["Apply"],
					func = function()
						if (settings.dock == "XIV") or (settings.dock == "XIVCOLOR") or (settings.dock == "MAUI") or (settings.dock == "SIMPLE") then
							mMT:XIV(settings)
						elseif settings.dock == "MMTDOCK" then
							mMT:Dock_Default(settings)
						elseif settings.dock == "MMTEXTRA" then
							mMT:Dock_Extra(settings)
						elseif (settings.dock == "CURRENCY") and E.Retail then
							mMT:Currency(settings)
						elseif settings.dock == "LOCATION" then
							mMT:Location(settings)
						end
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				execute_delete = {
					order = 10,
					type = "execute",
					name = L["Delete all"],
					func = function()
						mMT:DeleteAll()
						E:StaticPopup_Show("CONFIG_RL")
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
	}
end

tinsert(mMT.Config, configTable)
