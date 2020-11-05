--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates a frame for Heal By Party Members tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:HealByPartyMembersFrame_Create(parentFrame, challengeId)
    local healByPartyMembersFrame, descriptionLabel = self:TabContentWrapperWidget_Create(parentFrame);
    descriptionLabel.label:SetHeight(25);
    descriptionLabel:SetText(L["Healing done by each party member for all party members."]);
    healByPartyMembersFrame.tabButtonsFrame = self:HealByPartyMembersFrame_CreateTabButtonsFrame(healByPartyMembersFrame, challengeId);
    healByPartyMembersFrame.tabButtonsFrame:SelectTab("player");
    return healByPartyMembersFrame;
end
