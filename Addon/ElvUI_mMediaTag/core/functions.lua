local mMT, DB, M, E, P, L, MEDIA = unpack(ElvUI_mMediaTag)

-- Cache WoW Globals
local format = format
local print = print
local strmatch = strmatch

local LibDeflate = E.Libs.Deflate
local D = E:GetModule("Distributor")

function mMT:Print(...)
	print(MEDIA.icon16 .. " " .. mMT.Name .. ":", ...)
end

function mMT:AddSettingsIcon(text, icon)
	return format("|TInterface\\Addons\\ElvUI_mMediaTag\\media\\options\\%s.tga:16:16|t  %s", icon, text)
end

function mMT:UpdateModule(name)
	local module = M[name]
	if module and module.Initialize then module:Initialize() end
end

function mMT:AddModule(name, arg)
	if arg then
		M[name] = mMT:NewModule(name, unpack(arg))
	else
		M[name] = {}
	end
	return M[name]
end

function mMT:GetIconString(icon)
	return icon and format("|T%s:16:16:0:0:64:64:4:55:4:55|t", icon) or ""
end

function mMT:TC(text, color)
	color = color or "text"
	return MEDIA.color[color]:WrapTextInColorCode(text)
end

function mMT:HexToRGB(hex)
	if #hex == 6 then hex = "ff" .. hex end

	local a, r, g, b = tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16), tonumber(hex:sub(7, 8), 16)

	return r / 255, g / 255, b / 255, a / 255
end

-- build menu frames
function mMT:BuildMenus()
	mMT.menu = CreateFrame("Frame", "mMediaTag_Main_Menu_Frame", E.UIParent, "BackdropTemplate")
	mMT.menu:SetTemplate("Transparent", true)

	mMT.submenu = CreateFrame("Frame", "mMediaTag_Submenu_Frame", E.UIParent, "BackdropTemplate")
	mMT.submenu:SetTemplate("Transparent", true)
end

-- import/ export functions
local exportPrefix = "!mMT!"
function GetImportStringType(dataString)
	return (strmatch(dataString, "^" .. exportPrefix) and "Deflate") or (strmatch(dataString, "^{") and "Table") or ""
end

function mMT:GetExportText(profileData, profileType)
	local serialString = D:Serialize(profileData)
	local exportString = D:CreateProfileExport(profileType, profileType, serialString)
	local compressedData = LibDeflate:CompressDeflate(exportString, LibDeflate.compressLevel)
	local printableString = LibDeflate:EncodeForPrint(compressedData)
	local profileExport = printableString and format("%s%s", exportPrefix, printableString) or nil

	return profileExport
end

function mMT:GetImportText(string)
	local profileInfo, profileType, profileData
	local stringType = GetImportStringType(string)
	if stringType == "Deflate" then
		local data = gsub(string, "^" .. exportPrefix, "")
		local decodedData = LibDeflate:DecodeForPrint(data)
		local decompressed = LibDeflate:DecompressDeflate(decodedData)
		if not decompressed then
			mMT:Print(L["Error decompressing data."])
			return
		end

		local serializedData, success
		serializedData, profileInfo = E:SplitString(decompressed, "^^::") -- '^^' indicates the end of the AceSerializer string

		if not profileInfo then
			mMT:Print(L["Error importing profile. String is invalid or corrupted!"])
			return
		end

		serializedData = format("%s%s", serializedData, "^^") --Add back the AceSerializer terminator
		profileType, _ = E:SplitString(profileInfo, "::")
		success, profileData = D:Deserialize(serializedData)

		if not success then
			mMT:Print(L["Error deserializing:"], profileData)
			return
		end
	end

	return profileType, profileData
end
