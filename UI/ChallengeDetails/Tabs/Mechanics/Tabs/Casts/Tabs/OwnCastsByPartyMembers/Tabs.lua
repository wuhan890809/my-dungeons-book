--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates tabs (with click-handlers) for Own Casts frame.

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `ownCastsFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:OwnCastsByPartyMembersFrame_CreateTabButtonsFrame(parentFrame)
    return self:Tabs_Create(parentFrame, {
        {id = "player", title = "Player"},
        {id = "party1", title = "Party1"},
        {id = "party2", title = "Party2"},
        {id = "party3", title = "Party3"},
        {id = "party4", title = "Party4"},
    });
end
