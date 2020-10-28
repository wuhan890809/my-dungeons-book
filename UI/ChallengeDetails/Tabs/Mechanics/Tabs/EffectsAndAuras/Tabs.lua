--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Effects And Auras frame.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:EffectsAndAurasFrame_CreateTabButtonsFrame(parentFrame)
	local tabs = self:TabsWidget_Create(parentFrame);
	tabs:SetTabs({
		{value = "dispels", text = L["Dispels"]},
		{value = "avoidableDebuffs", text = L["Avoidable Debuffs"]},
		{value = "allDebuffsOnPartyMembers", text = L["All Debuffs"]},
		{value = "allBuffsOnPartyMembers", text = L["All Buffs"]},
		{value = "buffsOrDebuffsOnPartyMembers", text = L["Special Buffs Or Debuffs"]},
		{value = "buffsOrDebuffsOnUnits", text = L["Buffs Or Debuffs On Units"]}
	});
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		if (tabId == "dispels") then
			self:DispelsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "avoidableDebuffs") then
			self:AvoidableDebuffsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "allDebuffsOnPartyMembers") then
			self:AllDebuffsOnPartyMemberFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "allBuffsOnPartyMembers") then
			self:AllBuffsOnPartyMemberFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "buffsOrDebuffsOnPartyMembers") then
			self:BuffsOrDebuffsOnPartyMembersFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "buffsOrDebuffsOnUnits") then
			self:BuffsOrDebuffsOnUnitsFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(546);
	return tabs;
end
