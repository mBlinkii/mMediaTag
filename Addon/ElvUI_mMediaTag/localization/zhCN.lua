local L = LibStub("AceLocale-3.0"):NewLocale("mMediaTag", "zhCN")
if not L then return end

-- core/functions.lua
L["Error decompressing data."] = "解压数据时出错。"
L["Error deserializing:"] = "反序列化错误："
L["Error importing profile. String is invalid or corrupted!"] = "导入配置文件时出错。字符串无效或已损坏！"
L["This export belongs to another setting and cannot be imported here."] = "此导出属于其他设置，无法在此导入。"
L["This export was created by an older version and can no longer be imported."] = "此导出由旧版本创建，已无法导入。"

-- modules/datatexts/info_score.lua
L["Mythic+ Best Run: +"] = "史诗+最佳记录：+"
L["Dungeon overview:"] = "地下城总览："
L["Keystones in your Group"] = "你的小队中的钥石"
L["Level: "] = "等级："
L["No Keystone"] = "没有钥石"
L["Possible next upgrades:"] = "可能的下一次升级："
L["This Week Affix"] = "本周词缀"

-- modules/datatexts/misc_coordinate.lua
L["Coordinate X"] = "坐标 X"
L["Coordinate Y"] = "坐标 Y"

-- modules/datatexts/misc_dungeon.lua
L["Call to Arms:"] = "战斗号召："
L["Difficulty Infos:"] = "难度信息："
L["Dungeon Infos:"] = "地下城信息："
L["Dungeon:"] = "地下城："
L["Guild Party:"] = "公会队伍："
L["Legacy Raid:"] = "旧版团队副本："
L["Name:"] = "名称："
L["No"] = "否"
L["Raid:"] = "团队副本："
L["This week's Affix"] = "本周词缀"
L["Yes"] = "是"

-- modules/datatexts/misc_gamemenu.lua
L["Framerate:"] = "帧率："
L["Game Menu"] = "游戏菜单"
L["Latency:"] = "延迟："
L["left click to open the menu."] = "左键点击打开菜单。"
L["right click to open LFD Browser"] = "右键点击打开地下城查找器"
L["Home"] = "本地"
L["World"] = "世界"

-- modules/datatexts/misc_individual_professions.lua
L["Archaeology"] = "考古学"
L["Cooking"] = "烹饪"
L["Fishing"] = "钓鱼"
L["Not learned"] = "未学习"
L["Primary Profession"] = "主专业"
L["Secondary Profession"] = "副专业"

-- modules/datatexts/misc_professions.lua
L["click to open the menu."] = "点击打开菜单。"
L["Main Professions"] = "主专业"
L["No Main Professions"] = "没有主专业"
L["No Secondary Professions"] = "没有副专业"
L["Secondary Professions"] = "副专业"

-- modules/datatexts/misc_teleports.lua
L["Dungeon Teleports"] = "地下城传送"
L["Engineering"] = "工程学"
L["Favorite"] = "收藏"
L["Items"] = "物品"
L["Left click to open the Teleports menu."] = "左键点击打开传送菜单。"
L["M+ Season"] = "M+ 赛季"
L["Mage Portals"] = "法师传送门"
L["Mage Teleports"] = "法师传送"
L["Midnight"] = true
L["Other Portals"] = "其他传送门"
L["Other Teleports"] = "其他传送"
L["Random"] = "随机"
L["Season Teleports"] = "赛季传送"
L["Spells"] = "法术"
L["You can select your favourites in the settings."] = "你可以在设置中选择收藏项。"
L["You currently have no important teleports."] = "你当前没有重要的传送。"

-- modules/dock/achievement.lua
L["Achievement points:"] = "成就点数："
L["Completed"] = "已完成"
L["Guild Achievement points:"] = "公会成就点数："
L["Missing"] = "未完成"
L["Tracked Achievements"] = "追踪的成就"

-- modules/dock/calendar.lua
L["Date:"] = "日期："

-- modules/dock/character.lua
L["Account total"] = "账号总计"
L["Time played this level"] = "当前等级游戏时间"
L["Total play time"] = "总游戏时间"

-- modules/dock/collection.lua
L["Collected"] = "已收集"
L["Mounts"] = "坐骑"
L["Pets"] = "宠物"

-- modules/dock/encounter.lua
L["Progress:"] = "进度："
L["Reisetagebuch"] = "冒险指南"

-- modules/dock/housing.lua
L["Neighborhood"] = "邻里"
L["No cached house information available."] = "没有可用的缓存房屋信息。"
L["Owner"] = "拥有者"

-- modules/dock/spellbook.lua
L["click to open the Spellbook."] = "点击打开法术书。"
L["Opening the spellbook via addons can lead to taints.\nThis occurs when protected Blizzard code is unintentionally modified or affected,\nwhich may result in malfunctions or UI restrictions."] = "通过插件打开法术书可能会导致污染（taint）。\n当受保护的暴雪代码被无意修改或影响时，就会发生这种情况，\n这可能导致功能异常或界面受限。"

-- modules/dock/store.lua
L["WoW Token:"] = "魔兽世界时光徽章："

-- modules/misc/auto_quest.lua
L["[AutoQuest] Auto-accept paused (SHIFT held)."] = "[AutoQuest] 自动接任务已暂停（按住 SHIFT）。"
L["[AutoQuest] Auto-turn-in paused (SHIFT held)."] = "[AutoQuest] 自动交任务已暂停（按住 SHIFT）。"
L["[AutoQuest] Quest accepted: %s"] = "[AutoQuest] 已接受任务：%s"
L["[AutoQuest] Quest turned in: %s"] = "[AutoQuest] 已交付任务：%s"
L["[AutoQuest] Auto-gossip paused (SHIFT held)."] = "[AutoQuest] 自动对话已暂停（按住 SHIFT）。"
L["[AutoQuest] Gossip selected: %s"] = "[AutoQuest] 已选择对话选项：%s"

-- modules/misc/class_icons.lua
L["Could not add the texture."] = "无法添加纹理。"
L["The style already exists."] = "该样式已存在。"
L["The texture coordinates must be passed as a table."] = "纹理坐标必须以表格形式传递。"

-- modules/misc/details.lua
L["Click to hide Details frames."] = "点击隐藏 Details 窗口。"
L["Details embedded toggle"] = "切换嵌入式 Details"

-- modules/misc/dice_button.lua
L["Left Click to roll"] = "左键点击投骰"
L["Right Click to roll"] = "右键点击投骰"
L["Roll Button"] = "投骰按钮"

-- modules/misc/greeting_message.lua
L["Welcome to %s %s version |CFFF7DC6F%s|r, type |CFF58D68D/mmt|r to access the in-game configuration menu or type |CFF58D68D/mmt help|r for an overview of all chat commands."] = "欢迎使用 %s %s 版本 |CFFF7DC6F%s|r，输入 |CFF58D68D/mmt|r 可打开游戏内配置菜单，或输入 |CFF58D68D/mmt help|r 查看所有聊天命令的概览。"

-- modules/misc/group_keystones.lua
L["Group Keystones"] = "队伍钥石"

-- modules/misc/lfg_invite_info.lua
L["PVE"] = "PVE"
L["The Flame Burns Eternal"] = "烈焰永燃"
L["The Floodgate"] = "洪流闸门"
L["The Rookery"] = "群巢"
L["Transmog farming"] = "幻化刷取"
L["Weekly"] = "每周"

-- modules/misc/tags.lua
L["Returns the classification icon of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-classification:icon{rare:elite}] will only show something if the unit is either rare or elite."] = "返回单位的分类图标。你最多可以指定三个参数，仅显示某些特定分类。\n例如：[mMT-classification:icon{rare:elite}] 只有当单位是稀有或精英时才会显示内容。"
L["Returns the classification of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-classification{rare:elite}] will only show something if the unit is either rare or elite."] = "返回单位的分类。你最多可以指定三个参数，仅显示某些特定分类。\n例如：[mMT-classification{rare:elite}] 只有当单位是稀有或精英时才会显示内容。"
L["Returns the color of the unit. Players are colored by class, NPCs by classification. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-color{rare:elite}] will only show something if the unit is either rare or elite."] = "返回单位的颜色。玩家按职业着色，NPC 按分类着色。你最多可以指定三个参数，仅显示某些特定分类。\n例如：[mMT-color{rare:elite}] 只有当单位是稀有或精英时才会显示内容。"
L["Returns the spec icon of the unit. You can specify a size between 16 and 128 (default is 64). Example: mSpecIcon:style{32}"] = "返回单位的专精图标。你可以指定 16 到 128 之间的尺寸（默认值为 64）。示例：mSpecIcon:style{32}"
L["Returns the current health of the unit (changes between current health and percent in combat)."] = "返回单位当前生命值（战斗中会在当前生命值与百分比之间切换）。"
L["Returns the current health of the unit."] = "返回单位当前生命值。"
L["Returns the current health percent of the unit (in combat)."] = "返回单位当前生命值百分比（战斗中）。"
L["Same as mMT-color, but only for the units target."] = "与 mMT-color 相同，但仅针对该单位的目标。"


