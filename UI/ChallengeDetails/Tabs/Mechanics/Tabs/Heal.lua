--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Heal By Party Members tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:HealByPartyMembersFrame_Create(parentFrame, challengeId)
    local healByPartyMembersFrame = self:TabContentWrapperWidget_Create(parentFrame);
    healByPartyMembersFrame.tabButtonsFrame = self:HealByPartyMembersFrame_CreateTabButtonsFrame(healByPartyMembersFrame, challengeId);
    healByPartyMembersFrame.tabButtonsFrame:SelectTab("player");
    return healByPartyMembersFrame;
end
