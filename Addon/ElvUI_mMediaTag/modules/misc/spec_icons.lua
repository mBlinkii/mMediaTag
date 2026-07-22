local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

MEDIA.icons.spec = {
	data = {
		-- Death Knight
		[250] = { -- Blood
			texString = "0:128:0:128",
			texCoords = { 0, 0, 0, 0.125, 0.125, 0, 0.125, 0.125 },
		},
		[251] = { -- Frost
			texString = "128:256:0:128",
			texCoords = { 0.125, 0, 0.125, 0.125, 0.25, 0, 0.25, 0.125 },
		},
		[252] = { -- Unholy
			texString = "256:384:0:128",
			texCoords = { 0.25, 0, 0.25, 0.125, 0.375, 0, 0.375, 0.125 },
		},
		-- Druid
		[102] = { -- Balance
			texString = "384:512:0:128",
			texCoords = { 0.375, 0, 0.375, 0.125, 0.5, 0, 0.5, 0.125 },
		},
		[103] = { -- Feral
			texString = "512:640:0:128",
			texCoords = { 0.5, 0, 0.5, 0.125, 0.625, 0, 0.625, 0.125 },
		},
		[104] = { -- Guardian
			texString = "640:768:0:128",
			texCoords = { 0.625, 0, 0.625, 0.125, 0.75, 0, 0.75, 0.125 },
		},
		[105] = { -- Restoration
			texString = "768:896:0:128",
			texCoords = { 0.75, 0, 0.75, 0.125, 0.875, 0, 0.875, 0.125 },
		},
		-- Hunter
		[253] = { -- Beast Mastery
			texString = "896:1024:0:128",
			texCoords = { 0.875, 0, 0.875, 0.125, 1, 0, 1, 0.125 },
		},
		[254] = { -- Marksmanship
			texString = "0:128:128:256",
			texCoords = { 0, 0.125, 0, 0.25, 0.125, 0.125, 0.125, 0.25 },
		},
		[255] = { -- Survival
			texString = "128:256:128:256",
			texCoords = { 0.125, 0.125, 0.125, 0.25, 0.25, 0.125, 0.25, 0.25 },
		},
		-- Mage
		[62] = { -- Arcane
			texString = "256:384:128:256",
			texCoords = { 0.25, 0.125, 0.25, 0.25, 0.375, 0.125, 0.375, 0.25 },
		},
		[63] = { -- Fire
			texString = "384:512:128:256",
			texCoords = { 0.375, 0.125, 0.375, 0.25, 0.5, 0.125, 0.5, 0.25 },
		},
		[64] = { -- Frost
			texString = "512:640:128:256",
			texCoords = { 0.5, 0.125, 0.5, 0.25, 0.625, 0.125, 0.625, 0.25 },
		},
		-- Monk
		[268] = { -- Brewmaster
			texString = "640:768:128:256",
			texCoords = { 0.625, 0.125, 0.625, 0.25, 0.75, 0.125, 0.75, 0.25 },
		},
		[270] = { -- Mistweaver
			texString = "768:896:128:256",
			texCoords = { 0.75, 0.125, 0.75, 0.25, 0.875, 0.125, 0.875, 0.25 },
		},
		[269] = { -- Windwalker
			texString = "896:1024:128:256",
			texCoords = { 0.875, 0.125, 0.875, 0.25, 1, 0.125, 1, 0.25 },
		},
		-- Paladin
		[65] = { -- Holy
			texString = "0:128:256:384",
			texCoords = { 0, 0.25, 0, 0.375, 0.125, 0.25, 0.125, 0.375 },
		},
		[66] = { -- Protection
			texString = "128:256:256:384",
			texCoords = { 0.125, 0.25, 0.125, 0.375, 0.25, 0.25, 0.25, 0.375 },
		},
		[70] = { -- Retribution
			texString = "256:384:256:384",
			texCoords = { 0.25, 0.25, 0.25, 0.375, 0.375, 0.25, 0.375, 0.375 },
		},
		-- Priest
		[256] = { -- Discipline
			texString = "384:512:256:384",
			texCoords = { 0.375, 0.25, 0.375, 0.375, 0.5, 0.25, 0.5, 0.375 },
		},
		[257] = { -- Holy
			texString = "512:640:256:384",
			texCoords = { 0.5, 0.25, 0.5, 0.375, 0.625, 0.25, 0.625, 0.375 },
		},
		[258] = { -- Shadow
			texString = "640:768:256:384",
			texCoords = { 0.625, 0.25, 0.625, 0.375, 0.75, 0.25, 0.75, 0.375 },
		},
		-- Rogue
		[259] = { -- Assassination
			texString = "768:896:256:384",
			texCoords = { 0.75, 0.25, 0.75, 0.375, 0.875, 0.25, 0.875, 0.375 },
		},
		[260] = { -- Outlaw
			texString = "896:1024:256:384",
			texCoords = { 0.875, 0.25, 0.875, 0.375, 1, 0.25, 1, 0.375 },
		},
		[261] = { -- Subtlety
			texString = "0:128:384:512",
			texCoords = { 0, 0.375, 0, 0.5, 0.125, 0.375, 0.125, 0.5 },
		},
		-- Shaman
		[262] = { -- Elemental
			texString = "128:256:384:512",
			texCoords = { 0.125, 0.375, 0.125, 0.5, 0.25, 0.375, 0.25, 0.5 },
		},
		[263] = { -- Enhancement
			texString = "256:384:384:512",
			texCoords = { 0.25, 0.375, 0.25, 0.5, 0.375, 0.375, 0.375, 0.5 },
		},
		[264] = { -- Restoration
			texString = "384:512:384:512",
			texCoords = { 0.375, 0.375, 0.375, 0.5, 0.5, 0.375, 0.5, 0.5 },
		},
		-- Warlock
		[265] = { -- Affliction
			texString = "512:640:384:512",
			texCoords = { 0.5, 0.375, 0.5, 0.5, 0.625, 0.375, 0.625, 0.5 },
		},
		[266] = { -- Demonology
			texString = "640:768:384:512",
			texCoords = { 0.625, 0.375, 0.625, 0.5, 0.75, 0.375, 0.75, 0.5 },
		},
		[267] = { -- Destruction
			texString = "768:896:384:512",
			texCoords = { 0.75, 0.375, 0.75, 0.5, 0.875, 0.375, 0.875, 0.5 },
		},
		-- Warrior
		[71] = { -- Arms
			texString = "896:1024:384:512",
			texCoords = { 0.875, 0.375, 0.875, 0.5, 1, 0.375, 1, 0.5 },
		},
		[72] = { -- Fury
			texString = "0:128:512:640",
			texCoords = { 0, 0.5, 0, 0.625, 0.125, 0.5, 0.125, 0.625 },
		},
		[73] = { -- Protection
			texString = "128:256:512:640",
			texCoords = { 0.125, 0.5, 0.125, 0.625, 0.25, 0.5, 0.25, 0.625 },
		},
		-- Demon Hunter
		[577] = { -- Havoc
			texString = "256:384:512:640",
			texCoords = { 0.25, 0.5, 0.25, 0.625, 0.375, 0.5, 0.375, 0.625 },
		},
		[581] = { -- Vengeance
			texString = "384:512:512:640",
			texCoords = { 0.375, 0.5, 0.375, 0.625, 0.5, 0.5, 0.5, 0.625 },
		},
		[1480] = { -- Devourer
			texString = "512:640:512:640",
			texCoords = { 0.5, 0.5, 0.5, 0.625, 0.625, 0.5, 0.625, 0.625 },
		},
		-- Evoker
		[1467] = { -- Devastation
			texString = "640:768:512:640",
			texCoords = { 0.625, 0.5, 0.625, 0.625, 0.75, 0.5, 0.75, 0.625 },
		},
		[1468] = { -- Preservation
			texString = "768:896:512:640",
			texCoords = { 0.75, 0.5, 0.75, 0.625, 0.875, 0.5, 0.875, 0.625 },
		},
		[1473] = { -- Augmentation
			texString = "896:1024:512:640",
			texCoords = { 0.875, 0.5, 0.875, 0.625, 1, 0.5, 1, 0.625 },
		},
	},
	icons = {
		mmt = {},
		custom = {},
	},
}

