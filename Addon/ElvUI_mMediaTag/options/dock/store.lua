local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local DT = E:GetModule("DataTexts")

local function formatText(input)
    local ignore = { filled = true}
    local words = {}

    for word in string.gmatch(input, "[^_]+") do
        table.insert(words, word)
    end

    -- Remove the last word if it is to be ignored
    if ignore[words[#words]] then
        table.remove(words)
    end

    -- Format all remaining words
    for i, w in ipairs(words) do
        words[i] = w:sub(1,1):upper() .. w:sub(2):lower()
    end

    return table.concat(words, " ")
end


mMT.options.args.dock.args.store.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Icon"],
		args = {
			style = {
				order = 1,
				type = "select",
				name = L["Style"],
				get = function(info)
					return E.db.mMT.dock.store.style
				end,
				set = function(info, value)
					E.db.mMT.dock.store.style = value
				end,
				values = function()
					local styles = {}
					for key, _ in pairs(MEDIA.icons.dock) do
						styles[key] = key
					end
					return styles
				end,
			},
			icon = {
				order = 2,
				type = "select",
				name = L["Icon"],
				get = function(info)
					return E.db.mMT.dock.store.icon
				end,
				set = function(info, value)
					E.db.mMT.dock.store.icon = value
					DT:LoadDataTexts()
				end,
				values = function()
					local icons = {}
					if MEDIA.icons.dock[E.db.mMT.dock.store.style] then
						for key, icon in pairs(MEDIA.icons.dock[E.db.mMT.dock.store.style]) do
							icons[key] = E:TextureString(icon, ":14:14") .. " " .. formatText(key)
						end
						return icons
					end
				end,
			},
		},
	},
    color = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Color"],
		args = {
			custom_color = {
				order = 1,
				type = "toggle",
				name = L["Custom Color"],
				desc = L["Use a custom color for the icon."],
				get = function(info)
					return E.db.mMT.dock.store.custom_color
				end,
				set = function(info, value)
					E.db.mMT.dock.store.custom_color = value
					DT:LoadDataTexts()
				end,
			},
            color = {
				type = "color",
				order = 2,
				name = L["Color"],
				hasAlpha = true,
                disabled = function()
					return not E.db.mMT.dock.store.custom_color
				end,
				get = function(info)
					local r, g, b = mMT:HexToRGB(E.db.mMT.color.dock.store)
					return r, g, b
				end,
				set = function(info, r, g, b)
					local hex = E:RGBToHex(r, g, b, "ff")
					E.db.mMT.color.dock.store = hex
					MEDIA.color.dock.store = CreateColorFromHexString(hex)
                    DT:LoadDataTexts()
				end,
			},
		},
	},
}
