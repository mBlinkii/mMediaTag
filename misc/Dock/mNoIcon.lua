local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local DT = E:GetModule("DataTexts")
local addon, ns = ...

--Lua functions
local format = format

--Variables
local mText = format("Dock %s", L["None"])
local mTextName = "mNoIcon"

local function OnEvent(self, event, ...)
	if self.mIcon then
		if self.mIcon.TextA and self.mIcon.TextB then
			self.mIcon.TextA:SetText("")
			self.mIcon.TextB:SetText("")
		end

		if self.mNotificationsthen then
			self.mNotifications:Hide()
		end

		self.mIcon:SetTexture(nil)

		wipe(self.mIcon)
		wipe(self.mSettings)
	end
end

DT:RegisterDatatext(mTextName, "mDock", nil, OnEvent, nil, nil, nil, nil, mText, nil, nil)
