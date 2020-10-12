--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Mechanics frame.

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `mechanicsFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:MechanicsFrame_CreateTabButtonsFrame(parentFrame)
	return self:Tabs_Create(parentFrame, {
		{id = "specialCasts", title = L["Special Casts"]},
		{id = "usedItems", title = L["Used Items"]},
		{id = "damage", title = L["Damage"]},
		{id = "effectsAndAuras", title = L["Effects and Auras"]}
	});
end