-- options/about.lua
L["Contact"] = "联系"
L["Help"] = "帮助"
L["Thanks to:"] = "感谢："

-- options/cast/important_casts.lua
L["Adds an Extra Icon to the Castbar."] = "在施法条上添加一个额外图标。"
L["Border Color"] = "边框颜色"
L["Class Colors"] = "职业颜色"
L["Health Override"] = "生命值条覆盖"
L["Override Health Bar Color"] = "覆盖生命值条颜色"
L["Position Settings"] = "位置设置"
L["Sets the offset according to the anchor."] = "根据锚点设置偏移。"

-- options/changelog.lua
L["Fixes"] = "修复"
L["Important"] = "重要"
L["New"] = "新增"
L["Released"] = "发布"
L["Updates"] = "更新"
L["Version"] = "版本"

-- options/colors_difficulty.lua
L["Other"] = "其他"

-- options/colors_tip_menu.lua
L["Title"] = "标题"

-- options/datatext/misc_dungeon.lua
L["Dungeon Name"] = "地下城名称"

-- options/datatext/misc_individual_professions.lua
L["White"] = "白色"
L["Profession (Colored)"] = "专业（彩色）"
L["Profession (White)"] = "专业（白色）"

-- options/datatext/misc_tracker.lua
L["Delete ID"] = "删除 ID"
L["ID list"] = "ID 列表"
L["Crop Icons"] = "裁剪图标"
L["Cut off the icon border."] = "裁掉图标边框。"

-- options/dock/durability.lua
L["Durability"] = "耐久度"

-- options/dock/example.lua
L["Delete all"] = "全部删除"
L["Dock on Top"] = "Dock 置顶"
L["Preview"] = "预览"

-- options/dock/general.lua
L["Custom Font Size"] = "自定义字体大小"
L["Font Size"] = "字体大小"

-- options/dock/volume.lua
L["Colored Text"] = "彩色文本"

-- options/misc/details.lua
L["Adds a button to show or hide details on click. The button is only visible on mouse over."] = "添加一个按钮，用于点击显示或隐藏 Details。该按钮仅在鼠标悬停时可见。"
L["Details embeded"] = "嵌入的 Details"
L["Details Windows"] = "Details 窗口"
L["Embedded Settings"] = "嵌入设置"
L["Embedded to Chat"] = "嵌入到聊天窗口"
L["Left Chat"] = "左侧聊天"
L["Right Chat"] = "右侧聊天"
L["Toggle Button"] = "切换按钮"

-- options/misc/dice_button.lua
L["Color Hover"] = "悬停颜色"
L["Color Normal"] = "正常颜色"
L["Custom color"] = "自定义颜色"
L["Hover Color Style"] = "悬停颜色样式"
L["Hover Custom Color"] = "自定义悬停颜色"
L["Left Click"] = "左键点击"
L["Right Click"] = "右键点击"

-- options/misc/auto_role_check.lua
L["Auto Role Check"] = "自动职责确认"
L["Automatically accepts the dungeon or raid role check popup."] = "自动接受地下城或团队的职责确认弹窗。"
L["Lets you sign up for premade groups with a single click and confirms the application dialog automatically."] = "只需点击一次即可申请预创建队伍，并自动确认申请对话框。"
L["One-Click Sign Up"] = "一键申请"

-- options/misc/death_counter.lua
L["Death Counter"] = "死亡计数器"
L["Font size"] = "字体大小"
L["Shows deaths and lost time in the current Mythic+ run."] = "显示当前大秘境中的死亡次数和损失的时间。"

-- options/misc/difficulty_info.lua
L["LEFT"] = "左侧"
L["RIGHT"] = "右侧"

-- options/misc/phase_icon.lua
L["Phasing"] = "位面"
L["Sharding"] = "分片"

-- options/misc/ready_check_icon.lua
L["Not Ready"] = "未准备"
L["Waiting"] = "等待中"

-- options/misc/summon_icon.lua
L["Accepted"] = "已接受"
L["Available"] = "可用"
L["Rejected"] = "已拒绝"

-- options/misc/tags.lua
L["Moon"] = "月亮"

-- options/options_core.lua
L["About"] = "关于"
L["Custom Docks"] = "自定义 Dock"
L["Example"] = "示例"
L["Individual Professions"] = "单独专业"
L["Keystone to Chat"] = "钥石发到聊天"
L["License"] = "许可证"
L["Nameplates"] = "姓名板"
L["Notification"] = "通知"
L["Open Settings"] = "打开设置"
L["Phase Icon"] = "位面图标"
L["Portraits"] = "头像"
L["Professions"] = "专业"
L["Ready Check Icons"] = "团队确认图标"
L["Unitframes"] = "单位框体"
L["Objective Tracker"] = "任务追踪"
L["Classification Textures"] = "分类纹理"
L["Unitframe Textures"] = "单位框体纹理"
L["Addon Manager"] = "插件管理器"

-- options/portraits/portraits.lua
L["Anchor Point"] = "锚点"
L["Arena"] = "竞技场"
L["Background color shift"] = "背景颜色偏移"
L["Cast Icon"] = "施法图标"
L["Class colored"] = "职业着色"
L["Custom Textures"] = "自定义纹理"
L["Death"] = "死亡"
L["Enable"] = "启用"
L["Enable Class colored Background"] = "启用职业颜色背景"
L["Focus"] = "焦点"
L["Frame Level"] = "框体层级"
L["Frame Strata"] = "框体层次"
L["Mask"] = "蒙版"
L["Party"] = "小队"
L["Pet"] = "宠物"
L["Player"] = "玩家"
L["Reaction"] = "反应"
L["Shadow"] = "阴影"
L["Target"] = "目标"
L["Target of Target"] = "目标的目标"
L["Border Alpha"] = "边框透明度"
L["Cast"] = "施法"
L["Clockwise"] = "顺时针"
L["Edge Softness"] = "边缘柔和度"
L["Fills the ring clockwise, counter-clockwise when disabled."] = "顺时针填充圆环，禁用时逆时针填充。"
L["Filter mode for the portrait textures. Trilinear also samples mipmaps, nearest disables smoothing. The unit portrait itself is not affected."] = "头像纹理的过滤模式。三线性会同时采样多级纹理，最近点会关闭平滑。单位头像本身不受影响。"
L["Nearest"] = "最近点"
L["Opacity of the portrait border below the ring."] = "圆环下方头像边框的透明度。"
L["Reverse Fill"] = "反向填充"
L["Ring"] = "圆环"
L["Ring Alpha"] = "圆环透明度"
L["Shows health or the cast as a radial fill on the portrait border."] = "在头像边框上以径向填充显示生命值或施法。"
L["Softens the edge of the radial fill."] = "柔化径向填充的边缘。"
L["Start Point"] = "起点"
L["Texture Filter"] = "纹理过滤"
L["The ring fills with the missing health instead of draining, so it stays empty at full health."] = "圆环按损失的生命值填充而不是逐渐减少，因此满血时为空。"
L["Trilinear"] = "三线性"
L["Where the fill starts, 0 is the twelve o'clock position."] = "填充的起始位置，0 为十二点钟方向。"

-- options/skin/data_panel_skin.lua
L["Alpha"] = "透明度"
L["Change Texture"] = "更改纹理"
L["Dark Class"] = "暗色职业"
L["Delete all Settings"] = "删除所有设置"
L["Disable"] = "禁用"
L["Export"] = "导出"
L["Import"] = "导入"
L["Import/ Export of this Settings"] = "导入/导出此设置"
L["Info: The Skin can be affected by other addons if they add a skin for all windows. To fix the problem, the skin must be deactivated in the other addon. This is not a bug of mMT."] = "信息：如果其他插件为所有窗口添加皮肤，此皮肤可能会受到影响。要解决该问题，必须在其他插件中禁用该皮肤。这不是 mMT 的错误。"
L["Output/ Input"] = "输出/输入"
L["Panels"] = "面板"
L["Reset"] = "重置"

-- media/media.lua
L["Octagon"] = "八边形"

