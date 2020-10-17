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
	return self:Tabs_Create(parentFrame, {
		{id = "roster", title = L["Roster"]},
		{id = "details", title = L["Details"]},
		{id = "encounters", title = L["Encounters"]},
		{id = "mechanics", title = L["Mechanics"]},
		{id = "dev", title = L["DEV"]}
	});
end
