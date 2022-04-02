local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local CH = E:GetModule('Chat');
local UF = E:GetModule('UnitFrames');
local addon, ns = ...

local mIcons, mIconsList = nil, nil
local sizeString = ":16:16:0:0:64:64:4:60:4:60"
local mInsert = table.insert
local pairs = pairs

local function mSetupIcons()
    if not mIcons then
        local path = ""
        mIcons = {}

        --tank
        for i=1, 15, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tank%s.tga", i)
            mIcons["tank" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString)}
        end

        --dd
        for i=1, 10, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dd%s.tga", i)
            mIcons["dd" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString)}
        end

        --cookie
        for i=1, 5, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\cookie%s.tga", i)
            mIcons["cookie" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString)}
        end

        --heal
        for i=1, 8, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\heal%s.tga", i)
            mIcons["heal" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString)}
        end

        --tsunami
        for i=1, 7, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tsunami%s.tga", i)
            mIcons["tsunami" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString)}
        end

        --waterdrop
        for i=1, 13, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\waterdrop%s.tga", i)
            mIcons["waterdrop" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString)}
        end

        --heartborder
        for i=1, 10, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\heartborder%s.tga", i)
            mIcons["heartborder" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString)}
        end

        --heart
        for i=1, 16, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\heart%s.tga", i)
            mIcons["heart" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString)}
        end

        if not mIconsList then
            mIconsList = {}
            for i in pairs(mIcons) do
                mIconsList[i] = mIcons[i].icon
            end
        end
    end
end

function mMT:mStartRoleSmbols()
	local mTank = E.db[mPlugin].mRoleSymbols.tank.path
	local mDD = E.db[mPlugin].mRoleSymbols.dd.path
	local mHeal = E.db[mPlugin].mRoleSymbols.heal.path

	E.Media.Textures.Tank = mTank
	E.Media.Textures.Healer = mHeal
	E.Media.Textures.DPS = mDD

	_G.INLINE_TANK_ICON = E:TextureString(mTank, sizeString)
	_G.INLINE_HEALER_ICON = E:TextureString(mHeal, sizeString)
	_G.INLINE_DAMAGER_ICON = E:TextureString(mDD, sizeString)

	CH.RoleIcons = {
		TANK = E:TextureString(mTank, sizeString),
		HEALER = E:TextureString(mHeal, sizeString),
		DAMAGER = E:TextureString(mDD, sizeString),
	}

	UF.RoleIconTextures = {
		TANK = mTank,
		HEALER = mHeal,
		DAMAGER = mDD
    }
end

local function mRoleSmbolsOptions()
    mSetupIcons()

	E.Options.args.mMediaTag.args.cosmetic.args.rolesymbols.args = {
		rolesymbols = {
			order = 10,
			type = 'toggle',
			name = L["Enable"],
			desc = L["Enable the custom role icons"],
			get = function(info)
				return E.db[mPlugin].mRoleSymbols.enable
			end,
			set = function(info, value)
				E.db[mPlugin].mRoleSymbols.enable = value
			end,
		},
        spacer = {
			order = 11,
			type = "description",
			name = "\n\n",
		},
        tankicon = {
            order = 12,
            type = 'select',
            name = L["Tank"],
            disabled = function() return not E.db[mPlugin].mRoleSymbols.enable end,
            get = function(info) return E.db[mPlugin].mRoleSymbols.tank.name end,
            set = function(info, value)
                E.db[mPlugin].mRoleSymbols.tank.name = value
                E.db[mPlugin].mRoleSymbols.tank.path = mIcons[value].file
                mMT:mStartRoleSmbols()
            end,
            values = mIconsList,
        },
        healicon = {
            order = 13,
            type = 'select',
            name = L["Heal"],
            disabled = function() return not E.db[mPlugin].mRoleSymbols.enable end,
            get = function(info) return E.db[mPlugin].mRoleSymbols.heal.name end,
            set = function(info, value)
                E.db[mPlugin].mRoleSymbols.heal.name = value
                E.db[mPlugin].mRoleSymbols.heal.path = mIcons[value].file
                mMT:mStartRoleSmbols()
            end,
            values = mIconsList,
        },
        ddicon = {
            order = 14,
            type = 'select',
            name = L["DD"],
            disabled = function() return not E.db[mPlugin].mRoleSymbols.enable end,
            get = function(info) return E.db[mPlugin].mRoleSymbols.dd.name end,
            set = function(info, value)
                E.db[mPlugin].mRoleSymbols.dd.name = value
                E.db[mPlugin].mRoleSymbols.dd.path = mIcons[value].file
                mMT:mStartRoleSmbols()
            end,
            values = mIconsList,
        },
	}
end

mInsert(ns.Config, mRoleSmbolsOptions)