-- Shared / multiple files
L["+"] = "+"
L["AFK"] = "AFK"
L["Anchor"] = "锚点"
L["Apply"] = "应用"
L["B"] = "B"
L["Background"] = "背景"
L["Bags"] = "背包"
L["Border"] = "边框"
L["Boss"] = "首领"
L["Calendar"] = "日历"
L["CENTER"] = "居中"
L["Changelog"] = "更新日志"
L["Circle"] = "圆形"
L["Class"] = "职业"
L["Classification"] = "分类"
L["Color"] = "颜色"
L["Color Style"] = "颜色样式"
L["Colors"] = "颜色"
L["Combat/Arena Time"] = "战斗/竞技场时间"
L["Custom"] = "自定义"
L["Dead"] = "死亡"
L["Default"] = "默认"
L["Diamond"] = "菱形"
L["Difficulty:"] = "难度："
L["DND"] = "DND"
L["Dock"] = "Dock"
L["DPS"] = "DPS"
L["Dungeon"] = "地下城"
L["Elite"] = "精英"
L["Favorites"] = "收藏"
L["Font"] = "字体"
L["Font contour"] = "字体轮廓"
L["Friends"] = "好友"
L["General"] = "常规"
L["Ghost"] = "灵魂"
L["Guild"] = "公会"
L["Healer"] = "治疗"
L["Health"] = "生命值"
L["Housing"] = "住房"
L["Icon"] = "图标"
L["Icon Size"] = "图标大小"
L["Icons"] = "图标"
L["Keystone"] = "钥石"
L["Keystones on your Account"] = "你账号上的钥石"
L["left click to open Character Frame"] = "左键点击打开角色面板"
L["left click to open LFD Frame"] = "左键点击打开地下城查找器面板"
L["Level"] = "等级"
L["LFG Invite Info"] = "LFG 邀请信息"
L["M+ Score"] = "M+ 评分"
L["Misc"] = "杂项"
L["Miscellaneous"] = "其他"
L["My Info"] = "我的信息"
L["Mythic"] = "史诗"
L["Mythic+"] = "史诗+"
L["No Professions"] = "没有专业"
L["None"] = "无"
L["Normal"] = "普通"
L["Offline"] = "离线"
L["Power"] = "能量"
L["R"] = "R"
L["R+"] = "R+"
L["Raid"] = "团队副本"
L["Rare"] = "稀有"
L["Rare Elite"] = "稀有精英"
L["Ready"] = "已准备"
L["Repair Mount"] = "修理坐骑"
L["Returns a PvP icon if the unit is flagged for PvP and belongs to either the Horde or Alliance faction."] = "如果单位已标记为 PvP 且属于部落或联盟阵营，则返回一个 PvP 图标。"
L["Returns a quest icon if the unit is a quest mob."] = "如果单位是任务怪，则返回一个任务图标。"
L["Returns the class icon of the unit. You can specify a size between 16 and 128 (default is 64). Example: mClassIcon:style{32}"] = "返回单位的职业图标。你可以指定 16 到 128 之间的尺寸（默认值为 64）。示例：mClassIcon:style{32}"
L["Returns the current power percent of the unit, but only while in combat."] = "返回单位当前能量百分比，但仅在战斗中显示。"
L["Returns the faction icon of the unit (Horde or Alliance), but only if it's the opposite faction of the player."] = "返回单位的阵营图标（部落或联盟），但仅当其为玩家的敌对阵营时显示。"
L["Returns the faction icon of the unit (Horde or Alliance)."] = "返回单位的阵营图标（部落或联盟）。"
L["Returns the faction of the unit (Horde or Alliance), but only if it's the opposite faction of the player."] = "返回单位的阵营（部落或联盟），但仅当其为玩家的敌对阵营时显示。"
L["Returns the faction of the unit (Horde or Alliance)."] = "返回单位的阵营（部落或联盟）。"
L["Returns the level of the unit. If the unit is at max level or the same level as you, it will return nothing. If the player is resting, it will return a Zzz."] = "返回单位等级。如果单位为满级或与你同级，则不返回任何内容。如果玩家处于休息状态，则返回 Zzz。"
L["Returns the level of the unit. If the unit is at max level. If the player is resting, it will return a Zzz."] = "返回单位等级。如果单位为满级，则不返回任何内容。如果玩家处于休息状态，则返回 Zzz。"
L["Returns the role icon of the unit (Tank, Healer, DPS)."] = "返回单位角色图标（坦克、治疗、DPS）。"
L["Returns the role of the unit (Tank, Healer, DPS)."] = "返回单位角色（坦克、治疗、DPS）。"
L["Returns the status icon of the unit (AFK, DND, Offline, Dead, Ghost)."] = "返回单位状态图标（AFK、DND、离线、死亡、灵魂）。"
L["Returns the status of the unit (AFK, DND, Offline, Dead, Ghost)."] = "返回单位状态（AFK、DND、离线、死亡、灵魂）。"
L["right click to open Great Vault"] = "右键点击打开宏伟宝库"
L["right click to use:"] = "右键点击使用："
L["Role Icons"] = "角色图标"
L["Settings"] = "设置"
L["SHIFT + right click to clear all saved keystones."] = "SHIFT + 右键点击清除所有已保存的钥石。"
L["Short Version."] = "简短版本。"
L["Show Icon"] = "显示图标"
L["Size"] = "大小"
L["Square"] = "正方形"
L["Status"] = "状态"
L["Style"] = "样式"
L["Tank"] = "坦克"
L["Teleports"] = "传送"
L["Text"] = "文本"
L["Texture"] = "纹理"
L["Tooltip"] = "提示框"
L["Toys"] = "玩具"
L["Volume"] = "音量"
L["X offset"] = "X 偏移"
L["Y offset"] = "Y 偏移"
L["Time"] = "时间"

-- core/addoncompartment.lua
L["SHIFT + Click"] = "SHIFT + 点击"
L["for debug mode."] = "用于调试模式。"

-- core/cmd.lua
L["Added dev GUID:"] = "已添加开发者 GUID："
L["Available commands:"] = "可用命令："
L["DEV mode active"] = "DEV 模式已启用"
L["GUID:"] = "GUID："
L["Lua errors off."] = "Lua 错误已关闭。"
L["Show the current version"] = "显示当前版本"
L["Show this help message"] = "显示此帮助信息"
L["Show your player GUID"] = "显示你的玩家 GUID"
L["Toggle debug mode"] = "切换调试模式"
L["Toggle debug mode with safe addons"] = "使用安全插件切换调试模式"
L["Unable to detect player GUID."] = "无法检测玩家 GUID。"
L["unknown"] = "未知"
L["unknownIDS cleared."] = "unknownIDS 已清除。"
L["Version:"] = "版本："
L["Clear collected unknown IDs"] = "清除已收集的未知 ID"
L["Developer commands:"] = "开发者命令："
L["Enable function profiling (DEV only)"] = "启用函数性能分析（仅限 DEV）"
L["FunctionProfiler is not loaded."] = "FunctionProfiler 未加载。"
L["Profiling already active."] = "性能分析已启用。"
L["Profiling enabled, functions wrapped:"] = "性能分析已启用，已包装函数数："
L["Profiling is only available in DEV mode."] = "性能分析仅在 DEV 模式下可用。"
L["Register this character as developer"] = "将此角色注册为开发者"

-- core/functions.lua
L["!! ERROR - Round:"] = "!! 错误 - 轮次："
L["AddOn Memory:"] = "插件内存："
L["CPU overall:"] = "CPU 总体："
L["CPU peak:"] = "CPU 峰值："
L["Memory/ CPU usage:"] = "内存/CPU 使用："

-- core/retail.lua
L["No current Mythic+ affixes found."] = "未找到当前史诗+词缀。"

-- media/media.lua
L["Blizzard Portrait"] = "暴雪头像"
L["Blizzard Portrait v2"] = "暴雪头像 v2"
L["Blizzard Portrait v3"] = "暴雪头像 v3"
L["Blizzard Portrait v4"] = "暴雪头像 v4"
L["Cardinal v1"] = "Cardinal v1"
L["Cardinal v2"] = "Cardinal v2"
L["Cardinal v3"] = "Cardinal v3"
L["Cardinal v4"] = "Cardinal v4"
L["Cardinal v5"] = "Cardinal v5"
L["Cardinal v6"] = "Cardinal v6"
L["Cardinal v7"] = "Cardinal v7"
L["Hexagon"] = "六边形"
L["Parallelogram"] = "平行四边形"
L["Parallelogram v2"] = "平行四边形 v2"
L["Parallelogram v3"] = "平行四边形 v3"
L["Square Rounded"] = "圆角方形"
L["Window"] = "窗口"
L["Zigzag"] = "锯齿"
L["Zigzag v2"] = "锯齿 v2"

