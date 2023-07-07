local E, L = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.maui.args = {
		header_maui = {
			order = 1,
			type = "group",
			inline = true,
			name = "|CFF29C0E3M|r|CFF5493FFa|r|CFF854FE3U|r|CFFA632E3I|r",
			args = {
				logo = {
					type = "description",
					name = "",
					order = 1,
					image = function()
						return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\maui_logo.tga", 256, 64
					end,
				},
				description = {
					order = 2,
					type = "description",
					name = L["Here is an installer for my ElvUI Profile - MaUI, if you want to install only a part of my profile, then skip everything and install the part you want."],
				},
			},
		},
		header_install = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Installer"],
			args = {
				install = {
					order = 1,
					type = "execute",
					name = "Install",
					desc = "Run the installation process.",
					func = function()
						mMT:DEBUGTEXT()
						--E:GetModule("PluginInstaller"):Queue(InstallerData); E:ToggleOptions();
					end,
				},
				git = {
					order = 2,
					type = "execute",
					name = L["Git"],
					func = function()
						E:StaticPopup_Show(
							"ELVUI_EDITBOX",
							nil,
							nil,
							"https://github.com/mBlinkii/MaUI-ElvUI-Profile-Strings"
						)
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
