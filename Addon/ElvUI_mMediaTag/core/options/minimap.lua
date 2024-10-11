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
local function configTable()
	E.Options.args.mMT.args.cosmetic.args.minimap.args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["Enable"],
			get = function(info)
				return E.db.mMT.minimap.enable
			end,
			set = function(info, value)
				E.db.mMT.minimap.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		settings = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Settings"],
            disabled = function ()
                return not E.db.mMT.minimap.enable
            end,
			args = {
				aspectratio = {
					order = 2,
					type = "select",
					name = L["Aspect ratio"],
					values = aspectRatios,
					get = function(info)
						return E.db.mMT.minimap.aspectRatio
					end,
					set = function(info, value)
						E.db.mMT.minimap.aspectRatio = value
                        mMT.Modules.Minimap:Initialize()
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
