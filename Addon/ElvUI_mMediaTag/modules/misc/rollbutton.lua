local E = unpack(ElvUI)
local L = mMT.Locales

--Lua functions
local format = format

--Variables
local mRollFrame = nil
function mMT:mRollUpdateIcon()
	if mRollFrame and mRollFrame.mSettings then
		mRollFrame.mSettings.xy = E.db.mMT.roll.size

		if E.db.mMT.roll.colormodenormal == "class" then
			mRollFrame.mSettings.ColorNormal = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b, a = E.db.mMT.roll.colornormal.a }
		else
			mRollFrame.mSettings.ColorNormal = {
				r = E.db.mMT.roll.colornormal.r,
				g = E.db.mMT.roll.colornormal.g,
				b = E.db.mMT.roll.colornormal.b,
				a = E.db.mMT.roll.colornormal.a,
			}
		end

		if E.db.mMT.roll.colormodehover == "class" then
			mRollFrame.mSettings.ColorHover = { r = mMT.ClassColor.r, g = mMT.ClassColor.g, b = mMT.ClassColor.b, a = E.db.mMT.roll.colorhover.a }
		else
			mRollFrame.mSettings.ColorHover = {
				r = E.db.mMT.roll.colorhover.r,
				g = E.db.mMT.roll.colorhover.g,
				b = E.db.mMT.roll.colorhover.b,
				a = E.db.mMT.roll.colorhover.a,
			}
		end

		mRollFrame:Size(mRollFrame.mSettings.xy, mRollFrame.mSettings.xy)
		mRollFrame.Texture:Size(mRollFrame.mSettings.xy, mRollFrame.mSettings.xy)
		mRollFrame.Texture:ClearAllPoints()
		mRollFrame.Texture:Point("CENTER")
		mRollFrame.Texture:SetTexture(mMT.Media.RollIcons[E.db.mMT.roll.texture])
		mRollFrame.Texture:SetVertexColor(mRollFrame.mSettings.ColorNormal.r, mRollFrame.mSettings.ColorNormal.g, mRollFrame.mSettings.ColorNormal.b, mRollFrame.mSettings.ColorNormal.a)
	end
end

function mMT:mRoll()
	if not mRollFrame then
		mRollFrame = CreateFrame("Button", "mMediaTagRoll", E.UIParent, "BackdropTemplate")

		if not mRollFrame.Texture then mRollFrame.Texture = mRollFrame:CreateTexture(nil, "ARTWORK") end

		mRollFrame:Point("CENTER")
		mRollFrame.mSettings = { ColorNormal = { r = 1, g = 1, b = 1, a = 1 }, ColorHover = { r = 1, g = 1, b = 1, a = 1 }, xy = 16 }

		mMT:mRollUpdateIcon()

		--mRollFrame:Size(mRollFrame.mSettings.xy, mRollFrame.mSettings.xy)
		mRollFrame:RegisterForClicks("AnyDown")
		mRollFrame:SetScript("OnClick", function(self, btn)
			if btn == "RightButton" then
				RandomRoll(1, E.db.mMT.roll.right)
			else
				RandomRoll(1, E.db.mMT.roll.left)
			end
		end)
		mRollFrame:SetScript("OnEnter", function(self)
			mRollFrame.Texture:SetVertexColor(mRollFrame.mSettings.ColorHover.r, mRollFrame.mSettings.ColorHover.g, mRollFrame.mSettings.ColorHover.b, mRollFrame.mSettings.ColorHover.a)
			_G.GameTooltip:SetOwner(mRollFrame, "ANCHOR_RIGHT")
			_G.GameTooltip:AddLine(format("|CFFFFC800%s|r", L["Roll Button"]))
			_G.GameTooltip:AddLine(" ")
			_G.GameTooltip:AddDoubleLine(format("|CFFFFC800%s|r", L["Left Click to roll"]), "|CFF4C9CDE1-" .. E.db.mMT.roll.left .. "|r")
			_G.GameTooltip:AddDoubleLine(format("|CFFFFC800%s|r", L["Right Click to roll"]), "|CFF4C9CDE1-" .. E.db.mMT.roll.right .. "|r")
			_G.GameTooltip:Show()
		end)
		mRollFrame:SetScript("OnLeave", function(self)
			mRollFrame.Texture:SetVertexColor(mRollFrame.mSettings.ColorNormal.r, mRollFrame.mSettings.ColorNormal.g, mRollFrame.mSettings.ColorNormal.b, mRollFrame.mSettings.ColorNormal.a)
			_G.GameTooltip:Hide()
		end)

		E:CreateMover(mRollFrame, "mMediaTagRollMover", "mMediaTagRoll", nil, nil, nil, "ALL,MMEDIATAG", nil, "mMT,general,roll", nil)
	end
end
