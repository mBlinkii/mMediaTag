local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local ipairs = ipairs

local entries = {
	{ key = "worldboss", name = L["World Boss"] },
	{ key = "eliteBoss", name = L["Elite Boss"] },
	{ key = "eliteMini", name = L["Elite Mini"] },
	{ key = "rareelite", name = L["Rare Elite"] },
	{ key = "rare", name = L["Rare"] },
	{ key = "caster", name = L["Caster"] },
}

local args = {
	enable = {
		order = 1,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.nameplates.classification.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		get = function(info)
			return E.db.mMediaTag.nameplates.classification.enable
		end,
		set = function(info, value)
			E.db.mMediaTag.nameplates.classification.enable = value
			mMT:UpdateModule("NP-ClassificationTexture")
		end,
	},
	description = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = "\n" .. L["Inside a dungeon every mana user counts as a caster, so that texture wins over the elite ones there."] .. "\n",
	},
}

for index, entry in ipairs(entries) do
	local key = entry.key

	args[key] = {
		order = index + 2,
		type = "group",
		guiInline = true,
		name = entry.name,
		disabled = function()
			return not E.db.mMediaTag.nameplates.classification.enable
		end,
		get = function(info)
			return E.db.mMediaTag.nameplates.classification.units[key][info[#info]]
		end,
		set = function(info, value)
			E.db.mMediaTag.nameplates.classification.units[key][info[#info]] = value
			mMT:UpdateModule("NP-ClassificationTexture")
		end,
		args = {
			enable = {
				order = 1,
				type = "toggle",
				name = L["Enable"],
			},
			texture = {
				order = 2,
				type = "select",
				dialogControl = "LSM30_Statusbar",
				name = L["Texture"],
				values = LSM:HashTable("statusbar"),
				disabled = function()
					local db = E.db.mMediaTag.nameplates.classification
					return not (db.enable and db.units[key].enable)
				end,
			},
		},
	}
end

mMT.options.args.nameplates.args.classification_texture.args = args
