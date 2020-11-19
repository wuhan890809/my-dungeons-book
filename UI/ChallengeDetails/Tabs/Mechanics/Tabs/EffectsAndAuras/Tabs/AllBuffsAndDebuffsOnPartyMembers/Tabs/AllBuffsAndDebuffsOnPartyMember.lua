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
@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=Frame]
]]
function MyDungeonsBook:AllBuffsAndDebuffsOnPartyMemberFrame_Create(parentFrame, challengeId, unitId)
    local allBuffsAndDebuffsOnPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local columns = self:AllBuffsAndDebuffsOnPartyMemberFrame_GetHeadersForTable();
    local buffsData = self:AllBuffsAndDebuffsOnPartyMemberFrame_GetDataForTable(challengeId, "PARTY-MEMBERS-AURAS", unitId, "BUFF");
    local buffsTable = self:TableWidget_Create(columns, 10, 40, nil, allBuffsAndDebuffsOnPartyMemberFrame, "party-members-auras-on-" .. unitId .. "-buffs");
    buffsTable:SetData(buffsData);
    buffsTable:RegisterEvents({
        OnEnter = function (_, cellFrame, data, _, _, realrow, column)
            if (realrow) then
                if (column == 2 or column == 3) then
                    self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
                end
            end
        end,
        OnLeave = function (_, _, _, _, _, realrow, column)
            if (realrow) then
                if (column == 2 or column == 3) then
                    self:Table_Cell_MouseOut();
                end
            end
        end
    });
    local debuffsTable = self:TableWidget_Create(columns, 10, 40, nil, allBuffsAndDebuffsOnPartyMemberFrame, "party-members-auras-on-" .. unitId .. "-debuffs");
    local debuffsData = self:AllBuffsAndDebuffsOnPartyMemberFrame_GetDataForTable(challengeId, "PARTY-MEMBERS-AURAS", unitId, "DEBUFF");
    debuffsTable:SetData(debuffsData);
    debuffsTable:RegisterEvents({
        OnEnter = function (_, cellFrame, data, _, _, realrow, column)
            if (realrow) then
                if (column == 2 or column == 3) then
                    self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
                end
            end
        end,
        OnLeave = function (_, _, _, _, _, realrow, column)
            if (realrow) then
                if (column == 2 or column == 3) then
                    self:Table_Cell_MouseOut();
                end
            end
        end
    });
    debuffsTable.frame:SetPoint("TOPLEFT", 335, -40);
    return allBuffsAndDebuffsOnPartyMemberFrame;
end

--[[--
]]
function MyDungeonsBook:AllBuffsAndDebuffsOnPartyMemberFrame_GetHeadersForTable()
    return {
        {
            name = " ",
            width = 1,
            align = "LEFT"
        },
        {
            name = L["Spell"],
            width = 40,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellIcon(...);
            end
        },
        {
            name = "",
            width = 90,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = L["Time"],
            width = 40,
            align = "RIGHT",
            sort = "asc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = L["Uptime, %"],
            width = 40,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsPercents(...);
            end
        },
        {
            name = L["Hits"],
            width = 40,
            align = "RIGHT"
        },
        {
            name = L["Max Stacks"],
            width = 40,
            align = "RIGHT"
        }
    };
end

--[[--
@param[type=number] challengeId
@param[type=string] key
@param[type=unitId] unitId
@param[type=string] auraType
@return[type=table]
]]
function MyDungeonsBook:AllBuffsAndDebuffsOnPartyMemberFrame_GetDataForTable(challengeId, key, unitId, auraType)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local challenge = self:Challenge_GetById(challengeId);
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanics) then
        self:DebugPrint(string.format("No Party Members Auras data for challenge #%s", challengeId));
        return tableData;
    end
    local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
    local mechanicsData = mechanics[name] or mechanics[nameAndRealm];
    if (not mechanicsData) then
        self:DebugPrint(string.format("No Party Members Auras for %s or %s", name, nameAndRealm));
        return tableData;
    end
    local challengeDuration = challenge.challengeInfo.duration;
    for spellId, spellInfo in pairs(mechanicsData) do
        if (self.db.global.meta.spells[spellId] and self.db.global.meta.spells[spellId].auraType == auraType) then
            local durationCellValue = (spellInfo.duration and spellInfo.duration * 1000) or "-";
            local uptimeCellValue = (challengeDuration and spellInfo.duration and spellInfo.duration / (challengeDuration / 1000) * 100) or "-";
            tinsert(tableData, {
                cols = {
                    {value = spellId},
                    {value = spellId},
                    {value = spellId},
                    {value = durationCellValue},
                    {value = uptimeCellValue},
                    {value = spellInfo.hits},
                    {value = self:RoundNumber(spellInfo.maxAmount)}
                }
            });
        end
    end
    return tableData;
end
