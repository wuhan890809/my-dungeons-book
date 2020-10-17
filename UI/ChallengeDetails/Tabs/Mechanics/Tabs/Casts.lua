--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Casts tab

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:CastsFrame_Create(parentFrame)
    local castsFrame = CreateFrame("Frame", nil, parentFrame);
    castsFrame:SetPoint("TOPLEFT", 0, -30);
    castsFrame:SetWidth(900);
    castsFrame:SetHeight(650);
    castsFrame.tabButtonsFrame = self:CastsFrame_CreateTabButtonsFrame(castsFrame);
    castsFrame.specialCastsFrame = self:SpecialCastsFrame_Create(castsFrame);
    castsFrame.ownCastsFrame = self:OwnCastsByPartyMembersFrame_Create(castsFrame);
    castsFrame.interruptsFrame = self:InterruptsFrame_Create(castsFrame);
    castsFrame.tabs = {
        interrupts = castsFrame.interruptsFrame,
        specialCasts = castsFrame.specialCastsFrame,
        ownCasts = castsFrame.ownCastsFrame
    };
    castsFrame:Hide();
    return castsFrame;
end

--[[--
Updates a Casts frame with data for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:CastsFrame_Update(challengeId)
    self:InterruptsFrame_Update(challengeId);
    self:SpecialCastsFrame_Update(challengeId);
    self:OwnCastsByPartyMembersFrame_Update(challengeId);
    self:Tab_Click(self.challengeDetailsFrame.mechanicsFrame.castsFrame, "interrupts");
end
