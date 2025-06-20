local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)


local textureDB = {
	textures = {
		blizz_round = {
			name = "Blizzard Round",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round\\texture.tga",
			shadow = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round\\shadow.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round\\mask.tga",
			mask_mirror = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round\\mask_mirror.tga",
			extra_mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round\\extra_mask.tga",
			extra_mask_mirror = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round\\extra_mask_mirror.tga",
			embellishment = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round\\corner.tga",
			flip = false,
			mirror = false,
		},
		blizz_round_thick = {
			name = "Blizzard Round Thick",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round thick\\texture.tga",
			shadow = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round thick\\shadow.tga",
			mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round thick\\mask.tga",
			mask_mirror = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round thick\\mask_mirror.tga",
			extra_mask = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round thick\\extra_mask.tga",
			extra_mask_mirror = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round thick\\extra_mask_mirror.tga",
			embellishment = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\blizz round thick\\corner.tga",
			flip = false,
			mirror = false,
		},
	},
	extra = {
		blizz_boss = {
			name = "Blizzard Boss",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\extra\\blizz_boss.tga",
		},
		blizz_elite = {
			name = "Blizzard Elite",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\extra\\blizz_elite.tga",
		},
		blizz_rare = {
			name = "Blizzard Rare",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\extra\\blizz_rare.tga",
		},
		blizz_boss_neutral = {
			name = "Blizzard Boss Neutral",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\extra\\blizz_boss_neutral.tga",
		},
		blizz_rare_neutral = {
			name = "Blizzard Rare/ Elite Neutral",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\extra\\blizz_rare_neutral.tga",
		},
	},
	bg = {
		default = {
			name = "Default",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\bg\\bg_01.tga",
		},
		a = {
			name = "BG 1",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\bg\\bg_02.tga",
		},
		b = {
			name = "BG 2",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\bg\\bg_03.tga",
		},
		c = {
			name = "BG 3",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\bg\\bg_04.tga",
		},
		d = {
			name = "BG 4",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\bg\\bg_05.tga",
		},
		e = {
			name = "BG 5",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\bg\\bg_06.tga",
		},
		f = {
			name = "BG 6",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\bg\\bg_07.tga",
		},
	},
}

MEDIA.portraits = textureDB
