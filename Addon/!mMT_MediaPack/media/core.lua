local LSM = LibStub("LibSharedMedia-3.0")

if LSM == nil then
	return
end

local MediaType_BACKGROUND = LSM.MediaType.BACKGROUND
local MediaType_BORDER = LSM.MediaType.BORDER
local MediaType_FONT = LSM.MediaType.FONT
local MediaType_STATUSBAR = LSM.MediaType.STATUSBAR

local function mAddStatusbar(name, file)
	LSM:Register(MediaType_STATUSBAR, name, [[Interface\AddOns\!mMT_MediaPack\media\textures\]] .. file)
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

local function LoadSeriesA()
	mAddStatusbar("mMediaTag A1", "a1.tga")
	mAddStatusbar("mMediaTag A2", "a2.tga")
	mAddStatusbar("mMediaTag A3", "a3.tga")
	mAddStatusbar("mMediaTag A4", "a4.tga")
	mAddStatusbar("mMediaTag A5", "a5.tga")
	mAddStatusbar("mMediaTag A6", "a6.tga")
	mAddStatusbar("mMediaTag A7", "a7.tga")
	mAddStatusbar("mMediaTag A8", "a8.tga")
	mAddStatusbar("mMediaTag A9", "a9.tga")
	mAddStatusbar("mMediaTag A10", "a10.tga")
	mAddStatusbar("mMediaTag A11", "a11.tga")
	mAddStatusbar("mMediaTag A12", "a12.tga")
	mAddStatusbar("mMediaTag A13", "a13.tga")
	mAddStatusbar("mMediaTag A14", "a14.tga")
	mAddStatusbar("mMediaTag A15", "a15.tga")
end

local function LoadSeriesB()
	mAddStatusbar("mMediaTag B1", "b1.tga")
	mAddStatusbar("mMediaTag B2", "b2.tga")
	mAddStatusbar("mMediaTag B3", "b3.tga")
	mAddStatusbar("mMediaTag B4", "b4.tga")
	mAddStatusbar("mMediaTag B5", "b5.tga")
	mAddStatusbar("mMediaTag B6", "b6.tga")
	mAddStatusbar("mMediaTag B7", "b7.tga")
	mAddStatusbar("mMediaTag B8", "b8.tga")
	mAddStatusbar("mMediaTag B9", "b9.tga")
	mAddStatusbar("mMediaTag B10", "b10.tga")
	mAddStatusbar("mMediaTag B11", "b11.tga")
	mAddStatusbar("mMediaTag B12", "b12.tga")
	mAddStatusbar("mMediaTag B13", "b13.tga")
	mAddStatusbar("mMediaTag B14", "b14.tga")
	mAddStatusbar("mMediaTag B15", "b15.tga")
	mAddStatusbar("mMediaTag B16", "b16.tga")
	mAddStatusbar("mMediaTag B17", "b17.tga")
end

local function LoadSeriesC()
	mAddStatusbar("mMediaTag C1", "c1.tga")
	mAddStatusbar("mMediaTag C2", "c2.tga")
	mAddStatusbar("mMediaTag C3", "c3.tga")
	mAddStatusbar("mMediaTag C4", "c4.tga")
	mAddStatusbar("mMediaTag C5", "c5.tga")
	mAddStatusbar("mMediaTag C6", "c6.tga")
	mAddStatusbar("mMediaTag C7", "c7.tga")
	mAddStatusbar("mMediaTag C8", "c8.tga")
	mAddStatusbar("mMediaTag C9", "c9.tga")
	mAddStatusbar("mMediaTag C10", "c10.tga")
	mAddStatusbar("mMediaTag C11", "c11.tga")
	mAddStatusbar("mMediaTag C12", "c12.tga")
	mAddStatusbar("mMediaTag C13", "c13.tga")
	mAddStatusbar("mMediaTag C14", "c14.tga")
	mAddStatusbar("mMediaTag C15", "c15.tga")
end

