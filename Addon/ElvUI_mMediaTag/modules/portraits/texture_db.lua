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
	},
	bg = {
		default = {
			name = "Default",
			texture = "Interface\\AddOns\\ElvUI_mMediaTag\\media\\portraits\\bg\\bg_01.tga",
		},
	},
	icons = {},
}

MEDIA.portraits = textureDB
