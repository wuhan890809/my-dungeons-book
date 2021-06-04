--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local AceGUI = LibStub("AceGUI-3.0");

local function getShiftedIndex(i)
    return (i <= 3 and i) or i + 1;
end

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
    local stats = {
        crit = 0,
        haste = 0,
        mastery = 0,
        vers = 0
    };
    local itemsOrder = {1, 2, 3, 14, 4, 8, 9, 5, 6, 7, -1, 10, 11, -1, 12, 13, -1, 15, 16};
    for _, i in pairs(itemsOrder) do
        local itemFrame = AceGUI:Create("InteractiveLabel");
        parentFrame:AddChild(itemFrame);
        if (i == -1) then
            itemFrame:SetWidth(20);
        else
            itemFrame:SetWidth(35);
            itemFrame:SetCallback("OnEnter", function(frame)
                self:EquipmentFrame_TableItemHover(frame, unitId, i);
            end);
            itemFrame:SetCallback("OnLeave", function()
                self:Table_Cell_MouseOut();
            end);
            local itemString = challenge.players[unitId] and challenge.players[unitId].items and challenge.players[unitId].items[getShiftedIndex(i)] or nil;
            if (itemString) then
                local itemStats = self:GetItemSecondaryStatsBonus(itemString);
                for statName, statValue in pairs(itemStats) do
                    stats[statName] = stats[statName] + statValue;
                end
                local _, itemId = strsplit(":", itemString);
                if (itemId) then
                    local suffix = self:GetIconTextureSuffix(30);
                    itemFrame:SetText("|T" .. GetItemIcon(itemId) .. suffix .. "|t");
                end
            end
        end
    end;
    self:NewLine_Create(parentFrame);
    -- item levels
    local placeholder = AceGUI:Create("Label");
    placeholder:SetWidth(40);
    parentFrame:AddChild(placeholder);
    local gemsCount = 0;
    for _, i in pairs(itemsOrder) do
        local itemLevelFrame = AceGUI:Create("Label");
        parentFrame:AddChild(itemLevelFrame);
        if (i == -1) then
            itemLevelFrame:SetWidth(20);
        else
            itemLevelFrame:SetWidth(35);
            itemLevelFrame:SetJustifyH("CENTER");
            local itemString = challenge.players[unitId] and challenge.players[unitId].items and challenge.players[unitId].items[getShiftedIndex(i)] or nil;
            if (itemString) then
                local _, _, itemRarity = GetItemInfo(itemString);
                gemsCount = gemsCount + self:GetItemGemsCount(itemString);
                if (itemRarity) then
                    itemLevelFrame:SetColor(GetItemQualityColor(itemRarity));
                    itemLevelFrame:SetText(self:GetItemLevelFromTooltip(itemString));
                end
            end
        end
    end
    self:NewLine_Create(parentFrame);
    local gems = AceGUI:Create("Label");
    gems:SetWidth(40);
    local suffix = MyDungeonsBook:GetIconTextureSuffix(16);
    gems:SetText(string.format("%s |Tinterface\\icons\\inv_misc_gem_flamespessarite_02.blp" .. suffix .. "|t", gemsCount));
    parentFrame:AddChild(gems);
    local labelFormat = "%s: %s";
    -- crit
    local critLabel = AceGUI:Create("Label");
    parentFrame:AddChild(critLabel);
    critLabel:SetText(string.format(labelFormat, L["Critical Strike"], stats.crit));
    critLabel:SetWidth(150);
    critLabel:SetColor(249, 0, 0, 1);
    -- haste
    local hasteLabel = AceGUI:Create("Label");
    parentFrame:AddChild(hasteLabel);
    hasteLabel:SetText(string.format(labelFormat, L["Haste"], stats.haste));
    hasteLabel:SetWidth(150);
    hasteLabel:SetColor(0, 91, 255, 1);
    -- mastery
    local masteryLabel = AceGUI:Create("Label");
    parentFrame:AddChild(masteryLabel);
    masteryLabel:SetText(string.format(labelFormat, L["Mastery"], stats.mastery));
    masteryLabel:SetWidth(150);
    masteryLabel:SetColor(0, 183, 0, 1);
    -- vers
    local versLabel = AceGUI:Create("Label");
    parentFrame:AddChild(versLabel);
    versLabel:SetText(string.format(labelFormat, L["Versatility"], stats.vers));
    versLabel:SetWidth(150);
    versLabel:SetColor(190, 190, 0, 1);
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
    if (not self.activeChallengeId) then
        return;
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
                end
            else
                -- offhand can be empty
                if (i == 17) then
                    local mainHand = challenge.players[unit].items and challenge.players[unit].items[16] or nil;
                    if (mainHand) then
                        local _, _, _, _, _, _, _, _, itemEquipLoc = GetItemInfo(mainHand);
                        if (itemEquipLoc == "INVTYPE_2HWEAPON" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" or itemEquipLoc == "INVTYPE_RANGED") then
                            sum = sum + self:GetItemLevelFromTooltip(mainHand);
                        end
                    end
                end
            end
            itemsCount = itemsCount + 1;
        end
    end
    local ilvlFrame = AceGUI:Create("Label");
    ilvlFrame:SetWidth(40);
    parentFrame:AddChild(ilvlFrame);
    if (itemsCount ~= 0) then
        ilvlFrame:SetText(string.format("%.2f", sum / itemsCount));
    end
    return ilvlFrame;
end
