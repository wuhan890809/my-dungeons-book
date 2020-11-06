--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Damage Done By Party Members tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:DamageDoneByPartyMembersFrame_Create(parentFrame, challengeId)
    local damageDoneByPartyMembersFrame = self:TabContentWrapperWidget_Create(parentFrame);
    damageDoneByPartyMembersFrame.tabButtonsFrame = self:DamageDoneByPartyMembersFrame_CreateTabButtonsFrame(damageDoneByPartyMembersFrame, challengeId);
    damageDoneByPartyMembersFrame.tabButtonsFrame:SelectTab("player");
    return damageDoneByPartyMembersFrame;
end
