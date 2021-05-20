--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Deaths tab (data is taken from `mechanics[PARTY-MEMBERS-DEATHS-TIMER]`).

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:DeathsFrame_Create(parentFrame, challengeId)
    local deathsFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:DeathsFrame_GetDataForTable(challengeId, "PARTY-MEMBERS-DEATHS-TIMER");
    local columns = self:DeathsFrame_GetColumnsForTable(challengeId);
    local table = self:TableWidget_Create(columns, 10, 25, {r = 1.0, g = 0.9, b = 0.0, a = 0.5}, deathsFrame, "party-deaths");
    table:SetData(data);
    table:EnableSelection(true);
    table:RegisterEvents({
        OnClick = function(_, _, data, _, _, realrow, _, _, button)
            if (button == "LeftButton" and realrow) then
                local partyMemberKey = data[realrow].cols[1].value;
                if (partyMemberKey ~= -1) then
                    local timestamp, unitId = strsplit("=", partyMemberKey);
                    local deathLogData, rowData = self:DeathsFrame_GetDataForDeathLogTable(challengeId, "PARTY-MEMBER-DEATH-LOGS", unitId, tonumber(timestamp));
                    deathsFrame:GetUserData("deathLogTable"):SetData(deathLogData);
                    deathsFrame:SetUserData("deathLogTableRowData", rowData);
                end
            end
        end
    });
    local deathLogColumns = self:DeathsFrame_GetColumnsForDeathLogTable(challengeId);
    local deathLogTable = self:TableWidget_Create(deathLogColumns, 10, 20, nil, deathsFrame, "party-member-death-log");
    deathLogTable:SetData({});
    deathLogTable.frame:SetPoint("TOPLEFT", 0, -340);
    deathsFrame:SetUserData("deathLogTable", deathLogTable);
    deathsFrame:SetUserData("deathLogsTable", table);
    deathLogTable:RegisterEvents({
        OnEnter = function (_, cellFrame, data, _, _, realrow, column)
            if (realrow) then
                if (column == 5) then
                    self:DeathsFrame_LogCellHover(cellFrame, data[realrow].cols[5].value);
                end
                if (column == 6) then
                    self:DeathsFrame_AmountCellHover(cellFrame, deathsFrame:GetUserData("deathLogTableRowData")[realrow]);
                end
                if (column == 7 or column == 8) then
                    self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
                end
            end
        end,
        OnLeave = function (_, _, _, _, _, realrow, column)
            if (realrow) then
                if (column >= 5 and column <= 8) then
                    self:Table_Cell_MouseOut();
                end
            end
        end
    });
    return deathsFrame;
end

