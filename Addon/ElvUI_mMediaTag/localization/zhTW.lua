local L = LibStub("AceLocale-3.0"):NewLocale("mMediaTag", "zhTW")
if not L then return end

-- core/functions.lua
L["Error decompressing data."] = "解壓縮資料時發生錯誤。"
L["Error deserializing:"] = "反序列化錯誤："
L["Error importing profile. String is invalid or corrupted!"] = "匯入設定檔錯誤。字串無效或已損壞！"
L["This export belongs to another setting and cannot be imported here."] = "此匯出屬於其他設定，無法在此匯入。"
L["This export was created by an older version and can no longer be imported."] = "此匯出由舊版本建立，已無法匯入。"

-- modules/datatexts/info_score.lua
L["Mythic+ Best Run: +"] = "傳奇+最佳紀錄：+"
L["Dungeon overview:"] = "地城總覽："
L["Keystones in your Group"] = "你隊伍中的鑰石"
L["Level: "] = "等級："
L["No Keystone"] = "沒有鑰石"
L["Possible next upgrades:"] = "可能的下次升級："
L["This Week Affix"] = "本週詞綴"

-- modules/datatexts/misc_coordinate.lua
L["Coordinate X"] = "座標 X"
L["Coordinate Y"] = "座標 Y"

-- modules/datatexts/misc_dungeon.lua
L["Call to Arms:"] = "戰鬥的號角："
L["Difficulty Infos:"] = "難度資訊："
L["Dungeon Infos:"] = "地城資訊："
L["Dungeon:"] = "地城："
L["Guild Party:"] = "公會隊伍："
L["Legacy Raid:"] = "舊版團隊副本："
L["Name:"] = "名稱："
L["No"] = "否"
L["Raid:"] = "團隊副本："
L["This week's Affix"] = "本週詞綴"
L["Yes"] = "是"

-- modules/datatexts/misc_gamemenu.lua
L["Framerate:"] = "幀率："
L["Game Menu"] = "遊戲選單"
L["Latency:"] = "延遲："
L["left click to open the menu."] = "左鍵點擊以開啟選單。"
L["right click to open LFD Browser"] = "右鍵點擊以開啟地下城搜尋器"
L["Home"] = "本地"
L["World"] = "世界"

-- modules/datatexts/misc_individual_professions.lua
L["Archaeology"] = "考古學"
L["Cooking"] = "烹飪"
L["Fishing"] = "釣魚"
L["Not learned"] = "尚未學習"
L["Primary Profession"] = "主要專業"
L["Secondary Profession"] = "次要專業"

-- modules/datatexts/misc_professions.lua
L["click to open the menu."] = "點擊以開啟選單。"
L["Main Professions"] = "主要專業"
L["No Main Professions"] = "沒有主要專業"
L["No Secondary Professions"] = "沒有次要專業"
L["Secondary Professions"] = "次要專業"

-- modules/datatexts/misc_teleports.lua
L["Dungeon Teleports"] = "地城傳送"
L["Engineering"] = "工程學"
L["Favorite"] = "最愛"
L["Items"] = "物品"
L["Left click to open the Teleports menu."] = "左鍵點擊以開啟傳送選單。"
L["M+ Season"] = "M+ 賽季"
L["Mage Portals"] = "法師傳送門"
L["Mage Teleports"] = "法師傳送"
L["Midnight"] = true
L["Other Portals"] = "其他傳送門"
L["Other Teleports"] = "其他傳送"
L["Random"] = "隨機"
L["Season Teleports"] = "賽季傳送"
L["Spells"] = "法術"
L["You can select your favourites in the settings."] = "你可以在設定中選擇你的最愛。"
L["You currently have no important teleports."] = "你目前沒有重要的傳送。"

-- modules/dock/achievement.lua
L["Achievement points:"] = "成就點數："
L["Completed"] = "已完成"
L["Guild Achievement points:"] = "公會成就點數："
L["Missing"] = "缺少"
L["Tracked Achievements"] = "追蹤中的成就"

-- modules/dock/calendar.lua
L["Date:"] = "日期："

-- modules/dock/character.lua
L["Account total"] = "帳號總計"
L["Time played this level"] = "此等級遊玩時間"
L["Total play time"] = "總遊玩時間"

-- modules/dock/collection.lua
L["Collected"] = "已收集"
L["Mounts"] = "坐騎"
L["Pets"] = "寵物"

-- modules/dock/encounter.lua
L["Progress:"] = "進度："
L["Reisetagebuch"] = "冒險指南"

-- modules/dock/housing.lua
L["Neighborhood"] = "鄰里"
L["No cached house information available."] = "沒有可用的快取房屋資訊。"
L["Owner"] = "擁有者"

-- modules/dock/spellbook.lua
L["click to open the Spellbook."] = "點擊以開啟法術書。"
L["Opening the spellbook via addons can lead to taints.\nThis occurs when protected Blizzard code is unintentionally modified or affected,\nwhich may result in malfunctions or UI restrictions."] = "透過插件開啟法術書可能會導致污染（taint）。\n當受保護的暴雪程式碼被無意修改或影響時，就會發生這種情況，\n這可能導致功能異常或介面限制。"

-- modules/dock/store.lua
L["WoW Token:"] = "魔獸代幣："

-- modules/misc/auto_quest.lua
L["[AutoQuest] Auto-accept paused (SHIFT held)."] = "[AutoQuest] 自動接受已暫停（按住 SHIFT）。"
L["[AutoQuest] Auto-turn-in paused (SHIFT held)."] = "[AutoQuest] 自動交付已暫停（按住 SHIFT）。"
L["[AutoQuest] Quest accepted: %s"] = "[AutoQuest] 任務已接受：%s"
L["[AutoQuest] Quest turned in: %s"] = "[AutoQuest] 任務已交付：%s"
L["[AutoQuest] Auto-gossip paused (SHIFT held)."] = "[AutoQuest] 自動對話已暫停（按住 SHIFT）。"
L["[AutoQuest] Gossip selected: %s"] = "[AutoQuest] 已選擇對話選項：%s"

-- modules/misc/class_icons.lua
L["Could not add the texture."] = "無法新增材質。"
L["The style already exists."] = "該樣式已存在。"
L["The texture coordinates must be passed as a table."] = "材質座標必須以表格形式傳入。"

-- modules/misc/details.lua
L["Click to hide Details frames."] = "點擊以隱藏 Details 視窗。"
L["Details embedded toggle"] = "切換嵌入式 Details"

-- modules/misc/dice_button.lua
L["Left Click to roll"] = "左鍵點擊以擲骰"
L["Right Click to roll"] = "右鍵點擊以擲骰"
L["Roll Button"] = "擲骰按鈕"

-- modules/misc/greeting_message.lua
L["Welcome to %s %s version |CFFF7DC6F%s|r, type |CFF58D68D/mmt|r to access the in-game configuration menu or type |CFF58D68D/mmt help|r for an overview of all chat commands."] = "歡迎使用 %s %s 版本 |CFFF7DC6F%s|r，輸入 |CFF58D68D/mmt|r 可開啟遊戲內設定選單，或輸入 |CFF58D68D/mmt help|r 查看所有聊天指令總覽。"

-- modules/misc/lfg_invite_info.lua
L["PVE"] = "PVE"
L["The Flame Burns Eternal"] = "烈焰永燃"
L["The Floodgate"] = "洪水閘門"
L["The Rookery"] = "鳥巢"
L["Transmog farming"] = "幻化農場"
L["Weekly"] = "每週"

