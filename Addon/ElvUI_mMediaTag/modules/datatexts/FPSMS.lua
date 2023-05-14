local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local floor = floor

local GetFramerate = GetFramerate
local GetNetStats = GetNetStats

local statusColors = {
	"|cff0CD809",
	"|cffE8DA0F",
	"|cffFF9000",
	"|cffD80909",
}

local wait = 20 -- initial delay for update (let the ui load)
local function OnUpdate(self, elapsed)
	wait = wait - elapsed

	if wait < 0 then
		wait = 1

		local framerate = floor(GetFramerate())
		local _, _, homePing, worldPing = GetNetStats()
		local latency = E.global.datatexts.settings.System.latency == "HOME" and homePing or worldPing

		local fps = framerate >= 30 and 1
			or (framerate >= 20 and framerate < 30) and 2
			or (framerate >= 10 and framerate < 20) and 3
			or 4
		local ping = latency < 150 and 1
			or (latency >= 150 and latency < 300) and 2
			or (latency >= 300 and latency < 500) and 3
			or 4
		self.text:SetFormattedText("%s%d|r | %s%d|r", statusColors[fps], framerate, statusColors[ping], latency)
	end
end

DT:RegisterDatatext("mFPS", "mMediaTag", nil, nil, OnUpdate, nil, nil, nil, L["FPS/MS"], nil, nil)
