local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

function mMT:Print(...)
	print(MEDIA.icon16 .. " " .. mMT.Name .. ":", ...)
end

function mMT:AddSettingsIcon(text, icon)
	return format("|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\%s.tga:16:16|t %s", icon, text)
end
