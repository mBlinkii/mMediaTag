local mMT, DB, M, F, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

function F:Print(...)
	print(MEDIA.icon16 .. " ".. mMT.Name .. ":", ...)
end
