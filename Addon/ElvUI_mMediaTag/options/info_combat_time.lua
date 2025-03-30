local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local dt_icons = {
	combat_01 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_1.tga",
	combat_02 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_2.tga",
	combat_03 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_3.tga",
	combat_04 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_4.tga",
	combat_05 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_5.tga",
	combat_06 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_6.tga",
	combat_07 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_7.tga",
	combat_08 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_8.tga",
	combat_09 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_9.tga",
	combat_10 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_10.tga",
	combat_11 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_11.tga",
	combat_12 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_12.tga",
	combat_13 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_13.tga",
	combat_14 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_14.tga",
	combat_15 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_15.tga",
	combat_16 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_16.tga",
	combat_17 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_17.tga",
	combat_18 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_18.tga",
	combat_19 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_19.tga",
	combat_20 = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\datatexts\\combat_20.tga",
}

mMT.options.args.datatexts.args.info_combat_time.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			in_combat = {
				order = 1,
				type = "select",
				name = L["In Combat"],
				get = function(info)
					return E.db.mMT.datatexts.combat_time.in_combat
				end,
				set = function(info, value)
					E.db.mMT.datatexts.combat_time.in_combat = value
					DT:ForceUpdate_DataText("mMT - CombatTimer")
				end,
				values = function()
					local values = {}
					for key, icon in pairs(dt_icons) do
						values[key] = E:TextureString(icon, ":14:14")
					end

					values.none = L["None"]
					return values
				end,
			},
            out_of_combat = {
				order = 2,
				type = "select",
				name = L["Out of Combat"],
				get = function(info)
					return E.db.mMT.datatexts.combat_time.out_of_combat
				end,
				set = function(info, value)
					E.db.mMT.datatexts.combat_time.out_of_combat = value
					DT:ForceUpdate_DataText("mMT - CombatTimer")
				end,
				values = function()
					local values = {}
					for key, icon in pairs(dt_icons) do
						values[key] = E:TextureString(icon, ":14:14")
					end

					values.none = L["None"]
					return values
				end,
			},
            delay = {
				order = 3,
				name = L["Hide delay"],
				type = "range",
				min = 0,
				max = 120,
				step = 1,
				get = function(info)
					return E.db.mMT.datatexts.combat_time.hide_delay
				end,
				set = function(info, value)
					E.db.mMT.datatexts.combat_time.hide_delay = value
					DT:ForceUpdate_DataText("mMT - CombatTimer")
				end,
            },
		},
	},
}
