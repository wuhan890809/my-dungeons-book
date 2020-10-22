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

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `casts.tabs`.

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
	end)
	tabs:SetHeight(546);
	return tabs;
end
