local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

function MyDungeonsBook:CreateMechanicsFrame(parentFrame)
	local mechanicsFrame = CreateFrame("Frame", nil, parentFrame);
	mechanicsFrame:SetPoint("TOPRIGHT", -10, -30);
	mechanicsFrame:SetWidth(900);
	mechanicsFrame:SetHeight(650);
	mechanicsFrame.tabButtonsFrame = self:ChallengeDetailsFrame_Mechanics_CreateTabButtonsFrame(mechanicsFrame);
	mechanicsFrame.specialCastsFrame = self:CreateSpecialCastsFrame(mechanicsFrame);
	mechanicsFrame.damageDoneToUnitsFrame = self:CreateDamageDoneToUnitsFrame(mechanicsFrame);
	mechanicsFrame.buffsOrDebuffsOnUnitsFrame = self:CreateBuffsOrDebuffsOnUnitsFrame(mechanicsFrame);
	mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame = self:CreateBuffsOrDebuffsOnPartyMembersFrame(mechanicsFrame);
	mechanicsFrame.tabs = {
		specialCasts = mechanicsFrame.specialCastsFrame,
		damageDoneToUnits = mechanicsFrame.damageDoneToUnitsFrame,
		buffsOrDebuffsOnUnits = mechanicsFrame.buffsOrDebuffsOnUnitsFrame,
		buffsOrDebuffsOnPartyMembers = mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame
	};
	mechanicsFrame:Hide();
	return mechanicsFrame;
end

function MyDungeonsBook:UpdateMechanicsFrame(challengeId)
	self:UpdateSpecialCastsFrame(challengeId);
	self:UpdateDamageDoneToUnitsFrame(challengeId);
	self:UpdateBuffsOrDebuffsOnUnitsFrame(challengeId);
	self:UpdateBuffsOrDebuffsOnPartyMembersFrame(challengeId);
	self:ChallengeDetailsFrame_Mechanics_ShowTab("specialCasts");
end