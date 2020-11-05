--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates a frame for Damage Done By Party Members tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:DamageDoneByPartyMembersFrame_Create(parentFrame, challengeId)
    local damageDoneByPartyMembersFrame, descriptionLabel = self:TabContentWrapperWidget_Create(parentFrame);
    descriptionLabel.label:SetHeight(25);
    descriptionLabel:SetText(L["All damage groped by spells done by party members."]);
    damageDoneByPartyMembersFrame.tabButtonsFrame = self:DamageDoneByPartyMembersFrame_CreateTabButtonsFrame(damageDoneByPartyMembersFrame, challengeId);
    damageDoneByPartyMembersFrame.tabButtonsFrame:SelectTab("player");
    return damageDoneByPartyMembersFrame;
end
