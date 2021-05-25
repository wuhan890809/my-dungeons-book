--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local AceGUI = LibStub("AceGUI-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local key = "AURAS_BROKEN";

local function getBrokenAurasMenu(rows, index, cols, npcFilter, auraFilter)
    local brokenAuraId = rows[index].cols[4].value;
    local spellId = rows[index].cols[7].value;
    local npcId = rows[index].cols[9].value;
    local npcMenu = MyDungeonsBook:WowHead_Menu_Npc(npcId);
    local npcName = MyDungeonsBook.db.global.meta.npcs[npcId] and MyDungeonsBook.db.global.meta.npcs[npcId].name or npcId;
    npcMenu.text = npcName;
    local brokenAuraMenu = MyDungeonsBook:WowHead_Menu_Spell(brokenAuraId);
    local brokenAuraName = GetSpellInfo(brokenAuraId);
    brokenAuraMenu.text = brokenAuraName;
    local spellMenu = MyDungeonsBook:WowHead_Menu_Spell(spellId);
    local spellName = GetSpellInfo(spellId);
    spellMenu.text = spellName;
    local report = MyDungeonsBook:BrokenAurasFrame_BrokenAuraReport_Create(rows[index], cols);
    return {
        {
            text = L["WowHead"],
            hasArrow = true,
            menuList = {
                npcMenu,
                brokenAuraMenu,
                spellMenu,
            }
        },
        MyDungeonsBook:Report_Menu(report),
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
                },
                {
                    text = GetSpellInfo(brokenAuraId),
                    func = function()
                        if (auraFilter) then
                            auraFilter:SetValue(brokenAuraId);
                            auraFilter:Fire("OnValueChanged", brokenAuraId);
                        end
                    end
                }
            }
        }
    };
end

