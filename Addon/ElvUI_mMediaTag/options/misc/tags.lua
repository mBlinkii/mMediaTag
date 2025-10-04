local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local iconsDB

local function BuildIconsDB()
	if not iconsDB then
		iconsDB = {}
		for name, icon in pairs(MEDIA.icons.tags) do
			iconsDB[name] = E:TextureString(icon, ":14:14") .. " " .. mMT:formatText(name)
		end
	end
	return iconsDB
end

mMT.options.args.tags.args = {
	general = {
		order = 1,
		type = "group",
		inline = false,
		name = L["General"],
		args = {
			healthThreshold = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Classification"],
				args = {
					healthThreshold1 = {
						order = 1,
						name = L["Health trashhold 1"],
						desc = L["Set the first health trashhold."],
						type = "range",
						min = 25,
						max = 100,
						step = 1,
						get = function(info)
							return E.db.mMT.tags.healthThreshold1
						end,
						set = function(info, value)
							E.db.mMT.tags.healthThreshold1 = value
							M.TAGs:Initialize()
						end,
					},
					healthThreshold2 = {
						order = 1,
						name = L["Health trashhold 2"],
						desc = L["Set the second health trashhold."],
						type = "range",
						min = 0,
						max = 50,
						step = 1,
						get = function(info)
							return E.db.mMT.tags.healthThreshold2
						end,
						set = function(info, value)
							E.db.mMT.tags.healthThreshold2 = value
							M.TAGs:Initialize()
						end,
					},
				},
			},
		},
	},
	classification = {
		order = 2,
		type = "group",
		inline = false,
		name = L["Classification"],
		args = {
			rare = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Rare"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.classification.rare
						end,
						set = function(info, value)
							E.db.mMT.tags.classification.rare = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = true,
						get = function(info)
							local r, g, b, a = mMT:HexToRGB(E.db.mMT.color.tags.classification.rare)
							print(r, g, b, a)
							return r, g, b, a
						end,
						set = function(info, r, g, b, a)
							local hex = E:RGBToHex(r, g, b, mMT:FloatToHex(a))
							E.db.mMT.color.tags.classification.rare = hex
							MEDIA.color.tags.rare = CreateColorFromHexString(hex)
							MEDIA.color.tags.rare.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
		},
	},
}
