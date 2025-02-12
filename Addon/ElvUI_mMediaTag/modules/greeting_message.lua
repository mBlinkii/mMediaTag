local mMT, DB, M, E, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local format = format
local print = print

M.GreetingMessage = {}

local function GreetingMessage()
	local text = L["Welcome to %s %s version |CFFF7DC6F%s|r, type |CFF58D68D/mmt|r to access the in-game configuration menu or type |CFF58D68D/mmt help|r for an overview of all chat commands."]
	print(format(text, MEDIA.icon16, mMT.Name, mMT.Version))
end

function M.GreetingMessage:Initialize()
	if E.db.mMT.greeting_message then GreetingMessage() end
end
