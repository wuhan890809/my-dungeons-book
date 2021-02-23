--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getUnitMenu(rows, index)
    local npcId = rows[index].cols[1].value;
    return {
        MyDungeonsBook:WowHead_Menu_NpcComplex(npcId),
    };
end

--[[--
Creates a frame for Units tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] unitsFrame
]]
function MyDungeonsBook:UnitsFrame_Create(parentFrame, challengeId)
    local unitsFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:UnitsFrame_GetDataForTable(challengeId);
    local columns = self:UnitsFrame_GetHeadersForTable(challengeId);
    local table = self:TableWidget_Create(columns, 13, 40, nil, unitsFrame, "units");
    table:SetData(data);
    table:RegisterEvents({
        OnClick = function (_, _, data, _, _, realrow, _, _, button)
            if (button == "RightButton" and realrow) then
                EasyMenu(getUnitMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
            end
        end
    });
    table:SortData();
    return unitsFrame;
end

--[[--
]]
function MyDungeonsBook:UnitsFrame_GetHeadersForTable()
    return {
        {
            name = L["ID"],
            width = 50,
            align = "LEFT"
        },
        {
            name = L["NPC"],
            width = 200,
            align = "LEFT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
        },
        {
            name = L["Combat Start"],
            width = 120,
            align = "LEFT",
            sort = "dsc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = L["Combat End"],
            width = 120,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = L["Combat Duration"],
            width = 120,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },

    };
end

--[[--
@param[type=number]
@return[type=table]
]]
function MyDungeonsBook:UnitsFrame_GetDataForTable(challengeId)
    local challenge = self:Challenge_GetById(challengeId);
    if (not challenge) then
        return {};
    end
    local mechanic = self:Challenge_Mechanic_GetById(challengeId, "UNIT-APPEARS-IN-COMBAT");
    if (not mechanic) then
        return {};
    end
    local challengeStartTime = challenge.challengeInfo.startTime;
    local tableData = {};
    for npcGUID, npcData in pairs(mechanic) do
        local npcId = self:GetNpcIdFromGuid(npcGUID);
        if (npcId) then
            local npcName = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
            local combatStart = npcData.firstHit;
            local combatEnd = npcData.died or npcData.lastCast;
            if (combatStart and combatEnd) then
                tinsert(tableData, {
                    cols = {
                        {value = npcId},
                        {value = npcName},
                        {value = (combatStart - challengeStartTime) * 1000},
                        {value = (combatEnd - challengeStartTime) * 1000},
                        {value = (combatEnd - combatStart) * 1000}
                    }
                });
            end
        end
    end
    return tableData;
end
