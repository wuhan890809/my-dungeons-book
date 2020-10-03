-- Some stuff for interrupts is taken from https://wago.io/SkjHi61Bz/18

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function mergeInterruptSpellId(spellId)
	-- Warlock
	if (spellId == 119910 or spellId == 132409) then
		return 19647;
	end
	-- Priest
	if (spellId == 220543) then
		return 15487;
	end
	return spellId;
end

local function getPetOwner(unitGUID, partyRoster)
	for _, unitId in pairs(partyRoster) do
        if (UnitGUID(unitId .. "pet") == unitGUID) then
            return unitId;
        end
    end
	return nil;
end

--[[
Track each player's death

@method MyDungeonsBook:TrackDeath
@param {GUID} deadUnitGUID - 8th result of `CombatLogGetCurrentEventInfo` call
@param {string} unit - 9th result of `CombatLogGetCurrentEventInfo` call
]]
function MyDungeonsBook:TrackDeath(deadUnitGUID, unit)
	local id = self.db.char.activeChallengeId;
	local isPlayer = strfind(deadUnitGUID, "Player"); -- needed GUID is something like "Player-......"
	if (not isPlayer) then
		return;
	end
	if (UnitIsFeignDeath(unit)) then
		self:DebugPrint(string.format("%s is feign death", unit));
	    return;
	end
	local surrenderedSoul = GetSpellInfo(212570);
	for i = 1, 40 do
		local debuffName = UnitDebuff(unit, i);
		if (debuffName == nil) then
			break;
		end
		if (debuffName == surrenderedSoul) then
			self:DebugPrint(string.format("%s is on Surrendered Soul debuff", unit));
			return;
		end
	end
	if (not self.db.char.challenges[id].deaths[unit]) then
		self.db.char.challenges[id].deaths[unit] = 1;
	else
		self.db.char.challenges[id].deaths[unit] = self.db.char.challenges[id].deaths[unit] + 1;
	end
	self:LogPrint(string.format(L["%s died"], self:ClassColorText(unit, unit)));
end

--[[
Track interrupts by players

@method MyDungeonsBook:TrackInterrupt
@param {string} unit - 5th result of `CombatLogGetCurrentEventInfo` call
@param {string} srcGUID - 4th result of `CombatLogGetCurrentEventInfo` call
@param {number} spellId - 12th result of `CombatLogGetCurrentEventInfo` call
@param {number} interruptedSpellId - 15th result of `CombatLogGetCurrentEventInfo` call
]]
function MyDungeonsBook:TrackInterrupt(unit, srcGUID, spellId, interruptedSpellId)
	local id = self.db.char.activeChallengeId;
	--Attribute Pet Spell's to its owner
    local type = strsplit("-", srcGUID);
    if (type == "Pet") then
		local petOwnerId = getPetOwner(srcGUID, self:GetPartyRoster());
		if (petOwnerId) then
			unit = UnitName(petOwnerId);
		end
    end
	if (not UnitIsPlayer(unit)) then
		self:DebugPrint(string.format("%s is not player", unit));
	end
	local KEY = "COMMON-INTERRUPTS";
    spellId = mergeInterruptSpellId(spellId);
	self:LogPrint(string.format(L["%s interrupted %s using %s"], self:ClassColorText(unit, unit), GetSpellLink(interruptedSpellId), GetSpellLink(spellId)));
	self:InitMechanics2Lvl(KEY, unit);
	if (not self.db.char.challenges[id].mechanics[KEY][unit][spellId]) then
		self.db.char.challenges[id].mechanics[KEY][unit][spellId] = {};
	end
	if (not self.db.char.challenges[id].mechanics[KEY][unit][spellId][interruptedSpellId]) then
		self.db.char.challenges[id].mechanics[KEY][unit][spellId][interruptedSpellId] = 1;
	else
		self.db.char.challenges[id].mechanics[KEY][unit][spellId][interruptedSpellId] = self.db.char.challenges[id].mechanics[KEY][unit][spellId][interruptedSpellId] + 1;
	end
end

