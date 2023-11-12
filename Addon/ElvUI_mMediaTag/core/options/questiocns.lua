local E, L, V, P, G = unpack(ElvUI)

local tinsert = tinsert
local function configTable()
	local questIcons = {}

    for key, icon in pairs(mMT.Media.QuestIcons) do
		questIcons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end

	E.Options.args.mMT.args.cosmetic.args.questicons.args = {
        toggle_enable = {
            order = 1,
            type = "toggle",
            name = L["Enable"],
            desc = L["Enables or disables Quest Icon"],
            get = function(info)
                return E.db.mMT.questicons.enable
            end,
            set = function(info, value)
                E.db.mMT.questicons.enable = value
                E:StaticPopup_Show("CONFIG_RL")
            end,
        },
		header_icons = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Icons"],
			args = {
				icon_default = {
					order = 1,
					type = "select",
					name = L["Default"],
					get = function(info)
						return E.db.mMT.questicons.texture.Default
					end,
					set = function(info, value)
						E.db.mMT.questicons.texture.Default = value
					end,
					values = questIcons,
				},
				-- icon_item = {
				-- 	order = 2,
				-- 	type = "select",
				-- 	name = L["Item"],
				-- 	get = function(info)
				-- 		return E.db.mMT.questicons.texture.Item
				-- 	end,
				-- 	set = function(info, value)
				-- 		E.db.mMT.questicons.texture.Item = value
				-- 	end,
				-- 	values = questIcons,
				-- },
                icon_skull = {
					order = 3,
					type = "select",
					name = L["Skull"],
					get = function(info)
						return E.db.mMT.questicons.texture.Skull
					end,
					set = function(info, value)
						E.db.mMT.questicons.texture.Skull = value
					end,
					values = questIcons,
				},
                icon_chat = {
					order = 4,
					type = "select",
					name = L["Chat"],
					get = function(info)
						return E.db.mMT.questicons.texture.Chat
					end,
					set = function(info, value)
						E.db.mMT.questicons.texture.Chat = value
					end,
					values = questIcons,
				},
			},
		},
		header_settings = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Icon Settings"],
			args = {
				toggle_text = {
                    order = 1,
                    type = "toggle",
                    name = L["Hide Text"],
                    get = function(info)
                        return E.db.mMT.questicons.hidetext
                    end,
                    set = function(info, value)
                        E.db.mMT.questicons.hidetext = value
                        E:StaticPopup_Show("CONFIG_RL")
                    end,
                },
			},
		},
	}
end

tinsert(mMT.Config, configTable)