-- modules/datatexts/info_score.lua
L["middle click to open M+ Frame"] = "中键点击打开 M+ 窗口"

-- modules/misc/dice_button.lua
L["Dice Button"] = "骰子按钮"

-- options/cast/important_casts.lua
L["Disabled"] = "已禁用"
L["Enabled"] = "已启用"

-- options/cast/interrupt_on_cd.lua
L["Background Multiplier"] = "背景倍数"
L["Change BG color"] = "更改背景颜色"
L["Enable to change the background color of the castbar."] = "启用以更改施法条背景颜色。"
L["Glows while the current cast can be interrupted."] = "当前施法可以被打断时发光。"
L["Marker"] = "标记"
L["On CD"] = "冷却中"
L["Only important casts"] = "仅重要施法"
L["Only when your interrupt is ready"] = "仅在你的打断技能就绪时"
L["Set the background color multiplier for the castbar."] = "设置施法条背景颜色倍数。"
L["The marker color for in time interrupts."] = "用于及时打断的标记颜色。"

-- options/colors_difficulty.lua
L["Delve"] = "地下堡"
L["Follower"] = "追随者"
L["H"] = "H"
L["Heroic"] = "英雄"
L["LFR"] = "随机团队"
L["M"] = "M"
L["M+"] = "M+"
L["N"] = "N"
L["PVP"] = "PVP"
L["Quest"] = "任务"
L["SC"] = "SC"
L["Scenario"] = "场景战役"
L["Story"] = "剧情"
L["TW"] = "TW"
L["Timewalking"] = "时空漫游"

-- options/colors_tip_menu.lua
L["Mark"] = "标记"
L["Tip"] = "提示"

-- options/datatext/datatexts.lua
L["Change Colors"] = "更改颜色"
L["Override Text Color"] = "覆盖文本颜色"
L["Override Value Color"] = "覆盖数值颜色"
L["Text Color"] = "文本颜色"
L["These colors are used for the tooltips of the datatexts."] = "这些颜色用于数据文本的提示框。"
L["colors"] = "颜色"

-- options/datatext/info_combat_time.lua
L["Hide delay"] = "隐藏延迟"
L["In Combat"] = "战斗中"
L["Out of Combat"] = "脱离战斗"

-- options/datatext/info_durability_itemlevel.lua
L["Force withe Text"] = "强制白色文本"
L["Repair Threshold"] = "修理阈值"
L["Threshold value for the repair color, if this is active then you should repair your gear."] = "用于修理颜色的阈值，如果达到该值，你应该修理装备。"
L["Threshold value for the repair color, if this is active, you should repair your equipment soon."] = "用于修理颜色的阈值，如果达到该值，你应该尽快修理装备。"
L["Warning colors"] = "警告颜色"
L["Warning Threshold"] = "警告阈值"

-- options/datatext/info_score.lua
L["Keystone level"] = "钥石等级"
L["Score"] = "评分"
L["Show Party Keystones"] = "显示小队钥石"
L["Show Upgrades"] = "显示升级"
L["Sort method"] = "排序方式"

-- options/datatext/misc_dungeon.lua
L["Change Text to Dungeon Name."] = "将文本改为地下城名称。"

-- options/datatext/misc_gamemenu.lua
L["Menu Text color"] = "菜单文本颜色"
L["Show Menu Icons"] = "显示菜单图标"
L["Show Systeminfo"] = "显示系统信息"
L["colored"] = "着色"

-- options/datatext/misc_individual_professions.lua
L["Colored"] = "着色"
L["Icon Style"] = "图标样式"

-- options/datatext/misc_professions.lua
L["Menu Icons"] = "菜单图标"
L["Profession Icon Style"] = "专业图标样式"
L["Tooltip Icons"] = "提示框图标"

-- options/datatext/misc_teleports.lua
L["Current Dungeon"] = "当前地下城"
L["Highlight"] = "高亮"
L["Highlights the dungeon of your own keystone."] = "高亮你自己钥石的地下城。"
L["Highlights the dungeon you are listed for, joined or currently in."] = "高亮你已登记、已加入或当前所在的地下城。"
L["My Keystone"] = "我的钥石"
L["Slot"] = "栏位"

-- options/datatext/misc_tracker.lua
L["!!Error - this is not an ID."] = "!!错误 - 这不是一个 ID。"
L["Add Currency or Item ID"] = "添加货币或物品 ID"
L["Color the text"] = "给文本着色"
L["Custom IDs"] = "自定义 ID"
L["Enter a Currency or Item it accepts only Numbers."] = "输入货币或物品，仅接受数字。"
L["Here you can add custom IDs for the tracker. You can add currencies or items. This will add DataTexts for each ID to ElvUI."] = "你可以在这里为追踪器添加自定义 ID。你可以添加货币或物品。这会为每个 ID 向 ElvUI 添加数据文本。"
L["Is Currency"] = "是货币"
L["Short large numbers"] = "缩写大数字"
L["Show Name"] = "显示名称"
L["Show max amount"] = "显示最大数量"

-- options/dock/common
L["Custom Color"] = "自定义颜色"
L["Use a custom color for the icon."] = "为图标使用自定义颜色。"

-- options/dock/bags.lua
L["Free Slots"] = "空余格子"
L["Gold Infos"] = "金币信息"
L["Money"] = "金钱"
L["Money / Free Slots"] = "金钱 / 空余格子"
L["Show gold infos instead of bag slots in the tooltip."] = "在提示框中显示金币信息而不是背包格子。"
L["Used / Total Slots"] = "已用 / 总格子"
L["Used Slots"] = "已用格子"

-- options/dock/character.lua
L["Show durability percentage as text."] = "以文本形式显示耐久度百分比。"
L["Threshold"] = "阈值"

-- options/dock/durability.lua
L["Durability / Item level"] = "耐久度 / 物品等级"
L["Item level"] = "物品等级"

-- options/dock/example.lua
L["Dock V2"] = "Dock V2"
L["MAUI"] = "MAUI"
L["XIV Like"] = "类似 XIV"
L["XVI Like colored"] = "类似 XVI（彩色）"

-- options/dock/friends.lua
L["Show number of online friends on the icon."] = "在图标上显示在线好友数量。"

-- options/dock/general.lua
L["Auto grow"] = "自动放大"
L["Automatically adjust the growth size based on the icon size. When you hover over the icon."] = "当鼠标悬停在图标上时，根据图标大小自动调整放大尺寸。"
L["Class Color"] = "职业颜色"
L["Clicked"] = "点击"
L["Font Color"] = "字体颜色"
L["Font Outline"] = "字体轮廓"
L["Growth size"] = "放大尺寸"
L["Hover"] = "悬停"
L["Set the clicked color of the icon."] = "设置图标被点击时的颜色。"
L["Set the font for dock text."] = "设置 Dock 文本的字体。"
L["Set the font outline for dock text."] = "设置 Dock 文本的字体轮廓。"
L["Set the font size for dock text."] = "设置 Dock 文本的字体大小。"
L["Set the growth size of the dock icon. This is the distance between the icons."] = "设置 Dock 图标的放大尺寸。这也是图标之间的距离。"
L["Set the hover color of the icon."] = "设置图标悬停颜色。"
L["Set the normal color of the icon."] = "设置图标正常颜色。"
L["Show a tooltip when you hover over the icon."] = "当鼠标悬停在图标上时显示提示框。"
L["Use a custom color for dock text. If disabled, the font color will be class colored."] = "为 Dock 文本使用自定义颜色。如果禁用，字体颜色将使用职业颜色。"
L["Use a custom font size for dock text. If disabled, the font size will be set to one third of the icon size."] = "为 Dock 文本使用自定义字体大小。如果禁用，字体大小将设置为图标大小的三分之一。"
L["Use class color for the icon."] = "为图标使用职业颜色。"

-- options/dock/guild.lua
L["Show number of online Guild members on the icon."] = "在图标上显示在线公会成员数量。"

-- options/dock/lfd.lua
L["Call to the arms"] = "战斗号召"
L["Show difficulty or call to the arms on the icon."] = "在图标上显示难度或战斗号召。"
L["Show icons for call to the arms."] = "显示战斗号召图标。"

-- options/dock/notification.lua
L["Auto size"] = "自动大小"
L["ClassColor"] = "职业颜色"

