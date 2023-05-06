local mMT, E, L, V, P, G = unpack((select(2, ...)))

local _G = _G
local tinsert = tinsert
local tconcat = _G.table.concat
local green, blue, yellow, red, endtag = "|CFF00D80E", "|CFF00A9FF", "|CFFFFCC00", "|CFFFF0048", "|r"
local new, fix, update, important, dash =
	"|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\star.tga:14:14|t",
	"|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\done1.tga:14:14|t",
	"|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\datatext\\upgrade7.tga:14:14|t",
	"|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\tags\\quest2.tga:14:14|t",
	"> "

local change_log_important = {
	red .. "!!! Currently only for Retail" .. endtag,
	"Code Update",
	"The settings will be reset",
	"Removed old and unused Tags",
}

local change_log_new = {
	"Add new Logo and Settings for Retail 10.1",
	"More Mediafiles, for Dock, Role, Tags. Datatexts",
	"You can now choos a Icon for Chatbutton and Rollbutton",
	"Nameplate border and hover color can now be set separately",
	"Add new Target Arrows to ElvUI",
	"Add new Combat Icons to ElvUI",
	"Add new Mail Icons to ElvUI",
	"Add new Resting Icons to ElvUI",
	"Tags spelling is now consistent",
	"New Dock Icons",
	"3 special Styles for Dock Calendar",
	"Addon Compartment Tooltip",
	"5 new Icons, according to a user's request",
	"Change Log",
	"Custom Readycheck Icons",
	"Custom Phase Icons",
	"Custom Phase Colors"
}

local change_log_update = {
	"Update logo and Name",
	"Interrupt on CD now shows when the Unit is out of range",
	"M+ Datatext got more functionality for the tooltip, now shows an overview.",
	"Update Dungeon Name function for Dataext Dungeons",
	"Update the Tags, all aviable Tags under ElvUI > Tags",
	"New Tag Classification Icon",
	"Objectivetracker Skin, skins now the Dungeon tracker",
}

local change_log_fix = {
	"tag settings updatefunction",
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
    local releasdate = "05.05.2023"
	local change_log_important_string = Concatenation(change_log_important)
    local change_log_new_string = Concatenation(change_log_new)
    local change_log_update_string = Concatenation(change_log_update)
    local change_log_fix_string = Concatenation(change_log_fix)
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
							name = green .. L["Releas date:"] .. endtag .. " " .. (releasdate or "ERROR"),
						},
					},
				},
				header_important = {
					order = 2,
					type = "group",
					inline = true,
					name = important .. "  " .. red ..  L["Important:"] .. endtag,
                    hidden  = function()
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
					name = new .. "  " ..  green .. L["New:"] .. endtag,
                    hidden  = function()
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
                    hidden  = function()
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
                    hidden  = function()
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
