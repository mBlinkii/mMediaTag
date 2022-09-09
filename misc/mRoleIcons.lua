local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local CH = E:GetModule("Chat")
local UF = E:GetModule("UnitFrames")
local addon, ns = ...

local mIcons, mIconsList = nil, nil
local sizeString = ":16:16:0:0:64:64:4:60:4:60"
local mInsert = table.insert
local pairs = pairs

local function mSetupIcons()
	if not mIcons then
		local path = ""
		mIcons = {}

		--shield
		for i = 1, 28, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\shield%s.tga", i)
			mIcons["shield" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "shield" .. i }
		end

		--thermostat
		for i = 1, 10, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\thermostat%s.tga", i)
			mIcons["thermostat" .. i] =
				{ ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "thermostat" .. i }
		end

		--cookie
		for i = 1, 14, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\cookie%s.tga", i)
			mIcons["cookie" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "cookie" .. i }
		end

		--cross
		for i = 1, 20, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\cross%s.tga", i)
			mIcons["cross" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "cross" .. i }
		end

		--star
		for i = 1, 10, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\star%s.tga", i)
			mIcons["star" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "star" .. i }
		end

		--waterdrop
		for i = 1, 12, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\waterdrop%s.tga", i)
			mIcons["waterdrop" .. i] =
				{ ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "waterdrop" .. i }
		end

		--fire
		for i = 1, 6, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\fire%s.tga", i)
			mIcons["fire" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "fire" .. i }
		end

		--heart
		for i = 1, 12, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\heart%s.tga", i)
			mIcons["heart" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "heart" .. i }
		end

		--sword
		for i = 1, 12, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\sword%s.tga", i)
			mIcons["sword" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "sword" .. i }
		end

		--bigsword
		for i = 1, 14, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\bigsword%s.tga", i)
			mIcons["bigsword" .. i] =
				{ ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "bigsword" .. i }
		end

		--beer
		for i = 1, 8, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\beer%s.tga", i)
			mIcons["beer" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "beer" .. i }
		end

		--egg
		for i = 1, 8, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\egg%s.tga", i)
			mIcons["egg" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "egg" .. i }
		end

		--lightning
		for i = 1, 10, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\lightning%s.tga", i)
			mIcons["lightning" .. i] =
				{ ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "lightning" .. i }
		end

		--firenew
		for i = 1, 10, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\firenew%s.tga", i)
			mIcons["firenew" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "firenew" .. i }
		end

		--emergency
		for i = 1, 12, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\emergency%s.tga", i)
			mIcons["emergency" .. i] =
				{ ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "emergency" .. i }
		end

		--moon
		for i = 1, 12, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\moon%s.tga", i)
			mIcons["moon" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "moon" .. i }
		end

		--crown
		for i = 1, 3, 1 do
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\crown%s.tga", i)
			mIcons["crown" .. i] = { ["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "crown" .. i }
		end

		if not mIconsList then
			mIconsList = {}
			for i in pairs(mIcons) do
				mIconsList[i] = mIcons[i].icon
			end
		end
		mIcons = nil
	end
end

function mMT:mStartRoleSmbols()
	local mTank = nil
	local mHeal = nil
	local mDD = nil

	if E.db[mPlugin].mRoleSymbols.customtexture then
		mTank = {
			icon = E:TextureString(format(E.db[mPlugin].mRoleSymbols.customtank), sizeString),
			path = E.db[mPlugin].mRoleSymbols.customtank,
		}
		mHeal = {
			icon = E:TextureString(format(E.db[mPlugin].mRoleSymbols.customheal), sizeString),
			path = E.db[mPlugin].mRoleSymbols.customtheal,
		}
		mDD = {
			icon = E:TextureString(format(E.db[mPlugin].mRoleSymbols.customdd), sizeString),
			path = E.db[mPlugin].mRoleSymbols.customdd,
		}
	else
		mTank = {
			icon = E:TextureString(format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga", E.db[mPlugin].mRoleSymbols.tank), sizeString),
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga", E.db[mPlugin].mRoleSymbols.tank),
		}
		mHeal = {
			icon = E:TextureString(format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga", E.db[mPlugin].mRoleSymbols.heal), sizeString),
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga", E.db[mPlugin].mRoleSymbols.heal),
		}
		mDD = {
			icon = E:TextureString(format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga", E.db[mPlugin].mRoleSymbols.dd), sizeString),
			path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga", E.db[mPlugin].mRoleSymbols.dd),
		}
	end

	if mTank and mHeal and mDD then
		_G.INLINE_TANK_ICON = mTank.icon
		_G.INLINE_HEALER_ICON = mHeal.icon
		_G.INLINE_DAMAGER_ICON = mDD.icon

		CH.RoleIcons = {
			TANK = mTank.icon,
			HEALER = mHeal.icon,
			DAMAGER = mDD.icon,
		}

		UF.RoleIconTextures = {
			TANK = mTank.path,
			HEALER = mHeal.path,
			DAMAGER = mDD.path,
		}
	end
end

local function mRoleSmbolsOptions()
	mSetupIcons()

	E.Options.args.mMediaTag.args.cosmetic.args.rolesymbols.args = {
		rolesymbols = {
			order = 10,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable the custom role icons"],
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.enable = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		spacer = {
			order = 11,
			type = "description",
			name = "\n\n",
		},
		tankicon = {
			order = 12,
			type = "select",
			name = L["Tank"],
			disabled = function()
				return not E.db[mPlugin].mRoleSymbols.enable
			end,
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.tank
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.tank = value
				UF:CreateAndUpdateUF("party")
				UF:CreateAndUpdateUF("raid")
				UF:CreateAndUpdateUF("raid40")
				mMT:mStartRoleSmbols()
			end,
			values = mIconsList,
		},
		healicon = {
			order = 13,
			type = "select",
			name = L["Heal"],
			disabled = function()
				return not E.db[mPlugin].mRoleSymbols.enable
			end,
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.heal
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.heal = value
				UF:CreateAndUpdateUF("party")
				UF:CreateAndUpdateUF("raid")
				UF:CreateAndUpdateUF("raid40")
				mMT:mStartRoleSmbols()
			end,
			values = mIconsList,
		},
		ddicon = {
			order = 14,
			type = "select",
			name = L["DD"],
			disabled = function()
				return not E.db[mPlugin].mRoleSymbols.enable
			end,
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.dd
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.dd = value
				mMT:mStartRoleSmbols()
			end,
			values = mIconsList,
		},
		headercustomicons = {
			order = 20,
			type = "header",
			name = L["Custom Textures"],
		},
		customtexture = {
			order = 21,
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable the custom textures"],
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.customtexture
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.customtexture = value
			end,
		},
		spacertexture1 = {
			order = 22,
			type = "description",
			name = "\n\n",
		},
		customtexturetank = {
			order = 23,
			name = function()
				if E.db[mPlugin].mRoleSymbols.customtank then
					return L["Custom Texture Tank"]
						.. "  "
						.. E:TextureString(E.db[mPlugin].mRoleSymbols.customtank, sizeString)
				else
					return L["Custom Texture Tank"]
				end
			end,
			type = "input",
			width = "smal",
			disabled = function()
				return not E.db[mPlugin].mRoleSymbols.customtexture and E.db[mPlugin].mRoleSymbols.enable
			end,
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.customtank
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.customtank = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		customtextureheal = {
			order = 24,
			name = function()
				if E.db[mPlugin].mRoleSymbols.customheal then
					return L["Custom Texture Heal"]
						.. "  "
						.. E:TextureString(E.db[mPlugin].mRoleSymbols.customheal, sizeString)
				else
					return L["Custom Texture Heal"]
				end
			end,
			type = "input",
			width = "smal",
			disabled = function()
				return not E.db[mPlugin].mRoleSymbols.customtexture and E.db[mPlugin].mRoleSymbols.enable
			end,
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.customheal
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.customheal = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		customtexturedd = {
			order = 25,
			name = function()
				if E.db[mPlugin].mRoleSymbols.customdd then
					return L["Custom Texture DD"]
						.. "  "
						.. E:TextureString(E.db[mPlugin].mRoleSymbols.customdd, sizeString)
				else
					return L["Custom Texture DD"]
				end
			end,
			type = "input",
			width = "smal",
			disabled = function()
				return not E.db[mPlugin].mRoleSymbols.customtexture and E.db[mPlugin].mRoleSymbols.enable
			end,
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.customdd
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.customdd = value
				E:StaticPopup_Show("CONFIG_RL")
			end,
		},
		spacertexture2 = {
			order = 26,
			type = "description",
			name = "\n\n",
		},
		explanation = {
			order = 27,
			type = "description",
			name = L["Attention! The path of the custom texture must comply with WoW standards. Example: Interface\\MYFOLDER\\MYFILE.tga. If you see only a green box, the path is not correct or there is a typo."],
		},
	}
end

mInsert(ns.Config, mRoleSmbolsOptions)
