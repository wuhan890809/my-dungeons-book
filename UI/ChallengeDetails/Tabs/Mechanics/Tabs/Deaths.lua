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
    local table = self:TableWidget_Create(columns, 13, 40, nil, deathsFrame, "party-deaths");
    table:SetData(data);
    return deathsFrame;
end

--[[--
@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:DeathsFrame_GetColumnsForTable(challengeId)
    return {
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
        local unitMechanic = mechanic[name] or mechanic[nameAndRealm];
        if (unitMechanic and unitMechanic.timeline) then
            local prevStatus = -1;
            local lastTimestamp = -1;
            for _, timelineItem in pairs(unitMechanic.timeline) do
                local currentStatus = timelineItem[2];
                local currentTimestamp = timelineItem[1];
                if (prevStatus == 1 and currentStatus == 0) then
                    local deathTime = lastTimestamp - challenge.challengeInfo.startTime - 10;
                    local releaseTime = currentTimestamp - challenge.challengeInfo.startTime - 10;
                    tinsert(tableData, {
                        cols = {
                            {value = self:GetUnitNameRealmRoleStr(challenge.players[unitId])},
                            {value = deathTime * 1000},
                            {value = releaseTime * 1000},
                            {value = (currentTimestamp - lastTimestamp) * 1000},
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
                {value = string.format(L["%s (start)"], encounterData.name)},
                {value = st * 1000},
                {value = st * 1000},
                {value = ""},
            }
        });
        tinsert(tableData, {
            cols = {
                {value = string.format(L["%s (end)"], encounterData.name)},
                {value = et * 1000},
                {value = et * 1000},
                {value = ""},
            }
        });
    end
    return tableData;
end
