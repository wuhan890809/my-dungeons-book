--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates a frame for Own Casts By Party Members tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:OwnCastsByPartyMembersFrame_Create(parentFrame, challengeId)
    local ownCastsByPartyMembersFrame, descriptionLabel = self:TabContentWrapperWidget_Create(parentFrame);
    descriptionLabel.label:SetHeight(25);
    descriptionLabel:SetText(L["All casts done by party members. Some important spells are tracked with time and target."]);
    ownCastsByPartyMembersFrame.tabButtonsFrame = self:OwnCastsByPartyMembersFrame_CreateTabButtonsFrame(ownCastsByPartyMembersFrame, challengeId);
    ownCastsByPartyMembersFrame.tabButtonsFrame:SelectTab("player");
    return ownCastsByPartyMembersFrame;
end
