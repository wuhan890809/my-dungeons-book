--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local AceGUI = LibStub("AceGUI-3.0");

--[[--
Creates a frame for Equipment tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:TalentsFrame_Create(parentFrame, challengeId)
    local equipmentFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local challenge = self.db.char.challenges[challengeId];
    if (not challenge) then
        return;
    end
    for _, unit in pairs(self:GetPartyRoster()) do
        local partyMemberFrame = AceGUI:Create("InlineGroup");
        partyMemberFrame:SetLayout("Flow");
        partyMemberFrame:SetFullWidth(true);
        equipmentFrame:AddChild(partyMemberFrame);
        local challenge = self.db.char.challenges[challengeId];
        partyMemberFrame:SetTitle(self:GetUnitNameRealmRoleStr(challenge.players[unit]) or L["Not Found"]);
        self:TalentsFrame_PartyMember_Create(partyMemberFrame, unit, challengeId);
    end
    return equipmentFrame;
end


--[[--
Creates a frame with `unitId`'s talents.

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
]]
function MyDungeonsBook:TalentsFrame_PartyMember_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
    local talents = self:SafeNestedGet(challenge.players, unitId, "talents");
    if (not talents) then
        return;
    end
    local talentsInfo = {};
    for _, v in pairs(talents) do tinsert(talentsInfo, v) end
    table.sort(talentsInfo, function (t1, t2)
        return t1.tier < t2.tier;
    end);
    local suffix = self:GetIconTextureSuffix(30);
    for _, talent in pairs(talentsInfo) do
        local talentFrame = AceGUI:Create("InteractiveLabel");
        local spellId = talent.spell_id;
        local icon = talent.icon;
        talentFrame:SetText("|T".. icon .. suffix .."|t");
        talentFrame:SetWidth(35);
        talentFrame:SetCallback("OnEnter", function()
            self:Table_Cell_SpellMouseHover(talentFrame.frame, spellId);
        end);
        talentFrame:SetCallback("OnLeave", function()
            self:Table_Cell_MouseOut();
        end);
        parentFrame:AddChild(talentFrame);
    end
end
