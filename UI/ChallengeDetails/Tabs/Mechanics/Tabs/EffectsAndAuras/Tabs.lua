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
		{value = "allBuffsAndDebuffsOnPartyMembers", text = L["All Buffs & Debuffs"]},
		{value = "buffsOrDebuffsOnUnits", text = L["Buffs Or Debuffs On Units"]},
		{value = "brokenAuras", text = L["Broken Auras"]},
	});
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		if (tabId == "dispels") then
			self.dispelsFrame = self:DispelsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "avoidableDebuffs") then
			self.avoidableDebuffsFrame = self:AvoidableDebuffsFrame_Create(container, self.activeChallengeId);
		end
        if (tabId == "allBuffsAndDebuffsOnPartyMembers") then
            self.allBuffsAndDebuffsOnPartyMembersFrame = self:AllBuffsAndDebuffsOnPartyMembersFrame_Create(container, self.activeChallengeId);
        end
		if (tabId == "buffsOrDebuffsOnUnits") then
			self.buffsOrDebuffsOnUnitsFrame = self:BuffsOrDebuffsOnUnitsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "brokenAuras") then
			self.brokenAurasFrame = self:BrokenAurasFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(586);
	return tabs;
end
