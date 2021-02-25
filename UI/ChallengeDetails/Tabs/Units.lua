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
    local table = self:TableWidget_Create(columns, 10, 40, nil, unitsFrame, "units");
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
    filtersFrame:SetWidth(500);
    filtersFrame:SetTitle(L["Filters"]);
    filtersFrame:SetLayout("Flow");
    parentFrame:AddChild(filtersFrame);

    local npcFilterOptions = {["ALL"] = L["All"]};
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
    for unitGUID, _ in pairs(mechanics) do
        local npcId = self:GetNpcIdFromGuid(unitGUID);
        if (npcId) then
            npcFilterOptions[npcId] = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
        end
    end

    -- NPC filter
    local npcFilter = AceGUI:Create("Dropdown");
    npcFilter:SetWidth(200);
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
    local mechanic = self:Challenge_Mechanic_GetById(challengeId, key);
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
