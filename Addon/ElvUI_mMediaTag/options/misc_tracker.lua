local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local selected_id = nil

mMT.options.args.datatexts.args.misc_tracker.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			icon = {
				order = 1,
				type = "toggle",
				name = L["Show Icon"],
				get = function(info)
					return E.db.mMT.datatexts.tracker.icon
				end,
				set = function(info, value)
					E.db.mMT.datatexts.tracker.icon = value
					M.Tracker:UpdateAll()
				end,
			},
			name = {
				order = 2,
				type = "toggle",
				name = L["Show Name"],
				get = function(info)
					return E.db.mMT.datatexts.tracker.name
				end,
				set = function(info, value)
					E.db.mMT.datatexts.tracker.name = value
					M.Tracker:UpdateAll()
				end,
			},
			short_number = {
				order = 3,
				type = "toggle",
				name = L["Short large numbers"],
				get = function(info)
					return E.db.mMT.datatexts.tracker.short_number
				end,
				set = function(info, value)
					E.db.mMT.datatexts.tracker.short_number = value
					M.Tracker:UpdateAll()
				end,
			},
			show_max = {
				order = 4,
				type = "toggle",
				name = L["Show max amount"],
				get = function(info)
					return E.db.mMT.datatexts.tracker.show_max
				end,
				set = function(info, value)
					E.db.mMT.datatexts.tracker.show_max = value
					M.Tracker:UpdateAll()
				end,
			},
			colored = {
				order = 5,
				type = "toggle",
				name = L["Color the text"],
				get = function(info)
					return E.db.mMT.datatexts.tracker.colored
				end,
				set = function(info, value)
					E.db.mMT.datatexts.tracker.colored = value
					M.Tracker:UpdateAll()
				end,
			},
		},
	},
	custom_ids = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Custom IDs"],
		args = {
			description = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Here you can add custom IDs for the tracker. You can add currencies or items. This will add DataTexts for each ID to ElvUI."],
			},
			ad_id = {
				order = 2,
				name = L["Add Currency or Item ID"],
				desc = L["Enter a Currency or Item it accepts only Numbers."],
				type = "input",
				width = "smal",
				set = function(info, value)
					selected_id = tonumber(value)
					if selected_id then
						E.db.mMT.datatexts.tracker.custom[selected_id] = { isCurrency = true, color = "FFFFFFFF" }
                        E:StaticPopup_Show("CONFIG_RL")
					else
						mMT:Print(L["!!Error - this is not an ID."])
					end
				end,
			},
			id_list = {
				type = "select",
				order = 3,
				name = L["ID list"],
				get = function(info)
					return selected_id and tostring(selected_id)
				end,
				set = function(info, value)
					selected_id = tonumber(value)
				end,
				values = function()
					local ids = {}
					for id, _ in pairs(E.db.mMT.datatexts.tracker.custom) do
						ids[tostring(id)] = tostring(id)
					end
					return ids
				end,
			},
			delete_id = {
				type = "select",
				order = 4,
				name = L["Delete ID"],
				set = function(info, value)
					E.db.mMT.datatexts.tracker.custom[tonumber(value)] = nil
					selected_id = nil
					E:StaticPopup_Show("CONFIG_RL")
				end,
				get = function(info)
					-- noop
				end,
				values = function()
					local ids = {}
					for id, _ in pairs(E.db.mMT.datatexts.tracker.custom) do
						ids[tostring(id)] = tostring(id)
					end
					return ids
				end,
			},
			custom_ids_settings = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Custom IDs"],
				disabled = function()
					return not selected_id
				end,
				args = {
					name = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = function()
							if selected_id then
								local info = E.db.mMT.datatexts.tracker.custom[selected_id].isCurrency and M.Tracker:GetCurrencyInfos(selected_id) or M.Tracker:GetItemInfos(selected_id)
								if info then
									local db = E.db.mMT.datatexts.tracker
									local name, icon, value
									local textString, valueString, hex = "", "", ""

									if db.name then name = info.name end

									if db.icon then icon = info.icon end

									if db.short_number and info.count >= 1000 then info.count = E:ShortValue(info.count, 2) end

									value = info.count

									local textHex = E.db.mMT.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or db.colored and "|c" .. db.custom[selected_id].color or hex
									local valueHex = E.db.mMT.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or db.colored and "|c" .. db.custom[selected_id].color or hex

									textString = strjoin("", textHex, "%s|r")
									valueString = strjoin("", valueHex, "%s|r")

									if db.show_max and info.cap > 0 then
										if db.short_number and info.cap >= 1000 then info.cap = E:ShortValue(info.cap, 2) end
										value = format("%s/%s", info.count, info.cap)
									end

									return format("%s%s %s", icon or "", format(textString, name or ""), format(valueString, value))
								end
							end
							return ""
						end,
					},
					is_currency = {
						order = 2,
						type = "toggle",
						name = L["Is Currency"],
						get = function(info)
							return selected_id and E.db.mMT.datatexts.tracker.custom[selected_id] and E.db.mMT.datatexts.tracker.custom[selected_id].isCurrency
						end,
						set = function(info, value)
							if selected_id and E.db.mMT.datatexts.tracker.custom[selected_id] then
								E.db.mMT.datatexts.tracker.custom[selected_id].isCurrency = value
								M.Tracker:UpdateAll()
							end
						end,
					},
					color = {
						order = 3,
						type = "color",
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							if selected_id and E.db.mMT.datatexts.tracker.custom[selected_id] then
								local r, g, b = mMT:HexToRGB(E.db.mMT.datatexts.tracker.custom[selected_id].color)
								M.Tracker:UpdateAll()
								return r, g, b
							else
								return 1, 1, 1
							end
						end,
						set = function(info, r, g, b)
							if selected_id and E.db.mMT.datatexts.tracker.custom[selected_id] then
								local hex = E:RGBToHex(r, g, b, "ff")
								E.db.mMT.datatexts.tracker.custom[selected_id].color = hex
							end
						end,
					},
				},
			},
		},
	},
}
