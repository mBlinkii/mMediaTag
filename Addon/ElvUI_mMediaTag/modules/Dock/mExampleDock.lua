local mMT, E, L, V, P, G = unpack((select(2, ...)))
local DT = E:GetModule("DataTexts")

--Lua functions

--Variables

function mMT:mDockFull(top, enable)
	E.DataTexts:BuildPanelFrame("mDock")

	E.db["datatexts"]["panels"]["mDock"][1] = "mCharacter"
	E.db["datatexts"]["panels"]["mDock"][2] = "mSpellBook"
	E.db["datatexts"]["panels"]["mDock"][3] = "mTalent"
	E.db["datatexts"]["panels"]["mDock"][4] = "mAchievement"
	E.db["datatexts"]["panels"]["mDock"][5] = "mQuest"
	E.db["datatexts"]["panels"]["mDock"][6] = "mItemLevel"
	E.db["datatexts"]["panels"]["mDock"][7] = "mLFDTool"
	E.db["datatexts"]["panels"]["mDock"][8] = "mCollectionsJourna"
	E.db["datatexts"]["panels"]["mDock"][9] = "mEncounterJournal"
	E.db["datatexts"]["panels"]["mDock"][10] = "mBlizzardStore"
	E.db["datatexts"]["panels"]["mDock"][11] = "mMainMenu"
	E.db["datatexts"]["panels"]["mDock"][12] = "mFPSMS"
	E.db["datatexts"]["panels"]["mDock"][13] = "mFriends"
	E.db["datatexts"]["panels"]["mDock"][14] = "mGuild"
	E.db["datatexts"]["panels"]["mDock"][15] = "mProfession"
	E.db["datatexts"]["panels"]["mDock"][16] = "mDurability"
	E.db["datatexts"]["panels"]["mDock"][17] = "mCalendar"
	E.db["datatexts"]["panels"]["mDock"][18] = "mVolume"
	E.db["datatexts"]["panels"]["mDock"][19] = "mBags"
	E.db["datatexts"]["panels"]["mDock"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mDock"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mDock"]["border"] = false
	E.global["datatexts"]["customPanels"]["mDock"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mDock"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mDock"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mDock"]["fonts"]["fontSize"] = 14
	E.global["datatexts"]["customPanels"]["mDock"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mDock"]["frameStrata"] = "HIGH"
	E.global["datatexts"]["customPanels"]["mDock"]["growth"] = "HORIZONTAL"
	E.global["datatexts"]["customPanels"]["mDock"]["height"] = 42
	E.global["datatexts"]["customPanels"]["mDock"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mDock"]["name"] = "mDock"
	E.global["datatexts"]["customPanels"]["mDock"]["numPoints"] = 19
	E.global["datatexts"]["customPanels"]["mDock"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mDock"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mDock"]["tooltipAnchor"] = "ANCHOR_TOP"
	E.global["datatexts"]["customPanels"]["mDock"]["tooltipXOffset"] = 0
	E.global["datatexts"]["customPanels"]["mDock"]["tooltipYOffset"] = 9
	E.global["datatexts"]["customPanels"]["mDock"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mDock"]["width"] = 900

	if top then
		E.db["movers"]["DTPanelmDockMover"] = "TOP,ElvUIParent,TOP,0,-4"
	else
		E.db["movers"]["DTPanelmDockMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
	end

	E:StaggeredUpdateAll(nil, true)
end

function mMT:mDockMicroBar(top, enable)
	E.DataTexts:BuildPanelFrame("mMicroBar")

	E.db["datatexts"]["panels"]["mMicroBar"][1] = "mCharacter"
	E.db["datatexts"]["panels"]["mMicroBar"][2] = "mSpellBook"
	E.db["datatexts"]["panels"]["mMicroBar"][3] = "mTalent"
	E.db["datatexts"]["panels"]["mMicroBar"][4] = "mAchievement"
	E.db["datatexts"]["panels"]["mMicroBar"][5] = "mQuest"
	E.db["datatexts"]["panels"]["mMicroBar"][6] = "mGuild"
	E.db["datatexts"]["panels"]["mMicroBar"][7] = "mLFDTool"
	E.db["datatexts"]["panels"]["mMicroBar"][8] = "mCollectionsJourna"
	E.db["datatexts"]["panels"]["mMicroBar"][9] = "mEncounterJournal"
	E.db["datatexts"]["panels"]["mMicroBar"][10] = "mBlizzardStore"
	E.db["datatexts"]["panels"]["mMicroBar"][11] = "mMainMenu"
	E.db["datatexts"]["panels"]["mMicroBar"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mMicroBar"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mMicroBar"]["border"] = true
	E.global["datatexts"]["customPanels"]["mMicroBar"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mMicroBar"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mMicroBar"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mMicroBar"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mMicroBar"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mMicroBar"]["frameStrata"] = "LOW"
	E.global["datatexts"]["customPanels"]["mMicroBar"]["growth"] = "HORIZONTAL"
	E.global["datatexts"]["customPanels"]["mMicroBar"]["height"] = 42
	E.global["datatexts"]["customPanels"]["mMicroBar"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mMicroBar"]["name"] = "mMicroBar"
	E.global["datatexts"]["customPanels"]["mMicroBar"]["numPoints"] = 11
	E.global["datatexts"]["customPanels"]["mMicroBar"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mMicroBar"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mMicroBar"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mMicroBar"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mMicroBar"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mMicroBar"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mMicroBar"]["width"] = 570

	if top then
		E.db["movers"]["DTPanelmMicroBarMover"] = "TOP,ElvUIParent,TOP,0,-4"
	else
		E.db["movers"]["DTPanelmMicroBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
	end

	E:StaggeredUpdateAll(nil, true)
end

function mMT:mDockSpezial(top, enable)
	E.DataTexts:BuildPanelFrame("mSpezialDockBaground")
	E.DataTexts:BuildPanelFrame("mSpezialDockLeft")
	E.DataTexts:BuildPanelFrame("mSpezialDockRight")
	E.DataTexts:BuildPanelFrame("mSpezialDockTime")
	E.DataTexts:BuildPanelFrame("mSpezialDockDate")

	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["backdrop"] = true
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["border"] = true
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["frameStrata"] = "LOW"
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["growth"] = "HORIZONTAL"
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["height"] = 48
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["name"] = "mSpezialDockBaground"
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mSpezialDockBaground"]["width"] = 505

	E.db["datatexts"]["panels"]["mSpezialDockBaground"][1] = ""
	E.db["datatexts"]["panels"]["mSpezialDockBaground"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["border"] = true
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["frameStrata"] = "MEDIUM"
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["growth"] = "HORIZONTAL"
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["height"] = 42
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["name"] = "mSpezialDockLeft"
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["numPoints"] = 4
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mSpezialDockLeft"]["width"] = 200

	E.db["datatexts"]["panels"]["mSpezialDockLeft"][1] = "mCharacter"
	E.db["datatexts"]["panels"]["mSpezialDockLeft"][2] = "mItemLevel"
	E.db["datatexts"]["panels"]["mSpezialDockLeft"][3] = "mGuild"
	E.db["datatexts"]["panels"]["mSpezialDockLeft"][4] = "mFriends"
	E.db["datatexts"]["panels"]["mSpezialDockLeft"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["border"] = true
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["frameStrata"] = "MEDIUM"
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["growth"] = "HORIZONTAL"
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["height"] = 42
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["name"] = "mSpezialDockRight"
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["numPoints"] = 4
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mSpezialDockRight"]["width"] = 200

	E.db["datatexts"]["panels"]["mSpezialDockRight"][1] = "mLFDTool"
	E.db["datatexts"]["panels"]["mSpezialDockRight"][2] = "mProfession"
	E.db["datatexts"]["panels"]["mSpezialDockRight"][3] = "mCollectionsJourna"
	E.db["datatexts"]["panels"]["mSpezialDockRight"][4] = "mMainMenu"
	E.db["datatexts"]["panels"]["mSpezialDockRight"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["border"] = true
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["fonts"]["fontSize"] = 24
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["frameStrata"] = "MEDIUM"
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["growth"] = "VERTICAL"
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["height"] = 21
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["name"] = "mSpezialDockTime"
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mSpezialDockTime"]["width"] = 100

	E.db["datatexts"]["panels"]["mSpezialDockTime"][1] = "Time"
	E.db["datatexts"]["panels"]["mSpezialDockTime"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["border"] = true
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["frameStrata"] = "MEDIUM"
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["growth"] = "VERTICAL"
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["height"] = 22
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["name"] = "mSpezialDockDate"
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mSpezialDockDate"]["width"] = 100

	E.db["datatexts"]["panels"]["mSpezialDockDate"][1] = "Date"
	E.db["datatexts"]["panels"]["mSpezialDockDate"]["enable"] = enable

	if top then
		E.db["movers"]["DTPanelmSpezialDockBagroundMover"] = "TOP,ElvUIParent,TOP,0,-4"
		E.db["movers"]["DTPanelmSpezialDockLeftMover"] = "TOP,ElvUIParent,TOP,-153,-7"
		E.db["movers"]["DTPanelmSpezialDockDateMover"] = "TOP,ElvUIParent,TOP,0,-32"
		E.db["movers"]["DTPanelmSpezialDockTimeMover"] = "TOP,ElvUIParent,TOP,0,-8"
		E.db["movers"]["DTPanelmSpezialDockRightMover"] = "TOP,ElvUIParent,TOP,152,-7"
	else
		E.db["movers"]["DTPanelmSpezialDockBagroundMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
		E.db["movers"]["DTPanelmSpezialDockLeftMover"] = "BOTTOM,ElvUIParent,BOTTOM,-153,7"
		E.db["movers"]["DTPanelmSpezialDockDateMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
		E.db["movers"]["DTPanelmSpezialDockTimeMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,28"
		E.db["movers"]["DTPanelmSpezialDockRightMover"] = "BOTTOM,ElvUIParent,BOTTOM,152,7"
	end

	E:StaggeredUpdateAll(nil, true)
end
