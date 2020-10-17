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
@return[type=Frame]
]]
function MyDungeonsBook:OwnCastsByPartyMembersFrame_Create(parentFrame)
    local ownCastsByPartyMembersFrame = CreateFrame("Frame", nil, parentFrame);
    ownCastsByPartyMembersFrame:SetPoint("TOPLEFT", 0, -30);
    ownCastsByPartyMembersFrame:SetWidth(900);
    ownCastsByPartyMembersFrame:SetHeight(650);
    ownCastsByPartyMembersFrame.tabButtonsFrame = self:OwnCastsByPartyMembersFrame_CreateTabButtonsFrame(ownCastsByPartyMembersFrame);
    ownCastsByPartyMembersFrame.tabs = {};
    for _, unitId in pairs(self:GetPartyRoster()) do
        ownCastsByPartyMembersFrame[unitId] = self:OwnCastsByPartyMemberFrame_Create(ownCastsByPartyMembersFrame, unitId);
        ownCastsByPartyMembersFrame.tabs[unitId] = ownCastsByPartyMembersFrame[unitId];
    end
    ownCastsByPartyMembersFrame:Hide();
    return ownCastsByPartyMembersFrame;
end

--[[--
Updates a Own Casts By Party Members frame with data for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:OwnCastsByPartyMembersFrame_Update(challengeId)
    for _, unitId in pairs(self:GetPartyRoster()) do
        self:OwnCastsByPartyMemberFrame_Update(challengeId, unitId);
        self.challengeDetailsFrame.mechanicsFrame.castsFrame.ownCastsFrame.tabButtonsFrame.tabButtons[unitId]:SetText(self:GetNameByPartyUnit(challengeId, unitId));
    end
    self:Tab_Click(self.challengeDetailsFrame.mechanicsFrame.castsFrame.ownCastsFrame, "player");
end
