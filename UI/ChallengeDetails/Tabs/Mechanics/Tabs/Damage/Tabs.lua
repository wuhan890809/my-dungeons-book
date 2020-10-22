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

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `damageFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:DamageFrame_CreateTabButtonsFrame(parentFrame)
	local tabs = self:TabsWidget_Create(parentFrame);
	tabs:SetTabs({
		{value = "avoidableDamage", text = L["Avoidable Damage"]},
		{value = "damageDoneToPartyMembers", text = L["All damage taken"]},
		{value = "damageDoneToUnits", text = L["Damage Done To Units"]},
	});
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		if (tabId == "avoidableDamage") then
			self:AvoidableDamageFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "damageDoneToPartyMembers") then
			self:DamageDoneToPartyMembersFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "damageDoneToUnits") then
			self:DamageDoneToUnitsFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(546);
	return tabs;
end
