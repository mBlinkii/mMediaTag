local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("KeystoneToChat", { "AceEvent-3.0" })

-- Cache WoW Globals
local strlower = strlower
local ipairs = ipairs
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_MythicPlus = C_MythicPlus
local InCombatLockdown = InCombatLockdown
local SendChatMessage = SendChatMessage
local NUM_BAG_SLOTS = NUM_BAG_SLOTS

local function CheckText(text)
	local word = strlower(text)
	for _, value in ipairs({ "!key", "!keys" }) do
		if word == value then return true end
	end
	return false
end

local function GetKeyLink()
	local keystones = {}
	for bag = 0, NUM_BAG_SLOTS do
		local bSlots = GetContainerNumSlots(bag)
		for slot = 1, bSlots do
			local containerInfo = GetContainerItemInfo(bag, slot)
			if containerInfo then
				-- 180653 = SL/ 187786 = Legion
				if containerInfo.itemID == 180653 or containerInfo.itemID == 187786 then keystones[containerInfo.itemID] = containerInfo.hyperlink end
			end
		end
	end
	return keystones
end

local function GetKey(channel, text)
	if text and channel and CheckText(text) then
		if C_MythicPlus.GetOwnedKeystoneLevel() and not InCombatLockdown() then
			local keystones = GetKeyLink()
			if keystones then
				local link
				if keystones[180653] and keystones[187786] then
					link = keystones[180653] .. " & " .. keystones[187786]
				elseif keystones[180653] then
					link = keystones[180653]
				else
					link = keystones[187786]
				end

				if link and channel then
					SendChatMessage(link, channel)
				end
			end
		end
	end
end

function module:Initialize()
	if E.Retail and E.db.mMT.keystone_to_chat.enable then
		module:RegisterEvent("CHAT_MSG_PARTY")
		module:RegisterEvent("CHAT_MSG_PARTY_LEADER")
		module:RegisterEvent("CHAT_MSG_RAID")
		module:RegisterEvent("CHAT_MSG_RAID_LEADER")
		module:RegisterEvent("CHAT_MSG_GUILD")
		module:RegisterEvent("CHAT_MSG_SAY")
		module.isEnabled = true
	elseif module.isEnabled then
		module:UnregisterEvent("CHAT_MSG_PARTY")
		module:UnregisterEvent("CHAT_MSG_PARTY_LEADER")
		module:UnregisterEvent("CHAT_MSG_RAID")
		module:UnregisterEvent("CHAT_MSG_RAID_LEADER")
		module:UnregisterEvent("CHAT_MSG_GUILD")
		module:UnregisterEvent("CHAT_MSG_SAY")
		module.isEnabled = false
	end
end

function module:CHAT_MSG_SAY(_, text)
	GetKey("SAY", text)
end

function module:CHAT_MSG_PARTY(_, text)
	GetKey("PARTY", text)
end

function module:CHAT_MSG_PARTY_LEADER(_, text)
	GetKey("PARTY", text)
end

function module:CHAT_MSG_RAID(_, text)
	GetKey("RAID", text)
end

function module:CHAT_MSG_RAID_LEADER(_, text)
	GetKey("RAID", text)
end

function module:CHAT_MSG_GUILD(_, text)
	GetKey("GUILD", text)
end
