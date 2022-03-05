local E, L, V, P, G = unpack(ElvUI);
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin);
local addon, ns = ...
local D = E:GetModule('Distributor')
local LibCompress = E.Libs.Compress
local LibBase64 = E.Libs.Base64


--Lua functions
local format = format
local mInsert = table.insert

--Variables
local impD = {}
local impDisOK = false

function mMT:mImport(data)
    local DecodedProfile = LibBase64:Decode(data)
    local DecompressedProfile, DecompressedMessage = LibCompress:Decompress(DecodedProfile)

    if not DecompressedProfile then
        return DecompressedMessage, false
    end

    local success, DeserializeProfile = D:Deserialize(DecompressedProfile)

    E:CopyTable(E.db.mMediaTag, P)
    E:CopyTable(E.db.mMediaTag, DeserializeProfile)
	E:StaticPopup_Show("CONFIG_RL")
end

function mMT:mExport()
    local ProfileData = {}
    ProfileData = E:CopyTable(ProfileData, E.db.mMediaTag)
    ProfileData = E:RemoveTableDuplicates(ProfileData, P.mMediaTag)

    local SerializedProfile = D:Serialize(ProfileData)
    local CompressedProfile = LibCompress:Compress(SerializedProfile)

    local EncodedProfile = LibBase64:Encode(CompressedProfile)  .. "{}" .. LibBase64:Encode("mMediaTag-Profile")

    return EncodedProfile
end

function mMT:mDecode(data)
	local isDataOK = mMT:mCheckStrings(data)
	if isDataOK == true then
		local ProfileString, ProfileCheck = E:SplitString(data, "{}")
		local stringType1 = D:GetImportStringType(ProfileString)
		local stringType2 = D:GetImportStringType(ProfileCheck)

		if stringType1 == 'Base64' and stringType2 == 'Base64' and mMT:mCheckData(ProfileCheck) == true then
				local DecodedProfile = LibBase64:Decode(ProfileString)
				local DecompressedProfile, _ = LibCompress:Decompress(DecodedProfile)

				if not DecompressedProfile then
					return nil, false
				end

				local success, DeserializeProfile = D:Deserialize(DecompressedProfile)
				if success == true then
					return DeserializeProfile, true
				else
					return nil, false
				end
		end
	else
		return nil, false
	end
end

function mMT:mCheckData(data)
	local DecodedString = LibBase64:Decode(data)
	if DecodedString == "mMediaTag-Profile" then
		return true
	else
		return false
	end
end

function mMT:mCheckStrings(data)
	local CheckString1, CheckString2 = E:SplitString(data, "{}")
	if CheckString1 and CheckString2 then
		local CheckStringTyp1 = D:GetImportStringType(CheckString1)
		local CheckStringTyp2 = D:GetImportStringType(CheckString2)
		if CheckStringTyp1 == 'Base64' and CheckStringTyp2 == 'Base64' and mMT:mCheckData(CheckString2) == true then
			impD = CheckString1
			impDisOK = true
			return true
		else
			impD = {}
			impDisOK = false
			return false
		end
	else
		impD = {}
		impDisOK = false
		return false
	end
end

