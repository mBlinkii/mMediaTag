local E = unpack(ElvUI)
local L = mMT.Locales

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
	"This update will reset the Spell DB.",
}

local releasdate = "28.06.2024"

local change_log_new = {
	"Portraits can now use custom textures.",
	"Portraits can now show cast icon, available for player, target, focus, party, boss, and arena.",
	"Portraits setting to force reaction colors on Player Units.",
	"TAGs: mLevel:hidecombat, mLevelSmart:hidecombat, mHealth:onlypercent-with-absorbs:ndp, mHealth:short:absorbs, mColor:absorbs.",
	"TAGs: mHealth:current-percent:absorbs, mHealth:current-percent:ndp:absorbs, mHealth:current-percent:short:absorbs, mHealth:current-percent:short:ndp:absorbs.",
	"Add general TOC file for WOTLK Version in China",
}

local change_log_update = {
	"Add no Profession text and Icon to first and second Profession data text.",
	"White text setting for Profession data text.",
	"NEW: Icon for Teleports data text.",
	"Portraits texture names.",
	"Removed Portraits texture simple square and added flipped Versions for Drop texture.",
	"Add Stone of the Hearth and Draenic Hologem to TP datatext (thx to Merathilis)",
}

local change_log_fix = {
	"Portraits colors if gradient mode is disabled.",
	"Portraits can now properly enable/disable on the fly.",
	"Portraits corner won't hide if the texture does not support it.",
	"Tooltip Icon can override Item names in Classic.",
	"Tooltip and Teleports Datatext for TWW, (for beta use, disable the Objectivetracker Skin).",
	"Removed empty data text entry.",
	"Add S Pack to mMT Settings DB.",
	"Datatext Durability/ Ilevel: Durability color values.",
	"Removed debug print.",
	"Portraits Optimized code and fixed flipped drop texture (black background)",
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
	--change_log_important_string = Concatenation(change_log_important)
	change_log_new_string = Concatenation(change_log_new)
	change_log_update_string = Concatenation(change_log_update)
	change_log_fix_string = Concatenation(change_log_fix)
	E.Options.args.mMT.args.changelog.args = {
		header_changelog = {
			order = 1,
			type = "group",
			inline = true,
			name = mMT.IconSquare .. "  " .. mMT.Name .. "  " .. L["Changelog"],
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