--[[
Track casts that should interrupt enemies
This mechanic is used together with `COMMON-INTERRUPTS` to get number of failed "interrrupt"-casts (e.g. when 2+ party member tried to interrupt the same cast together)

@method MyDungeonsBook:TrackTryInterrupt
@param {number} spellId 12th param for SPELL_CAST_SUCCESS
@param {string} sourceGUID 4th param for SPELL_CAST_SUCCESS
@param {string} sourceName 5th param for SPELL_CAST_SUCCESS
]]
function MyDungeonsBook:TrackTryInterrupt(spellId, sourceGUID, sourceName)
	local interrupts = {
		[47528] = true,  --Mind Freeze
		[106839] = true, --Skull Bash
		[78675] = true,  --Solar Beam
		[183752] = true, --Disrupt
		[147362] = true, --Counter Shot
		[187707] = true, --Muzzle
		[2139] = true,   --Counter Spell
		[116705] = true, --Spear Hand Strike
		[96231] = true,  --Rebuke
		[1766] = true,   --Kick
		[57994] = true,  --Wind Shear
		[6552] = true,   --Pummel
		[119910] = true, --Spell Lock Command Demon
		[19647] = true,  --Spell Lock if used from pet bar
		[132409] = true, --Spell Lock Command Demon Sacrifice
		[15487] = true,  --Silence
		[31935] = true,  --Avenger's Shield
		[15487] = true,  -- Silence
	};
	if (not interrupts[spellId]) then
		return;
	end
	local id = self.db.char.activeChallengeId;
	local KEY = "COMMON-TRY-INTERRUPT";
    --Attribute Pet Spell's to its owner
    local type = strsplit("-", sourceGUID);
    if (type == "Pet") then
		local petOwnerId = getPetOwner(sourceGUID, self:GetPartyRoster());
		if (petOwnerId) then
			sourceName = UnitName(unit);
		end
    end
    spellId = mergeInterruptSpellId(spellId);
	self:InitMechanics2Lvl(KEY, sourceName);
	if (not self.db.char.challenges[id].mechanics[KEY][sourceName][spellId]) then
		self.db.char.challenges[id].mechanics[KEY][sourceName][spellId] = 1;
	else
		self.db.char.challenges[id].mechanics[KEY][sourceName][spellId] = self.db.char.challenges[id].mechanics[KEY][sourceName][spellId] + 1;
	end
end

