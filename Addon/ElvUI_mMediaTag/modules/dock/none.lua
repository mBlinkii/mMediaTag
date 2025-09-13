local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local DT = E:GetModule("DataTexts")
local Dock = M.Dock

local function OnEvent(self)
	if self.mMT_Dock then
		if self.mMT_Dock.macroBtn then
			-- delete Secure button
			self.mMT_Dock.SecureBtn:Hide()
			self.mMT_Dock.SecureBtn:SetScript("OnEnter", nil)
			self.mMT_Dock.SecureBtn:SetScript("OnLeave", nil)
			self.mMT_Dock.SecureBtn:SetScript("OnClick", nil)
			self.mMT_Dock.SecureBtn:SetParent(nil)
			self.mMT_Dock.SecureBtn:ClearAllPoints()
			self.mMT_Dock.SecureBtn = nil
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

DT:RegisterDatatext("mMT_Dock_None", mMT.NameShort .. " - |CFF01EEFFDock|r", nil, OnEvent, nil, nil, nil, nil, "|CFF01EEFFDock|r" .. " " .. L["None"] .. "|r", nil, nil)
