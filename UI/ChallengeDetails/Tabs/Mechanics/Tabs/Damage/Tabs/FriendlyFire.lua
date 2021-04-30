--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for friendly fire

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:FriendlyFireFrame_Create(parentFrame, challengeId)
    local friendlyFireFrame = self:TabContentWrapperWidget_Create(parentFrame);
    friendlyFireFrame.tabButtonsFrame = self:FriendlyFireFrame_CreateTabButtonsFrame(friendlyFireFrame, challengeId);
    friendlyFireFrame.tabButtonsFrame:SelectTab("player");
    return friendlyFireFrame;
end
