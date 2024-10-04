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
	E.Options.args.mMT.args.misc.args.details.args = {
		windows = {
			order = 1,
			type = "group",
			name = L["Embedded Settings"],
            inline = true,
			args = {
				chat = {
					order = 1,
					type = "select",
					name = L["Embedded to Chat"],
					get = function(info)
						return E.db.mMT.detailsEmbedded.chatEmbedded
					end,
					set = function(info, value)
						E.db.mMT.detailsEmbedded.chatEmbedded = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						DISABLE = L["DISABLE"],
						LeftChat = L["Left Chat"],
						RightChat = L["Right Chat"],
					},
				},
				windows = {
					order = 2,
					type = "select",
					name = L["Details Windows"],
					get = function(info)
						return E.db.mMT.detailsEmbedded.windows
					end,
					set = function(info, value)
						E.db.mMT.detailsEmbedded.windows = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
					values = {
						[1] = L["One"],
						[2] = L["Two"],
						[3] = L["Three (double chat height)"],
						[4] = L["Four (double chat height)"],
					},
				},
                toggle = {
					order = 3,
					type = "toggle",
					name = L["Toggle Button"],
					desc = L["Adds a button to show or hide details on click. The button is only visible on mouse over."],
					get = function(info)
						return E.db.mMT.detailsEmbedded.toggle
					end,
					set = function(info, value)
						E.db.mMT.detailsEmbedded.toggle = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		combathide = {
			order = 2,
			type = "group",
			name = L["Combat Hide/Show"],
            inline = true,
			args = {
				combathide = {
					order = 1,
					type = "toggle",
					name = L["Show/Hide in Combat"],
					desc = L["Auto shows details during combat and hides them after combat."],
					get = function(info)
						return E.db.mMT.detailsEmbedded.combatHide
					end,
					set = function(info, value)
						E.db.mMT.detailsEmbedded.combatHide = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				delay = {
					order = 2,
					name = L["Hide Delay"],
					type = "range",
					min = 0,
					max = 120,
					step = 1,
					get = function(info)
						return E.db.mMT.detailsEmbedded.hideDelay
					end,
					set = function(info, value)
						E.db.mMT.detailsEmbedded.hideDelay = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
