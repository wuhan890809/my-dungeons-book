--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getEnemyFriendlyFireMenu(rows, index, cols)
    local sourceNpcId = rows[index].cols[9].value;
    local targetNpcId = rows[index].cols[10].value;
    local spellId = rows[index].cols[5].value;
    local sourceNpcName = (MyDungeonsBook.db.global.meta.npcs[sourceNpcId] and MyDungeonsBook.db.global.meta.npcs[sourceNpcId].name) or sourceNpcId;
    local targetNpcName = (MyDungeonsBook.db.global.meta.npcs[targetNpcId] and MyDungeonsBook.db.global.meta.npcs[targetNpcId].name) or targetNpcId;
    local sourceNpcMenu = MyDungeonsBook:WowHead_Menu_Npc(sourceNpcId);
    sourceNpcMenu.text = sourceNpcName;
    local targetNpcMenu = MyDungeonsBook:WowHead_Menu_Npc(targetNpcId);
    targetNpcMenu.text = targetNpcName;
    local spellMenu = MyDungeonsBook:WowHead_Menu_Spell(spellId);
    local spellName = GetSpellInfo(spellId);
    spellMenu.text = spellName;
    local wowHeadMenu = {
        text = L["WowHead"],
        hasArrow = true,
        menuList = {
            sourceNpcMenu
        }
    };
    local report = MyDungeonsBook:EnemiesFriendlyFireFrame_Report_Create(rows[index], cols);
    if (sourceNpcId ~= targetNpcId) then
        tinsert(wowHeadMenu.menuList, targetNpcMenu);
    end
    tinsert(wowHeadMenu.menuList, spellMenu);
    return {
        wowHeadMenu,
        MyDungeonsBook:Report_Menu(report)
    }
end

--[[--
Creates a frame for enemies friendly fire

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:EnemiesFriendlyFireFrame_Create(parentFrame, challengeId)
    local enemiesFriendlyFireFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local data = self:EnemiesFriendlyFireFrame_GetDataForTable(challengeId, "ENEMIES-FRIENDLY-FIRE");
    local columns = self:EnemiesFriendlyFireFrame_GetHeadersForTable(challengeId);
    local table = self:TableWidget_Create(columns, 12, 40, nil, enemiesFriendlyFireFrame, "enemies-friendly-fire");
    table:SetData(data);
    table:RegisterEvents({
        OnClick = function (_, _, data, _, _, realrow, _, _, button)
            if (button == "RightButton" and realrow) then
                EasyMenu(getEnemyFriendlyFireMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
            end
        end,
        OnEnter = function (_, cellFrame, data, _, _, realrow, column, _)
            if (realrow) then
                if (column == 4 or column == 5) then
                    self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[column].value);
                end
            end
        end,
        OnLeave = function (_, _, _, _, _, realrow, column, _)
            if (realrow) then
                if (column == 4 or column == 5) then
                    self:Table_Cell_MouseOut();
                end
            end
        end
    });
    return enemiesFriendlyFireFrame;
end

--[[--
@param[type=string] challengeId
@param[type=string] key
@return[type=table]
]]
function MyDungeonsBook:EnemiesFriendlyFireFrame_GetDataForTable(challengeId, key)
    local tableData = {};
    local challenge = self:Challenge_GetById(challengeId);
    if (not challenge) then
        return tableData;
    end
    local mechanic = self:Challenge_Mechanic_GetById(challengeId, key);
    if (not mechanic) then
        return tableData;
    end
    local mdtEnemiesDb =  IsAddOnLoaded("MythicDungeonTools") and self:Mdt_GetInstanceEnemiesRemapped(challenge.challengeInfo.currentZoneId) or {};
    local mdtOverrides = self.db.global.meta.addons.mythicDungeonTools;
    for _, log in pairs(mechanic.logs) do
        local sourceNpcId = self:GetNpcIdFromGuid(log[4]);
        local targetNpcId = self:GetNpcIdFromGuid(log[8]);
        if (sourceNpcId and targetNpcId) then
            local sourceNpcName = (self.db.global.meta.npcs[sourceNpcId] and self.db.global.meta.npcs[sourceNpcId].name) or sourceNpcId;
            local targetNpcName = (self.db.global.meta.npcs[targetNpcId] and self.db.global.meta.npcs[targetNpcId].name) or targetNpcId;
            local sourceEnemyInfo = mdtOverrides.npcs[sourceNpcId] or mdtEnemiesDb[sourceNpcId] or {};
            local targetEnemyInfo = mdtOverrides.npcs[targetNpcId] or mdtEnemiesDb[targetNpcId] or {};
            local sourcePortraitDisplayId = sourceEnemyInfo.displayId or -1;
            local targetPortraitDisplayId = targetEnemyInfo.displayId or -1;
            tinsert(tableData, {
                cols = {
                    {value = (log[1] - challenge.challengeInfo.startTime) * 1000},
                    {value = sourcePortraitDisplayId},
                    {value = sourceNpcName},
                    {value = log[12]},
                    {value = log[12]},
                    {value = targetPortraitDisplayId},
                    {value = targetNpcName},
                    {value = log[15]},
                    {value = sourceNpcId},
                    {value = targetNpcId},
                }
            });
        end
    end
    return tableData;
end

--[[--
@param[type=string]
@return[type=table]
]]
function MyDungeonsBook:EnemiesFriendlyFireFrame_GetHeadersForTable(challengeId)
    return {
        {
            name = L["Time"],
            align = "LEFT",
            width = 50,
            sort = "dsc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTime(...);
            end,
        },
        {
            name = "",
            width = 40,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTexture(...);
            end,
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
        },
        {
            name = L["Source"],
            width = 150,
            align = "LEFT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
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
            name = "",
            width = 40,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsTexture(...);
            end,
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
        },
        {
            name = L["Target"],
            width = 150,
            align = "LEFT",
            bgcolor = {
                r = 0,
                g = 0,
                b = 0,
                a = 0.4
            },
        },
        {
            name = L["Amount"],
            width = 60,
            align = "RIGHT",
            sort = "asc",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsNumber(...);
            end
        },
        {
            name = "",
            width = 1,
            align = "LEFT"
        },
        {
            name = "",
            width = 1,
            align = "LEFT"
        }
    };
end

--[[--
@local
]]
function MyDungeonsBook:EnemiesFriendlyFireFrame_Report_Create(row, cols)
    return {string.format(L["%s got %s damage from %s with %s"], row.cols[7].value, self:FormatNumber(row.cols[8].value), row.cols[3].value, GetSpellLink(row.cols[5].value))};
end
