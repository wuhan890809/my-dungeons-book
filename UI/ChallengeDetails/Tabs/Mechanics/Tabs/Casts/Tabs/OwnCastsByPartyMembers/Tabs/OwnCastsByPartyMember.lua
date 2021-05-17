--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local AceGUI = LibStub("AceGUI-3.0");

local function getOwnCastsSpellMenu(spellId)
    return {
        MyDungeonsBook:WowHead_Menu_Spell(spellId)
    };
end

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=Frame]
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_Create(parentFrame, challengeId, unitId)
    local ownCastsByPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local key = self:GetMechanicsPrefixForChallenge(challengeId) .. "-OWN-CASTS-DONE-BY-PARTY-MEMBERS";
    self.db.char.filters.ownCasts.spellId = "ALL";
    ownCastsByPartyMemberFrame:SetUserData("table", self:OwnCastsByPartyMemberFrame_Table_Create(ownCastsByPartyMemberFrame, challengeId, key, unitId));
    ownCastsByPartyMemberFrame:SetUserData("summaryTable", self:OwnCastsByPartyMemberFrame_SummaryTable_Create(ownCastsByPartyMemberFrame, challengeId, key, unitId));
    ownCastsByPartyMemberFrame:SetUserData("filterBySpellId", self:OwnCastsByPartyMemberFrame_FilterBySpellId_Create(ownCastsByPartyMemberFrame, challengeId, key, unitId));
    self.ownCastsByPartyMemberFrame = ownCastsByPartyMemberFrame;
    return ownCastsByPartyMemberFrame;
end

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=string] key
@param[type=unitId] unitId
@param[type=Frame] filterBySpellId
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_FilterBySpellId_Create(parentFrame, challengeId, key, unitId)
    local filterBySpellId = AceGUI:Create("Dropdown");
    local summaryData = self:OwnCastsByPartyMemberFrame_GetImportantDataForSummaryTable(challengeId, key, unitId);
    filterBySpellId:SetWidth(200);
    local filterBySpellIdOptions = {
        ["ALL"] = L["All"]
    };
    local filterBySpellIdOptionsOrder = {"ALL"}
    for _, row in pairs(summaryData) do
        local spellId = row.cols[1].value;
        filterBySpellIdOptions[spellId] = GetSpellInfo(spellId);
        tinsert(filterBySpellIdOptionsOrder, spellId);
    end
    filterBySpellId:SetList(filterBySpellIdOptions, filterBySpellIdOptionsOrder);
    filterBySpellId:SetValue(self.db.char.filters.ownCasts.spellId);
    filterBySpellId:SetCallback("OnValueChanged", function (_, _, filterValue)
        self:OwnCastsByPartyMemberFrame_FilterBySpellId_Update(filterValue);
    end);
    parentFrame:AddChild(filterBySpellId);
    local resetFilters = AceGUI:Create("Button");
    resetFilters:SetText(L["Reset"]);
    resetFilters:SetWidth(90);
    resetFilters:SetCallback("OnClick", function()
        self:OwnCastsByPartyMemberFrame_FilterBySpellId_Update("ALL");
        filterBySpellId:SetValue("ALL");
    end);
    parentFrame:AddChild(resetFilters);
    return filterBySpellId;
end

--[[--
@param[type=string|number] newSpellId
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_FilterBySpellId_Update(newSpellId)
    self.db.char.filters.ownCasts.spellId = newSpellId;
    self.ownCastsByPartyMemberFrame:GetUserData("table"):SortData();
end

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=string] key
@param[type=unitId] unitId
@param[type=table]
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_Table_Create(parentFrame, challengeId, key, unitId)
    local data = self:OwnCastsByPartyMemberFrame_GetDataForTable(challengeId, key, unitId);
    local columns = self:OwnCastsByPartyMemberFrame_GetHeadersForTable(challengeId, unitId);
    local table = self:TableWidget_Create(columns, 10, 40, {r = 1.0, g = 0.9, b = 0.0, a = 0.5}, parentFrame, "own-casts-by-" .. unitId);
    table:SetData(data);
    table.frame:SetPoint("TOPLEFT", 260, -80);
    table:RegisterEvents({
        OnClick = function(_, _, data, _, _, realrow, _, _, button)
            if (button == "RightButton" and realrow) then
                EasyMenu(getOwnCastsSpellMenu(data[realrow].cols[1].value), self.menuFrame, "cursor", 0 , 0, "MENU");
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
    table:SetFilter(function(_, row)
        local spellId = self.db.char.filters.ownCasts.spellId;
        if (spellId ~= "ALL") then
            if (row.cols[1].value ~= spellId) then
                return false;
            end
        end
        return true;
    end);
    return table;
end

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@param[type=string] key
@param[type=unitId] unitId
@param[type=table]
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_SummaryTable_Create(parentFrame, challengeId, key, unitId)
    local summaryData = self:OwnCastsByPartyMemberFrame_GetAllDataForSummaryTable(challengeId, key, unitId);
    local summaryColumns = self:OwnCastsByPartyMemberFrame_GetHeadersForSummaryTable();
    local summaryTable = self:TableWidget_Create(summaryColumns, 10, 40, nil, parentFrame, "own-casts-by-" .. unitId .. "-summary");
    summaryTable:SetData(summaryData);
    summaryTable.frame:SetPoint("TOPLEFT", 0, -80);
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
        end,
        OnClick = function(_, _, data, _, _, realrow, _, _, button)
            if (button == "RightButton" and realrow) then
                EasyMenu(getOwnCastsSpellMenu(data[realrow].cols[1].value), self.menuFrame, "cursor", 0 , 0, "MENU");
            end
            if (button == "LeftButton" and realrow) then
                local spellId = data[realrow].cols[1].value;
                self.ownCastsByPartyMemberFrame.userdata.filterBySpellId:SetValue(spellId);
                self:OwnCastsByPartyMemberFrame_FilterBySpellId_Update(spellId);
            end
        end
    });
    return summaryTable;
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
    local challenge = self:Challenge_GetById(challengeId);
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, "OWN-CASTS-DONE-BY-PARTY-MEMBERS") or self:Challenge_Mechanic_GetById(challengeId, key);
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
                    {value = (singleSpellUse.time - challenge.challengeInfo.startTime - 10) * 1000}, -- first 10 seconds are countdown
                    {value = ""},
                    {value = singleSpellUse.target or ""}
                }
            });
        end
    end
    return tableData;
end

--[[--
Map summary data about "important" own casts by party member `unitId` for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_GetImportantDataForSummaryTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, "OWN-CASTS-DONE-BY-PARTY-MEMBERS") or self:Challenge_Mechanic_GetById(challengeId, key);
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

--[[--
Map summary data about all own casts by party member `unitId` for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:OwnCastsByPartyMemberFrame_GetAllDataForSummaryTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, "ALL-CASTS-DONE-BY-PARTY-MEMBERS");
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
    for spellId, usageCount in pairs(mechanicsData) do
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
