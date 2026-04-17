local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("AutoRoleCheck", { "AceEvent-3.0" })

local _G = _G
local C_Timer_After = C_Timer.After

local function ClickButton(button)
	if button and button:IsShown() and button:IsEnabled() then button:Click() end
end

local function AcceptLFDPopup()
	local popup = _G.LFDRoleCheckPopup
	if not popup or not popup:IsShown() then return end

	ClickButton(_G.LFDRoleCheckPopupAcceptButton)
end

local function AcceptPremadeSignup()
	local dialog = _G.LFGListApplicationDialog
	if not dialog or not dialog:IsShown() then return end

	ClickButton(dialog.SignUpButton)
end

function module:Initialize()
	if not E.db.mMediaTag.auto_role_check.enable then return end
	module.db = E.db.mMediaTag.auto_role_check

	if not module.lfdHooked then
		local lfdPopup = _G.LFDRoleCheckPopup
		if lfdPopup then
			lfdPopup:HookScript("OnShow", function()
				C_Timer_After(0.05, AcceptLFDPopup)
			end)
			module.lfdHooked = true
		end
	end

	if not module.premadeHooked then
		local premadeDialog = _G.LFGListApplicationDialog
		if premadeDialog then
			premadeDialog:HookScript("OnShow", function()
				C_Timer_After(0.05, AcceptPremadeSignup)
			end)
			module.premadeHooked = true
		end
	end
end
