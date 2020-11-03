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
function MyDungeonsBook:DamageDoneByPartyMemberFrame_Create(parentFrame, challengeId, unitId)
    local ownCastsByPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:DamageDoneByPartyMemberFrame_GetDataForTable(challengeId, "ALL-DAMAGE-DONE-BY-PARTY-MEMBERS", unitId);
    local columns = self:DamageDoneByPartyMemberFrame_GetHeadersForTable(challengeId, unitId);
    local table = self:TableWidget_Create(columns, 10, 40, nil, ownCastsByPartyMemberFrame, "all-damage-done-by-" .. unitId);
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
    return ownCastsByPartyMemberFrame;
end

--[[--
@return[type=table]
]]
function MyDungeonsBook:DamageDoneByPartyMemberFrame_GetHeadersForTable()
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

--[[--
Map data about own casts by party member `unitId` for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:DamageDoneByPartyMemberFrame_GetDataForTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local challenge = self.db.char.challenges[challengeId];
    local mechanics = challenge.mechanics[key];
    if (not mechanics) then
        self:DebugPrint(string.format("No Damage Done By Party Members data for challenge #%s", challengeId));
        return tableData;
    end
    local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
    local mechanicsData = mechanics[name] or mechanics[nameAndRealm];
    if (not mechanicsData) then
        self:DebugPrint(string.format("No Damage found for %s or %s", name, nameAndRealm));
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
    for spellId, spellStats in pairs(mechanicsData) do
        tinsert(tableData, {
            cols = {
                {value = spellId},
                {value = spellId},
                {value = spellId},
                {value = spellStats.hits},
                {value = spellStats.amount},
                {value = spellStats.overkill},
                {value = (spellStats.hitsCrit or 0) / spellStats.hits * 100},
                {value = spellStats.hitsCrit or 0},
                {value = (spellStats.maxCrit == 0 and "-") or spellStats.maxCrit},
                {value = (spellStats.minCrit == math.huge and "-") or spellStats.minCrit},
                {value = (spellStats.maxNotCrit == 0 and "-") or spellStats.maxNotCrit},
                {value = (spellStats.minNotCrit == math.huge and "-") or spellStats.minNotCrit},
            }
        });
        summaryRow.cols[4].value = summaryRow.cols[4].value + spellStats.hits;
        summaryRow.cols[5].value = summaryRow.cols[5].value + spellStats.amount;
        summaryRow.cols[6].value = summaryRow.cols[6].value + spellStats.overkill;
        summaryRow.cols[8].value = summaryRow.cols[8].value + spellStats.hitsCrit;
    end
    summaryRow.cols[7].value = summaryRow.cols[8].value / summaryRow.cols[4].value * 100;
    tinsert(tableData, summaryRow);
    return tableData;
end
