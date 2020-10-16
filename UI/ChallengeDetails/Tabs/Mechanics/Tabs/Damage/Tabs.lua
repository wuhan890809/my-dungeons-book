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
	return self:Tabs_Create(parentFrame, {
		{id = "avoidableDamage", title = L["Avoidable Damage"]},
		{id = "damageDoneToPartyMembers", title = L["All damage taken"]},
		{id = "damageDoneToUnits", title = L["Damage Done To Units"]},
	});
end
