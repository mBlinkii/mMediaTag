local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local addon, ns = ...

--Lua functions
local mInsert = table.insert

local function OptionsBaground()
	E.Options.args.mMediaTag.args.chatbaground.args = {
		chatdescription1 = {
			order = 1,
			type = "description",
			name = L["Chath backgrounds, copy the path from the input fields to the chat settings to use the backgrounds."],
		},
		chatdescription2 = {
			order = 2,
			type = "description",
			name = "\n\n\n",
		},
		chat1 = {
			order = 3,
			name = "mChat1.1",
			type = 'input',
			width = 'full',
			get = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\backgrounds\\chat1.tga" end,
		},
		chat2 = {
			order = 4,
			name = "mChat1.2",
			type = 'input',
			width = 'full',
			get = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\backgrounds\\chat2.tga" end,
		},
		chat3 = {
			order = 5,
			name = "mChat2.1",
			type = 'input',
			width = 'full',
			get = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\backgrounds\\chat3.tga" end,
		},
		chat4 = {
			order = 6,
			name = "mChat2.2",
			type = 'input',
			width = 'full',
			get = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\backgrounds\\chat4.tga" end,
		},
		chat5 = {
			order = 7,
			name = "mChat3.1",
			type = 'input',
			width = 'full',
			get = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\backgrounds\\chat5.tga" end,
		},
		chat6 = {
			order = 8,
			name = "mChat3.2",
			type = 'input',
			width = 'full',
			get = function() return "Interface\\Addons\\ElvUI_mMediaTag\\media\\backgrounds\\chat6.tga" end,
		},
	}
end

mInsert(ns.Config, OptionsBaground)