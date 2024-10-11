local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert

local aspectRatios = {
	["3:2"] = "3:2",
	["4:3"] = "4:3",
	["16:8"] = "16:8",
	["16:9"] = "16:9",
	["16:10"] = "16:10",
}

local skins = {
	circle = "circle",
	drop_a = "drop",
	hexagon = "hexagon",
	octagon = "octagon",
	paralelogram = "paralelogram",
}
local function configTable()
	E.Options.args.mMT.args.cosmetic.args.minimap.args = {
		aspectratio = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Aspect ratio"],
			disabled = function()
				return E.db.mMT.minimapSkin.enable
			end,
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.minimapAspectRatio.enable
					end,
					set = function(info, value)
						E.db.mMT.minimapAspectRatio.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				settings = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Settings"],
					disabled = function()
						return not E.db.mMT.minimapAspectRatio.enable or E.db.mMT.minimapSkin.enable
					end,
					args = {
						aspectratio = {
							order = 2,
							type = "select",
							name = L["Aspect ratio"],
							values = aspectRatios,
							get = function(info)
								return E.db.mMT.minimapAspectRatio.aspectRatio
							end,
							set = function(info, value)
								E.db.mMT.minimapAspectRatio.aspectRatio = value
								mMT.Modules.MinimapAspectRatio:Initialize()
							end,
						},
					},
				},
			},
		},
		skin = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Skin"],
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					get = function(info)
						return E.db.mMT.minimapSkin.enable
					end,
					set = function(info, value)
						E.db.mMT.minimapSkin.enable = value
						if value then E.db.mMT.minimapAspectRatio = false end
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				settings = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Settings"],
					disabled = function()
						return not E.db.mMT.minimapSkin.enable
					end,
					args = {
						aspectratio = {
							order = 2,
							type = "select",
							name = L["Style"],
							values = skins,
							get = function(info)
								return E.db.mMT.minimapSkin.skin
							end,
							set = function(info, value)
								E.db.mMT.minimapSkin.skin = value
								mMT.Modules.MinimapSkin:Initialize()
							end,
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
