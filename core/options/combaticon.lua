local mMT, E, L, V, P, G = unpack((select(2, ...)))

local tinsert = tinsert
local texturelist = {
	CI1 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat1.tga',':20:20'),
	CI2 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat2.tga',':20:20'),
	CI3 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat3.tga',':20:20'),
	CI4 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat4.tga',':20:20'),
	CI5 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat5.tga',':20:20'),
	CI6 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat6.tga',':20:20'),
	CI7 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat7.tga',':20:20'),
	CI8 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat8.tga',':20:20'),
	CI9 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat9.tga',':20:20'),
	CI10 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat10.tga',':20:20'),
	CI12 = E:TextureString('Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\combat\\combat11.tga',':20:20'),
}
local function configTable()
	E.Options.args.mMT.args.datatexts.args = {
		header_combaticon = {
			order = 1,
			type = "header",
			name = L["Combat Icon and Time"],
		},
		combaticon_ooc_icon = {
			order = 2,
			type = "select",
			name = L["Icon out of Combat"],
			get = function(info)
				return E.db.mMT.combattime.ooctexture
			end,
			set = function(info, value)
				E.db.mMT.combattime.ooctexture = value
			end,
			values = texturelist,
		},
		combaticon_ic_icon = {
			order = 3,
			type = "select",
			name = L["Icon in Combat"],
			get = function(info)
				return E.db.mMT.combattime.ictexture
			end,
			set = function(info, value)
				E.db.mMT.combattime.ictexture = value
			end,
			values = texturelist,
		},
	}
end

tinsert(mMT.Config, configTable)
