local E = unpack(ElvUI)

function mMT:LoadCommands()
    self:RegisterChatCommand("mmt", function()
        if not InCombatLockdown() then
            E:ToggleOptions("mMT")
            HideUIPanel(_G["GameMenuFrame"])
        end
    end)
end