local function LoadSeriesD()
	mAddStatusbar("mMediaTag D1", "d1.tga")
	mAddStatusbar("mMediaTag D2", "d2.tga")
	mAddStatusbar("mMediaTag D3", "d3.tga")
	mAddStatusbar("mMediaTag D4", "d4.tga")
	mAddStatusbar("mMediaTag D5", "d5.tga")
	mAddStatusbar("mMediaTag D6", "d6.tga")
	mAddStatusbar("mMediaTag D7", "d7.tga")
	mAddStatusbar("mMediaTag D8", "d8.tga")
	mAddStatusbar("mMediaTag D9", "d9.tga")
	mAddStatusbar("mMediaTag D10", "d10.tga")
	mAddStatusbar("mMediaTag D11", "d11.tga")
	mAddStatusbar("mMediaTag D12", "d12.tga")
	mAddStatusbar("mMediaTag D13", "d13.tga")
	mAddStatusbar("mMediaTag D14", "d14.tga")
	mAddStatusbar("mMediaTag D15", "d15.tga")
end

local function LoadSeriesE()
	mAddStatusbar("mMediaTag E1", "e1.tga")
	mAddStatusbar("mMediaTag E2", "e2.tga")
	mAddStatusbar("mMediaTag E3", "e3.tga")
	mAddStatusbar("mMediaTag E4", "e4.tga")
	mAddStatusbar("mMediaTag E5", "e5.tga")
	mAddStatusbar("mMediaTag E6", "e6.tga")
	mAddStatusbar("mMediaTag E7", "e7.tga")
	mAddStatusbar("mMediaTag E8", "e8.tga")
	mAddStatusbar("mMediaTag E9", "e9.tga")
	mAddStatusbar("mMediaTag E10", "e10.tga")
	mAddStatusbar("mMediaTag E11", "e11.tga")
	mAddStatusbar("mMediaTag E12", "e12.tga")
end

local function LoadSeriesF()
	mAddStatusbar("mMediaTag F1", "f1.tga")
	mAddStatusbar("mMediaTag F2", "f2.tga")
	mAddStatusbar("mMediaTag F3", "f3.tga")
	mAddStatusbar("mMediaTag F4", "f4.tga")
	mAddStatusbar("mMediaTag F5", "f5.tga")
	mAddStatusbar("mMediaTag F6", "f6.tga")
	mAddStatusbar("mMediaTag F7", "f7.tga")
	mAddStatusbar("mMediaTag F8", "f8.tga")
	mAddStatusbar("mMediaTag F9", "f9.tga")
	mAddStatusbar("mMediaTag F10", "f10.tga")
	mAddStatusbar("mMediaTag F11", "f11.tga")
	mAddStatusbar("mMediaTag F12", "f12.tga")
	mAddStatusbar("mMediaTag F13", "f13.tga")
	mAddStatusbar("mMediaTag F14", "f14.tga")
	mAddStatusbar("mMediaTag F15", "f15.tga")
end

local function LoadSeriesG()
	mAddStatusbar("mMediaTag G1", "g1.tga")
	mAddStatusbar("mMediaTag G2", "g2.tga")
	mAddStatusbar("mMediaTag G3", "g3.tga")
	mAddStatusbar("mMediaTag G4", "g4.tga")
	mAddStatusbar("mMediaTag G5", "g5.tga")
	mAddStatusbar("mMediaTag G6", "g6.tga")
	mAddStatusbar("mMediaTag G7", "g7.tga")
	mAddStatusbar("mMediaTag G8", "g8.tga")
	mAddStatusbar("mMediaTag G9", "g9.tga")
	mAddStatusbar("mMediaTag G10", "g10.tga")
	mAddStatusbar("mMediaTag G11", "g11.tga")
	mAddStatusbar("mMediaTag G12", "g12.tga")
	mAddStatusbar("mMediaTag G13", "g13.tga")
	mAddStatusbar("mMediaTag G14", "g14.tga")
	mAddStatusbar("mMediaTag G15", "g15.tga")
