local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- MUST stay last in the TOC: E:RegisterModule() calls Initialize() synchronously once ElvUI is up, and core/profiles/media/options/modules must be loaded by then.
E:RegisterModule(mMT:GetName())
