--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates a frame for Mechanics tab

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:MechanicsFrame_Create(parentFrame)
	local mechanicsFrame = CreateFrame("Frame", nil, parentFrame);
	mechanicsFrame:SetPoint("TOPRIGHT", -10, -30);
	mechanicsFrame:SetWidth(900);
	mechanicsFrame:SetHeight(650);
	mechanicsFrame.tabButtonsFrame = self:MechanicsFrame_CreateTabButtonsFrame(mechanicsFrame);
	mechanicsFrame.specialCastsFrame = self:SpecialCastsFrame_Create(mechanicsFrame);
	mechanicsFrame.damageDoneToUnitsFrame = self:DamageDoneToUnitsFrame_Create(mechanicsFrame);
	mechanicsFrame.buffsOrDebuffsOnUnitsFrame = self:BuffsOrDebuffsOnUnitsFrame_Create(mechanicsFrame);
	mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame = self:BuffsOrDebuffsOnPartyMembersFrame_Create(mechanicsFrame);
	mechanicsFrame.tabs = {
		specialCasts = mechanicsFrame.specialCastsFrame,
		damageDoneToUnits = mechanicsFrame.damageDoneToUnitsFrame,
		buffsOrDebuffsOnUnits = mechanicsFrame.buffsOrDebuffsOnUnitsFrame,
		buffsOrDebuffsOnPartyMembers = mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame
	};
	mechanicsFrame:Hide();
	return mechanicsFrame;
end

--[[--
Updates a Mechanics frame with data for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:MechanicsFrame_Update(challengeId)
	self:SpecialCastsFrame_Update(challengeId);
	self:DamageDoneToUnitsFrame_Update(challengeId);
	self:BuffsOrDebuffsOnUnitsFrame_Update(challengeId);
	self:BuffsOrDebuffsOnPartyMembersFrame_Update(challengeId);
	self:MechanicsFrame_ShowTab("specialCasts");
end