end

local function LoadSeriesH()
	mAddStatusbar("mMediaTag H1", "h1.tga")
	mAddStatusbar("mMediaTag H2", "h2.tga")
	mAddStatusbar("mMediaTag H3", "h3.tga")
	mAddStatusbar("mMediaTag H4", "h4.tga")
	mAddStatusbar("mMediaTag H5", "h5.tga")
	mAddStatusbar("mMediaTag H6", "h6.tga")
	mAddStatusbar("mMediaTag H7", "h7.tga")
	mAddStatusbar("mMediaTag H8", "h8.tga")
	mAddStatusbar("mMediaTag H9", "h9.tga")
	mAddStatusbar("mMediaTag H10", "h10.tga")
	mAddStatusbar("mMediaTag H11", "h11.tga")
	mAddStatusbar("mMediaTag H12", "h12.tga")
	mAddStatusbar("mMediaTag H13", "h13.tga")
	mAddStatusbar("mMediaTag H14", "h14.tga")
	mAddStatusbar("mMediaTag H15", "h15.tga")
	mAddStatusbar("mMediaTag H16", "h16.tga")
	mAddStatusbar("mMediaTag H17", "h17.tga")
	mAddStatusbar("mMediaTag H18", "h18.tga")
end

local function LoadSeriesI()
	mAddStatusbar("mMediaTag I1", "i1.tga")
	mAddStatusbar("mMediaTag I2", "i2.tga")
	mAddStatusbar("mMediaTag I3", "i3.tga")
	mAddStatusbar("mMediaTag I4", "i4.tga")
	mAddStatusbar("mMediaTag I5", "i5.tga")
	mAddStatusbar("mMediaTag I6", "i6.tga")
	mAddStatusbar("mMediaTag I7", "i7.tga")
	mAddStatusbar("mMediaTag I8", "i8.tga")
	mAddStatusbar("mMediaTag I9", "i9.tga")
	mAddStatusbar("mMediaTag I10", "i10.tga")
end

local function LoadSeriesJ()
	mAddStatusbar("mMediaTag J1", "j1.tga")
	mAddStatusbar("mMediaTag J2", "j2.tga")
	mAddStatusbar("mMediaTag J3", "j3.tga")
	mAddStatusbar("mMediaTag J4", "j4.tga")
	mAddStatusbar("mMediaTag J5", "j5.tga")
	mAddStatusbar("mMediaTag J6", "j6.tga")
	mAddStatusbar("mMediaTag J7", "j7.tga")
	mAddStatusbar("mMediaTag J8", "j8.tga")
	mAddStatusbar("mMediaTag J9", "j9.tga")
	mAddStatusbar("mMediaTag J10", "j10.tga")
end