-- options/dock/volume.lua
L["Color the text with the ElvUI color."] = "使用 ElvUI 颜色为文本着色。"

-- options/misc/auto_quest.lua
L["Auto Accept"] = "自动接受"
L["Auto Quest"] = "自动任务"
L["Auto Turn-In"] = "自动交付"
L["Automatically accepts quest dialogs from NPCs."] = "自动接受 NPC 的任务对话。"
L["Automatically turns in completed quests. If the quest has multiple reward choices, the dialog stays open for you to choose."] = "自动交付已完成的任务。如果任务有多个奖励选项，窗口会保持打开以便你选择。"
L["Chat Messages"] = "聊天消息"
L["Disables auto accept/turn-in while you are in combat."] = "在战斗中禁用自动接受/交付。"
L["Prints a message to chat whenever a quest is auto-accepted or turned in, or a gossip option is selected."] = "每当任务被自动接受或交付时，在聊天中输出一条消息。"
L["Skip in Combat"] = "战斗中跳过"
L["Auto Gossip"] = "自动对话"
L["Automatically clicks gossip options of the types selected below. If more than one option matches, the dialog stays open for you to choose."] = "自动点击下方所选类型的对话选项。若有多个选项符合，对话框会保持打开由你选择。"
L["Cinematic Options"] = "过场动画选项"
L["Quest Options"] = "任务选项"
L["Selects gossip options that are marked with the (Quest) label."] = "选择带有（任务）标签的对话选项。"
L["Selects gossip options that start a cinematic."] = "选择会播放过场动画的对话选项。"
L["Selects the option when an NPC offers only a single one. This also triggers on vendors, flight masters and trainers."] = "当 NPC 只提供一个选项时自动选择它。对商人、飞行管理员和训练师同样生效。"
L["Single Option"] = "单一选项"

-- options/misc/difficulty_info.lua
L["Alignment"] = "对齐"
L["Difficulty Info"] = "难度信息"
L["Font size, top line"] = "字体大小，上行"
L["Show Frame"] = "显示框体"

-- options/misc/greeting_message.lua
L["Show a greeting message in the chat when you log in."] = "登录时在聊天中显示欢迎消息。"

-- options/misc/keystone_to_chat.lua
L["Post your keystone to the chat when someone types !key or !keys into the chat."] = "当有人在聊天中输入 !key 或 !keys 时，将你的钥石发送到聊天。"

-- options/misc/group_keystones.lua
L["Shows the keystones of your group next to the group finder listing."] = "在队伍查找器登记旁显示你队伍的钥石。"
L["The keystones of your group members need Details! or BigWigs."] = "队友的钥石需要 Details! 或 BigWigs。"

-- options/misc/lfg_invite_info.lua
L["Class (accent line)"] = "职业（强调线）"
L["Embed icon"] = "嵌入图标"
L["Fade out delay"] = "淡出延迟"
L["First line color"] = "第一行颜色"
L["Font size, bottom line"] = "字体大小，下行"
L["Font size, keystones"] = "字体大小，钥石"
L["Minimal (text only)"] = "极简（仅文本）"
L["Second line color"] = "第二行颜色"
L["Show in chat"] = "在聊天中显示"
L["Shows the icon inside the window instead of next to it. Requires the background to be enabled."] = "在窗口内显示图标，而不是在窗口旁边。需要启用背景。"
L["Theme"] = "主题"
L["Third line color"] = "第三行颜色"
L["Animation"] = "动画"
L["Custom (frame)"] = "自定义（边框）"
L["Fade"] = "淡入淡出"
L["Scale"] = "缩放"
L["Slide"] = "滑动"
L["Theme color"] = "主题颜色"
L["Show teleport"] = "显示传送"
L["Shows the teleport of the dungeon below the card when you join a group for a dungeon of the current Mythic+ season and know its teleport. The card then stays open until you use or close it or the group enters the dungeon."] = "当你加入当前大秘境赛季某个地下城的队伍且已学会其传送时，在卡片下方显示该地下城的传送。卡片会一直显示，直到你使用或关闭它，或队伍进入地下城。"
L["Show keystones"] = "显示钥石"
L["Shows on the card which group members have a keystone for the dungeon and its level. Your own keystone is always known, other players need Details! or BigWigs."] = "在卡片上显示哪些队员拥有该地下城的钥石及其层数。你自己的钥石总是已知，其他玩家需要 Details! 或 BigWigs。"

-- options/misc/phase_icon.lua
L["Chromie Time"] = "克罗米时间"
L["Timerunning World"] = "时空奔流世界"
L["War Mode"] = "战争模式"

-- options/misc/tags.lua
L["DC/ Offline"] = "掉线/离线"
L["PvP"] = "PvP"

-- options/misc/tooltip.lua
L["Icon Zoom"] = "图标缩放"

-- options/nameplates/shared
L["Border color"] = "边框颜色"
L["Health color"] = "生命值颜色"
L["Ignore threat color"] = "忽略仇恨颜色"

-- options/nameplates/nameplate_tools.lua
L["ElvUI Color Settings"] = "ElvUI 颜色设置"
L["Open the ElvUI color settings to adjust the colors used for nameplates."] = "打开 ElvUI 颜色设置以调整姓名板使用的颜色。"
L["Sets automatically your class color for glow and border color on nameplates for the target unit."] = "自动将你的职业颜色设置为目标单位姓名板的发光和边框颜色。"
L["Target & Glow color"] = "目标与发光颜色"
L["Heal and absorb textures for nameplates are configured together with the unitframe textures."] = "姓名板的治疗和吸收纹理与单位框体纹理一起设置。"
L["Open the mMediaTag unitframe texture settings."] = "打开 mMediaTag 单位框体纹理设置。"

-- options/options_core.lua
L["Data Panel Skin"] = "数据面板皮肤"
L["Datatexts"] = "数据文本"
L["Details embedded"] = "嵌入的 Details"
L["Difficulty"] = "难度"
L["Durability & Item Level"] = "耐久度与物品等级"
L["Focus Highlight"] = "焦点高亮"
L["Gamemenu"] = "游戏菜单"
L["Greeting Message"] = "欢迎消息"
L["In WoW Classic, the docks may appear differently because not all modules are available in this version. However, you can still customize the docks through the ElvUI settings."] = "在魔兽世界怀旧服中，由于此版本并非所有模块都可用，Dock 的显示可能会有所不同。不过你仍然可以通过 ElvUI 设置自定义 Dock。"
L["Interrupt On CD"] = "打断冷却中"
L["Minimap Skin"] = "小地图皮肤"
L["Quest Highlight"] = "任务高亮"
L["Resurrection Icon"] = "复活图标"
L["Summon Icon"] = "召唤图标"
L["TAGs"] = "标签"
L["Target Highlight"] = "目标高亮"
L["Tip/ Menu"] = "提示/菜单"
L["Tracker"] = "追踪器"

