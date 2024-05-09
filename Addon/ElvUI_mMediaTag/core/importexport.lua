local E = unpack(ElvUI)
local L = mMT.Locales

local LibDeflate = E.Libs.Deflate
local D = E:GetModule("Distributor")

local strmatch = strmatch
local exportPrefix = "!mMT!"
function GetImportStringType(dataString)
	return (strmatch(dataString, "^" .. exportPrefix) and "Deflate") or (strmatch(dataString, "^{") and "Table") or ""
end

function mMT:GetExportText(tbl, profileType)
	local serialData = D:Serialize(tbl)
	local exportString = D:CreateProfileExport(serialData, profileType, profileType)
	local compressedData = LibDeflate:CompressDeflate(exportString, LibDeflate.compressLevel)
	local printableString = ""
	local exportText = nil
	printableString = LibDeflate:EncodeForPrint(compressedData)
	exportText = printableString and format("%s%s", exportPrefix, printableString) or nil
	return exportText
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