--[[--
@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:DeathsFrame_GetColumnsForTable(challengeId)
    return {
        {
            name = "",
            width = 1,
            align = "LEFT"
        },
        {
            name = L["Player"],
            width = 250,
            align = "LEFT"
        },
        {
            name = L["Death Time"],
            width = 100,
            align = "LEFT",
            sort = "dsc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = L["Release Time"],
            width = 100,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = L["Time dead"],
            width = 100,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        }
    };
end

--[[--
@param[type=number] challengeId
@param[type=string] key for mechanics table
@return[type=table]
]]
function MyDungeonsBook:DeathsFrame_GetDataForTable(challengeId, key)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local challenge = self:Challenge_GetById(challengeId);
    local mechanic = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanic) then
        self:DebugPrint(string.format("No Party Deaths data for challenge #%s", challengeId));
        return tableData;
    end
    for _, unitId in pairs(self:GetPartyRoster()) do
        local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
        local nameToUse = (mechanic[name] and name) or nameAndRealm;
        local unitMechanic = mechanic[nameToUse];
        local unitId = self:GetPartyUnitByName(challengeId, nameToUse);
        if (unitMechanic and unitMechanic.timeline) then
            local prevStatus = -1;
            local lastTimestamp = -1;
            for indx, timelineItem in pairs(unitMechanic.timeline) do
                local currentStatus = timelineItem[2];
                local currentTimestamp = timelineItem[1];
                if (prevStatus == 1 and currentStatus == 0) then
                    local deathTime = lastTimestamp - challenge.challengeInfo.startTime - 10;
                    local releaseTime = currentTimestamp - challenge.challengeInfo.startTime - 10;
                    tinsert(tableData, {
                        cols = {
                            {value = lastTimestamp .. "=" .. unitId},
                            {value = self:GetUnitNameRealmRoleStr(challenge.players[unitId])},
                            {value = deathTime * 1000},
                            {value = releaseTime * 1000},
                            {value = (currentTimestamp - lastTimestamp) * 1000},
                        }
                    });
                end
                -- Party member is dead until challenge end (e.g. died and not released until challenge ends)
                if (currentStatus == 1 and #unitMechanic.timeline == indx) then
                    local deathTime = currentTimestamp - challenge.challengeInfo.startTime - 10;
                    local releaseTime = challenge.challengeInfo.duration / 1000;
                    tinsert(tableData, {
                        cols = {
                            {value = currentTimestamp .. "=" .. unitId},
                            {value = self:GetUnitNameRealmRoleStr(challenge.players[unitId])},
                            {value = deathTime * 1000},
                            {value = releaseTime * 1000},
                            {value = (releaseTime - deathTime) * 1000},
                        }
                    });
                end
                prevStatus = currentStatus;
                lastTimestamp = currentTimestamp;
            end
        else
            self:DebugPrint(string.format("No Deaths for %s", nameAndRealm));
        end
    end
    for _, encounterData in pairs(challenge.encounters) do
        local st = encounterData.startTime - challenge.challengeInfo.startTime - 10;
        local et = encounterData.endTime - challenge.challengeInfo.startTime - 10;
        tinsert(tableData, {
            cols = {
                {value = -1},
                {value = string.format(L["%s (start)"], encounterData.name)},
                {value = st * 1000},
                {value = st * 1000},
                {value = ""},
            }
        });
        tinsert(tableData, {
            cols = {
                {value = -1},
                {value = string.format(L["%s (end)"], encounterData.name)},
                {value = et * 1000},
                {value = et * 1000},
                {value = ""},
            }
        });
    end
    return tableData;
end

local function getLogItemByIndex(log, index)
    local offset = (type(log[1]) == "number" and 0) or 1;
    return log[index + offset];
end

--[[--
]]
function MyDungeonsBook:DeathsFrame_GetDataForDeathLogTable(challengeId, key, unitId, timestamp)
    local tableData = {};
    local mechanic = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanic) then
        return tableData;
    end
    local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
    local nameToUse = self:SafeNestedGet(mechanic, name) and name or nameAndRealm;
    local deathLogs = self:SafeNestedGet(mechanic, nameToUse, timestamp) or
            self:SafeNestedGet(mechanic, nameToUse, timestamp - 1) or
            self:SafeNestedGet(mechanic, nameToUse, timestamp - 2);
    if (not deathLogs) then
        self:DebugPrint(string.format("No death logs for %s on %s", nameAndRealm, timestamp));
        return tableData;
    end
    local lastLogTime = getLogItemByIndex(deathLogs[#deathLogs], 1) or timestamp;
    for _, log in pairs(deathLogs) do
        local row = {cols = {}};
        local subEventName = getLogItemByIndex(log, 2);
        local amount = "/";
        local spellId;
        local source = getLogItemByIndex(log, 5);
        local subEventPrefix, subEventSuffix = subEventName:match("^(.-)_?([^_]*)$");
        local hp = "";
        if (type (log[1]) == "table") then
            hp = log[1].hp.current .. "=" .. log[1].hp.max;
        end
        if (subEventName:match("SPELL_AURA_REMOVED")) then
            amount = "-" .. getLogItemByIndex(log, 15); -- BUFF or DEBUFF
            spellId = getLogItemByIndex(log, 12);
        end
        if (subEventName:match("SPELL_AURA_APPLIED")) then
            amount = "+" .. getLogItemByIndex(log, 15); -- BUFF or DEBUFF
            spellId = getLogItemByIndex(log, 12);
        end
        if ((subEventPrefix:match("^SPELL") or subEventPrefix:match("^RANGE")) and subEventSuffix == "DAMAGE") then
            amount = "-" .. getLogItemByIndex(log, 15);
            spellId = getLogItemByIndex(log, 12);
        end
        if (subEventName == "SWING_DAMAGE") then
            amount = "-" .. getLogItemByIndex(log, 12);
            spellId = -2;
        end
        if (subEventSuffix == "HEAL") then
            amount = "+" .. getLogItemByIndex(log, 15);
            spellId = getLogItemByIndex(log, 12);
        end
        if (subEventName == "SPELL_ABSORBED") then
            local n22 = getLogItemByIndex(log, 22);
            amount = "+" .. (n22 and getLogItemByIndex(log, 22) or getLogItemByIndex(log, 19));
            spellId = (n22 and getLogItemByIndex(log, 19)) or getLogItemByIndex(log, 16);
            source = (n22 and getLogItemByIndex(log, 16)) or getLogItemByIndex(log, 13);
        end
        if (subEventName == "SPELL_DISPEL") then
            spellId = getLogItemByIndex(log, 12);
        end
        tinsert(row.cols, {value = spellId});
        tinsert(row.cols, {value = unitId});
        tinsert(row.cols, {value = tonumber(string.format("%.2f", getLogItemByIndex(log, 1) - lastLogTime))});
        tinsert(row.cols, {value = hp});
        tinsert(row.cols, {value = subEventName});
        tinsert(row.cols, {value = amount});
        tinsert(row.cols, {value = spellId});
        tinsert(row.cols, {value = spellId});
        tinsert(row.cols, {value = source});
        tinsert(tableData, row);
    end
    return tableData, deathLogs;
end

--[[--
]]
function MyDungeonsBook:DeathsFrame_GetColumnsForDeathLogTable(challengeId)
    return {
        {
            name = "",
            width = 25,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatCellAsDeathLogAvoidable(challengeId, ...)
            end
        },
        {
            name = "",
            width = 1,
            align = "LEFT"
        },
        {
            name = L["Time"],
            width = 50,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatCellAsDeathLogTime(...);
            end
        },
        {
            name = L["HP"],
            width = 90,
            align = "RIGHT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
            DoCellUpdate = function(...)
                self:Table_Cell_FormatCellAsDeathLogHP(...);
            end
        },
        {
            name = L["Event"],
            width = 60,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsCombatLogSubEventName(...);
            end
        },
        {
            name = L["Amount"],
            width = 80,
            align = "RIGHT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
            DoCellUpdate = function(...)
                self:Table_Cell_FormatCellAsDeathLogAmount(...)
            end
        },
        {
            name = "",
            width = 25,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSmallSpellIcon(...);
            end
        },
        {
            name = L["Spell"],
            width = 150,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = L["Source"],
            width = 150,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatCellAsDeathLogSource(challengeId, ...);
            end
        }
    };
end

--[[--
@local
]]
function MyDungeonsBook:Table_Cell_FormatCellAsDeathLogAmount(_, cellFrame, data, _, _, realrow, column)
    local val = data[realrow].cols[column].value or "";
    local text = val;
    if (val == "-DEBUFF" or val == "+BUFF") then
        cellFrame.text:SetText(string.format("|cff1eff00%s|r", val));
        return;
    end
    if (val == "-BUFF" or val == "+DEBUFF") then
        cellFrame.text:SetText(string.format("|cffcc3333%s|r", val));
        return;
    end
    if (val:match("^%-%d+")) then
        text = string.format("|cffcc3333%s|r", "-" .. self:FormatNumber(math.abs(tonumber(val))));
    else
        local numeric = tonumber(val);
        if (numeric) then
            text = (val and string.format("|cff1eff00%s|r", "+" .. self:FormatNumber(tonumber(val)))) or val;
        end
    end
    cellFrame.text:SetText(text);
end

--[[--
@local
]]
function MyDungeonsBook:Table_Cell_FormatCellAsDeathLogSource(challengeId, _, cellFrame, data, _, _, realrow, column)
    local val = data[realrow].cols[column].value;
    local unitId = self:GetPartyUnitByName(challengeId, val);
    local challenge = self:Challenge_GetById(challengeId);
    local text = val;
    if (unitId) then
         text = self:GetUnitNameRealmRoleStr(challenge.players[unitId]);
    end
    cellFrame.text:SetText(text);
end

--[[--
@local
]]
function MyDungeonsBook:Table_Cell_FormatCellAsDeathLogAvoidable(challengeId, _, cellFrame, data, _, _, realrow, column)
    local spellId = data[realrow].cols[column].value;
    local unitId = data[realrow].cols[2].value;
    local isAvoidable = self:IsSpellAvoidableForPartyMember(challengeId, unitId, spellId) and (data[realrow].cols[6].value ~= "-DEBUFF");
    local icon = "interface\\raidframe\\readycheck-notready.blp";
    local suffix = self:GetIconTextureSuffix(16);
    cellFrame.text:SetText((isAvoidable and "|T" .. (icon or "") .. suffix .. "|t") or "");
end

--[[--
@local
]]
function MyDungeonsBook:DeathsFrame_AmountCellHover(cellFrame, log)
    local logMsg, r, g, b = CombatLog_OnEvent(DEFAULT_COMBATLOG_FILTER_TEMPLATE, unpack(log, (type(log[1]) == "number" and 1) or 2));
    GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE");
    GameTooltip:SetPoint("TOPLEFT", cellFrame, "BOTTOMLEFT");
    GameTooltip:SetText(logMsg or "", {r = r, g = g, b = b});
    GameTooltip:Show();
end

--[[--
@local
]]
function MyDungeonsBook:DeathsFrame_LogCellHover(cellFrame, subEventName)
    GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE");
    GameTooltip:SetPoint("TOPLEFT", cellFrame, "BOTTOMLEFT");
    GameTooltip:SetText(subEventName);
    GameTooltip:Show();
end

--[[--
@local
]]
function MyDungeonsBook:Table_Cell_FormatCellAsDeathLogHP(_, cellFrame, data, _, _, realrow, column)
    local val = data[realrow].cols[column].value or "";
    local current, max = strsplit("=", val);
    local percents = current / max * 100;
    current = self:FormatNumber(tonumber(current));
    cellFrame.text:SetText(string.format("%s (%s%%)", current, string.format("%.1f", percents)));
end

--[[--
@local
]]
function MyDungeonsBook:Table_Cell_FormatCellAsDeathLogTime(_, cellFrame, data, _, _, realrow, column)
    local val = data[realrow].cols[column].value or "";
    cellFrame.text:SetText(string.format("%.2f", val));
end

--[[--
@local
]]
function MyDungeonsBook:Table_Cell_FormatAsCombatLogSubEventName(_, cellFrame, data, _, _, realrow, column)
    local val = data[realrow].cols[column].value or "";
    local strs = { strsplit("_", val) };
    local acronim = "";
    for k, v in pairs(strs) do
        strs[k] = string.sub(v, 1, 1);
    end
    acronim = table.concat(strs);
    cellFrame.text:SetText(acronim);
end
