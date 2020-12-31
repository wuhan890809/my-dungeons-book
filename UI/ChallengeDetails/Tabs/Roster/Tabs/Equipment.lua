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
function MyDungeonsBook:EquipmentFrame_Create(parentFrame, challengeId)
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
        self:EquipmentFrame_PartyMember_Create(partyMemberFrame, unit, challengeId);
    end
    return equipmentFrame;
end

--[[--
Creates a frame with equipment for `unitId`.

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
]]
function MyDungeonsBook:EquipmentFrame_PartyMember_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
    for i = 1, 16 do
        local itemFrame = AceGUI:Create("InteractiveLabel");
        parentFrame:AddChild(itemFrame);
        itemFrame:SetWidth(35);
        itemFrame:SetCallback("OnEnter", function(frame)
            self:EquipmentFrame_TableItemHover(frame, unitId, i);
        end);
        itemFrame:SetCallback("OnLeave", function()
            self:Table_Cell_MouseOut();
        end);
        local itemFrameIndex;
        if (i <= 3) then
            itemFrameIndex = i;
        else
            itemFrameIndex = i - 1;
        end
        local itemString = challenge.players[unitId] and challenge.players[unitId].items and challenge.players[unitId].items[(i <= 3 and i) or i + 1] or nil;
        if (itemString) then
            local _, itemId = strsplit(":", itemString);
            if (itemId) then
                local suffix = self:GetIconTextureSuffix(30);
                itemFrame:SetText("|T" .. GetItemIcon(itemId) .. suffix .. "|t");
            end
        end
    end;
end


--[[--
Mouse-hover handler for equiped item.

Shows a tooltip with data from item.

@param[type=Frame] itemFrame
@param[type=unitId] unitId
@param[type=number] itemIndex
]]
function MyDungeonsBook:EquipmentFrame_TableItemHover(itemFrame, unitId, itemIndex)
    local realItemIndex = itemIndex;
    if (itemIndex > 3) then
        realItemIndex = realItemIndex + 1;
    end
    local player = self.db.char.challenges[self.activeChallengeId].players[unitId];
    local itemString = player.items and self.db.char.challenges[self.activeChallengeId].players[unitId].items[realItemIndex] or nil;
    if (itemString) then
        GameTooltip:SetOwner(itemFrame.frame, "ANCHOR_NONE");
        GameTooltip:SetPoint("BOTTOMLEFT", itemFrame.frame, "BOTTOMRIGHT");
        GameTooltip:SetHyperlink(self.db.char.challenges[self.activeChallengeId].players[unitId].items[realItemIndex]);
        GameTooltip:Show();
    end
end