-- modules/misc/tags.lua
L["Returns the classification icon of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-classification:icon{rare:elite}] will only show something if the unit is either rare or elite."] = "回傳單位的分類圖示。你可以指定最多三個參數，只顯示某些分類。\n例如：[mMT-classification:icon{rare:elite}] 只有當單位是稀有或精英時才會顯示。"
L["Returns the classification of the unit. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-classification{rare:elite}] will only show something if the unit is either rare or elite."] = "回傳單位的分類。你可以指定最多三個參數，只顯示某些分類。\n例如：[mMT-classification{rare:elite}] 只有當單位是稀有或精英時才會顯示。"
L["Returns the color of the unit. Players are colored by class, NPCs by classification. You can specify up to three arguments to display only certain classifications.\nFor example: [mMT-color{rare:elite}] will only show something if the unit is either rare or elite."] = "回傳單位的顏色。玩家依職業著色，NPC 依分類著色。你可以指定最多三個參數，只顯示某些分類。\n例如：[mMT-color{rare:elite}] 只有當單位是稀有或精英時才會顯示。"
L["Returns the spec icon of the unit. You can specify a size between 16 and 128 (default is 64). Example: mSpecIcon:style{32}"] = "回傳單位的專精圖示。你可以指定 16 到 128 之間的大小（預設為 64）。例如：mSpecIcon:style{32}"
L["Returns the current health of the unit (changes between current health and percent in combat)."] = "回傳單位目前生命值（戰鬥中會在目前生命值與百分比之間切換）。"
L["Returns the current health of the unit."] = "回傳單位目前生命值。"
L["Returns the current health percent of the unit (in combat)."] = "回傳單位目前生命值百分比（戰鬥中）。"
L["Same as mMT-color, but only for the units target."] = "與 mMT-color 相同，但只針對該單位的目標。"


-- options/about.lua
L["Contact"] = "聯絡方式"
L["Help"] = "幫助"
L["Thanks to:"] = "感謝："

-- options/cast/important_casts.lua
L["Adds an Extra Icon to the Castbar."] = "在施法條上新增額外圖示。"
L["Border Color"] = "邊框顏色"
L["Class Colors"] = "職業顏色"
L["Health Override"] = "生命值條覆寫"
L["Override Health Bar Color"] = "覆寫生命值條顏色"
L["Position Settings"] = "位置設定"
L["Sets the offset according to the anchor."] = "根據錨點設定偏移。"

-- options/changelog.lua
L["Fixes"] = "修正"
L["Important"] = "重要"
L["New"] = "新增"
L["Released"] = "發布"
L["Updates"] = "更新"
L["Version"] = "版本"

-- options/colors_difficulty.lua
L["Other"] = "其他"

-- options/colors_tip_menu.lua
L["Title"] = "標題"

-- options/datatext/misc_dungeon.lua
L["Dungeon Name"] = "地城名稱"

-- options/datatext/misc_individual_professions.lua
L["White"] = "白色"
L["Profession (Colored)"] = "專業（彩色）"
L["Profession (White)"] = "專業（白色）"

-- options/datatext/misc_tracker.lua
L["Delete ID"] = "刪除 ID"
L["ID list"] = "ID 清單"
L["Crop Icons"] = "裁切圖示"
L["Cut off the icon border."] = "裁掉圖示邊框。"

-- options/dock/durability.lua
L["Durability"] = "耐久度"

-- options/dock/example.lua
L["Delete all"] = "全部刪除"
L["Dock on Top"] = "Dock 置頂"
L["Preview"] = "預覽"

-- options/dock/general.lua
L["Custom Font Size"] = "自訂字體大小"
L["Font Size"] = "字體大小"

-- options/dock/volume.lua
L["Colored Text"] = "彩色文字"

-- options/misc/details.lua
L["Adds a button to show or hide details on click. The button is only visible on mouse over."] = "新增一個按鈕以點擊顯示或隱藏 Details。按鈕僅在滑鼠懸停時可見。"
L["Details embeded"] = "嵌入式 Details"
L["Details Windows"] = "Details 視窗"
L["Embedded Settings"] = "嵌入設定"
L["Embedded to Chat"] = "嵌入至聊天"
L["Left Chat"] = "左側聊天"
L["Right Chat"] = "右側聊天"
L["Toggle Button"] = "切換按鈕"

-- options/misc/dice_button.lua
L["Color Hover"] = "懸停顏色"
L["Color Normal"] = "一般顏色"
L["Custom color"] = "自訂顏色"
L["Hover Color Style"] = "懸停顏色樣式"
L["Hover Custom Color"] = "自訂懸停顏色"
L["Left Click"] = "左鍵點擊"
L["Right Click"] = "右鍵點擊"

-- options/misc/auto_role_check.lua
L["Auto Role Check"] = "自動角色確認"
L["Automatically accepts the dungeon or raid role check popup."] = "自動接受地城或團隊的角色確認彈出視窗。"
L["Lets you sign up for premade groups with a single click and confirms the application dialog automatically."] = "只需點一下即可申請預組隊伍，並自動確認申請對話框。"
L["One-Click Sign Up"] = "一鍵申請"

-- options/misc/death_counter.lua
L["Death Counter"] = "死亡計數器"
L["Font size"] = "字體大小"
L["Shows deaths and lost time in the current Mythic+ run."] = "顯示目前傳奇鑰石地城中的死亡次數和損失的時間。"

-- options/misc/difficulty_info.lua
L["LEFT"] = "左"
L["RIGHT"] = "右"

-- options/misc/phase_icon.lua
L["Phasing"] = "位面"
L["Sharding"] = "分流"

-- options/misc/ready_check_icon.lua
L["Not Ready"] = "未準備"
L["Waiting"] = "等待中"

-- options/misc/summon_icon.lua
L["Accepted"] = "已接受"
L["Available"] = "可用"
L["Rejected"] = "已拒絕"

-- options/misc/tags.lua
L["Moon"] = "月亮"

-- options/options_core.lua
L["About"] = "關於"
L["Custom Docks"] = "自訂 Dock"
L["Example"] = "範例"
L["Individual Professions"] = "個別專業"
L["Keystone to Chat"] = "鑰石分享到聊天"
L["License"] = "授權"
L["Nameplates"] = "姓名板"
L["Notification"] = "通知"
L["Open Settings"] = "開啟設定"
L["Phase Icon"] = "位面圖示"
L["Portraits"] = "頭像"
L["Professions"] = "專業"
L["Ready Check Icons"] = "準備確認圖示"
L["Unitframes"] = "單位框架"
L["Objective Tracker"] = "任務追蹤"
L["Classification Textures"] = "分類材質"
L["Unitframe Textures"] = "單位框架材質"
L["Addon Manager"] = "插件管理器"

-- options/portraits/portraits.lua
L["Anchor Point"] = "錨點"
L["Arena"] = "競技場"
L["Background color shift"] = "背景顏色偏移"
L["Cast Icon"] = "施法圖示"
L["Class colored"] = "職業著色"
L["Custom Textures"] = "自訂材質"
L["Death"] = "死亡"
L["Enable"] = "啟用"
L["Enable Class colored Background"] = "啟用職業顏色背景"
L["Focus"] = "焦點"
L["Frame Level"] = "框架層級"
L["Frame Strata"] = "框架層次"
L["Mask"] = "遮罩"
L["Party"] = "隊伍"
L["Pet"] = "寵物"
L["Player"] = "玩家"
L["Reaction"] = "反應"
L["Shadow"] = "陰影"
L["Target"] = "目標"
L["Target of Target"] = "目標的目標"
L["Border Alpha"] = "邊框透明度"
L["Cast"] = "施法"
L["Clockwise"] = "順時針"
L["Edge Softness"] = "邊緣柔和度"
L["Fills the ring clockwise, counter-clockwise when disabled."] = "以順時針方向填滿圓環，停用時為逆時針。"
L["Filter mode for the portrait textures. Trilinear also samples mipmaps, nearest disables smoothing. The unit portrait itself is not affected."] = "頭像材質的過濾模式。三線性也會取樣多級紋理，最近點會關閉平滑。單位頭像本身不受影響。"
L["Nearest"] = "最近點"
L["Opacity of the portrait border below the ring."] = "圓環下方頭像邊框的透明度。"
L["Reverse Fill"] = "反向填充"
L["Ring"] = "圓環"
L["Ring Alpha"] = "圓環透明度"
L["Shows health or the cast as a radial fill on the portrait border."] = "在頭像邊框上以徑向填充顯示生命值或施法。"
L["Softens the edge of the radial fill."] = "柔化徑向填充的邊緣。"
L["Start Point"] = "起點"
L["Texture Filter"] = "材質過濾"
L["The ring fills with the missing health instead of draining, so it stays empty at full health."] = "圓環依損失的生命值填充而非逐漸減少，因此滿血時為空。"
L["Trilinear"] = "三線性"
L["Where the fill starts, 0 is the twelve o'clock position."] = "填充的起始位置，0 為十二點鐘方向。"

