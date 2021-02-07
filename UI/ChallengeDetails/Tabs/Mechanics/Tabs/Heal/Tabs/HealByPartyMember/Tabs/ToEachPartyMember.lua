--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getHealToEachPartyMemberSpellMenu(rows, index, cols, challengeId, unitId)
    local spellId = rows[index].cols[1].value;
    local report = MyDungeonsBook:HealByPartyMemberToEachPartyMemberFrame_Report_Create(rows[index], cols, challengeId, unitId);
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
function MyDungeonsBook:HealByPartyMemberToEachPartyMemberFrame_Create(parentFrame, challengeId, unitId)
    local healByPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:HealByPartyMemberToEachPartyMemberFrame_GetDataForTable(challengeId, "PARTY-MEMBERS-HEAL", unitId);
    local columns = self:HealByPartyMemberToEachPartyMemberFrame_GetColumnsForTable(challengeId);
    local table = self:TableWidget_Create(columns, 10, 40, nil, healByPartyMemberFrame, "heal-by-" .. unitId .. "-to-party");
    table:SetData(data);
    table:RegisterEvents({
        OnClick = function(_, _, data, _, _, realrow, _, _, button)
            if (button == "RightButton" and realrow) then
                if (data[realrow].cols[1].value > 0) then
                    EasyMenu(getHealToEachPartyMemberSpellMenu(data, realrow, table.cols, challengeId, unitId), self.menuFrame, "cursor", 0 , 0, "MENU");
                end
            end
        end,
        OnEnter = function (rowFrame, cellFrame, data, cols, row, realrow, column)
            if (realrow) then
                if (column == 2 or column == 3) then
                    self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
                end
                if (column > 3) then
                    self:HealByPartyMemberToEachPartyMemberFrame_HealHover(rowFrame, cellFrame, data, cols, row, realrow, column);
                end
            end
        end,
        OnLeave = function (_, _, _, _, _, realrow)
            if (realrow) then
                self:Table_Cell_MouseOut();
            end
        end
    });
    return healByPartyMemberFrame;
end

--[[--
Mouse-over handler for cells with amount of healing done to party members
]]
function MyDungeonsBook:HealByPartyMemberToEachPartyMemberFrame_HealHover(_, cellFrame, data, cols, _, realrow, column)
    if (realrow and column % 3 == 1) then
        local amount = self:FormatNumber(data[realrow].cols[column].value);
        local overkill = self:FormatNumber(data[realrow].cols[column + 1].value);
        local hits = data[realrow].cols[column + 2].value;
        GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE");
        GameTooltip:SetPoint("BOTTOMLEFT", cellFrame, "BOTTOMRIGHT");
        GameTooltip:AddLine(cols[column].name);
        GameTooltip:AddLine(string.format("%s: %s", L["Amount"], amount));
        GameTooltip:AddLine(string.format("%s: %s", L["Over"], overkill));
        GameTooltip:AddLine(string.format("%s: %s", L["Hits"], hits));
        GameTooltip:Show();
    end
end

--[[--
@param[type=number] challengeId
]]
function MyDungeonsBook:HealByPartyMemberToEachPartyMemberFrame_GetColumnsForTable(challengeId)
    local challenge = self:Challenge_GetById(challengeId);
    local player = "Player";
    local party1 = "Party1";
    local party2 = "Party2";
    local party3 = "Party3";
    local party4 = "Party4";
    if (challenge) then
        local players = challenge.players;
        player = (players.player.name and self:ClassColorTextByClassIndex(players.player.class, players.player.name)) or L["Not Found"];
        party1 = (players.party1.name and self:ClassColorTextByClassIndex(players.party1.class, players.party1.name)) or L["Not Found"];
        party2 = (players.party2.name and self:ClassColorTextByClassIndex(players.party2.class, players.party2.name)) or L["Not Found"];
        party3 = (players.party3.name and self:ClassColorTextByClassIndex(players.party3.class, players.party3.name)) or L["Not Found"];
        party4 = (players.party4.name and self:ClassColorTextByClassIndex(players.party4.class, players.party4.name)) or L["Not Found"];
    end
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
            name = " ",
            width = 110,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = player,
            width = 75,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = party1,
            width = 75,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = party2,
            width = 75,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = party3,
            width = 75,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = party4,
            width = 75,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = "",
            width = 1,
            align = "RIGHT"
        },
        {
            name = L["Sum"],
            width = 75,
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
            name = "",
            width = 1,
            align = "RIGHT"
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
function MyDungeonsBook:HealByPartyMemberToEachPartyMemberFrame_GetDataForTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanics) then
        self:DebugPrint(string.format("No Heal To Party Members data for challenge #%s", challengeId));
        return tableData;
    end
    local unitName, unitNameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
    local healDoneByUnit = mechanics[unitName] or mechanics[unitNameAndRealm];
    if (not healDoneByUnit) then
        self:DebugPrint(string.format("No Heal Found for '%s' with name '%s'", unitId, unitName));
        return tableData;
    end
    local sumRow = {cols = {
        {value = -1},
        {value = -1},
        {value = -1}
    }, color = {
        r = 0,
        g = 100,
        b = 0,
        a = 1
    } }
    for i = 1, 18 do
        tinsert(sumRow.cols, {value = 0});
    end
    for spellId, healBySpell in pairs(healDoneByUnit) do
        local row = {cols = {}};
        tinsert(row.cols, {value = spellId});
        tinsert(row.cols, {value = spellId});
        tinsert(row.cols, {value = spellId});
        local amount = 0;
        local hits = 0;
        local over = 0;
        local indx = 4;
        for _, unitId in pairs(self:GetPartyRoster()) do
            local unitName, unitNameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
            local healUnitBySpell = healBySpell[unitName] or healBySpell[unitNameAndRealm] or {overheal = 0, hits = 0, amount = 0};
            tinsert(row.cols, {value = healUnitBySpell.amount});
            tinsert(row.cols, {value = healUnitBySpell.overheal});
            tinsert(row.cols, {value = healUnitBySpell.hits});
            sumRow.cols[indx].value = sumRow.cols[indx].value + healUnitBySpell.amount;
            indx = indx + 1;
            sumRow.cols[indx].value = sumRow.cols[indx].value + healUnitBySpell.overheal;
            indx = indx + 1;
            sumRow.cols[indx].value = sumRow.cols[indx].value + healUnitBySpell.hits;
            indx = indx + 1;
            amount = amount + healUnitBySpell.amount;
            hits = hits + healUnitBySpell.hits;
            over = over + healUnitBySpell.overheal;
        end
        tinsert(row.cols, {value = amount});
        tinsert(row.cols, {value = over});
        tinsert(row.cols, {value = hits});
        sumRow.cols[indx].value = sumRow.cols[indx].value + amount;
        indx = indx + 1;
        sumRow.cols[indx].value = sumRow.cols[indx].value + over;
        indx = indx + 1;
        sumRow.cols[indx].value = sumRow.cols[indx].value + hits;
        indx = indx + 1;
        tinsert(tableData, row);
    end
    tinsert(tableData, sumRow);
    return tableData;
end

--[[--
@param[type=table] row
@param[type=table] cols
@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:HealByPartyMemberToEachPartyMemberFrame_Report_Create(row, cols, challengeId, unitId)
    local spellLink = GetSpellLink(row.cols[1].value);
    local challenge = self:Challenge_GetById(challengeId);
    local title = string.format(L["MyDungeonsBook Heal done by %s with %s:"], challenge.players[unitId].name or "", spellLink);
    return self:Table_PlayersRow_Report_Create(row, cols, {4, 7, 10, 13, 16, 19}, title);
end
