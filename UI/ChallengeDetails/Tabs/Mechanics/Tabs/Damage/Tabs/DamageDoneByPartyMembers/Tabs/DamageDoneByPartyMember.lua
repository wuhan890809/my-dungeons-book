--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getDamageByPartyMemberSpellMenu(rows, index, cols, challengeId, unitId)
    local spellId = rows[index].cols[1].value;
    local report = MyDungeonsBook:DamageDoneByPartyMemberFrame_Report_Create(rows[index], cols, challengeId, unitId);
    return {
        MyDungeonsBook:WowHead_Menu_Spell(spellId),
        MyDungeonsBook:Report_Menu(report)
    };
end

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=Frame]
]]
function MyDungeonsBook:DamageDoneByPartyMemberFrame_Create(parentFrame, challengeId, unitId)
    local damageDoneByPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:DamageDoneByPartyMemberFrame_GetDataForTable(challengeId, "ALL-DAMAGE-DONE-BY-PARTY-MEMBERS", unitId);
    local columns = self:DamageDoneByPartyMemberFrame_GetHeadersForTable(challengeId, unitId);
    local table = self:TableWidget_Create(columns, 11, 40, nil, damageDoneByPartyMemberFrame, "all-damage-done-by-" .. unitId);
    table:SetData(data);
    table:RegisterEvents({
        OnClick = function(_, _, data, _, _, realrow, _, _, button)
            if (button == "RightButton" and realrow) then
                local spellId = data[realrow].cols[1].value;
                if (spellId > 0) then
                    EasyMenu(getDamageByPartyMemberSpellMenu(data, realrow, table.cols, challengeId, unitId), self.menuFrame, "cursor", 0 , 0, "MENU");
                end
            end
        end,
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
    return damageDoneByPartyMemberFrame;
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
            name = "",
            width = 40,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellIcon(...);
            end
        },
        {
            name = L["Spell"],
            width = 110,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = L["Hits"],
            width = 40,
            align = "RIGHT"
        },
        {
            name = L["Amount"],
            width = 60,
            align = "RIGHT",
            sort = "asc",
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
            name = L["%"],
            width = 40,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsPercents(...);
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
            {value = 0},
            {value = spellStats.overkill},
            {value = (spellStats.hitsCrit or 0) / spellStats.hits},
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
    summaryRow.cols[7].value = summaryRow.cols[7].value + spellStats.overkill;
    summaryRow.cols[9].value = summaryRow.cols[9].value + (spellStats.hitsCrit or 0);
    return row, summaryRow;
end

--[[--
Map data about own casts by party member `unitId` for challenge with id `challengeId`.

Pets and other summonned units are included.

@param[type=number] challengeId
@param[type=string] key for mechanics table
@param[type=unitId] unitId
@return[type=table] whole table data
@return[type=table] summary row
]]
function MyDungeonsBook:DamageDoneByPartyMemberFrame_GetDataForTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
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
            {value = ""},
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
    for unitName, damageDoneByUnit in pairs(mechanics) do
        if (damageDoneByUnit.meta and (damageDoneByUnit.meta.unitName == name or damageDoneByUnit.meta.unitName == nameAndRealm) and damageDoneByUnit.meta.unitName ~= unitName) then
            for spellId, spellStats in pairs(damageDoneByUnit.spells or damageDoneByUnit) do
                if (spellId ~= "meta") then
                    local row = proceedSpellStats(spellId, spellStats, summaryRow, unitName);
                    tinsert(tableData, row);
                end
            end
        end
    end
    summaryRow.cols[8].value = summaryRow.cols[9].value / summaryRow.cols[4].value;
    for _, tableRow in pairs(tableData) do
        tableRow.cols[6].value = tableRow.cols[5].value / summaryRow.cols[5].value;
    end
    tinsert(tableData, summaryRow);
    return tableData, summaryRow;
end

--[[--
@param[type=table] row
@param[type=table] cols
@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:DamageDoneByPartyMemberFrame_Report_Create(row, cols, challengeId, unitId)
    local spellLink = GetSpellLink(row.cols[1].value);
    local challenge = self:Challenge_GetById(challengeId);
    local title = string.format(L["MyDungeonsBook Damage stats by %s with %s:"], challenge.players[unitId].name or "", spellLink);
    return self:Table_PlayersRowBySpell_Report_Create(row, cols, title);
end