local function LoadSeriesK()
	mAddStatusbar("mMediaTag K1", "k1.tga")
	mAddStatusbar("mMediaTag K2", "k2.tga")
	mAddStatusbar("mMediaTag K3", "k3.tga")
	mAddStatusbar("mMediaTag K4", "k4.tga")
	mAddStatusbar("mMediaTag K5", "k5.tga")
	mAddStatusbar("mMediaTag K6", "k6.tga")
	mAddStatusbar("mMediaTag K7", "k7.tga")
	mAddStatusbar("mMediaTag K8", "k8.tga")
	mAddStatusbar("mMediaTag K9", "k9.tga")
	mAddStatusbar("mMediaTag K10", "k10.tga")
	mAddStatusbar("mMediaTag K11", "k11.tga")
	mAddStatusbar("mMediaTag K12", "k12.tga")
	mAddStatusbar("mMediaTag K13", "k13.tga")
	mAddStatusbar("mMediaTag K14", "k14.tga")
	mAddStatusbar("mMediaTag K15", "k15.tga")
	mAddStatusbar("mMediaTag K16", "k16.tga")
	mAddStatusbar("mMediaTag K17", "k17.tga")
	mAddStatusbar("mMediaTag K18", "k18.tga")
	mAddStatusbar("mMediaTag K19", "k19.tga")
	mAddStatusbar("mMediaTag K20", "k20.tga")
	mAddStatusbar("mMediaTag K21", "k21.tga")
	mAddStatusbar("mMediaTag K22", "k22.tga")
	mAddStatusbar("mMediaTag K23", "k23.tga")
	mAddStatusbar("mMediaTag K24", "k24.tga")
	mAddStatusbar("mMediaTag K25", "k25.tga")
	mAddStatusbar("mMediaTag K26", "k26.tga")
	mAddStatusbar("mMediaTag K27", "k27.tga")
	mAddStatusbar("mMediaTag K28", "k28.tga")
	mAddStatusbar("mMediaTag K29", "k29.tga")
	mAddStatusbar("mMediaTag K30", "k30.tga")
	mAddStatusbar("mMediaTag K31", "k31.tga")
	mAddStatusbar("mMediaTag K32", "k32.tga")
	mAddStatusbar("mMediaTag K33", "k33.tga")
	mAddStatusbar("mMediaTag K34", "k34.tga")
	mAddStatusbar("mMediaTag K35", "k35.tga")
end

local function LoadSeriesL()
	mAddStatusbar("mMediaTag L1", "l1.tga")
	mAddStatusbar("mMediaTag L2", "l2.tga")
	mAddStatusbar("mMediaTag L3", "l3.tga")
	mAddStatusbar("mMediaTag L4", "l4.tga")
	mAddStatusbar("mMediaTag L5", "l5.tga")
	mAddStatusbar("mMediaTag L6", "l6.tga")
	mAddStatusbar("mMediaTag L7", "l7.tga")
	mAddStatusbar("mMediaTag L8", "l8.tga")
	mAddStatusbar("mMediaTag L9", "l9.tga")
	mAddStatusbar("mMediaTag L10", "l10.tga")
	mAddStatusbar("mMediaTag L11", "l11.tga")
	mAddStatusbar("mMediaTag L12", "l12.tga")
	mAddStatusbar("mMediaTag L13", "l13.tga")
	mAddStatusbar("mMediaTag L14", "l14.tga")
	mAddStatusbar("mMediaTag L15", "l15.tga")
end

local function LoadSeriesM()
	mAddStatusbar("mMediaTag M1", "m1.tga")
	mAddStatusbar("mMediaTag M2", "m2.tga")
	mAddStatusbar("mMediaTag M3", "m3.tga")
	mAddStatusbar("mMediaTag M4", "m4.tga")
	mAddStatusbar("mMediaTag M5", "m5.tga")
	mAddStatusbar("mMediaTag M6", "m6.tga")
	mAddStatusbar("mMediaTag M7", "m7.tga")
	mAddStatusbar("mMediaTag M8", "m8.tga")
	mAddStatusbar("mMediaTag M9", "m9.tga")
	mAddStatusbar("mMediaTag M10", "m10.tga")
	mAddStatusbar("mMediaTag M11", "m11.tga")
	mAddStatusbar("mMediaTag M12", "m12.tga")
	mAddStatusbar("mMediaTag M13", "m13.tga")
	mAddStatusbar("mMediaTag M14", "m14.tga")
	mAddStatusbar("mMediaTag M15", "m15.tga")
end