--[[--
Create a frame for Broken Auras tab (data is taken from `mechanics[AURAS_BROKEN]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:BrokenAurasFrame_Create(parentFrame, challengeId)
    local brokenAurasFrame = self:TabContentWrapperWidget_Create(parentFrame);
    self:BrokenAurasFrame_Filters_Create(brokenAurasFrame, challengeId);
    local data = self:BrokenAurasFrame_GetDataForTable(challengeId, key);
    local columns = self:BrokenAurasFrame_GetHeadersForTable(challengeId);
    local table = self:TableWidget_Create(columns, 10, 40, nil, brokenAurasFrame, "broken-auras");
    table:SetData(data);
    table:RegisterEvents({
        OnEnter = function (_, cellFrame, data, _, _, realrow, column)
            if (realrow) then
                if (column == 4 or column == 5) then
                    self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[4].value);
                end
                if (column == 7 or column == 8) then
                    self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[7].value);
                end
            end
        end,
        OnLeave = function (_, _, _, _, _, realrow, column)
            if (realrow) then
                if (column == 4 or column == 5 or column == 7 or column == 8) then
                    self:Table_Cell_MouseOut();
                end
            end
        end,
        OnClick = function(_, _, data, _, _, realrow, _, _, button)
            if (button == "RightButton" and realrow) then
                local npcFilter = brokenAurasFrame:GetUserData("npcFilter");
                local auraFilter = brokenAurasFrame:GetUserData("auraFilter");
                EasyMenu(getBrokenAurasMenu(data, realrow, table.cols, npcFilter, auraFilter), self.menuFrame, "cursor", 0 , 0, "MENU");
            end
        end
    });
    table:SetFilter(function(_, row)
        -- NPC
        local npcFilter = self.db.char.filters.brokenAuras.npc;
        if (npcFilter ~= "ALL") then
            local npc = row.cols[9].value;
            if (npc ~= npcFilter) then
                return false;
            end
        end
        -- Aura
        local auraFilter = self.db.char.filters.brokenAuras.aura;
        if (auraFilter ~= "ALL") then
            local aura = row.cols[4].value;
            if (aura ~= auraFilter) then
                return false;
            end
        end
        return true;
    end);
    table.frame:SetPoint("TOPLEFT", 0, -130);
    brokenAurasFrame:SetUserData("brokenAurasTable", table);
    brokenAurasFrame:GetUserData("resetFilters"):Fire("OnClick");
    return brokenAurasFrame;
end

--[[--
@param[type=number] challengeId
@param[type=string] key
@return[type=table]
]]
function MyDungeonsBook:BrokenAurasFrame_GetDataForTable(challengeId, key)
    local tableData = {};
    local challenge = self:Challenge_GetById(challengeId);
    if (not challenge) then
        return tableData;
    end
    local mechanic = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanic) then
        self:DebugPrint("No Broken Auras found");
        return tableData;
    end
    local mdtEnemiesDb =  IsAddOnLoaded("MythicDungeonTools") and self:Mdt_GetInstanceEnemiesRemapped(challenge.challengeInfo.currentZoneId) or {};
    local mdtOverrides = self.db.global.meta.addons.mythicDungeonTools;
    for unitName, breaks in pairs(mechanic) do
        for _, brokenAuraInfo in pairs(breaks.breaks) do
            local npcId = self:GetNpcIdFromGuid(brokenAuraInfo.targetUnitGUID or brokenAuraInfo.targetUnitGIUD);
            local enemyInfo = mdtOverrides.npcs[npcId] or mdtEnemiesDb[npcId] or {};
            local enemyPortraitDisplayId = enemyInfo.displayId or -1;
            tinsert(tableData, {
               cols = {
                   {value = (brokenAuraInfo.timestamp - challenge.challengeInfo.startTime) * 1000},
                   {value = enemyPortraitDisplayId},
                   {value = brokenAuraInfo.targetUnitName},
                   {value = brokenAuraInfo.brokenSpellId},
                   {value = brokenAuraInfo.brokenSpellId},
                   {value = unitName},
                   {value = brokenAuraInfo.spellId},
                   {value = brokenAuraInfo.spellId},
                   {value = npcId}
               }
            });
        end
    end
    return tableData;
end

--[[--
@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:BrokenAurasFrame_GetHeadersForTable(challengeId)
    return {
        {
            name = L["Time"],
            width = 35,
            align = "RIGHT",
            sort = "dsc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end
        },
        {
            name = "",
            width = 40,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTexture(...);
            end
        },
        {
            name = L["Target"],
            width = 130,
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
            name = L["Aura"],
            width = 100,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = L["Broken By"],
            width = 150,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsPartyMember(challengeId, ...);
            end
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
            width = 100,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
            end
        },
        {
            name = "",
            width = 1,
            align = "LEFT"
        }
    };
end

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:BrokenAurasFrame_Filters_Create(parentFrame, challengeId)
    local filtersFrame = AceGUI:Create("InlineGroup");
    filtersFrame:SetFullWidth(true);
    filtersFrame:SetWidth(500);
    filtersFrame:SetTitle(L["Filters"]);
    filtersFrame:SetLayout("Flow");
    parentFrame:AddChild(filtersFrame);

    local npcFilterOptions = {["ALL"] = L["All"]};
    local auraFilterOptions = {["ALL"] = L["All"]};
    local mechanic = self:Challenge_Mechanic_GetById(challengeId, key) or {};
    for _, breaks in pairs(mechanic) do
        for _, brokenAuraInfo in pairs(breaks.breaks) do
            local npcId = self:GetNpcIdFromGuid(brokenAuraInfo.targetUnitGUID or brokenAuraInfo.targetUnitGIUD);
            npcFilterOptions[npcId] = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
            auraFilterOptions[brokenAuraInfo.brokenSpellId] = GetSpellInfo(brokenAuraInfo.brokenSpellId);
        end
    end

    -- NPC filter
    local npcFilter = AceGUI:Create("Dropdown");
    npcFilter:SetWidth(200);
    npcFilter:SetLabel(L["NPC"]);
    npcFilter:SetList(npcFilterOptions);
    npcFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
        self.db.char.filters.brokenAuras.npc = filterValue;
        parentFrame:GetUserData("brokenAurasTable"):SortData();
    end);
    filtersFrame:AddChild(npcFilter);
    parentFrame:SetUserData("npcFilter", npcFilter);
    -- Aura filter
    local auraFilter = AceGUI:Create("Dropdown");
    auraFilter:SetWidth(200);
    auraFilter:SetValue(self.db.char.filters.brokenAuras.aura);
    auraFilter:SetLabel(L["Aura"]);
    auraFilter:SetList(auraFilterOptions);
    auraFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
        self.db.char.filters.brokenAuras.aura = filterValue;
        parentFrame:GetUserData("brokenAurasTable"):SortData();
    end);
    filtersFrame:AddChild(auraFilter);
    parentFrame:SetUserData("auraFilter", auraFilter);
    -- Reset filters
    local resetFilters = AceGUI:Create("Button");
    resetFilters:SetText(L["Reset"]);
    resetFilters:SetWidth(90);
    resetFilters:SetCallback("OnClick", function()
        self.db.char.filters.brokenAuras.npc = "ALL";
        self.db.char.filters.brokenAuras.aura = "ALL";
        parentFrame:GetUserData("auraFilter"):SetValue("ALL");
        parentFrame:GetUserData("npcFilter"):SetValue("ALL");
        parentFrame:GetUserData("brokenAurasTable"):SortData();
    end);
    parentFrame:SetUserData("resetFilters", resetFilters);
    filtersFrame:AddChild(resetFilters);
    return filtersFrame;
end


--[[--
@local
]]
function MyDungeonsBook:BrokenAurasFrame_BrokenAuraReport_Create(row, cols)
    local spellId = row.cols[7].value;
    local spell = spellId > 0 and GetSpellLink(row.cols[7].value) or L["Swing Damage"];
    return {string.format(L["%s broke %s on %s using %s"], row.cols[6].value, GetSpellLink(row.cols[4].value) or "", row.cols[3].value, spell)};
end
