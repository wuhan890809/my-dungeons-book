--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Casts frame.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:CastsFrame_CreateTabButtonsFrame(parentFrame)
	local tabs = self:TabsWidget_Create(parentFrame);
	tabs:SetTabs({
		{value = "interrupts", text = L["Interrupts"]},
		{value = "specialCasts", text = L["Special Casts"]},
		{value = "ownCasts", text = L["Own Casts"]}
	});
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		if (tabId == "interrupts") then
			self:InterruptsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "specialCasts") then
			self:SpecialCastsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "ownCasts") then
			self:OwnCastsByPartyMembersFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(538);
	return tabs;
end