-- options/skin/data_panel_skin.lua
L["Alpha"] = "透明度"
L["Change Texture"] = "更改材質"
L["Dark Class"] = "深色職業"
L["Delete all Settings"] = "刪除所有設定"
L["Disable"] = "停用"
L["Export"] = "匯出"
L["Import"] = "匯入"
L["Import/ Export of this Settings"] = "此設定的匯入/匯出"
L["Info: The Skin can be affected by other addons if they add a skin for all windows. To fix the problem, the skin must be deactivated in the other addon. This is not a bug of mMT."] = "資訊：如果其他插件為所有視窗新增皮膚，此皮膚可能會受到影響。要修正此問題，必須在其他插件中停用該皮膚。這不是 mMT 的錯誤。"
L["Output/ Input"] = "輸出/輸入"
L["Panels"] = "面板"
L["Reset"] = "重設"

-- media/media.lua
L["Octagon"] = "八角形"

-- Shared / multiple files
L["+"] = "+"
L["AFK"] = "AFK"
L["Anchor"] = "錨點"
L["Apply"] = "套用"
L["B"] = "B"
L["Background"] = "背景"
L["Bags"] = "背包"
L["Border"] = "邊框"
L["Boss"] = "首領"
L["Calendar"] = "日曆"
L["CENTER"] = "中央"
L["Changelog"] = "更新日誌"
L["Circle"] = "圓形"
L["Class"] = "職業"
L["Classification"] = "分類"
L["Color"] = "顏色"
L["Color Style"] = "顏色樣式"
L["Colors"] = "顏色"
L["Combat/Arena Time"] = "戰鬥/競技場時間"
L["Custom"] = "自訂"
L["Dead"] = "死亡"
L["Default"] = "預設"
L["Diamond"] = "菱形"
L["Difficulty:"] = "難度："
L["DND"] = "DND"
L["Dock"] = "Dock"
L["DPS"] = "DPS"
L["Dungeon"] = "地城"
L["Elite"] = "精英"
L["Favorites"] = "最愛"
L["Font"] = "字體"
L["Font contour"] = "字體輪廓"
L["Friends"] = "好友"
L["General"] = "一般"
L["Ghost"] = "靈魂"
L["Guild"] = "公會"
L["Healer"] = "治療"
L["Health"] = "生命值"
L["Housing"] = "住房"
L["Icon"] = "圖示"
L["Icon Size"] = "圖示大小"
L["Icons"] = "圖示"
L["Keystone"] = "鑰石"
L["Keystones on your Account"] = "你帳號上的鑰石"
L["left click to open Character Frame"] = "左鍵點擊開啟角色面板"
L["left click to open LFD Frame"] = "左鍵點擊開啟地下城搜尋器面板"
L["Level"] = "等級"
L["LFG Invite Info"] = "LFG 邀請資訊"
L["M+ Score"] = "M+ 分數"
L["Misc"] = "雜項"
L["Miscellaneous"] = "其他"
L["My Info"] = "我的資訊"
L["Mythic"] = "傳奇"
L["Mythic+"] = "傳奇+"
L["No Professions"] = "沒有專業"
L["None"] = "無"
L["Normal"] = "普通"
L["Offline"] = "離線"
L["Power"] = "資源"
L["R"] = "R"
L["R+"] = "R+"
L["Raid"] = "團隊副本"
L["Rare"] = "稀有"
L["Rare Elite"] = "稀有精英"
L["Ready"] = "已準備"
L["Repair Mount"] = "修理坐騎"
L["Returns a PvP icon if the unit is flagged for PvP and belongs to either the Horde or Alliance faction."] = "如果單位已標記為 PvP 且屬於部落或聯盟陣營，則回傳 PvP 圖示。"
L["Returns a quest icon if the unit is a quest mob."] = "如果單位是任務怪，則回傳任務圖示。"
L["Returns the class icon of the unit. You can specify a size between 16 and 128 (default is 64). Example: mClassIcon:style{32}"] = "回傳單位的職業圖示。你可以指定 16 到 128 之間的大小（預設為 64）。例如：mClassIcon:style{32}"
L["Returns the current power percent of the unit, but only while in combat."] = "回傳單位目前資源百分比，但僅在戰鬥中顯示。"
L["Returns the faction icon of the unit (Horde or Alliance), but only if it's the opposite faction of the player."] = "回傳單位的陣營圖示（部落或聯盟），但僅當其為玩家敵對陣營時顯示。"
L["Returns the faction icon of the unit (Horde or Alliance)."] = "回傳單位的陣營圖示（部落或聯盟）。"
L["Returns the faction of the unit (Horde or Alliance), but only if it's the opposite faction of the player."] = "回傳單位的陣營（部落或聯盟），但僅當其為玩家敵對陣營時顯示。"
L["Returns the faction of the unit (Horde or Alliance)."] = "回傳單位的陣營（部落或聯盟）。"
L["Returns the level of the unit. If the unit is at max level or the same level as you, it will return nothing. If the player is resting, it will return a Zzz."] = "回傳單位等級。如果單位為滿級或與你同級，則不顯示任何內容。如果玩家正在休息，則顯示 Zzz。"
L["Returns the level of the unit. If the unit is at max level. If the player is resting, it will return a Zzz."] = "回傳單位等級。如果單位為滿級，則不顯示任何內容。如果玩家正在休息，則顯示 Zzz。"
L["Returns the role icon of the unit (Tank, Healer, DPS)."] = "回傳單位角色圖示（坦克、治療、DPS）。"
L["Returns the role of the unit (Tank, Healer, DPS)."] = "回傳單位角色（坦克、治療、DPS）。"
L["Returns the status icon of the unit (AFK, DND, Offline, Dead, Ghost)."] = "回傳單位狀態圖示（AFK、DND、離線、死亡、靈魂）。"
L["Returns the status of the unit (AFK, DND, Offline, Dead, Ghost)."] = "回傳單位狀態（AFK、DND、離線、死亡、靈魂）。"
L["right click to open Great Vault"] = "右鍵點擊開啟寶庫"
L["right click to use:"] = "右鍵點擊使用："
L["Role Icons"] = "角色圖示"
L["Settings"] = "設定"
L["SHIFT + right click to clear all saved keystones."] = "SHIFT + 右鍵點擊清除所有已儲存的鑰石。"
L["Short Version."] = "簡短版本。"
L["Show Icon"] = "顯示圖示"
L["Size"] = "大小"
L["Square"] = "方形"
L["Status"] = "狀態"
L["Style"] = "樣式"
L["Tank"] = "坦克"
L["Teleports"] = "傳送"
L["Text"] = "文字"
L["Texture"] = "材質"
L["Tooltip"] = "提示資訊"
L["Toys"] = "玩具"
L["Volume"] = "音量"
L["X offset"] = "X 偏移"
L["Y offset"] = "Y 偏移"
L["Time"] = "時間"

-- core/addoncompartment.lua
L["SHIFT + Click"] = "SHIFT + 點擊"
L["for debug mode."] = "用於除錯模式。"

-- core/cmd.lua
L["Added dev GUID:"] = "已新增開發者 GUID："
L["Available commands:"] = "可用指令："
L["DEV mode active"] = "DEV 模式已啟用"
L["GUID:"] = "GUID："
L["Lua errors off."] = "Lua 錯誤已關閉。"
L["Show the current version"] = "顯示目前版本"
L["Show this help message"] = "顯示此幫助訊息"
L["Show your player GUID"] = "顯示你的玩家 GUID"
L["Toggle debug mode"] = "切換除錯模式"
L["Toggle debug mode with safe addons"] = "搭配安全插件切換除錯模式"
L["Unable to detect player GUID."] = "無法偵測玩家 GUID。"
L["unknown"] = "未知"
L["unknownIDS cleared."] = "unknownIDS 已清除。"
L["Version:"] = "版本："
L["Clear collected unknown IDs"] = "清除已收集的未知 ID"
L["Developer commands:"] = "開發者指令："
L["Enable function profiling (DEV only)"] = "啟用函式效能分析（僅限 DEV）"
L["FunctionProfiler is not loaded."] = "FunctionProfiler 未載入。"
L["Profiling already active."] = "效能分析已啟用。"
L["Profiling enabled, functions wrapped:"] = "效能分析已啟用，已包裝函式數："
L["Profiling is only available in DEV mode."] = "效能分析僅在 DEV 模式下可用。"
L["Register this character as developer"] = "將此角色登錄為開發者"

