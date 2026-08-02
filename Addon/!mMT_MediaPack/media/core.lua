local addonName, ns = ...

local LSM = LibStub("LibSharedMedia-3.0")

if LSM == nil then
	return
end

local TEXTURE_PATH = [[Interface\AddOns\!mMT_MediaPack\media\textures\]]

local MediaType_BACKGROUND = LSM.MediaType.BACKGROUND
local MediaType_BORDER = LSM.MediaType.BORDER
local MediaType_FONT = LSM.MediaType.FONT
local MediaType_STATUSBAR = LSM.MediaType.STATUSBAR
local MediaType_SOUND = LSM.MediaType.SOUND

local function mAddStatusbar(name, file)
	LSM:Register(MediaType_STATUSBAR, name, TEXTURE_PATH .. file)
end

local function mAddBackground(name, file)
	LSM:Register(MediaType_BACKGROUND, name, [[Interface\AddOns\!mMT_MediaPack\media\backgrounds\]] .. file)
end

local function mAddFont(name, file)
	LSM:Register(MediaType_FONT, name, [[Interface\AddOns\!mMT_MediaPack\media\fonts\]] .. file)
end

local function mAddBorder(name, file)
	LSM:Register(MediaType_BORDER, name, [[Interface\AddOns\!mMT_MediaPack\media\border\]] .. file)
end

local function mAddSound(name, file)
	LSM:Register(MediaType_SOUND, name, [[Interface\AddOns\!mMT_MediaPack\media\sound\]] .. file)
end

-- statusbar series: "<letter><n>.tga" as "mMediaTag <LETTER><n>", highest n per series
local series = {
	a = 15, b = 16, c = 15, d = 15, e = 13, f = 15, g = 15, h = 18, i = 10, j = 10,
	k = 36, l = 15, m = 15, n = 39, o = 15, p = 18, q = 4, r = 29, s = 10, t = 8,
}

local skip = { n15 = true }

-- statusbars outside the numbering scheme, grouped into the pack they belong to
local named = {
	n = {
		["mMediaTag N38v2"] = "n38v2.tga",
		["mMediaTag N38v3"] = "n38v3.tga",
	},
	misc = {
		["mMediaTag Caith UI 1"] = "Wglass.tga",
		["mMediaTag Caith UI 2"] = "Wisps.tga",
		["MaUIv3"] = "MaUIv3.tga",
		["MaUIv3 LEFT"] = "MaUIv3Left.tga",
		["MaUIv3 RIGHT"] = "MaUIv3Right.tga",
		["mMT Blank"] = "mMT_Blank.tga",
		["mMT Target"] = "mMT_Target.tga",
		["mMT Dark"] = "mMT_Dark.tga",
	},
}

local packs, packList = {}, {}
local label, preview = { misc = "Misc" }, { misc = "Wglass.tga" }

