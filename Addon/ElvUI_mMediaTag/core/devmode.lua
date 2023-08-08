local E, L = unpack(ElvUI)
--Lua functions
local format = format

--Variables
local mDevFrame = nil
local function setupButtons(btn, texture)
	btn:SetHighlightTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dev\\" .. texture .. "h.tga")
	btn:SetNormalTexture("Interface\\AddOns\\ElvUI_mMediaTag\\media\\icons\\dev\\" .. texture .. ".tga")
	btn:Height(32)
	btn:Width(32)
	btn:Show()
end

local function SaveZoneID()
	local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
	tinsert(mMT.DB.dev.zone, instanceID, { name = name, id = instanceID, type = instanceType, difficultyID = difficultyID, difficultyName = difficultyName })
    mMT:Print("|CFFFFC900DEV:|r ", instanceID, name)
end

function mMT:SaveFramePos()
    mMT.DB.dev.frame.top =  mDevFrame:GetTop()
    mMT.DB.dev.frame.left = mDevFrame:GetLeft()
end

local function SaveUnitID()
	if UnitExists("target") and not UnitIsPlayer("target") then
        local ZoneName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
		local guid = UnitGUID("target")
		local npcID = guid and select(6, strsplit("-", guid))
        local name, realm = UnitName("target")
		tinsert(mMT.DB.dev.unit, npcID or guid, { name = name, guid = guid, npcid = npcID, zone = ZoneName })
        mMT:Print("|CFFFFC900DEV:|r ", npcID, name)
	end
end

function mMT:DevTools()
    if mMT.DevMode then
        if not mDevFrame then
            -- Create DEV Frame
            mDevFrame = CreateFrame("Frame", "mMT_DevTools", E.UIParent, "BackdropTemplate")
            mDevFrame:SetPoint("TOPLEFT", E.UIParent, "BOTTOMLEFT", mMT.DB.dev.frame.left or 0, mMT.DB.dev.frame.top or 0)
            mDevFrame:CreateBackdrop("Transparent")
            mDevFrame:SetMovable(true)
            mDevFrame:EnableMouse(true)
            mDevFrame:RegisterForDrag("LeftButton")
            mDevFrame:SetScript("OnDragStart", mDevFrame.StartMoving)
            mDevFrame:SetScript("OnDragStop", mDevFrame.StopMovingOrSizing)
            mDevFrame:SetClampedToScreen(true)
            mDevFrame:Size(76, 42)

            -- Save Target Unit ID
            mDevFrame.UnitID = CreateFrame("Button", "mMT_BTN_UnitID", mDevFrame)
            setupButtons(mDevFrame.UnitID, "devunit")
            mDevFrame.UnitID:Point("TOPLEFT", mDevFrame, "TOPLEFT", 5, -5)
            mDevFrame.UnitID:SetScript("OnClick", SaveUnitID)

            -- Save Zone ID
            mDevFrame.ZoneID = CreateFrame("Button", "mMT_BTN_ZoneID", mDevFrame)
            setupButtons(mDevFrame.ZoneID, "devzone")
            mDevFrame.ZoneID:Point("LEFT", mDevFrame.UnitID, "RIGHT", 2, 0)
            mDevFrame.ZoneID:SetScript("OnClick", SaveZoneID)
        end

        if DevTool then
            DevTool:AddData(mMT.DB.dev.zone, "Zone")
            DevTool:AddData(mMT.DB.dev.unit, "Unit")
        end
    elseif mDevFrame then
        mDevFrame:Hide()
    end
end