-- options/portraits/portraits.lua
L["BG"] = "背景"
L["BG Style"] = "背景样式"
L["Choose the background style for the transparent Class icons."] = "为透明职业图标选择背景样式。"
L["Class icon"] = "职业图标"
L["Custom Extra Texture"] = "自定义额外纹理"
L["Death Knight"] = "死亡骑士"
L["Demon Hunter"] = "恶魔猎手"
L["Desaturate"] = "去色"
L["Druid"] = "德鲁伊"
L["Embellishment"] = "装饰"
L["Enable Custom Textures for Portrait."] = "为头像启用自定义纹理。"
L["Enable Cast Icons."] = "启用施法图标。"
L["Enable Custom extra Textures for Portrait."] = "为头像启用自定义额外纹理。"
L["Enable and select a class icon style for the portrait."] = "启用并为头像选择职业图标样式。"
L["Enable and select a spec icon style for the portrait."] = "启用并为头像选择专精图标样式。"
L["Enable Extra Texture"] = "启用额外纹理"
L["Enable the Shadow for the Portraits."] = "为头像启用阴影。"
L["Enable the Unit Portrait."] = "启用单位头像。"
L["Enable this to show the Extra Texture on top of the Unit Portrait."] = "启用后将在单位头像上方显示额外纹理。"
L["Enable custom Position and size settings for Extra Texture."] = "为额外纹理启用自定义位置和大小设置。"
L["Enemy"] = "敌对"
L["Evoker"] = "唤魔师"
L["Extra"] = "额外"
L["Extra Mask"] = "额外蒙版"
L["Extra Settings"] = "额外设置"
L["Extra Shadow"] = "额外阴影"
L["Force Extra Texture"] = "强制额外纹理"
L["Forces the default color for all texture."] = "强制所有纹理使用默认颜色。"
L["Frame Level/ Strata"] = "框体层级/层次"
L["Friendly"] = "友方"
L["Hunter"] = "猎人"
L["It will override the default extra texture, but will take care of rare/elite/boss units."] = "这将覆盖默认的额外纹理，但仍会处理稀有/精英/首领单位。"
L["Mage"] = "法师"
L["Monk"] = "武僧"
L["Neutral"] = "中立"
L["On Top"] = "置顶"
L["Paladin"] = "圣骑士"
L["Portrait Scale"] = "头像缩放"
L["Priest"] = "牧师"
L["Put your custom textures in the Addon folder and add the path here (example MyMediaFolder\\MyTexture.tga)."] = "将你的自定义纹理放入插件文件夹，并在此处填写路径（例如 MyMediaFolder\\MyTexture.tga）。"
L["Reset all colors"] = "重置所有颜色"
L["Reset class colors"] = "重置职业颜色"
L["Rogue"] = "潜行者"
L["Select a extra texture style for boss units."] = "为首领单位选择额外纹理样式。"
L["Select a extra texture style for elite units."] = "为精英单位选择额外纹理样式。"
L["Select a extra texture style for player."] = "为玩家选择额外纹理样式。"
L["Select a extra texture style for rare elite units."] = "为稀有精英单位选择额外纹理样式。"
L["Select a extra texture style for rare units."] = "为稀有单位选择额外纹理样式。"
L["Select a portrait texture style."] = "选择头像纹理样式。"
L["Shadow Alpha"] = "阴影透明度"
L["Shaman"] = "萨满祭司"
L["Shows the Extra Texture (rare/elite) for the Unit Portrait."] = "为单位头像显示额外纹理（稀有/精英）。"
L["Texture Style settings for Extra texture (Rare/Elite/Boss/player)."] = "额外纹理（稀有/精英/首领/玩家）的纹理样式设置。"
L["Texture Styles"] = "纹理样式"
L["TIP: If you use the Blizzard textures and change the classification color to white, you will see the extra texture with the original colors."] = "提示：如果你使用暴雪纹理并将分类颜色改为白色，你将看到保留原始颜色的额外纹理。"
L["Unitcolor for Extra"] = "额外层使用单位颜色"
L["Use Default color"] = "使用默认颜色"
L["Spec icons"] = "专精图标"
L["Use the unit color for the Extra (Rare/Elite) Texture."] = "额外（稀有/精英）纹理使用单位颜色。"
L["Warlock"] = "术士"
L["Warrior"] = "战士"
L["Will always desaturate the portraits."] = "始终对头像进行去色处理。"
L["Will show the embellishment on the portraits, if the Style has an embellishment."] = "如果样式带有装饰，将在头像上显示该装饰。"

-- options/skin/data_panel_skin.lua
L["Delete the actual Settings"] = "删除当前设置"
L["Info: This Settings will override the ElvUI Data Panel settings."] = "信息：这些设置将覆盖 ElvUI 数据面板设置。"
L["Reset all"] = "全部重置"

-- options/skin/minimap.lua
L["Cardinal Icon"] = "Cardinal 图标"

-- options/datatext/misc_gamemenu.lua
L["white"] = "白色"

-- options/options_core.lua
L["These are just examples of how to create your own dock using ElvUI’s custom data text bars.\n\nTo set up a custom bar:\nOpen ElvUI and navigate to ElvUI > Datatext > Bars.\nEnter a name for your new bar, click OK, and then click Add.\nSet the width of the bar based on how many icons you want to display.\nSet the height, which also determines the icon size.\nChoose the number of data text slots you want.\n\nAssign icons to each slot. For example:\nSlot 1 = Dock Calendar\nSlot 2 = Dock Profession\nSlot 3 = Dock Spec\n…and so on.\n\nThis setup allows you to build a personalized dock that fits your UI and gameplay needs.\n\n"] = "这些只是使用 ElvUI 自定义数据文本条来创建你自己的 Dock 的示例。\n\n要设置自定义条：\n打开 ElvUI，然后前往 ElvUI > Datatext > Bars。\n为你的新条输入一个名称，点击 OK，然后点击 Add。\n根据你想显示的图标数量设置条的宽度。\n设置高度，这也会决定图标大小。\n选择你想要的数据文本槽位数量。\n\n为每个槽位分配图标。例如：\n槽位 1 = Dock Calendar\n槽位 2 = Dock Profession\n槽位 3 = Dock Spec\n……依此类推。\n\n此设置可以让你创建一个符合自己界面和游戏需求的个性化 Dock。\n\n"

-- modules/portraits/texture_db.lua
L["Antik"] = "古典"
L["BG 1"] = "背景 1"
L["BG 2"] = "背景 2"
L["BG 3"] = "背景 3"
L["BG 4"] = "背景 4"
L["BG 5"] = "背景 5"
L["BG 6"] = "背景 6"
L["Blizzard Boss"] = "暴雪首领"
L["Blizzard Boss Neutral"] = "暴雪首领（中立）"
L["Blizzard Elite"] = "暴雪精英"
L["Blizzard Rare"] = "暴雪稀有"
L["Blizzard Rare/ Elite Neutral"] = "暴雪稀有/精英（中立）"
L["Blizzard Round"] = "暴雪圆形"
L["Blizzard Round Thick"] = "暴雪粗圆形"
L["Blizzard Round UP"] = "暴雪上圆形"
L["Blizzard Round UP Thick"] = "暴雪上粗圆形"
L["Blizzard Sharp"] = "暴雪尖角"
L["Blizzard Sharp Thick"] = "暴雪粗尖角"
L["Blizzard Sharp UP"] = "暴雪上尖角"
L["Blizzard Sharp UP Thick"] = "暴雪上粗尖角"
L["Circle Thick"] = "粗圆形"
L["Climbing Plant"] = "攀缘植物"
L["Climbing Plant V2"] = "攀缘植物 V2"
L["Cookie"] = "饼干"
L["Diamond Thick"] = "粗菱形"
L["Dog Any"] = "任意狗"
L["Dog Pack"] = "狗群"
L["Dog Pack color"] = "狗群彩色"
L["Dogs"] = "狗"
L["Dogs color"] = "狗彩色"
L["Dragon Blue"] = "蓝龙"
L["Dragon Boss"] = "龙首领"
L["Dragon Elite"] = "龙精英"
L["Dragon Green"] = "绿龙"
L["Dragon Purple"] = "紫龙"
L["Leaf"] = "叶子"
L["Leaf Mirrored"] = "镜像叶子"
L["Pad"] = "垫片"
L["Parallelogram Mirrored"] = "镜像平行四边形"
L["Pentagon"] = "五边形"
L["Pixel"] = "像素"
L["Rectangular"] = "矩形"
L["Round - Leaf"] = "圆形 - 叶子"
L["Round - Monster"] = "圆形 - 怪物"
L["Round - Pulse"] = "圆形 - 脉冲"
L["Round - Star"] = "圆形 - 星形"
L["Round - Tech"] = "圆形 - 科技"
L["Round - Zickzack"] = "圆形 - 之字形"
L["Shield"] = "盾牌"
L["Snake"] = "蛇"
L["Snake Blue"] = "蓝蛇"
L["Snake Green"] = "绿蛇"
L["Snake Purple"] = "紫蛇"
L["Snake Red"] = "红蛇"
L["Space"] = "太空"
L["Space color"] = "太空彩色"
L["Square Leaf"] = "方形叶子"
L["Square Loop"] = "方形环"
L["Square Round"] = "圆角方形"
L["Square Round Thick"] = "粗圆角方形"
L["Square Spikes"] = "尖刺方形"
L["Square Stars"] = "星形方框"
L["Square Thick"] = "粗方形"
L["Tear"] = "泪滴"
L["Tear down"] = "向下泪滴"
L["Tear down Mirrored"] = "镜像向下泪滴"
L["Tear Mirrored"] = "镜像泪滴"
L["Trapezoid"] = "梯形"
L["Trapezoid Mirrored"] = "镜像梯形"

-- modules/misc/addon_manager.lua
L["Addon profile saved:"] = "插件配置已保存："
L["Addon Profiles"] = "插件配置"
L["Addons with disabled dependencies:"] = "依赖项被禁用的插件："
L["All Characters"] = "所有角色"
L["Category"] = "类别"
L["Delete Profile"] = "删除配置"
L["Filter"] = "过滤"
L["Name of the addon profile:"] = "插件配置名称："
L["Protect ElvUI & mMT"] = "保护 ElvUI 和 mMT"
L["Save Current State"] = "保存当前状态"

