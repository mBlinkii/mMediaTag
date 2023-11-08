-- Thanks to phanx-wow with his Addon https://github.com/phanx-wow/ClassColors/tree/master

CUSTOM_CLASS_COLORS = {}

local _G = _G
local tinsert = tinsert
local updateFunctions = {}
local db = {}

local MMT_RAID_CLASS_COLORS = {
	---@type ColorMixin_RCC
	DEATHKNIGHT = { r = 0.76862752437592, g = 0.11764706671238, b = 0.22745099663734, colorStr = "ffc41e3a" },
	---@type ColorMixin_RCC
	DEMONHUNTER = { r = 0.63921570777893, g = 0.18823531270027, b = 0.78823536634445, colorStr = "ffa330c9" },
	---@type ColorMixin_RCC
	DRUID = { r = 1, g = 0.48627454042435, b = 0.039215687662363, colorStr = "ffff7c0a" },
	---@type ColorMixin_RCC
	EVOKER = { r = 0.20000001788139, g = 0.57647061347961, b = 0.49803924560547, colorStr = "ff33937f" },
	---@type ColorMixin_RCC
	HUNTER = { r = 0.66666668653488, g = 0.82745105028152, b = 0.44705885648727, colorStr = "ffaad372" },
	---@type ColorMixin_RCC
	MAGE = { r = 0.24705883860588, g = 0.78039222955704, b = 0.9215686917305, colorStr = "ff3fc7eb" },
	---@type ColorMixin_RCC
	MONK = { r = 0, g = 1, b = 0.59607845544815, colorStr = "ff00ff98" },
	---@type ColorMixin_RCC
	PALADIN = { r = 0.95686280727386, g = 0.54901963472366, b = 0.7294117808342, colorStr = "fff48cba" },
	---@type ColorMixin_RCC
	PRIEST = { r = 1, g = 1, b = 1, colorStr = "ffffffff" },
	---@type ColorMixin_RCC
	ROGUE = { r = 1, g = 0.95686280727386, b = 0.4078431725502, colorStr = "fffff468" },
	---@type ColorMixin_RCC
	SHAMAN = { r = 0, g = 0.43921571969986, b = 0.8666667342186, colorStr = "ff0070dd" },
	---@type ColorMixin_RCC
	WARLOCK = { r = 0.52941179275513, g = 0.53333336114883, b = 0.93333339691162, colorStr = "ff8788ee" },
	---@type ColorMixin_RCC
	WARRIOR = { r = 0.77647066116333, g = 0.60784316062927, b = 0.42745101451874, colorStr = "ffc69b6d" },
}

local f = CreateFrame("FRAME")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGOUT")

local function BuildColorTable()
	for class, color in pairs(_G.RAID_CLASS_COLORS) do
		if db[class] == nil then
			color = MMT_RAID_CLASS_COLORS[class]
			db[class] = { r = color.r, g = color.g, b = color.b, colorStr = color.colorStr }
		end
		CUSTOM_CLASS_COLORS[class] = color
		CUSTOM_CLASS_COLORS[class].r = db[class].r
		CUSTOM_CLASS_COLORS[class].g = db[class].g
		CUSTOM_CLASS_COLORS[class].b = db[class].b
		CUSTOM_CLASS_COLORS[class].colorStr = db[class].colorStr
	end
end
local function OnEvent(self, event, addon)
	if event == "ADDON_LOADED" and addon == "!mMT_ClassColors" then
		mMT_Colors = mMT_Colors or {}
		db = mMT_Colors

		BuildColorTable()
	elseif event == "PLAYER_LOGOUT" then
		mMT_Colors = db
	end
end

f:SetScript("OnEvent", OnEvent)

local ColorFunctions = {}
function ColorFunctions:UpdateColors()
	for class, color in pairs(_G.RAID_CLASS_COLORS) do
		CUSTOM_CLASS_COLORS[class] = db[class]
	end

	for method, handler in pairs(updateFunctions) do
		local ok, err = pcall(method, handler ~= true and handler or nil)
		if not ok then
			print("ERROR:", err)
		end
	end
end

function ColorFunctions:RegisterCallback(method, handler)
	assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :RegisterCallback (string or function expected)")
	if type(method) == "string" then
		assert(type(handler) == "table", "Bad argument #2 to :RegisterCallback (table expected)")
		assert(type(handler[method]) == "function", 'Bad argument #1 to :RegisterCallback (method "' .. method .. '" not found)')
		method = handler[method]
	end

	updateFunctions[method] = handler or true
end

function ColorFunctions:ResetColors()
	db = {}
	mMT_Colors = {}
	BuildColorTable()
	ColorFunctions:UpdateColors()
end

function ColorFunctions:UnregisterCallback(method, handler)
	assert(type(method) == "string" or type(method) == "function", "Bad argument #1 to :UnregisterCallback (string or function expected)")
	if type(method) == "string" then
		assert(type(handler) == "table", "Bad argument #2 to :UnregisterCallback (table expected)")
		assert(type(handler[method]) == "function", 'Bad argument #1 to :UnregisterCallback (method "' .. method .. '" not found)')
		method = handler[method]
	end

	updateFunctions[method] = nil
end

function ColorFunctions:SetColor(class, r, g, b)
	if db[class] then
		db[class].r = r
		db[class].g = g
		db[class].b = b
		db[class].colorStr = format("ff%02x%02x%02x", db[class].r * 255, db[class].g * 255, db[class].b * 255)
	end
end

setmetatable(CUSTOM_CLASS_COLORS, { __index = ColorFunctions })
