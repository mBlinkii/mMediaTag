local E = unpack(ElvUI)
local _G = _G

local settings = {}
local texture = "Interface\\Addons\\ElvUI_mMediaTag\\media\\portraits\\"

function MTEST.Modules.DEVTest:Init(update)
	if update then
		MTEST.Modules.DEVTest:Test_Update_Settings()
	end

	if settings.enable then
		if not MTEST.Modules.DEVTest.TEST then
			MTEST.Modules.DEVTest.TEST = CreateFrame("Frame", "MTT", _G.UIParent)
		end

		MTEST.Modules.DEVTest.TEST:SetSize(128, 128)
		MTEST.Modules.DEVTest.TEST:SetPoint("CENTER")

		if not MTEST.Modules.DEVTest.TEST.texture then
			MTEST.Modules.DEVTest.texture = MTEST.Modules.DEVTest.TEST:CreateTexture("mMT_Border", "OVERLAY", nil, 4)
		end
        
		MTEST.Modules.DEVTest.TEST.texture:SetAllPoints(MTEST.Modules.DEVTest.TEST)
		MTEST.Modules.DEVTest.TEST.texture:SetTexture(texture, "CLAMP", "CLAMP", "TRILINEAR")
		MTEST.Modules.DEVTest.TEST.texture:SetVertexColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
		MTEST.Modules.DEVTest.TEST:RegisterEvent("PLAYER_TARGET_CHANGED")
		MTEST.Modules.DEVTest.TEST:SetScript("OnEvent", function(self, event)
			MTEST:print("FUNCTION", settings.enable, settings.color.r, settings.color.g, settings.color.b, settings.color.a, settings.text)
			MTEST.Modules.DEVTest.TEST.texture:SetVertexColor(settings.color.r, settings.color.g, settings.color.b, settings.color.a)
		end)
	else
		MTEST.Modules.DEVTest.TEST:UnregisterEvent("PLAYER_TARGET_CHANGED")
		MTEST.Modules.DEVTest.TEST:Hide()
	end

	function MTEST.Modules.DEVTest:Update_Settings()
		settings = E.db.MT
		MTEST.print("SETTINGS", settings.enable, settings.color.r, settings.color.g, settings.color.b, settings.color.a, settings.text)
	end
end