local type = type
local path = "Interface\\Addons\\ElvUI_mMediaTag\\media\\spec\\"

-- style = texture style, texture = path to the texture, table with texture coords for each spec, name = optional name to show in dropdown menu
local function AddOtherSpecIcons(style, texture, texCoords, name)
	if not (style and texture and texCoords) then
		mMT:Print("|CFFEA1818Error|r:", L["Could not add the texture."])
		return false, "missingArgs"
	end

	local icon = {
		name = name or style,
		texture = texture,
	}

	if texCoords ~= "default" then
		if type(texCoords) ~= "table" then
			mMT:Print("|CFFEA1818Error|r:", L["The texture coordinates must be passed as a table."])
			return false, "invalidCoords"
		end
		icon.texCoords = texCoords
	end

	if not MEDIA.icons.spec.icons.custom[style] then
		MEDIA.icons.spec.icons.custom[style] = icon
		return true
	else
		mMT:Print("|CFFEA1818Error|r:", L["The style already exists."])
		return false, "duplicate"
	end
end

local function AddSpecIcons(style, texture, name)
	if not (style and texture) then return end

	MEDIA.icons.spec.icons.mmt[style] = {
		name = name or style,
		texture = texture,
	}
end

-- Add mMT Icons to the DB
AddSpecIcons("mmt_hd_spec_icons", path .. "mmt_hd_spec_icons.tga", "mMT Spec Icon HD")
AddSpecIcons("mmt_simple_spec_icons", path .. "mmt_simple_spec_icons.tga", "mMT Spec Icon Simple")
AddSpecIcons("mmt_clean_spec_icons", path .. "mmt_clean_spec_icons.tga", "mMT Spec Icon Clean")