local function LoadSeriesN()
	mAddStatusbar("mMediaTag N1", "n1.tga")
	mAddStatusbar("mMediaTag N2", "n2.tga")
	mAddStatusbar("mMediaTag N3", "n3.tga")
	mAddStatusbar("mMediaTag N4", "n4.tga")
	mAddStatusbar("mMediaTag N5", "n5.tga")
	mAddStatusbar("mMediaTag N6", "n6.tga")
	mAddStatusbar("mMediaTag N7", "n7.tga")
	mAddStatusbar("mMediaTag N8", "n8.tga")
	mAddStatusbar("mMediaTag N9", "n9.tga")
	mAddStatusbar("mMediaTag N10", "n10.tga")
	mAddStatusbar("mMediaTag N11", "n11.tga")
	mAddStatusbar("mMediaTag N12", "n12.tga")
	mAddStatusbar("mMediaTag N13", "n13.tga")
	mAddStatusbar("mMediaTag N14", "n14.tga")
	mAddStatusbar("mMediaTag N15", "n15.tga")
	mAddStatusbar("mMediaTag N16", "n16.tga")
	mAddStatusbar("mMediaTag N17", "n17.tga")
	mAddStatusbar("mMediaTag N18", "n18.tga")
	mAddStatusbar("mMediaTag N19", "n19.tga")
	mAddStatusbar("mMediaTag N20", "n20.tga")
	mAddStatusbar("mMediaTag N21", "n21.tga")
	mAddStatusbar("mMediaTag N22", "n22.tga")
	mAddStatusbar("mMediaTag N23", "n23.tga")
	mAddStatusbar("mMediaTag N24", "n24.tga")
	mAddStatusbar("mMediaTag N25", "n25.tga")
	mAddStatusbar("mMediaTag N26", "n26.tga")
	mAddStatusbar("mMediaTag N27", "n27.tga")
	mAddStatusbar("mMediaTag N28", "n28.tga")
	mAddStatusbar("mMediaTag N29", "n29.tga")
	mAddStatusbar("mMediaTag N30", "n30.tga")
	mAddStatusbar("mMediaTag N31", "n31.tga")
	mAddStatusbar("mMediaTag N32", "n32.tga")
	mAddStatusbar("mMediaTag N33", "n33.tga")
	mAddStatusbar("mMediaTag N34", "n34.tga")
	mAddStatusbar("mMediaTag N35", "n35.tga")
	mAddStatusbar("mMediaTag N36", "n36.tga")
	mAddStatusbar("mMediaTag N37", "n37.tga")
	mAddStatusbar("mMediaTag N38", "n38.tga")
	mAddStatusbar("mMediaTag N38v2", "n38v2.tga")
	mAddStatusbar("mMediaTag N38v3", "n38v3.tga")
	mAddStatusbar("mMediaTag N39", "n39.tga")
end

local function LoadSeriesO()
	mAddStatusbar("mMediaTag O1", "o1.tga")
	mAddStatusbar("mMediaTag O2", "o2.tga")
	mAddStatusbar("mMediaTag O3", "o3.tga")
	mAddStatusbar("mMediaTag O4", "o4.tga")
	mAddStatusbar("mMediaTag O5", "o5.tga")
	mAddStatusbar("mMediaTag O6", "o6.tga")
	mAddStatusbar("mMediaTag O7", "o7.tga")
	mAddStatusbar("mMediaTag O8", "o8.tga")
	mAddStatusbar("mMediaTag O9", "o9.tga")
	mAddStatusbar("mMediaTag O10", "o10.tga")
	mAddStatusbar("mMediaTag O11", "o11.tga")
	mAddStatusbar("mMediaTag O12", "o12.tga")
	mAddStatusbar("mMediaTag O13", "o13.tga")
	mAddStatusbar("mMediaTag O14", "o14.tga")
	mAddStatusbar("mMediaTag O15", "o15.tga")
end

