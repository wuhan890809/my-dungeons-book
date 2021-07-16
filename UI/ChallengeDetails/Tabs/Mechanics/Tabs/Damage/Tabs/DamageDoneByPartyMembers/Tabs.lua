--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates tabs (with click-handlers) for Own Casts frame.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:DamageDoneByPartyMembersFrame_CreateTabButtonsFrame(parentFrame, challengeId)
	local tabs = self:TabsWidget_Create(parentFrame);
	local tabsConfig = {};
	local challenge = self:Challenge_GetById(challengeId);
	for _, unitId in pairs(self:GetPartyRoster()) do
		tinsert(tabsConfig, {value = unitId, text = self:GetUnitNameRoleStr(challenge.players[unitId])});
	end
	tabs:SetTabs(tabsConfig);
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		self:DamageDoneByPartyMemberFrame_Create(container, self.activeChallengeId, tabId);
	end);
	tabs:SetHeight(550);
	return tabs;
end
