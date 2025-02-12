local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local format = format
local print = print

function mMT:Print(...)
	print(MEDIA.icon16 .. " " .. mMT.Name .. ":", ...)
end

function mMT:AddSettingsIcon(text, icon)
	return format("|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\%s.tga:16:16|t %s", icon, text)
end

function mMT:UpdateModule(name)
	local module = M[name]
	if module and module.Initialize then module:Initialize() end
end

function mMT:AddModule(name)
	M[name] = {}
	return M[name]
end
