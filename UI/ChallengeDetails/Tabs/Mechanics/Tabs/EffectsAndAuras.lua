--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Effects And Auras tab

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:EffectsAndAurasFrame_Create(parentFrame)
	local effectsAndAurasFrame = CreateFrame("Frame", nil, parentFrame);
	effectsAndAurasFrame:SetPoint("TOPLEFT", 0, -30);
	effectsAndAurasFrame:SetWidth(900);
	effectsAndAurasFrame:SetHeight(650);
	effectsAndAurasFrame.tabButtonsFrame = self:EffectsAndAurasFrame_CreateTabButtonsFrame(effectsAndAurasFrame);
	effectsAndAurasFrame.buffsOrDebuffsOnUnitsFrame = self:BuffsOrDebuffsOnUnitsFrame_Create(effectsAndAurasFrame);
	effectsAndAurasFrame.buffsOrDebuffsOnPartyMembersFrame = self:BuffsOrDebuffsOnPartyMembersFrame_Create(effectsAndAurasFrame);
	effectsAndAurasFrame.avoidableDebuffsFrame = self:AvoidableDebuffsFrame_Create(effectsAndAurasFrame);
	effectsAndAurasFrame.allBuffsOnPartyMembersFrame = self:AllBuffsOnPartyMemberFrame_Create(effectsAndAurasFrame);
	effectsAndAurasFrame.allDebuffsOnPartyMembersFrame = self:AllDebuffsOnPartyMemberFrame_Create(effectsAndAurasFrame);
	effectsAndAurasFrame.dispelsFrame = self:DispelsFrame_Create(effectsAndAurasFrame);
	effectsAndAurasFrame.tabs = {
		avoidableDebuffs = effectsAndAurasFrame.avoidableDebuffsFrame,
		buffsOrDebuffsOnUnits = effectsAndAurasFrame.buffsOrDebuffsOnUnitsFrame,
		buffsOrDebuffsOnPartyMembers = effectsAndAurasFrame.buffsOrDebuffsOnPartyMembersFrame,
		allBuffsOnPartyMembers = effectsAndAurasFrame.allBuffsOnPartyMembersFrame,
		allDebuffsOnPartyMembers = effectsAndAurasFrame.allDebuffsOnPartyMembersFrame,
		dispels = effectsAndAurasFrame.dispelsFrame
	};
	effectsAndAurasFrame:Hide();
	return effectsAndAurasFrame;
end

--[[--
Updates a Effects And Auras frame with data for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:EffectsAndAurasFrame_Update(challengeId)
	self:BuffsOrDebuffsOnUnitsFrame_Update(challengeId);
	self:BuffsOrDebuffsOnPartyMembersFrame_Update(challengeId);
	self:AvoidableDebuffsFrame_Update(challengeId);
	self:AllBuffsOnPartyMemberFrame_Update(challengeId);
	self:AllDebuffsOnPartyMemberFrame_Update(challengeId);
	self:DispelsFrame_Update(challengeId);
	self:Tab_Click(self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame, "dispels");
end
