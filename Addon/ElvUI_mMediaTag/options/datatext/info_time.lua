local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local dt_icons = MEDIA.icons.datatexts.combat

local function IconValues()
	local values = {}
	for key, icon in pairs(dt_icons) do
		values[key] = E:TextureString(icon, ":14:14")
	end

	values.none = L["None"]
	return values
end

local function Get(key)
	return function()
		return E.db.mMediaTag.datatexts.time[key]
	end
end

local function Set(key)
	return function(_, value)
		E.db.mMediaTag.datatexts.time[key] = value
		DT:ForceUpdate_DataText("mMT - Time")
	end
end

mMT.options.args.datatexts.args.info_time.args = {
	settings = {
		order = 1,
		type = "group",
		inline = true,
		name = L["Settings"],
		args = {
			description = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Switches to the combat time as soon as you enter combat."],
			},
			icon = {
				order = 2,
				type = "select",
				name = L["Clock Icon"],
				values = IconValues,
				get = Get("icon"),
				set = Set("icon"),
			},
			in_combat = {
				order = 3,
				type = "select",
				name = L["Combat Icon"],
				values = IconValues,
				get = Get("in_combat"),
				set = Set("in_combat"),
			},
			hold_delay = {
				order = 4,
				type = "range",
				name = L["Hide delay"],
				min = 0,
				max = 120,
				step = 1,
				get = Get("hold_delay"),
				set = Set("hold_delay"),
			},
		},
	},
	clock = {
		order = 2,
		type = "group",
		inline = true,
		name = L["Clock"],
		args = {
			description = {
				order = 1,
				type = "description",
				fontSize = "medium",
				name = L["Time format and tooltip are taken from ElvUI's Time datatext."],
			},
			settings = {
				order = 2,
				type = "execute",
				name = L["Settings"],
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "datatexts", "settings", "Time")
				end,
			},
		},
	},
}
