local E = unpack(ElvUI)

local NP = E:GetModule("NamePlates")
local module = mMT.Modules.QuestIcons

local function SetQuestIcons(_, nameplate)
	if IsInInstance() then return end

	local plateDB = NP:PlateDB(nameplate)
	local db = E.Retail and plateDB.questIcon

	if db and db.enable and not nameplate.isBattlePet and (nameplate.frameType == "FRIENDLY_NPC" or nameplate.frameType == "ENEMY_NPC") and not nameplate.QuestIcons.mMTSkin then
		for _, object in ipairs(NP.QuestIcons.iconTypes) do
			--mMT:Print("QuestIcon", "Object", object)
			local icon = nameplate.QuestIcons[object]

			if object ~= "Item" then
				icon:SetTexture(mMT.Media.DockIcons[E.db.mMT.questicons.texture[object]])
			end

			if E.db.mMT.questicons.hidetext then
				icon.Text:Hide()
			end
		end
		nameplate.QuestIcons.mMTSkin = true
	end
end

function module:Initialize()
	if not module.hooked then
		hooksecurefunc(NP, "Update_QuestIcons", SetQuestIcons)
		module.loaded = true
		module.hooked = true
		module.needReloadUI = true
	end
end
