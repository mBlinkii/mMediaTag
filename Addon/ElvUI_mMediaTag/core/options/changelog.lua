local E, L, V, P, G = unpack(ElvUI)

local _G = _G
local tinsert = tinsert
local change_log_important_string, change_log_new_string, change_log_update_string, change_log_fix_string = nil, nil, nil, nil
local green, blue, yellow, red, endtag = "|CFF00D80E", "|CFF00A9FF", "|CFFFFCC00", "|CFFFF0048", "|r"
local new, fix, update, important, dash = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\star.tga:14:14|t", "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\misc\\done1.tga:14:14|t", "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\datatext\\upgrade7.tga:14:14|t", "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\icons\\tags\\quest2.tga:14:14|t", "> "

local change_log_important = {
	red .. "!!! Currently only for Retail" .. endtag,
	"Code Update",
	"The settings will be rest if you update from v2 to v3",
	"Removed old and unused Tags",
}

local change_log_new = {
	"More Layouts for Portraits",
	"Portraits for Focus, Pet, TargetTarget, Boss and Arena Frames",
	"Custom Role Icons for Wrath",
	"Important Spells is available for Classic and Wrath",
	"A Reload UI Popup will show if you change your ElvUI Profile",
	"mTargetingPlayers:icons:Role shows classcolred role icons of targeting Players",
	"mTargetingPlayers:icons:Stop shows classcolred icons of targeting Players",
	"Statusbartexture q5 and q6 are under testing (maybe they get an own Series)",
}

local change_log_update = {
	"Portraits Classic and Retail have now the same look, no mor different textures",
	"Optimized Portraits Events and Code",
	"Combatcheck for Teleports Datatext",
	"Optimized Portraits Settings",
	"Force Datatexts to use ElvUI Value color",
}

local change_log_fix = {
	"Nil error on Score Datatext",
	"Custom Backdrops",
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
	local releasdate = "20.09.2023"
	--change_log_important_string = Concatenation(change_log_important)
	change_log_new_string = Concatenation(change_log_new)
	change_log_update_string = Concatenation(change_log_update)
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
