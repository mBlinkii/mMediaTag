local E, L, V, P, G = unpack(ElvUI)

local DT = E:GetModule("DataTexts")
local tinsert = tinsert
local function configTable()
	E.Options.args.mMT.args.datatexts.args.durabilityanditemlevel.args = {
        icon = {
            order = 1,
            name = L["Show Icons"],
            type = "toggle",
            get = function(info)
                return E.db.mMT.durabilityIlevel.icon
            end,
            set = function(info, value)
                E.db.mMT.durabilityIlevel.icon = value
                DT:ForceUpdate_DataText("DurabilityIlevel")
            end,
        },
        text = {
            order = 2,
            name = L["withe Text"],
            type = "toggle",
            get = function(info)
                return E.db.mMT.durabilityIlevel.whiteText
            end,
            set = function(info, value)
                E.db.mMT.durabilityIlevel.whiteText = value
                DT:ForceUpdate_DataText("DurabilityIlevel")
            end,
        },
	}
end

tinsert(mMT.Config, configTable)
