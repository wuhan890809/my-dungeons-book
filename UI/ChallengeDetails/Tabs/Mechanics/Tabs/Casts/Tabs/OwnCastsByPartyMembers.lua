--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Own Casts By Party Members tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:OwnCastsByPartyMembersFrame_Create(parentFrame, challengeId)
    local ownCastsByPartyMembersFrame = self:TabContentWrapperWidget_Create(parentFrame);
    ownCastsByPartyMembersFrame.tabButtonsFrame = self:OwnCastsByPartyMembersFrame_CreateTabButtonsFrame(ownCastsByPartyMembersFrame, challengeId);
    ownCastsByPartyMembersFrame.tabButtonsFrame:SelectTab("player");
    return ownCastsByPartyMembersFrame;
end