-- options/datatext/info_time.lua
L["Clock"] = "时钟"
L["Clock Icon"] = "时钟图标"
L["Combat Icon"] = "战斗图标"
L["Switches to the combat time as soon as you enter combat."] = "进入战斗后立即切换为战斗时间。"
L["Time format and tooltip are taken from ElvUI's Time datatext."] = "时间格式和提示框取自 ElvUI 的时间数据文字。"

-- options/misc/addon_manager.lua
L["Add a profile dropdown and a filter to Blizzard's addon list."] = "在暴雪插件列表中添加配置下拉菜单和过滤器。"
L["Apply profiles account wide instead of only to the current character."] = "将配置应用到整个账号，而不仅是当前角色。"
L["Apply to all characters"] = "应用到所有角色"
L["Never disable ElvUI, its libraries and mMediaTag when a profile is applied."] = "应用配置时绝不禁用 ElvUI、其库文件和 mMediaTag。"
L["Protect ElvUI and mMediaTag"] = "保护 ElvUI 和 mMediaTag"
L["Save your enabled addons as a named set and switch between them from Blizzard's addon list."] = "将已启用的插件保存为命名组合，并在暴雪插件列表中切换。"

-- options/misc/prey_hunt.lua
L["Prey Hunt"] = "猎物狩猎"
L["Shows Ready in green once every hunt stage is done, the text is hidden otherwise."] = "所有狩猎阶段完成后以绿色显示“就绪”，否则隐藏文字。"
L["Shows the current hunt stage as text on the prey icon."] = "在猎物图标上以文字显示当前狩猎阶段。"
L["Target List"] = "目标列表"
L["Mark Defeated Targets"] = "标记已击败的目标"
L["Colors prey targets you already defeated in the target list, based on the achievement criteria."] = "根据成就条件，在目标列表中为已击败的猎物着色。"

-- options/misc/unitframe_textures.lua
L["Background Texture"] = "背景纹理"
L["Castbar"] = "施法条"
L["Absorb Shield"] = "吸收护盾"
L["Heal Absorb"] = "治疗吸收"
L["Incoming Heal"] = "即将受到的治疗"
L["Power Cost"] = "能量消耗"
L["Target of Target of Target"] = "目标的目标的目标"

-- options/nameplates/classification_texture.lua
L["Caster"] = "施法者"
L["Elite Boss"] = "精英首领"
L["Elite Mini"] = "精英小首领"
L["In Instances"] = "在副本中"
L["Inside a dungeon every mana user counts as a caster, so that texture wins over the elite ones there."] = "在地下城中，所有使用法力的单位都算作施法者，因此该纹理优先于精英纹理。"
L["Show the classification textures only inside dungeons, raids and other instances."] = "仅在地下城、团队副本和其他副本中显示分类纹理。"
L["World Boss"] = "世界首领"

-- options/nameplates/auto_friendly_nameplates.lua
L["Auto Friendly Nameplates"] = "自动友方姓名板"
L["Automatically shows friendly nameplates in dungeons and raids and hides them in the open world."] = "在地下城和团队副本中自动显示友方姓名板，在野外隐藏。"
L["Dungeons"] = "地下城"
L["Raids"] = "团队副本"
L["Show friendly nameplates in dungeons."] = "在地下城中显示友方姓名板。"
L["Show friendly nameplates in raids."] = "在团队副本中显示友方姓名板。"

-- options/misc/objective_tracker.lua
L["Bad"] = "差"
L["Class Color Border"] = "职业颜色边框"
L["Colors objectives like 3/5 by progress."] = "按进度为 3/5 这类目标着色。"
L["Complete"] = "已完成"
L["Good"] = "好"
L["Gradient"] = "渐变"
L["Header"] = "标题栏"
L["Header Bar"] = "标题条"
L["Hide Dash"] = "隐藏短横线"
L["Progress"] = "进度"
L["Removes the dash in front of each objective."] = "移除每个目标前的短横线。"
L["Some changes require a reload of the UI."] = "部分更改需要重载界面。"
L["Transition"] = "过渡"
L["Transparent"] = "透明"

-- options/nameplates/execute_marker.lua
L["Automatic range"] = "自动范围"
L["Determines the execute range automatically based on your class, spec and talents."] = "根据你的职业、专精和天赋自动确定斩杀范围。"
L["Execute Marker"] = "斩杀标记"
L["Execute range"] = "斩杀范围"
L["Only in combat"] = "仅在战斗中"
L["Shows a marker on enemy nameplates at the execute threshold of your spec. Because of the Midnight API restrictions the marker is hidden via clipping once the unit drops below the threshold, health values are never read."] = "在敌方姓名板上标出你专精的斩杀阈值。由于至暗之夜的 API 限制，单位血量低于阈值后标记会通过裁剪隐藏，从不读取生命值。"

-- options/nameplates/raid_marker_color.lua
L["Raid Marker Colors"] = "团队标记颜色"
L["Raid Markers"] = "团队标记"
L["Colors the health bar of nameplates with a raid marker in the color of that marker."] = "将带有团队标记的姓名板生命条染成该标记的颜色。"

-- modules/skin/bugsack.lua
L["Page:"] = "页："

-- options/skin/auctionator.lua
L["Info: Auctionator is not installed."] = "信息：未安装 Auctionator。"
L["Info: This skins the Shopping, Selling, Cancelling and Auctionator tabs. Rows inside the result lists keep their default look."] = "信息：为购买、出售、取消和 Auctionator 标签页应用皮肤。结果列表中的行保持默认外观。"

-- options/skin/bigwigs.lua
L["Custom Texture"] = "自定义纹理"
L["Info: BigWigs is not installed."] = "信息：未安装 BigWigs。"
L["Info: The keystone window is the /key list, the queue timer is the bar below the dungeon invite popup. Boss bars keep their own BigWigs style."] = "信息：钥石窗口是 /key 列表，排队计时器是地下城邀请弹窗下方的计时条。首领计时条保持 BigWigs 自身样式。"
L["Keystone Window"] = "钥石窗口"
L["Original"] = "原始"
L["Queue Timer Bar"] = "排队计时条"

-- options/skin/aussyloot.lua
L["Value Color"] = "数值颜色"
L["Info: AussyLoot is not installed."] = "信息：未安装 AussyLoot。"
L["Info: This replaces AussyLoot's own surface, border and accent colors with the ElvUI ones and its fonts with the ElvUI font. The window is rebuilt on the next reload, the item quality, crest and status colors keep their own meaning."] = "信息：将 AussyLoot 自身的表面、边框和强调色替换为 ElvUI 的颜色，并将其字体替换为 ElvUI 字体。窗口会在下次重载时重建，物品品质、纹章和状态颜色保持原有含义。"

-- options/skin/premade_groups_filter.lua
L["Checkboxes"] = "复选框"
L["Info: Premade Groups Filter is not installed."] = "信息：未安装 Premade Groups Filter。"
L["Info: This skins the filter dialog, its panels, dropdowns and popups."] = "信息：为过滤对话框及其面板、下拉菜单和弹窗应用皮肤。"

-- options/skin/bugsack.lua
L["Info: BugSack is not installed."] = "信息：未安装 BugSack。"
L["Shows the ElvUI, mMT and WoW version left of the page counter."] = "在页码左侧显示 ElvUI、mMT 和 WoW 的版本。"
L["Skins"] = "皮肤"
L["Version Info"] = "版本信息"

-- options/media_pack.lua
L["Choose which texture packs are registered. Loading fewer packs keeps the texture dropdowns short. Changes need a UI reload."] = "选择要注册的纹理包。加载的纹理包越少，纹理下拉菜单越短。更改需要重载界面。"
L["Disable All"] = "全部禁用"
L["Enable All"] = "全部启用"
L["Load all texture packs"] = "加载所有纹理包"
L["Media Pack"] = "Media Pack"
L["Overrides the individual packs below."] = "覆盖下方的单独纹理包设置。"
L["Texture Packs"] = "纹理包"

