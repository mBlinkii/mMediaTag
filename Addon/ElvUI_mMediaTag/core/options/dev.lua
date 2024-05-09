local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert

local function Concatenation(tbl)
	local string = ""
	for key, line in pairs(tbl) do
		string = string  .. "[" .. key .. "] > "
		--{ name = name, id = instanceID, type = instanceType, difficultyID = difficultyID, difficultyName = difficultyName })
		--{name = UnitName("player"), guid = guid, npcid = npcID })
		if line and line.name then
			string = string .. "|CFF6559F1name|r: " .. line.name
		end

		if line and line.id then
			string = string .. " - |CFF7A4DEFid|r: " .. line.id
		end

		if line and line.type then
			string = string .. " - |CFF8845ECtyp|r: " .. line.type
		end

		if line and line.difficultyID then
			string = string .. " - |CFFA037E9diffcultyID|r: " .. line.difficultyID
		end

		if line and line.difficultyName then
			string = string .. " - |CFFA435E8difficultyName|r: " .. line.difficultyName
		end

		if line and line.guid then
			string = string .. " - |CFFB32DE6guid|r: " .. line.guid
		end

		if line and line.npcid then
			string = string .. " - |CFFBC26E5npcid|r: " .. line.npcid
		end

        if line and line.zone then
			string = string .. " - |CFFCB1EE3npcid|r: " .. line.zone
		end

        string = string .. "\n"
	end
	return string
end
local function configTable()
	E.Options.args.mMT.args.dev.args = {
		dev_unit = {
			order = 1,
			type = "group",
			inline = true,
			name = L["Unit"],
			args = {
				reset = {
					order = 1,
					type = "execute",
					name = L["Reset DB"],
					func = function()
						wipe(mMT.DB.dev.unit)
					end,
				},
				output = {
					order = 2,
					type = "description",
					fontSize = "medium",
					name = function()
						return Concatenation(mMT.DB.dev.unit)
					end,
				},
			},
		},
		dev_zone = {
			order = 2,
			type = "group",
			inline = true,
			name = L["Zone"],
			args = {
				reset = {
					order = 1,
					type = "execute",
					name = L["Reset DB"],
					func = function()
						wipe(mMT.DB.dev.zone)
					end,
				},
				output = {
					order = 2,
					type = "description",
					fontSize = "medium",
					name = function()
						return Concatenation(mMT.DB.dev.zone)
					end,
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
