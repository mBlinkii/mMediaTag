local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")

local module = mMT:AddModule("Tracker")

--WoW API / Variables
local _G = _G
local GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local GetItemCount = C_Item and C_Item.GetItemCount or GetItemCount
local RequestLoadItemDataByID = C_Item.RequestLoadItemDataByID
local strjoin = strjoin

--Variables
local tracker_ids_db, is_currency_db, requested_ids = {}, {}, {}
local item_events = E.Modern and { "ITEM_COUNT_CHANGED" } or { "BAG_UPDATE_DELAYED" }
local itemLoadFrame = CreateFrame("Frame")

-- 5:59 of 64 matches ElvUI's 0.08 TexCoords crop
local ICON_DATA, ICON_DATA_CROPPED = ":14:14", ":14:14:0:0:64:64:5:59:5:59"

local function IconString(texture)
	return E:TextureString(texture, E.db.mMediaTag.datatexts.tracker.crop_icon and ICON_DATA_CROPPED or ICON_DATA)
end

local tracker_default_ids
if E.Retail then
	tracker_default_ids = {
		-- crest
		[3443] = { isCurrency = true, color = "FF84FF4F" }, -- Veteran Mistcrest
		[3444] = { isCurrency = true, color = "FF034CF6" }, -- Champion Mistcrest
		[3445] = { isCurrency = true, color = "FFA928FF" }, -- Hero Mistcrest
		[3446] = { isCurrency = true, color = "FFFFA514" }, -- Myth Mistcrest
		[3442] = { isCurrency = true, color = "FF4FFCFF" }, -- Adventurer Mistcrest

		-- midnight
		[3465] = { isCurrency = true, color = "FFFFAE17" }, -- Venomblight Manaflux
		[3509] = { isCurrency = true, color = "FF2FD8C4" }, -- Tidal Spark Dust
		[3418] = { isCurrency = true, color = "FF6B4FE0" }, -- Nebulous Voidcore
		[3028] = { isCurrency = true, color = "FFEC46FF" }, -- Restored Coffer Key
		[2803] = { isCurrency = true, color = "FFEC46FF" }, -- Undercoin

		-- pvp
		[2123] = { isCurrency = true, color = "FFFF4117" }, -- Bloody Tokens
		[1792] = { isCurrency = true, color = "FFFCE03D" }, -- Honor
		[1602] = { isCurrency = true, color = "FFFCE03D" }, -- Conquest

		-- misc
		[2032] = { isCurrency = true, color = "FFF68D03" }, -- Trader's Tender
		[1166] = { isCurrency = true, color = "FF54BAFF" }, -- Timewarped Badge
	}
elseif E.Mists then
	tracker_default_ids = {
		[395] = { isCurrency = true, color = "FF3FA9FF" }, -- Justice Points
		[396] = { isCurrency = true, color = "FFFF9D00" }, -- Valor Points
		[1901] = { isCurrency = true, color = "FFFCE03D" }, -- Honor Points
		[390] = { isCurrency = true, color = "FFFF4117" }, -- Conquest Points
		[738] = { isCurrency = true, color = "FF84FF4F" }, -- Lesser Charm of Good Fortune
		[697] = { isCurrency = true, color = "FFA928FF" }, -- Elder Charm of Good Fortune
		[752] = { isCurrency = true, color = "FFA928FF" }, -- Mogu Rune of Fate
		[776] = { isCurrency = true, color = "FFA928FF" }, -- Warforged Seal
		[777] = { isCurrency = true, color = "FF4FFCFF" }, -- Timeless Coin
		[789] = { isCurrency = true, color = "FFFF4117" }, -- Bloody Coin
		[402] = { isCurrency = true, color = "FFF68D03" }, -- Ironpaw Token
		[515] = { isCurrency = true, color = "FFEC46FF" }, -- Darkmoon Prize Ticket
	}
