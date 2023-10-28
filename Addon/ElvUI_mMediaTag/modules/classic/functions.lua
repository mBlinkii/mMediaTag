local E, L = unpack(ElvUI)

local _G = _G
local GetNumSkillLines, GetSkillLineInfo = _G.GetNumSkillLines, _G.GetSkillLineInfo

function mMT:GetClassicProfessions()
	local prof1, prof2, firstaid, fish, cook = nil, nil, nil, nil, nil

    local numSkills = GetNumSkillLines()

	for skillIndex = 1, numSkills do
		local skillName, isHeader, _, _, _, _, _, isAbandonable, _, _, _, _, _ = GetSkillLineInfo(skillIndex)

		if skillName and not isHeader then
			if isAbandonable then
				if not prof1 then
					prof1 = skillIndex
				else
					prof2 = skillIndex
				end
			else
                if (skillName == PROFESSIONS_FIRST_AID) then
                    firstaid = skillIndex
                elseif (skillName == PROFESSIONS_FISHING) then
                    fish = skillIndex
                elseif (skillName == PROFESSIONS_COOKING) then
                    cook = skillIndex
                end
			end
		end
	end

    return prof1, prof2, firstaid, fish, cook
end
