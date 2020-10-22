--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for ChallengeDetails frame.

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `challengeDetailsFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreateTabButtonsFrame(parentFrame)
	local tabs = self:TabsWidget_Create(parentFrame);
	local tabsConfig = {
		{value = "roster", text = L["Roster"]},
		{value = "details", text = L["Details"]},
		{value = "encounters", text = L["Encounters"]},
		{value = "mechanics", text = L["Mechanics"]}
	};
	if (self.db.profile.performance.showdevtab) then
		tinsert(tabsConfig, {value = "dev", text = L["DEV"]});
	end
	tabs:SetTabs(tabsConfig);
	tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
		container:ReleaseChildren();
		if (tabId == "roster") then
			self:RosterFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "details") then
			self:DetailsFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "encounters") then
			self:EncountersFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "dev") then
			self:DevFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "mechanics") then
			self:MechanicsFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(618);
	return tabs;
end
