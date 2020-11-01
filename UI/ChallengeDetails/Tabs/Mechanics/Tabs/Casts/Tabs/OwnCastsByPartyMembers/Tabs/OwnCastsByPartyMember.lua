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
function MyDungeonsBook:OwnCastsByPartyMemberFrame_Create(parentFrame, challengeId, unitId)
    local ownCastsByPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local key = self:GetMechanicsPrefixForChallenge(challengeId) .. "-OWN-CASTS-DONE-BY-PARTY-MEMBERS";
    local data = self:OwnCastsByPartyMemberFrame_GetDataForTable(challengeId, key, unitId);
    local columns = self:OwnCastsByPartyMemberFrame_GetHeadersForTable(challengeId, unitId);
    local table = self:TableWidget_Create(columns, 10, 40, nil, ownCastsByPartyMemberFrame, "own-casts-by-" .. unitId);
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
    local summaryData = self:OwnCastsByPartyMemberFrame_GetDataForSummaryTable(challengeId, key, unitId);
    local summaryColumns = self:OwnCastsByPartyMemberFrame_GetHeadersForSummaryTable();
    local summaryTable = self:TableWidget_Create(summaryColumns, 10, 40, nil, ownCastsByPartyMemberFrame, "own-casts-by-" .. unitId .. "-summary");
    summaryTable:SetData(summaryData);
    summaryTable.frame:SetPoint("TOPLEFT", 380, -40);
    summaryTable:RegisterEvents({
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
function MyDungeonsBook:OwnCastsByPartyMemberFrame_GetHeadersForTable()
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
            width = 110,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = L["Time"],
            width = 60,
            align = "RIGHT",
            sort = "dsc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            -- Just an extra space for Time and Target columns
            name = " ",
            width = 20,
            align = "CENTER",
        },
        {
            name = L["Target?"],
            width = 110,
            align = "LEFT"
        }
    };
end

--[[--
@return[type=table]
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_GetHeadersForSummaryTable()
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
            width = 110,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = L["Num"],
            width = 60,
            align = "RIGHT",
            sort = "asc"
        },
    };
end

--[[--
Map data about own casts by party member `unitId` for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_GetDataForTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local challenge = self.db.char.challenges[challengeId];
    local mechanics = challenge.mechanics["OWN-CASTS-DONE-BY-PARTY-MEMBERS"] or challenge.mechanics[key];
    if (not mechanics) then
        self:DebugPrint(string.format("No Own Casts Done By Party Members data for challenge #%s", challengeId));
        return tableData;
    end
    local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
    local mechanicsData = mechanics[name] or mechanics[nameAndRealm];
    if (not mechanicsData) then
        self:DebugPrint(string.format("No Own Casts found for %s or %s", name, nameAndRealm));
        return tableData;
    end
    for spellId, spellUsages in pairs(mechanicsData) do
        for _, singleSpellUse in pairs(spellUsages) do
            tinsert(tableData, {
                cols = {
                    {value = spellId},
                    {value = spellId},
                    {value = spellId},
                    {value = (singleSpellUse.time - challenge.challengeInfo.startTime) * 1000},
                    {value = ""},
                    {value = singleSpellUse.target or ""}
                }
            });
        end
    end
    return tableData;
end

--[[--
Map summary data about own casts by party member `unitId` for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_GetDataForSummaryTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local challenge = self.db.char.challenges[challengeId];
    local mechanics = challenge.mechanics["OWN-CASTS-DONE-BY-PARTY-MEMBERS"] or challenge.mechanics[key];
    if (not mechanics) then
        self:DebugPrint(string.format("No Own Casts Done By Party Members data for challenge #%s", challengeId));
        return tableData;
    end
    local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
    local mechanicsData = mechanics[name] or mechanics[nameAndRealm];
    if (not mechanicsData) then
        self:DebugPrint(string.format("No Own Casts found for %s or %s", name, nameAndRealm));
        return tableData;
    end
    for spellId, spellUsages in pairs(mechanicsData) do
        local usageCount = 0;
        for _, _ in pairs(spellUsages) do
            usageCount = usageCount + 1;
        end;
        tinsert(tableData, {
            cols = {
                {value = spellId},
                {value = spellId},
                {value = spellId},
                {value = usageCount}
            }
        });
    end
    return tableData;
end
