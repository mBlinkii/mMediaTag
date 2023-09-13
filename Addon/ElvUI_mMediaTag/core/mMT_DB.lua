-- default settings
local defaultDB = {
	mplusaffix = { affixes = nil, season = nil, reset = false, year = nil },
	affix = nil,
	keys = {},
	dev = { enabled = false, frame = { top = nil, left = nil }, unit = {}, zone = {} },
}

-- Create Frame and register events
local DB_Loader = CreateFrame("FRAME")
DB_Loader:RegisterEvent("PLAYER_LOGOUT")
DB_Loader:RegisterEvent("ADDON_LOADED")

local function OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "ElvUI_mMediaTag" then
		mMTDB = mMTDB or {}
		for k, v in pairs(defaultDB) do
			if mMTDB[k] == nil then
				mMTDB[k] = v
			end
		end
	elseif event == "PLAYER_LOGOUT" then
		if mMT.DevMode then
			mMT:SaveFramePos()
			mMT.DB.dev.enabled = mMT.DevMode
		end

		if mMT.DB then
			mMTDB = mMT.DB
		end
	end
end

DB_Loader:SetScript("OnEvent", OnEvent)
