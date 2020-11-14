--[[--
@module MyDungeonsBook
]]

--[[--
Addon data storage created with `AceDB` (it's available like `MyDungeonsBook.db` or `self.db`).

@table DB
@field[type=Char] char data for single character
]]

--[[--
Every character has its own pull of challenges.

@table Char
@field[type=Challenges] challenges
@field[type=number] activeChallengeId
]]

--[[--
Table with all challenges for current char. Every key is a challenge id. Every value is an information about challenge.
@see Challenge

@table Challenges
]]

--[[--
Every challenge has next fields:

@table Challenge
@field[type=number] id challenge run identifier (timestamp when challenge was started)
@field[type=ChallengePartyRoster] players information about all party members (class, role, name, items etc).
@field[type=Mechanics] mechanics table with data collected my MyDungeonsBook about current challenge
@field[type=GameInfo] gameInfo short info about WoW
@field[type=ChallengeInfo] challengeInfo detailed info about challenge
@field[type=Encounters] encounters table with data about encounters (start, end, duration, deaths)
@field[type=table] misc
]]

--[[--
Common info about WoW-itself like build, version etc.
@table GameInfo
@field[type=string] date
@field[type=string] build
@field[type=string] version
@field[type=number] tocversion
]]

--[[--
Common info about challenge like zone name, start/end time, key level etc.
@table ChallengeInfo
@field[type=number] timeLost
@field[type=number] healthMod
@field[type=number] numDeaths
@field[type=number] duration
@field[type=bool] onTime
@field[type=string] affixesKey
@field[type=number] startTime
@field[type=number] currentMapId
@field[type=number] maxTime
@field[type=number] steps
@field[type=number] currentZoneId
@field[type=number] cmLevel
@field[type=string] levelKey
@field[type=number] endTime
@field[type=string] zoneName
@field[type=number] damageMod
@field[type=table] affixes
@field[type=number] keystoneUpgradeLevel
]]

--[[--
Table with all encounters related to the current challenge.

Each key is an encounter id, each value is a table with data about this encounter.
@see Encounter

@table Encounters
]]

--[[--
Information about a single encounter.

@table Encounter
@field[type=number] deathCountOnStart how many deaths party has before encounter starts
@field[type=number] success 1 if encounter is passed
@field[type=number] id encounter's indentifier
@field[type=number] endTime timestamp when encounters ends
@field[type=number] startTime timestamp when encounters starts
@field[type=number] deathCountOnEnd how many deaths party has right after encounter ends
@field[type=string] name name of encounter (usually Boss-name)
]]

--[[--
Table with data releated to some challenge specific items. Every key is a mechanic id. Every value is an information about mechanic.
@see Mechanic

@table Mechanics
]]

--[[--
Counter for some unique behavior in the challenges.

All challenges have some common parts - dodging AoE, interruptions, CCs, casting some unique spells etc.
Almost all of them can be calculated and stored. After passing challenge party can check them and find out what could be done better and what was done perfectly.

Each mechanic is a unique counter (well, technically it's a table with deep nested structure). One of them track interrupts, another one check how many avoidable damage got party members (say "Hello" to addon EH) etc. Every mechanic is shown in the Challenge Details tab.

@table Mechanic
]]

--[[--
Every value is an `itemString` with info about items in the slot equal to index in the `PartyMemberItems`.

@table PartyMemberItems
]]

--[[--
Table with data about party members (class, spec, role etc).

Each key is a party member name (with realm for `party1..4`). Each value is a table like `ChallengePartyMember`.

This data is collected when challenge is started (e.g. when event `CHALLENGE_MODE_START` is fired).

@see ChallengePartyMember

@table ChallengePartyRoster
]]

--[[--
General information about single party member.

@table ChallengePartyMember
@field[type=number] class class indentifier
@field[type=number] spec specialization identified
@field[type=string] role `TANK` or `HEALER` or `DAMAGER`
@field[type=string] name player's name (without realm)
@field[type=string] race player's race (I bet it's the same for all party members)
@field[type=string] realm player's realm name
@field[type=PartyMemberItems] items list of equiped items
]]
