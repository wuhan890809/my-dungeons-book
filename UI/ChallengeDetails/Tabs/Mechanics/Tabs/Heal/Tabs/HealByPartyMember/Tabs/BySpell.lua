--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=Frame]
]]
function MyDungeonsBook:HealByPartyMemberBySpellFrame_Create(parentFrame, challengeId, unitId)
    local healByPartyMemberBySpellFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:HealByPartyMemberBySpellFrame_GetDataForTable(challengeId, "ALL-HEAL-DONE-BY-PARTY-MEMBERS", unitId);
    local columns = self:HealByPartyMemberBySpellFrame_GetHeadersForTable(challengeId, unitId);
    local table = self:TableWidget_Create(columns, 10, 40, nil, healByPartyMemberBySpellFrame, "all-heal-done-by-" .. unitId);
    table:SetData(data);
    table:RegisterEvents({
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
    return healByPartyMemberBySpellFrame;
end

--[[--
@return[type=table]
]]
function MyDungeonsBook:HealByPartyMemberBySpellFrame_GetHeadersForTable()
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
            width = 120,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = L["Hits"],
            width = 60,
            align = "RIGHT"
        },
        {
            name = L["Amount"],
            width = 60,
            align = "RIGHT",
            sort = "asc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = L["Over"],
            width = 50,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = L["Crit, %"],
            width = 50,
            align = "RIGHT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
            color = {
                r = 1,
                g = 0,
                b = 0,
                a = 1
            },
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsPercents(...);
            end
        },
        {
            name = L["Hits Crit"],
            width = 50,
            align = "RIGHT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
        },
        {
            name = L["Max Crit"],
            width = 50,
            align = "RIGHT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = L["Min Crit"],
            width = 50,
            align = "RIGHT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = L["Max Not Crit"],
            width = 50,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = L["Min Not Crit"],
            width = 50,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        }
    };
end

local function proceedSpellStats(spellId, spellStats, summaryRow, unitName)
    local row = {
        cols = {
            {value = spellId},
            {value = spellId},
            {value = spellId},
            {value = spellStats.hits},
            {value = spellStats.amount},
            {value = spellStats.overheal},
            {value = (spellStats.hitsCrit or 0) / spellStats.hits * 100},
            {value = spellStats.hitsCrit or 0},
            {value = (spellStats.maxCrit == 0 and "-") or spellStats.maxCrit},
            {value = (spellStats.minCrit == math.huge and "-") or spellStats.minCrit},
            {value = (spellStats.maxNotCrit == 0 and "-") or spellStats.maxNotCrit},
            {value = (spellStats.minNotCrit == math.huge and "-") or spellStats.minNotCrit},
        },
        meta = {
            unitName = unitName
        }
    };
    summaryRow.cols[4].value = summaryRow.cols[4].value + spellStats.hits;
    summaryRow.cols[5].value = summaryRow.cols[5].value + spellStats.amount;
    summaryRow.cols[6].value = summaryRow.cols[6].value + spellStats.overheal;
    summaryRow.cols[8].value = summaryRow.cols[8].value + spellStats.hitsCrit;
    return row, summaryRow;
end

--[[--
Map data about own casts by party member `unitId` for challenge with id `challengeId`.

Pets and other summonned units are included.

@param[type=number] challengeId
@param[type=string] key for mechanics table
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:HealByPartyMemberBySpellFrame_GetDataForTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanics) then
        self:DebugPrint(string.format("No Heal Done By Party Members data for challenge #%s", challengeId));
        return tableData;
    end
    local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
    local mechanicsData = mechanics[name] or mechanics[nameAndRealm];
    if (not mechanicsData) then
        self:DebugPrint(string.format("No Heal found for %s or %s", name, nameAndRealm));
        return tableData;
    end
    local summaryRow = {
        color = {
            r = 0,
            g = 100,
            b = 0,
            a = 1
        },
        cols = {
            {value = -1},
            {value = -1},
            {value = -1},
            {value = 0},
            {value = 0},
            {value = 0},
            {value = 0},
            {value = 0},
            {value = ""},
            {value = ""},
            {value = ""},
            {value = ""}
        }
    };
    for spellId, spellStats in pairs(mechanicsData.spells or mechanicsData) do
        if (spellId ~= "meta") then
            local row = proceedSpellStats(spellId, spellStats, summaryRow);
            tinsert(tableData, row);
        end
    end
    for unitName, healDoneByUnit in pairs(mechanics) do
        if (healDoneByUnit.meta and (healDoneByUnit.meta.unitName == name or healDoneByUnit.meta.unitName == nameAndRealm) and healDoneByUnit.meta.unitName ~= unitName) then
            for spellId, spellStats in pairs(healDoneByUnit.spells or healDoneByUnit) do
                if (spellId ~= "meta") then
                    local row = proceedSpellStats(spellId, spellStats, summaryRow, unitName);
                    tinsert(tableData, row);
                end
            end
        end
    end
    summaryRow.cols[7].value = summaryRow.cols[8].value / summaryRow.cols[4].value * 100;
    tinsert(tableData, summaryRow);
    return tableData;
end