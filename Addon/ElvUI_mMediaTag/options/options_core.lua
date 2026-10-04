local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local _G = _G
local floor, format, ipairs, pairs, pcall, sort, strrep, tinsert, type = floor, format, ipairs, pairs, pcall, sort, strrep, tinsert, type

local DOT = "|TInterface\\CHARACTERFRAME\\TempPortraitAlphaMask:8:8:0:0:64:64:0:64:0:64:%d:%d:%d|t  %s"
-- a disabled module shows a grey dot
local DISABLED = { 0.35, 0.35, 0.35 }

local COLORS = {
	unitframes = { 0.353, 0.722, 0.941 },
	nameplates = { 0.878, 0.341, 0.290 },
	cooldownmanager = { 0.710, 0.494, 0.863 },
	datatexts = { 0.941, 0.706, 0.161 },
	dock = { 0.310, 0.820, 0.773 },
	tags = { 0.949, 0.482, 0.627 },
	group = { 0.561, 0.820, 0.310 },
	quests = { 0.839, 0.827, 0.310 },
	interface = { 0.941, 0.565, 0.310 },
	skins = { 0.518, 0.580, 0.659 },
	colors = { 0.902, 0.651, 0.851 },
	media_pack = { 0.600, 0.850, 0.950 },
	changelog = { MEDIA.color.red:GetRGB() },
	license = { MEDIA.color.yellow:GetRGB() },
	about = { MEDIA.color.green:GetRGB() },
}

local PAGE_COLORS = {
	{ 0.353, 0.722, 0.941 },
	{ 0.941, 0.706, 0.161 },
	{ 0.878, 0.341, 0.290 },
	{ 0.310, 0.820, 0.773 },
	{ 0.949, 0.482, 0.627 },
	{ 0.561, 0.820, 0.310 },
	{ 0.710, 0.494, 0.863 },
	{ 0.941, 0.565, 0.310 },
	{ 0.839, 0.827, 0.310 },
	{ 0.600, 0.900, 0.700 },
}

local function Dot(text, color)
	return format(DOT, floor(color[1] * 255 + 0.5), floor(color[2] * 255 + 0.5), floor(color[3] * 255 + 0.5), text)
end

local function NotRetail()
	return not E.Retail
end

local function Category(order, name, args, childGroups, hidden)
	return {
		order = order,
		type = "group",
		name = name,
		childGroups = childGroups or "tree",
		hidden = hidden,
		args = args or {},
	}
end

-- disabled tree entries can't be selected, so this one only draws a line
local function Separator(order)
	return {
		order = order,
		type = "group",
		name = strrep("—", 8),
		disabled = true,
		args = {},
	}
end

local function Feature(order, name, hidden)
	return {
		order = order,
		type = "group",
		name = name,
		childGroups = "tab",
		hidden = hidden,
		args = {},
	}
end

-- layout "inline" shows every feature as a section, "tab" and "select" give one feature at a time
local function Page(order, name, layout, args, hidden)
	local group = {
		order = order,
		type = "group",
		name = name,
		hidden = hidden,
		args = args,
	}

	if layout == "inline" then
		for _, feature in pairs(args) do
			feature.inline = true
		end
	else
		group.childGroups = layout
	end

	return group
end

local function EnableToggle(group)
	local args = group.args
	local toggle = args.enable or args.toggle_enable or (args.settings and args.settings.args and args.settings.args.enable)
	return toggle and toggle.type == "toggle" and toggle
end

local function IsEnabled(toggle)
	local ok, value = pcall(toggle.get)
	return ok and value
end

-- a page counts as off when it has module toggles and all of them are off
local function IsOff(group)
	local toggle = EnableToggle(group)
	if toggle then return not IsEnabled(toggle) end

	local hasToggle = false
	for _, child in pairs(group.args) do
		local childToggle = type(child) == "table" and child.type == "group" and EnableToggle(child)
		if childToggle and not (child.hidden and child.hidden()) then
			if IsEnabled(childToggle) then return false end
			hasToggle = true
		end
	end

	return hasToggle
end

