--[[--
@module MyDungeonsBook
]]

--[[--
Mechanics
@section Mechanics
]]

local SLSpells = {
    -- Affixes
    [209862] = true, -- Volcanic Plume
    [343520] = true, -- Storming
    [226512] = true, -- Sanguine Ichor (Environment)
    [240448] = true, -- Quaking (Environment)
    [342494] = true, -- Belligerent Boast (Season 1 Pridefull)
    [-174773] = true, -- Spiteful Shade Melee Damage
    [350163] = true, -- Spiteful Shade Melee Damage
    [240446] = true, -- Explosion
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
    [320519] = true, -- Jagged Spines (Blighted Spinebreaker)
    [324667] = true, -- Slime Wave (Globgrog)
    [626242] = true, -- Slime Wave (Globgrog)
    [333808] = true, -- Oozing Outbreak (Doctor Ickus)
    [322492] = true, -- Plague Rot (Margrave Stradama)
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
    [333477] = true, -- Gut Slice (Goregrind)
    [320365] = true, -- Embalming Ichor (Surgeon Stitchflesh)
    [320366] = true, -- Embalming Ichor (Surgeon Stitchflesh)
    [338353] = true, -- Goresplatter (Corpse Collector)
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
    [323786] = true, -- Swift Slice (Kyrian Dark-Praetor)
    [317943] = true, -- Sweeping Blow (Frostsworn Vanguard)
    [324608] = true, -- Charged Stomp (Oryphrion)
    [323740] = true, -- Impact (Forsworn Squad-Leader)
    [336447] = true, -- Crashing Strike (Forsworn Squad-Leader)
    [328466] = true, -- Charged Spear (Lakesis / Klotos)
    [336420] = true, -- Diminuendo (Klotos / Lakesis)
    [321034] = true, -- Charged Spear (Kin-Tara)
    [324141] = true, -- Dark Bolt (Ventunax)
    [323943] = true, -- Run Through (Devos)
    [334625] = true, -- Seed of the Abyss (Devos)
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
    [321968] = true, -- Bewildering Pollen (tirnenn Villager)
    [323137] = true, -- Bewildering Pollen (tirnenn Villager)
    [323250] = true, -- Anima Puddle (Droman Oulfarran)
    [326022] = true, -- Acid Globule (Spinemaw Gorger)
    [340300] = true, -- Tongue Lashing (Mistveil Gorgegullet)
    [340304] = true, -- Poisonous Secretions (Mistveil Gorgegullet)
    [331743] = true, -- Bucking Rampage (Mistveil Guardian)
    [326263] = true, -- Anima Shedding (Tred'ova)
    [325027] = true, -- Bramble Burst (Drust Boughbreaker)
    -- Theater of Pain
    [320180] = true, -- Noxious Spores (Paceran the Virulent)
    [339415] = true, -- Deafening Crash (Xav the Unfallen)
    [321041] = true, -- Disgusting Burst
    [333297] = true, -- Death Winds
    [332708] = true, -- Ground Smash (Heavin the Breaker)
    [318406] = true, -- Tenderizing Smash (Gorechop)
    [337037] = true, -- Whirling Blade (Nekthara the Mangler)
    [331243] = true, -- Bone Spikes (Soulforged Bonereaver)
    [331224] = true, -- Bonestorm (Soulforged Bonereaver)
    [330608] = true, -- Vile Eruption (Rancind Gasbag)
    [317231] = true, -- Crushing Slam (Xav the Unfallen)
    [320729] = true, -- Massive Cleave (Xav the Unfallen)
    [323681] = true, -- Dark Devastation (Mordretha)
    [339573] = true, -- Echos of Carnage (Mordretha)
    [339759] = true, -- Echos of Carnage (Mordretha)
    [339751] = true, -- Ghostly Charge (Mordretha)
    [341969] = true, -- Withering Discharge (Blighted Sludge-Spewer)
    [317367] = true, -- Necrotic Volley
    -- Halls of Atonement
    [323001] = true, -- Glass Shards (Halkias)
    [324044] = true, -- Refracted Sinlight
    [323126] = true, -- Telekinetic Collision
    [325523] = true, -- Deadly Thrust (Depraved Darkblade)
    [325799] = true, -- Rapid Fire (Depraved Houndmaster)
    [326440] = true, -- Sin Quake (Shard of Halkias)
    [322945] = true, -- Heave Debris (Halkias)
    [319702] = true, -- Blood Torrent (Echelon)
    [329113] = true, -- Telekinteic Onslaught (Lord Chamberlain)
    [327885] = true, -- Erupting Torment (Lord Chamberlain)
    [323414] = true, -- Ritual of Woe (Lord Chamberlain)
    -- De Other Side
    [342961] = true, -- Localized Explosive Contrivance (Dealer Xy'exa)
    [320232] = true, -- Explosive Contrivance (Dealer Xy'exa)
    [325691] = true, -- Cosmic Collapse
    [320723] = true, -- Displaced Blastwave (Dealer Xy'exa)
    [323136] = true, -- Anima Starstorm
    [345498] = true, -- Anima Starstorm
    [334913] = true, -- Master of Death (Mueh'zala)
    [328729] = true, -- Dark Lotus
    [332729] = true, -- Malefic Blast
    [333250] = true, -- Reaver (Risen Warlord)
    [331933] = true, -- Haywire
    [331398] = true, -- Volatile Capacitor (Volatile Memory)
    [323118] = true, -- Blood Barrage (Hakkar the Soulflayer)
    [332672] = true, -- Bladestorm
    [334051] = true, -- Erupting Darkness (Death Speaker)
    [342869] = true, -- Enraged Mask (Enraged Spirit)
    [333790] = true, -- Enraged Mask (Enraged Spirit)
    [323569] = true, -- Spilled Essence (Environement)
    [320830] = true, -- Mechanical Bomb Squirrel
    [327427] = true, -- Shattered Dominion (Mueh'zala)
    [335000] = true, -- Stellar cloud (Mueh'zala)
    [334961] = true, -- Crush (Mueh'zala)
    -- Sanguine Depths
    [320999] = true, -- Echoing Thrust (Regal Mistdancer)
    [320991] = true, -- Echoing Thrust (Regal Mistdancer)
    [322418] = true, -- Craggy Fracture
    [323573] = true, -- Residue
    [322212] = true, -- Growing Mistrust (Vestige of Doubt)
    [334563] = true, -- Volatile Trap
    [334615] = true, -- Sweeping Slash
    [325885] = true, -- Anguished Cries (Z'rali)
    [328494] = true, -- Sintouched Anima
    [323810] = true, -- Piercing Blur (General Kaal)
    [336277] = true, -- Explosive Anger (Remnant of Fury)
    [334563] = true, -- Volatile Trap (Dreadful Huntmaster)
    [320991] = true, -- Echoing Thrust (Regal Mistdancer)
    [320999] = true, -- Echoing Thrust (Regal Mistdancer Mirror)
    [334921] = true, -- Umbral Crash (Insatiable Brute)
    [322418] = true, -- Craggy Fracture (Chamber Sentinel)
    [334378] = true, -- Explosive Vellum (Research Scribe)
    [323573] = true, -- Residue (Fleeting Manifestation)
    [325885] = true, -- Anguished Cries (Z'rali)
    [334615] = true, -- Sweeping Slash (Head Custodian Javlin)
    [322212] = true, -- Growing Mistrust (Vestige of Doubt)
    [328494] = true, -- Sintouched Anima (Environement)
    [323810] = true, -- Piercing Blur (General Kaal)
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
    [336444] = true, -- Crescendo (Forsworn Helion)
    -- Mists of Tirna Scithe
    [322557] = true, -- Soul Split
    [323057] = true, -- Spirit Bolt (Ingra Maloch)
    [331721] = true, -- Spear Flurry (Mistveil Defender)
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
    [346866] = true, -- Stone Breathe (Loyal Stoneborn)
    -- De Other Side
    [333711] = true, -- Decrepit Bite (Skeletal Raptor)
    [333728] = true, -- Bonestrike (Risen Bonesoldier)
    [340016] = true, -- Talon Rake (Mythresh, Sky's Talons)
    [334535] = true, -- Beak Slice
    [327649] = true, -- Crushed Soul (Mueh'zala)
    [327646] = true, -- Soulcrusher (Mueh'zala)
    [320147] = true, -- Bleeding (Millificent Manastorm)
    [320145] = true, -- Buzz-Saw
    [328707] = true, -- Scribe (Risen Cultist)
    [331548] = true, -- Metallic Jaws (4.RF-4.RF)
    [322735] = true, -- Piercing Barb (Hakkar the Soulflayer)
    [322736] = true, -- Piercing Barb (Hakkar the Soulflayer)
    [332678] = true, -- Gushing Wound (Atal'ai Deathwalker)
    [332705] = true, -- Smite (Atal'ai High Priest)
    -- Sanguine Depths
    [322429] = true, -- Severing Slice (Chamber Sentinel)
    [320843] = true, -- Thrash
    [321178] = true, -- Slam (Insatiable Brute)
    [335308] = true, -- Crushing Strike (Depths Warden)
    [319650] = true, -- Vicious Headbutt (Kryxis the Voracious)
    [321264] = true, -- Claw (Rockbound Sprite)
    [326718] = true, -- Pierce (Sanguine Cadet)
    [325257] = true, -- Iron Spikes
    [325260] = true, -- Iron Spikes
    [325261] = true, -- Iron Spikes
    [325262] = true, -- Iron Spikes
    [334326] = true, -- Bludgeoning Bash (Head Custodian Javlin)
    [316068] = true, -- Bonk
    [326952] = true, -- Fiery Cantrip (Infused Quill-feather)
    [316244] = true, -- Animate Pebble
};

local SLAuras = {
    -- Affixes
    [342494] = true, -- Belligerent Boast (Manifestation of Pride)
    -- Plaguefall
    [336301] = true, -- Web Wrap (Domina Venomblade)
    [333406] = true, -- Assassinate (Domina Venomblade adds)
    [344001] = true, -- Slime Trail
    [322358] = true, -- Burning Strain (Doctor Ickus)
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
    [323137] = true, -- Bewildering Pollen (Drohman Oulfarran)
    [324859] = true, -- Bramblethorn Entanglement
    -- Halls of Atonement
    [319703] = true, -- Blood Torrent (Echelon)
    -- De Other Side
    [331379] = true, -- Lubricate (Lubricator)
    [323118] = true, -- Blood Barrage (Hakkar the Soulflayer)
    [333250] = true, -- Reaver (Risen Warlord)
    [334913] = true, -- Master of Death (Mueh'zala)
    -- Sanguine Depths
    [321038] = true, -- Wrack Soul (Wicked Oppressor)
    [326836] = true, -- Curse of Suppression (Wicked Oppressor)
    [322212] = true, -- Growing Mistrust (Vestige of Doubt)
    -- Theater of Pain
    [341949] = true, -- Withering Blight
};

local SLAurasNoTank = {
    -- Plaguefall
    [325552] = true, -- Cytotoxic Slash (Domina Venomblade)
    [327882] = true, -- Blightbeak (Plagueroc)
    -- The Necrotic Wake
    [338357] = true, -- Tenderize
    [321807] = true, -- Boneflay (Zolramus Bonecarver)
    [333477] = true, -- Gut Slice (Goregrind)
    -- Halls of Atonement
    [344993] = true, -- Jagged Swipe (Vicious Gargon)
    [326632] = true, -- Stony Veins
    -- Sanguine Depths
    [322429] = true, -- Severing Slice (Chamber Sentinel)
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
    [337255] = true, -- Parasitic Domination (Tred'ova)
    [337249] = true, -- Parasitic Incapacitation (Tred'ova)
    [337235] = true, -- Parasitic Pacification (Tred'ova)
    [321828] = true, -- Patty Cake (MistCaller)
    -- Halls of Atonement
    [325700] = true, -- Collect Sins (Depraved Collector)
    [323552] = true, -- Volley of Power (High Adjudicator Aleez)
    [323538] = true, -- Bolt of Power (High Adjudicator Aleez)
    [326607] = true, -- Turn to Stone (Stoneborn Reaver)
    -- De Other Side
    [332706] = true, -- Heal (Atal'ai High Priest)
    [332612] = true, -- Healing Wave (Atal'ai Hoodoo Hexxer)
    [332084] = true, -- Self-Cleaning Cycle (Lubricator)
    [332605] = true, -- Hex (Atal'ai Hoodoo Hexxer)
};

local SLUnitsAppearsInCombat = {};

local SLSpecificBuffOrDebuffOnPartyMembers = {
    -- Spires of Ascension
    [330683] = true, -- Raw Anima (Devos)
};

local SLSpecificBuffOrDebuffOnUnit = {
    -- De Other Side
    [322773] = true, -- Blood Barrier (Blood Barrier)
    -- Plaguefall
    [332397] = true, -- Shroudweb (Domina Venomblade adds)
    -- Mists of Tirna Scithe
    [336499] = true, -- Guessing Game (Mistcaller)
    [323149] = true, -- Embrace Darkness (Ingra Maloch)
    [322527] = true, -- Gorging Shield (Tred'ova)
    -- Necrotic Wake
    [321754] = true, -- Icebound Aegis (Nalthor the Rimebinder)
    [326629] = true, -- Noxious Fog (Surgeon Stitchflesh)
    -- Sanguine Depths
    [319657] = true, -- Essence Surge (Kryxis the Voracious)
};

local SLSpecificCastsDoneByPartyMembers = {
    -- The Necrotic Wake
    [328404] = true, -- Discharged Anima (use)
    [328351] = true, -- Bloody Javelin (use)
    [328128] = true, -- Forgotten Forgehammer (use)
    [328050] = true, -- Discarded Shield (use)
    -- De Other Side
    [320140] = true, -- Disarming...
    -- Mists of Tirna Scithe
    [340162] = true, -- Savory Statshroom
    [340158] = true, -- Tasty Toughshroom
    -- Halls of Atonement
    [342171] = true, -- Loyal Stoneborn
    -- Sanguine Depths
    [324089] = true, -- Z'rali's Essence
    [324086] = true, -- Shining Radiance
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
    [343385] = 178849, -- Overflowing Anima Cage
    [342432] = 178850, -- Lingering Sunmote
    [345549] = 178783, -- Siphoning Phylactery Shard
    [345548] = 178751, -- Spare Meat Hook
    [345547] = 178742, -- Bottled Flayedwing Toxin
    [329840] = 179331, -- Blood-Spattered Scale
    [330323] = 179350, -- Inscrutable Quantum Device TODO or 348098
    [329831] = 179342, -- Overwhelming Power Crystal
    [331523] = 179356, -- Shadowgrasp Totem
    [345739] = 178811, -- Grim Codex
    [345801] = 178809, -- Soulletting Ruby
    [-2] = 178810, -- Vial of Spectral Essence
    [330067] = 178715, -- Mistcaller Ocarina
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
    [120651] = {
        type = "AFFIX"
    }, -- Explosive Orbs
    [174773] = {
        type = "AFFIX"
    }, -- Spiteful Shade
    [173729] = {
        type = "AFFIX"
    }, -- Manifestation of Pride

    -- Plaguefall
    [164362] = {
        type = "ADD"
    }, -- Slimy Morsel (Globgrog adds)
    [171887] = {
        type = "ADD"
    }, -- Slimy Smorgasbord (Globgrog adds)
    [163915] = {
        type = "MOB"
    }, -- Hatchling Nest
    [169159] = {
        type = "MOB"
    }, -- Unstable Canister
    [169498] = {
        type = "ADD"
    }, -- Plague Bomb (Doctor Ickus adds)
    [168837] = {
        type = "MOB"
    }, -- Stealthling
    [170474] = {
        type = "ADD"
    }, -- Brood Assassin (Domina Venomblade adds)
    [165430] = {
        type = "ADD"
    }, -- Malignant Spawn (Margrave Stradama adds)
    [164255] = {
        type = "BOSS"
    }, -- Globgrog
    [164967] = {
        type = "BOSS"
    }, -- Doctor Ickus
    [164266] = {
        type = "BOSS"
    }, -- Domina Venomblade,
    [164267] = {
        type = "BOSS"
    }, -- Margrave Stradama

    -- The Necrotic Wake
    [163121] = {
        type = "MOB"
    }, -- Stitched Vanguard
    [164702] = {
        type = "ADD"
    }, -- Carrion Worm (Blightbone adds)
    [164414] = {
        type = "ADD"
    }, -- Reanimated Mage (Amarth adds)
    [164427] = {
        type = "ADD"
    }, -- Reanimated Warrior (Amarth adds)
    [168246] = {
        type = "ADD"
    }, -- Reanimated Crossbowman (Amarth adds)
    [162691] = {
        type = "BOSS"
    }, -- Blightbone
    [163157] = {
        type = "BOSS"
    }, -- Amarth
    [162689] = {
        type = "BOSS"
    }, -- Surgeon Stitchflesh
    [162693] = {
        type = "BOSS"
    }, -- Nalthor the Rimebinder

    -- Spires of Ascension
    [163077] = {
        type = "BOSS"
    }, -- Azules
    [162059] = {
        type = "BOSS"
    }, -- Kin-Tara
    [162058] = {
        type = "BOSS"
    }, -- Ventunax
    [162060] = {
        type = "BOSS"
    }, -- Oryphrion
    [162061] = {
        type = "BOSS"
    }, -- Devos

    -- Sanguine Depths
    [168882] = {
        type = "MOB"
    }, -- Fleeting Manifestation
    [162100] = {
        type = "BOSS"
    }, -- Kryxis the Voracious
    [162103] = {
        type = "BOSS"
    }, -- Executor Tarvold
    [162102] = {
        type = "BOSS"
    }, -- Grand Proctor Beryllia
    [162133] = {
        type = "ADD"
    }, -- General Kaal
    [162099] = {
        type = "BOSS"
    }, -- General Kaal
    [165556] = {
        type = "ADD"
    }, -- Fleeting Manifestation

    -- Mists of Tirna Scithe
    [165251] = {
        type = "ADD"
    }, -- Illusionary Vulpin
    [165560] = {
        type = "ADD"
    }, -- Gormling Larva
    [164567] = {
        type = "BOSS"
    }, -- Ingra Maloch
    [164501] = {
        type = "BOSS"
    }, -- Mistcaller
    [164517] = {
        type = "BOSS"
    }, -- Tred'ova
    [164804] = {
        type = "BOSS"
    }, -- Droman Oulfarran

    -- De Other Side
    [165905] = {
        type = "ADD"
    }, -- Son of Hakkar (Hakkar adds),
    [164450] = {
        type = "BOSS",
    }, -- Dealer Xy'exa
    [164558] = {
        type = "BOSS"
    }, -- Hakkar the Soulflayer
    [164555] = {
        type = "BOSS"
    }, -- Millificent Manastorm
    [164556] = {
        type = "BOSS"
    }, -- Millhouse Manastorm
    [166608] = {
        type = "BOSS"
    }, -- Mueh'zala
    [168326] = {
        type = "ADD"
    }, -- Shattered Visage

    -- Halls of Atonement
    [165408] = {
        type = "BOSS"
    }, -- Halkias
    [164185] = {
        type = "BOSS"
    }, -- Echelon
    [165410] = {
        type = "BOSS"
    }, -- High Adjudicator Aleez
    [164218] = {
        type = "BOSS"
    }, -- Lord Chamberlain

    -- Theater of Pain
    [164451] = {
        type = "BOSS"
    }, -- Dessia the Decapitator
    [164463] = {
        type = "BOSS"
    }, -- Paceran the Virulent
    [164461] = {
        type = "BOSS"
    }, -- Sathel the Accursed
    [162317] = {
        type = "BOSS"
    }, -- Gorechop
    [162329] = {
        type = "BOSS"
    }, -- Xav the Unfallen
    [162309] = {
        type = "BOSS"
    }, -- Kul'tharok
    [165946] = {
        type = "BOSS"
    }, -- Mordretha, the Endless Empress
    [170234] = {
        type = "ADD"
    }, -- Oppressive Banner
};

function MyDungeonsBook:GetSLDamageDoneToSpecificUnits()
	return SLDamageDoneToSpecificUnits;
end

function MyDungeonsBook:GetSLSpellsToInterrupt()
    return SLSpellsToInterrupt;
end

function MyDungeonsBook:GetSLAvoidableSpells()
    return SLSpells;
end

function MyDungeonsBook:GetSLAvoidableSpellsNoTank()
    return SLSpellsNoTank;
end

function MyDungeonsBook:TrackSLAvoidableSpells(damagedUnit, spellId, amount)
	self:TrackAvoidableSpells("SL-AVOIDABLE-SPELLS", SLSpells, SLSpellsNoTank, damagedUnit, spellId, amount);
end

function MyDungeonsBook:TrackSLAvoidableAuras(damagedUnit, spellId)
	self:TrackAvoidableAuras("SL-AVOIDABLE-AURAS", SLAuras, SLAurasNoTank, damagedUnit, spellId);
end

function MyDungeonsBook:TrackSLPassedCasts(caster, spellId, raidFlags)
	self:TrackPassedCasts("SL-SPELLS-TO-INTERRUPT", SLSpellsToInterrupt, caster, spellId, raidFlags);
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
