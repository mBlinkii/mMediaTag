local E, L, V, P, G = unpack(ElvUI)

local _G = _G
local tinsert = tinsert
local change_log_important_string, change_log_new_string, change_log_update_string, change_log_fix_string = nil, nil, nil, nil
local green, blue, yellow, red, endtag = "|CFF00D80E", "|CFF00A9FF", "|CFFFFCC00", "|CFFFF0048", "|r"
local new, fix, update, important, dash = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\star.tga:14:14|t", "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\done1.tga:14:14|t", "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\datatext\\upgrade7.tga:14:14|t", "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\tags\\quest2.tga:14:14|t", "> "

local change_log_important = {
	red .. "!!! Important" .. endtag,
	"rework of the Important Spell feature",
	"it is possible to create filters similar to ElvUI Style filters and assign multiple",
	"spell IDs to the filters, so it is possible to have the same settings for multiple spells.",
	"before you had to define separate settings for each id",
	"This update will reset the Spell DB."
}

local releasdate = "28.04.2024"

local change_log_new = {
	"TAG mRoleIcon:blizz:nodd and mRoleIcon:nodd",
	"Icons for castbar"
}

local change_log_update = {
	"Enabled mRoleIcon Tags for Classic Versions",
	"Cleand up and optimized Objectivetracker Settings",
	"Teleports for S4",
	"Healthmarkers for S4",
	"Rework of the Important Spells module, the behavior is no like ElvUI Style filters, a filter ca now react now to more then one spell id. This update will reset the Spell DB.",
	"Currency for S4",
	"TOC file for Classic"
}

local change_log_fix = {
	"Prevent nil error with important spells",
	"Prevent nil error with tex coords Portraits/Class Icons",
	"Prevent nil error with instancdifficulty",
	"Fixed color table bug with DK classes"
}

local function Concatenation(tbl, icon, color)
	local string = ""
	for key, line in pairs(tbl) do
		if color then
			line = color .. line .. endtag
		end

		if icon then
			line = icon .. "  " .. line
		end

		string = string .. dash .. "  " .. line .. "\n"
	end
	return string
end

local function configTable()
	change_log_important_string = Concatenation(change_log_important)
	change_log_new_string = Concatenation(change_log_new)
	--change_log_update_string = Concatenation(change_log_update)
	change_log_fix_string = Concatenation(change_log_fix)
	E.Options.args.mMT.args.changelog.args = {
		header_changelog = {
			order = 1,
			type = "group",
			inline = true,
			name = mMT.IconSquare .. "  " .. mMT.Name .. "  " .. L["Change Log"],
			args = {
				header_version = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Version:"],
					args = {
						version = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = green .. mMT.Version .. endtag,
						},
						date = {
							order = 2,
							type = "description",
							fontSize = "medium",
							name = green .. L["Release"] .. endtag .. " " .. (releasdate or "ERROR"),
						},
					},
				},
				header_important = {
					order = 2,
					type = "group",
					inline = true,
					name = important .. "  " .. red .. L["Important:"] .. endtag,
					hidden = function()
						if change_log_important_string then
							return false
						else
							return true
						end
					end,
					args = {
						important = {
							order = 1,
							type = "description",
							fontSize = "large",
							name = change_log_important_string or "",
						},
					},
				},
				header_new = {
					order = 3,
					type = "group",
					inline = true,
					name = new .. "  " .. green .. L["New:"] .. endtag,
					hidden = function()
						if change_log_new_string then
							return false
						else
							return true
						end
					end,
					args = {
						new = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = change_log_new_string or "",
						},
					},
				},
				header_update = {
					order = 4,
					type = "group",
					inline = true,
					name = update .. "  " .. blue .. L["Update:"] .. endtag,
					hidden = function()
						if change_log_update_string then
							return false
						else
							return true
						end
					end,
					args = {
						update = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = change_log_update_string or "",
						},
					},
				},
				header_fix = {
					order = 5,
					type = "group",
					inline = true,
					name = fix .. "  " .. yellow .. L["Fix:"] .. endtag,
					hidden = function()
						if change_log_fix_string then
							return false
						else
							return true
						end
					end,
					args = {
						fix = {
							order = 1,
							type = "description",
							fontSize = "medium",
							name = change_log_fix_string or "",
						},
					},
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)
