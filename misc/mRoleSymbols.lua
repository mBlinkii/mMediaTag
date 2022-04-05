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
        for i=1, 14, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\tank%s.tga", i)
            mIcons["tank" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "tank" .. i}
        end

        --thermostat
        for i=1, 10, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\thermostat%s.tga", i)
            mIcons["thermostat" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "thermostat" .. i}
        end

        --cookie
        for i=1, 14, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\cookie%s.tga", i)
            mIcons["cookie" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "cookie" .. i}
        end

        --heal
        for i=1, 10, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\heal%s.tga", i)
            mIcons["heal" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "heal" .. i}
        end

        --star
        for i=1, 10, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\star%s.tga", i)
            mIcons["star" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "star" .. i}
        end

        --waterdrop
        for i=1, 12, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\waterdrop%s.tga", i)
            mIcons["waterdrop" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "waterdrop" .. i}
        end

        --fire
        for i=1, 6, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\fire%s.tga", i)
            mIcons["fire" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "fire" .. i}
        end

        --heart
        for i=1, 12, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\heart%s.tga", i)
            mIcons["heart" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "heart" .. i}
        end

        --dd
        for i=1, 8, 1 do
            path = format("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dd%s.tga", i)
            mIcons["dd" .. i] = {["file"] = path, ["icon"] = E:TextureString(path, sizeString) .. "dd" .. i}
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
    local path = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\%s.tga"
	local mTank = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.tank), sizeString)
	local mHeal = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.heal), sizeString)
	local mDD = E:TextureString(format(path, E.db[mPlugin].mRoleSymbols.dd), sizeString)

	_G.INLINE_TANK_ICON = mTank
	_G.INLINE_HEALER_ICON = mHeal
	_G.INLINE_DAMAGER_ICON = mDD

	CH.RoleIcons = {
		TANK = mTank,
		HEALER = mHeal,
		DAMAGER = mDD,
	}

	UF.RoleIconTextures = {
		TANK = format(path, E.db[mPlugin].mRoleSymbols.tank),
		HEALER = format(path, E.db[mPlugin].mRoleSymbols.heal),
		DAMAGER = format(path, E.db[mPlugin].mRoleSymbols.dd)
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
            type = 'select',
            name = L["Tank"],
            disabled = function() return not E.db[mPlugin].mRoleSymbols.enable end,
            get = function(info) return E.db[mPlugin].mRoleSymbols.tank end,
            set = function(info, value)
                E.db[mPlugin].mRoleSymbols.tank = value
                mMT:mStartRoleSmbols()
            end,
            values = mIconsList,
        },
        healicon = {
            order = 13,
            type = 'select',
            name = L["Heal"],
            disabled = function() return not E.db[mPlugin].mRoleSymbols.enable end,
            get = function(info) return E.db[mPlugin].mRoleSymbols.heal end,
            set = function(info, value)
                E.db[mPlugin].mRoleSymbols.heal = value
                mMT:mStartRoleSmbols()
            end,
            values = mIconsList,
        },
        ddicon = {
            order = 14,
            type = 'select',
            name = L["DD"],
            disabled = function() return not E.db[mPlugin].mRoleSymbols.enable end,
            get = function(info) return E.db[mPlugin].mRoleSymbols.dd end,
            set = function(info, value)
                E.db[mPlugin].mRoleSymbols.dd = value
                mMT:mStartRoleSmbols()
            end,
            values = mIconsList,
        },
	}
end

mInsert(ns.Config, mRoleSmbolsOptions)