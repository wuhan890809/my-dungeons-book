--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Roster tab

@param[type=Frame] parentFrame
@return[type=Frame] rosterFrame
]]
function MyDungeonsBook:RosterFrame_Create(parentFrame)
    local rosterFrame = self:TabContentWrapperWidget_Create(parentFrame);
    rosterFrame.tabButtonsFrame = self:RosterFrame_CreateTabButtonsFrame(rosterFrame);
    rosterFrame.tabButtonsFrame:SelectTab("shortInfo");
    return rosterFrame;
end
