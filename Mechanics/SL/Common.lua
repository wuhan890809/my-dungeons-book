--[[--
@module MyDungeonsBook
]]

--[[--
Mechanics
@section Mechanics
]]

local SLSpells = {
    -- Plaguefall
    [320072] = true, -- Toxic Pool (Decaying Flesh Giant)
    [328177] = true, -- Fungistorm (Fungi Stormer)
    [319120] = true, -- Putrid Bile (Gushing Slime)
    [327233] = true, -- Belch Plague (Plaguebelcher)
    [326242] = true, -- Slime Wave (Globgrog)
    [329217] = true, -- Slime Lunge (Doctor Ickus) -- TODO find out which one is correct
    [329215] = true, -- Slime Lunge (Doctor Ickus)
    [328395] = true, -- Venompiercer (Venomous Sniper)
    [329163] = true, -- Ambush (Stealthlings)
    [318949] = true, -- Festering Belch (Blighted Spinebreaker)
    [322475] = true, -- Plague Crash (Margrave Stradama)
    [330135] = true, -- Fount of Pestilence (Margrave Stradama DoT in her pool)
};

local SLSpellsNoTank = {
    -- Plaguefall
    [330403] = true, -- Wing Buffet (Plaguerocs)
};

local SLAuras = {
    -- Plaguefall
    [336301] = true, -- Web Wrap (Domina Venomblade)
    [333406] = true, -- Assassinate (Domina Venomblade adds)
};

local SLAurasNoTank = {};

local SLSpellsToInterrupt = {
    -- Plaguefall
    [319070] = true, -- Corrosive Gunk (Rotmarrow Slime)
    [321999] = true, -- Viral Globs (Pestilence Slime)
    [320103] = true, -- Metamorphosis (Slithering Ooze) It's not interruptable, but npcs should be killed before cast is passed
    [329163] = true, -- Ambush (Stealthling) It's not interruptable, but npcs can be killed or stunned before cast is passed
};

local SLUnitsAppearsInCombat = {};

local SLSpecificBuffOrDebuffOnPartyMembers = {};

local SLSpecificBuffOrDebuffOnUnit = {
    -- Plaguefall
    [332397] = true, -- Shroudweb (Domina Venomblade adds)
};

local SLSpecificCastsDoneByPartyMembers = {};

local SLSpecificItemsUsedByPartyMembers = {};

local SLDamageDoneToSpecificUnits = {
    -- Plaguefall
    [164362] = true, -- Slimy Morsel (Globgrog adds)
    [171887] = true, -- Slimy Smorgasbord (Globgrog adds)
    [163915] = true, -- Hatchling Nest
    [169159] = true, -- Unstable Canister
    [169498] = true, -- Plague Bomb (Doctor Ickus adds)
    [168837] = true, -- Stealthling
    [170474] = true, -- Brood Assassin (Domina Venomblade adds)
    [165430] = true, -- Malignant Spawn (Margrave Stradama adds)
};

function MyDungeonsBook:GetSLDamageDoneToSpecificUnits()
	return SLDamageDoneToSpecificUnits;
end

function MyDungeonsBook:TrackSLAvoidableSpells(damagedUnit, spellId, amount)
	self:TrackAvoidableSpells("SL-AVOIDABLE-SPELLS", SLSpells, SLSpellsNoTank, damagedUnit, spellId, amount);
end

function MyDungeonsBook:TrackSLAvoidableAuras(damagedUnit, spellId)
	self:TrackAvoidableAuras("SL-AVOIDABLE-AURAS", SLAuras, SLAurasNoTank, damagedUnit, spellId);
end

function MyDungeonsBook:TrackSLPassedCasts(caster, spellId)
	self:TrackPassedCasts("SL-SPELLS-TO-INTERRUPT", SLSpellsToInterrupt, caster, spellId);
end

function MyDungeonsBook:TrackSLUnitsAppearsInCombat(sourceUnitGUID, targetUnitGUID)
	self:TrackUnitsAppearsInCombat("SL-UNITS-APPEARS-IN-COMBAT", SLUnitsAppearsInCombat, sourceUnitGUID, targetUnitGUID);
end

function MyDungeonsBook:TrackSLSpecificBuffOrDebuffOnPartyMembers(unit, spellId)
	self:TrackSpecificBuffOrDebuffOnPartyMembers("SL-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS", SLSpecificBuffOrDebuffOnPartyMembers, unit, spellId);
end

function MyDungeonsBook:TrackSLSpecificBuffOrDebuffOnUnit(sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, auraType, amount)
	self:TrackSpecificAuraAddedToEnemyUnits("SL-BUFFS-OR-DEBUFFS-ON-UNIT", SLSpecificBuffOrDebuffOnUnit, sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, auraType, amount);
end

function MyDungeonsBook:TrackSLSpecificBuffOrDebuffRemovedFromUnit(sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, auraType, amount)
	self:TrackAuraRemovedFromEnemyUnits("SL-BUFFS-OR-DEBUFFS-ON-UNIT", SLSpecificBuffOrDebuffOnUnit, sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, auraType, amount);
end

function MyDungeonsBook:TrackSLSpecificCastDoneByPartyMembers(unit, spellId)
	self:TrackSpecificCastDoneByPartyMembers("SL-CASTS-DONE-BY-PARTY-MEMBERS", SLSpecificCastsDoneByPartyMembers, unit, spellId);
end

function MyDungeonsBook:TrackSLSpecificItemUsedByPartyMembers(unit, spellId)
	self:TrackSpecificItemUsedByPartyMembers("SL-ITEM-USED-BY-PARTY-MEMBERS", SLSpecificItemsUsedByPartyMembers, unit, spellId);
end

function MyDungeonsBook:TrackSLDamageDoneToSpecificUnits(sourceName, sourceGUID, spellId, amount, overkill, targetName, targetGUID)
	self:TrackDamageDoneToSpecificUnits("SL-DAMAGE-DONE-TO-UNITS", SLDamageDoneToSpecificUnits, sourceName, sourceGUID, spellId, amount, overkill, targetName, targetGUID);
end