-- core/functions.lua
L["!! ERROR - Round:"] = "!! 錯誤 - 回合："
L["AddOn Memory:"] = "插件記憶體："
L["CPU overall:"] = "CPU 總計："
L["CPU peak:"] = "CPU 峰值："
L["Memory/ CPU usage:"] = "記憶體/CPU 使用量："

-- core/retail.lua
L["No current Mythic+ affixes found."] = "找不到目前的傳奇+詞綴。"

-- media/media.lua
L["Blizzard Portrait"] = "暴雪頭像"
L["Blizzard Portrait v2"] = "暴雪頭像 v2"
L["Blizzard Portrait v3"] = "暴雪頭像 v3"
L["Blizzard Portrait v4"] = "暴雪頭像 v4"
L["Cardinal v1"] = "Cardinal v1"
L["Cardinal v2"] = "Cardinal v2"
L["Cardinal v3"] = "Cardinal v3"
L["Cardinal v4"] = "Cardinal v4"
L["Cardinal v5"] = "Cardinal v5"
L["Cardinal v6"] = "Cardinal v6"
L["Cardinal v7"] = "Cardinal v7"
L["Hexagon"] = "六邊形"
L["Parallelogram"] = "平行四邊形"
L["Parallelogram v2"] = "平行四邊形 v2"
L["Parallelogram v3"] = "平行四邊形 v3"
L["Square Rounded"] = "圓角方形"
L["Window"] = "視窗"
L["Zigzag"] = "鋸齒"
L["Zigzag v2"] = "鋸齒 v2"

-- modules/datatexts/info_score.lua
L["middle click to open M+ Frame"] = "中鍵點擊開啟 M+ 視窗"

-- modules/misc/dice_button.lua
L["Dice Button"] = "骰子按鈕"

-- options/cast/important_casts.lua
L["Disabled"] = "已停用"
L["Enabled"] = "已啟用"

-- options/cast/interrupt_on_cd.lua
L["Background Multiplier"] = "背景倍率"
L["Change BG color"] = "更改背景顏色"
L["Enable to change the background color of the castbar."] = "啟用以更改施法條背景顏色。"
L["Marker"] = "標記"
L["On CD"] = "冷卻中"
L["Set the background color multiplier for the castbar."] = "設定施法條背景顏色倍率。"
L["The marker color for in time interrupts."] = "用於及時打斷的標記顏色。"

-- options/colors_difficulty.lua
L["Delve"] = "探究"
L["Follower"] = "追隨者"
L["H"] = "H"
L["Heroic"] = "英雄"
L["LFR"] = "團隊搜尋器"
L["M"] = "M"
L["M+"] = "M+"
L["N"] = "N"
L["PVP"] = "PVP"
L["Quest"] = "任務"
L["SC"] = "SC"
L["Scenario"] = "情境戰役"
L["Story"] = "劇情"
L["TW"] = "TW"
L["Timewalking"] = "時光漫遊"

-- options/colors_tip_menu.lua
L["Mark"] = "標記"
L["Tip"] = "提示"

-- options/datatext/datatexts.lua
L["Change Colors"] = "更改顏色"
L["Override Text Color"] = "覆蓋文字顏色"
L["Override Value Color"] = "覆蓋數值顏色"
L["Text Color"] = "文字顏色"
L["These colors are used for the tooltips of the datatexts."] = "這些顏色用於資料文字的提示資訊。"
L["colors"] = "顏色"

-- options/datatext/info_combat_time.lua
L["Hide delay"] = "隱藏延遲"
L["In Combat"] = "戰鬥中"
L["Out of Combat"] = "脫離戰鬥"

-- options/datatext/info_durability_itemlevel.lua
L["Force withe Text"] = "強制白色文字"
L["Repair Threshold"] = "修理閾值"
L["Threshold value for the repair color, if this is active then you should repair your gear."] = "修理顏色的閾值。如果啟用，代表你應該修理裝備。"
L["Threshold value for the repair color, if this is active, you should repair your equipment soon."] = "修理顏色的閾值。如果啟用，代表你應該盡快修理裝備。"
L["Warning colors"] = "警告顏色"
L["Warning Threshold"] = "警告閾值"

-- options/datatext/info_score.lua
L["Keystone level"] = "鑰石等級"
L["Score"] = "分數"
L["Show Party Keystones"] = "顯示隊伍鑰石"
L["Show Upgrades"] = "顯示升級"
L["Sort method"] = "排序方式"

-- options/datatext/misc_dungeon.lua
L["Change Text to Dungeon Name."] = "將文字改為地城名稱。"

-- options/datatext/misc_gamemenu.lua
L["Menu Text color"] = "選單文字顏色"
L["Show Menu Icons"] = "顯示選單圖示"
L["Show Systeminfo"] = "顯示系統資訊"
L["colored"] = "已著色"

-- options/datatext/misc_individual_professions.lua
L["Colored"] = "已著色"
L["Icon Style"] = "圖示樣式"

-- options/datatext/misc_professions.lua
L["Menu Icons"] = "選單圖示"
L["Profession Icon Style"] = "專業圖示樣式"
L["Tooltip Icons"] = "提示資訊圖示"

-- options/datatext/misc_teleports.lua
L["Current Dungeon"] = "目前地城"
L["Highlight"] = "醒目提示"
L["Highlights the dungeon of your own keystone."] = "醒目提示你自己鑰石的地城。"
L["Highlights the dungeon you are listed for, joined or currently in."] = "醒目提示你已登記、已加入或目前所在的地城。"
L["My Keystone"] = "我的鑰石"
L["Slot"] = "欄位"

-- options/datatext/misc_tracker.lua
L["!!Error - this is not an ID."] = "!!錯誤 - 這不是 ID。"
L["Add Currency or Item ID"] = "新增貨幣或物品 ID"
L["Color the text"] = "為文字著色"
L["Custom IDs"] = "自訂 ID"
L["Enter a Currency or Item it accepts only Numbers."] = "輸入貨幣或物品，只接受數字。"
L["Here you can add custom IDs for the tracker. You can add currencies or items. This will add DataTexts for each ID to ElvUI."] = "你可以在這裡為追蹤器新增自訂 ID。你可以新增貨幣或物品。這將為每個 ID 新增對應的 ElvUI 資料文字。"
L["Is Currency"] = "是否為貨幣"
L["Short large numbers"] = "縮寫大數字"
L["Show Name"] = "顯示名稱"
L["Show max amount"] = "顯示最大數量"

-- options/dock/common
L["Custom Color"] = "自訂顏色"
L["Use a custom color for the icon."] = "為圖示使用自訂顏色。"

-- options/dock/bags.lua
L["Free Slots"] = "空閒欄位"
L["Gold Infos"] = "金幣資訊"
L["Money"] = "金錢"
L["Money / Free Slots"] = "金錢 / 空閒欄位"
L["Show gold infos instead of bag slots in the tooltip."] = "在提示資訊中顯示金幣資訊而非背包欄位。"
L["Used / Total Slots"] = "已用 / 總欄位"
L["Used Slots"] = "已用欄位"

-- options/dock/character.lua
L["Show durability percentage as text."] = "以文字顯示耐久度百分比。"
L["Threshold"] = "閾值"

-- options/dock/durability.lua
L["Durability / Item level"] = "耐久度 / 物品等級"
L["Item level"] = "物品等級"

-- options/dock/example.lua
L["Dock V2"] = "Dock V2"
L["MAUI"] = "MAUI"
L["XIV Like"] = "類似 XIV"
L["XVI Like colored"] = "類似 XVI（彩色）"

-- options/dock/friends.lua
L["Show number of online friends on the icon."] = "在圖示上顯示在線好友數量。"

