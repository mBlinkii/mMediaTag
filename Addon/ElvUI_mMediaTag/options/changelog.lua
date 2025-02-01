local mMT, DB, M, F, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local format = format
local gsub = gsub
local pairs = pairs
local tonumber = tonumber
local tostring = tostring
local type = type
local mod = math.fmod

local dash = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\dash.tga:14:14|t  "
local function Color(str)
	if type(str) ~= "string" then str = tostring(str) end
	return "[" .. "|CFF0393FF" .. str .. "|r" .. "]"
end

local function renderChangeLogLine(line)
	return gsub(line, "%[([^%[]+)%]", Color)
end

mMT.options.args.changelog.args = {}

do
	for version, data in pairs(mMT.Changelog) do
		local versionString = format("%d.%02d", version / 100, mod(tonumber(version), 100))

		mMT.options.args.changelog.args[tostring(version)] = {
			order = 1000 - version,
			type = "group",
			guiInline = false,
			name = versionString,
			args = {},
		}

		local page = mMT.options.args.changelog.args[tostring(version)].args

		page.date = {
			order = 1,
			type = "description",
			name = "|CFFBBBBBB" .. data.DATE .. " " .. L["Released"] .. "|r",
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

		local order = 4
		for _, line in ipairs(data.CHANGES) do
			page["line" .. order] = {
				order = order,
				type = "description",
				name = dash .. renderChangeLogLine(line),
				fontSize = "medium",
			}
			order = order + 1
		end
	end
end
