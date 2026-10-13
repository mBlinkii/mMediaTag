local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

local _G = _G
local format, gmatch, gsub, ipairs, max, pairs, pcall, sort, strlower, strrep, tconcat, tinsert, tremove, type, unpack, wipe =
	format, string.gmatch, gsub, ipairs, max, pairs, pcall, sort, strlower, strrep, table.concat, tinsert, tremove, type, unpack, wipe

local ICON = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\%s.tga:16:16|t  %s"
-- a disabled module shows a darkened icon and grey text
local ICON_OFF = "|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\%s.tga:16:16:0:0:16:16:0:16:0:16:110:110:110|t  |cff808080%s|r"

local ICONS = {
	unitframes = "unitframes",
	nameplates = "nameplates",
	cooldownmanager = "cooldown",
	datatexts = "datatexts",
	dock = "dock",
	tags = "tags",
	group = "guild",
	quests = "quest",
	interface = "interface",
	comfort = "comfort",
	skins = "skins",
	colors = "colors",
	media_pack = "media",
	changelog = "log",
	license = "license",
	about = "mmt_16",
}

local PAGE_ICONS = {
	unitframes = { portraits = "character", castbar = "castbar", status_icons = "status", unitframe_textures = "textures" },
	nameplates = { highlights = "missions", markers = "marker", tools = "fix" },
	cooldownmanager = { general = "settings", viewers = "collection", custom = "clock" },
	datatexts = { general = "settings", info = "info", menus = "menu" },
	dock = { general = "settings", buttons = "buttons", custom_docks = "add" },
	group = { lfg_invite_info = "search", keystones = "keystone", group_tools = "fix" },
	quests = { objective_tracker = "objectives", prey_hunt = "prey" },
	interface = { panels = "panels", tooltip = "tooltip" },
	comfort = { automation = "automation", mail_helper = "mail", addon_manager = "addons", tools = "fix" },
	skins = { auctionator = "shop", aussyloot = "new", bigwigs = "boss", bugsack = "bug", premade_groups_filter = "filter" },
	colors = { difficulty = "difficulty", tip_menu = "chat" },
}

local function Icon(text, icon, off)
	return format(off and ICON_OFF or ICON, icon, text)
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

-- meta: desc = one line about the module, db = settings path for the reset button, new = changelog version that added it
local META = {}

local function Feature(order, name, hidden, meta)
	local group = {
		order = order,
		type = "group",
		name = name,
		childGroups = "tab",
		hidden = hidden,
		args = {},
	}
	META[group] = meta
	return group
end

local function Skin(order, name)
	return Feature(order, name, nil, { db = "skins." .. strlower(gsub(name, " ", "_")), desc = format(L["Skins %s in the ElvUI style."], name) })
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

-- returns the module toggle, the args table holding it and its path below the group
local function FindToggle(group)
	local args = group.args
	for _, key in ipairs({ "enable", "toggle_enable" }) do
		if args[key] and args[key].type == "toggle" then return args[key], args, { key } end
	end

	local settings = args.settings and args.settings.args
	if settings and settings.enable and settings.enable.type == "toggle" then return settings.enable, settings, { "settings", "enable" } end
end

