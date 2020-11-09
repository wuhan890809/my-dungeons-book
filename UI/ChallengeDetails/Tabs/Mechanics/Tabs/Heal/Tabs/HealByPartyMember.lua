--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Healing tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=Frame]
]]
function MyDungeonsBook:HealByPartyMemberFrame_Create(parentFrame, challengeId, unitId)
    local healByPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    healByPartyMemberFrame.tabButtonsFrame = self:HealByPartyMemberFrame_CreateTabButtonsFrame(healByPartyMemberFrame, unitId);
    healByPartyMemberFrame.tabButtonsFrame:SelectTab("bySpell");
    return healByPartyMemberFrame;
end
