local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", L["None"])
local mTextName = "mNoIcon"

local function OnEvent(self, event, ...)
	if self.mIcon then
		if self.mIcon.TextA then
			self.mIcon.TextA:SetText("")
		end

		if self.mIcon.TextB then
			self.mIcon.TextB:SetText("")
		end

		if self.mNotifications then
			self.mNotifications:Hide()
			self.mNotifications = nil
		end

		self.text:SetText("")

		self.mIcon:SetTexture(nil)
		self.mIcon = nil
		self.mSettings = nil
		
		print(self.mIcon)
		print(self.mSettings)
		print(self.mNotifications)
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, nil, nil, nil, mText, nil, nil)