local function EnableToggle(group)
	return (FindToggle(group))
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
			portraits = Feature(1, L["Portraits"], nil, { db = "portraits", desc = L["Adds styled portraits with class or spec icons to the ElvUI unitframes."] }),
			castbar = Page(2, L["Castbar"], "tab", {
				interrupt_on_cd = Feature(
					1,
					L["Interrupt On CD"],
					nil,
					{ db = "interrupt_on_cd", desc = L["Colors castbars by the state of your interrupt and marks when it is ready again during the cast."] }
				),
				important_casts = Feature(2, L["Important Casts"], nil, { db = "important_casts", desc = L["Marks casts that Blizzard flags as important with an extra icon on the castbar."] }),
			}),
			status_icons = Page(3, L["Status Icons"], "inline", {
				role_icons = Feature(1, L["Role Icons"], nil, { db = "role_icons" }),
				phase_icon = Feature(2, L["Phase Icon"], nil, { db = "phase_icon" }),
				ready_check_icon = Feature(3, L["Ready Check Icons"], nil, { db = "ready_check_icon" }),
				resurrection_icon = Feature(4, L["Resurrection Icon"], nil, { db = "resurrection_icon" }),
				summon_icon = Feature(5, L["Summon Icon"], nil, { db = "summon_icon" }),
			}),
			unitframe_textures = Feature(4, L["Unitframe Textures"]),
		}),
		nameplates = Category(4, L["Nameplates"], {
			highlights = Page(1, L["Highlights"], "tab", {
				target_highlight = Feature(1, L["Target Highlight"], nil, { db = "nameplates.target", desc = L["Highlights the nameplate of your target with its own texture, border and health color."] }),
				focus_highlight = Feature(2, L["Focus Highlight"], nil, { db = "nameplates.focus", desc = L["Highlights the nameplate of your focus with its own texture, border and health color."] }),
				quest_highlight = Feature(3, L["Quest Highlight"], nil, { db = "nameplates.quest", desc = L["Highlights the nameplates of quest units with their own texture, border and health color."] }),
			}),
			markers = Page(2, L["Markers and Textures"], "tab", {
				execute_marker = Feature(1, L["Execute Marker"], nil, { db = "nameplates.execute" }),
				raid_marker_color = Feature(
					2,
					L["Raid Marker Colors"],
					nil,
					{ db = "nameplates.raid_marker_color", desc = L["Colors the health bar of nameplates with a raid marker in the color of that marker."], new = 415 }
				),
				classification_texture = Feature(
					3,
					L["Classification Textures"],
					nil,
					{ db = "nameplates.classification", desc = L["Shows textures for elites, rares, bosses and casters on the nameplates."] }
				),
			}),
			tools = Page(3, L["Tools"], "inline", {
				auto_friendly_nameplates = Feature(
					1,
					L["Auto Friendly Nameplates"],
					nil,
					{ db = "auto_friendly_nameplates", desc = L["Automatically shows friendly nameplates in dungeons and raids and hides them in the open world."] }
				),
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
			lfg_invite_info = Feature(1, L["LFG Invite Info"], nil, { db = "lfg_invite_info", desc = L["Shows a popup with the location, difficulty and name of the group finder group you joined."] }),
			keystones = Page(2, L["Keystones"], "inline", {
				group_keystones = Feature(1, L["Group Keystones"], NotRetail, { db = "group_keystones", desc = L["Shows the keystones of your group next to the group finder listing."] }),
				keystone_teleports = Feature(
					2,
					L["Keystone Teleports"],
					NotRetail,
					{ db = "keystone_teleports", desc = L["Shows the keystones of your group with the teleport to their dungeon and highlights the dungeon of your group."], new = 415 }
				),
				keystone_to_chat = Feature(3, L["Keystone to Chat"], NotRetail, { db = "keystone_to_chat", desc = L["Post your keystone to the chat when someone types !key or !keys into the chat."] }),
			}, NotRetail),
			group_tools = Page(3, L["Group Tools"], "tab", {
				difficulty_info = Feature(1, L["Difficulty Info"], nil, { db = "difficulty_info", desc = L["Shows the difficulty of the current instance in its own frame."] }),
				death_counter = Feature(2, L["Death Counter"], nil, { db = "death_counter", desc = L["Shows deaths and lost time in the current Mythic+ run."] }),
				buff_reminder = Feature(3, L["Buff Reminder"], NotRetail, { db = "buff_reminder", new = 415 }),
			}),
		}),
		quests = Category(12, L["Quests"], {
			objective_tracker = Feature(1, L["Objective Tracker"], nil, { db = "objective_tracker", desc = L["Skins the objective tracker and adds quest colors, progress bars and highlights."] }),
			prey_hunt = Feature(2, L["Prey Hunt"], nil, { db = "prey_hunt", desc = L["Shows the current hunt stage as text on the prey icon."] }),
		}),
		separator_3 = Separator(13),
		interface = Category(14, L["Interface"], {
			panels = Page(1, L["Panels"], "tab", {
				data_panel_skin = Feature(1, L["Data Panel Skin"], nil, { desc = L["Gives the ElvUI data panels their own background, border and texture."] }),
				minimap_skin = Feature(2, L["Minimap Skin"], nil, { db = "minimap_skin" }),
				details = Feature(3, L["Details embedded"]),
			}),
			tooltip = Feature(2, L["Tooltip"], nil, { db = "tooltip" }),
		}),
		comfort = Category(15, L["Comfort"], {
			automation = Page(1, L["Automation"], "tab", {
				auto_quest = Feature(1, L["Auto Quest"], nil, { db = "auto_quest", desc = L["Accepts and turns in quests automatically and selects gossip options for you."] }),
				auto_role_check = Feature(2, L["Auto Role Check"], nil, { db = "auto_role_check", desc = L["Automatically accepts the dungeon or raid role check popup."] }),
				auto_delete = Feature(3, L["Auto Delete"], nil, { db = "auto_delete", desc = L["Fills in the confirmation word automatically when you delete an item."], new = 415 }),
			}),
			mail_helper = Feature(
				2,
				L["Mail Helper"],
				nil,
				{ db = "mail_helper", desc = L["Takes the gold from your mails, shows an inbox overview and lists your alts and contacts when sending mail."], new = 415 }
			),
			addon_manager = Feature(3, L["Addon Manager"], nil, { db = "addon_manager", desc = L["Save your enabled addons as a named set and switch between them from Blizzard's addon list."] }),
			tools = Page(4, L["Tools"], "inline", {
				greeting_message = Feature(1, L["Greeting Message"], nil, { db = "general.greeting_message", desc = L["Show a greeting message in the chat when you log in."] }),
				dice_button = Feature(2, L["Dice Button"], nil, { db = "dice_button", desc = L["Adds a button that rolls a random number in the ranges you set."] }),
			}),
		}),
		skins = Category(16, L["Skins"], {
			auctionator = Skin(1, "Auctionator"),
			aussyloot = Skin(2, "AussyLoot"),
			bigwigs = Skin(3, "BigWigs"),
			bugsack = Skin(4, "BugSack"),
			premade_groups_filter = Skin(5, "Premade Groups Filter"),
		}),
		colors = Category(17, L["Colors"], {
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

-- the colors category mirrors every color option, both places edit the same setting
local function Chain(list)
	if #list == 0 then return nil end
	return function(...)
		for _, value in ipairs(list) do
			if value == true or (type(value) == "function" and value(...)) then return true end
		end
	end
end

local function Append(list, value)
	if not value then return list end
	local copy = { unpack(list) }
	tinsert(copy, value)
	return copy
end

local function SortedKeys(args)
	local keys = {}
	for key in pairs(args) do
		tinsert(keys, key)
	end
	sort(keys, function(a, b)
		local orderA, orderB = args[a].order or 100, args[b].order or 100
		if orderA == orderB then return a < b end
		return orderA < orderB
	end)
	return keys
end

local function CollectColors(group, path, state, sections)
	local colors, count = nil, 0
	for _, key in ipairs(SortedKeys(group.args)) do
		local option = group.args[key]
		if type(option) == "table" and option.type == "color" then
			colors = colors or {}
			local copy = {}
			for field, value in pairs(option) do
				copy[field] = value
			end
			count = count + 1
			copy.order = count
			copy.get = option.get or state.get
			copy.set = option.set or state.set
			copy.disabled = Chain(Append(state.disabled, option.disabled))
			copy.hidden = Chain(Append(state.hidden, option.hidden))
			colors[key] = copy
		end
	end

	if colors then tinsert(sections, { name = tconcat(path, " › "), args = colors }) end

	for _, key in ipairs(SortedKeys(group.args)) do
		local child = group.args[key]
		if type(child) == "table" and child.type == "group" then
			local childPath = { unpack(path) }
			if type(child.name) == "string" and child.name ~= "" then tinsert(childPath, child.name) end
			CollectColors(child, childPath, {
				get = child.get or state.get,
				set = child.set or state.set,
				disabled = Append(state.disabled, child.disabled),
				hidden = Append(state.hidden, child.hidden),
			}, sections)
		end
	end
end

local function BuildColorPages()
	local options = mMT.options.args
	local colors = options.colors.args
	for key, category in pairs(options) do
		if key ~= "colors" and ICONS[key] and type(category) == "table" and category.type == "group" then
			local sections = {}
			CollectColors(category, {}, { disabled = {}, hidden = { category.hidden } }, sections)

			if #sections > 0 then
				local args = {}
				for index, section in ipairs(sections) do
					args["section_" .. index] = {
						order = index,
						type = "group",
						inline = true,
						name = section.name,
						args = section.args,
					}
				end
				colors["mirror_" .. key] = Page(category.order + 10, category.name, nil, args)
			end
		end
	end
end

-- every category and page gets its own icon, the category page lists every page as a shortcut
local function Decorate()
	for key, categoryIcon in pairs(ICONS) do
		local category = mMT.options.args[key]
		local categoryName = category.name
		category.name = Icon(categoryName, categoryIcon)

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
				-- the colors category mirrors other categories and borrows their icons
				local icon = (PAGE_ICONS[key] and PAGE_ICONS[key][pageKey]) or ICONS[gsub(pageKey, "^mirror_", "")] or categoryIcon
				local function name()
					return Icon(text, icon, IsOff(page))
				end

				page.name = name
				category.args["shortcut_" .. pageKey] = {
					order = index,
					type = "execute",
					width = 1.25,
					name = Icon(text, icon),
					hidden = page.hidden,
					func = function()
						E.Libs.AceConfigDialog:SelectGroup("ElvUI", "mMT", key, pageKey)
					end,
				}
			end
		end
	end
end

local function Resolve(root, path)
	local parent, key = root, nil
	for part in gmatch(path, "[^%.]+") do
		if key then parent = parent[key] end
		key = part
	end
	return parent, key
end

-- refills the table in place, modules keep a reference to their settings
local function ResetSettings(path)
	local db, dbKey = Resolve(E.db.mMediaTag, path)
	local defaults, defaultKey = Resolve(P, path)
	local default = defaults[defaultKey]

	if type(default) == "table" then
		if type(db[dbKey]) == "table" then wipe(db[dbKey]) end
		db[dbKey] = E:CopyTable(db[dbKey], default)
	else
		db[dbKey] = default
	end
end

local function OptionValue(value, info)
	if type(value) == "function" then return value(info) end
	return value
end

-- every page or tab with a module toggle, in tree order
local function CollectModules()
	local modules = {}

	local function Add(catKey, category, pageKey, page, featureKey, feature)
		local group = feature or page
		local toggle, container, tail = FindToggle(group)
		if not toggle then return end

		-- AceConfig lets a toggle inherit get and set from its groups
		local get, set = toggle.get, toggle.set
		local parents = { category, page, feature or page, tail[2] and group.args[tail[1]] or group }
		for index = #parents, 1, -1 do
			get = get or parents[index].get
			set = set or parents[index].set
		end
		if type(get) ~= "function" or type(set) ~= "function" then return end

		local info = { "mMT", catKey, pageKey }
		if featureKey then tinsert(info, featureKey) end
		local path = { unpack(info, 2) }
		if feature and feature.inline then tremove(path) end
		for _, key in ipairs(tail) do
			tinsert(info, key)
		end

		tinsert(modules, {
			group = group,
			toggle = toggle,
			get = get,
			set = set,
			container = container,
			info = info,
			path = path,
			meta = META[group] or {},
			name = group.name == L["General"] and category.name or group.name,
			hidden = Chain(Append(Append(Append({}, category.hidden), page.hidden), feature and feature.hidden)),
		})
	end

	local options = mMT.options.args
	for _, catKey in ipairs(SortedKeys(options)) do
		local category = options[catKey]
		if ICONS[catKey] and catKey ~= "colors" and category.type == "group" then
			for _, pageKey in ipairs(SortedKeys(category.args)) do
				local page = category.args[pageKey]
				if page.type == "group" then
					if FindToggle(page) then
						Add(catKey, category, pageKey, page)
					else
						for _, featureKey in ipairs(SortedKeys(page.args)) do
							local feature = page.args[featureKey]
							if type(feature) == "table" and feature.type == "group" then Add(catKey, category, pageKey, page, featureKey, feature) end
						end
					end
				end
			end
		end
	end

	return modules
end

local function LatestVersion()
	local latest = 0
	for version in pairs(mMT.Changelog) do
		latest = max(latest, version)
	end
	return latest
end

local function NewBadge(text)
	return format("%s  %s", text, MEDIA.color.yellow:WrapTextInColorCode(L["New"]))
end

-- every module page starts with its toggle, a reset button and one line about the module
local function ApplyPageLayout(modules)
	for _, module in ipairs(modules) do
		local toggle, info, meta = module.toggle, module.info, module.meta
		local order = toggle.order or 1

		if meta.db then
			module.container.module_reset = {
				order = order + 0.1,
				type = "execute",
				name = L["Reset"],
				confirm = true,
				confirmText = format(L["Reset all settings of %s to their defaults?"], module.name),
				disabled = function()
					return OptionValue(toggle.disabled, info)
				end,
				func = function()
					ResetSettings(meta.db)
					module.set(info, module.get(info))
					E.Libs.AceConfigRegistry:NotifyChange("ElvUI")
				end,
			}
		end

		-- pages that already explain themselves keep their own text
		local description = meta.desc
		for _, option in pairs(module.group.args) do
			if type(option) == "table" and option.type == "description" then description = nil end
		end

		module.container.module_desc = description and {
			order = order + 0.2,
			type = "description",
			fontSize = "medium",
			name = description,
		}
	end
end

-- new modules carry the badge up to their page and category until the next changelog version
local function MarkNew(modules)
	local latest, marked = LatestVersion(), {}
	for _, module in ipairs(modules) do
		if module.meta.new == latest then
			local options = mMT.options.args
			local category = options[module.info[2]]
			local page = category.args[module.info[3]]
			for _, group in ipairs({ category, page, module.group }) do
				if not marked[group] then
					marked[group] = true
					group.name = NewBadge(group.name)
				end
			end
		end
	end
end

function mMT:FinalizeOptions()
	if mMT.optionsFinalized then return end
	mMT.optionsFinalized = true

	BuildColorPages()

	local modules = CollectModules()
	ApplyPageLayout(modules)
	MarkNew(modules)
	Decorate()
end