--[[
Track gotten by players damage that could be avoided
Check events not related to `SPELL_AURA_APPLIED` and `SPELL_AURA_APPLIED_DOSE` (they are tracked in the method `MyDungeonsBook:TrackAvoidableAuras`)

@method MyDungeonsBook:TrackAvoidableSpells
@param {string} key - db key to save damage done by `spells` or `spellsNoTank`
@param {table} spells - table with keys equal to tracked spell ids
@param {table} spellsNoTank - table with keys equal to tracked spell ids allowed to hit tanks
@param {string} unit - unit name that got damage (usualy it's a destUnit from `CombatLogGetCurrentEventInfo`)
@param {number} spellId - spell that did damage to `damagedUnit`
@param {number} amount - amount of damage done to `damagedUnit` by `spellId`
]]
function MyDungeonsBook:TrackAvoidableSpells(key, spells, spellsNoTank, unit, spellId, amount)
	if ((spells[spellId] or (spellsNoTank[spellId] and UnitGroupRolesAssigned(unit) ~= "TANK")) and UnitIsPlayer(unit)) then
		local partyUnit = self:GetPartyUnitByName(unit);
		if (partyUnit) then
			local amountInPercents = amount / UnitHealthMax(unit) * 100;
			if (amountInPercents > 40) then
				self:LogPrint(string.format(L["%s got hit by %s for %s (%s)"], unit, GetSpellLink(spellId), self:FormatNumber(amount), string.format("%.1f\%", amountInPercents)));
			end
		end
		local id = self.db.char.activeChallengeId;
		self:InitMechanics2Lvl(key, unit);
		if (not self.db.char.challenges[id].mechanics[key][unit][spellId]) then
			self.db.char.challenges[id].mechanics[key][unit][spellId] = {
				num = 0,
				sum = 0
			};
		end
		if (not amount) then
			amount = 0;
			self:DebugPrint(string.format("Cast of %s did `nil` amount of damage", GetSpellLink(spellId)));
		end
		self.db.char.challenges[id].mechanics[key][unit][spellId].num = self.db.char.challenges[id].mechanics[key][unit][spellId].num + 1;
		self.db.char.challenges[id].mechanics[key][unit][spellId].sum = self.db.char.challenges[id].mechanics[key][unit][spellId].sum + amount;
	end
end

--[[
Track gotten by players debuffs that could be avoided
Check events `SPELL_AURA_APPLIED` and `SPELL_AURA_APPLIED_DOSE`

@method MyDungeonsBook:TrackAvoidableAuras
@param {string} key - db key to save debuffs done by `spells` or `spellsNoTank`
@param {table} spells - table with keys equal to tracked spell ids
@param {table} spellsNoTank - table with keys equal to tracked spell ids allowed to hit tanks
@param {unitId} damagedUnit - unit name that got damage (usualy it's a destUnit from `CombatLogGetCurrentEventInfo`)
@param {number} spellId - spell that apply debuff to `damagedUnit`
]]
function MyDungeonsBook:TrackAvoidableAuras(key, auras, aurasNoTank, unit, spellId)
	if (auras[spellId] or (aurasNoTank[spellId] and UnitGroupRolesAssigned(unit) ~= "TANK")) and UnitIsPlayer(unit) then
		local id = self.db.char.activeChallengeId;
		self:InitMechanics2Lvl(key, unit);
		if (not self.db.char.challenges[id].mechanics[key][unit][spellId]) then
			self.db.char.challenges[id].mechanics[key][unit][spellId] = 0
		end
		self.db.char.challenges[id].mechanics[key][unit][spellId] = self.db.char.challenges[id].mechanics[key][unit][spellId] + 1;
		self:LogPrint(string.format(L["%s got debuff by %s"], unit, GetSpellLink(spellId)));
	end
end

--[[
Track passed casts that should be interrupted by players

This mechanic is a subset of one from `TrackAllEnemyPassedCasts`

@method MyDungeonsBook:TrackPassedCasts
@param {string} key - db key
@param {table} spells - table with keys equal to tracked spell ids
@param {string} unitName - caster
@param {number} spellId - casted spell id
]]
function MyDungeonsBook:TrackPassedCasts(key, spells, unitName, spellId)
	if (spells[spellId]) then
		self:LogPrint(string.format(L["%s's cast %s is passed"], unitName, GetSpellLink(spellId)));
		local id = self.db.char.activeChallengeId;
		self:InitMechanics1Lvl(key);
		if (not self.db.char.challenges[id].mechanics[key][spellId]) then
			self.db.char.challenges[id].mechanics[key][spellId] = 0;
		end
		self.db.char.challenges[id].mechanics[key][spellId] = self.db.char.challenges[id].mechanics[key][spellId] + 1;
	end
end

--[[
Track all passed casts done by enemies

@method MyDungeonsBook:TrackAllEnemiesPassedCasts
@param {string} unitName - caster's name
@param {GUID} unitGUID - caster's GUID
@param {number} spellId - casted spell ID
]]
function MyDungeonsBook:TrackAllEnemiesPassedCasts(unitName, unitGUID, spellId)
	local isPlayer = strfind(unitGUID, "Player");
	local isPet = strfind(unitGUID, "Pet");
	if (isPlayer or isPet) then
		return;
	end
	local KEY = "ALL-ENEMY-PASSED-CASTS";
	local id = self.db.char.activeChallengeId;
	self:InitMechanics1Lvl(KEY);
	if (not self.db.char.challenges[id].mechanics[KEY][spellId]) then
		self.db.char.challenges[id].mechanics[KEY][spellId] = 0;
	end
	self.db.char.challenges[id].mechanics[KEY][spellId] = self.db.char.challenges[id].mechanics[KEY][spellId] + 1;
end

--[[
Track damage done by party members (and pets) for specific unit

@method MyDungeonsBook:TrackDamageDoneToSpecificUnits
@param {string} key - mechanic unique identifier
@param {table} npcs - table with npcs needed to track (each key is a npc id)
@param {string} sourceUnitName - name of unit that did damage
@param {GUID} sourceUnitGUID - GUID of unit that did damage
@param {number} spellId - spell id 
@param {number} amount - amount of done damage
@param {number} overkill - amount of extra damage
@param {string} targetUnitName - name of unit that got damage
@param {GUID} targetUnitGUID - GUID of unit that got damage
]]
function MyDungeonsBook:TrackDamageDoneToSpecificUnits(key, npcs, sourceName, sourceGUID, spellId, amount, overkill, targetUnitName, targetUnitGUID)
	local id = self.db.char.activeChallengeId;
	local type = strsplit("-", sourceGUID);
	if ((type ~= "Pet") and (type ~= "Player")) then
		return;
	end
	local npcId = self:GetNpcIdFromGuid(targetUnitGUID);
	if (not npcs[npcId]) then
		return;
	end
    if (type == "Pet") then
		local petOwnerId = getPetOwner(sourceGUID, self:GetPartyRoster());
		if (petOwnerId) then
			sourceName = string.format("%s (%s)", UnitName(petOwnerId), sourceName);
		end
    end
	self:InitMechanics4Lvl(key, npcId, sourceName, spellId);
	if (not self.db.char.challenges[id].mechanics[key][npcId][sourceName][spellId].hits) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceName][spellId] = {
			hits = 0,
			amount = 0,
			overkill = 0
		};
	end
	self.db.char.challenges[id].mechanics[key][npcId][sourceName][spellId].hits = self.db.char.challenges[id].mechanics[key][npcId][sourceName][spellId].hits + 1;
	self.db.char.challenges[id].mechanics[key][npcId][sourceName][spellId].amount = self.db.char.challenges[id].mechanics[key][npcId][sourceName][spellId].amount + 1;
	if (overkill > 0) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceName][spellId].overkill = self.db.char.challenges[id].mechanics[key][npcId][sourceName][spellId].overkill + 1;
	end
