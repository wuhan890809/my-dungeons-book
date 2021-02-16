--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Utils
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local prefixes = {
    ["deDE"] = "https://de.",
    ["esES"] = "https://es.",
    ["esMX"] = "https://es.",
    ["frFR"] = "https://fr.",
    ["itIT"] = "https://it.",
    ["koKR"] = "https://ko.",
    ["ptBR"] = "https://pt.",
    ["ruRU"] = "https://ru.",
    ["zhCN"] = "https://cn.",
    ["zhTW"] = "https://cn."
};

function MyDungeonsBook:WowHead_LinkPrefix()
    local locale = GetLocale();
    return prefixes[locale] or "https://";
end

--[[--
Generates Wowhead-URL for item with id `itemId`

URL is locale-specific

@param[type=number] itemId
@return[type=string]
]]
function MyDungeonsBook:WowHead_ItemLink(itemId)
    return string.format("%swowhead.com/item=%s", self:WowHead_LinkPrefix(), itemId);
end

--[[--
Generates Wowhead-URL for spell with id `spellId`

URL is locale-specific

@param[type=number] spellId
@return[type=string]
]]
function MyDungeonsBook:WowHead_SpellLink(spellId)
    return string.format("%swowhead.com/spell=%s", self:WowHead_LinkPrefix(), spellId);
end

--[[--
Generates Wowhead-URL for NPC with id `npcId`

URL is locale-specific

@param[type=number] npcId
@return[type=string]
]]
function MyDungeonsBook:WowHead_NpcLink(npcId)
    return string.format("%swowhead.com/npc=%s", self:WowHead_LinkPrefix(), npcId);
end

--[[--
Generates the context menu-item for item with id `itemId`

@param[type=number] itemId
@return[type=table]
]]
function MyDungeonsBook:WowHead_Menu_Item(itemId)
    return {
        text = L["WowHead"],
        func = function()
            local _, itemLink = GetItemInfo(itemId);
            StaticPopup_Show("MDB_FILLED_WOWHEAD_LINK_INPUT", itemLink, "", self:WowHead_ItemLink(itemId));
        end
    };
end

--[[--
Generates the context menu-item for spell with id `spellId`

@param[type=number] spellId
@return[type=table]
]]
function MyDungeonsBook:WowHead_Menu_Spell(spellId)
    return {
        text = L["WowHead"],
        func = function()
            local spellLink = GetSpellLink(spellId);
            StaticPopup_Show("MDB_FILLED_WOWHEAD_LINK_INPUT", spellLink, "", self:WowHead_SpellLink(spellId));
        end
    };
end

--[[--
Generates the context menu-item for spell's casters

@param[type=number] spellId
@return[type=table]
]]
function MyDungeonsBook:WowHead_Menu_SpellCasters(spellId)
    local npcs = (self.db.global.meta.spells[spellId] and self.db.global.meta.spells[spellId].casters) or nil;
    local npcsSubMenu = {};
    if (not npcs) then
        return nil;
    end
    for npcId, _ in pairs(npcs) do
        local npcSubMenu = self:WowHead_Menu_Npc(npcId);
        npcSubMenu.text = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
        tinsert(npcsSubMenu, npcSubMenu);
    end
    return {
        text = L["Casters"],
        hasArrow = true,
        menuList = npcsSubMenu
    };
end

--[[--
Generates the complex context menu-item for spell and it's casters

@param[type=number] npcId
@return[type=table]
]]
function MyDungeonsBook:WowHead_Menu_SpellComplex(npcId)
    local spellWowHeadMenuItem = self:WowHead_Menu_Spell(npcId);
    spellWowHeadMenuItem.text = L["Spell"];
    local spellCastersWowHeadMenuItem = self:WowHead_Menu_SpellCasters(npcId);
    return {
        text = L["WowHead"],
        hasArrow = true,
        menuList = {
            spellWowHeadMenuItem,
            spellCastersWowHeadMenuItem
        }
    }
end


--[[--
Generates the context menu-item for NPC with id `npcId`

@param[type=number] npcId
@return[type=table]
]]
function MyDungeonsBook:WowHead_Menu_Npc(npcId)
    return {
        text = L["WowHead"],
        func = function()
            local npcName = self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name or npcId;
            StaticPopup_Show("MDB_FILLED_WOWHEAD_LINK_INPUT", npcName, "", self:WowHead_NpcLink(npcId));
        end
    };
end

--[[--
Generates the context menu-item for NPC's spells

@param[type=number] npcId
@return[type=table]
]]
function MyDungeonsBook:WowHead_Menu_NpcSpells(npcId)
    local spells = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].spells) or nil;
    local spellsSubMenu = {};
    if (not spells) then
        return nil;
    end
    for spellId, _ in pairs(spells) do
        local spellSubMenu = self:WowHead_Menu_Spell(spellId);
        spellSubMenu.text = GetSpellInfo(spellId);
        tinsert(spellsSubMenu, spellSubMenu);
    end
    return {
        text = L["Spells"],
        hasArrow = true,
        menuList = spellsSubMenu
    };
end

--[[--
Generates the complex context menu-item for NPC and it's spells

@param[type=number] npcId
@return[type=table]
]]
function MyDungeonsBook:WowHead_Menu_NpcComplex(npcId)
    local npcWowHeadMenuItem = self:WowHead_Menu_Npc(npcId);
    npcWowHeadMenuItem.text = L["NPC"];
    local npcspellsWowHeadMenuItem = self:WowHead_Menu_NpcSpells(npcId);
    return {
        text = L["WowHead"],
        hasArrow = true,
        menuList = {
            npcWowHeadMenuItem,
            npcspellsWowHeadMenuItem
        }
    }
end
