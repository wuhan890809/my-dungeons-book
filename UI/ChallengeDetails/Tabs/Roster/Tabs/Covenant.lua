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
function MyDungeonsBook:CovenantFrame_Create(parentFrame, challengeId)
    local covenantFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local challenge = self.db.char.challenges[challengeId];
    if (not challenge) then
        return;
    end
    for _, unit in pairs(self:GetPartyRoster()) do
        local partyMemberFrame = AceGUI:Create("InlineGroup");
        partyMemberFrame:SetLayout("Flow");
        partyMemberFrame:SetFullWidth(true);
        covenantFrame:AddChild(partyMemberFrame);
        local challenge = self.db.char.challenges[challengeId];
        partyMemberFrame:SetTitle(self:GetUnitNameRealmRoleStr(challenge.players[unit]) or L["Not Found"]);
        self:CovenantFrame_PartyMember_Create(partyMemberFrame, unit, challengeId);
    end
    return covenantFrame;
end


--[[--
Creates a frame with `unitId`'s covenant.

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
]]
function MyDungeonsBook:CovenantFrame_PartyMember_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
    local unitCovenantInfo = challenge.players[unitId] and challenge.players[unitId].covenant;
    if (not unitCovenantInfo or not unitCovenantInfo.id) then
        local helpLabel = AceGUI:Create("Label");
        helpLabel:SetText(L["Covenant info is available only about players with installed MyDungeonsBook."]);
        helpLabel:SetFullWidth(true);
        parentFrame:AddChild(helpLabel);
        return;
    end
    local id = unitCovenantInfo.id;
    local covenantIconFrame = AceGUI:Create("InteractiveLabel");
    parentFrame:AddChild(covenantIconFrame);
    local covenantMetaInfo = C_Covenants.GetCovenantData(unitCovenantInfo.id);
    local suffix = self:GetIconTextureSuffix(30);
    covenantIconFrame:SetText("|T" .. self:GetCovenantIconId(id) .. suffix .. "|t");
    covenantIconFrame:SetCallback("OnEnter", function()
        GameTooltip:SetOwner(covenantIconFrame.frame, "ANCHOR_NONE");
        GameTooltip:SetPoint("BOTTOMLEFT", covenantIconFrame.frame, "BOTTOMRIGHT");
        GameTooltip:AddLine(covenantMetaInfo.name, 1, 1, 1);
        GameTooltip:Show();
    end);
    covenantIconFrame:SetCallback("OnLeave", function()
        self:Table_Cell_MouseOut();
    end);
    covenantIconFrame:SetWidth(35);
    local soulbindFrame = AceGUI:Create("Label");
    soulbindFrame:SetText(unitCovenantInfo.soulbind.name);
    soulbindFrame:SetWidth(260);
    parentFrame:AddChild(soulbindFrame);
    table.sort(unitCovenantInfo.soulbind.conduits, function (c1, c2)
        return c1.row < c2.row;
    end);
    for _, conduit in pairs(unitCovenantInfo.soulbind.conduits) do
        local conduitFrame = AceGUI:Create("InteractiveLabel");
        local spellId = conduit.spellID;
        local icon = conduit.icon;
        if (spellId == 0 and conduit.conduitID ~= 0) then
            spellId = C_Soulbinds.GetConduitSpellID(conduit.conduitID, conduit.conduitRank);
        end
        if (conduit.conduitID ~= 0) then
            icon = select(3, GetSpellInfo(spellId));
        end
        conduitFrame:SetText("|T".. icon .. suffix .."|t");
        conduitFrame:SetWidth(35);
        conduitFrame:SetCallback("OnEnter", function()
            GameTooltip:SetOwner(conduitFrame.frame, "ANCHOR_NONE");
            GameTooltip:SetPoint("BOTTOMLEFT", conduitFrame.frame, "BOTTOMRIGHT");
            if (conduit.conduitID == 0) then
                GameTooltip:SetSpellByID(spellId);
            else
                GameTooltip:SetHyperlink(C_Soulbinds.GetConduitHyperlink(conduit.conduitID, conduit.conduitRank));
            end
            GameTooltip:Show();
        end);
        conduitFrame:SetCallback("OnLeave", function()
            self:Table_Cell_MouseOut();
        end);
        parentFrame:AddChild(conduitFrame);
    end
end
