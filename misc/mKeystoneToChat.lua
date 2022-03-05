local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
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
	for index, value in ipairs({"!key", "!keys", "!cov", "!covenant"}) do
		if word == value then
			return value
		end
	end
end

local function Covenant()
	local covenantID = C_Covenants.GetActiveCovenantID()
	if covenantID then
		local data = C_Covenants.GetCovenantData(covenantID)
		if data then
			return data.name
		end
	end
end

local function mGetKey()
	for bag = 0, NUM_BAG_SLOTS do
		local bSlots = GetContainerNumSlots(bag)
		for slot = 1, bSlots do
			local itemLink, _, _, itemID = select(7, GetContainerItemInfo(bag, slot))
			if itemID == 180653 then
				return itemLink
			end
		end
	end
end

local function mMediaTagKeys(event, text, channelIndex)
	local isKeyword = mCheckText(text) or false
	if isKeyword then
		local chat, link = "PARTY", nil
		if event == "CHAT_MSG_GUILD" then
			chat = "GUILD"
		elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" then
			chat = "PARTY"
		elseif event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" then
			chat = "RAID"
		elseif event == "CHAT_MSG_COMMUNITIES_CHANNEL" then
			chat = "CHANNEL"
		end

		local key, covenant = mGetKey(), Covenant()
		if isKeyword == "!key" or isKeyword == "!keys" then
			if key then
				if covenant then
					link = covenant .. ' - ' .. key
				else
					link = key
				end
			end
		else
			if covenant then
				link = covenant
			else
				link = L["No Covenant"]
			end
		end

	
		if chat then
			if channelIndex then
				SendChatMessage(link, chat, nil, channelIndex)
			else
				SendChatMessage(link, chat)
			end
		end
	end
end

local function OnEvent(self, event, ...)
	local key = C_MythicPlus.GetOwnedKeystoneLevel() or false
	if key and E.db[mPlugin].mMythicPlusTools.keys and not InCombatLockdown then
		local text , _, _, _, _, _, _, channelIndex = ...
		if text then
			text = string.lower(text)
			mMediaTagKeys(event, text, channelIndex)
		end
	end
end

local function mKeystoneToChatOptions()
	E.Options.args.mMediaTag.args.general.args.myticplustools.args = {
		keystontochat = {
			order = 10,
			type = 'toggle',
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
	mKeystoneToChat:RegisterEvent("CHAT_MSG_COMMUNITIES_CHANNEL")
	mKeystoneToChat:SetScript("OnEvent", OnEvent)
	--mKeystoneToChat:Show()
end

mInsert(ns.Config, mKeystoneToChatOptions)