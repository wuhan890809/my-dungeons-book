--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Create a frame for All Buffs On Party Members tab (data is taken from `mechanics[ALL-AURAS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:AllBuffsOnPartyMemberFrame_Create(parentFrame)
    local ScrollingTable = LibStub("ScrollingTable");
    local interruptsFrame = CreateFrame("Frame", nil, parentFrame);
    interruptsFrame:SetWidth(900);
    interruptsFrame:SetHeight(490);
    interruptsFrame:SetPoint("TOPLEFT", 0, -120);
    local tableWrapper = CreateFrame("Frame", nil, interruptsFrame);
    tableWrapper:SetWidth(600);
    tableWrapper:SetHeight(450);
    tableWrapper:SetPoint("TOPLEFT", 0, 0);
    local cols = self:Table_Headers_GetForSpellsSummary();
    local table = ScrollingTable:CreateST(cols, 10, 40, nil, tableWrapper);
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
    tableWrapper.table = table;
    return tableWrapper;
end

--[[--
Map data about all buffs for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table
@param[type=string] neededType "BUFF" or "DEBUFF"
@return[type=table]
]]
function MyDungeonsBook:AllBuffsOnPartyMemberFrame_GetDataForTable(challengeId, key, neededType)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    if (not self.db.char.challenges[challengeId].mechanics[key]) then
        self:DebugPrint(string.format("No All Buffs data for challenge #%s", challengeId));
        return {};
    end
    for name, buffsAndDebuffsOnUnit in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
        for buffOnDebuffId, buffOrDebuffSummary in pairs(buffsAndDebuffsOnUnit) do
            if (buffOrDebuffSummary.auraType == neededType or (self.db.global.meta.spells[buffOnDebuffId] and self.db.global.meta.spells[buffOnDebuffId].auraType == neededType)) then
                if (not tableData[buffOnDebuffId]) then
                    tableData[buffOnDebuffId] = {
                        spellId = buffOnDebuffId
                    };
                    for _, unitId in pairs(self:GetPartyRoster()) do
                        tableData[buffOnDebuffId][unitId] = 0;
                    end
                end
                local partyUnitId = self:GetPartyUnitByName(challengeId, name);
                if (partyUnitId) then
                    tableData[buffOnDebuffId][partyUnitId] = buffOrDebuffSummary.count;
                else
                    self:DebugPrint(string.format("%s not found in the challenge party roster", name));
                end
            end
        end
    end
    local remappedTableData = {};
    for _, row in pairs(tableData) do
        local r = {
            cols = {}
        };
        tinsert(r.cols, {value = row.spellId});
        tinsert(r.cols, {value = row.spellId});
        tinsert(r.cols, {value = row.spellId});
        local sum = 0;
        for _, unitId in pairs(self:GetPartyRoster()) do
            tinsert(r.cols, {value = row[unitId]});
            if (row[unitId]) then
                sum = sum + row[unitId];
            end
        end
        tinsert(r.cols, {value = sum});
        tinsert(remappedTableData, r);
    end
    return remappedTableData;
end

--[[--
Update All Buffs On Party Members tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:AllBuffsOnPartyMemberFrame_Update(challengeId)
    local challenge = self.db.char.challenges[challengeId];
    if (challenge) then
        local allBuffsOnPartyMembersTableData = self:AllBuffsOnPartyMemberFrame_GetDataForTable(challengeId, "ALL-AURAS", "BUFF");
        self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.allBuffsOnPartyMembersFrame.table:SetData(allBuffsOnPartyMembersTableData);
        self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.allBuffsOnPartyMembersFrame.table:SetDisplayCols(self:Table_Headers_GetForSpellsSummary(challengeId));
        self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.allBuffsOnPartyMembersFrame.table:SortData();
    end
end