mMT.options = {
	name = MEDIA.icon16 .. mMT.Name,
	handler = mMT,
	type = "group",
	args = {
		logo = {
			order = 1,
			type = "description",
			name = "",
			image = function()
				return "Interface\\Addons\\ElvUI_mMediaTag\\media\\logo", 512, 64
			end,
		},
		unitframes = Category(3, L["Unitframes"], {
			portraits = Feature(1, L["Portraits"]),
			castbar = Page(2, L["Castbar"], "tab", {
				interrupt_on_cd = Feature(1, L["Interrupt On CD"]),
				important_casts = Feature(2, "Important Casts"),
			}),
			status_icons = Page(3, L["Status Icons"], "inline", {
				role_icons = Feature(1, L["Role Icons"]),
				phase_icon = Feature(2, L["Phase Icon"]),
				ready_check_icon = Feature(3, L["Ready Check Icons"]),
				resurrection_icon = Feature(4, L["Resurrection Icon"]),
				summon_icon = Feature(5, L["Summon Icon"]),
			}),
			unitframe_textures = Feature(4, L["Unitframe Textures"]),
		}),
		nameplates = Category(4, L["Nameplates"], {
			highlights = Page(1, L["Highlights"], "tab", {
				target_highlight = Feature(1, L["Target Highlight"]),
				focus_highlight = Feature(2, L["Focus Highlight"]),
				quest_highlight = Feature(3, L["Quest Highlight"]),
			}),
			markers = Page(2, L["Markers and Textures"], "tab", {
				execute_marker = Feature(1, L["Execute Marker"]),
				raid_marker_color = Feature(2, L["Raid Marker Colors"]),
				classification_texture = Feature(3, L["Classification Textures"]),
			}),
			tools = Page(3, L["Tools"], "inline", {
				auto_friendly_nameplates = Feature(1, L["Auto Friendly Nameplates"]),
				misc = Feature(2, L["Misc"]),
			}),
		}),
		cooldownmanager = Category(5, L["Cooldown Manager"], {
			general = Feature(1, L["General"]),
			viewers = Page(2, L["Viewers"], "tab", {
				essential = Feature(1, L["Essential Cooldowns"]),
				utility = Feature(2, L["Utility Cooldowns"]),
				buff_icon = Feature(3, L["Buff Icons"]),
				buff_bar = Feature(4, L["Buff Bars"]),
			}),
			custom = Feature(3, L["Custom Tracker"]),
		}),
		separator_1 = Separator(6),
		datatexts = Category(7, L["Datatexts"], {
			general = Feature(1, L["General"]),
			info = Page(2, L["Info"], "tab", {
				info_score = Feature(1, L["M+ Score"], NotRetail),
				info_time = Feature(2, L["Time"]),
				info_combat_time = Feature(3, L["Combat/Arena Time"]),
				info_durability_itemlevel = Feature(4, L["Durability & Item Level"]),
			}),
			menus = Page(3, L["Menus"], "tab", {
				misc_teleports = Feature(1, L["Teleports"], NotRetail),
				misc_professions = Feature(2, L["Professions"]),
				misc_individual_professions = Feature(3, L["Individual Professions"]),
				misc_gamemenu = Feature(4, L["Gamemenu"]),
				misc_dungeon = Feature(5, L["Dungeon"]),
				misc_tracker = Feature(6, L["Tracker"]),
			}),
		}),
		dock = Category(8, L["Dock"], {
			general = Feature(1, L["General"]),
			buttons = Page(2, L["Buttons"], "select", {
				character = Feature(1, CHARACTER_BUTTON),
				friends = Feature(2, L["Friends"]),
				guild = Feature(3, L["Guild"]),
				lfd = Feature(4, _G.DUNGEONS_BUTTON),
				spellbook = Feature(5, (E.Retail and _G.SPELLBOOK or _G.SPELLBOOK_ABILITIES_BUTTON)),
				spec = Feature(6, _G.TALENTS_BUTTON),
				menu = Feature(7, _G.MAINMENU_BUTTON),
				mail = Feature(8, _G.MAIL_LABEL),
				professions = Feature(9, _G.TRADE_SKILLS),
				quests = Feature(10, _G.QUESTLOG_BUTTON),
				durability = Feature(11, _G.DURABILITY),
				encounter = Feature(12, _G.ENCOUNTER_JOURNAL),
				collection = Feature(13, _G.COLLECTIONS),
				bags = Feature(14, L["Bags"]),
				achievement = Feature(15, _G.ACHIEVEMENT_BUTTON),
				store = Feature(16, _G.BLIZZARD_STORE),
				volume = Feature(17, L["Volume"]),
				calendar = Feature(18, L["Calendar"]),
				housing = Feature(19, L["Housing"]),
				notification = Feature(20, L["Notification"]),
			}),
			custom_docks = Page(3, L["Custom Docks"], nil, {
				guide = {
					order = 1,
					type = "group",
					inline = true,
					name = L["Example"],
					args = {
						desc = {
							order = 1,
							type = "description",
							name = L["These are just examples of how to create your own dock using ElvUI’s custom data text bars.\n\nTo set up a custom bar:\nOpen ElvUI and navigate to ElvUI > Datatext > Bars.\nEnter a name for your new bar, click OK, and then click Add.\nSet the width of the bar based on how many icons you want to display.\nSet the height, which also determines the icon size.\nChoose the number of data text slots you want.\n\nAssign icons to each slot. For example:\nSlot 1 = Dock Calendar\nSlot 2 = Dock Profession\nSlot 3 = Dock Spec\n…and so on.\n\nThis setup allows you to build a personalized dock that fits your UI and gameplay needs.\n\n"],
						},
						warning = {
							order = 2,
							type = "description",
							name = L["In WoW Classic, the docks may appear differently because not all modules are available in this version. However, you can still customize the docks through the ElvUI settings."],
						},
					},
				},
				docks = {
					order = 2,
					type = "group",
					inline = true,
					name = L["Custom Docks"],
					args = {},
				},
			}),
		}),
		tags = Category(9, L["TAGs"], nil, "tab"),
		separator_2 = Separator(10),
		group = Category(11, L["Group and M+"], {
			lfg_invite_info = Feature(1, L["LFG Invite Info"]),
			keystones = Page(2, L["Keystones"], "inline", {
				group_keystones = Feature(1, L["Group Keystones"], NotRetail),
				keystone_to_chat = Feature(2, L["Keystone to Chat"], NotRetail),
			}, NotRetail),
			group_tools = Page(3, L["Group Tools"], "tab", {
				auto_role_check = Feature(1, L["Auto Role Check"]),
				difficulty_info = Feature(2, L["Difficulty Info"]),
				death_counter = Feature(3, L["Death Counter"]),
			}),
		}),
		quests = Category(12, L["Quests"], {
			objective_tracker = Feature(1, L["Objective Tracker"]),
			automation = Page(2, L["Automation"], "tab", {
				auto_quest = Feature(1, L["Auto Quest"]),
				prey_hunt = Feature(2, L["Prey Hunt"]),
			}),
		}),
		separator_3 = Separator(13),
		interface = Category(14, L["Interface"], {
			panels = Page(1, L["Panels"], "tab", {
				data_panel_skin = Feature(1, L["Data Panel Skin"]),
				minimap_skin = Feature(2, L["Minimap Skin"]),
				details = Feature(3, L["Details embedded"]),
			}),
			tooltip = Feature(2, L["Tooltip"]),
			comfort = Page(3, L["Comfort"], "tab", {
				greeting_message = Feature(1, L["Greeting Message"]),
				dice_button = Feature(2, L["Dice Button"]),
				addon_manager = Feature(3, L["Addon Manager"]),
			}),
		}),
		skins = Category(15, L["Skins"], {
			auctionator = Feature(1, "Auctionator"),
			aussyloot = Feature(2, "AussyLoot"),
			bigwigs = Feature(3, "BigWigs"),
			bugsack = Feature(4, "BugSack"),
			premade_groups_filter = Feature(5, "Premade Groups Filter"),
		}),
		colors = Category(16, L["Colors"], {
			difficulty = Feature(1, L["Difficulty"]),
			tip_menu = Feature(2, L["Tip/ Menu"]),
		}),
		media_pack = Category(18, L["Media Pack"], nil, "tab", function()
			return not _G.mMT_MediaPack
		end),
		separator_4 = Separator(19),
		changelog = Category(20, L["Changelog"], nil, "select"),
		license = Category(21, L["License"], nil, "tab"),
		about = Category(22, L["About"], nil, "tab"),
	},
}

-- each page gets its own dot color, the category page lists every page as a shortcut
for key, color in pairs(COLORS) do
	local category = mMT.options.args[key]
	local categoryName = category.name
	category.name = Dot(categoryName, color)

	if category.childGroups == "tree" then
		local pageKeys = {}
		for pageKey, page in pairs(category.args) do
			if type(page) == "table" and page.type == "group" and not page.inline then tinsert(pageKeys, pageKey) end
		end
		sort(pageKeys, function(a, b)
			return category.args[a].order < category.args[b].order
		end)

		category.args.shortcuts_header = {
			order = 0,
			type = "header",
			name = categoryName,
		}

		for index, pageKey in ipairs(pageKeys) do
			local page = category.args[pageKey]
			local text = page.name
			local pageColor = PAGE_COLORS[(index - 1) % #PAGE_COLORS + 1]
			local function name()
				return Dot(text, IsOff(page) and DISABLED or pageColor)
			end

			page.name = name
			category.args["shortcut_" .. pageKey] = {
				order = index,
				type = "execute",
				width = 1.25,
				name = text,
				hidden = page.hidden,
				func = function()
					E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", key, pageKey)
				end,
			}
		end
	end
end
