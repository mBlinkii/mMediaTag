local E = unpack(ElvUI)

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

function mMT:mDockSpecial(top, enable)
	E.DataTexts:BuildPanelFrame("mspecialDockBaground")
	E.DataTexts:BuildPanelFrame("mspecialDockLeft")
	E.DataTexts:BuildPanelFrame("mspecialDockRight")
	E.DataTexts:BuildPanelFrame("mspecialDockTime")
	E.DataTexts:BuildPanelFrame("mspecialDockDate")

	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["backdrop"] = true
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["border"] = true
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["frameStrata"] = "LOW"
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["growth"] = "HORIZONTAL"
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["height"] = 48
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["name"] = "mspecialDockBaground"
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mspecialDockBaground"]["width"] = 505

	E.db["datatexts"]["panels"]["mspecialDockBaground"][1] = ""
	E.db["datatexts"]["panels"]["mspecialDockBaground"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["border"] = true
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["frameStrata"] = "MEDIUM"
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["growth"] = "HORIZONTAL"
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["height"] = 42
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["name"] = "mspecialDockLeft"
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["numPoints"] = 4
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mspecialDockLeft"]["width"] = 200

	E.db["datatexts"]["panels"]["mspecialDockLeft"][1] = "mCharacter"
	E.db["datatexts"]["panels"]["mspecialDockLeft"][2] = "mItemLevel"
	E.db["datatexts"]["panels"]["mspecialDockLeft"][3] = "mGuild"
	E.db["datatexts"]["panels"]["mspecialDockLeft"][4] = "mFriends"
	E.db["datatexts"]["panels"]["mspecialDockLeft"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["border"] = true
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["frameStrata"] = "MEDIUM"
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["growth"] = "HORIZONTAL"
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["height"] = 42
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["name"] = "mspecialDockRight"
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["numPoints"] = 4
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mspecialDockRight"]["width"] = 200

	E.db["datatexts"]["panels"]["mspecialDockRight"][1] = "mLFDTool"
	E.db["datatexts"]["panels"]["mspecialDockRight"][2] = "mProfession"
	E.db["datatexts"]["panels"]["mspecialDockRight"][3] = "mCollectionsJourna"
	E.db["datatexts"]["panels"]["mspecialDockRight"][4] = "mMainMenu"
	E.db["datatexts"]["panels"]["mspecialDockRight"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["border"] = true
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["fonts"]["enable"] = true
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["fonts"]["font"] = "PT Sans Narrow"
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["fonts"]["fontSize"] = 24
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["frameStrata"] = "MEDIUM"
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["growth"] = "VERTICAL"
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["height"] = 21
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["name"] = "mspecialDockTime"
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mspecialDockTime"]["width"] = 100

	E.db["datatexts"]["panels"]["mspecialDockTime"][1] = "Time"
	E.db["datatexts"]["panels"]["mspecialDockTime"]["enable"] = enable

	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["backdrop"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["border"] = true
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["fonts"]["enable"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["fonts"]["fontOutline"] = "OUTLINE"
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["fonts"]["fontSize"] = 12
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["frameLevel"] = 1
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["frameStrata"] = "MEDIUM"
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["growth"] = "VERTICAL"
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["height"] = 22
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["mouseover"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["name"] = "mspecialDockDate"
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["numPoints"] = 1
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["textJustify"] = "CENTER"
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["tooltipAnchor"] = "ANCHOR_TOPLEFT"
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["tooltipXOffset"] = -17
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["tooltipYOffset"] = 4
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["visibility"] = "[petbattle] hide;show"
	E.global["datatexts"]["customPanels"]["mspecialDockDate"]["width"] = 100

	E.db["datatexts"]["panels"]["mspecialDockDate"][1] = "Date"
	E.db["datatexts"]["panels"]["mspecialDockDate"]["enable"] = enable

	if top then
		E.db["movers"]["DTPanelmspecialDockBagroundMover"] = "TOP,ElvUIParent,TOP,0,-4"
		E.db["movers"]["DTPanelmspecialDockLeftMover"] = "TOP,ElvUIParent,TOP,-153,-7"
		E.db["movers"]["DTPanelmspecialDockDateMover"] = "TOP,ElvUIParent,TOP,0,-32"
		E.db["movers"]["DTPanelmspecialDockTimeMover"] = "TOP,ElvUIParent,TOP,0,-8"
		E.db["movers"]["DTPanelmspecialDockRightMover"] = "TOP,ElvUIParent,TOP,152,-7"
	else
		E.db["movers"]["DTPanelmspecialDockBagroundMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
		E.db["movers"]["DTPanelmspecialDockLeftMover"] = "BOTTOM,ElvUIParent,BOTTOM,-153,7"
		E.db["movers"]["DTPanelmspecialDockDateMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,4"
		E.db["movers"]["DTPanelmspecialDockTimeMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,28"
		E.db["movers"]["DTPanelmspecialDockRightMover"] = "BOTTOM,ElvUIParent,BOTTOM,152,7"
	end

	E:StaggeredUpdateAll(nil, true)
end