function mMT:mImportExportWindow()
	local Frame = E.Libs.AceGUI:Create('Frame')
	Frame:SetTitle(ns.mName .. " Profile Import/ Export")
	Frame:EnableResize(false)
	Frame:SetWidth(400)
	Frame:SetHeight(500)
	Frame.frame:SetFrameStrata('FULLSCREEN_DIALOG')
	Frame:SetLayout('flow')
	
	local Box = E.Libs.AceGUI:Create('MultiLineEditBox-ElvUI')
	Box:SetNumLines(20)
	Box:DisableButton(true)
	Box:SetWidth(400)
	Box:SetLabel('')
	Box:SetText("")
	Frame:AddChild(Box)
	--Save original script so we can restore it later
	Box.editBox.OnTextChangedOrig = Box.editBox:GetScript('OnTextChanged')
	Box.editBox.OnCursorChangedOrig = Box.editBox:GetScript('OnCursorChanged')
	--Remove OnCursorChanged script as it causes weird behaviour with long text
	Box.editBox:SetScript('OnCursorChanged', nil)
	Box.scrollFrame:UpdateScrollChildRect()

	local Label1 = E.Libs.AceGUI:Create('Label')
	local font = GameFontHighlightSmall:GetFont()
	Label1:SetFont(font, 14)
	Label1:SetText('...') --Set temporary text so height is set correctly
	Label1:SetWidth(350)
	
	local importButton = E.Libs.AceGUI:Create('Button-ElvUI') --This version changes text color on SetDisabled
	importButton:SetDisabled(true)
	importButton:SetText(L["Import Now"])
	importButton:SetAutoWidth(true)
	importButton:SetCallback('OnClick', function()
		if impDisOK == true then
        	mMT:mImport(impD)
		else
		end
	end)
	Frame:AddChild(importButton)

    local exportButton = E.Libs.AceGUI:Create('Button-ElvUI') --This version changes text color on SetDisabled
	exportButton:SetDisabled(false)
	exportButton:SetText(L["Export Now"])
	exportButton:SetAutoWidth(true)
	exportButton:SetCallback('OnClick', function()
        Box:SetText(mMT:mExport())
		Box.editBox:HighlightText()
	end)
	Frame:AddChild(exportButton)
	
	local decodeButton = E.Libs.AceGUI:Create('Button-ElvUI')
	decodeButton:SetDisabled(true)
	decodeButton:SetText(L["Decode Text"])
	decodeButton:SetAutoWidth(true)
	decodeButton:SetCallback('OnClick', function()
        local DecodedData, succses = mMT:mDecode(Box:GetText())
		if succses == true then
			Box:SetText(E:TableToLuaString(DecodedData))
		else
			Box:SetText("")
			Label1:SetText(format("|CFFE74C3C%s|r", L["ERROR: Import string is not OK!"]))
		end
	end)
	Frame:AddChild(decodeButton)
	Frame:AddChild(Label1)
	
	local function OnTextChanged(_, userInput)
		if not userInput then
			Box.scrollFrame:SetVerticalScroll(Box.scrollFrame:GetVerticalScrollRange())
		end
		
		local text = Box:GetText()

		if text == '' then
			Label1:SetText('')
			importButton:SetDisabled(true)
			decodeButton:SetDisabled(true)
		else
			if mMT:mCheckStrings(text) == true then
				Label1:SetText(format("|CFF58D68D%s|r", L["It is all right, profile Import or Copy the string."]))

				decodeButton:SetDisabled(false)
				importButton:SetDisabled(false)

				--Scroll frame doesn't scroll to the bottom by itself, so let's do that now
				Box.scrollFrame:UpdateScrollChildRect()
				Box.scrollFrame:SetVerticalScroll(Box.scrollFrame:GetVerticalScrollRange())
			else
				Label1:SetText(format("|CFFE74C3C%s|r", L["ERROR: Import string is not OK!"]))
				decodeButton:SetDisabled(true)
				importButton:SetDisabled(true)
			end
		end
	end
	
	Box.editBox:SetFocus()
	Box.editBox:SetScript('OnChar', nil)
	Box.editBox:SetScript('OnTextChanged', OnTextChanged)
	
	Frame:SetCallback('OnClose', function(widget)
		--Restore changed scripts
		Box.editBox:SetScript('OnChar', nil)
		Box.editBox:SetScript('OnTextChanged', Box.editBox.OnTextChangedOrig)
		Box.editBox:SetScript('OnCursorChanged', Box.editBox.OnCursorChangedOrig)
		Box.editBox.OnTextChangedOrig = nil
		Box.editBox.OnCursorChangedOrig = nil
		
		E.Libs.AceGUI:Release(widget)
		E:Config_OpenWindow()
	end)
	
	--Close ElvUI OptionsUI
	E.Libs.AceConfigDialog:Close('ElvUI')
	
	GameTooltip_Hide() --The tooltip from the Export/Import button stays on screen, so hide it
end

local function mImportExportSettings()
	E.Options.args.mMediaTag.args.profile.args = {
		description = {
			order = 1,
			type = "description",
			name = L["Here you can export and share or import the settings of mMediaTag."] .. "\n\n",
		},
		importexport = {
            order = 10,
            type = "execute",
            name = L["IMPORT/ EXPORT"],
            func = function() 
                mMT:mImportExportWindow()
            end,
        },
	}
end

mInsert(ns.Config, mImportExportSettings)