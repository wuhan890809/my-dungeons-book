--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:AllBuffsAndDebuffsOnPartyMembersFrame_Create(parentFrame, challengeId)
    local allBuffsAndDebuffsOnPartyMembersFrame = self:TabContentWrapperWidget_Create(parentFrame);
    allBuffsAndDebuffsOnPartyMembersFrame.tabButtonsFrame = self:AllBuffsAndDebuffsOnPartyMembersFrame_CreateTabButtonsFrame(allBuffsAndDebuffsOnPartyMembersFrame, challengeId);
    allBuffsAndDebuffsOnPartyMembersFrame.tabButtonsFrame:SelectTab("player");
    return allBuffsAndDebuffsOnPartyMembersFrame;
end
