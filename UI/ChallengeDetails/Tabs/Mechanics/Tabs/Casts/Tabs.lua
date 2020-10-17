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
    return self:Tabs_Create(parentFrame, {
        {id = "interrupts", title = L["Interrupts"]},
        {id = "specialCasts", title = L["Special Casts"]},
        {id = "ownCasts", title = L["Own Casts"]},
    });
end