elseif E.TBC then
	tracker_default_ids = {
		[1901] = { isCurrency = true, color = "FFFCE03D" }, -- Honor Points
		[1900] = { isCurrency = true, color = "FFFF4117" }, -- Arena Points
		[29434] = { color = "FFA928FF" }, -- Badge of Justice
		[28558] = { color = "FF4FFCFF" }, -- Spirit Shard
		[26045] = { color = "FFFF4117" }, -- Halaa Battle Token
		[26044] = { color = "FF84FF4F" }, -- Halaa Research Token
		[32569] = { color = "FF84FF4F" }, -- Apexis Shard
		[32897] = { color = "FF84FF4F" }, -- Mark of the Illidari
		[34664] = { color = "FFFF9D00" }, -- Sunmote
		[24579] = { color = "FF3FA9FF" }, -- Mark of Honor Hold
		[24581] = { color = "FFFF4117" }, -- Mark of Thrallmar
		[20558] = { color = "FFFCE03D" }, -- Warsong Gulch Mark of Honor
		[20559] = { color = "FFFCE03D" }, -- Arathi Basin Mark of Honor
		[20560] = { color = "FFFCE03D" }, -- Alterac Valley Mark of Honor
		[29024] = { color = "FFFCE03D" }, -- Eye of the Storm Mark of Honor
		[19182] = { color = "FFEC46FF" }, -- Darkmoon Faire Prize Ticket
	}
elseif E.Forever then
	tracker_default_ids = {
		[1792] = { isCurrency = true, color = "FFFCE03D" }, -- Honor Points
		[3468] = { isCurrency = true, color = "FFFF4117" }, -- Rank Points
		[3402] = { isCurrency = true, color = "FFF68D03" }, -- Merchant's Favor
		[3469] = { isCurrency = true, color = "FF84FF4F" }, -- Tarnished Undermine Real
		[515] = { isCurrency = true, color = "FFEC46FF" }, -- Darkmoon Prize Ticket
	}
else
	tracker_default_ids = {
		[20558] = { color = "FFFCE03D" }, -- Warsong Gulch Mark of Honor
		[20559] = { color = "FFFCE03D" }, -- Arathi Basin Mark of Honor
		[20560] = { color = "FFFCE03D" }, -- Alterac Valley Mark of Honor
		[12844] = { color = "FF84FF4F" }, -- Argent Dawn Valor Token
		[22484] = { color = "FF84FF4F" }, -- Necrotic Rune
		[19858] = { color = "FF4FFCFF" }, -- Zandalar Honor Token
		[21229] = { color = "FFA928FF" }, -- Qiraji Lord's Insignia
		[19182] = { color = "FFEC46FF" }, -- Darkmoon Faire Prize Ticket
	}
end

function module:GetItemInfos(id)
	local itemName, itemLink, _, _, _, _, _, itemStackCount, _, itemTexture, _, _, _, _, _, _, _ = GetItemInfo(id)
	if itemName and itemLink and itemTexture then
		return {
			name = itemName,
			icon = IconString(itemTexture),
			link = itemLink,
			count = GetItemCount(id, true),
			cap = itemStackCount,
			isCurrency = false,
		}
	end
end

function module:GetCurrencyInfos(id)
	local info = GetCurrencyInfo(id)
	if info then
		is_currency_db[id] = true
		return {
			name = info.name,
			icon = IconString(info.iconFileID),
			link = format("|Hcurrency:%s|h", id),
			count = info.quantity,
			cap = info.maxQuantity,
			isCurrency = true,
		}
	end
end

local function OnEvent(self, event, id)
	if event == "ITEM_COUNT_CHANGED" and id ~= self.name then return end

	local db = E.db.mMediaTag.datatexts.tracker
	id = tonumber(self.name)
	local info = is_currency_db[id] and module:GetCurrencyInfos(id) or module:GetItemInfos(id)
	if not info then return end

	self.tracker_info = info
	self.text:SetText(info.name)

	local name = db.name and info.name or nil
	local icon = db.icon and info.icon or nil
	local value = db.short_number and info.count >= 1000 and E:ShortValue(info.count, 2) or info.count

	if db.show_max and info.cap > 0 then
		local cap = db.short_number and info.cap >= 1000 and E:ShortValue(info.cap, 2) or info.cap
		value = format("%s/%s", value, cap)
	end

	if self.text:GetJustifyH() == "RIGHT" then
		self.text:SetFormattedText("%s %s %s", format(self.mMT_valueString, value), format(self.mMT_textString, name or ""), icon or "")
	else
		self.text:SetFormattedText("%s %s %s", icon or "", format(self.mMT_textString, name or ""), format(self.mMT_valueString, value))
	end