-- options/dock/general.lua
L["Auto grow"] = "自動放大"
L["Automatically adjust the growth size based on the icon size. When you hover over the icon."] = "當滑鼠懸停於圖示上時，依據圖示大小自動調整放大尺寸。"
L["Class Color"] = "職業顏色"
L["Clicked"] = "點擊"
L["Font Color"] = "字體顏色"
L["Font Outline"] = "字體外框"
L["Growth size"] = "放大大小"
L["Hover"] = "懸停"
L["Set the clicked color of the icon."] = "設定圖示被點擊時的顏色。"
L["Set the font for dock text."] = "設定 Dock 文字字體。"
L["Set the font outline for dock text."] = "設定 Dock 文字字體外框。"
L["Set the font size for dock text."] = "設定 Dock 文字字體大小。"
L["Set the growth size of the dock icon. This is the distance between the icons."] = "設定 Dock 圖示的放大大小。這也是圖示之間的距離。"
L["Set the hover color of the icon."] = "設定圖示懸停顏色。"
L["Set the normal color of the icon."] = "設定圖示一般顏色。"
L["Show a tooltip when you hover over the icon."] = "滑鼠懸停在圖示上時顯示提示資訊。"
L["Use a custom color for dock text. If disabled, the font color will be class colored."] = "為 Dock 文字使用自訂顏色。若停用，字體顏色將使用職業顏色。"
L["Use a custom font size for dock text. If disabled, the font size will be set to one third of the icon size."] = "為 Dock 文字使用自訂字體大小。若停用，字體大小將設為圖示大小的三分之一。"
L["Use class color for the icon."] = "為圖示使用職業顏色。"

-- options/dock/guild.lua
L["Show number of online Guild members on the icon."] = "在圖示上顯示在線公會成員數量。"

-- options/dock/lfd.lua
L["Call to the arms"] = "戰鬥的號角"
L["Show difficulty or call to the arms on the icon."] = "在圖示上顯示難度或戰鬥的號角。"
L["Show icons for call to the arms."] = "顯示戰鬥的號角圖示。"

-- options/dock/notification.lua
L["Auto size"] = "自動大小"
L["ClassColor"] = "職業顏色"

-- options/dock/volume.lua
L["Color the text with the ElvUI color."] = "使用 ElvUI 顏色為文字著色。"

-- options/misc/auto_quest.lua
L["Auto Accept"] = "自動接受"
L["Auto Quest"] = "自動任務"
L["Auto Turn-In"] = "自動交付"
L["Automatically accepts quest dialogs from NPCs."] = "自動接受 NPC 的任務對話。"
L["Automatically turns in completed quests. If the quest has multiple reward choices, the dialog stays open for you to choose."] = "自動交付已完成任務。如果任務有多個獎勵選項，對話框將保持開啟讓你選擇。"
L["Chat Messages"] = "聊天訊息"
L["Disables auto accept/turn-in while you are in combat."] = "當你處於戰鬥中時停用自動接受/交付。"
L["Prints a message to chat whenever a quest is auto-accepted or turned in, or a gossip option is selected."] = "每當任務自動接受或交付時，在聊天中輸出訊息。"
L["Skip in Combat"] = "戰鬥中跳過"
L["Auto Gossip"] = "自動對話"
L["Automatically clicks gossip options of the types selected below. If more than one option matches, the dialog stays open for you to choose."] = "自動點選下方所選類型的對話選項。若有多個選項符合，對話框會保持開啟讓你選擇。"
L["Cinematic Options"] = "過場動畫選項"
L["Quest Options"] = "任務選項"
L["Selects gossip options that are marked with the (Quest) label."] = "選擇帶有（任務）標籤的對話選項。"
L["Selects gossip options that start a cinematic."] = "選擇會播放過場動畫的對話選項。"
L["Selects the option when an NPC offers only a single one. This also triggers on vendors, flight masters and trainers."] = "當 NPC 只提供一個選項時自動選擇它。對商人、飛行管理員與訓練師同樣有效。"
L["Single Option"] = "單一選項"

-- options/misc/difficulty_info.lua
L["Alignment"] = "對齊"
L["Difficulty Info"] = "難度資訊"
L["Font size, top line"] = "字體大小，上行"
L["Show Frame"] = "顯示框架"

-- options/misc/greeting_message.lua
L["Show a greeting message in the chat when you log in."] = "登入時在聊天中顯示歡迎訊息。"

-- options/misc/keystone_to_chat.lua
L["Post your keystone to the chat when someone types !key or !keys into the chat."] = "當有人在聊天中輸入 !key 或 !keys 時，將你的鑰石發送到聊天。"

-- options/misc/lfg_invite_info.lua
L["Class (accent line)"] = "職業（強調線）"
L["Embed icon"] = "嵌入圖示"
L["Fade out delay"] = "淡出延遲"
L["First line color"] = "第一行顏色"
L["Font size, bottom line"] = "字體大小，下行"
L["Minimal (text only)"] = "極簡（僅文字）"
L["Second line color"] = "第二行顏色"
L["Show in chat"] = "在聊天中顯示"
L["Shows the icon inside the window instead of next to it. Requires the background to be enabled."] = "在視窗內顯示圖示，而不是在視窗旁邊。需要啟用背景。"
L["Theme"] = "主題"
L["Third line color"] = "第三行顏色"
L["Animation"] = "動畫"
L["Custom (frame)"] = "自訂（邊框）"
L["Fade"] = "淡入淡出"
L["Scale"] = "縮放"
L["Slide"] = "滑動"
L["Theme color"] = "主題顏色"

-- options/misc/phase_icon.lua
L["Chromie Time"] = "克羅米的時間"
L["Timerunning World"] = "時光奔流世界"
L["War Mode"] = "戰爭模式"

-- options/misc/tags.lua
L["DC/ Offline"] = "斷線 / 離線"
L["PvP"] = "PvP"

-- options/misc/tooltip.lua
L["Icon Zoom"] = "圖示縮放"

-- options/nameplates/shared
L["Border color"] = "邊框顏色"
L["Health color"] = "生命值顏色"
L["Ignore threat color"] = "忽略仇恨顏色"

-- options/nameplates/nameplate_tools.lua
L["ElvUI Color Settings"] = "ElvUI 顏色設定"
L["Open the ElvUI color settings to adjust the colors used for nameplates."] = "開啟 ElvUI 顏色設定以調整姓名板所使用的顏色。"
L["Sets automatically your class color for glow and border color on nameplates for the target unit."] = "自動將你的職業顏色套用到目標單位姓名板的發光與邊框顏色。"
L["Target & Glow color"] = "目標與發光顏色"
L["Heal and absorb textures for nameplates are configured together with the unitframe textures."] = "姓名板的治療與吸收材質與單位框架材質一起設定。"
L["Open the mMediaTag unitframe texture settings."] = "開啟 mMediaTag 單位框架材質設定。"

-- options/options_core.lua
L["Data Panel Skin"] = "資料面板皮膚"
L["Datatexts"] = "資料文字"
L["Details embedded"] = "嵌入式 Details"
L["Difficulty"] = "難度"
L["Durability & Item Level"] = "耐久度與物品等級"
L["Focus Highlight"] = "焦點高亮"
L["Gamemenu"] = "遊戲選單"
L["Greeting Message"] = "歡迎訊息"
L["In WoW Classic, the docks may appear differently because not all modules are available in this version. However, you can still customize the docks through the ElvUI settings."] = "在魔獸世界經典版中，由於此版本並非所有模組都可用，Dock 的顯示可能會有所不同。不過你仍可透過 ElvUI 設定自訂 Dock。"
L["Interrupt On CD"] = "打斷冷卻中"
L["Minimap Skin"] = "小地圖皮膚"
L["Quest Highlight"] = "任務高亮"
L["Resurrection Icon"] = "復活圖示"
L["Summon Icon"] = "召喚圖示"
L["TAGs"] = "標籤"
L["Target Highlight"] = "目標高亮"
L["Tip/ Menu"] = "提示 / 選單"
L["Tracker"] = "追蹤器"

