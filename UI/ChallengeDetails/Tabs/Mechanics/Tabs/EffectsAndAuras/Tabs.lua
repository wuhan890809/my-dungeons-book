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

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `damageFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:EffectsAndAurasFrame_CreateTabButtonsFrame(parentFrame)
	return self:Tabs_Create(parentFrame, {
		{id = "avoidableDebuffs", title = L["Avoidable Debuffs"]},
		{id = "buffsOrDebuffsOnUnits", title = L["Buffs Or Debuffs On Units"]},
		{id = "buffsOrDebuffsOnPartyMembers", title = L["Buffs Or Debuffs On Party Members"]},
		{id = "allBuffsOnPartyMembers", title = L["All Buffs On Party Members"]},
		{id = "allDebuffsOnPartyMembers", title = L["All Debuffs On Party Members"]}
	});
end