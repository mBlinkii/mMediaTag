local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

M.GreetingMessage = {}

local function GreetingMessage()
	print(
		format(
			L["Welcome to %s %s version |CFFF7DC6F%s|r, type |CFF58D68D/mmt|r to access the in-game configuration menu or type |CFF58D68D/mmt help|r for an overview of all chat commands."],
			MEDIA.icon16,
			mMT.Name,
			mMT.Version
		)
	)
end

M.GreetingMessage.Initialize = function()
    if E.db.mMT.greeting_message then
        GreetingMessage()
    end
end