local function LoadSeriesP()
	mAddStatusbar("mMediaTag P1", "p1.tga")
	mAddStatusbar("mMediaTag P2", "p2.tga")
	mAddStatusbar("mMediaTag P3", "p3.tga")
	mAddStatusbar("mMediaTag P4", "p4.tga")
	mAddStatusbar("mMediaTag P5", "p5.tga")
	mAddStatusbar("mMediaTag P6", "p6.tga")
	mAddStatusbar("mMediaTag P7", "p7.tga")
	mAddStatusbar("mMediaTag P8", "p8.tga")
	mAddStatusbar("mMediaTag P9", "p9.tga")
	mAddStatusbar("mMediaTag P10", "p10.tga")
	mAddStatusbar("mMediaTag P11", "p11.tga")
	mAddStatusbar("mMediaTag P12", "p12.tga")
	mAddStatusbar("mMediaTag P13", "p13.tga")
	mAddStatusbar("mMediaTag P14", "p14.tga")
	mAddStatusbar("mMediaTag P15", "p15.tga")
	mAddStatusbar("mMediaTag P16", "p16.tga")
	mAddStatusbar("mMediaTag P17", "p17.tga")
	mAddStatusbar("mMediaTag P18", "p18.tga")
end

local function LoadSeriesQ()
	mAddStatusbar("mMediaTag Q1", "q1.tga")
	mAddStatusbar("mMediaTag Q2", "q2.tga")
	mAddStatusbar("mMediaTag Q3", "q3.tga")
	mAddStatusbar("mMediaTag Q4", "q4.tga")
end
local function LoadSeriesR()
	mAddStatusbar("mMediaTag R1", "r1.tga")
	mAddStatusbar("mMediaTag R2", "r2.tga")
	mAddStatusbar("mMediaTag R3", "r3.tga")
	mAddStatusbar("mMediaTag R4", "r4.tga")
	mAddStatusbar("mMediaTag R5", "r5.tga")
	mAddStatusbar("mMediaTag R6", "r6.tga")
	mAddStatusbar("mMediaTag R7", "r7.tga")
	mAddStatusbar("mMediaTag R8", "r8.tga")
	mAddStatusbar("mMediaTag R9", "r9.tga")
	mAddStatusbar("mMediaTag R10", "r10.tga")
	mAddStatusbar("mMediaTag R11", "r11.tga")
	mAddStatusbar("mMediaTag R12", "r12.tga")
	mAddStatusbar("mMediaTag R13", "r13.tga")
	mAddStatusbar("mMediaTag R14", "r14.tga")
	mAddStatusbar("mMediaTag R15", "r15.tga")
	mAddStatusbar("mMediaTag R16", "r16.tga")
	mAddStatusbar("mMediaTag R17", "r17.tga")
	mAddStatusbar("mMediaTag R18", "r18.tga")
	mAddStatusbar("mMediaTag R19", "r19.tga")
	mAddStatusbar("mMediaTag R20", "r20.tga")
	mAddStatusbar("mMediaTag R21", "r21.tga")
	mAddStatusbar("mMediaTag R22", "r22.tga")
	mAddStatusbar("mMediaTag R23", "r23.tga")
	mAddStatusbar("mMediaTag R24", "r24.tga")
	mAddStatusbar("mMediaTag R25", "r25.tga")
	mAddStatusbar("mMediaTag R26", "r26.tga")
	mAddStatusbar("mMediaTag R27", "r27.tga")
	mAddStatusbar("mMediaTag R28", "r28.tga")
	mAddStatusbar("mMediaTag R29", "r29.tga")
end

local function LoadSeriesAll()
	LoadSeriesA()
	LoadSeriesB()
	LoadSeriesC()
	LoadSeriesD()
	LoadSeriesE()
	LoadSeriesF()
	LoadSeriesG()
	LoadSeriesH()
	LoadSeriesI()
	LoadSeriesJ()
	LoadSeriesK()
	LoadSeriesL()
	LoadSeriesM()
	LoadSeriesN()
	LoadSeriesO()
	LoadSeriesP()
	LoadSeriesQ()
	LoadSeriesR()
end

local defaultDB = {
	textures = {
		all = true,
		a = true,
		b = true,
		c = true,
		d = true,
		e = true,
		f = true,
		g = true,
		h = true,
		i = true,
		j = true,
		k = true,
		l = true,
		n = true,
		m = true,
		o = true,
		p = true,
		q = true,
		r = true,
	},
}

