--[[--
@module MyDungeonsBook
]]

--[[--
Mechanics
@section Mechanics
]]

local SLSpells = {
    -- Plaguefall
    [319898] = true, -- Vile Spit (Slime Tentacle)
    [328501] = true, -- Plague Bomb (Rigged Plagueborer)
    [322475] = true, -- Plague Crash (Margrave Stradama adds)
    [322358] = true, -- Burning Strain (Doctor Ickus)
    [318949] = true, -- Festering Belch (Blighted Spinebreaker)
    [330404] = true, -- Wing Buffet
    [328395] = true, -- Venompiercer (Venomous Sniper)
    [328986] = true, -- Violent Detonation (Unstable Canister)
    [322410] = true, -- Withering Filth (Congealed Slime)
    [327233] = true, -- Belch Plague (Plaguebelcher)
    [319120] = true, -- Putrid Bile
    [344001] = true, -- Slime Trail
    [320072] = true, -- Toxic Pool (Decaying Flesh Giant)
    [328177] = true, -- Fungistorm (Fungi Stormer)
    [326242] = true, -- Slime Wave (Globgrog)
    [329217] = true, -- Slime Lunge (Doctor Ickus) -- TODO find out which one is correct
    [329215] = true, -- Slime Lunge (Doctor Ickus)
    [329163] = true, -- Ambush (Stealthlings)
    [330135] = true, -- Fount of Pestilence (Margrave Stradama DoT in her pool)
    -- Spires of Ascension
    [331251] = true, -- Deep Connection (Kin-Tara)
    [324662] = true, -- Ionized Plasma (Kin-Tara)
    [324370] = true, -- Attenuated Barrage (Azules)
    [317661] = true, -- Insidious Venom (Etherdiver)
};

local SLSpellsNoTank = {
    -- Plaguefall
    [330403] = true, -- Wing Buffet (Plaguerocs)
    [330417] = true, -- Mighty Swing (Mire Soldier)
    [322239] = true, -- Touch of Slime (Malignant Spawn)
    [330417] = true, -- Mighty Swing (Mire Soldier)
    [325550] = true, -- Venomblades (Domina Venomblade)
    [327882] = true, -- Blightbeak (Plagueroc)
    [328094] = true, -- Pestilence Bolt
    [329110] = true, -- Slime Injection (Doctor Ickus)
    [335863] = true, -- Nibble (Creepy Crawler)
    [328342] = true, -- Venomfangs
    [334926] = true, -- Wretched Phlegm (Rigged Plagueborer)
    [325552] = true, -- Cytotoxic Slash (Cytotoxic Slash)
    -- Spires of Ascension
    [320966] = true, -- Overhead Slash (Kin-Tara)
};

local SLAuras = {
    -- Plaguefall
    [336301] = true, -- Web Wrap (Domina Venomblade)
    [333406] = true, -- Assassinate (Domina Venomblade adds)
    [344001] = true, -- Slime Trail
    [322358] = true, -- Burning Strain (Doctor Ickus)
    [327882] = true, -- Blightbeak (Plagueroc)
    [319898] = true, -- Vile Spit (Slime Tentacle)
    [319120] = true, -- Putrid Bile
    [328501] = true, -- Plague Bomb (Rigged Plagueborer)
    [320512] = true, -- Corroded Claws (Rotting Slimeclaw)
};

local SLAurasNoTank = {
    [325552] = true, -- Cytotoxic Slash (Domina Venomblade)
};

local SLSpellsToInterrupt = {
    -- Plaguefall
    [319070] = true, -- Corrosive Gunk (Rotmarrow Slime)
    [321999] = true, -- Viral Globs (Pestilence Slime)
    [320103] = true, -- Metamorphosis (Slithering Ooze) It's not interruptable, but npcs should be killed before cast is passed
    [329163] = true, -- Ambush (Stealthling) It's not interruptable, but npcs can be killed or stunned before cast is passed
    -- Spires of Ascension
    [317936] = true, -- Forsworn Doctrine (Forsworn Mender)
    [317963] = true, -- Burden of Knowledge (Forsworn Castigator)
    [327413] = true, -- Rebellious Fist (Forsworn Goliath)
    [328295] = true, -- Greater Mending (Forsworn Warden)
    [328137] = true, -- Dark Pulse (Forsworn Devastator)
    [328331] = true, -- Forced Confession (Forsworn Justicar)
    -- Theater of Pain
    [341902] = true, -- Unholy Fervor (Battlefield Ritualist)
    [341969] = true, -- Withering Discharge (Blighted Sludge-Spewer)
    [342139] = true, -- Battle Trance
    [330562] = true, -- Demoralizing Shout (Ancient Captain)
    -- Necrotic Wake
    [320462] = true, -- Necrotic Bolt
    [324293] = true, -- Rasping Scream (Skeletal Marauder)
    [334748] = true, -- Drain Fluids
    [338353] = true, -- Goresplatter (Corpse Collector)
    [320170] = true, -- Necrotic Bolt
    -- Sanguine Depths
    [319654] = true, -- Hungering Drain (Kryxis the Voracious)
    [322433] = true, -- Stoneskin (Chamber Sentinel)
    [321038] = true, -- Wrack Soul (Wicked Oppressor)
    -- Mists of Tirna Scithe
    [322938] = true, -- Harvest Essence (Drust Harvester)
    [324914] = true, -- Nourish the Forest (Mistveil Tender)
    [324776] = true, -- Bramblethorn Coat (Mistveil Shaper)
    [326046] = true, -- Stimulate Resistance (Spinemaw Staghorn)
    [340544] = true, -- Stimulate Regeneration (Spinemaw Staghorn)
    -- Halls of Atonement
    [325700] = true, -- Collect Sins (Depraved Collector)
    [326607] = true, -- Turn to Stone (Stoneborn Reaver)
    [323552] = true, -- Volley of Power (High Adjudicator Aleez)
    [323538] = true, -- Bolt of Power (High Adjudicator Aleez)
    [326607] = true, -- Turn to Stone (Stoneborn Reaver)
    -- De Other Side
    [332706] = true, -- Heal (Atal'ai High Priest)
    [332612] = true, -- Healing Wave (Atal'ai Hoodoo Hexxer)
    [332084] = true, -- Self-Cleaning Cycle (Lubricator)
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