-- modules/cooldownmanager
L["Essential Cooldowns"] = "核心冷却"
L["Utility Cooldowns"] = "辅助冷却"
L["Buff Icons"] = "增益图标"
L["Buff Bars"] = "增益计时条"
L["Custom Tracker"] = "自定义追踪"
L["Buff Name"] = "增益名称"
L["Cooldown Manager"] = "冷却管理器"
L["The cooldown manager needs Blizzards cooldown viewer. Enable it again under Options > Gameplay Enhancements."] = "冷却管理器需要暴雪的冷却显示器。请在 选项 > 游戏体验增强 中重新启用。"
L["Blizzards cooldown manager was enabled, a reload is needed."] = "暴雪冷却管理器已启用，需要重载界面。"
L["ElvUIs cooldown manager skin was turned on for the mMT cooldown manager, a reload is needed."] = "已为 mMT 冷却管理器开启 ElvUI 的冷却管理器皮肤，需要重新载入。"
L["The mMT cooldown manager needs ElvUIs Blizzard skins for the ElvUI look of its icons, they are turned off under ElvUI > Skins."] = "mMT 冷却管理器需要 ElvUI 的暴雪皮肤来为图标提供 ElvUI 外观，它们已在 ElvUI > 皮肤 中关闭。"
L["Glow Options"] = "发光选项"
L["Enable Glow"] = "启用发光"
L["Type"] = "类型"
L["Speed"] = "速度"
L["Lines"] = "线条"
L["Thickness"] = "粗细"
L["Particles"] = "粒子"
L["Bar Colors"] = "计时条颜色"
L["Enable Custom Colors"] = "启用自定义颜色"
L["Foreground"] = "前景"
L["Active State"] = "激活状态"
L["Mode"] = "模式"
L["Hide"] = "隐藏"
L["Customize"] = "自定义"
L["Swipe"] = "冷却转圈"
L["Keep"] = "保持"
L["Solid Color"] = "纯色"
L["Swipe Color"] = "转圈颜色"
L["Active Text Color"] = "激活文字颜色"
L["Desaturate icon while active"] = "激活时图标去色"
L["The active text color applies only while the buff is running, afterwards the normal cooldown text returns."] = "激活文字颜色仅在增益持续期间生效，之后恢复为普通冷却文字。"

-- options/cooldownmanager/cooldown_manager.lua
L["Center"] = "居中"
L["Top"] = "上"
L["Bottom"] = "下"
L["Left"] = "左"
L["Right"] = "右"
L["Top Left"] = "左上"
L["Top Right"] = "右上"
L["Bottom Left"] = "左下"
L["Bottom Right"] = "右下"
L["Always"] = "总是"
L["In Group"] = "在队伍中"
L["Player Fader"] = "玩家渐隐"
L["Hidden"] = "隐藏"
L["Position"] = "位置"
L["X-Offset"] = "X 偏移"
L["Y-Offset"] = "Y 偏移"
L["Layout"] = "布局"
L["Keep Size Ratio"] = "保持尺寸比例"
L["Icon Width"] = "图标宽度"
L["Icon Height"] = "图标高度"
L["Spacing"] = "间距"
L["Icons Per Row"] = "每行图标数"
L["Vertical Growth"] = "垂直增长"
L["Down"] = "向下"
L["Up"] = "向上"
L["When to Show"] = "显示时机"
L["Show Tooltips"] = "显示提示框"
L["Show Keybind"] = "显示按键绑定"
L["Visibility"] = "可见性"
L["Proc Glow"] = "触发发光"
L["Cooldown Text"] = "冷却文字"
L["Count Text"] = "层数文字"
L["Keybind Text"] = "按键绑定文字"
L["Moves Blizzards cooldown manager icons into mMT containers with own movers and text settings. Blizzards cooldown manager has to be enabled under Options > Gameplay Enhancements."] = "将暴雪冷却管理器的图标移入 mMT 容器，拥有独立的移动锚点和文字设置。需要在 选项 > 游戏体验增强 中启用暴雪冷却管理器。"
L["Hide GCD Swipe"] = "隐藏公共冷却转圈"
L["Bar Width"] = "计时条宽度"
L["Bar Height"] = "计时条高度"
L["Icon Gap"] = "图标间隙"
L["Mirrored Columns"] = "镜像列"
L["Column Gap"] = "列间距"
L["Name Text"] = "名称文字"
L["Duration Text"] = "持续时间文字"
L["Stacks Text"] = "层数文字"
L["Show Racials"] = "显示种族技能"
L["Show Healthstone"] = "显示治疗石"
L["Show Healing Potions"] = "显示治疗药水"
L["Show Combat Potions"] = "显示战斗药水"
L["Show Weyrnstone"] = "显示 Weyrnstone"
L["Tracks the cooldown of the Weyrnstone while it is in your bags."] = "当 Weyrnstone 在背包中时追踪其冷却。"
L["Show Belt Tinker"] = "显示腰带工程改装"
L["Trinkets"] = "饰品"
L["Both"] = "两者"
L["Trinket 1"] = "饰品 1"
L["Trinket 2"] = "饰品 2"
L["On-Use Only"] = "仅限主动使用"
L["Hides passive and proc trinkets without an activatable cooldown."] = "隐藏没有可激活冷却的被动和触发型饰品。"
L["Growth Direction"] = "增长方向"
L["Managed"] = "已接管"
L["Not Managed"] = "未接管"
L["Move this viewer into an mMT container. Turn it off to leave it to Blizzard and ElvUI."] = "将此显示器移入 mMT 容器。关闭后交由暴雪和 ElvUI 处理。"
L["Opacity"] = "不透明度"
L["Show"] = "显示"
L["Debuff Border"] = "减益边框"
L["Keeps Blizzards colored border on harmful auras."] = "在有害光环上保留暴雪的彩色边框。"
L["Bar Color"] = "计时条颜色"
L["Background Color"] = "背景颜色"
L["A single aura can override this with a right click in Blizzards cooldown manager."] = "可以在暴雪冷却管理器中右键单击单个光环来覆盖此设置。"
L["Pandemic"] = "Pandemic"
L["What to show while the aura is inside its refresh window."] = "光环处于刷新窗口内时显示的内容。"
L["Blizzard"] = "暴雪"
L["Glow"] = "发光"
L["Pandemic Glow"] = "Pandemic 发光"
L["Demo"] = "演示"
L["Fills every managed viewer with placeholder icons and bars that follow your settings live. Turns itself off when the options close."] = "用示例图标和计时条填充所有已接管的显示器，并实时跟随你的设置。关闭选项时自动关闭。"
L["Hide Delay"] = "隐藏延迟"
L["How long the display stays up after its condition falls away."] = "条件不再满足后，显示继续保留的时长。"
L["Fade Time"] = "渐变时间"
L["How long fading in and out takes. Zero switches instantly."] = "淡入和淡出所需的时间。为零时立即切换。"
L["Texts"] = "文字"
L["Copy Settings"] = "复制设置"
L["Copy From"] = "复制自"
L["Only settings this display knows are taken over, everything else stays untouched."] = "只复制此显示器认识的设置，其他内容保持不变。"
L["Sections"] = "分组"
L["Copy"] = "复制"
L["Took over %d settings from %s."] = "已复制 %d 项设置，来源：%s。"
L["Own Entries"] = "自定义条目"
L["Spell"] = "法术"
L["Item"] = "物品"
L["Equipment Slot"] = "装备栏位"
L["Spell or Item ID"] = "法术或物品 ID"
L["Add"] = "添加"
L["No spell or item found for this ID."] = "找不到与此 ID 对应的法术或物品。"
L["Entries"] = "条目"
L["Move Up"] = "上移"
L["Move Down"] = "下移"
L["Remove"] = "移除"
L["Known Spells Only"] = "仅限已学会的法术"
L["Hides own spell entries the character has not learned."] = "隐藏角色尚未学会的自定义法术条目。"
L["Fixed Width"] = "固定宽度"
L["Fixed Height"] = "固定高度"
L["Width of the whole block, the icons of a row share it and the icon size settings are ignored. 0 = off."] = "整个区块的宽度，一行中的图标平分此宽度，图标尺寸设置将被忽略。0 = 关闭。"
L["Height of all rows, the icons are sized from it and the icon size settings are ignored. 0 = off."] = "所有行的高度，图标尺寸由此计算，图标尺寸设置将被忽略。0 = 关闭。"
L["Only when ready"] = "仅在就绪时"
L["Only on cooldown"] = "仅在冷却中"
L["Only when missing"] = "仅在缺少时"
L["When the selected entry is shown. Missing means for spells that the buff with this spell ID is not on you (read outside of combat, in combat the last state is kept), for items that none is in the bags and for slots that nothing is equipped."] = "所选条目何时显示。缺少对法术而言表示你身上没有此法术ID的增益（在战斗外读取，战斗中保持最后状态），对物品表示背包中没有，对装备栏表示未装备任何物品。"
L["Glow when ready"] = "就绪时发光"
L["Glow Color"] = "发光颜色"