-- options/portraits/portraits.lua
L["BG"] = "背景"
L["BG Style"] = "背景樣式"
L["Choose the background style for the transparent Class icons."] = "為透明職業圖示選擇背景樣式。"
L["Class icon"] = "職業圖示"
L["Custom Extra Texture"] = "自訂額外材質"
L["Death Knight"] = "死亡騎士"
L["Demon Hunter"] = "惡魔獵人"
L["Desaturate"] = "去飽和"
L["Druid"] = "德魯伊"
L["Embellishment"] = "裝飾"
L["Enable Custom Textures for Portrait."] = "為頭像啟用自訂材質。"
L["Enable Cast Icons."] = "啟用施法圖示。"
L["Enable Custom extra Textures for Portrait."] = "為頭像啟用自訂額外材質。"
L["Enable and select a class icon style for the portrait."] = "啟用並選擇頭像的職業圖示樣式。"
L["Enable and select a spec icon style for the portrait."] = "啟用並選擇頭像的專精圖示樣式。"
L["Enable Extra Texture"] = "啟用額外材質"
L["Enable the Shadow for the Portraits."] = "為頭像啟用陰影。"
L["Enable the Unit Portrait."] = "啟用單位頭像。"
L["Enable this to show the Extra Texture on top of the Unit Portrait."] = "啟用此項目以在單位頭像上方顯示額外材質。"
L["Enable custom Position and size settings for Extra Texture."] = "為額外材質啟用自訂位置與大小設定。"
L["Enemy"] = "敵方"
L["Evoker"] = "喚能師"
L["Extra"] = "額外"
L["Extra Mask"] = "額外遮罩"
L["Extra Settings"] = "額外設定"
L["Extra Shadow"] = "額外陰影"
L["Force Extra Texture"] = "強制額外材質"
L["Forces the default color for all texture."] = "強制所有材質使用預設顏色。"
L["Frame Level/ Strata"] = "框架層級 / 層次"
L["Friendly"] = "友方"
L["Hunter"] = "獵人"
L["It will override the default extra texture, but will take care of rare/elite/boss units."] = "這會覆蓋預設額外材質，但仍會處理稀有/精英/首領單位。"
L["Mage"] = "法師"
L["Monk"] = "武僧"
L["Neutral"] = "中立"
L["On Top"] = "置頂"
L["Paladin"] = "聖騎士"
L["Portrait Scale"] = "頭像縮放"
L["Priest"] = "牧師"
L["Put your custom textures in the Addon folder and add the path here (example MyMediaFolder\\MyTexture.tga)."] = "將你的自訂材質放入插件資料夾，並在這裡填入路徑（例如 MyMediaFolder\\MyTexture.tga）。"
L["Reset all colors"] = "重設所有顏色"
L["Reset class colors"] = "重設職業顏色"
L["Rogue"] = "盜賊"
L["Select a extra texture style for boss units."] = "為首領單位選擇額外材質樣式。"
L["Select a extra texture style for elite units."] = "為精英單位選擇額外材質樣式。"
L["Select a extra texture style for player."] = "為玩家選擇額外材質樣式。"
L["Select a extra texture style for rare elite units."] = "為稀有精英單位選擇額外材質樣式。"
L["Select a extra texture style for rare units."] = "為稀有單位選擇額外材質樣式。"
L["Select a portrait texture style."] = "選擇頭像材質樣式。"
L["Shadow Alpha"] = "陰影透明度"
L["Shaman"] = "薩滿"
L["Shows the Extra Texture (rare/elite) for the Unit Portrait."] = "為單位頭像顯示額外材質（稀有/精英）。"
L["Texture Style settings for Extra texture (Rare/Elite/Boss/player)."] = "額外材質（稀有/精英/首領/玩家）的材質樣式設定。"
L["Texture Styles"] = "材質樣式"
L["TIP: If you use the Blizzard textures and change the classification color to white, you will see the extra texture with the original colors."] = "提示：如果你使用暴雪材質並將分類顏色改為白色，將會看到保留原始顏色的額外材質。"
L["Unitcolor for Extra"] = "額外層使用單位顏色"
L["Use Default color"] = "使用預設顏色"
L["Spec icons"] = "專精圖示"
L["Use the unit color for the Extra (Rare/Elite) Texture."] = "額外（稀有/精英）材質使用單位顏色。"
L["Warlock"] = "術士"
L["Warrior"] = "戰士"
L["Will always desaturate the portraits."] = "將始終對頭像去飽和。"
L["Will show the embellishment on the portraits, if the Style has an embellishment."] = "如果樣式有裝飾，則會在頭像上顯示裝飾。"

-- options/skin/data_panel_skin.lua
L["Delete the actual Settings"] = "刪除目前設定"
L["Info: This Settings will override the ElvUI Data Panel settings."] = "資訊：這些設定將覆蓋 ElvUI 資料面板設定。"
L["Reset all"] = "全部重設"

-- options/skin/minimap.lua
L["Cardinal Icon"] = "Cardinal 圖示"

-- options/datatext/misc_gamemenu.lua
L["white"] = "白色"

-- options/options_core.lua
L["These are just examples of how to create your own dock using ElvUI’s custom data text bars.\n\nTo set up a custom bar:\nOpen ElvUI and navigate to ElvUI > Datatext > Bars.\nEnter a name for your new bar, click OK, and then click Add.\nSet the width of the bar based on how many icons you want to display.\nSet the height, which also determines the icon size.\nChoose the number of data text slots you want.\n\nAssign icons to each slot. For example:\nSlot 1 = Dock Calendar\nSlot 2 = Dock Profession\nSlot 3 = Dock Spec\n…and so on.\n\nThis setup allows you to build a personalized dock that fits your UI and gameplay needs.\n\n"] = "這些只是如何使用 ElvUI 自訂資料文字列來建立你自己的 Dock 的範例。\n\n要設定自訂列：\n開啟 ElvUI，然後前往 ElvUI > Datatext > Bars。\n為你的新列輸入名稱，點擊 OK，然後點擊 Add。\n根據你想顯示的圖示數量設定列寬。\n設定高度，這也會決定圖示大小。\n選擇你想要的資料文字欄位數量。\n\n為每個欄位指派圖示。例如：\n欄位 1 = Dock Calendar\n欄位 2 = Dock Profession\n欄位 3 = Dock Spec\n……依此類推。\n\n此設定可讓你建立符合你的介面與遊戲需求的個人化 Dock。\n\n"

-- modules/portraits/texture_db.lua
L["Antik"] = "古典"
L["BG 1"] = "背景 1"
L["BG 2"] = "背景 2"
L["BG 3"] = "背景 3"
L["BG 4"] = "背景 4"
L["BG 5"] = "背景 5"
L["BG 6"] = "背景 6"
L["Blizzard Boss"] = "暴雪首領"
L["Blizzard Boss Neutral"] = "暴雪首領（中立）"
L["Blizzard Elite"] = "暴雪精英"
L["Blizzard Rare"] = "暴雪稀有"
L["Blizzard Rare/ Elite Neutral"] = "暴雪稀有 / 精英（中立）"
L["Blizzard Round"] = "暴雪圓形"
L["Blizzard Round Thick"] = "暴雪粗圓形"
L["Blizzard Round UP"] = "暴雪上圓形"
L["Blizzard Round UP Thick"] = "暴雪上粗圓形"
L["Blizzard Sharp"] = "暴雪尖角"
L["Blizzard Sharp Thick"] = "暴雪粗尖角"
L["Blizzard Sharp UP"] = "暴雪上尖角"
L["Blizzard Sharp UP Thick"] = "暴雪上粗尖角"
L["Circle Thick"] = "粗圓形"
L["Climbing Plant"] = "攀爬植物"
L["Climbing Plant V2"] = "攀爬植物 V2"
L["Cookie"] = "餅乾"
L["Diamond Thick"] = "粗菱形"
L["Dog Any"] = "任意狗"
L["Dog Pack"] = "犬群"
L["Dog Pack color"] = "犬群彩色"
L["Dogs"] = "狗"
L["Dogs color"] = "狗彩色"
L["Dragon Blue"] = "藍龍"
L["Dragon Boss"] = "龍首領"
L["Dragon Elite"] = "龍精英"
L["Dragon Green"] = "綠龍"
L["Dragon Purple"] = "紫龍"
L["Leaf"] = "葉子"
L["Leaf Mirrored"] = "鏡像葉子"
L["Pad"] = "墊片"
L["Parallelogram Mirrored"] = "鏡像平行四邊形"
L["Pentagon"] = "五邊形"
L["Pixel"] = "像素"
L["Rectangular"] = "矩形"
L["Round - Leaf"] = "圓形 - 葉子"
L["Round - Monster"] = "圓形 - 怪物"
L["Round - Pulse"] = "圓形 - 脈衝"
L["Round - Star"] = "圓形 - 星星"
L["Round - Tech"] = "圓形 - 科技"
L["Round - Zickzack"] = "圓形 - 鋸齒"
L["Shield"] = "盾牌"
L["Snake"] = "蛇"
L["Snake Blue"] = "藍蛇"
L["Snake Green"] = "綠蛇"
L["Snake Purple"] = "紫蛇"
L["Snake Red"] = "紅蛇"
L["Space"] = "太空"
L["Space color"] = "太空彩色"
L["Square Leaf"] = "方形葉子"
L["Square Loop"] = "方形環"
L["Square Round"] = "圓角方形"
L["Square Round Thick"] = "粗圓角方形"
L["Square Spikes"] = "尖刺方形"
L["Square Stars"] = "星形方框"
L["Square Thick"] = "粗方形"
L["Tear"] = "淚滴"
L["Tear down"] = "向下淚滴"
L["Tear down Mirrored"] = "鏡像向下淚滴"
L["Tear Mirrored"] = "鏡像淚滴"
L["Trapezoid"] = "梯形"
L["Trapezoid Mirrored"] = "鏡像梯形"

