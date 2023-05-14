local strlower = strlower
local string = string
local ipairs = ipairs

--WoW API / Variables
local GetContainerNumSlots = C_Container.GetContainerNumSlots
local GetContainerItemInfo = C_Container.GetContainerItemInfo
local C_MythicPlus = C_MythicPlus
local InCombatLockdown = InCombatLockdown()

local function mCheckText(text)
	local word = strlower(text)
	for index, value in ipairs({ "!key", "!keys" }) do
		if word == value then
			return value
		end
	end
end

local function mGetKeyLink()
	local mKeys = {}
	mKeys = wipe(mKeys)
	for bag = 0, NUM_BAG_SLOTS do
		local bSlots = GetContainerNumSlots(bag)
		for slot = 1, bSlots do
			local containerInfo = GetContainerItemInfo(bag, slot)
			if containerInfo then
				-- 180653 = SL/ 187786 = Legion
				if containerInfo.itemID == 180653 or containerInfo.itemID == 187786 then
					mKeys[containerInfo.itemID] = containerInfo.hyperlink
				end
			end
		end
	end
	return mKeys
end

function mMT:GetKey(channel, text)
	if text and channel and mCheckText(string.lower(text)) or false then
		if C_MythicPlus.GetOwnedKeystoneLevel() or false and not InCombatLockdown then
			local myKeys = mGetKeyLink()
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
