local E = unpack(ElvUI)
local L = mMT.Locales

local tinsert = tinsert
local dash = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\system\\dash.tga:14:14|t  "
local function Color(string)
	if type(string) ~= "string" then
		string = tostring(string)
	end

	return "[" .. "|CFF0393FF" .. string .. "|r" .. "]"
end

local function renderChangeLogLine(line)
	line = gsub(line, "%[([^%[]+)%]", Color)
	return line
end

local function configTable()
	E.Options.args.mMT.args.changelog.args = {}

	for version, data in pairs(mMT.Changelog) do
		local versionString = format("%d.%02d", version / 100, mod(tonumber(version), 100))

		E.Options.args.mMT.args.changelog.args[tostring(version)] = {
			order = 1000 - version,
			type = "group",
			guiInline = false,
			name = versionString,
			args = {},
		}

		local page = E.Options.args.mMT.args.changelog.args[tostring(version)].args

		page.date = {
			order = 1,
			type = "description",
			name = "|CFFBBBBBB" .. data.DATE
			.. " " .. L["Released"] .. "|r",
			fontSize = "small",
		}

		page.version = {
			order = 2,
			type = "description",
			name = L["Version"] .. " |CFF99FF33" .. versionString .. "|r",
			fontSize = "large",
		}

		page.space = {
			order = 3,
			type = "description",
			name = "\n\n",
			fontSize = "medium",
		}

		local importantPart = data and data.IMPORTANT
		if importantPart and #importantPart > 0 then
			local iconImportant = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\tags\\quest2.tga:14:14|t"
			page.important = {
				order = 4,
				type = "group",
				guiInline = true,
				name = iconImportant .. "  |CFFFF006C" .. L["Important"] .. "|r",
				args = {
					text = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = function()
							local text = ""
							for _, line in ipairs(importantPart) do
								text = text .. dash .. renderChangeLogLine(line) .. "\n"
							end
							return text .. "\n"
						end,
					},
				},
			}
		end

		local newPart = data and data.NEW
		if newPart and #newPart > 0 then
			local iconNew = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\star.tga:14:14|t"
			page.new = {
				order = 5,
				type = "group",
				guiInline = true,
				name = iconNew .. "  |CFF6559F1" .. L["New"] .. "|r",
				args = {
					text = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = function()
							local text = ""
							for _, line in ipairs(newPart) do
								text = text .. dash .. renderChangeLogLine(line) .. "\n"
							end
							return text .. "\n"
						end,
					},
				},
			}
		end

		local updatePart = data and data.UPDATE
		if updatePart and #updatePart > 0 then
			local iconUpdate = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\datatext\\upgrade7.tga:14:14|t"
			page.update = {
				order = 6,
				type = "group",
				guiInline = true,
				name = iconUpdate .. "  |CFFBC26E5" .. L["Updates"] .. "|r",
				args = {
					text = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = function()
							local text = ""
							for _, line in ipairs(updatePart) do
								text = text .. dash .. renderChangeLogLine(line) .. "\n"
							end
							return text .. "\n"
						end,
					},
				},
			}
		end

		local fixPart = data and data.FIX
		if fixPart and #fixPart > 0 then
			local iconFixe = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\done1.tga:14:14|t"
			page.fix = {
				order = 7,
				type = "group",
				guiInline = true,
				name = iconFixe .. "  |CFFFFA800" .. L["Fixes"] .. "|r",
				args = {
					text = {
						order = 1,
						type = "description",
						fontSize = "medium",
						name = function()
							local text = ""
							for _, line in ipairs(fixPart) do
								text = text .. dash .. renderChangeLogLine(line) .. "\n"
							end
							return text .. "\n"
						end,
					},
				},
			}
		end
	end
end

tinsert(mMT.Config, configTable)
