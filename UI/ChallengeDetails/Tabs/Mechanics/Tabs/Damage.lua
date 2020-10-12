--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Damage tab

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:DamageFrame_Create(parentFrame)
	local damageFrame = CreateFrame("Frame", nil, parentFrame);
	damageFrame:SetPoint("TOPRIGHT", 0, -30);
	damageFrame:SetWidth(900);
	damageFrame:SetHeight(650);
	damageFrame.tabButtonsFrame = self:DamageFrame_CreateTabButtonsFrame(damageFrame);
	damageFrame.damageDoneToUnitsFrame = self:DamageDoneToUnitsFrame_Create(damageFrame);
	damageFrame.damageDoneToPartyMembersFrame = self:DamageDoneToPartyMembersFrame_Create(damageFrame);
	damageFrame.avoidableDamageFrame = self:AvoidableDamageFrame_Create(damageFrame);
	damageFrame.tabs = {
		avoidableDamage = damageFrame.avoidableDamageFrame,
		damageDoneToUnits = damageFrame.damageDoneToUnitsFrame,
		damageDoneToPartyMembers = damageFrame.damageDoneToPartyMembersFrame,
	};
	damageFrame:Hide();
	return damageFrame;
end

--[[--
Updates a Damage frame with data for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:DamageFrame_Update(challengeId)
	self:DamageDoneToUnitsFrame_Update(challengeId);
	self:DamageDoneToPartyMembersFrame_Update(challengeId);
	self:AvoidableDamageFrame_Update(challengeId);
	self:DamageFrame_ShowTab("avoidableDamage");
end
