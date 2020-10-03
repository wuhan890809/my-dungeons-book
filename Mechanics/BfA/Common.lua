--[[
Original idea for avoidable damage is taken from addon ElitismHelper (thanks to amkoio, talizea) https://www.curseforge.com/wow/addons/elitismhelper
]]

local BfASpells = {
	
	[296142] = true,          -- Shadow Smash (Lost Soul)
	
	-- Affixes
	[209862] = true,		-- Volcanic Plume (Environment)
	[226512] = true,		-- Sanguine Ichor (Environment)

	-- Freehold
	[272046] = true,		--- Dive Bomb (Sharkbait)
	[257426] = true,		--- Brutal Backhand (Irontide Enforcer)
	[258352] = true,		--- Grapeshot (Captain Eudora)
	[256594] = true,		--- Barrel Smash (Captain Raoul)
	[272374] = true,		--- Whirlpool of Blades (Captain Jolly)
	[256546] = true,		--- Shark Tornado (Trothak)
	[257310] = true,		--- Cannon Barrage (Harlan Sweete)
	[257784] = true,		--- Frost Blast (Bilge Rat Brinescale)
	[257902] = true,		--- Shell Bounce (Ludwig Von Tortollan)
	[258199] = true,		--- Ground Shatter (Irontide Crusher)
	[276061] = true,		--- Boulder Throw (Irontide Crusher)
	[258779] = true,		--- Sea Spout (Irontide Oarsman)
	[274400] = true,		--- Duelist Dash (Cutwater Duelist)
	[257274] = true,		--- Vile Coating (Environment)
	[258673] = true,		--- Azerite Grenade (Irontide Crackshot)
	[274389] = true,		--- Rat Traps (Vermin Trapper)
	[257460] = true,		--- Fiery Debris (Harlan Sweete)
	
	-- Shrine of the Storm
	[276268] = true,		--- Heaving Blow (Shrine Templar)
	[267973] = true,		--- Wash Away (Temple Attendant)
	[268059] = true,		--- Anchor of Binding (Tidesage Spiritualist)
	[264155] = true,		--- Surging Rush (Aqu'sirr)
	[267841] = true,		--- Blowback (Galecaller Faye)
	[267899] = true,		--- Hindering Cleave (Brother Ironhull)
	[268280] = true,		--- Tidal Pod (Tidesage Enforcer)
	[276286] = true,		--- Slicing Hurricane (Galecaller Apprentice)
	[276292] = true,		--- Whirlign Slam (Ironhull Apprentice)
	[267385] = true,		--- Tentacle Slam (Vol'zith the Whisperer)
	
	-- Siege of Boralus
	[256627] = true,		--- Slobber Knocker (Kul Tiran Halberd)
	[256663] = true,		--- Burning Tar (Blacktar Bomber)
	[275775] = true,		--- Savage Tempest (Irontide Raider)
	[257292] = true,		--- Heavy Slash (Kul Tiran Vanguard)
	[272426] = true,		--- Sighted Artillery (Ashvane Spotter)
	[257069] = true,		--- Watertight Shell (Kul Tiran Wavetender)
	[273681] = true,		--- Heavy Hitter (Chopper Redhook)
	[272874] = true,		--- Trample (Ashvane Commander)
	[268260] = true,		--- Broadside (Ashvane Cannoneer)
	[269029] = true,		--- Clear the Deck (Dread Captain Lockwood)
	[268443] = true,		--- Dread Volley (Dread Captain Lockwood)
	[272713] = true,		--- Crushing Slam (Bilge Rat Demolisher)
	[274941] = true,		--- Banana Rampage swirlies(Bilge Rat Buccaneer)
	[257883] = true,		--- Break Water (Hadal Darkfathom)
	[276068] = true,		--- Tidal Surge (Hadal Darkfathom)
	[257886] = true,		--- Brine Pool (Hadal Darkfathom)
	[261565] = true,		--- Crashing Tide (Hadal Darkfathom)
	[277535] = true,		--- Viq'Goth's Wrath (Viq'Goth)
	
	-- Tol Dagor
	[257119] = true,		--- Sand Trap (The Sand Queen)
	[257785] = true,		--- Flashing Daggers (Jes Howlis)
	[256976] = true,		--- Ignition (Knight Captain Valyri)
	[256955] = true,		--- Cinderflame (Knight Captain Valyri)
	[256083] = true,		--- Cross Ignition (Overseer Korgus)
	[263345] = true,		--- Massive Blast (Overseer Korgus)
	[258364] = true,		--- Fuselighter (Ashvane Flamecaster)
	[259711] = true,		--- Lockdown (Ashvane Warden)
	[256710] = true,		--- Burning Arsenal (Knight Captain Valyri)
	
	-- Waycrest Manor
	[264531] = true,		--- Shrapnel Trap (Maddened Survivalist)
	[264476] = true,		--- Tracking Explosive (Crazed Marksman)
	[260569] = true,		--- Wildfire (Soulbound Goliath)
	[265407] = true,		--- Dinner Bell (Banquet Steward)
	[264923] = true,		--- Tenderize (Raal the Gluttonous)
	[264712] = true,		--- Rotten Expulsion (Raal the Gluttonous)
	[272669] = true,		--- Burning Fists (Soulbound Goliath)
	[278849] = true,		--- Uproot (Coven Thornshaper)
	[264040] = true,		--- Uprooted Thorns (Coven Thornshaper)
	[265757] = true,		--- Splinter Spike (Matron Bryndle)
	[264150] = true,		--- Shatter (Thornguard)
	[268387] = true,		--- Contagious Remnants (Lord Waycrest)
	[268308] = true,		--- Discordant Cadenza (Lady Waycrest

	-- Atal'Dazar
	[253666] = true,		--- Fiery Bolt (Dazar'ai Juggernaught)
	[257692] = true,		--- Tiki Blaze (Environment)
	[255620] = true,		--- Festering Eruption (Reanimated Honor Guard)
	[258723] = true,		--- Grotesque Pool (Renaimated Honor Guard)
	[250259] = true,		--- Toxic Leap (Vol'kaal)
	[250022] = true,		--- Echoes of Shadra (Yazma)
	[250585] = true, 		--- Toxic Pool (Vol'kaal)
	[250036] = true,		--- Shadowy Remains (Echoes of Shadra)
	[255567] = true,		--- Frenzied Charge (T'lonja)

	-- King's Rest
	[270003] = true,		--- Suppression Slam (Animated Guardian)
	[269932] = true,		--- Ghust Slash (Shadow-Borne Warrior)
	[265781] = true,		--- Serpentine Gust (The Golden Serpent)
	[265914] = true,		--- Molten Gold (The Golden Serpent)
	[270928] = true,		--- Bladestorm (King Timalji)
	[270931] = true,		--- Darkshot (Queen Patlaa)
	[270891] = true,		--- Channel Lightning (King Rahu'ai)
	[266191] = true,		--- Whirling Axe (Council of Tribes)
	[270292] = true,		--- Purifying Flame (Purification Construct)
	[270503] = true,		--- Hunting Leap (Honored Raptor)
	[270514] = true,		--- Ground Crush (Spectral Brute)
	[271564] = true,		--- Embalming Fluid (Embalming Fluid)
	[270485] = true,		--- Blooded Leap (Spectral Berserker)
	[267639] = true,		--- Burn Corruption (Mchimba the Embalmer)
	[268419] = true,		--- Gale Slash (King Dazar)
	[268796] = true,		--- Impaling Spear (King Dazar)
	
	-- The MOTHERLODE!!
	[257371] = true,		--- Gas Can (Mechanized Peace Keeper)
	[262287] = true,		--- Concussion Charge (Mech Jockey / Venture Co. Skyscorcher)
	[268365] = true,		--- Mining Charge (Wanton Sapper)
	[269313] = true,		--- Final Blast (Wanton Sapper)
	[275907] = true,		--- Tectonic Smash (Azerokk)
	[259533] = true,		--- Azerite Catalyst (Rixxa Fluxflame)
	[260103] = true,		--- Propellant Blast (Rixxa Fluxflame)
	[260279] = true,		--- Gattling Gun (Mogul Razdunk)
	[276234] = true, 		--- Micro Missiles (Mogul Razdunk)
	[270277] = true,		--- Big Red Rocket (Mogul Razdunk)
	[271432] = true,		--- Test Missile (Venture Co. War Machine)
	[257337] = true,		--- Shocking Claw (Coin-Operated Pummeler)
	[268417] = true,		--- Power Through (Azerite Extractor)
	[268704] = true,		--- Furious Quake (Stonefury)
	[258628] = true,		--- Resonant Quake (Earthrager)
	[269092] = true,		--- Artillery Barrage (Ordnance Specialist)
	[271583] = true,		--- Black Powder Special (Mines near the track)
	[269831] = true,		--- Toxic Sludge (Oil Environment)

	-- Temple of Sethraliss
	[263425] = true,		--- Arc Dash (Adderis)
	[268851] = true,		--- Lightning Shield (Aspix and Adderis)
	[263573] = true,		--- Cyclone Strike (Adderis)
	[273225] = true,		--- Volley (Sandswept Marksman)
	[272655] = true,		--- Scouring Sand (Mature Krolusk)
	[273995] = true,		--- Pyrrhic Blast (Crazed Incubator)
	[272696] = true,		--- Lightning in a Bottle (Crazed Incubator)
	[264206] = true,		--- Burrow (Merektha)
	[272657] = true,		--- Noxious Breath (Merektha)
	[272821] = true,		--- Call Lightning (Imbued Stormcaller)
	[264763] = true,		--- Spark (Static-charged Dervish)
	[279014] = true,		--- Cardiac Shock (Avatar, Environment)
	
	-- Underrot
	[265542] = true,		--- Rotten Bile (Fetid Maggot)
	[265019] = true,		--- Savage Cleave (Chosen Blood Matron)
	[261498] = true,		--- Creeping Rot (Elder Leaxa)
	[264757] = true,		--- Sanguine Feast (Elder Leaxa)
	[265665] = true,		--- Foul Sludge (Living Rot)
	[260312] = true,		--- Charge (Cragmaw the Infested)
	[265511] = true,		--- Spirit Drain (Spirit Drain Totem)
	[259720] = true,		--- Upheaval (Sporecaller Zancha)
	[270108] = true,		--- Rotting Spore (Unbound Abomination)
	[272609] = true,		--- Maddenin Gaze (Faceless Corruptor)
	[272469] = true,		--- Abyssal Slam (Faceless Corruptor)
	[270108] = true,		--- Rotting Spore (Unbound Abomination)
	
	-- Mechagon Workshop
	[294128] = true,		--- Rocket Barrage (Rocket Tonk)
	[285020] = true,		--- Whirling Edge (The Platinum Pummeler)
	[294291] = true,		--- Process Waste ()
	[291930] = true,		--- Air Drop (K.U-J.0)
	[294324] = true,		--- Mega Drill (Waste Processing Unit)
	[293861] = true,		--- Anti-Personnel Squirrel (Anti-Personnel Squirrel)
	[295168] = true,		--- Capacitor Discharge (Blastatron X-80)
	[294954] = true,		--- Self-Trimming Hedge (Head Machinist Sparkflux)
	
	
	-- Mechagon Junkyard
	[300816] = true,		--- Slimewave (Slime Elemental)
	[300188] = true,		--- Scrap Cannon (Weaponized Crawler)
	[300427] = true,		--- Shockwave (Scrapbone Bully)
	[294890] = true,		--- Gryro-Scrap (Malfunctioning Scrapbot)
	[300129] = true,		--- Self-Destruct Protocol (Malfunctioning Scrapbot)
	[300561] = true,		--- Explosion (Scrapbone Trashtosser)
	[299475] = true,		--- B.O.R.K. (Scraphound)
	[299535] = true,		--- Scrap Blast (Pistonhead Blaster)
	[298940] = true,		--- Bolt Buster (Naeno Megacrash)
	[297283] = true,		--- Cave In (King Gobbamak)
	
	--- Awakened Lieutenant
	[314309] = true,		--- Dark Fury (Urg'roth, Breaker of Heroes)
	[314467] = true,		--- Volatile Rupture (Voidweaver Mal'thir)
	[314565] = true,		--- Defiled Ground (Blood of the Corruptor)
};

local BfASpellsNoTank = {
	-- Freehold

	-- Shrine of the Storm
	
	-- Siege of Boralus
	[268230] = true,		--- Crimson Swipe (Ashvane Deckhand)
	
	-- Tol Dagor
	[258864] = true,		--- Suppression Fire (Ashvane Marine/Spotter)
	
	-- Waycrest Manor
	[263905] = true,		--- Marking Cleave (Heartsbane Runeweaver)
	[265372] = true,		---	Shadow Cleave (Enthralled Guard)
	[271174] = true,		--- Retch (Pallid Gorger)
	
	-- Atal'Dazar

	-- King's Rest
	[270289] = true,		--- Purification Beam (Purification Construct)
	
	-- The MOTHERLODE!!
	[268846] = true,		--- Echo Blade (Weapons Tester)
	[263105] = true,		--- Blowtorch (Feckless Assistant)
	[263583] = true,		--- Broad Slash (Taskmaster Askari)
		
	-- Temple of Sethraliss
	[255741] = true,		--- Cleave (Scaled Krolusk Rider)

	-- Underrot
	[272457] = true,		--- Shockwave (Sporecaller Zancha)
	[260793] = true,		--- Indigestion (Cragmaw the Infested)
	
};

local BfAAuras = {
	-- Freehold
	[274516] = true,		-- Slippery Suds
	
	-- Shrine of the Storm
	[268391] = true,		-- Mental Assault (Abyssal Cultist)
	[269104] = true,		-- Explosive Void (Lord Stormsong)
	[267956] = true,		-- Zap (Jellyfish)
	
	-- Siege of Boralus
	[274942] = true,		-- Banana Stun
	[257169] = true,		-- Fear

	-- Tol Dagor
	[256474] = true,		-- Heartstopper Venom (Overseer Korgus)

	-- Waycrest Manor
	[265352] = true,		-- Toad Blight (Toad)
	[278468] = true,		-- Freezing Trap
	
	-- Atal'Dazar
	[255371] = true,		-- Terrifying Visage (Rezan)
	[257483] = true,        -- Pile of Bones (Rezan void zones with bones)

	-- King's Rest
	[276031] = true,		-- Pit of Despair (Minion of Zul)
	
	-- Temple of Sethraliss
	[269970] = true,		-- Blinding Sand (Merektha)

	-- Underrot

	-- The MOTHERLODE!!
	[280605] = true,        -- Brain Freeze (Refreshment Vendor)
	
	-- Mechagon Workshop
	[293986] = true,		--- Sonic Pulse (Blastatron X-80)
	
	-- Mechaton Junkyard
	[398529] = true,		-- Gooped (Gunker)
	[300659] = true,		-- Consuming Slime (Toxic Monstrosity)
};

local BfAAurasNoTank = {
	[272140] = true,		--- Iron Volley
};

local BfASpellsToInterrupt = {
	-- AD
	[256849] = true, -- Dino Might
	[253583] = true, -- Fiery Enchant
	[253517] = true, -- Mending Word
	[255041] = true, -- Terrifying Screech
	[279118] = true, -- Unstable Hex
	-- FH
	[257397] = true, -- Healing Balm
	[258777] = true, -- Sea Spout
	[257732] = true, -- Shattering Bellow
	[257736] = true, -- Thundering Squall
	-- KR
	[270901] = true, -- Induce Regeneration
	[270492] = true, -- Hex
	[267273] = true, -- Poison Nova
	[269972] = true, -- Shadow Bolt Volley
	[267763] = true, -- Wretched Discharge
	-- MH JY
	[300436] = true, -- Grasping Hex
	[300087] = true, -- Repair
	[300171] = true, -- Repair Protocol
	[300514] = true, -- Stoneskin
	-- MH WS
	[293827] = true, -- Giga-Wallop
	[293930] = true, -- Overclock
	[293729] = true, -- Tune Up
	-- ML
	[269090] = true, -- Artillery Barrage
	[263103] = true, -- Blow Torch
	[268709] = true, -- Earth Shield
	[262554] = true, -- Repair
	[263215] = true, -- Tectonic Barrier
	[268797] = true, -- Transmute: Enemy to Goo
	-- SoB
	[272571] = true, -- Choking Waters
	[274569] = true, -- Revitalizing Mist
	[256957] = true, -- Watertight Shell
	-- SotS
	[268030] = true, -- Mending Rapids
	[267977] = true, -- Tidal Surge
	[274438] = true, -- Tempest
	[267973] = true, -- Wash Away
	[268309] = true, -- Unending Darkness
	-- ToS
	[265968] = true, -- Healing Surge
	[261624] = true, -- Greater Healing Potion
	[267237] = true, -- Drain
	-- TD
	[258128] = true, -- Debilitating Shout
	[257791] = true, -- Howling Fear
	[258935] = true, -- Inner Flames
	[258317] = true, -- Riot Shield
	[258153] = true, -- Watery Dome
	-- UNDR
	[278961] = true, -- Decaying Mind
	[265091] = true, -- Gift of G'huun
	[278755] = true, -- Harrowing Despair
	[272183] = true, -- Raise Dead
	[258347] = true, -- Sonic Screech
	[265433] = true, -- Withering Curse
	-- WM
	[265407] = true, -- Dinner Bell
	[278474] = true, -- Effigy Reconstruction
	[278551] = true, -- Soul Fetish
	[263959] = true, -- Soul Volley
	-- Awakened
	[314592] = true, -- Mind Flay
	[314406] = true, -- Crippling Pestilence
	[314411] = true, -- Lingering Doubt
};

local BfAUnitsAppearsInCombat = {
	-- AD
	[129517] = true, -- Reanimated Raptor
	-- UNDR
	[132051] = true, -- Blood Tick
};

local BfASpecificBuffOrDebuffOnPartyMembers = {
	-- AD
	[255558] = true, -- Tainted Blood
	-- ToS
	[266923] = true, -- Galvanize
	-- UNDR
	[259714] = true, -- Decaying Spores
};

local BfASpecificBuffOrDebuffOnUnit = {
	-- ML
	[271867] = true, -- Pay to Win
};

local BfASpecificCastsDoneByPartyMembers = {
	-- ML
	[255996] = true, -- Punt
	-- TD
	[256578] = true, -- Put Down Gently
};

local BfADamageDoneToSpecificUnits = {
	-- KR
	[136976] = true, -- T'zala
	[136984] = true, -- Reban
	[135406] = true, -- Animated Gold
	-- ML
	[129802] = true, -- Earthrager
	-- MW
	[152033] = true, -- Inconspicuous Plant
};

function MyDungeonsBook:TrackBfAAvoidableSpells(damagedUnit, spellId, amount)
	self:TrackAvoidableSpells("BFA-AVOIDABLE-SPELLS", BfASpells, BfASpellsNoTank, damagedUnit, spellId, amount);
end

function MyDungeonsBook:TrackBfAAvoidableAuras(damagedUnit, spellId)
	self:TrackAvoidableAuras("BFA-AVOIDABLE-AURAS", BfAAuras, BfAAurasNoTank, damagedUnit, spellId);
end

function MyDungeonsBook:TrackBfAPassedCasts(caster, spellId)
	self:TrackPassedCasts("BFA-SPELLS-TO-INTERRUPT", BfASpellsToInterrupt, caster, spellId);
end

function MyDungeonsBook:TrackBfAUnitsAppearsInCombat(sourceUnitGUID, targetUnitGUID)
	self:TrackUnitsAppearsInCombat("BFA-UNITS-APPEARS-IN-COMBAT", BfAUnitsAppearsInCombat, sourceUnitGUID, targetUnitGUID);
end

function MyDungeonsBook:TrackBfASpecificBuffOrDebuffOnPartyMembers(unit, spellId)
	self:TrackSpecificBuffOrDebuffOnPartyMembers("BFA-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS", BfASpecificBuffOrDebuffOnPartyMembers, unit, spellId);
end

function MyDungeonsBook:TrackBfASpecificBuffOrDebuffOnUnit(unit, spellId)
	self:TrackSpecificBuffOrDebuffOnUnit("BFA-BUFFS-OR-DEBUFFS-ON-UNIT", BfASpecificBuffOrDebuffOnUnit, unit, spellId);
end

function MyDungeonsBook:TrackBfASpecificCastDoneByPartyMembers(unit, spellId)
	self:TrackSpecificCastDoneByPartyMembers("BFA-CASTS-DONE-BY-PARTY-MEMBERS", BfASpecificCastsDoneByPartyMembers, unit, spellId);
end

function MyDungeonsBook:TrackBfADamageDoneToSpecificUnits(sourceName, sourceGUID, spellId, amount, overkill, targetName, targetGUID)
	self:TrackDamageDoneToSpecificUnits("BFA-DAMAGE-DONE-TO-UNITS", BfADamageDoneToSpecificUnits, sourceName, sourceGUID, spellId, amount, overkill, targetName, targetGUID);
end