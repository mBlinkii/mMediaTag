local E = unpack(ElvUI)
local L = mMT.Locales

local DT = E:GetModule("DataTexts")
local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.datatexts.args.individual_professions.args = {
        icon = {
            order = 1,
            name = L["Show Icons"],
            type = "toggle",
            get = function(info)
                return E.db.mMT.singleProfession.icon
            end,
            set = function(info, value)
                E.db.mMT.singleProfession.icon = value
                DT:ForceUpdate_DataText("firstProf")
                DT:ForceUpdate_DataText("secondProf")
            end,
        },
        text = {
            order = 2,
            name = L["white Text"],
            type = "toggle",
            get = function(info)
                return E.db.mMT.singleProfession.whiteText
            end,
            set = function(info, value)
                E.db.mMT.singleProfession.whiteText = value
                DT:ForceUpdate_DataText("firstProf")
                DT:ForceUpdate_DataText("secondProf")
            end,
        },
        value = {
            order = 3,
            name = L["white Value"],
            type = "toggle",
            get = function(info)
                return E.db.mMT.singleProfession.witheValue
            end,
            set = function(info, value)
                E.db.mMT.singleProfession.witheValue = value
                DT:ForceUpdate_DataText("firstProf")
                DT:ForceUpdate_DataText("secondProf")
            end,
        },
	}
end

tinsert(mMT.Config, configTable)
