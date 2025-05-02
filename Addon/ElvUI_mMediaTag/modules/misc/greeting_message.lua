local mMT, DB, M, E, P, L, MEDIA, COLORS = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local format = format
local print = print

local module = mMT:AddModule("GreetingMessage")

local function GreetingMessage()
	local text = L["Welcome to %s %s version |CFFF7DC6F%s|r, type |CFF58D68D/mmt|r to access the in-game configuration menu or type |CFF58D68D/mmt help|r for an overview of all chat commands."]
	print(format(text, MEDIA.icon16, mMT.Name, mMT.Version))
end

function module:Initialize()
	if E.db.mMT.general.greeting_message then GreetingMessage() end
end
