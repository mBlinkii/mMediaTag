local E = unpack(ElvUI)
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
local delay = 0
local enteredFrame = false
local function OnEnter(self, slow)
	enteredFrame = true

	if slow == 1 or not slow then
		DT.tooltip:ClearLines()
		if E.Retail then
			local addonCount = C_AddOns.GetNumAddOns()
			if C_AddOnProfiler.IsEnabled() and addonCount > 0 then
				DT.tooltip:AddLine("|cffffffff" .. AddonList:GetOverallMetric(ADDON_LIST_PERFORMANCE_AVERAGE_CPU, Enum.AddOnProfilerMetric.SessionAverageTime) .. "|r")
				DT.tooltip:AddLine("|cffffffff" .. AddonList:GetOverallMetric(ADDON_LIST_PERFORMANCE_PEAK_CPU, Enum.AddOnProfilerMetric.PeakTime) .. "|r")
				DT.tooltip:AddLine(" ")

				local addonCPU = C_AddOnProfiler.GetTopKAddOnsForMetric(Enum.AddOnProfilerMetric.RecentAverageTime, 10)
				if #addonCPU > 0 then
					for _, result in ipairs(addonCPU) do
						DT.tooltip:AddLine("|cffffffff" .. AddonList:GetAddonMetricPercent(result.addOnName, ADDON_PERFORMANCE_MENU_TOOLTIP, Enum.AddOnProfilerMetric.RecentAverageTime) .. "|r")
					end
				end
			end
		elseif self.infos then
			DT.tooltip:AddDoubleLine(mMT.Name, format("|CFFF7DC6FVer. %s|r", mMT.Version))
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddDoubleLine("FPS:", self.infos.fps)
			DT.tooltip:AddDoubleLine("MS:", self.infos.ping)
		end
	end
	DT.tooltip:Show()
end

local function OnLeave()
	enteredFrame = false
	DT.tooltip:Hide()
end

local function OnUpdate(self, elapsed)
	wait = wait - elapsed

	if wait < 0 then
		wait = 1

		local framerate = floor(GetFramerate())
		local _, _, homePing, worldPing = GetNetStats()
		local latency = E.global.datatexts.settings.System.latency == "HOME" and homePing or worldPing

		local fps = framerate >= 30 and 1 or (framerate >= 20 and framerate < 30) and 2 or (framerate >= 10 and framerate < 20) and 3 or 4
		local ping = latency < 150 and 1 or (latency >= 150 and latency < 300) and 2 or (latency >= 300 and latency < 500) and 3 or 4
		self.text:SetFormattedText("%s%d|r | %s%d|r", statusColors[fps], framerate, statusColors[ping], latency)

		self.infos = {
			fps = format("%s%d|r", statusColors[fps], fps),
			ping = format("%s%d|r", statusColors[ping], latency),
		}
	end

	if enteredFrame then
		if delay > 40 then
			OnEnter(self)
			delay = 0
		else
			OnEnter(self, delay)
			delay = delay + 1
		end
	end
end

DT:RegisterDatatext("mFPS", mMT.DatatextString, nil, nil, OnUpdate, nil, OnEnter, OnLeave, "FPS/MS", nil, nil)
