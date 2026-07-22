local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)
local module = mMT:AddModule("AutoRoleCheck", { "AceEvent-3.0" })

local _G = _G
local hooksecurefunc = hooksecurefunc
local IsShiftKeyDown = IsShiftKeyDown

local function CanUsePremadeSignup()
	return module.db and module.db.enable and module.db.accept_premade
end

local function CanUseRoleCheck()
	return module.db and module.db.enable and module.db.accept_lfd
end

local function SetupPremadeHooks()
	if module.premadeHooksLoaded then return end
	if type(_G.LFGListSearchEntry_OnClick) ~= "function" then return end
	if not _G.LFGListApplicationDialog then return end

	hooksecurefunc("LFGListSearchEntry_OnClick", function(self, button)
		if not CanUsePremadeSignup() then return end

		local lfgFrame = _G.LFGListFrame
		local panel = lfgFrame and lfgFrame.SearchPanel
		local scrollBox = panel and panel.ScrollBox

		if not self or not panel or not scrollBox or not self.resultID then return end
		if button ~= "LeftButton" then return end
		if not _G.LFGListSearchPanelUtil_CanSelectResult(self.resultID) then return end
		if not scrollBox:IsVisible() or not scrollBox:IsMouseOver() then return end
		if not panel.SignUpButton or not panel.SignUpButton:IsEnabled() then return end

		if panel.selectedResult ~= self.resultID then
			_G.LFGListSearchPanel_SelectResult(panel, self.resultID)
		end

		_G.LFGListSearchPanel_SignUp(panel)
	end)

	_G.LFGListApplicationDialog:HookScript("OnShow", function(self)
		if not CanUsePremadeSignup() then return end

		local lfgFrame = _G.LFGListFrame
		local panel = lfgFrame and lfgFrame.SearchPanel
		local scrollBox = panel and panel.ScrollBox

		if not self or not self.SignUpButton or not scrollBox then return end
		if not self.SignUpButton:IsEnabled() then return end
		if IsShiftKeyDown() then return end
		if not scrollBox:IsVisible() or not scrollBox:IsMouseOver() then return end

		self.SignUpButton:Click()
	end)

	module.premadeHooksLoaded = true
end

local function SetupRoleCheckHook()
	if module.roleCheckHookLoaded then return end
	if not _G.LFDRoleCheckPopup then return end

	_G.LFDRoleCheckPopup:HookScript("OnShow", function()
		if not CanUseRoleCheck() then return end
		if _G.LFDRoleCheckPopupAcceptButton and _G.LFDRoleCheckPopupAcceptButton:IsEnabled() then
			_G.LFDRoleCheckPopupAcceptButton:Click()
		end
	end)

	module.roleCheckHookLoaded = true
end

function module:ADDON_LOADED()
	SetupPremadeHooks()
	SetupRoleCheckHook()

	if module.premadeHooksLoaded and module.roleCheckHookLoaded then
		module:UnregisterEvent("ADDON_LOADED")
	end
end

function module:Initialize()
	module.db = E.db.mMediaTag.auto_role_check

	if not module.db or not module.db.enable then
		module:UnregisterAllEvents()
		return
	end

	SetupPremadeHooks()
	SetupRoleCheckHook()

	if not (module.premadeHooksLoaded and module.roleCheckHookLoaded) then
		module:RegisterEvent("ADDON_LOADED")
	end
end
