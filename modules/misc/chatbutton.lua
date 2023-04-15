local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")
local NP = E:GetModule("NamePlates")

--Lua functions
local format = format
local mInsert = table.insert

--Variables
local _, unitClass = UnitClass("player")
local class = ElvUF.colors.class[unitClass]
local mChatMenuFrame = nil
function mMT:mChatUpdateIcon()
	if mChatMenuFrame and mChatMenuFrame.mSettings then
		mChatMenuFrame.mSettings.xy = E.db.mMT.chat.size

		if E.db.mMT.chat.colormodenormal == "class" then
			mChatMenuFrame.mSettings.ColorNormal =
				{ r = class[1], g = class[2], b = class[3], a = E.db.mMT.chat.colornormal.a }
		else
			mChatMenuFrame.mSettings.ColorNormal = {
				r = E.db.mMT.chat.colornormal.r,
				g = E.db.mMT.chat.colornormal.g,
				b = E.db.mMT.chat.colornormal.b,
				a = E.db.mMT.chat.colornormal.a,
			}
		end

		if E.db.mMT.chat.colormodehover == "class" then
			mChatMenuFrame.mSettings.ColorHover =
				{ r = class[1], g = class[2], b = class[3], a = E.db.mMT.chat.colorhover.a }
		else
			mChatMenuFrame.mSettings.ColorHover = {
				r = E.db.mMT.chat.colorhover.r,
				g = E.db.mMT.chat.colorhover.g,
				b = E.db.mMT.chat.colorhover.b,
				a = E.db.mMT.chat.colorhover.a,
			}
		end

		mChatMenuFrame:Size(mChatMenuFrame.mSettings.xy, mChatMenuFrame.mSettings.xy)
		mChatMenuFrame.Texture:Size(mChatMenuFrame.mSettings.xy, mChatMenuFrame.mSettings.xy)
		mChatMenuFrame.Texture:ClearAllPoints()
		mChatMenuFrame.Texture:Point("CENTER")
		mChatMenuFrame.Texture:SetTexture(mMT.Media.ChatIcons[E.db.mMT.chat.texture])
		mChatMenuFrame.Texture:SetVertexColor(
			mChatMenuFrame.mSettings.ColorNormal.r,
			mChatMenuFrame.mSettings.ColorNormal.g,
			mChatMenuFrame.mSettings.ColorNormal.b,
			mChatMenuFrame.mSettings.ColorNormal.a
		)
	end
end
function mMT:mChat()
	if not mChatMenuFrame then
		mChatMenuFrame = CreateFrame("Button", "mMediaTagChat", E.UIParent, "BackdropTemplate")

		if not mChatMenuFrame.Texture then
			mChatMenuFrame.Texture = mChatMenuFrame:CreateTexture(nil, "ARTWORK")
		end

		mChatMenuFrame:Point("CENTER")
		mChatMenuFrame.mSettings =
			{ ColorNormal = { r = 1, g = 1, b = 1, a = 1 }, ColorHover = { r = 1, g = 1, b = 1, a = 1 }, xy = 16 }

		mMT:mChatUpdateIcon()

		--mChatMenuFrame:Size(mChatMenuFrame.mSettings.xy, mChatMenuFrame.mSettings.xy)
		mChatMenuFrame:RegisterForClicks("AnyDown")
		mChatMenuFrame:SetScript("OnClick", function(self)
			_G.ChatMenu:SetShown(not _G.ChatMenu:IsShown())
		end)
		mChatMenuFrame:SetScript("OnEnter", function(self)
			mChatMenuFrame.Texture:SetVertexColor(
				mChatMenuFrame.mSettings.ColorHover.r,
				mChatMenuFrame.mSettings.ColorHover.g,
				mChatMenuFrame.mSettings.ColorHover.b,
				mChatMenuFrame.mSettings.ColorHover.a
			)

			_G.GameTooltip:SetOwner(mChatMenuFrame, "ANCHOR_RIGHT")
			_G.GameTooltip:AddLine(format("|cffffc800%s|r", L["Chat Menu"]))
			_G.GameTooltip:Show()
		end)
		mChatMenuFrame:SetScript("OnLeave", function(self)
			mChatMenuFrame.Texture:SetVertexColor(
				mChatMenuFrame.mSettings.ColorNormal.r,
				mChatMenuFrame.mSettings.ColorNormal.g,
				mChatMenuFrame.mSettings.ColorNormal.b,
				mChatMenuFrame.mSettings.ColorNormal.a
			)
			_G.GameTooltip:Hide()
		end)

		E:CreateMover(
			mChatMenuFrame,
			"mMediaTagChatMover",
			"mMediaTagChat",
			nil,
			nil,
			nil,
			"ALL",
			nil,
			"mMT,general,Chat",
			nil
		)
	end
end
