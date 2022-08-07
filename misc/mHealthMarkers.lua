local E, L, V, P, G = unpack(ElvUI)
local mPlugin = "mMediaTag"
local mMT = E:GetModule(mPlugin)
local NP = E:GetModule("NamePlates")
local UF = E:GetModule("UnitFrames")
local addon, ns = ...

local mlifePercent = {
	--토르가스트
	[179526] = { 66, 33 }, -- 폭군 트로즈이갈
	[176578] = { 66, 33 }, -- 금고 수호자

	--쐐기
	[164451] = { 40 }, -- 데시아
	[164461] = { 40 }, -- 사델
	[165946] = { 50 }, -- 모르드레타
	[164218] = { 70, 40 }, -- 시종장
	[162061] = { 70, 30 }, -- 데보스
	[164804] = { 20 }, -- 수풀사령관 울파란
	[164501] = { 70, 40, 10 }, -- 미스트콜러
	[164517] = { 70, 40 }, -- 트레도바
	[164967] = { 66, 33 }, --의사 이커스
	[169861] = { 66, 33 }, -- 이코르 바일플래시
	[164267] = { 66, 33 }, --후작 스트라디마
	[164555] = { 10 }, -- 마나스톰 부부
	[164556] = { 10 },
	[166608] = { 10.5 }, -- 무에젤라
	[162689] = { 5 }, -- 스티치플레시
	[162133] = { 90, 80, 70 }, -- 장군 카알
	[162099] = { 50 },
	[176555] = { 40 }, -- 알크룩스
	[176556] = { 40 }, -- 아칠라이트
	[175806] = { 70, 40 }, -- 소아즈미

	[164562] = { 50 }, -- 타락한 사냥개조련사
	[164921] = { 80 }, -- 드러스트 수확자
	[164929] = { 20 }, -- 티르넨 주민
	[164926] = { 50 }, -- 드러스트 가지파괴자
	[170572] = { 50 }, -- 아탈라이 어둠마법 사술사
	[167965] = { 50 }, -- 윤활유 도포기

	[178139] = { 50, 15 }, -- 진흙소금 껍질분쇄자
	[163892] = { 30 }, -- 썩어가는 끈적손톱
	[170490] = { 15 }, -- 아탈라이 대사제
	[178133] = { 15 }, -- 진흙소금 파도도약꾼
	[178141] = { 15 }, -- 진흙소금 비늘결속자
	[178142] = { 15 }, -- 진흙소금 생선술사
	[180015] = { 50 }, -- 건장한 갑판원
	[180432] = { 40 }, -- 헌신적인 동조자
	--레이드
	[180773] = { 15.5 }, -- 경계하는 수호자
	[183501] = { 75.5, 50.5, 30.5 }, -- 자이목스
	[181548] = { 40.5 }, -- 면죄
	[181551] = { 40.5 }, -- 책무
	[181546] = { 40.5 }, -- 소생
	[181549] = { 40.5 }, -- 전쟁
	[180906] = { 78.5, 45.5 }, -- 할론드루스
	[183671] = { 35.5 }, -- 흉측한 영혼
}

function mMT:UpdateMarkers()
	hooksecurefunc(NP, "Health_UpdateColor", function(m, unit)
		--if not unit or self.unit ~= unit then return end
		local nameplate = m.Health
		print("xxx")
		print(m)
		print(unit)
		if nameplate then
			print(self.unitGUID)
			local markersTable = mlifePercent[self.unitGUID]
			if markersTable then
				local unitLifePercent = nameplate.Health:GetValue() / 100
				for i, percent in ipairs(markersTable) do
					percent = percent / 100
					if unitLifePercent > percent then
						local healthBar = nameplate.Health
						local overlaySize = healthBar:GetWidth() * percent

						if not nameplate.healthMarker then
							nameplate.healthMarker = healthBar:CreateTexture(nil, "overlay")
							nameplate.healthMarker:SetColorTexture(1, 1, 1)
							nameplate.healthOverlay = healthBar:CreateTexture(nil, "overlay")
							nameplate.healthOverlay:SetColorTexture(1, 1, 1)
						end

						nameplate.healthMarker:Show()
						nameplate.healthMarker:SetSize(1, healthBar:GetHeight())
						nameplate.healthMarker:SetPoint("left", healthBar, "left", overlaySize, 0)
						nameplate.healthMarker:SetVertexColor(1, 1, 1)

						nameplate.healthOverlay:Show()
						nameplate.healthOverlay:SetSize(overlaySize, healthBar:GetHeight())
						nameplate.healthOverlay:SetPoint("right", nameplate.healthMarker, "left", 0, 0)
						nameplate.healthOverlay:SetVertexColor(1, 1, 1)
						nameplate.healthOverlay:SetAlpha(0.5)
						return
					end
				end

				if nameplate.healthMarker then
					nameplate.healthMarker:Hide()
					nameplate.healthOverlay:Hide()
				end
			end
		end
	end)
end
