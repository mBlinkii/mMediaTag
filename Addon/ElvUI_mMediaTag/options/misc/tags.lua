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
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.classification.rare)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.classification.rare = hex
							MEDIA.color.tags.rare = CreateColorFromHexString(hex)
							MEDIA.color.tags.rare.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			elite = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Elite"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.classification.elite
						end,
						set = function(info, value)
							E.db.mMT.tags.classification.elite = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.classification.elite)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.classification.elite = hex
							MEDIA.color.tags.elite = CreateColorFromHexString(hex)
							MEDIA.color.tags.elite.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			rareelite = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Rare Elite"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.classification.rareelite
						end,
						set = function(info, value)
							E.db.mMT.tags.classification.rareelite = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.classification.rareelite)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.classification.rareelite = hex
							MEDIA.color.tags.rareelite = CreateColorFromHexString(hex)
							MEDIA.color.tags.rareelite.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			boss = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Boss"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.classification.worldboss
						end,
						set = function(info, value)
							E.db.mMT.tags.classification.worldboss = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.classification.worldboss)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.classification.worldboss = hex
							MEDIA.color.tags.worldboss = CreateColorFromHexString(hex)
							MEDIA.color.tags.worldboss.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
		},
	},
	status = {
		order = 3,
		type = "group",
		inline = false,
		name = L["Status"],
		args = {
			afk = {
				order = 1,
				type = "group",
				inline = true,
				name = L["AFK"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.status.afk
						end,
						set = function(info, value)
							E.db.mMT.tags.status.afk = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.status.afk)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.status.afk = hex
							MEDIA.color.tags.afk = CreateColorFromHexString(hex)
							MEDIA.color.tags.afk.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			dnd = {
				order = 2,
				type = "group",
				inline = true,
				name = L["DND"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.status.dnd
						end,
						set = function(info, value)
							E.db.mMT.tags.status.dnd = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.status.dnd)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.status.dnd = hex
							MEDIA.color.tags.dnd = CreateColorFromHexString(hex)
							MEDIA.color.tags.dnd.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			dc = {
				order = 3,
				type = "group",
				inline = true,
				name = L["DC/ Offline"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.status.dc
						end,
						set = function(info, value)
							E.db.mMT.tags.status.dc = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.status.dc)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.status.dc = hex
							MEDIA.color.tags.dc = CreateColorFromHexString(hex)
							MEDIA.color.tags.dc.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			dead = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Dead"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.status.dead
						end,
						set = function(info, value)
							E.db.mMT.tags.status.dead = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.status.dead)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.status.dead = hex
							MEDIA.color.tags.dead = CreateColorFromHexString(hex)
							MEDIA.color.tags.dead.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			ghost = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Ghost"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.status.ghost
						end,
						set = function(info, value)
							E.db.mMT.tags.status.ghost = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.status.ghost)
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.status.ghost = hex
							MEDIA.color.tags.ghost = CreateColorFromHexString(hex)
							MEDIA.color.tags.ghost.hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
		},
	},
	misc = {
		order = 4,
		type = "group",
		inline = false,
		name = L["Misc"],
		args = {
			role = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Role Icons"],
				args = {
					tank = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Tank"],
						args = {
							icon = {
								order = 1,
								type = "select",
								name = L["Icon"],
								get = function(info)
									return E.db.mMT.tags.misc.tank
								end,
								set = function(info, value)
									E.db.mMT.tags.misc.tank = value
									M.TAGs:Initialize()
								end,
								values = BuildIconsDB,
							},
							color = {
								type = "color",
								order = 2,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.misc.tank)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.tags.misc.tank = hex
									MEDIA.color.tags.tank = CreateColorFromHexString(hex)
									MEDIA.color.tags.tank.hex = hex
									M.TAGs:Initialize()
								end,
							},
						},
					},
					healer = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Healer"],
						args = {
							icon = {
								order = 1,
								type = "select",
								name = L["Icon"],
								get = function(info)
									return E.db.mMT.tags.misc.healer
								end,
								set = function(info, value)
									E.db.mMT.tags.misc.healer = value
									M.TAGs:Initialize()
								end,
								values = BuildIconsDB,
							},
							color = {
								type = "color",
								order = 2,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.misc.healer)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.tags.misc.healer = hex
									MEDIA.color.tags.healer = CreateColorFromHexString(hex)
									MEDIA.color.tags.healer.hex = hex
									M.TAGs:Initialize()
								end,
							},
						},
					},
					dps = {
						order = 3,
						type = "group",
						inline = true,
						name = L["DPS"],
						args = {
							icon = {
								order = 1,
								type = "select",
								name = L["Icon"],
								get = function(info)
									return E.db.mMT.tags.misc.dps
								end,
								set = function(info, value)
									E.db.mMT.tags.misc.dps = value
									M.TAGs:Initialize()
								end,
								values = BuildIconsDB,
							},
							color = {
								type = "color",
								order = 2,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.misc.dps)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.tags.misc.dps = hex
									MEDIA.color.tags.dps = CreateColorFromHexString(hex)
									MEDIA.color.tags.dps.hex = hex
									M.TAGs:Initialize()
								end,
							},
						},
					},
				},
			},
			misc = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Misc"],
				args = {
					pvp = {
						order = 1,
						type = "group",
						inline = true,
						name = L["PvP"],
						args = {
							icon = {
								order = 1,
								type = "select",
								name = L["Icon"],
								get = function(info)
									return E.db.mMT.tags.misc.pvp
								end,
								set = function(info, value)
									E.db.mMT.tags.misc.pvp = value
									M.TAGs:Initialize()
								end,
								values = BuildIconsDB,
							},
							color = {
								type = "color",
								order = 2,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.misc.pvp)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.tags.misc.pvp = hex
									MEDIA.color.tags.pvp = CreateColorFromHexString(hex)
									MEDIA.color.tags.pvp.hex = hex
									M.TAGs:Initialize()
								end,
							},
						},
					},
					quest = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Quest"],
						args = {
							icon = {
								order = 1,
								type = "select",
								name = L["Icon"],
								get = function(info)
									return E.db.mMT.tags.misc.quest
								end,
								set = function(info, value)
									E.db.mMT.tags.misc.quest = value
									M.TAGs:Initialize()
								end,
								values = BuildIconsDB,
							},
							color = {
								type = "color",
								order = 2,
								name = L["Color"],
								hasAlpha = false,
								get = function(info)
									local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.misc.quest)
									return r, g, b
								end,
								set = function(info, r, g, b)
									local hex = E:RGBToHex(r, g, b, "ff")
									E.db.mMT.color.tags.misc.quest = hex
									MEDIA.color.tags.quest = CreateColorFromHexString(hex)
									MEDIA.color.tags.quest.hex = hex
									M.TAGs:Initialize()
								end,
							},
						},
					},
					targeting = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Targeting Players"],
						args = {
							icon = {
								order = 1,
								type = "select",
								name = L["Icon"],
								get = function(info)
									return E.db.mMT.tags.misc.targeting
								end,
								set = function(info, value)
									E.db.mMT.tags.misc.targeting = value
									M.TAGs:Initialize()
								end,
								values = BuildIconsDB,
							},
						},
					},
				},
			},
		},
	},
	raidtargetmarkers = {
		order = 5,
		type = "group",
		inline = false,
		name = L["Raidtarget Markers"],
		args = {
			star = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Star"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.raidtargetmarkers[1]
						end,
						set = function(info, value)
							E.db.mMT.tags.raidtargetmarkers[1] = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.raidtargetmarkers[1])
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.raidtargetmarkers[1] = hex
							MEDIA.color.tags.raidtargetmarkers[1]= CreateColorFromHexString(hex)
							MEDIA.color.tags.raidtargetmarkers[1].hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			circle = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Circle"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.raidtargetmarkers[2]
						end,
						set = function(info, value)
							E.db.mMT.tags.raidtargetmarkers[2] = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.raidtargetmarkers[2])
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.raidtargetmarkers[2] = hex
							MEDIA.color.tags.raidtargetmarkers[2]= CreateColorFromHexString(hex)
							MEDIA.color.tags.raidtargetmarkers[2].hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			diamond = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Diamond"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.raidtargetmarkers[3]
						end,
						set = function(info, value)
							E.db.mMT.tags.raidtargetmarkers[3] = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.raidtargetmarkers[3])
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.raidtargetmarkers[3] = hex
							MEDIA.color.tags.raidtargetmarkers[3]= CreateColorFromHexString(hex)
							MEDIA.color.tags.raidtargetmarkers[3].hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			triangle = {
				order = 4,
				type = "group",
				inline = true,
				name = L["Triangle"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.raidtargetmarkers[4]
						end,
						set = function(info, value)
							E.db.mMT.tags.raidtargetmarkers[4] = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.raidtargetmarkers[4])
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.raidtargetmarkers[4] = hex
							MEDIA.color.tags.raidtargetmarkers[4]= CreateColorFromHexString(hex)
							MEDIA.color.tags.raidtargetmarkers[4].hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			moon = {
				order = 5,
				type = "group",
				inline = true,
				name = L["Moon"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.raidtargetmarkers[5]
						end,
						set = function(info, value)
							E.db.mMT.tags.raidtargetmarkers[5] = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.raidtargetmarkers[5])
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.raidtargetmarkers[5] = hex
							MEDIA.color.tags.raidtargetmarkers[5]= CreateColorFromHexString(hex)
							MEDIA.color.tags.raidtargetmarkers[5].hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			square = {
				order = 6,
				type = "group",
				inline = true,
				name = L["Square"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.raidtargetmarkers[6]
						end,
						set = function(info, value)
							E.db.mMT.tags.raidtargetmarkers[6] = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.raidtargetmarkers[6])
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.raidtargetmarkers[6] = hex
							MEDIA.color.tags.raidtargetmarkers[6]= CreateColorFromHexString(hex)
							MEDIA.color.tags.raidtargetmarkers[6].hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			cross = {
				order = 7,
				type = "group",
				inline = true,
				name = L["Cross"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.raidtargetmarkers[7]
						end,
						set = function(info, value)
							E.db.mMT.tags.raidtargetmarkers[7] = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.raidtargetmarkers[7])
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.raidtargetmarkers[7] = hex
							MEDIA.color.tags.raidtargetmarkers[7]= CreateColorFromHexString(hex)
							MEDIA.color.tags.raidtargetmarkers[7].hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
			skull= {
				order = 8,
				type = "group",
				inline = true,
				name = L["Skull"],
				args = {
					icon = {
						order = 1,
						type = "select",
						name = L["Icon"],
						get = function(info)
							return E.db.mMT.tags.raidtargetmarkers[8]
						end,
						set = function(info, value)
							E.db.mMT.tags.raidtargetmarkers[8] = value
							M.TAGs:Initialize()
						end,
						values = BuildIconsDB,
					},
					color = {
						type = "color",
						order = 2,
						name = L["Color"],
						hasAlpha = false,
						get = function(info)
							local r, g, b = mMT:HexToRGB(E.db.mMT.color.tags.raidtargetmarkers[8])
							return r, g, b
						end,
						set = function(info, r, g, b)
							local hex = E:RGBToHex(r, g, b, "ff")
							E.db.mMT.color.tags.raidtargetmarkers[8] = hex
							MEDIA.color.tags.raidtargetmarkers[8]= CreateColorFromHexString(hex)
							MEDIA.color.tags.raidtargetmarkers[8].hex = hex
							M.TAGs:Initialize()
						end,
					},
				},
			},
		},
	},
}
