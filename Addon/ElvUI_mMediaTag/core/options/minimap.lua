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
								E.db.mMT.minimapAspectRatio.aspectRatio.enable = value
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
				color = {
					order = 3,
					type = "group",
					inline = true,
					name = L["Color"],
					disabled = function()
						return not E.db.mMT.minimapSkin.enable
					end,
					args = {
						texture = {
							order = 1,
							type = "group",
							inline = true,
							name = L["Texture"],
							args = {
								color = {
									order = 1,
									type = "color",
									name = L["Color"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.minimapSkin.colors.texture.color
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.minimapSkin.colors.texture.color
										t.r, t.g, t.b, t.a = r, g, b, a
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
								calss = {
									order = 2,
									type = "toggle",
									name = L["Class colored"],
									get = function(info)
										return E.db.mMT.minimapSkin.colors.texture.class
									end,
									set = function(info, value)
										E.db.mMT.minimapSkin.colors.texture.class = value
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
							},
						},
						cardinal = {
							order = 2,
							type = "group",
							inline = true,
							name = L["Cardinal Point"],
							args = {
								color = {
									order = 1,
									type = "color",
									name = L["Color"],
									hasAlpha = true,
									get = function(info)
										local t = E.db.mMT.minimapSkin.colors.cardinal.color
										return t.r, t.g, t.b, t.a
									end,
									set = function(info, r, g, b, a)
										local t = E.db.mMT.minimapSkin.colors.cardinal.color
										t.r, t.g, t.b, t.a = r, g, b, a
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
								calss = {
									order = 2,
									type = "toggle",
									name = L["Class colored"],
									get = function(info)
										return E.db.mMT.minimapSkin.colors.cardinal.class
									end,
									set = function(info, value)
										E.db.mMT.minimapSkin.colors.cardinal.class = value
										mMT.Modules.MinimapSkin:Initialize()
									end,
								},
							},
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
