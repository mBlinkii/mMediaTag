local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local tinsert = tinsert
local GetMountInfoByID = C_MountJournal.GetMountInfoByID

local mountIDs = {}

local function UpdateMountIDs()
	for _, mountID in ipairs({ 280, 284, 460, 1039, 2237 }) do
		local name, _, icon, _, isUsable = GetMountInfoByID(mountID)
		if isUsable then mountIDs[mountID] = format("|T%s:14:14:0:0:64:64:4:60:4:60|t %s", icon, name) end
	end
end

local function configTable()
	UpdateMountIDs()
	E.Options.args.mMT.args.datatexts.args.durabilityanditemlevel.args = {
		settings = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Settings"],
			args = {
				icon = {
					order = 1,
					name = L["Show Icons"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.durabilityIlevel.icon
					end,
					set = function(info, value)
						E.db.mMT.durabilityIlevel.icon = value
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
				},
				text = {
					order = 2,
					name = L["white Text"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.durabilityIlevel.whiteText
					end,
					set = function(info, value)
						E.db.mMT.durabilityIlevel.whiteText = value
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
				},
				shieldicon = {
					order = 3,
					name = L["white shield Icon"],
					type = "toggle",
					get = function(info)
						return E.db.mMT.durabilityIlevel.whiteIcon
					end,
					set = function(info, value)
						E.db.mMT.durabilityIlevel.whiteIcon = value
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
				},
			},
		},
		color = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Color Settings"],
			args = {
				enable = {
					order = 1,
					type = "toggle",
					name = L["Enable custom colors"],
					desc = L["Enable custom colors"],
					get = function(info)
						return E.db.mMT.durabilityIlevel.colored.enable
					end,
					set = function(info, value)
						E.db.mMT.durabilityIlevel.colored.enable = value
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
				},
				spacer_1 = {
					order = 2,
					type = "description",
					name = "\n\n",
				},
				value_a = {
					order = 3,
					name = L["Trigger"] .. " A",
					type = "range",
					min = 5,
					max = 100,
					step = 1,
					get = function(info)
						return E.db.mMT.durabilityIlevel.colored.a.value
					end,
					set = function(info, value)
						E.db.mMT.durabilityIlevel.colored.a.value = value
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
				},
				color_a = {
					type = "color",
					order = 4,
					name = L["Color"] .. " A",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.durabilityIlevel.colored.a.color
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.durabilityIlevel.colored.a.color
						t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
				},
				spacer_2 = {
					order = 5,
					type = "description",
					name = "\n\n",
				},
				value_b = {
					order = 6,
					name = L["Trigger"] .. " B",
					type = "range",
					min = 5,
					max = 100,
					step = 1,
					get = function(info)
						return E.db.mMT.durabilityIlevel.colored.b.value
					end,
					set = function(info, value)
						E.db.mMT.durabilityIlevel.colored.b.value = value
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
				},
				color_b = {
					type = "color",
					order = 7,
					name = L["Color"] .. " B",
					hasAlpha = false,
					get = function(info)
						local t = E.db.mMT.durabilityIlevel.colored.b.color
						return t.r, t.g, t.b
					end,
					set = function(info, r, g, b)
						local t = E.db.mMT.durabilityIlevel.colored.b.color
						t.r, t.g, t.b, t.hex = r, g, b, E:RGBToHex(r, g, b)
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
				},
			},
		},
		mouint = {
			order = 3,
			type = "group",
			inline = true,
			name = L["Mount"],
			args = {
				select_gradient = {
					order = 2,
					type = "select",
					name = L["Repair Mount"],
					get = function(info)
						return E.db.mMT.durabilityIlevel.mount
					end,
					set = function(info, value)
						E.db.mMT.durabilityIlevel.mount = value
						DT:ForceUpdate_DataText("DurabilityIlevel")
					end,
					values = mountIDs,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
