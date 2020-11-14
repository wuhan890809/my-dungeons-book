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

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreateTabButtonsFrame(parentFrame)
	local tabs = self:TabsWidget_Create(parentFrame);
	local tabsConfig = {
		{value = "roster", text = L["Roster"]},
		{value = "summary", text = L["Summary"]},
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
			self.rosterFrame = self:RosterFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "summary") then
			self.summaryFrame = self:SummaryFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "encounters") then
			self.encountersFrame = self:EncountersFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "dev") then
			self.devFrame = self:DevFrame_Create(container, self.activeChallengeId);
		end
		if (tabId == "mechanics") then
			self.mechanicsFrame = self:MechanicsFrame_Create(container, self.activeChallengeId);
		end
	end);
	tabs:SetHeight(618);
	return tabs;
end
