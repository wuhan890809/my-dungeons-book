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
    local challenge = self:Challenge_GetById(challengeId);
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
        self:EquipmentFrame_PartyMember_Ilvl_Create(partyMemberFrame, challengeId, unit);
        self:EquipmentFrame_PartyMember_Create(partyMemberFrame, challengeId, unit);
    end
    return equipmentFrame;
end

--[[--
Creates a frame with equipment for `unitId`.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=unitId] unitId
]]
function MyDungeonsBook:EquipmentFrame_PartyMember_Create(parentFrame, challengeId, unitId)
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

--[[--
Update average items level for party member (`unit`) in the `challenge`.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=unitId] unit
]]
function MyDungeonsBook:EquipmentFrame_PartyMember_Ilvl_Create(parentFrame, challengeId, unit)
    local sum = 0;
    local itemsCount = 0;
    local challenge = self:Challenge_GetById(challengeId);
    for i = 1, 17 do
        if (i ~= 4) then
            local itemLink = challenge.players[unit].items and challenge.players[unit].items[i] or nil;
            if (itemLink) then
                local itemLevel = self:GetItemLevelFromTooltip(itemLink);
                if (itemLevel) then
                    sum = sum + itemLevel;
                    itemsCount = itemsCount + 1;
                end
            end
        end
    end
    if (itemsCount ~= 0) then
        local ilvlFrame = AceGUI:Create("Label");
        ilvlFrame:SetText(string.format("%.2f", sum / itemsCount));
        ilvlFrame:SetWidth(60);
        parentFrame:AddChild(ilvlFrame);
        return ilvlFrame;
    end
end