-- modules/misc/addon_manager.lua
L["Addon profile saved:"] = "插件設定檔已儲存："
L["Addon Profiles"] = "插件設定檔"
L["Addons with disabled dependencies:"] = "相依項目被停用的插件："
L["All Characters"] = "所有角色"
L["Category"] = "類別"
L["Delete Profile"] = "刪除設定檔"
L["Filter"] = "篩選"
L["Name of the addon profile:"] = "插件設定檔名稱："
L["Protect ElvUI & mMT"] = "保護 ElvUI 與 mMT"
L["Save Current State"] = "儲存目前狀態"

-- options/datatext/info_time.lua
L["Clock"] = "時鐘"
L["Clock Icon"] = "時鐘圖示"
L["Combat Icon"] = "戰鬥圖示"
L["Switches to the combat time as soon as you enter combat."] = "進入戰鬥後立即切換為戰鬥時間。"
L["Time format and tooltip are taken from ElvUI's Time datatext."] = "時間格式與提示資訊取自 ElvUI 的時間資訊文字。"

-- options/misc/addon_manager.lua
L["Add a profile dropdown and a filter to Blizzard's addon list."] = "在暴雪插件清單中加入設定檔下拉選單與篩選器。"
L["Apply profiles account wide instead of only to the current character."] = "將設定檔套用到整個帳號，而不只是目前角色。"
L["Apply to all characters"] = "套用到所有角色"
L["Never disable ElvUI, its libraries and mMediaTag when a profile is applied."] = "套用設定檔時絕不停用 ElvUI、其函式庫與 mMediaTag。"
L["Protect ElvUI and mMediaTag"] = "保護 ElvUI 與 mMediaTag"
L["Save your enabled addons as a named set and switch between them from Blizzard's addon list."] = "將已啟用的插件儲存為具名組合，並在暴雪插件清單中切換。"

-- options/misc/prey_hunt.lua
L["Prey Hunt"] = "獵物狩獵"
L["Shows Ready in green once every hunt stage is done, the text is hidden otherwise."] = "所有狩獵階段完成後以綠色顯示「就緒」，否則隱藏文字。"
L["Shows the current hunt stage as text on the prey icon."] = "在獵物圖示上以文字顯示目前狩獵階段。"
L["Target List"] = "目標清單"
L["Mark Defeated Targets"] = "標記已擊敗的目標"
L["Colors prey targets you already defeated in the target list, based on the achievement criteria."] = "依據成就條件，在目標清單中為已擊敗的獵物上色。"

-- options/misc/unitframe_textures.lua
L["Background Texture"] = "背景材質"
L["Castbar"] = "施法條"
L["Absorb Shield"] = "吸收護盾"
L["Heal Absorb"] = "治療吸收"
L["Incoming Heal"] = "即將受到的治療"
L["Power Cost"] = "能量消耗"
L["Target of Target of Target"] = "目標的目標的目標"

-- options/nameplates/classification_texture.lua
L["Caster"] = "施法者"
L["Elite Boss"] = "菁英首領"
L["Elite Mini"] = "菁英小首領"
L["In Instances"] = "在副本中"
L["Inside a dungeon every mana user counts as a caster, so that texture wins over the elite ones there."] = "在地城中，所有使用法力的單位都算作施法者，因此該材質優先於菁英材質。"
L["Show the classification textures only inside dungeons, raids and other instances."] = "僅在地城、團隊副本與其他副本中顯示分類材質。"
L["World Boss"] = "世界首領"

-- options/nameplates/auto_friendly_nameplates.lua
L["Auto Friendly Nameplates"] = "自動友方姓名板"
L["Automatically shows friendly nameplates in dungeons and raids and hides them in the open world."] = "在地城與團隊副本中自動顯示友方姓名板，在野外隱藏。"
L["Dungeons"] = "地城"
L["Raids"] = "團隊副本"
L["Show friendly nameplates in dungeons."] = "在地城中顯示友方姓名板。"
L["Show friendly nameplates in raids."] = "在團隊副本中顯示友方姓名板。"

-- options/misc/objective_tracker.lua
L["Bad"] = "差"
L["Class Color Border"] = "職業顏色邊框"
L["Colors objectives like 3/5 by progress."] = "依進度為 3/5 這類目標上色。"
L["Complete"] = "已完成"
L["Font size, header"] = "字體大小，標題列"
L["Font size, text"] = "字體大小，文字"
L["Font size, title"] = "字體大小，標題"
L["Good"] = "好"
L["Gradient"] = "漸層"
L["Header"] = "標題列"
L["Header Bar"] = "標題條"
L["Hide Dash"] = "隱藏短橫線"
L["Progress"] = "進度"
L["Removes the dash in front of each objective."] = "移除每個目標前的短橫線。"
L["Some changes require a reload of the UI."] = "部分變更需要重新載入介面。"
L["Transition"] = "過渡"
L["Transparent"] = "透明"

-- options/nameplates/execute_marker.lua
L["Automatic range"] = "自動範圍"
L["Determines the execute range automatically based on your class, spec and talents."] = "依據你的職業、專精與天賦自動決定斬殺範圍。"
L["Execute Marker"] = "斬殺標記"
L["Execute range"] = "斬殺範圍"
L["Only in combat"] = "僅在戰鬥中"
L["Shows a marker on enemy nameplates at the execute threshold of your spec. Because of the Midnight API restrictions the marker is hidden via clipping once the unit drops below the threshold, health values are never read."] = "在敵方姓名板上標出你專精的斬殺門檻。由於至暗之夜的 API 限制，單位血量低於門檻後標記會以裁切方式隱藏，從不讀取生命值。"

-- modules/skin/bugsack.lua
L["Page:"] = "頁："

-- options/skin/auctionator.lua
L["Info: Auctionator is not installed."] = "資訊：未安裝 Auctionator。"
L["Info: This skins the Shopping, Selling, Cancelling and Auctionator tabs. Rows inside the result lists keep their default look."] = "資訊：為購買、出售、取消與 Auctionator 分頁套用外觀。結果清單中的列保持預設外觀。"

-- options/skin/bigwigs.lua
L["Custom Texture"] = "自訂材質"
L["Info: BigWigs is not installed."] = "資訊：未安裝 BigWigs。"
L["Info: The keystone window is the /key list, the queue timer is the bar below the dungeon invite popup. Boss bars keep their own BigWigs style."] = "資訊：鑰石視窗是 /key 清單，排隊計時器是地城邀請視窗下方的計時條。首領計時條保持 BigWigs 本身的樣式。"
L["Keystone Window"] = "鑰石視窗"
L["Original"] = "原始"
L["Queue Timer Bar"] = "排隊計時條"

-- options/skin/aussyloot.lua
L["Value Color"] = "數值顏色"
L["Info: AussyLoot is not installed."] = "資訊：未安裝 AussyLoot。"
L["Info: This replaces AussyLoot's own surface, border and accent colors with the ElvUI ones and its fonts with the ElvUI font. The window is rebuilt on the next reload, the item quality, crest and status colors keep their own meaning."] = "資訊：將 AussyLoot 本身的表面、邊框與強調色換成 ElvUI 的顏色，並將其字體換成 ElvUI 字體。視窗會在下次重新載入時重建，物品品質、紋章與狀態顏色保持原有含義。"

-- options/skin/premade_groups_filter.lua
L["Checkboxes"] = "核取方塊"
L["Info: Premade Groups Filter is not installed."] = "資訊：未安裝 Premade Groups Filter。"
L["Info: This skins the filter dialog, its panels, dropdowns and popups."] = "資訊：為篩選對話框及其面板、下拉選單與彈出視窗套用外觀。"

