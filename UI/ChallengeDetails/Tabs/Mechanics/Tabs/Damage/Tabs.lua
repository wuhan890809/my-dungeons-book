--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Damage frame.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:DamageFrame_CreateTabButtonsFrame(parentFrame)
	local tabs = self:TabsWidget_Create(parentFrame);
	tabs:SetTabs({
		{value = "damageDoneToPartyMembers", text = L["All damage taken"]},
		{value = "damageDoneByPartyMembers", text = L["All damage done"]},
		{value = "damageDoneToUnits", text = L["Damage Done To Units"]},
		{value = "friendlyFire", text = L["Friendly Fire"]},
		{value = "enemiesFriendlyFire", text = L["Enemies Friendly Fire"]},
	});
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		if (tabId == "damageDoneToPartyMembers") then
			self.damageDoneToPartyMembersFrame = self:DamageDoneToPartyMembersFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "damageDoneByPartyMembers") then
			self.damageDoneByPartyMembersFrame = self:DamageDoneByPartyMembersFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "damageDoneToUnits") then
			self.damageDoneToUnitsFrame = self:DamageDoneToUnitsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "friendlyFire") then
			self.friendlyFireFrame = self:FriendlyFireFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "enemiesFriendlyFire") then
			self.enemiesFriendlyFireFrame = self:EnemiesFriendlyFireFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(586);
	return tabs;
end
