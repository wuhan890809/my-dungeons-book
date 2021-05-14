--[[--
Thanks to all Mythic Dungeon Tools authors https://www.curseforge.com/wow/addons/mythic-dungeon-tools and personally for Nnoggie
]]

-- WoW Instance indexes are from https://wowpedia.fandom.com/wiki/InstanceID
local wowInstancesToMdtInstances = {
    -- [WoW Instance Index] = MDT Instance Index
    -- Shadowlands
    [2291] = 29, -- De Other Side
    [2287] = 30, -- Halls of Atonement
    [2290] = 31, -- Mists of Tirna Scithe
    [2289] = 32, -- Plaguefall
    [2284] = 33, -- Sanguine Depths
    [2285] = 34, -- Spires of Ascension
    [2286] = 35, -- The Necrotic Wake
    [2293] = 36, -- Theater of Pain
};

--[[
@param[type=number] wowInstanceIndex
@return[type=number]
]]
function MyDungeonsBook:Mdt_GetInstanceIndexByWowInstanceIndex(wowInstanceIndex)
    return wowInstancesToMdtInstances[wowInstanceIndex];
end

--[[--
@param[type=number] mdtOrWowInstanceIndex
@return[type=?table]
]]
function MyDungeonsBook:Mdt_GetInstanceEnemiesByInstanceIndex(mdtOrWowInstanceIndex)
    local mdtInstanceIndex = self:Mdt_GetInstanceIndexByWowInstanceIndex(mdtOrWowInstanceIndex);
    local indexToUse = mdtInstanceIndex or mdtOrWowInstanceIndex;
    if (indexToUse) then
        return MDT.dungeonEnemies[indexToUse];
    end
    return nil;
end

--[[--
@param[type=number] mdtOrWowInstanceIndex
@return[type=table]
]]
function MyDungeonsBook:Mdt_GetInstanceEnemiesRemapped(mdtOrWowInstanceIndex)
    local instanceEnemies = self:Mdt_GetInstanceEnemiesByInstanceIndex(mdtOrWowInstanceIndex);
    local remappedInstanceEnemies = {};
    if (instanceEnemies) then
        for _, v in pairs(instanceEnemies) do
            remappedInstanceEnemies[v.id] = v;
        end
    end
    return remappedInstanceEnemies;
end

--[[--
@param[type=number] mdtOrWowInstanceIndex
@return[type=?number]
]]
function MyDungeonsBook:Mdt_GetInstanceNeededEnemiesTotalCount(mdtOrWowInstanceIndex)
    local mdtInstanceIndex = self:Mdt_GetInstanceIndexByWowInstanceIndex(mdtOrWowInstanceIndex);
    local indexToUse = mdtInstanceIndex or mdtOrWowInstanceIndex;
    local dungeonTotalCount = MDT.dungeonTotalCount[indexToUse];
    return (dungeonTotalCount and dungeonTotalCount.normal) or nil;
end