for key in pairs(series) do
	packs[key] = true
	packList[#packList + 1] = key
	label[key] = strupper(key)
	preview[key] = key .. "1.tga"
end
sort(packList)

for key in pairs(named) do
	if not packs[key] then
		packs[key] = true
		packList[#packList + 1] = key
	end
end

ns.packList = packList
ns.label = label
ns.preview = preview
ns.TEXTURE_PATH = TEXTURE_PATH

local function LoadPack(key)
	local count = series[key]
	if count then
		local upper = strupper(key)
		for i = 1, count do
			if not skip[key .. i] then
				mAddStatusbar("mMediaTag " .. upper .. i, key .. i .. ".tga")
			end
		end
	end

	for name, file in pairs(named[key] or {}) do
		mAddStatusbar(name, file)
	end
end

local defaultDB = { textures = { all = true } }
for key in pairs(packs) do
	defaultDB.textures[key] = true
end

local mMT_MediaPack = CreateFrame("FRAME")
mMT_MediaPack:RegisterEvent("ADDON_LOADED")
function mMT_MediaPack:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "!mMT_MediaPack" then
		self:UnregisterEvent(event)

		mMTSettings = mMTSettings or {}
		mMT_MediaPack.db = mMTSettings
		mMT_MediaPack.db.textures = mMT_MediaPack.db.textures or {}

		local textures = mMT_MediaPack.db.textures
		-- per key, so a new series also reaches existing SavedVariables
		for key, default in pairs(defaultDB.textures) do
			if textures[key] == nil then
				textures[key] = default
			end
		end

		for key in pairs(packs) do
			if textures.all or textures[key] then
				LoadPack(key)
			end
		end

		ns.db = mMT_MediaPack.db
		if ns.SetupOptions then
			ns.SetupOptions()
		end
	end
end

StaticPopupDialogs["MMTMPRL"] = {
	text = "One or more of the changes you have made require a ReloadUI.",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = ReloadUI,
	whileDead = 1,
	hideOnEscape = false,
}
local function RLDialog()
	if ns.MarkDirty then
		ns.MarkDirty()
	end
	StaticPopup_Show("MMTMPRL")
end

local function PrintStatus(...)
	local name = "|CFFAB02FDm|r|CFFB820D5M|r|CFFC031BDT|r |CFFCB4A9CM|r|CFFD25A87e|r|CFFD96972d|r|CFFDE7464i|r|CFFE27E57a|r |CFFE88B46P|r|CFFF09D2Da|r|CFFF4A720c|r|CFFFCB70Ak|r"
	print(name .. ":", ...)
end

local function PrintStatusOne(setting, toggleg)
	PrintStatus("Texture Pack is |CFF1D9EF9" .. setting .. "|r:", toggleg == true and "|CFF2ECC71Enabled|r" or "|CFFE74C3CDisabled|r")
end
local function SetDBAll()
	if mMT_MediaPack.db.textures.all then
		mMT_MediaPack.db.textures.all = false
		PrintStatus("Texture Pack is |CFF1D9EF9all|r:", mMT_MediaPack.db.textures.all)
	end
end

local function DisableAll()
	for k, v in pairs(mMT_MediaPack.db.textures) do
		if mMT_MediaPack.db.textures[k] == true then
			mMT_MediaPack.db.textures[k] = false
			PrintStatusOne(k, mMT_MediaPack.db.textures[k])
		end
	end
	RLDialog()
end

local function EnableAll()
	for k, v in pairs(mMT_MediaPack.db.textures) do
		if mMT_MediaPack.db.textures[k] == false then
			mMT_MediaPack.db.textures[k] = true
			PrintStatusOne(k, mMT_MediaPack.db.textures[k])
		end
	end
	RLDialog()
end

local function SetSetting(setting)
	if setting ~= "all" then
		SetDBAll()
	end
	mMT_MediaPack.db.textures[setting] = not mMT_MediaPack.db.textures[setting]
	PrintStatusOne(setting, mMT_MediaPack.db.textures[setting])
	RLDialog()
end

local function PrintHelp()
	print("Available slash Commands:")
	print("----------------------------------------------------------")
	print("|CFFFCB70A/mmtmp|r = opens the settings panel")
	print("|CFFFCB70A/mmtmp help|r = shows the list of available commands")
	print("|CFFFCB70A/mmtmp reset|r = resets Settings to default")
	print("|CFFFCB70A/mmtmp all|r = enabled/disabled loading all textures")
	print("|CFFFCB70A/mmtmp disable all|r = disables all textures")
	print("|CFFFCB70A/mmtmp enable all|r = enables all textures")
	print("----------------------------------------------------------")
	print("To selectively enable or disable a texture pack you must enter /mmtmp followed by the letter (a - t) of the pack.")
	print("Here are three example commands")
	print("|CFFFCB70A/mmtmp a|r = enabled/disabled loading texture pack A")
	print("|CFFFCB70A/mmtmp f|r = enabled/disabled loading texture pack F")
	print("|CFFFCB70A/mmtmp misc|r = enabled/disabled loading Caith UI, MaUIv3 and mMT textures")
end

mMT_MediaPack:SetScript("OnEvent", mMT_MediaPack.OnEvent)

SLASH_MMTMP1 = "/mmtmp"
SlashCmdList.MMTMP = function(msg)
	msg = strtrim(strlower(msg or ""))

	if msg == "" and ns.OpenOptions and ns.OpenOptions() then
		return
	end

	if msg == "reset" then
		mMTSettings = CopyTable(defaultDB)
		mMT_MediaPack.db = mMTSettings
		ns.db = mMT_MediaPack.db
		PrintStatus("Settings has been reset to default")
		RLDialog()
	elseif defaultDB.textures[msg] then
		SetSetting(msg)
	elseif msg == "disable all" then
		DisableAll()
	elseif msg == "enable all" then
		EnableAll()
	elseif msg == "help" then
		PrintHelp()
	else
		print("|CFFFCB70A/mmtmp help|r to shows the list of available commands")
	end
end

for i = 1, 11 do
	mAddBackground("mMediaTag BG" .. i, "bg" .. i .. ".tga")
end

for i = 1, 12 do
	mAddBackground("mMediaTag Chat" .. i, "chat" .. i .. ".tga")
end

mAddBorder("mMediaTag Border1", "mborder1.tga")
mAddBorder("mMediaTag Border2", "mborder2.tga")
mAddBorder("mMediaTag yborder", "yborder.tga")
mAddBorder("mMediaTag yborder2", "yborder2.tga")
mAddBorder("mMediaTag YuluBorderSwitch", "YuluBorderSwitch.tga")
mAddBorder("mMediaTag YuluBorderXI", "YuluBorderXI.tga")
mAddBorder("mMT Pixel", "pixel.tga")
mAddBorder("mMT Pencil and Lieneal", "pencilandlieneal.tga")
mAddBorder("mMT Pencil and Lieneal black/white", "pencilandlienealblack.tga")
mAddBorder("mMT Speech Bubble", "bubble.tga")
mAddBorder("mMT Speech Bubble mirror", "bubblem.tga")
mAddBorder("mMT Speech Bubble red", "bubbler.tga")
mAddBorder("mMT Speech Bubble red/mirror", "bubblerm.tga")
mAddBorder("mMT Speech Bubble 2", "bubble2.tga")
mAddBorder("mMT Speech Bubble 2 mirror", "bubble2m.tga")
mAddBorder("mMT Speech Bubble 2 red", "bubble2r.tga")
mAddBorder("mMT Speech Bubble 2 red/mirror", "bubble2rm.tga")
mAddBorder("mMT Speech Bubble 3", "bubble3.tga")
mAddBorder("mMT Speech Bubble 3 mirror", "bubble3m.tga")
mAddBorder("mMT Speech Bubble 3 red", "bubble3r.tga")
mAddBorder("mMT Speech Bubble 3 red/mirror", "bubble3rm.tga")
mAddBorder("mMT Squares", "squares.tga")
mAddBorder("mMT Squares mirror", "squaresm.tga")
mAddBorder("mMT Squares red", "squaresr.tga")
mAddBorder("mMT Squares red/mirror", "squaresrm.tga")
mAddBorder("mMT Corners", "corners.tga")
mAddBorder("mMT Round", "round.tga")
mAddBorder("mMT Drawn", "drawn.tga")
mAddBorder("mMT Wood", "wood.tga")
mAddBorder("mMT Glass", "glass.tga")
mAddBorder("mMT Heart and Star", "heartandstar.tga")
mAddBorder("mMT Round Corners", "roundcorners.tga")

mAddFont("Inter-Bold", "Inter-Bold.ttf")
mAddFont("Inter-Regular", "Inter-Regular.ttf")
mAddFont("Inter-SemiBold", "Inter-SemiBold.ttf")

mAddFont("Lemon-Regular", "Lemon-Regular.ttf")

mAddFont("Ubuntu-Bold", "Ubuntu-Bold.ttf")
mAddFont("Ubuntu-Medium", "Ubuntu-Medium.ttf")

mAddFont("NotoSans-Bold", "NotoSans-Bold.ttf")
mAddFont("NotoSans-SemiBold", "NotoSans-SemiBold.ttf")

mAddFont("Montserrat-Bold", "Montserrat-Bold.ttf")
mAddFont("Montserrat-Medium", "Montserrat-Medium.ttf")
mAddFont("Montserrat-Regular", "Montserrat-Regular.ttf")
mAddFont("Montserrat-SemiBold", "Montserrat-SemiBold.ttf")

mAddFont("BarlowCondensed-Bold", "BarlowCondensed-Bold.ttf")
mAddFont("BarlowCondensed-Medium", "BarlowCondensed-Medium.ttf")
mAddFont("BarlowCondensed-Regular", "BarlowCondensed-Regular.ttf")
mAddFont("BarlowCondensed-SemiBold", "BarlowCondensed-SemiBold.ttf")

mAddFont("Beep-Bold", "Beep-Bold.otf")
mAddFont("Beep-Medium", "Beep-Medium.otf")
mAddFont("Beep-Regular", "Beep-Regular.otf")

mAddFont("RingLink-Bold", "RingLink-Bold.otf")
mAddFont("RingLink-Medium", "RingLink-Medium.otf")

mAddFont("SimplySans-Bold", "SimplySans-Bold.ttf")
mAddFont("SimplySans-Book", "SimplySans-Book.ttf")

mAddSound("mMT - Bewegen - weiblich", "bewegen_female.ogg")
mAddSound("mMT - Unterbrechen - weiblich", "unterbrechen_female.ogg")
mAddSound("mMT - Bewegen - mänlich", "bewegen_male.ogg")
mAddSound("mMT - Unterbrechen - mänlich", "unterbrechen_male.ogg")

mAddSound("mMT - Feet - female", "feet_female.ogg")
mAddSound("mMT - Get out - female", "getout_female.ogg")
mAddSound("mMT - Interrupt - female", "interrupt_female.ogg")
mAddSound("mMT - Kick - female", "kick_female.ogg")
mAddSound("mMT - STUN! - female", "loud_stun_female.ogg")
mAddSound("mMT - Stun - female", "stun_female.ogg")

mAddSound("mMT - Feet - male", "feet_male.ogg")
mAddSound("mMT - Interrupt - male", "interrupt_male.ogg")
mAddSound("mMT - Stun - male", "stun_male.ogg")

mAddSound("mMT - AOE - DE - male", "aoe_de_male.ogg")
mAddSound("mMT - AOE - DE - female", "aoe_de_female.ogg")
mAddSound("mMT - AOE - male", "aoe_male.ogg")
mAddSound("mMT - AOE - female", "aoe_female.ogg")
mAddSound("mMT - AOE 2 - female", "aoe_b_female.ogg")

mAddSound("mMT - Frontal - male", "frontal_male.ogg")
mAddSound("mMT - Frontal - female", "frontal_female.ogg")
mAddSound("mMT - Frontal 2 - female", "frontal_b_female.ogg")

mAddSound("mMT - Incorp - male", "incorp_male.ogg")
mAddSound("mMT - Incorp - female", "incorp_female.ogg")
mAddSound("mMT - Incorporeal - male", "incorporeal_male.ogg")
mAddSound("mMT - Incorporeal - female", "incorporeal_female.ogg")
