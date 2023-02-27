local mMT, E, L, V, P, G = unpack(select(2, ...))

local  tinsert =  tinsert

local function configTable()
	E.Options.args.mMT = {
		type = "group",
		name = mMT.Icon .. " " .. mMT.Name,
		--childGroups = "tab",
		order = 6,
		--width = "full",
		args = {
			logo = {
				type = "description",
				name = "",
				order = 1,
				image = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo\\mmt_logo.tga", 384, 96 end,
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\general.tga",
				args = {
				},
			},
			general2 = {
				order = 22,
				type = "group",
				name = L["General"],
				icon = "Interface\\Addons\\ElvUI_mMediaTag\\media\\system\\general.tga",
				args = {
				},
			},
		},
	}
end

tinsert(mMT.Config, configTable)