local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- This file MUST stay the last entry in the TOC.
--
-- ElvUI's E:RegisterModule() runs the module's Initialize() *synchronously*
-- when E.initialized is already true (which is the case for plugins loading
-- after ElvUI). Registering earlier would call mMT:Initialize() before
-- core\, profiles\, media\, options\ and modules\ are loaded, resulting in
-- "attempt to call a nil value" (e.g. mMT:UpdateDeveloperState).
E:RegisterModule(mMT:GetName())
