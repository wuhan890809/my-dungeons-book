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
function MyDungeonsBook:FriendlyFireByPartyMemberFrame_Create(parentFrame, challengeId, unitId)
    local friendlyFireByPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:FriendlyFireByPartyMemberFrame_GetDataForTable(challengeId, "FRIENDLY-FIRE-BY-PARTY-MEMBERS", unitId);
    local columns = self:FriendlyFireByPartyMemberFrame_GetColumnsForTable(challengeId);
    local table = self:TableWidget_Create(columns, 11, 40, nil, friendlyFireByPartyMemberFrame, "friendly-fire-by-" .. unitId);
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
                    self:FriendlyFireByPartyMemberFrame_DamageHover(rowFrame, cellFrame, data, cols, row, realrow, column);
                end
            end
        end,
        OnLeave = function (_, _, _, _, _, realrow)
            if (realrow) then
                self:Table_Cell_MouseOut();
            end
        end
    });
    return friendlyFireByPartyMemberFrame;
end


--[[--
Mouse-over handler for cells with amount of healing done to party members
]]
function MyDungeonsBook:FriendlyFireByPartyMemberFrame_DamageHover(_, cellFrame, data, cols, _, realrow, column)
    if (realrow and column % 2 == 0) then
        local amount = self:FormatNumber(data[realrow].cols[column].value);
        local hits = data[realrow].cols[column + 1].value;
        GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE");
        GameTooltip:SetPoint("BOTTOMLEFT", cellFrame, "BOTTOMRIGHT");
        GameTooltip:AddLine(cols[column].name);
        GameTooltip:AddLine(string.format("%s: %s", L["Amount"], amount));
        GameTooltip:AddLine(string.format("%s: %s", L["Hits"], hits));
        GameTooltip:Show();
    end
end

--[[--
@param[type=number] challengeId
]]
function MyDungeonsBook:FriendlyFireByPartyMemberFrame_GetColumnsForTable(challengeId)
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
function MyDungeonsBook:FriendlyFireByPartyMemberFrame_GetDataForTable(challengeId, key, unitId)
    local tableData = {};
    if (not challengeId) then
        return tableData;
    end
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanics) then
        self:DebugPrint(string.format("No Friendly Fire by Party Members data for challenge #%s", challengeId));
        return tableData;
    end
    local unitName, unitNameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
    local friendlyFireByUnit = mechanics[unitName] or mechanics[unitNameAndRealm];
    if (not friendlyFireByUnit) then
        self:DebugPrint(string.format("No Friendly Fire Found for '%s' with name '%s'", unitId, unitName));
        return tableData;
    end
    for partyMemberName, damageToPartyMember in pairs(friendlyFireByUnit) do
        for spellId, summaryBySpell in pairs(damageToPartyMember) do
            if (not tableData[spellId]) then
                tableData[spellId] = {};
            end
            local unitId = self:GetPartyUnitByName(challengeId, partyMemberName);
            if (not tableData[spellId][unitId]) then
                tableData[spellId][unitId] = {sum = 0, num = 0};
            end
            self:SafeNestedNumberModify(tableData[spellId][unitId], summaryBySpell.sum, "sum");
            self:SafeNestedNumberModify(tableData[spellId][unitId], summaryBySpell.num, "num");
        end
    end
    local formattedTableData = {};
    for spellId, spellRow in pairs(tableData) do
        local row = {
           cols = {
               {value = spellId},
               {value = spellId},
               {value = spellId}
           }
        };
        local sums = 0;
        local nums = 0;
        for _, unitId in pairs(self:GetPartyRoster()) do
            local sum = (spellRow[unitId] and spellRow[unitId].sum) or 0;
            local num = (spellRow[unitId] and spellRow[unitId].num) or 0;
            tinsert(row.cols, {value = sum});
            tinsert(row.cols, {value = num});
            sums = sums + sum;
            nums = nums + num;
        end
        tinsert(row.cols, {value = sums});
        tinsert(row.cols, {value = nums});
        tinsert(formattedTableData, row);
    end
    return formattedTableData;
end
