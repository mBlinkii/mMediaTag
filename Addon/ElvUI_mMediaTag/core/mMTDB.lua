local defaultDB = {
	mplusaffix = { affixes = nil, season = nil, reset = false, year = nil },
	affix = nil,
	keys = {},
	dev = { enabled = false, frame = { top = nil, left = nil }, unit = {}, zone = {} },
}

local DB_Loader = CreateFrame("FRAME")
DB_Loader:RegisterEvent("PLAYER_LOGOUT")
DB_Loader:RegisterEvent("ADDON_LOADED")

function DB_Loader:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "ElvUI_mMediaTag" then
		mMTDB = mMTDB or {}
		mMT.DB = mMTDB
		for k, v in pairs(defaultDB) do
			if mMT.DB[k] == nil then
				mMT.DB[k] = v
			end
		end
	elseif event == "PLAYER_LOGOUT" then
		if mMT.DevMode then
			mMT:SaveFramePos()
			mMT.DB.dev.enabled = mMT.DevMode
		end
		mMTDB = mMT.DB
	end
end

DB_Loader:SetScript("OnEvent", DB_Loader.OnEvent)