end

local function OnEnter(self)
	if not self.tracker_info then OnEvent(self) end

	DT.tooltip:ClearLines()

	DT:SetupTooltip(self)
	DT.tooltip:SetHyperlink(self.tracker_info.link)
	DT.tooltip:Show()
end

local function ValueColorUpdate(self, hex)
	local db = E.db.mMediaTag.datatexts.tracker
	-- on a profile switch ElvUI's applySettings runs before mMT:UpdateAll (E:Delay), so an unknown ID falls back to ElvUI's value color
	local info = tracker_ids_db[tonumber(self.name)]
	local custom = info and info.color and "|c" .. info.color
	local textHex = E.db.mMediaTag.datatexts.text.override_text and "|c" .. MEDIA.color.override_text.hex or db.colored and custom or hex
	local valueHex = E.db.mMediaTag.datatexts.text.override_value and "|c" .. MEDIA.color.override_value.hex or db.colored and custom or hex

	self.mMT_textString = strjoin("", textHex, "%s|r")
	self.mMT_valueString = strjoin("", valueHex, "%s|r")
	OnEvent(self)
end

local function AddID(id, t)
	local infos = t.isCurrency and module:GetCurrencyInfos(id) or module:GetItemInfos(id)
	if infos then
		tracker_ids_db[id] = infos
		tracker_ids_db[id].color = t.color
	elseif not requested_ids[id] then
		-- items that are not in the cache yet return nil, the datatext is registered once they are loaded
		requested_ids[id] = true
		RequestLoadItemDataByID(id)
		itemLoadFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")
	end
end

local function LoadIDs()
	tracker_ids_db, is_currency_db = {}, {}

	for id, t in pairs(E.db.mMediaTag.datatexts.tracker.custom) do
		AddID(id, t)
	end

	for id, t in pairs(tracker_default_ids) do
		AddID(id, t)
	end
end

itemLoadFrame:SetScript("OnEvent", function(self)
	self:UnregisterEvent("GET_ITEM_INFO_RECEIVED")
	E:Delay(1, module.Initialize, module, true)
end)

function module:UpdateAll()
	if next(tracker_ids_db) then
		for id, _ in pairs(tracker_ids_db) do
			DT:ForceUpdate_DataText(id)
		end
	end
end

function module:Initialize(itemsLoaded)
	LoadIDs()
	local registered

	if next(tracker_ids_db) then
		for id, info in pairs(tracker_ids_db) do
			if not DT.RegisteredDataTexts[id] then
				if is_currency_db[id] then
					-- #FFA600
					DT:RegisterDatatext(
						id,
						mMT.NameShort .. " - " .. "|CFFFFA600" .. _G.CURRENCY .. "|r",
						{ "CHAT_MSG_CURRENCY", "CURRENCY_DISPLAY_UPDATE" },
						OnEvent,
						nil,
						nil,
						OnEnter,
						nil,
						"mMT - " .. info.name,
						nil,
						ValueColorUpdate
					)
				else
					-- #EE1E75
					DT:RegisterDatatext(
						id,
						mMT.NameShort .. " - " .. "|CFFEE1E75" .. _G.ITEMS .. "|r",
						item_events,
						OnEvent,
						nil,
						nil,
						OnEnter,
						nil,
						"mMT - " .. info.name .. " (" .. id .. ")",
						nil,
						ValueColorUpdate
					)
				end
				registered = true
			end
		end
	end

	-- repaint assigned slots: ElvUI's applySettings pass ran before LoadIDs() on a profile switch
	for dt, data in pairs(DT.AssignedDatatexts) do
		if data and tracker_ids_db[tonumber(data.name)] then ValueColorUpdate(dt, E.media.hexvaluecolor) end
	end

	DT:UpdateQuickDT()

	-- ElvUI assigned the panels on PLAYER_ENTERING_WORLD, before these datatexts existed
	if itemsLoaded and registered then DT:LoadDataTexts() end
end