local mMT_MediaPack = CreateFrame("FRAME")
mMT_MediaPack:RegisterEvent("ADDON_LOADED")
mMT_MediaPack:RegisterEvent("PLAYER_LOGOUT")
function mMT_MediaPack:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "!mMT_MediaPack" then
		mMTSettings = mMTSettings or {}
		mMT_MediaPack.db = mMTSettings

		for k, v in pairs(defaultDB) do
			if mMT_MediaPack.db[k] == nil then
				mMT_MediaPack.db[k] = v
			end
		end

		if mMT_MediaPack.db.textures.all then
			LoadSeriesAll()
		end
		if mMT_MediaPack.db.textures.a then
			LoadSeriesA()
		end
		if mMT_MediaPack.db.textures.b then
			LoadSeriesB()
		end
		if mMT_MediaPack.db.textures.c then
			LoadSeriesC()
		end
		if mMT_MediaPack.db.textures.d then
			LoadSeriesD()
		end
		if mMT_MediaPack.db.textures.e then
			LoadSeriesE()
		end
		if mMT_MediaPack.db.textures.f then
			LoadSeriesF()
		end
		if mMT_MediaPack.db.textures.g then
			LoadSeriesG()
		end
		if mMT_MediaPack.db.textures.h then
			LoadSeriesH()
		end
		if mMT_MediaPack.db.textures.i then
			LoadSeriesI()
		end
		if mMT_MediaPack.db.textures.j then
			LoadSeriesJ()
		end
		if mMT_MediaPack.db.textures.k then
			LoadSeriesK()
		end
		if mMT_MediaPack.db.textures.l then
			LoadSeriesL()
		end
		if mMT_MediaPack.db.textures.m then
			LoadSeriesM()
		end
		if mMT_MediaPack.db.textures.n then
			LoadSeriesN()
		end
		if mMT_MediaPack.db.textures.o then
			LoadSeriesO()
		end
		if mMT_MediaPack.db.textures.p then
			LoadSeriesP()
		end
		if mMT_MediaPack.db.textures.q then
			LoadSeriesQ()
		end
		if mMT_MediaPack.db.textures.r then
			LoadSeriesR()
		end
	elseif event == "PLAYER_LOGOUT" then
		mMTSettings = mMT_MediaPack.db
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
	print("|CFFFCB70A/mmtmp help|r = shows the list of available commands")
	print("|CFFFCB70A/mmtmp reset|r = resets Settings to default")
	print("|CFFFCB70A/mmtmp all|r = enabled/disabled loading all textures")
	print("|CFFFCB70A/mmtmp disable all|r = disables all textures")
	print("|CFFFCB70A/mmtmp enable all|r = enables all textures")
	print("----------------------------------------------------------")
	print("To selectively enable or disable a texture pack you must enter /mmtmp followed by the letter (a - r) of the pack.")
	print("Here are two example commands")
	print("|CFFFCB70A/mmtmp a|r = enabled/disabled loading texture pack A")
	print("|CFFFCB70A/mmtmp f|r = enabled/disabled loading texture pack F")
end

mMT_MediaPack:SetScript("OnEvent", mMT_MediaPack.OnEvent)

SLASH_MMTMP1 = "/mmtmp"
SlashCmdList.MMTMP = function(msg, editBox)
	msg = strlower(msg)

	if msg == "reset" then
		mMTSettings = CopyTable(defaultDB) -- reset to defaults
		mMT_MediaPack.db = mMTSettings
		PrintStatus("Settings has been reset to default")
		RLDialog()
	elseif msg == "a" then
		SetSetting(msg)
	elseif msg == "b" then
		SetSetting(msg)
	elseif msg == "c" then
		SetSetting(msg)
	elseif msg == "d" then
		SetSetting(msg)
	elseif msg == "e" then
		SetSetting(msg)
	elseif msg == "f" then
		SetSetting(msg)
	elseif msg == "g" then
		SetSetting(msg)
	elseif msg == "h" then
		SetSetting(msg)
	elseif msg == "i" then
		SetSetting(msg)
	elseif msg == "j" then
		SetSetting(msg)
	elseif msg == "k" then
		SetSetting(msg)
	elseif msg == "l" then
		SetSetting(msg)
	elseif msg == "m" then
		SetSetting(msg)
	elseif msg == "n" then
		SetSetting(msg)
	elseif msg == "o" then
		SetSetting(msg)
	elseif msg == "p" then
		SetSetting(msg)
	elseif msg == "q" then
		SetSetting(msg)
	elseif msg == "r" then
		SetSetting(msg)
	elseif msg == "all" then
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

