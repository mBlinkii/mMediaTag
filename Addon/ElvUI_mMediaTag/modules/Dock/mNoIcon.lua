local E, L = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local function OnEvent(self, event, ...)
	if self.mMT_Dock then
		if self.mMT_Dock.macroBtn then
			-- delete macro button
			self.mMT_Dock.macroBtn:Hide()
			self.mMT_Dock.macroBtn:SetScript("OnEnter", nil)
			self.mMT_Dock.macroBtn:SetScript("OnLeave", nil)
			self.mMT_Dock.macroBtn = nil
		end

		-- delete text a
		if self.mMT_Dock.TextA then
			self.mMT_Dock.TextA:SetText("")
			self.mMT_Dock.TextA = nil
		end

		-- delete text b
		if self.mMT_Dock.TextB then
			self.mMT_Dock.TextB:SetText("")
			self.mMT_Dock.TextB = nil
		end

		-- delete notification
		if self.mMT_Dock.Notification then
			self.mMT_Dock.Notification:Hide()
			self.mMT_Dock.Notification:SetTexture(nil)
			E:StopFlash(self.mMT_Dock.Notification)
			self.mMT_Dock.Notification = nil
		end

		-- delete icon
		if self.mMT_Dock.Icon then
			self.mMT_Dock.Icon:Hide()
			self.mMT_Dock.Icon:SetTexture(nil)
			self.mMT_Dock.Icon = nil
		end

		-- delete db
		DT.mMT_Dock = nil
	end
end

DT:RegisterDatatext("mMT_Dock_None", "mMT-" .. mMT.DockString, nil, OnEvent, nil, nil, nil, nil, mMT.DockString .. " |CFFFF006C" .. L["None"] .. "|r", nil, nil)
