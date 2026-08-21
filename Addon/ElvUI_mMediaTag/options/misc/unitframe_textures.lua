local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local LSM = E.Libs.LSM

local ipairs = ipairs

local entries = {
	{ key = "player", name = L["Player"], power = true },
	{ key = "target", name = L["Target"], power = true },
	{ key = "targettarget", name = L["Target of Target"], power = true },
	{ key = "targettargettarget", name = L["Target of Target of Target"], power = true },
	{ key = "focus", name = L["Focus"], power = true },
	{ key = "pet", name = L["Pet"], power = true },
	{ key = "party", name = L["Party"], power = true },
	{ key = "arena", name = L["Arena"], power = true },
	{ key = "boss", name = L["Boss"], power = true },
	{ key = "castbar", name = L["Castbar"] },
	{ key = "healprediction", name = L["Incoming Heal"], textureOnly = true, nameplates = true },
	{ key = "damageabsorb", name = L["Absorb Shield"], textureOnly = true, nameplates = true },
	{ key = "healabsorb", name = L["Heal Absorb"], textureOnly = true, nameplates = true },
	{ key = "powerprediction", name = L["Power Cost"], textureOnly = true },
}

local args = {}

for index, entry in ipairs(entries) do
	local key = entry.key
	local function disabled()
		return not E.db.mMediaTag.unitframe_textures[key].enable
	end

	args[key] = {
		order = index,
		type = "group",
		guiInline = true,
		name = entry.name,
		get = function(info)
			return E.db.mMediaTag.unitframe_textures[key][info[#info]]
		end,
		set = function(info, value)
			E.db.mMediaTag.unitframe_textures[key][info[#info]] = value
			mMT:UpdateModule("UnitframeTextures")
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
				disabled = disabled,
			},
		},
	}

	local extra = args[key].args

	if entry.power then extra.power_enable = { order = 3, type = "toggle", name = L["Power"], disabled = disabled } end

	if entry.nameplates then extra.nameplates = { order = 3, type = "toggle", name = L["Nameplates"], disabled = disabled } end

	if not entry.textureOnly then
		extra.spacer = {
			order = 4,
			type = "description",
			name = "\n",
		}

		extra.background_enable = {
			order = 5,
			type = "toggle",
			name = L["Background"],
			disabled = disabled,
		}

		extra.background = {
			order = 6,
			type = "select",
			dialogControl = "LSM30_Statusbar",
			name = L["Background Texture"],
			values = LSM:HashTable("statusbar"),
			disabled = function()
				local settings = E.db.mMediaTag.unitframe_textures[key]
				return not (settings.enable and settings.background_enable)
			end,
		}
	end
end

mMT.options.args.unitframes.args.unitframe_textures.args = args