-- options/skin/bugsack.lua
L["Info: BugSack is not installed."] = "資訊：未安裝 BugSack。"
L["Shows the ElvUI, mMT and WoW version left of the page counter."] = "在頁碼左側顯示 ElvUI、mMT 與 WoW 的版本。"
L["Skins"] = "外觀"
L["Version Info"] = "版本資訊"

-- options/media_pack.lua
L["Choose which texture packs are registered. Loading fewer packs keeps the texture dropdowns short. Changes need a UI reload."] = "選擇要註冊的材質包。載入越少材質包，材質下拉選單越短。變更需要重新載入介面。"
L["Disable All"] = "全部停用"
L["Enable All"] = "全部啟用"
L["Load all texture packs"] = "載入所有材質包"
L["Media Pack"] = "Media Pack"
L["Overrides the individual packs below."] = "覆蓋下方的個別材質包設定。"
L["Texture Packs"] = "材質包"

-- modules/cooldownmanager
L["Essential Cooldowns"] = "核心冷卻"
L["Utility Cooldowns"] = "輔助冷卻"
L["Buff Icons"] = "增益圖示"
L["Buff Bars"] = "增益計時條"
L["Custom Tracker"] = "自訂追蹤"
L["Buff Name"] = "增益名稱"
L["Cooldown Manager"] = "冷卻管理器"
L["The cooldown manager needs Blizzards cooldown viewer. Enable it again under Options > Gameplay Enhancements."] = "冷卻管理器需要暴雪的冷卻顯示器。請在 選項 > 遊戲性增強 中重新啟用。"
L["Blizzards cooldown manager was enabled, a reload is needed."] = "暴雪冷卻管理器已啟用，需要重新載入介面。"
L["Glow Options"] = "發光選項"
L["Enable Glow"] = "啟用發光"
L["Type"] = "類型"
L["Speed"] = "速度"
L["Lines"] = "線條"
L["Thickness"] = "粗細"
L["Particles"] = "粒子"
L["Bar Colors"] = "計時條顏色"
L["Enable Custom Colors"] = "啟用自訂顏色"
L["Foreground"] = "前景"
L["Active State"] = "啟動狀態"
L["Mode"] = "模式"
L["Hide"] = "隱藏"
L["Customize"] = "自訂"
L["Swipe"] = "冷卻旋轉"
L["Keep"] = "保留"
L["Solid Color"] = "純色"
L["Swipe Color"] = "旋轉顏色"
L["Active Text Color"] = "啟動文字顏色"
L["Desaturate icon while active"] = "啟動時圖示去色"
L["The active text color applies only while the buff is running, afterwards the normal cooldown text returns."] = "啟動文字顏色僅在增益持續期間生效，之後恢復為一般冷卻文字。"

-- options/cooldownmanager/cooldown_manager.lua
L["Center"] = "置中"
L["Top"] = "上"
L["Bottom"] = "下"
L["Left"] = "左"
L["Right"] = "右"
L["Top Left"] = "左上"
L["Top Right"] = "右上"
L["Bottom Left"] = "左下"
L["Bottom Right"] = "右下"
L["Always"] = "總是"
L["In Group"] = "在隊伍中"
L["Player Fader"] = "玩家淡出"
L["Hidden"] = "隱藏"
L["Position"] = "位置"
L["X-Offset"] = "X 偏移"
L["Y-Offset"] = "Y 偏移"
L["Layout"] = "版面配置"
L["Keep Size Ratio"] = "保持尺寸比例"
L["Icon Width"] = "圖示寬度"
L["Icon Height"] = "圖示高度"
L["Spacing"] = "間距"
L["Icons Per Row"] = "每列圖示數"
L["Vertical Growth"] = "垂直延伸"
L["Down"] = "向下"
L["Up"] = "向上"
L["When to Show"] = "顯示時機"
L["Show Tooltips"] = "顯示提示資訊"
L["Show Keybind"] = "顯示按鍵綁定"
L["Visibility"] = "可見性"
L["Proc Glow"] = "觸發發光"
L["Cooldown Text"] = "冷卻文字"
L["Count Text"] = "層數文字"
L["Keybind Text"] = "按鍵綁定文字"
L["Moves Blizzards cooldown manager icons into mMT containers with own movers and text settings. Blizzards cooldown manager has to be enabled under Options > Gameplay Enhancements."] = "將暴雪冷卻管理器的圖示移入 mMT 容器，擁有獨立的移動錨點與文字設定。需要在 選項 > 遊戲性增強 中啟用暴雪冷卻管理器。"
L["Hide GCD Swipe"] = "隱藏公共冷卻旋轉"
L["Bar Width"] = "計時條寬度"
L["Bar Height"] = "計時條高度"
L["Icon Gap"] = "圖示間隙"
L["Mirrored Columns"] = "鏡像欄"
L["Column Gap"] = "欄間距"
L["Name Text"] = "名稱文字"
L["Duration Text"] = "持續時間文字"
L["Stacks Text"] = "堆疊文字"
L["Show Racials"] = "顯示種族技能"
L["Show Healthstone"] = "顯示治療石"
L["Show Healing Potions"] = "顯示治療藥水"
L["Show Combat Potions"] = "顯示戰鬥藥水"
L["Show Weyrnstone"] = "顯示 Weyrnstone"
L["Tracks the cooldown of the Weyrnstone while it is in your bags."] = "當 Weyrnstone 在背包中時追蹤其冷卻。"
L["Show Belt Tinker"] = "顯示腰帶工程改裝"
L["Trinkets"] = "飾品"
L["Both"] = "兩者"
L["Trinket 1"] = "飾品 1"
L["Trinket 2"] = "飾品 2"
L["On-Use Only"] = "僅限主動使用"
L["Hides passive and proc trinkets without an activatable cooldown."] = "隱藏沒有可啟動冷卻的被動與觸發型飾品。"
L["Growth Direction"] = "延伸方向"
L["Managed"] = "已接管"
L["Not Managed"] = "未接管"
L["Move this viewer into an mMT container. Turn it off to leave it to Blizzard and ElvUI."] = "將此顯示器移入 mMT 容器。關閉後交由暴雪與 ElvUI 處理。"
L["Opacity"] = "不透明度"
L["Show"] = "顯示"
L["Debuff Border"] = "減益邊框"
L["Keeps Blizzards colored border on harmful auras."] = "在有害光環上保留暴雪的彩色邊框。"
L["Bar Color"] = "計時條顏色"
L["Background Color"] = "背景顏色"
L["A single aura can override this with a right click in Blizzards cooldown manager."] = "可在暴雪冷卻管理器中右鍵點擊單一光環來覆蓋此設定。"
L["Pandemic"] = "Pandemic"
L["What to show while the aura is inside its refresh window."] = "光環位於刷新區間內時顯示的內容。"
L["Blizzard"] = "暴雪"
L["Glow"] = "發光"
L["Pandemic Glow"] = "Pandemic 發光"
L["Demo"] = "示範"
L["Fills every managed viewer with placeholder icons and bars that follow your settings live. Turns itself off when the options close."] = "以範例圖示與計時條填滿所有已接管的顯示器，並即時跟隨你的設定。關閉選項時自動關閉。"
L["Hide Delay"] = "隱藏延遲"
L["How long the display stays up after its condition falls away."] = "條件不再成立後，顯示繼續保留的時間。"
L["Fade Time"] = "淡化時間"
L["How long fading in and out takes. Zero switches instantly."] = "淡入與淡出所需的時間。為零時立即切換。"
L["Texts"] = "文字"
L["Copy Settings"] = "複製設定"
L["Copy From"] = "複製自"
L["Only settings this display knows are taken over, everything else stays untouched."] = "只複製此顯示器認得的設定，其餘內容保持不變。"
L["Sections"] = "分組"
L["Copy"] = "複製"
L["Took over %d settings from %s."] = "已複製 %d 項設定，來源：%s。"
L["Own Entries"] = "自訂項目"
L["Spell"] = "法術"
L["Item"] = "物品"
L["Equipment Slot"] = "裝備欄位"
L["Spell or Item ID"] = "法術或物品 ID"
L["Add"] = "新增"
L["No spell or item found for this ID."] = "找不到與此 ID 對應的法術或物品。"
L["Entries"] = "項目"
L["Move Up"] = "上移"
L["Move Down"] = "下移"
L["Remove"] = "移除"
L["Known Spells Only"] = "僅限已學會的法術"
L["Hides own spell entries the character has not learned."] = "隱藏角色尚未學會的自訂法術項目。"
