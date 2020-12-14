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
    -- The Necrotic Wake
    [345625] = true, -- Death Burst (Nar'zudah <Servant of Amarth>)
    [320574] = true, -- Shadow Well
    [324391] = true, -- Frigid Spikes
    [327952] = true, -- Meat Hook
    [320614] = true, -- Blood Gorge (Carrion Worm)
    [334749] = true, -- Drain Fluids
    [320784] = true, -- Comet Storm (Nalthor the Rimebinder)
    [328212] = true, -- Razorshard Ice
    [324381] = true, -- Chill Scythe
    [327100] = true, -- Noxious Fog
    [333489] = true, -- Necrotic Breath
    [333492] = true, -- Necrotic Ichor
    -- Spires of Ascension
    [327413] = true, -- Rebellious Fist (Forsworn Goliath)
    [336444] = true, -- Crescendo
    [317626] = true, -- Maw-Touched Venom
    [324141] = true, -- Dark Bolt
    [317963] = true, -- Burden of Knowledge (Forsworn Castigator)
    [324370] = true, -- Attenuated Barrage (Azules)
    [331251] = true, -- Deep Connection (Kin-Tara)
    [324662] = true, -- Ionized Plasma (Kin-Tara)
    [323792] = true, -- Anima Field (Coalesced Anima)
    [323372] = true, -- Empyreal Ordnance
    [323943] = true, -- Run Through (Devos)
    -- Mists of Tirna Scithe
    [326309] = true, -- Decomposing Acid
    [326017] = true, -- Decomposing Acid
    [321828] = true, -- Patty Cake (Mistcaller)
    [321893] = true, -- Freezing Burst (Freezing Burst)
    [336759] = true, -- Dodge Ball (Mistcaller)
    [321834] = true, -- Dodge Ball (Mistcaller)
    [322655] = true, -- Acid Expulsion
    [324923] = true, -- Bramble Burst (Drust Boughbreaker)
    [321837] = true, -- Oopsie (Mistcaller)
    -- Theater of Pain
    [320180] = true, -- Noxious Spores (Paceran the Virulent)
    [339415] = true, -- Deafening Crash (Xav the Unfallen)
    [321041] = true, -- Disgusting Burst
    [333297] = true, -- Death Winds
    [332708] = true, -- Ground Smash (Heavin the Breaker)
    [318406] = true, -- Tenderizing Smash (Gorechop)
    -- Halls of Atonement
    [323001] = true, -- Glass Shards (Halkias)
    [324044] = true, -- Refracted Sinlight
    [323126] = true, -- Telekinetic Collision
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
    -- The Necrotic Wake
    [320771] = true, -- Icy Shard (Nalthor the Rimebinder)
    [338456] = true, -- Mutlilate
    [321807] = true, -- Boneflay (Zolramus Bonecarver)
    [320580] = true, -- Melee
    [324323] = true, -- Gruesome Cleave
    [320696] = true, -- Bone Claw
    [338357] = true, -- Tenderize
    [334488] = true, -- Sever Flesh (Surgeon Stitchflesh)
    [333477] = true, -- Gut Slice (Goregrind)
    [320655] = true, -- Crunch (Blightbone)
    [324394] = true, -- Shatter (Skeletal Monstrosity)
    [338636] = true, -- Separate Flesh (Separation Assistant)
    [338653] = true, -- Throw Flesh (Stitching Assistant)
    [320366] = true, -- Embalming Ichor (Surgeon Stitchflesh)
    -- Spires of Ascension
    [320966] = true, -- Overhead Slash (Kin-Tara)
    [317943] = true, -- Sweeping Blow (Forsworn Vanguard)
    [324608] = true, -- Charged Stomp (Oryphrion)
    [328289] = true, -- Blessed Weapon
    [323786] = true, -- Swift Slice (Kyrian Dark-Praetor)
    [327331] = true, -- Imbued Weapon
    [317661] = true, -- Insidious Venom (Etherdiver)
    -- Mists of Tirna Scithe
    [322557] = true, -- Soul Split
    [323057] = true, -- Spirit Bolt (Ingra Maloch)
    -- Theater of Pain
    [326835] = true, -- Cruel Slash (Ossified Conscript)
    [324079] = true, -- Reaping Scythe (Mordretha, the Endless Empress)
    [323515] = true, -- Hateful Strike (Gorechop)
    [330875] = true, -- Spirit Frost (Nefarious Darkspeaker)
    [331319] = true, -- Savage Flurry
    [331320] = true, -- Savage Flurry
    [337178] = true, -- Vicious Strike (Unyielding Contender)
    [324424] = true, -- Reaping Scythe (Mordretha, the Endless Empress)
    [318102] = true, -- Finishing Blow
    [316995] = true, -- Quick Strike
    [331288] = true, -- Colossus Smash (Heavin the Breaker)
    [320063] = true, -- Slam (Dessia the Decapitator)
    [330565] = true, -- Shield Bash (Ancient Captain)
    -- Halls of Atonement
    [344993] = true, -- Jagged Swipe (Vicious Gargon)
    [329321] = true, -- Jagged Swipe (Vicious Gargon)
    [338003] = true, -- Wicked Bolt (Depraved Obliterator)
    [329324] = true, -- Jaws of Stone (Vicious Gargon)
    [326997] = true, -- Powerful Swipe (Stoneborn Slasher)
    [326829] = true, -- Wicked Bolt (Inquisitor Sigar)
    [323437] = true, -- Stigma of Pride (Lord Chamberlain)
    [322936] = true, -- Crumbling Slam (Halkias)
    [323538] = true, -- Bolt of Power (High Adjudicator Aleez)
    [338004] = true, -- Bonk (Toiling Groundskeeper)
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
    -- The Necrotic Wake
    [322681] = true, -- Meat Hook (Stitchflesh's Creation)
    [333492] = true, -- Necrotic Ichor
    [334748] = true, -- Drain Fluids
    [320573] = true, -- Shadow Well (Zolramus Sorcerer)
    [320366] = true, -- Embalming Ichor (Surgeon Stitchflesh)
    [333489] = true, -- Necrotic Breath
    [327100] = true, -- Noxious Fog
    [324293] = true, -- Rasping Scream
    -- Spires of Ascension
    [317963] = true, -- Burden of Knowledge (Forsworn Castigator)
    [317626] = true, -- Maw-Touched Venom
    [323739] = true, -- Residual Impact
    [331251] = true, -- Deep Connection (Kin-Tara)
    [323792] = true, -- Anima Field (Coalesced Anima)
    -- Mists of Tirna Scithe
    [325027] = true, -- Bramble Burst (Drust Boughbreaker)
    [326309] = true, -- Decomposing Acid
    [321828] = true, -- Patty Cake (Mistcaller)
    [326017] = true, -- Decomposing Acid
    [321893] = true, -- Freezing Burst (Illusionary Vulpin)
    -- Halls of Atonement
    [319703] = true, -- Blood Torrent (Echelon)
};

local SLAurasNoTank = {
    -- Plaguefall
    [325552] = true, -- Cytotoxic Slash (Domina Venomblade)
    -- The Necrotic Wake
    [338357] = true, -- Tenderize
    [321807] = true, -- Boneflay (Zolramus Bonecarver)
    [333477] = true, -- Gut Slice (Goregrind)
    -- Halls of Atonement
    [344993] = true, -- Jagged Swipe (Vicious Gargon)
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
    -- The Necrotic Wake
    [320462] = true, -- Necrotic Bolt
    [324293] = true, -- Rasping Scream (Skeletal Marauder)
    [334748] = true, -- Drain Fluids
    [338353] = true, -- Goresplatter (Corpse Collector)
    [320170] = true, -- Necrotic Bolt
    [327130] = true, -- Repair Flesh (Flesh Crafter)
    [335143] = true, -- Bonemend (Zolramus Bonemender)
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
    [323552] = true, -- Volley of Power (High Adjudicator Aleez)
    [323538] = true, -- Bolt of Power (High Adjudicator Aleez)
    [326607] = true, -- Turn to Stone (Stoneborn Reaver)
    -- De Other Side
    [332706] = true, -- Heal (Atal'ai High Priest)
    [332612] = true, -- Healing Wave (Atal'ai Hoodoo Hexxer)
    [332084] = true, -- Self-Cleaning Cycle (Lubricator)
};

local SLUnitsAppearsInCombat = {};

local SLSpecificBuffOrDebuffOnPartyMembers = {
    -- Spires of Ascension
    [330683] = true, -- Raw Anima (Devos)
};

local SLSpecificBuffOrDebuffOnUnit = {
    -- Plaguefall
    [332397] = true, -- Shroudweb (Domina Venomblade adds)
    -- Mists of Tirna Scithe
    [336499] = true, -- Guessing Game (Mistcaller)
};

local SLSpecificCastsDoneByPartyMembers = {
    -- The Necrotic Wake
    [328404] = true, -- Discharged Anima (use)
    [328351] = true, -- Bloody Javelin (use)
    [328128] = true, -- Forgotten Forgehammer (use)
    [325189] = true, -- Discarded Shield (use)
};

local SLSpecificItemsUsedByPartyMembers = {
    -- Warlock Health Stone
    [6262] = 5512, -- Healthstone
    -- Kyrian
    [323436] = 177278, -- Phial of Serenity
    -- Alchemy
    [307192] = 171267, -- Spiritual Healing Potion
    [307193] = 171268, -- Spiritual Mana Potion
    [307495] = 171349, -- Potion of Phantom Fire
    [338385] = 182163, -- Strength of Blood
    [307162] = 171273, -- Potion of Spectral Intellect
    [307159] = 171270, -- Potion of Spectral Agility
    [334436] = 180771, -- Potion of Unusual Strength
    [307164] = 171275, -- Potion of Spectral Strength
    [307497] = 171351, -- Potion of Deathly Fixation
    [307161] = 171272, -- Potion of Spiritual Clarity
    [307494] = 171352, -- Potion of Empowered Exorcisms
    [331974] = 180317, -- Soulful Healing Potion
    [307496] = 171350, -- Potion of Divine Awakening
    [322302] = 176811, -- Potion of Sacrificial Anima
    [307195] = 171266, -- Potion of the Hidden Spirit
    [307163] = 171274, -- Potion of Spectral Stamina
    [307501] = 171370, -- Potion of Specter Swiftness
    [307199] = 171263, -- Potion of Soul Purity
    [331978] = 180318, -- Soulful Mana Potion
    [307160] = 171271, -- Potion of Hardened Shadows
    [307194] = 171269, -- Spiritual Rejuvenation Potion
    [307196] = 171264, -- Potion of Shaded Sight
    -- Trinkets (Raids)
    [344662] = 184025, -- Memory of Past Sins
    [344245] = 184029, -- Manabound Mirror
    [344231] = 184031, -- Sanguine Vintage
    [345019] = 184016, -- Skulker's Wing
    [345432] = 184024, -- Macabre Sheet Music
    [344384] = 184017, -- Bargast's Leash
    [345251] = 184019, -- Soul Igniter
    [344916] = 184020, -- Tuft of Smoldering Plumage
    [345500] = 184021, -- Glyph of Assimilation
    [344732] = 184030, -- Dreadfire Vessel
    -- Trinkets (Dungeons)
    [342423] = 178862, -- Bladedancer's Armor Kit
    [-2] = 178849, -- Overflowing Anima Cage
    [342432] = 178850, -- Lingering Sunmote
    [345549] = 178783, -- Siphoning Phylactery Shard
    [345548] = 178751, -- Spare Meat Hook
    [345547] = 178742, -- Bottled Flayedwing Toxin
    [329852] = 179331, -- Blood-Spattered Scale
    [330323] = 179350, -- Inscrutable Quantum Device TODO or 348098
    [329831] = 179342, -- Overwhelming Power Crystal
    [331523] = 179356, -- Shadowgrasp Totem TODO or 329878
    [345739] = 178811, -- Grim Codex
    [345807] = 178809, -- Soulletting Ruby TODO or 345806
    [-2] = 178810, -- Vial of Spectral Essence
    [-2] = 178715, -- Mistcaller Ocarina
    [343393] = 178826, -- Sunblood Amethyst
    [343399] = 178825, -- Pulsating Stoneheart
    [345595] = 178770, -- Slimy Consumptive Organ
    [345539] = 180117, -- Empyreal Ordnance
    [345530] = 180116, -- Overcharged Anima Battery
    -- Trinkets (Professions)
    [333734] = 173078, -- Darkmoon Deck: Repose
    [311444] = 173096, -- Darkmoon Deck: Indomitable Deck
    [331624] = 173087, -- Darkmoon Deck: Voracity
    [347047] = 173069, -- Darkmoon Deck: Putrescence
    -- Trinkets (PvP)
    [345228] = 175884, -- Sinful Aspirant's Badge of Ferocity (same spell is for item 175921)
    [345231] = 178334, -- Sinful Aspirant's Emblem (same spell is for item 178447)
    [345229] = 178298, -- Sinful Gladiator's Insignia of Alacrity (same spell is for item 178386)
};

local SLDamageDoneToSpecificUnits = {
    [120651] = {}, -- Explosive Orbs
    -- Plaguefall
    [164362] = {}, -- Slimy Morsel (Globgrog adds)
    [171887] = {}, -- Slimy Smorgasbord (Globgrog adds)
    [163915] = {}, -- Hatchling Nest
    [169159] = {}, -- Unstable Canister
    [169498] = {}, -- Plague Bomb (Doctor Ickus adds)
    [168837] = {}, -- Stealthling
    [170474] = {}, -- Brood Assassin (Domina Venomblade adds)
    [165430] = {}, -- Malignant Spawn (Margrave Stradama adds)
    -- The Necrotic Wake
    [163121] = {}, -- Stitched Vanguard
    [164702] = {}, -- Carrion Worm (Blightbone adds)
    [164414] = {}, -- Reanimated Mage (Amarth adds)
    [164427] = {}, -- Reanimated Warrior (Amarth adds)
    [168246] = {}, -- Reanimated Crossbowman (Amarth adds)
    -- Spires of Ascension
    [163077] = {}, -- Azules
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
