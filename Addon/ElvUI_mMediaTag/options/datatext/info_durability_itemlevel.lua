local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local GetMountInfoByID = C_MountJournal.GetMountInfoByID

local styles = {
	a = {
		shield = MEDIA.icons.datatexts.durability.shield_01,
		armor = MEDIA.icons.datatexts.durability.armor_01,
	},
	b = {
		shield = MEDIA.icons.datatexts.durability.shield_02,
		armor = MEDIA.icons.datatexts.durability.armor_01,
	},
	c = {
		shield = MEDIA.icons.datatexts.durability.shield_03,
		armor = MEDIA.icons.datatexts.durability.armor_01,
	},
	d = {
		shield = MEDIA.icons.datatexts.durability.shield_01,
		armor = MEDIA.icons.datatexts.durability.armor_02,
	},
	e = {
		shield = MEDIA.icons.datatexts.durability.shield_02,
		armor = MEDIA.icons.datatexts.durability.armor_02,
	},
	f = {
		shield = MEDIA.icons.datatexts.durability.shield_03,
		armor = MEDIA.icons.datatexts.durability.armor_02,
	},
	g = {
		shield = MEDIA.icons.datatexts.durability.shield_01,
		armor = MEDIA.icons.datatexts.durability.armor_03,
	},
	h = {
		shield = MEDIA.icons.datatexts.durability.shield_02,
		armor = MEDIA.icons.datatexts.durability.armor_03,
	},
	i = {
		shield = MEDIA.icons.datatexts.durability.shield_03,
		armor = MEDIA.icons.datatexts.durability.armor_03,
	},
	j = {
		shield = MEDIA.icons.datatexts.durability.shield_01,
		armor = MEDIA.icons.datatexts.durability.armor_04,
	},
	k = {
		shield = MEDIA.icons.datatexts.durability.shield_02,
		armor = MEDIA.icons.datatexts.durability.armor_04,
	},
	l = {
		shield = MEDIA.icons.datatexts.durability.shield_03,
		armor = MEDIA.icons.datatexts.durability.armor_04,
	},
}

mMT.options.args.datatexts.args.info_durability_itemlevel.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			styles = {
				order = 1,
				type = "select",
				name = L["Style"],
				get = function(info)
					return E.db.mMT.datatexts.durability_itemLevel.style
				end,
				set = function(info, value)
					E.db.mMT.datatexts.durability_itemLevel.style = value
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
				values = function()
					local values = {}
					for key, icon in pairs(styles) do
						values[key] = E:TextureString(icon.shield, ":14:14") .. " 80%" .. " " .. E:TextureString(icon.armor, ":14:14") .. " 645"
					end

					values.none = L["None"]
					return values
				end,
			},
			withe_text = {
				order = 2,
				type = "toggle",
				name = L["Force withe Text"],
				get = function(info)
					return E.db.mMT.datatexts.durability_itemLevel.force_withe_text
				end,
				set = function(info, value)
					E.db.mMT.datatexts.durability_itemLevel.force_withe_text = value
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
			},
		},
	},
	color = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Color"],
		args = {
			warnings = {
				order = 1,
				type = "toggle",
				name = L["Warning colors"],
				get = function(info)
					return E.db.mMT.datatexts.durability_itemLevel.warning
				end,
				set = function(info, value)
					E.db.mMT.datatexts.durability_itemLevel.warning = value
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
			},
            spacer1 = {
				order = 2,
				type = "description",
				fontSize = "medium",
				name = "\n",
			},
			repair = {
				order = 3,
				name = L["Repair Threshold"],
				desc = L["Threshold value for the repair color, if this is active then you should repair your gear."],
				type = "range",
				min = 2,
				max = 98,
				step = 1,
				softMin = 0,
				softMax = 100,
				disabled = function()
					return not E.db.mMT.datatexts.durability_itemLevel.warning
				end,
				get = function(info)
					return E.db.mMT.datatexts.durability_itemLevel.repair_threshold
				end,
				set = function(info, value)
					E.db.mMT.datatexts.durability_itemLevel.repair_threshold = value
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
			},
			repair_color = {
				order = 4,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.datatexts.durability_itemLevel.warning
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.datatexts.durability_itemLevel.color_repair)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.datatexts.durability_itemLevel.color_repair = hex
					MEDIA.color.di_repair = CreateColorFromHexString(hex)
					MEDIA.color.di_repair.hex = hex
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
			},
            spacer2 = {
				order = 5,
				type = "description",
				fontSize = "medium",
				name = "\n",
			},
			warning = {
				order = 6,
				name = L["Warning Threshold"],
				desc = L["Threshold value for the repair color, if this is active, you should repair your equipment soon."],
				type = "range",
				min = 12,
				max = 98,
				step = 1,
				softMin = 0,
				softMax = 100,
				disabled = function()
					return not E.db.mMT.datatexts.durability_itemLevel.warning
				end,
				get = function(info)
					return E.db.mMT.datatexts.durability_itemLevel.warning_threshold
				end,
				set = function(info, value)
					E.db.mMT.datatexts.durability_itemLevel.warning_threshold = value
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
			},
			warning_color = {
				order = 7,
				type = "color",
				name = L["Color"],
				hasAlpha = false,
				disabled = function()
					return not E.db.mMT.datatexts.durability_itemLevel.warning
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.datatexts.durability_itemLevel.color_warning)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.datatexts.durability_itemLevel.color_warning = hex
					MEDIA.color.di_warning = CreateColorFromHexString(hex)
					MEDIA.color.di_warning.hex = hex
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
			},
		},
	},
	mount = {
		order = 3,
		type = "group",
		inline = true,
		name = L["Repair Mount"],
		args = {
			mount = {
				order = 1,
				type = "select",
				name = L["Repair Mount"],
				get = function(info)
					return E.db.mMT.datatexts.durability_itemLevel.mount
				end,
				set = function(info, value)
					E.db.mMT.datatexts.durability_itemLevel.mount = value
					DT:ForceUpdate_DataText("mMT - Durability & ItemLevel")
				end,
				values = function()
					local mountIDs = {}

					for _, mountID in ipairs({ 280, 284, 460, 1039, 2237 }) do
						local name, _, icon, _, isUsable = GetMountInfoByID(mountID)
						if isUsable then mountIDs[mountID] = format("|T%s:14:14:0:0:64:64:4:60:4:60|t %s", icon, name) end
					end

					return mountIDs
				end,
			},
		},
	},
}
