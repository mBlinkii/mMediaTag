local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local format = format
local pairs = pairs

local GetAddOnMetadata = _G.C_AddOns and _G.C_AddOns.GetAddOnMetadata or _G.GetAddOnMetadata

local function pack()
	return _G.mMT_MediaPack
end

local function textures()
	local api = pack()
	return api and api.GetTextures()
end

local function setTexture(key, value)
	local db = textures()
	if not db then return end

	if key ~= "all" then db.all = false end
	db[key] = value

	E:StaticPopup_Show("CONFIG_RL")
end

local function setAll(value)
	local db = textures()
	if not db then return end

	for key in pairs(db) do
		db[key] = value
	end

	E:StaticPopup_Show("CONFIG_RL")
end

mMT.options.args.media_pack.args = {
	header = {
		order = 1,
		type = "header",
		name = function()
			return format("%s |CFFFFFFFFVer.|r |CFFF7DC6F%s|r", L["Media Pack"], GetAddOnMetadata("!mMT_MediaPack", "Version") or "?")
		end,
	},
	description = {
		order = 2,
		type = "description",
		fontSize = "medium",
		name = L["Choose which texture packs are registered. Loading fewer packs keeps the texture dropdowns short. Changes need a UI reload."],
	},
	all = {
		order = 3,
		type = "toggle",
		width = "full",
		name = L["Load all texture packs"],
		desc = L["Overrides the individual packs below."],
		get = function()
			local db = textures()
			return db and db.all
		end,
		set = function(_, value)
			setTexture("all", value)
		end,
	},
	buttons = {
		order = 4,
		type = "group",
		inline = true,
		name = "",
		args = {
			enable_all = {
				order = 1,
				type = "execute",
				name = L["Enable All"],
				func = function()
					setAll(true)
				end,
			},
			disable_all = {
				order = 2,
				type = "execute",
				name = L["Disable All"],
				func = function()
					setAll(false)
				end,
			},
		},
	},
	packs = {
		order = 5,
		type = "group",
		inline = true,
		name = L["Texture Packs"],
		disabled = function()
			local db = textures()
			return not db or db.all
		end,
		args = {},
	},
}

local function BuildPackList()
	local api = pack()
	if not api then return end

	local args = mMT.options.args.media_pack.args.packs.args
	for index, key in ipairs(api.packList) do
		args[key] = {
			order = index,
			type = "toggle",
			width = "double",
			name = format("|T%s%s.tga:14:112|t  %s", api.previewPath, key, api.label[key]),
			get = function()
				local db = textures()
				return db and (db.all or db[key]) or false
			end,
			set = function(_, value)
				setTexture(key, value)
			end,
		}
	end
end

BuildPackList()
