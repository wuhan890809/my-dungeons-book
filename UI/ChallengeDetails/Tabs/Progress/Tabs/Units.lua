--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local AceGUI = LibStub("AceGUI-3.0");

local key = "UNIT-APPEARS-IN-COMBAT";

local function getUnitMenu(rows, index, cols, npcFilter)
    local npcId = rows[index].cols[1].value;
    local npcName = (MyDungeonsBook.db.global.meta.npcs[npcId] and MyDungeonsBook.db.global.meta.npcs[npcId].name) or npcId;
    return {
        MyDungeonsBook:WowHead_Menu_NpcComplex(npcId),
        {
            text = L["Filters"],
            hasArrow = true,
            menuList = {
                {
                    text = npcName,
                    func = function()
                        if (npcFilter) then
                            npcFilter:SetValue(npcId);
                            npcFilter:Fire("OnValueChanged", npcId);
                        end
                    end
                }
            }
        }
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
    self:UnitsFrame_Filters_Create(unitsFrame, challengeId);
    local data = self:UnitsFrame_GetDataForTable(challengeId);
    local columns = self:UnitsFrame_GetHeadersForTable(challengeId);
    local table = self:TableWidget_Create(columns, 17, 25, nil, unitsFrame, "units");
    unitsFrame:SetUserData("unitsTable", table);
    unitsFrame:GetUserData("resetFilters"):Fire("OnClick");
    table:SetSummaryVisible(true);
    table:SetData(data);
    table:RegisterEvents({
        OnClick = function (_, _, data, _, _, realrow, _, _, button)
            local npcFilter = unitsFrame:GetUserData("npcFilter");
            if (button == "RightButton" and realrow) then
                EasyMenu(getUnitMenu(data, realrow, table.cols, npcFilter), self.menuFrame, "cursor", 0 , 0, "MENU");
            end
        end
    });
    table:SetFilter(function(_, row)
        -- NPC
        local npcFilter = self.db.char.filters.units.npc;
        if (npcFilter ~= "ALL") then
            local npc = row.cols[1].value;
            if (npc ~= npcFilter) then
                return false;
            end
        end
        return true;
    end);
    table:SortData();
    table.frame:SetPoint("TOPLEFT", 0, -130);
    return unitsFrame;
end

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:UnitsFrame_Filters_Create(parentFrame, challengeId)
    local filtersFrame = AceGUI:Create("InlineGroup");
    filtersFrame:SetFullWidth(true);
    filtersFrame:SetTitle(L["Filters"]);
    filtersFrame:SetLayout("Flow");
    parentFrame:AddChild(filtersFrame);

    local npcFilterOptions = {["ALL"] = L["All"]};
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanics) then
        return;
    end
    for unitGUID, _ in pairs(mechanics) do
        local npcId = self:GetNpcIdFromGuid(unitGUID);
        if (npcId) then
            npcFilterOptions[npcId] = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
        end
    end

    -- NPC filter
    local npcFilter = AceGUI:Create("Dropdown");
    npcFilter:SetWidth(400);
    npcFilter:SetLabel(L["NPC"]);
    npcFilter:SetList(npcFilterOptions);
    npcFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
        self.db.char.filters.units.npc = filterValue;
        parentFrame:GetUserData("unitsTable"):SortData();
    end);
    filtersFrame:AddChild(npcFilter);
    parentFrame:SetUserData("npcFilter", npcFilter);
    -- Reset filters
    local resetFilters = AceGUI:Create("Button");
    resetFilters:SetText(L["Reset"]);
    resetFilters:SetWidth(90);
    resetFilters:SetCallback("OnClick", function()
        self.db.char.filters.units.npc = "ALL";
        parentFrame:GetUserData("npcFilter"):SetValue("ALL");
        parentFrame:GetUserData("unitsTable"):SortData();
    end);
    parentFrame:SetUserData("resetFilters", resetFilters);
    filtersFrame:AddChild(resetFilters);
    return filtersFrame;
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
            name = "",
            width = 25,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTexture(...);
            end
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
            width = 70,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = L["Combat End"],
            width = 70,
            align = "LEFT",
            sort = "dsc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = L["Combat Duration"],
            width = 70,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = L["Enemy Forces"],
            width = 60,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsEnemiesNeededCount(...);
            end
        },
        {
            name = "",
            width = 1,
            align = "LEFT"
        },
        {
            name = L["Sum"],
            width = 100,
            align = "RIGHT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsEnemiesNeededCount(...);
            end
        }
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
    local mechanic = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanic) then
        return {};
    end
    local challengeStartTime = challenge.challengeInfo.startTime;
    local mdtEnemiesDb =  IsAddOnLoaded("MythicDungeonTools") and self:Mdt_GetInstanceEnemiesRemapped(challenge.challengeInfo.currentZoneId) or {};
    local mdtEnemiesNeededCount = IsAddOnLoaded("MythicDungeonTools") and self:Mdt_GetInstanceNeededEnemiesTotalCount(challenge.challengeInfo.currentZoneId) or "";
    local neededEnemiesCount = challenge.challengeInfo.neededEnemyForces or mdtEnemiesNeededCount;
    local mdtOverrides = self.db.global.meta.addons.mythicDungeonTools;
    local tableData = {};
    for npcGUID, npcData in pairs(mechanic) do
        local npcId = self:GetNpcIdFromGuid(npcGUID);
        if (npcId) then
            local npcName = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
            local combatStart = npcData.firstHit;
            local combatEnd = npcData.died;
            if (mdtOverrides.npcs[npcId] and (mdtOverrides.npcs[npcId].mustDieToCount == false)) then
                combatEnd = combatEnd or npcData.lastCast;
            end
            local ignoreNpc = (mdtOverrides.npcs[npcId] and mdtOverrides.npcs[npcId].ignored) or false;
            if (npcId == 162041) then
                print(npcData.firstHit, npcData.died, npcData.lastCast);
            end
            if (combatStart and combatEnd and not ignoreNpc) then
                local enemyInfo = mdtOverrides.npcs[npcId] or mdtEnemiesDb[npcId] or {};
                local enemyPortraitDisplayId = enemyInfo.displayId or -1;
                local enemyPower = enemyInfo.count or "";
                tinsert(tableData, {
                    cols = {
                        {value = npcId},
                        {value = enemyPortraitDisplayId},
                        {value = npcName},
                        {value = (combatStart - challengeStartTime) * 1000},
                        {value = (combatEnd - challengeStartTime) * 1000},
                        {value = (combatEnd - combatStart) * 1000},
                        {value = enemyPower .. "=" .. (neededEnemiesCount or "") },
                        {value = npcData.died},
                    }
                });
            end
        end
    end
    table.sort(tableData, function(row1, row2)
        return row1.cols[5].value < row2.cols[5].value;
    end);
    local sum = 0;
    for _, row in pairs(tableData) do
        local npcId = row.cols[1].value;
        local enemyInfo = mdtOverrides.npcs[npcId] or mdtEnemiesDb[npcId] or {};
        local mustDieToCount = (mdtOverrides.npcs[npcId] and mdtOverrides.npcs[npcId].mustDieToCount) or false;
        local died = row.cols[8].value;
        local count = enemyInfo.count or 0;
        if (mustDieToCount) then
            if (died) then
                sum = sum + count;
            end
        else
            sum = sum + count;
        end
        tinsert(row.cols, {value = (enemyInfo.count and sum or "") .. "=" .. (neededEnemiesCount or "")});
    end
    return tableData;
end

--[[--
@local
]]
function MyDungeonsBook:Table_Cell_FormatAsEnemiesNeededCount(_, cellFrame, data, _, _, realrow, column)
    local val = data[realrow].cols[column].value or "";
    if (val == "=") then
        cellFrame.text:SetText("");
        return;
    end
    local count, needed = strsplit("=", val);
    count = tonumber(count);
    needed = tonumber(needed);
    if (count and needed) then
        local text = string.format("%s (%s%%)", count, string.format("%.2f", count / needed * 100));
        cellFrame.text:SetText(text);
        return;
    end
    cellFrame.text:SetText("");
end
