local E, L, V, P, G = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")
local tinsert = tinsert
local function configTable()
    local sizeString = ":16:16:0:0:64:64:4:60:4:60"
    local icons = {}

	for key, icon in pairs(mMT.Media.Role) do
		icons[key] = E:TextureString(icon, ":14:14") .. " " .. key
	end
	E.Options.args.mMT.args.cosmetic.args.roleicons.args = {
		header_roleicons = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Role Icons"],
			args = {
				rolesymbols = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable the custom role icons"],
					get = function(info)
						return E.db.mMT.roleicons.enable
					end,
					set = function(info, value)
						E.db.mMT.roleicons.enable = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		header_icons = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Icons"],
			args = {
				tankicon = {
					order = 1,
					type = "select",
					name = L["Tank"],
					disabled = function()
						return not E.db.mMT.roleicons.enable
					end,
					get = function(info)
						return E.db.mMT.roleicons.tank
					end,
					set = function(info, value)
						E.db.mMT.roleicons.tank = value
						UF:HeaderConfig(UF.party, UF.party.forceShow ~= true or nil)
						UF:HeaderConfig(UF.party, UF.party.forceShow ~= true or nil)
						mMT.Modules.RoleIcons:Initialize()
					end,
					values = icons,
				},
				healicon = {
					order = 2,
					type = "select",
					name = L["Heal"],
					disabled = function()
						return not E.db.mMT.roleicons.enable
					end,
					get = function(info)
						return E.db.mMT.roleicons.heal
					end,
					set = function(info, value)
						E.db.mMT.roleicons.heal = value
						UF:HeaderConfig(UF.party, UF.party.forceShow ~= true or nil)
						UF:HeaderConfig(UF.party, UF.party.forceShow ~= true or nil)
						mMT.Modules.RoleIcons:Initialize()
					end,
					values = icons,
				},
				ddicon = {
					order = 3,
					type = "select",
					name = L["DD"],
					disabled = function()
						return not E.db.mMT.roleicons.enable
					end,
					get = function(info)
						return E.db.mMT.roleicons.dd
					end,
					set = function(info, value)
						E.db.mMT.roleicons.dd = value
						UF:HeaderConfig(UF.party, UF.party.forceShow ~= true or nil)
						UF:HeaderConfig(UF.party, UF.party.forceShow ~= true or nil)
						mMT.Modules.RoleIcons:Initialize()
					end,
					values = icons,
				},
			},
		},
		headercustomicons = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Custom Textures"],
			args = {
				customtexture = {
					order = 1,
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable the custom textures"],
					get = function(info)
						return E.db.mMT.roleicons.customtexture
					end,
					set = function(info, value)
						E.db.mMT.roleicons.customtexture = value
					end,
				},
				spacertexture1 = {
					order = 2,
					type = "description",
					name = "\n\n",
				},
				customtexturetank = {
					order = 3,
					name = function()
						if E.db.mMT.roleicons.customtank then
							return L["Custom Texture Tank"]
								.. "  "
								.. E:TextureString(E.db.mMT.roleicons.customtank, sizeString)
						else
							return L["Custom Texture Tank"]
						end
					end,
					type = "input",
					width = "smal",
					disabled = function()
						return not E.db.mMT.roleicons.customtexture and E.db.mMT.roleicons.enable
					end,
					get = function(info)
						return E.db.mMT.roleicons.customtank
					end,
					set = function(info, value)
						E.db.mMT.roleicons.customtank = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				customtextureheal = {
					order = 4,
					name = function()
						if E.db.mMT.roleicons.customheal then
							return L["Custom Texture Heal"]
								.. "  "
								.. E:TextureString(E.db.mMT.roleicons.customheal, sizeString)
						else
							return L["Custom Texture Heal"]
						end
					end,
					type = "input",
					width = "smal",
					disabled = function()
						return not E.db.mMT.roleicons.customtexture and E.db.mMT.roleicons.enable
					end,
					get = function(info)
						return E.db.mMT.roleicons.customheal
					end,
					set = function(info, value)
						E.db.mMT.roleicons.customheal = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
				customtexturedd = {
					order = 5,
					name = function()
						if E.db.mMT.roleicons.customdd then
							return L["Custom Texture DD"]
								.. "  "
								.. E:TextureString(E.db.mMT.roleicons.customdd, sizeString)
						else
							return L["Custom Texture DD"]
						end
					end,
					type = "input",
					width = "smal",
					disabled = function()
						return not E.db.mMT.roleicons.customtexture and E.db.mMT.roleicons.enable
					end,
					get = function(info)
						return E.db.mMT.roleicons.customdd
					end,
					set = function(info, value)
						E.db.mMT.roleicons.customdd = value
						E:StaticPopup_Show("CONFIG_RL")
					end,
				},
			},
		},
		headerdescription = {
			order = 4,
			type = "group",
			inline = true,
			name = L["Explanation"],
			args = {
				explanation = {
					order = 1,
					type = "description",
					name = L["Attention! The path of the custom texture must comply with WoW standards. Example: Interface\\MYFOLDER\\MYFILE.tga. If you see only a green box, the path is not correct or there is a typo."],
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
