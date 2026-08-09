local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local exportText, importText, button

-- options load before the modules, so the module table can only be resolved at runtime
local function Module()
	return mMT:GetModule("AddonManager")
end

mMT.options.args.misc.args.addon_manager.args = {
	text = {
		order = 1,
		type = "description",
		fontSize = "medium",
		name = L["Save your enabled addons as a named set and switch between them from Blizzard's addon list."],
	},
	spacer = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = "\n",
	},
	enable = {
		order = 3,
		type = "toggle",
		name = function()
			return E.db.mMediaTag.addon_manager.enable and MEDIA.color.green:WrapTextInColorCode(L["Enabled"]) or MEDIA.color.red:WrapTextInColorCode(L["Disabled"])
		end,
		desc = L["Add a profile dropdown and a filter to Blizzard's addon list."],
		get = function()
			return E.db.mMediaTag.addon_manager.enable
		end,
		set = function(_, value)
			E.db.mMediaTag.addon_manager.enable = value
			mMT:UpdateModule("AddonManager")
		end,
	},
	settings = {
		order = 4,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			protect = {
				order = 1,
				type = "toggle",
				name = L["Protect ElvUI and mMediaTag"],
				desc = L["Never disable ElvUI, its libraries and mMediaTag when a profile is applied."],
				disabled = function()
					return not E.db.mMediaTag.addon_manager.enable
				end,
				get = function()
					return E.db.mMediaTag.addon_manager.protect
				end,
				set = function(_, value)
					E.db.mMediaTag.addon_manager.protect = value
					Module():UpdateBar()
				end,
			},
			account = {
				order = 2,
				type = "toggle",
				name = L["Apply to all characters"],
				desc = L["Apply profiles account wide instead of only to the current character."],
				disabled = function()
					return not E.db.mMediaTag.addon_manager.enable
				end,
				get = function()
					return E.db.mMediaTag.addon_manager.account
				end,
				set = function(_, value)
					E.db.mMediaTag.addon_manager.account = value
					Module():UpdateBar()
				end,
			},
		},
	},
	header_importexport = {
		order = 10,
		type = "group",
		inline = true,
		name = L["Import/ Export of this Settings"],
		args = {
			export = {
				order = 1,
				type = "execute",
				name = L["Export"],
				func = function()
					exportText = mMT:GetExportText(DB.addon_manager.profiles, "mMTAddonProfiles")
					button = exportText and "export" or "none"
				end,
			},
			import = {
				order = 2,
				type = "execute",
				name = L["Import"],
				func = function()
					local profileData = mMT:GetImportData(importText, "mMTAddonProfiles")
					if profileData then
						E:CopyTable(DB.addon_manager.profiles, profileData)
						Module():UpdateBar()
					end
				end,
			},
			text = {
				order = 3,
				name = function()
					-- disable input box button
					E.Options.args.mMT.args.misc.args.addon_manager.args.header_importexport.args.text.disableButton = true
					E.Options.args.mMT.args.misc.args.addon_manager.args.header_importexport.args.text.textChanged = function(text)
						if text ~= importText then importText = text end
						button = "none"
					end
					return L["Output/ Input"]
				end,
				type = "input",
				width = "full",
				multiline = 10,
				set = function() end,
				get = function()
					return (button == "export" and exportText) or ""
				end,
			},
		},
	},
}
