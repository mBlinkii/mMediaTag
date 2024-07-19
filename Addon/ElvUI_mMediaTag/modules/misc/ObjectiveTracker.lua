local E = unpack(ElvUI)
local LSM = E.Libs.LSM
local S = E:GetModule("Skins")

local module = mMT.Modules.ObjectiveTracker
local db = nil
if not module then
	return
end


-- get quest infos
local function GetRequirements(text)
	local current, required, questText = strmatch(text, "^(%d-)/(%d-) (.+)")
	if not current or not required or not questText then
		questText, current, required = strmatch(text, "(.+): (%d-)/(%d-)$")
	end
	return current, required, questText
end

local function SetLineText(text, completed)
	if not db then return end
	local color = completed and db.font.color.complete or (db.font.color.text.class and mMT.ClassColor or db.font.color.text)
	local fontsize = db.font.fontsize.text

	text:SetFont(LSM:Fetch("font", db.font.font), fontsize, db.font.fontflag)
	text:SetTextColor(color.r, color.g, color.b)
	local lineText = text:GetText()

	if lineText then
		-- Text Progress
		if not completed then
			local current, required, questText = GetRequirements(lineText)

			if current and required and questText then
				if current == required then
					lineText = db.font.color.good.hex .. questText .. "|r"
				else
					local progressPercent = nil

					local colorGood = db.font.color.good
					local colorTransit = db.font.color.transit
					local colorBad = db.font.color.bad

					if required ~= "1" then
						progressPercent = (tonumber(current) / tonumber(required)) * 100 or 0
						local r, g, b = E:ColorGradient(progressPercent * 0.01, colorBad.r, colorBad.g, colorBad.b, colorTransit.r, colorTransit.g, colorTransit.b, colorGood.r, colorGood.g, colorGood.b)
						local colorProgress = E:RGBToHex(r, g, b)
						progressPercent = format("%.f%%", progressPercent)
						lineText = colorProgress .. current .. "/" .. required .. " - " .. progressPercent .. "|r" .. "  " .. questText
					else
						lineText = db.font.color.bad.hex .. current .. "/" .. required .. "|r  " .. questText
					end
				end
			end
		else
			local _, _, questText = GetRequirements(lineText)
			if questText then
				lineText = db.font.color.good.hex .. questText .. "|r"
			end
		end

		text:SetText(lineText)
		text:SetWordWrap(true)

		return text:GetStringHeight()
	end
end

local function AddObjective(self, objectiveKey, text, template, useFullHeight, dashStyle, colorStyle, adjustForNoText, overrideHeight)
	--mMT:Print(self, objectiveKey, text, template, useFullHeight, dashStyle, colorStyle, adjustForNoText, overrideHeight)
	local line = self:GetLine(objectiveKey, template)

	--mMT:DebugPrintTable(line,)
    mMT:Print(line.state)
	-- line.Text:SetText("UFFI")

	if line and line.Text then
		SetLineText(line.Text, (line.state == "Completed"))
	end

	-- line.progressBar = nil;

	-- -- dash
	-- if line.Dash then
	-- 	if not dashStyle then
	-- 		dashStyle = OBJECTIVE_DASH_STYLE_SHOW;
	-- 	end
	-- 	if line.dashStyle ~= dashStyle then
	-- 		if dashStyle == OBJECTIVE_DASH_STYLE_SHOW then
	-- 			line.Dash:Show();
	-- 			line.Dash:SetText(QUEST_DASH);
	-- 		elseif dashStyle == OBJECTIVE_DASH_STYLE_HIDE then
	-- 			line.Dash:Hide();
	-- 			line.Dash:SetText(QUEST_DASH);
	-- 		elseif dashStyle == OBJECTIVE_DASH_STYLE_HIDE_AND_COLLAPSE then
	-- 			line.Dash:Hide();
	-- 			line.Dash:SetText(nil);
	-- 		else
	-- 			assertsafe(false, "Invalid dash style: " .. tostring(dashStyle));
	-- 		end
	-- 		line.dashStyle = dashStyle;
	-- 	end
	-- end

	--local lineSpacing = self.parentModule.lineSpacing;
	-- local offsetY = -lineSpacing;

	-- -- anchor the line
	-- local anchor = self.lastRegion or self.HeaderText;
	-- if anchor then
	-- 	line:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, offsetY);
	-- else
	-- 	line:SetPoint("TOPLEFT", 0, offsetY);
	-- end
	-- line:SetPoint("RIGHT", self.rightEdgeOffset, 0);

	-- set the text
	-- local textHeight = self:SetStringText(line.Text, text, useFullHeight, colorStyle, self.isHighlighted);
	-- local height = overrideHeight or textHeight;
	-- line:SetHeight(height);

	-- self.height = self.height + height + lineSpacing;

	-- self.lastRegion = line;
	-- return line;

	-- line.Text
end

local function AddBlock(self, block)
	--mMT:DebugPrintTable(block)

	if block and block.AddObjective then
		hooksecurefunc(block, "AddObjective", AddObjective)
	end
end

function module:Initialize()
	-- prevent bugs with wrong db entries
	if E.db.mMT.objectivetracker.font and not E.db.mMT.objectivetracker.font.font then
		E.db.mMT.objectivetracker.font = {
			font = "PT Sans Narrow",
			fontflag = "NONE",
			highlight = 0.4,
			color = {
				title = { class = false, r = 1, g = 0.78, b = 0, hex = "|cffffc700" },
				header = { class = false, r = 1, g = 0.78, b = 0, hex = "|cffffc700" },
				text = { class = false, r = 0.87, g = 0.87, b = 0.87, hex = "|cff00ffa4" },
				failed = { r = 1, g = 0.16, b = 0, hex = "|cffff2800" },
				complete = { r = 0, g = 1, b = 0.27, hex = "|cff00ff45" },
				good = { r = 0.25, g = 1, b = 0.43, hex = "|cff40ff6e" },
				bad = { r = 0.92, g = 0.46, b = 0.1, hex = "|cffeb751a" },
				transit = { r = 1, g = 0.63, b = 0.05, hex = "|cffffa10d" },
			},
			fontsize = {
				header = 14,
				title = 12,
				text = 12,
			},
		}
	end

	db = E.db.mMT.objectivetracker

	if not module.hooked then
		-- this hooked wont run?
		-- QuestObjectiveTrackerMixin
		-- hooksecurefunc(_G.ObjectiveTrackerBlockMixin, "AddObjective", AddObjective)

		--mMT:DebugPrintTable(ObjectiveTrackerBlockMixin)
		-- hooksecurefunc(_G.ObjectiveTrackerBlockMixin, "AddObjective", AddObjective)

		if ObjectiveTrackerFrame and ObjectiveTrackerFrame.modules then
			for _, m in pairs(ObjectiveTrackerFrame.modules) do
				hooksecurefunc(m, "AddBlock", AddBlock)
			end
		end
	end

	module.needReloadUI = true
	module.loaded = true
end