mAddStatusbar("mMediaTag Caith UI 1", "Wglass.tga")
mAddStatusbar("mMediaTag Caith UI 2", "Wisps.tga")

mAddStatusbar("MaUIv3", "MaUIv3.tga")
mAddStatusbar("MaUIv3 LEFT", "MaUIv3Left.tga")
mAddStatusbar("MaUIv3 RIGHT", "MaUIv3Right.tga")
mAddStatusbar("mMT Blank", "mMT_Blank.tga")
mAddStatusbar("mMT Target", "mMT_Target.tga")

-- Backgrounds
mAddBackground("mMediaTag BG1", "bg1.tga")
mAddBackground("mMediaTag BG2", "bg2.tga")
mAddBackground("mMediaTag BG3", "bg3.tga")
mAddBackground("mMediaTag BG4", "bg4.tga")
mAddBackground("mMediaTag BG5", "bg5.tga")
mAddBackground("mMediaTag BG6", "bg6.tga")
mAddBackground("mMediaTag BG7", "bg7.tga")
mAddBackground("mMediaTag BG8", "bg8.tga")
mAddBackground("mMediaTag BG9", "bg9.tga")
mAddBackground("mMediaTag BG10", "bg10.tga")
mAddBackground("mMediaTag BG11", "bg11.tga")

mAddBackground("mMediaTag Chat1", "chat1.tga")
mAddBackground("mMediaTag Chat2", "chat2.tga")
mAddBackground("mMediaTag Chat3", "chat3.tga")
mAddBackground("mMediaTag Chat4", "chat4.tga")
mAddBackground("mMediaTag Chat5", "chat5.tga")
mAddBackground("mMediaTag Chat6", "chat6.tga")
mAddBackground("mMediaTag Chat7", "chat7.tga")
mAddBackground("mMediaTag Chat8", "chat8.tga")
mAddBackground("mMediaTag Chat9", "chat9.tga")
mAddBackground("mMediaTag Chat10", "chat10.tga")
mAddBackground("mMediaTag Chat11", "chat11.tga")
mAddBackground("mMediaTag Chat12", "chat12.tga")
mAddBackground("mMediaTag Chat13", "chat13.tga")

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
mAddFont("Oregano-Regular", "Oregano-Regular.ttf")
mAddFont("Oswald-Bold", "Oswald-Bold.ttf")
mAddFont("Oswald-Light", "Oswald-Light.ttf")
mAddFont("Oswald-Regular", "Oswald-Regular.ttf")
mAddFont("Ubuntu-Bold", "Ubuntu-Bold.ttf")
mAddFont("Ubuntu-Medium", "Ubuntu-Medium.ttf")
mAddFont("NotoSans-Bold", "NotoSans-Bold.ttf")
mAddFont("NotoSans-SemiBold", "NotoSans-SemiBold.ttf")
mAddFont("Montserrat-Black", "Montserrat-Black.ttf")
mAddFont("Montserrat-Bold", "Montserrat-Bold.ttf")
mAddFont("Montserrat-ExtraBold", "Montserrat-ExtraBold.ttf")
mAddFont("Montserrat-Medium", "Montserrat-Medium.ttf")
mAddFont("Montserrat-Regular", "Montserrat-Regular.ttf")
mAddFont("Montserrat-SemiBold", "Montserrat-SemiBold.ttf")