end

--[[
Track specific cast done by any party member.
It should not be used for player's own spells. It should be used for some specific for dungeon spells (e.g. kicking balls in the ML)

@method MyDungeonsBook:TrackSpecificCastDoneByPartyMembers
@param {string} key - mechanic unique identifier
@param {table} spells - table with spells needed to track (each key is a spell id)
@param {string} unit - name of unit that casted a spell
@param {number} spellId - casted spell id
]]
function MyDungeonsBook:TrackSpecificCastDoneByPartyMembers(key, spells, unit, spellId)
	if (spells[spellId] and UnitIsPlayer(unit)) then
		local id = self.db.char.activeChallengeId;
		self:InitMechanics3Lvl(key, spellId, unit, true);
		self.db.char.challenges[id].mechanics[key][spellId][unit] = self.db.char.challenges[id].mechanics[key][spellId][unit] + 1;
	end
end

--[[
Track specific buffs or debuffs got by any party member

@method MyDungeonsBook:TrackSpecificBuffOrDebuffOnPartyMembers
@param {string} key - mechanic unique identifier
@param {table} spells - table with buffs (or debuffs) needed to track (each key is a spell id)
@param {string} unit - name of unit that casted a spell
@param {number} spellId - buff (or debuff) id
]]
function MyDungeonsBook:TrackSpecificBuffOrDebuffOnPartyMembers(key, spells, unit, spellId)
	if (spells[spellId] and UnitIsPlayer(unit)) then
		local id = self.db.char.activeChallengeId;
		self:InitMechanics3Lvl(key, spellId, unit, true);
		self.db.char.challenges[id].mechanics[key][spellId][unit] = self.db.char.challenges[id].mechanics[key][spellId][unit] + 1;
	end
end

--[[
Track specific buffs or debuffs got by any unit

@method MyDungeonsBook:TrackSpecificBuffOrDebuffOnUnit
@param {string} key - mechanic unique identifier
@param {table} spells - table with needed to track buffs and debuffs (each key is npc id)
@param {GUID} unitGUID - GUID for unit with buff/debuff
@param {number} spellId - buff (or debuff) id
]]
function MyDungeonsBook:TrackSpecificBuffOrDebuffOnUnit(key, spells, unitGUID, spellId)
	if (spells[spellId]) then
		local id = self.db.char.activeChallengeId;
		local npcId = self:GetNpcIdFromGuid(unitGUID);
		if (npcId) then
			self:InitMechanics1Lvl(key, spellId, npcId, true);
			self.db.char.challenges[id].mechanics[key][spellId][npcId] = self.db.char.challenges[id].mechanics[key][spellId][npcId] + 1;
		end
	end
end

--[[
Track if specific npc appears in combat (and how many times this happens)

@method MyDungeonsBook:TrackUnitsAppearsInCombat
@param {string} key - mechanic unique identifier
@param {table} units - table with needed to track npcs (each key is npc id)
@param {GUID} sourceUnitGUID - GUID of source unit
@param {GUID} targetUnitGUID - GUID of target unit
]]
function MyDungeonsBook:TrackUnitsAppearsInCombat(key, units, sourceUnitGUID, targetUnitGUID)
	local sourceNpcId = self:GetNpcIdFromGuid(sourceUnitGUID);
	local targetNpcId = self:GetNpcIdFromGuid(targetUnitGUID);
	local neededNpcGUID, neededNpcId;
	if (units[sourceNpcId]) then
		neededNpcGUID = sourceUnitGUID;
		neededNpcId = sourceNpcId;
	end
	if (units[targetNpcId]) then
		neededNpcGUID = targetUnitGUID;
		neededNpcId = targetNpcId;
	end
	if (neededNpcGUID and neededNpcId) then
		self:InitMechanics2Lvl(key, neededNpcId);
		self.db.char.challenges[id].mechanics[key][neededNpcId][neededNpcGUID] = true;
	end
end