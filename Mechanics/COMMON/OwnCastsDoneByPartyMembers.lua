-- Thanks to NNoggie https://wago.io/PartyCDs
local OwnCastsDoneByPartyMembers = {
    --[[
        DAMAGE
    ]]
    [258925] = true, -- Fel Barrage
    [191427] = true, -- Metamorphosis
    [275699] = true, -- Apocalypse
    [42650] = true, -- Army of the Dead
    [152279] = true, -- Breath of Sindra
    [63560] = true, -- Dark Transformat
    [279302] = true, -- Frostwyrm's Fury
    [51271] = true, -- Pillar of Frost
    [49206] = true, -- Summon Gargoyle
    [207289] = true, -- Unholy Assault
    [115989] = true, -- Unholy Blight
    [106951] = true, -- Berserk
    [194223] = true, -- Celestial Alignm
    [202770] = true, -- Fury of Elune
    [319454] = true, -- Heart of the Wil
    [102560] = true, -- Incarnation: Cho
    [102543] = true, -- Incarnation: Kin
    [193530] = true, -- Aspect of the Wi
    [19574] = true, -- Bestial Wrath
    [321530] = true, -- Bloodshed
    [266779] = true, -- Coordinated Assa
    [260402] = true, -- Double Tap
    [201430] = true, -- Stampede
    [288613] = true, -- Trueshot
    [12042] = true, -- Arcane Power
    [190319] = true, -- Combustion
    [84714] = true, -- Frozen Orb
    [12472] = true, -- Icy Veins
    [55342] = true, -- Mirror Image
    [321507] = true, -- Touch of the Mag
    [113656] = true, -- Fists of Fury
    [123904] = true, -- Invoke Xuen, the
    [152173] = true, -- Serenity
    [137639] = true, -- Storm, Earth, an
    [322109] = true, -- Touch of Death
    [31884] = true, -- Avenging Wrath
    [231895] = true, -- Crusade
    [343721] = true, -- Final Reckoning
    [105809] = true, -- Holy Avenger
    [10060] = true, -- Power Infusion
    [319952] = true, -- Surrender to Mad
    [228260] = true, -- Void Eruption
    [13750] = true, -- Adrenaline Rush
    [13877] = true, -- Blade Flurry
    [271877] = true, -- Blade Rush
    [343142] = true, -- Dreadblades
    [51690] = true, -- Killing Spree
    [121471] = true, -- Shadow Blades
    [277925] = true, -- Shuriken Tornado
    [79140] = true, -- Vendetta
    [51533] = true, -- Feral Spirit
    [198067] = true, -- Fire Elemental
    [192249] = true, -- Fire Elemental
    [191634] = true, -- Stormkeeper
    [152108] = true, -- Cataclysm
    [113858] = true, -- Dark Soul: Insta
    [113860] = true, -- Dark Soul: Miser
    [111898] = true, -- Grimoire: Felgua
    [267217] = true, -- Nether Portal
    [205180] = true, -- Summon Darkglare
    [265187] = true, -- Summon Demonic T
    [1122] = true, -- Summon Infernal
    [107574] = true, -- Avatar
    [262228] = true, -- Deadly Calm
    [228920] = true, -- Ravager
    [152277] = true, -- Ravager
    [1719] = true, -- Recklessness
    [280772] = true, -- Siegebreaker
    --[[
        EXTERNAL
    ]]
    [102342] = true, -- Ironbark
    [116849] = true, -- Life Cocoon
    [1022] = true, -- Blessing of Prot
    [6940] = true, -- Blessing of Sacr
    [204018] = true, -- Blessing of Spel
    [633] = true, -- Lay on Hands
    [47788] = true, -- Guardian Spirit
    [33206] = true, -- Pain Suppression
    [207399] = true, -- Ancestral Protec
    [3411] = true, -- Intervene
    --[[
        HARD CC
    ]]
    [179057] = true, -- Chaos Nova
    [109248] = true, -- Binding Shot
    [119381] = true, -- Leg Sweep
    [205369] = true, -- Mind Bomb
    [192058] = true, -- Capacitor Totem
    [30283] = true, -- Shadowfury
    [46968] = true, -- Shockwave
    --[[
        HEALING
    ]]
    [102351] = true, -- Cenarion Ward
    [197721] = true, -- Flourish
    [319454] = true, -- Heart of the Wil
    [33891] = true, -- Incarnation: Tre
    [203651] = true, -- Overgrowth
    [740] = true, -- Tranquility
    [325197] = true, -- Invoke Chi-Ji, t
    [322118] = true, -- Invoke Yu'lon, t
    [115310] = true, -- Revival
    [216331] = true, -- Avenging Crusade
    [31884] = true, -- Avenging Wrath
    [200025] = true, -- Beacon of Virtue
    [105809] = true, -- Holy Avenger
    [200183] = true, -- Apotheosis
    [64843] = true, -- Divine Hymn
    [246287] = true, -- Evangelism
    [265202] = true, -- Holy Word: Salva
    [10060] = true, -- Power Infusion
    [47536] = true, -- Rapture
    [109964] = true, -- Spirit Shell
    [15286] = true, -- Vampiric Embrace
    [108281] = true, -- Ancestral Guidan
    [114052] = true, -- Ascendance
    [198838] = true, -- Earthen Wall Tot
    [108280] = true, -- Healing Tide Tot
    [98008] = true, -- Spirit Link Totem
    --[[
        IMMUNITY
    ]]
    [196555] = true, -- Netherwalk
    [186265] = true, -- Aspect of the Tu
    [45438] = true, -- Ice Block
    [642] = true, -- Divine Shield
    [31224] = true, -- Cloak of Shadows
    --[[
        PERSONAL
    ]]
    [198589] = true, -- Blur
    [48707] = true, -- Anti-Magic Shell
    [48743] = true, -- Death Pact
    [48792] = true, -- Icebound Fortitu
    [49039] = true, -- Lichborne
    [327574] = true, -- Sacrificial Pact
    [22812] = true, -- Barkskin
    [319454] = true, -- Heart of the Wil
    [108238] = true, -- Renewal
    [61336] = true, -- Survival Instinc
    [109304] = true, -- Exhilaration
    [108978] = true, -- Alter Time
    [342245] = true, -- Alter Time
    [235313] = true, -- Blazing Barrier
    [11426] = true, -- Ice Barrier
    [235450] = true, -- Prismatic Barrie
    [122278] = true, -- Dampen Harm
    [122783] = true, -- Diffuse Magic
    [243435] = true, -- Fortifying Brew
    [115203] = true, -- Fortifying Brew
    [122470] = true, -- Touch of Karma
    [498] = true, -- Divine Protectio
    [205191] = true, -- Eye for an Eye
    [184662] = true, -- Shield of Vengea
    [19236] = true, -- Desperate Prayer
    [47585] = true, -- Dispersion
    [185311] = true, -- Crimson Vial
    [108271] = true, -- Astral Shift
    [108416] = true, -- Dark Pact
    [104773] = true, -- Unending Resolve
    [118038] = true, -- Die by the Sword
    [184364] = true, -- Enraged Regenera
    [23920] = true, -- Spell Reflection
    --[[
        RAID CD
    ]]
    [196718] = true, -- Darkness
    [51052] = true, -- Anti-Magic Zone
    [31821] = true, -- Aura Mastery
    [62618] = true, -- Power Word: Barr
    [97462] = true, -- Rallying Cry
    --[[
        SOFT CC
    ]]
    [202138] = true, -- Sigil of Chains
    [207684] = true, -- Sigil of Misery
    [202137] = true, -- Sigil of Silence
    [207167] = true, -- Blinding Sleet
    [108199] = true, -- Gorefiend's Gras
    [99] = true, -- Incapacitating R
    [102359] = true, -- Mass Entanglemen
    [132469] = true, -- Typhoon
    [102793] = true, -- Ursol's Vortex
    [162488] = true, -- Steel Trap
    [31661] = true, -- Dragon's Breath
    [113724] = true, -- Ring of Frost
    [324312] = true, -- Clash
    [116844] = true, -- Ring of Peace
    [198898] = true, -- Song of Chi-Ji
    [115750] = true, -- Blinding Light
    [8122] = true, -- Psychic Scream
    [204263] = true, -- Shining Force
    [51485] = true, -- Earthgrab Totem
    [5484] = true, -- Howl of Terror
    [5246] = true, -- Intimidating Sho
    --[[
        ST HARD CC
    ]]
    [211881] = true, -- Fel Eruption
    [22570] = true, -- Maim
    [5211] = true, -- Mighty Bash
    [19577] = true, -- Intimidation
    [853] = true, -- Hammer of Justic
    [88625] = true, -- Holy Word: Chast
    [64044] = true, -- Psychic Horror
    [408] = true, -- Kidney Shot
    [6789] = true, -- Mortal Coil
    [107570] = true, -- Storm Bolt
    --[[
        ST SOFT CC
    ]]
    [217832] = true, -- Imprison
    [186387] = true, -- Bursting Shot
    [187650] = true, -- Freezing Trap
    [115078] = true, -- Paralysis
    [20066] = true, -- Repentance
    [88625] = true, -- Holy Word: Chast
    [2094] = true, -- Blind
    [51514] = true, -- Hex
    --[[
        TANK
    ]]
    [320341] = true, -- Bulk Extraction
    [212084] = true, -- Fel Devastation
    [204021] = true, -- Fiery Brand
    [187827] = true, -- Metamorphosis
    [263648] = true, -- Soul Barrier
    [185245] = true, -- Torment
    [194844] = true, -- Bonestorm
    [49028] = true, -- Dancing Rune Wea
    [56222] = true, -- Dark Command
    [219809] = true, -- Tombstone
    [55233] = true, -- Vampiric Blood
    [50334] = true, -- Berserk
    [6795] = true, -- Growl
    [102558] = true, -- Incarnation: Gua
    [204066] = true, -- Lunar Beam
    [80313] = true, -- Pulverize
    [115399] = true, -- Black Ox Brew
    [322507] = true, -- Celestial Brew
    [325153] = true, -- Exploding Keg
    [132578] = true, -- Invoke Niuzao, t
    [115546] = true, -- Provoke
    [115176] = true, -- Zen Meditation
    [31850] = true, -- Ardent Defender
    [86659] = true, -- Guardian of Anci
    [105809] = true, -- Holy Avenger
    [1161] = true, -- Challenging Shou
    [1160] = true, -- Demoralizing Sho
    [12975] = true, -- Last Stand
    [871] = true, -- Shield Wall
    [355] = true, -- Taunt
    --[[
        UTILITY
    ]]
    [188501] = true, -- Spectral Sight
    [205636] = true, -- Force of Nature
    [29166] = true, -- Innervate
    [132158] = true, -- Nature's Swiftne
    [106898] = true, -- Stampeding Roar
    [77764] = true, -- Stampeding Roar
    [186257] = true, -- Aspect of the Ch
    [199483] = true, -- Camouflage
    [5384] = true, -- Feign Death
    [34477] = true, -- Misdirection
    [235219] = true, -- Cold Snap
    [110959] = true, -- Greater Invisibi
    [66] = true, -- Invisibility
    [205025] = true, -- Presence of Mind
    [116841] = true, -- Tiger's Lust
    [73325] = true, -- Leap of Faith
    [64901] = true, -- Symbol of Hope
    [1725] = true, -- Distract
    [114018] = true, -- Shroud of Concea
    [57934] = true, -- Tricks of the Tr
    [1856] = true, -- Vanish
    [198103] = true, -- Earth Elemental
    [16191] = true, -- Mana Tide Totem
    [20608] = true, -- Reincarnation
    [79206] = true, -- Spiritwalker's G
    [192077] = true, -- Wind Rush Totem
    [333889] = true, -- Fel Domination
    [64382] = true, -- Shattering Throw
    [8143] = true, -- Tremor Totem
    [2484] = true, -- Earthbind Totem
    [190784] = true, -- Divine Steed
    [1044] = true, -- Blessing of Freedom
    [19801] = true, -- Tranquilizing Shot
    --[[
        RACE SPECIFIC
    ]]
    -- Dark Iron Dwarf
    [265221] = true, -- Fireblood
    -- Draenei
    [28880] = true,  -- Gift of the Naaru
    [59542] = true,  -- Gift of the Naaru
    [59543] = true,  -- Gift of the Naaru
    [59544] = true,  -- Gift of the Naaru
    [59545] = true,  -- Gift of the Naaru
    [59547] = true,  -- Gift of the Naaru
    [59548] = true,  -- Gift of the Naaru
    [121093] = true, -- Gift of the Naaru
    -- Dwarf
    [20594] = true,  -- Stoneform
    -- Gnome
    [20589] = true,  -- Escape Artist
    -- Goblin
    [69041] = true,  -- Rocket Barrage
    [69070] = true,  -- Rocket Jump
    -- Highmountain Tauren
    [255654] = true, -- Bull Rush
    -- Human
    [59752] = true,  -- Will to Survive
    -- Kul Tiran
    [287712] = true, -- Haymaker
    -- Lightforged Draenei
    [255647] = true, -- Light's Judgment
    -- Mag'har Orc
    [274738] = true, -- Ancestral Call
    -- Mechgnome
    [312924] = true, -- Hyper Organic Light Originator
    -- Nightborne
    [260364] = true, -- Arcane Pulse
    -- Night Elf
    [58984] = true,  -- Shadowmeld
    -- Orc
    [20572] = true,  -- Blood Fury
    [33697] = true,  -- Blood Fury
    [33702] = true,  -- Blood Fury
    -- Pandaren
    [107079] = true, -- Quaking Palm
    -- Tauren
    [20549] = true,  -- War Stomp
    -- Troll
    [26297] = true,  -- Berserking
    -- Undead
    [7744] = true,   -- Will of the Forsaken
    [20577] = true,  -- Cannibalize
    -- Vulpera
    [312411] = true, -- Bag of Tricks
    -- Worgen
    [68992] = true,  -- Darkflight
    -- Zandalari Troll
    [291944] = true, -- Regeneratin'
    --[[
        CLASS SPECIFIC
    ]]
    -- Shaman
    [2825] = true,   -- Blood Lust
    [21169] = true,  -- Reincarnation
    -- DK
    [61999] = true,  -- Raise Ally
    -- Druid
    [20484] = true,  -- Rebirth
    -- Warlock
    [20707] = true,  -- Soulstone
    --[[
        COVENANTS SPECIFIC
    ]]
    -- Kyrian
    [312202] = true, -- Shackle the Unworthy (Death Knight)
    [306830] = true, -- Elysian Decree (Demon Hunter)
    [326434] = true, -- Kindred Spirits (Druid)
    [308491] = true, -- Resonating Arrow (Hunter)
    [307443] = true, -- Radiant Spark (Mage)
    [310454] = true, -- Weapons of Order (Monk)
    [304971] = true, -- Divine Toll (Paladin)
    [325013] = true, -- Boon of the Ascended (Priest)
    [323547] = true, -- Echoing Reprimand (Rogue)
    [324386] = true, -- Vesper Totem (Shaman)
    [312321] = true, -- Scouring Tithe (Warlock)
    [307865] = true, -- Spear of Bastion (Warrior)
    -- Necrolords
    [315443] = true, -- Abomination Limb (Death Knight)
    [329554] = true, -- Fodder to the Flame (Demon Hunter)
    [325727] = true, -- Adaptive Swarm (Druid)
    [325028] = true, -- Death Chakram (Hunter)
    [324220] = true, -- Deathborne (Mage)
    [325216] = true, -- Bonedust Brew (Monk)
    [328204] = true, -- Vanquisher's Hammer (Paladin)
    [324724] = true, -- Unholy Nova (Priest)
    [328547] = true, -- Serrated Bone Spike (Rogue)
    [326059] = true, -- Primordial Wave (Shaman)
    [325289] = true, -- Decimating Bolt (Warlock)
    [324143] = true, -- Conqueror's Banner (Warrior)
    -- Night Fae
    [324128] = true, -- Death's Due (Death Knight)
    [323639] = true, -- The Hunt (Demon Hunter)
    [323764] = true, -- Convoke the Spirits (Druid)
    [328231] = true, -- Wild Spirits (Hunter)
    [314791] = true, -- Shifting Power (Mage)
    [327104] = true, -- Faeline Stomp (Monk)
    [328278] = true, -- Blessing of the Seasons (Paladin)
    [327661] = true, -- Fae Guardians (Priest)
    [328305] = true, -- Sepsis (Rogue)
    [328923] = true, -- Fae Transfusion (Shaman)
    [325640] = true, -- Soul Rot (Warlock)
    [325886] = true, -- Ancient Aftershock (Warrior)
    -- Venthyr
    [311648] = true, -- Swarming Mist (Death Knight)
    [317009] = true, -- Sinful Brand (Demon Hunter)
    [323546] = true, -- Ravenous Frenzy (Druid)
    [324149] = true, -- Flayed Shot (Hunter)
    [314793] = true, -- Mirrors of Torment (Mage)
    [326860] = true, -- Fallen Order (Monk)
    [316958] = true, -- Ashen Hallow (Paladin)
    [323673] = true, -- Mindgames (Priest)
    [323654] = true, -- Flagellation (Rogue)
    [320674] = true, -- Chain Harvest (Shaman)
    [321792] = true, -- Impending Catastrophe (Warlock)
    [317349] = true, -- Condemn (Warrior)

    --[[
        Dungeons specific stuff for covenants
    ]]
    -- Plaguefall (Necrolord)
    [340210] = true, -- Corrosive Gunk
    [340225] = true, -- Rapid Infection
    [340271] = true, -- Congealed Contagion
    -- Spires of Ascension (Kyrian)
    [339916] = true, -- Spear of Destiny
};

--[[--
Track cast done by any party member.

It should be used for player's own spells.

@param[type=string] sourceUnitName name of unit that casted a spell
@param[type=number] spellId casted spell id
@param[type=?string] targetUnitName name of unit that is spell's target (only for single target spells)
]]
function MyDungeonsBook:TrackOwnCastDoneByPartyMembers(sourceUnitName, spellId, targetUnitName)
    if (OwnCastsDoneByPartyMembers[spellId] and UnitIsPlayer(sourceUnitName)) then
        local id = self.db.char.activeChallengeId;
        local key = "OWN-CASTS-DONE-BY-PARTY-MEMBERS";
        self:InitMechanics3Lvl(key, sourceUnitName, spellId);
        local timestamp = time();
        self.db.char.challenges[id].mechanics[key][sourceUnitName][spellId][timestamp] = {
            time = timestamp,
            target = targetUnitName
        };
    end
end
