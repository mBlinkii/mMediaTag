local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local addon, ns = ...

--Lua functions
local strlower = strlower
local string = string
local ipairs = ipairs
local select = select
local mInsert = table.insert

--WoW API / Variables
local _G = _G
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemInfo = GetContainerItemInfo
local C_MythicPlus = C_MythicPlus
local InCombatLockdown = InCombatLockdown()

--Variables
local mKeystoneToChat = nil

local function mCheckText(text)
	local word = strlower(text)
	for index, value in ipairs({"!key", "!keys"}) do
		if word == value then
			return value
		end
	end
end

local function mGetKey()
	local mKeys = {}
	for bag = 0, NUM_BAG_SLOTS do
		local bSlots = GetContainerNumSlots(bag)
		for slot = 1, bSlots do
			local itemLink, _, _, itemID = select(7, GetContainerItemInfo(bag, slot))
			-- 180653 = SL/ 187786 = Legion
			if itemID == 180653 or itemID == 187786 then
				mKeys[itemID] = itemLink
			end
		end
	end
	return mKeys
end

local function OnEvent(self, event, ...)
	local text, _, _, _, _, _, _, _ = ...
	if text and mCheckText(string.lower(text)) or false then
		if C_MythicPlus.GetOwnedKeystoneLevel() or false and E.db[mPlugin].mMythicPlusTools.keys and not InCombatLockdown then
			local channel = nil
			if event == "CHAT_MSG_GUILD" then
				channel = "GUILD"
			elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
				channel = "PARTY"
			elseif event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" then
				channel = "RAID"
			end

			local myKeys = mGetKey()
			if myKeys then
				local link = nil
				-- 180653 = SL/ 187786 = Legion
				if myKeys[180653] and myKeys[187786] then
					link = myKeys[180653] .. " & " .. myKeys[187786]
				elseif myKeys[180653] then
					link = myKeys[180653]
				else
					link = myKeys[187786]
				end
				if link and channel then
					SendChatMessage(link, channel)
				end
			end
		end
	end
end

local function mKeystoneToChatOptions()
	E.Options.args.mMediaTag.args.general.args.myticplustools.args = {
		keystontochat = {
			order = 10,
			type = "toggle",
			name = L["Send Keyston to Chat"],
			desc = L["Sends your Keyston to Chat, wen ther ist The Keyword !key or !keys"],
			get = function(info)
				return E.db[mPlugin].mMythicPlusTools.keys
			end,
			set = function(info, value)
				E.db[mPlugin].mMythicPlusTools.keys = value
			end,
		},
	}
end

function mMT:mStartKeysToChatt()
	mKeystoneToChat = CreateFrame("FRAME")
	mKeystoneToChat:RegisterEvent("CHAT_MSG_PARTY")
	mKeystoneToChat:RegisterEvent("CHAT_MSG_PARTY_LEADER")
	mKeystoneToChat:RegisterEvent("CHAT_MSG_RAID")
	mKeystoneToChat:RegisterEvent("CHAT_MSG_RAID_LEADER")
	mKeystoneToChat:RegisterEvent("CHAT_MSG_GUILD")
	mKeystoneToChat:SetScript("OnEvent", OnEvent)
end

mInsert(ns.Config, mKeystoneToChatOptions)
