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
function MyDungeonsBook:AllDebuffsOnPartyMemberFrame_Create(parentFrame, challengeId)
    local allDebuffsOnPartyMemberFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:AllDebuffsOnPartyMemberFrame_GetDataForTable(challengeId, "ALL-AURAS", "DEBUFF");
    local columns = self:Table_Headers_GetForSpellsSummary(challengeId);
    local table = self:TableWidget_Create(columns, 11, 40, nil, allDebuffsOnPartyMemberFrame, "all-debuffs-on-party-members");
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
    return allDebuffsOnPartyMemberFrame;
end

--[[--
Map data about all buffs for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table
@param[type=string] neededType "BUFF" or "DEBUFF"
@return[type=table]
]]
function MyDungeonsBook:AllDebuffsOnPartyMemberFrame_GetDataForTable(challengeId, key, neededType)
    local tableData = {};
    if (not challengeId) then
        return nil;
    end
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanics) then
        self:DebugPrint(string.format("No All Buffs data for challenge #%s", challengeId));
        return {};
    end
    for name, buffsAndDebuffsOnUnit in pairs(mechanics) do
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
