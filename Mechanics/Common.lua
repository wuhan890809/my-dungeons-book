--[[--
@module MyDungeonsBook
]]

--[[--
Mechanics
@section Mechanics
]]

-- Some stuff for interrupts is taken from https://wago.io/SkjHi61Bz/18

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local petTooltipFrame = CreateFrame("GameTooltip", "MyDungeonsBookPetTooltip", nil, "GameTooltipTemplate");

--[[--
Original idea is taken from Details addon

@local
@return[type=bool]
]]
function MyDungeonsBook:FindNameDeclension(petTooltipText, partyMemberName)
	--> 2 - male, 3 - female
	for gender = 3, 2, -1 do
		for declensionSet = 1, GetNumDeclensionSets(partyMemberName, gender) do
			--> check genitive case of player name
			local genitive = DeclineName(partyMemberName, gender, declensionSet);
			if (petTooltipText:find(genitive)) then
				return true;
			end
		end
	end
	return false;
end

--[[
@local
@return[type=bool]
]]
function MyDungeonsBook:IsFriendlyFire(spellId)
	if (spellId == 98021) then
		return true;
	end
	return false;
end

--[[--
Original idea is taken from Details addon

@local
@param[type=GUID] unitGUID
@return[type=?string]
]]
function MyDungeonsBook:FindPetOwnerId(unitGUID)
	petTooltipFrame:SetOwner(WorldFrame, "ANCHOR_NONE");
	petTooltipFrame:SetHyperlink("unit:" .. unitGUID or "");

	for _, line in pairs({"MyDungeonsBookPetTooltipTextLeft2", "MyDungeonsBookPetTooltipTextLeft3"}) do
		local text = _G[line] and _G[line]:GetText();
		if (text and text ~= "") then
			for _, unitId in pairs(self:GetPartyRoster()) do
				if (UnitExists(unitId)) then
					local partyMemberName = UnitName(unitId);
					--if the user client is in russian language
					--make an attempt to remove declensions from the character's name
					--this is equivalent to remove 's from the owner on enUS
					if (GetLocale() == "ruRU") then
						if (self:FindNameDeclension(text, partyMemberName)) then
							return unitId;
						else
							if (text:find(partyMemberName)) then
								return unitId;
							end
						end
					else
						if (text:find(partyMemberName)) then
							return unitId;
						end
					end
				end
			end
		end
	end
end

local function mergeInterruptSpellId(spellId)
	-- Warlock
	if (spellId == 119910 or spellId == 132409) then
		return 19647;
	end
	-- Priest
	if (spellId == 220543) then
		return 15487;
	end
	-- Druid
	if (spellId == 97547) then
		return 78675;
	end
	return spellId;
end

--[[--
Add a table or counter (depends on `asCounter`) to the active challenge inside a `mechanics` (nested in 1 level).

It doesn't do anything if value `mechanics[first]` already exists.

@param[type=string|number] first key for the new value inside `mechanics`
@param[type=bool] asCounter truly for new value `0`, falsy for `{}`
]]
function MyDungeonsBook:InitMechanics1Lvl(first, asCounter)
	local id = self.db.char.activeChallengeId;
	if (not self.db.char.challenges[id].mechanics[first]) then
		self.db.char.challenges[id].mechanics[first] = (asCounter and 0) or {};
	end
end

--[[--
Add a table or counter (depends on `asCounter`) to the active challenge inside a `mechanics` (nested in 2 levels).

It doesn't do anything if value `mechanics[first][second]` already exists.

@param[type=string|number] first key for the new table inside `mechanics`
@param[type=string|number] second key for the new value inside mechanics&lbrack;first&rbrack;
@param[type=bool] asCounter truly for new value `0`, falsy for `{}`
]]
function MyDungeonsBook:InitMechanics2Lvl(first, second, asCounter)
	local id = self.db.char.activeChallengeId;
	self:InitMechanics1Lvl(first, false);
	if (not self.db.char.challenges[id].mechanics[first][second]) then
		self.db.char.challenges[id].mechanics[first][second] = (asCounter and 0) or {};
	end
end

--[[--
Add a table or counter (depends on `asCounter`) to the active challenge inside a `mechanics` (nested in 3 levels).

It doesn't do anything if value `mechanics[first][second][third]` already exists.

@param[type=string|number] first key for the new table inside `mechanics`
@param[type=string|number] second key for the new table inside mechanics&lbrack;first&rbrack;
@param[type=string|number] third key for the new value inside mechanics&lbrack;first&rbrack;&lbrack;second&rbrack;
@param[type=bool] asCounter truly for new value `0`, falsy for `{}`
]]
function MyDungeonsBook:InitMechanics3Lvl(first, second, third, asCounter)
	local id = self.db.char.activeChallengeId;
	self:InitMechanics2Lvl(first, second, false);
	if (not self.db.char.challenges[id].mechanics[first][second][third]) then
		self.db.char.challenges[id].mechanics[first][second][third] = (asCounter and 0) or {};
	end
end

--[[--
Add a table or counter (depends on `asCounter`) to the active challenge inside a `mechanics` (nested in 4 levels).

It doesn't do anything if value `mechanics[first][second][third][fourth]` already exists.

@param[type=string|number] first key for the new table inside `mechanics`
@param[type=string|number] second key for the new table inside mechanics&lbrack;first&rbrack;
@param[type=string|number] third key for the new table inside mechanics&lbrack;first&rbrack;&lbrack;second&rbrack;
@param[type=string|number] fourth key for the new value inside mechanics&lbrack;first&rbrack;&lbrack;second&rbrack;&lbrack;third&rbrack;
@param[type=bool] asCounter truly for new value `0`, falsy for `{}`
]]
function MyDungeonsBook:InitMechanics4Lvl(first, second, third, fourth, asCounter)
	local id = self.db.char.activeChallengeId;
	self:InitMechanics3Lvl(first, second, third, false);
	if (not self.db.char.challenges[id].mechanics[first][second][third][fourth]) then
		self.db.char.challenges[id].mechanics[first][second][third][fourth] = (asCounter and 0) or {};
	end
end

--[[--
Add a table or counter (depends on `asCounter`) to the active challenge inside a `mechanics` (nested in 5 levels).

It doesn't do anything if value `mechanics[first][second][third][fourth][fifth]` already exists.

@param[type=string|number] first key for the new table inside `mechanics`
@param[type=string|number] second key for the new table inside mechanics&lbrack;first&rbrack;
@param[type=string|number] third key for the new table inside mechanics&lbrack;first&rbrack;&lbrack;second&rbrack;
@param[type=string|number] fourth key for the new value inside mechanics&lbrack;first&rbrack;&lbrack;second&rbrack;&lbrack;third&rbrack;
@param[type=string|number] fifth key for the new value inside mechanics&lbrack;first&rbrack;&lbrack;second&rbrack;&lbrack;third&rbrack;&lbrack;fourth&rbrack;
@param[type=bool] asCounter truly for new value `0`, falsy for `{}`
]]
function MyDungeonsBook:InitMechanics5Lvl(first, second, third, fourth, fifth, asCounter)
	local id = self.db.char.activeChallengeId;
	self:InitMechanics4Lvl(first, second, third, fourth, false);
	if (not self.db.char.challenges[id].mechanics[first][second][third][fourth][fifth]) then
		self.db.char.challenges[id].mechanics[first][second][third][fourth][fifth] = (asCounter and 0) or {};
	end
end

--[[--
Track each player's death.

@param[type=GUID] deadUnitGUID 8th result of `CombatLogGetCurrentEventInfo` call
@param[type=string] unit 9th result of `CombatLogGetCurrentEventInfo` call
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
	local key = "DEATHS";
	self:InitMechanics2Lvl(key, unit);
	tinsert(self.db.char.challenges[id].mechanics[key][unit], time());
	self.db.char.challenges[id].challengeInfo.numDeaths = self.db.char.challenges[id].challengeInfo.numDeaths + 1;
	if (self.db.global.meta.mechanics[key].verbose) then
		self:LogPrint(string.format(L["%s died"], self:ClassColorText(unit, unit)));
	end
	self:RemoveAurasFromPartyMember(unit, deadUnitGUID);
end

--[[--
Track interrupts done by party members.

@param[type=string] unit 5th result of `CombatLogGetCurrentEventInfo` call
@param[type=string] srcGUID 4th result of `CombatLogGetCurrentEventInfo` call
@param[type=number] spellId 12th result of `CombatLogGetCurrentEventInfo` call
@param[type=number] interruptedSpellId 15th result of `CombatLogGetCurrentEventInfo` call
]]
function MyDungeonsBook:TrackInterrupt(unit, srcGUID, spellId, interruptedSpellId)
	local id = self.db.char.activeChallengeId;
	--Attribute Pet Spell's to its owner
    local type = strsplit("-", srcGUID);
	local petOwner;
    if (type == "Pet") then
		local petOwner = self:GetSummonedUnitOwner(unit, srcGUID);
    end
	if ((not petOwner) and (not UnitIsPlayer(unit))) then
		self:DebugPrint(string.format("%s is not player or pet", unit));
	end
	unit = petOwner or unit;
	local KEY = "COMMON-INTERRUPTS";
	if (spellId == 240448) then
		KEY = "COMMON-AFFIX-QUAKING-INTERRUPTS";
	end
	spellId = mergeInterruptSpellId(spellId);
	if (self.db.global.meta.mechanics[KEY].verbose) then
		self:LogPrint(string.format(L["%s interrupted %s using %s"], self:ClassColorText(unit, unit), GetSpellLink(interruptedSpellId), GetSpellLink(spellId)));
	end
	self:InitMechanics4Lvl(KEY, unit, spellId, interruptedSpellId, true);
	self.db.char.challenges[id].mechanics[KEY][unit][spellId][interruptedSpellId] = self.db.char.challenges[id].mechanics[KEY][unit][spellId][interruptedSpellId] + 1;
end

--[[--
Track dispels done by party members.

@param[type=string] unit 5th result of `CombatLogGetCurrentEventInfo` call
@param[type=string] srcGUID 4th result of `CombatLogGetCurrentEventInfo` call
@param[type=number] spellId 12th result of `CombatLogGetCurrentEventInfo` call
@param[type=number] dispelledSpellId 15th result of `CombatLogGetCurrentEventInfo` call
]]
function MyDungeonsBook:TrackDispel(unit, srcGUID, spellId, dispelledSpellId)
	local id = self.db.char.activeChallengeId;
	--Attribute Pet Spell's to its owner
    local type = strsplit("-", srcGUID);
	local petOwner;
    if (type == "Pet") then
		petOwner = self:GetSummonedUnitOwner(unit, srcGUID);
    end
	if ((not petOwner) and (not UnitIsPlayer(unit))) then
		self:DebugPrint(string.format("%s is not player or pet", unit));
		return;
	end
	local KEY = "COMMON-DISPEL";
	if (self.db.global.meta.mechanics[KEY].verbose) then
		self:LogPrint(string.format(L["%s dispelled %s using %s"], self:ClassColorText(unit, unit), GetSpellLink(dispelledSpellId), GetSpellLink(spellId)));
	end
	self:InitMechanics4Lvl(KEY, unit, spellId, dispelledSpellId, true);
	self.db.char.challenges[id].mechanics[KEY][unit][spellId][dispelledSpellId] = self.db.char.challenges[id].mechanics[KEY][unit][spellId][dispelledSpellId] + 1;
end

--[[--
Track casts that should interrupt enemies.

This mechanic is used together with `COMMON-INTERRUPTS` to get number of failed "interrupt"-casts (e.g. when 2+ party member tried to interrupt the same cast together).

@param[type=string] sourceName 5th param for `SPELL_CAST_SUCCESS`
@param[type=string] sourceGUID 4th param for `SPELL_CAST_SUCCESS`
@param[type=number] spellId 12th param for `SPELL_CAST_SUCCESS`
]]
function MyDungeonsBook:TrackTryInterrupt(sourceName, sourceGUID, spellId)
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
		[15487] = true,  --Silence
		[93985] = true,  --Skull Bash
		[97547] = true,  --Solar Beam
		[91807] = true,  --Shambling Rush
		[32747] = true,  --Arcane Torrent
	};
	if (not interrupts[spellId]) then
		return;
	end
	local id = self.db.char.activeChallengeId;
	local KEY = "COMMON-TRY-INTERRUPT";
    --Attribute Pet Spell's to its owner
    local type = strsplit("-", sourceGUID);
	local petOwnerId;
    if (type == "Pet") then
		petOwnerId = self:GetSummonedUnitOwner(sourceName, sourceGUID);
		if (not petOwnerId) then
			return;
		end
    end
    spellId = mergeInterruptSpellId(spellId);
	self:InitMechanics3Lvl(KEY, sourceName, spellId, true);
	self.db.char.challenges[id].mechanics[KEY][sourceName][spellId] = self.db.char.challenges[id].mechanics[KEY][sourceName][spellId] + 1;
end

--[[--
Track all damage done to party members

@param[type=string] unit unit name that got damage (usualy it's a destUnit from `CombatLogGetCurrentEventInfo`)
@param[type=number] spellId spell that did damage to `unit`
@param[type=number] amount amount of damage done to `unit` by `spellId`
]]
function MyDungeonsBook:TrackAllDamageDoneToPartyMembers(targetUnit, sourceUnitGUID, spellId, amount)
	local key = "ALL-DAMAGE-DONE-TO-PARTY-MEMBERS";
	if (UnitIsPlayer(targetUnit)) then
		self:SaveTrackedDamageToPartyMembers(key, targetUnit, sourceUnitGUID, spellId, amount);
	end
end

--[[--
Track all damage done by party members (including pets and other summonned units)

@param[type=string] sourceUnitName
@param[type=GUID] sourceUnitGUID
@param[type=number] spellId
@param[type=number] amount
@param[type=number] overkill
@param[type=bool] crit
]]
function MyDungeonsBook:TrackAllDamageDoneByPartyMembers(sourceUnitName, sourceUnitGUID, spellId, amount, overkill, crit)
	local id = self.db.char.activeChallengeId;
	local type = strsplit("-", sourceUnitGUID);
	local summonedUnitOwner = self:GetSummonedUnitOwner(sourceUnitName, sourceUnitGUID);
	if ((not summonedUnitOwner) and (type ~= "Pet") and (type ~= "Player")) then
		return;
	end
	local key = "ALL-DAMAGE-DONE-BY-PARTY-MEMBERS";
	self:InitMechanics4Lvl(key, sourceUnitName, "spells", spellId);
	if (summonedUnitOwner) then
		self:InitMechanics3Lvl(key, sourceUnitName, "meta");
		self.db.char.challenges[id].mechanics[key][sourceUnitName].meta.unitName = summonedUnitOwner; -- save original unit name
	end
	if (not self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hits) then
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId] = {
			hits = 0,
			amount = 0,
			overkill = 0,
			hitsCrit = 0,
			maxCrit = 0,
			minCrit = math.huge,
			amountCrit = 0,
			hitsNotCrit = 0,
			maxNotCrit = 0,
			minNotCrit = math.huge,
			amountNotCrit = 0
		};
	end
	local realAmount = amount or 0;
	local realOverkill = 0;
	if (overkill and overkill > 0) then
		realOverkill = overkill;
	end
	self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hits = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hits + 1;
	self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amount = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amount + realAmount;
	self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].overkill = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].overkill + realOverkill;
	if (crit) then
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hitsCrit = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hitsCrit + 1;
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amountCrit = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amountCrit + realAmount;
		if (realAmount > self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].maxCrit) then
			self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].maxCrit = realAmount;
		end
		if (realAmount < self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].minCrit) then
			self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].minCrit = realAmount;
		end
	else
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hitsNotCrit = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hitsNotCrit + 1;
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amountNotCrit = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amountNotCrit + realAmount;
		if (realAmount > self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].maxNotCrit) then
			self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].maxNotCrit = realAmount;
		end
		if (realAmount < self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].minNotCrit) then
			self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].minNotCrit = realAmount;
		end
	end
end

--[[--
Track all heal done by party members (including pets and other summonned units)

@param[type=string] sourceUnitName
@param[type=GUID] sourceUnitGUID
@param[type=number] sourceUnitFlags
@param[type=string] targetUnitName
@param[type=GUID] targetUnitGUID
@param[type=number] targetUnitFlags
@param[type=number] spellId
@param[type=number] amount
@param[type=number] overheal
@param[type=bool] crit
]]
function MyDungeonsBook:TrackAllHealBySpellDoneByPartyMembers(sourceUnitName, sourceUnitGUID, sourceUnitFlags, targetUnitName, targetUnitGUID, targetUnitFlags, spellId, amount, overheal, crit)
	local id = self.db.char.activeChallengeId;
	local type = strsplit("-", sourceUnitGUID);
	local summonedUnitOwner = self:GetSummonedUnitOwner(sourceUnitName, sourceUnitGUID);
	local targetIsEnemy = bit.band(targetUnitFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
	if (targetIsEnemy) then
		return;
	end
	if ((not summonedUnitOwner) and (type ~= "Pet") and (type ~= "Player")) then
		return;
	end
	local key = "ALL-HEAL-DONE-BY-PARTY-MEMBERS";
	self:InitMechanics4Lvl(key, sourceUnitName, "spells", spellId);
	if (summonedUnitOwner) then
		self:InitMechanics3Lvl(key, sourceUnitName, "meta");
		self.db.char.challenges[id].mechanics[key][sourceUnitName].meta.unitName = summonedUnitOwner; -- save original unit name
	end
	if (not self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hits) then
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId] = {
			hits = 0,
			amount = 0,
			overheal = 0,
			hitsCrit = 0,
			maxCrit = 0,
			minCrit = math.huge,
			amountCrit = 0,
			hitsNotCrit = 0,
			maxNotCrit = 0,
			minNotCrit = math.huge,
			amountNotCrit = 0
		};
	end
	local realAmount = amount or 0;
	local realOverkill = 0;
	if (overheal and overheal > 0) then
		realOverkill = overheal;
	end
	self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hits = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hits + 1;
	self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amount = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amount + realAmount;
	self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].overheal = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].overheal + realOverkill;
	if (crit) then
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hitsCrit = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hitsCrit + 1;
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amountCrit = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amountCrit + realAmount;
		if (realAmount > self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].maxCrit) then
			self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].maxCrit = realAmount;
		end
		if (realAmount < self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].minCrit) then
			self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].minCrit = realAmount;
		end
	else
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hitsNotCrit = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].hitsNotCrit + 1;
		self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amountNotCrit = self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].amountNotCrit + realAmount;
		if (realAmount > self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].maxNotCrit) then
			self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].maxNotCrit = realAmount;
		end
		if (realAmount < self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].minNotCrit) then
			self.db.char.challenges[id].mechanics[key][sourceUnitName].spells[spellId].minNotCrit = realAmount;
		end
	end
end

--[[--
@local
@param[type=string] key db key
@param[type=string] unit unit name that got damage (usualy it's a destUnit from `CombatLogGetCurrentEventInfo`)
@param[type=GUID] sourceUnitGUID damage source GUID
@param[type=number] spellId spell that did damage to `unit`
@param[type=number] amount amount of damage done to `unit` by `spellId`
]]
function MyDungeonsBook:SaveTrackedDamageToPartyMembers(key, unit, sourceUnitGUID, spellId, amount)
	if (self:IsFriendlyFire(spellId)) then
		return;
	end
	local sourceNpcId = self:GetNpcIdFromGuid(sourceUnitGUID);
	-- Save swing damage for "special" npcs separately
	if (spellId == -2 and self.db.global.meta.npcToTrackSwingDamage[sourceNpcId] ~= nil) then
		spellId = -sourceNpcId;
	end
	local amountInPercents = amount and amount / UnitHealthMax(unit) * 100 or 0;
	if (amountInPercents >= 40 and self.db.global.meta.mechanics[key].verbose) then
		local spellLink = GetSpellLink(spellId);
		self:LogPrint(string.format(L["%s got hit by %s for %s (%s)"], unit, spellLink or spellId, self:FormatNumber(amount), string.format("%.1f%%", amountInPercents)));
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

--[[--
Track gotten by players debuffs that could be avoided.

Check events `SPELL_AURA_APPLIED` and `SPELL_AURA_APPLIED_DOSE`.

@param[type=string] key db key to save debuffs done by `spells` or `spellsNoTank`
@param[type=table] auras table with keys equal to tracked spell ids
@param[type=table] aurasNoTank table with keys equal to tracked spell ids allowed to hit tanks
@param[type=unitId] unit unit name that got damage (usualy it's a destUnit from `CombatLogGetCurrentEventInfo`)
@param[type=number] spellId spell that apply debuff to `damagedUnit`
]]
function MyDungeonsBook:TrackAvoidableAuras(key, auras, aurasNoTank, unit, spellId)
	if ((auras[spellId] or (aurasNoTank[spellId] and UnitGroupRolesAssigned(unit) ~= "TANK")) and UnitIsPlayer(unit)) then
		local id = self.db.char.activeChallengeId;
		self:InitMechanics3Lvl(key, unit, spellId, true);
		self.db.char.challenges[id].mechanics[key][unit][spellId] = self.db.char.challenges[id].mechanics[key][unit][spellId] + 1;
		if (self.db.global.meta.mechanics[key].verbose) then
			self:LogPrint(string.format(L["%s got debuff by %s"], unit, GetSpellLink(spellId)));
		end
	end
end

--[[--
Track all casts done by party members and their pets

@param[type=string] unitName caster name
@param[type=GUID] unitGUID caster GUID
@param[type=number] spellId casted spell id
]]
function MyDungeonsBook:TrackAllCastsDoneByPartyMembers(unitName, unitGUID, spellId)
	local isPlayer = strfind(unitGUID, "Player");
	local isPet = strfind(unitGUID, "Pet");
	if (not isPlayer) then
		return;
	end
	local KEY = "ALL-CASTS-DONE-BY-PARTY-MEMBERS";
	local id = self.db.char.activeChallengeId;
	self:InitMechanics3Lvl(KEY, unitName, spellId, true);
	self.db.char.challenges[id].mechanics[KEY][unitName][spellId] = self.db.char.challenges[id].mechanics[KEY][unitName][spellId] + 1;
end

--[[--
Track passed casts that should be interrupted by players.

This mechanic is a subset of one from `TrackAllEnemyPassedCasts`.

@param[type=string] key db key
@param[type=table] spells table with keys equal to tracked spell ids
@param[type=string] unitName caster
@param[type=number] spellId casted spell id
]]
function MyDungeonsBook:TrackPassedCasts(key, spells, unitName, spellId)
	if (not spells[spellId]) then
		return;
	end
	if (self.db.global.meta.mechanics[key].verbose) then
		self:LogPrint(string.format(L["%s's cast %s is passed"], unitName, GetSpellLink(spellId)));
	end
	local id = self.db.char.activeChallengeId;
	self:InitMechanics2Lvl(key, spellId, true);
	self.db.char.challenges[id].mechanics[key][spellId] = self.db.char.challenges[id].mechanics[key][spellId] + 1;
end

--[[--
Track all passed casts done by enemies.

@param[type=string] unitName caster's name
@param[type=GUID] unitGUID caster's GUID
@param[type=number] spellId casted spell ID
]]
function MyDungeonsBook:TrackAllEnemiesPassedCasts(unitName, unitGUID, spellId)
	local isPlayer = strfind(unitGUID, "Player");
	local isPet = strfind(unitGUID, "Pet");
	if (isPlayer or isPet) then
		return;
	end
	local KEY = "ALL-ENEMY-PASSED-CASTS";
	local id = self.db.char.activeChallengeId;
	self:InitMechanics2Lvl(KEY, spellId, true);
	self.db.char.challenges[id].mechanics[KEY][spellId] = self.db.char.challenges[id].mechanics[KEY][spellId] + 1;
end

--[[--
Save meta info about casts and casters

@param[type=string] unitName caster's name
@param[type=GUID] unitGUID caster's GUID
@param[type=number] spellId casted spell ID
]]
function MyDungeonsBook:TrackSpellsCaster(unitName, unitGUID, spellId)
	local isPlayer = strfind(unitGUID, "Player");
	local isPet = strfind(unitGUID, "Pet");
	if (isPlayer or isPet) then
		return;
	end
	if (not self.db.global.meta.spells[spellId]) then
		self.db.global.meta.spells[spellId] = {};
	end
	local npcId = self:GetNpcIdFromGuid(unitGUID);
	if (not npcId) then
		return;
	end
	self.db.global.meta.spells[spellId].casters = self.db.global.meta.spells[spellId].casters or {};
	self.db.global.meta.spells[spellId].casters[npcId] = true;
	self.db.global.meta.npcs[npcId] = self.db.global.meta.npcs[npcId] or {};
	self.db.global.meta.npcs[npcId].name = unitName;
	self.db.global.meta.npcs[npcId].spells = self.db.global.meta.npcs[npcId].spells or {};
	self.db.global.meta.npcs[npcId].spells[spellId] = self.db.global.meta.npcs[npcId].spells[spellId] or {
		spellId = spellId
	};
end

--[[--
Track damage done by party members (and pets) for all units.

@param[type=string] key mechanic unique identifier
@param[type=table] npcs table with npcs needed to track (each key is a npc id)
@param[type=string] sourceUnitName name of unit that did damage
@param[type=GUID] sourceUnitGUID GUID of unit that did damage
@param[type=number] spellId spell id
@param[type=number] amount amount of done damage
@param[type=number] overkill amount of extra damage
@param[type=string] targetUnitName name of unit that got damage
@param[type=GUID] targetUnitGUID GUID of unit that got damage
]]
function MyDungeonsBook:TrackDamageDoneToSpecificUnits(key, npcs, sourceUnitName, sourceUnitGUID, spellId, amount, overkill, targetUnitName, targetUnitGUID)
	local id = self.db.char.activeChallengeId;
	local type = strsplit("-", sourceUnitGUID);
	if ((type ~= "Pet") and (type ~= "Player")) then
		return;
	end
	local npcId = self:GetNpcIdFromGuid(targetUnitGUID);
	if (not npcId) then
		return;
	end
	self:InitMechanics4Lvl(key, npcId, sourceUnitName, spellId);
    if (type == "Pet") then
		local summonedUnitOwner = self:GetSummonedUnitOwner(sourceUnitName, sourceUnitGUID);
		if (summonedUnitOwner) then
			self:InitMechanics4Lvl(key, npcId, sourceUnitName, "meta");
			self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName].meta.unitName = summonedUnitOwner; -- save original unit name
		end
    end
	if (not self.db.global.meta.npcs[npcId]) then
		self.db.global.meta.npcs[npcId] = {};
	end
	self.db.global.meta.npcs[npcId].name = targetUnitName;
	if (not self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName][spellId].hits) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName][spellId] = {
			hits = 0,
			amount = 0,
			overkill = 0
		};
	end
	self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName][spellId].hits = self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName][spellId].hits + 1;
	if (amount) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName][spellId].amount = self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName][spellId].amount + amount;
	else
		self:DebugPrint(string.format("Cast of %s did `nil` amount of damage to %s", GetSpellLink(spellId), targetUnitName));
	end
	if (overkill and overkill > 0) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName][spellId].overkill = self.db.char.challenges[id].mechanics[key][npcId][sourceUnitName][spellId].overkill + overkill;
	end
end

--[[--
Track specific cast done by any party member.

It should not be used for player's own spells. It should be used for some specific for dungeon spells (e.g. kicking balls in the ML).

@param[type=string] key mechanic unique identifier
@param[type=table] spells table with spells needed to track (each key is a spell id)
@param[type=string] unit name of unit that casted a spell
@param[type=number] spellId casted spell id
]]
function MyDungeonsBook:TrackSpecificCastDoneByPartyMembers(key, spells, unit, spellId)
	if (spells[spellId] and UnitIsPlayer(unit)) then
		local id = self.db.char.activeChallengeId;
		self:InitMechanics3Lvl(key, spellId, unit, true);
		self.db.char.challenges[id].mechanics[key][spellId][unit] = self.db.char.challenges[id].mechanics[key][spellId][unit] + 1;
	end
end

--[[--
Track specific items used by any party member.

Technically using items is same as casting spells.

@param[type=string] key mechanic unique identifier
@param[type=table] spells table with spells needed to track (each key is a spell id and each value is item id)
@param[type=string] unit name of unit that casted a spell
@param[type=number] spellId casted spell id
]]
function MyDungeonsBook:TrackSpecificItemUsedByPartyMembers(key, spells, unit, spellId)
	local itemId = spells[spellId];
	if (itemId and UnitIsPlayer(unit)) then
		local id = self.db.char.activeChallengeId;
		self:InitMechanics3Lvl(key, itemId, unit, true);
		self.db.char.challenges[id].mechanics[key][itemId][unit] = self.db.char.challenges[id].mechanics[key][itemId][unit] + 1;
	end
end

--[[--
Track specific buffs or debuffs got by any party member.

@param[type=string] key mechanic unique identifier
@param[type=table] spells table with buffs (or debuffs) needed to track (each key is a spell id)
@param[type=string] unit name of unit that casted a spell
@param[type=number] spellId buff (or debuff) id
]]
function MyDungeonsBook:TrackSpecificBuffOrDebuffOnPartyMembers(key, spells, unit, spellId)
	if (spells[spellId] and UnitIsPlayer(unit)) then
		local id = self.db.char.activeChallengeId;
		self:InitMechanics3Lvl(key, spellId, unit, true);
		self.db.char.challenges[id].mechanics[key][spellId][unit] = self.db.char.challenges[id].mechanics[key][spellId][unit] + 1;
	end
end

--[[--
Track if specific npc appears in combat (and how many times this happens).

@param[type=string] key - mechanic unique identifier
@param[type=table] units - table with needed to track npcs (each key is npc id)
@param[type=GUID] sourceUnitGUID - GUID of source unit
@param[type=GUID] targetUnitGUID - GUID of target unit
]]
function MyDungeonsBook:TrackUnitsAppearsInCombat(key, units, sourceUnitGUID, targetUnitGUID)
	local sourceNpcId = self:GetNpcIdFromGuid(sourceUnitGUID);
	local targetNpcId = self:GetNpcIdFromGuid(targetUnitGUID);
	local id = self.db.char.activeChallengeId;
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

--[[--
Track all heal done by party members to each other

@param[type=string] sourceUnitName caster name
@param[type=string] sourceUnitGUID caster GUID
@param[type=string] targetUnitName cast's target name
@param[type=string] targetUnitGUID cast's target GUID
@param[type=number] spellId casted spell id
@param[type=number] amount amount of healing done
@param[type=number] overheal amount of overhealing done
]]
function MyDungeonsBook:TrackAllHealDoneByPartyMembersToEachOther(sourceUnitName, sourceUnitGUID, targetUnitName, targetUnitGUID, spellId, amount, overheal)
	local id = self.db.char.activeChallengeId;
	local sourceIsPlayer = strfind(sourceUnitGUID, "Player");
	local targetIsPlayer = strfind(targetUnitGUID, "Player");
	local sourceNameToUse;
	if (sourceIsPlayer) then
		sourceNameToUse = sourceUnitName;
	else
		local sourceOwnerName = self:GetSummonedUnitOwner(sourceUnitName, sourceUnitGUID);
		if (sourceOwnerName) then
			sourceNameToUse = sourceOwnerName;
		end
	end
	if (not sourceNameToUse or not targetIsPlayer) then
		return;
	end
	local KEY = "PARTY-MEMBERS-HEAL";
	self:InitMechanics5Lvl(KEY, sourceNameToUse, spellId, targetUnitName, "amount", true);
	self:InitMechanics5Lvl(KEY, sourceNameToUse, spellId, targetUnitName, "overheal", true);
	self:InitMechanics5Lvl(KEY, sourceNameToUse, spellId, targetUnitName, "hits", true);
	self.db.char.challenges[id].mechanics[KEY][sourceNameToUse][spellId][targetUnitName].hits = self.db.char.challenges[id].mechanics[KEY][sourceNameToUse][spellId][targetUnitName].hits + 1;
	self.db.char.challenges[id].mechanics[KEY][sourceNameToUse][spellId][targetUnitName].amount = self.db.char.challenges[id].mechanics[KEY][sourceNameToUse][spellId][targetUnitName].amount + amount;
	if (overheal and overheal > 0) then
		self.db.char.challenges[id].mechanics[KEY][sourceNameToUse][spellId][targetUnitName].overheal = self.db.char.challenges[id].mechanics[KEY][sourceNameToUse][spellId][targetUnitName].overheal + overheal;
	end
end

--[[--
Track when some party member summons some unit

@param[type=string] sourceUnitName
@param[type=GUID] sourceUnitGUID
@param[type=string] targetUnitName
@param[type=GUID] targetUnitGUID
]]
function MyDungeonsBook:TrackSummonnedByPartyMembersUnit(sourceUnitName, sourceUnitGUID, targetUnitName, targetUnitGUID)
	local sourceIsPlayer = strfind(sourceUnitGUID, "Player");
	if (not sourceIsPlayer) then
		return;
	end
	local id = self.db.char.activeChallengeId;
	local KEY = "PARTY-MEMBERS-SUMMON";
	self:InitMechanics1Lvl(KEY);
	self.db.char.challenges[id].mechanics[KEY][targetUnitGUID] = sourceUnitName;
	self:DebugPrint(string.format("%s is saved as pet for %s", targetUnitName, sourceUnitName));
end

--[[--
Track if summonned by party members unit is dead

@param[type=string] targetUnitName
@param[type=GUID] targetUnitGUID
]]
function MyDungeonsBook:TrackSummonByPartyMemberUnitDeath(targetUnitName, targetUnitGUID)
	local id = self.db.char.activeChallengeId;
	local KEY = "PARTY-MEMBERS-SUMMON";
	if (self:SafeNestedGet(self.db.char.challenges[id].mechanics, KEY, targetUnitGUID)) then
		self.db.char.challenges[id].mechanics[KEY][targetUnitGUID] = nil;
	end
end

--[[--
@param[type=string] sourceUnitName
@param[type=string] sourceUnitGUID
@param[type=number] spellId
@param[type=string] auraType
@param[type=number] amount
]]
function MyDungeonsBook:TrackAuraAddedToPartyMember(sourceUnitName, sourceUnitGUID, spellId, auraType, amount)
	if (not UnitIsPlayer(sourceUnitName)) then
		return;
	end
	if (not self.db.global.meta.spells[spellId]) then
		self.db.global.meta.spells[spellId] = {};
	end
	self.db.global.meta.spells[spellId].auraType = auraType;
	local id = self.db.char.activeChallengeId;
	local KEY = "PARTY-MEMBERS-AURAS";
	self:InitMechanics3Lvl(KEY, sourceUnitName, spellId);
	self:InitMechanics4Lvl(KEY, sourceUnitName, spellId, "timeline");
	if (not self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta) then
		self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta = {
			hits = 0,
			duration = 0,
			lastStartTime = nil,
			maxAmount = 0
		};
	end
	local timestamp = time();
	if (not self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.hits) then
		self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.hits = 0;
		self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.maxAmount = 0;
	end
	self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.hits = self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.hits + 1;
	if (amount > self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.maxAmount) then
		self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.maxAmount = amount;
	end
	if (not self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.lastStartTime) then
		self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.lastStartTime = timestamp;
	end
	tinsert(self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].timeline, {timestamp, amount});
end


--[[--
@param[type=string] sourceUnitName
@param[type=string] sourceUnitGUID
@param[type=string] sourceUniFlags
@param[type=string] targetUnitName
@param[type=string] targetUnitGUID
@param[type=string] targetUnitFlags
@param[type=number] spellId
@param[type=string] auraType
@param[type=number] amount
]]
function MyDungeonsBook:TrackAuraAddedToEnemyUnit(sourceUnitName, sourceUnitGUID, sourceUnitFlags, targetUnitName, targetUnitGUID, targetUnitFlags, spellId, auraType, amount)
	local targetIsEnemy = bit.band(targetUnitFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
	if (not targetIsEnemy) then
		return;
	end
	local type = strsplit("-", sourceUnitGUID);
	if ((type == "Pet") or (type == "Player")) then
		return;
	end
	if (not self.db.global.meta.spells[spellId]) then
		self.db.global.meta.spells[spellId] = {};
	end
	self.db.global.meta.spells[spellId].auraType = auraType;
	local id = self.db.char.activeChallengeId;
	local KEY = "ENEMY-UNITS-AURAS";
	self:InitMechanics3Lvl(KEY, targetUnitGUID, spellId);
	self:InitMechanics4Lvl(KEY, targetUnitGUID, spellId, "timeline");
	if (not self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta) then
		self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta = {
			hits = 0,
			duration = 0,
			lastStartTime = nil,
			maxAmount = 0
		};
	end
	local timestamp = time();
	if (not self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.hits) then
		self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.hits = 0;
		self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.maxAmount = 0;
	end
	self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.hits = self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.hits + 1;
	if (amount > self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.maxAmount) then
		self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.maxAmount = amount;
	end
	if (not self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.lastStartTime) then
		self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.lastStartTime = timestamp;
	end
	tinsert(self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].timeline, {timestamp, amount});
end

--[[--
Track all buffs or debuffs got by any enemy unit.

@param[type=string] sourceUnitName
@param[type=string] sourceUnitGUID
@param[type=number] sourceUnitFlags
@param[type=number] spellId
@param[type=string] auraType
@param[type=number] amount
]]
function MyDungeonsBook:TrackAllBuffOrDebuffOnUnit(sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, auraType, amount)
	local KEY = "ALL-ENEMY-AURAS";
	if (not self.db.profile.dev.mechanics[KEY].enabled) then
		return;
	end
	local targetIsEnemy = bit.band(sourceUnitFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
	if (not targetIsEnemy) then
		return;
	end
	local id = self.db.char.activeChallengeId;
	local npcId = self:GetNpcIdFromGuid(sourceUnitGUID);
	if (npcId) then
		self.db.global.meta.spells[spellId] = self.db.global.meta.spells[spellId] or {};
		self.db.global.meta.spells[spellId].auraType = auraType;
		self.db.global.meta.npcs[npcId] = self.db.global.meta.npcs[npcId] or {};
		self.db.global.meta.npcs[npcId].name = sourceUnitName;
		self:InitMechanics3Lvl(KEY, spellId, npcId, true);
		self.db.char.challenges[id].mechanics[KEY][spellId][npcId] = self.db.char.challenges[id].mechanics[KEY][spellId][npcId] + 1;
	end
end

--[[--
Tracks when specific buff or debuff is added to enemy unit

@param[type=string] key
@param[type=table] neededSpells
@param[type=string] sourceUnitName
@param[type=string] sourceUnitGUID
@param[type=number] sourceUnitFlags
@param[type=number] spellId
@param[type=string] auraType
@param[type=number] amount
]]
function MyDungeonsBook:TrackSpecificAuraAddedToEnemyUnits(key, neededSpells, sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, auraType, amount)
	if (not neededSpells[spellId]) then
		return;
	end
	local targetIsEnemy = bit.band(sourceUnitFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
	if (not targetIsEnemy) then
		return;
	end
	if (not self.db.global.meta.spells[spellId]) then
		self.db.global.meta.spells[spellId] = {};
	end
	self.db.global.meta.spells[spellId].auraType = auraType;
	local id = self.db.char.activeChallengeId;
	local npcId = self:GetNpcIdFromGuid(sourceUnitGUID);
	self.db.global.meta.npcs[npcId] = self.db.global.meta.npcs[npcId] or {};
	self.db.global.meta.npcs[npcId].name = sourceUnitName;
	self:InitMechanics4Lvl(key, npcId, sourceUnitGUID, spellId);
	if (not self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta = {
			hits = 0,
			duration = 0,
			lastStartTime = nil,
			maxAmount = 0
		};
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].timeline = {};
	end
	local timestamp = time();
	self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.hits = self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.hits + 1;
	if (amount > self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.maxAmount) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.maxAmount = amount;
	end
	if (not self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.lastStartTime) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.lastStartTime = time();
	end
	tinsert(self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].timeline, {timestamp, amount});
end

--[[--
Track when buff or debuff is removed from party member (triggers for stacks changing too)

@param[type=string] sourceUnitName
@param[type=string] sourceUnitGUID
@param[type=number] spellId
@param[type=string] auraType
@param[type=number] amount
]]
function MyDungeonsBook:TrackAuraRemovedFromPartyMember(sourceUnitName, sourceUnitGUID, spellId, auraType, amount)
	if (not UnitIsPlayer(sourceUnitName)) then
		return;
	end
	local KEY = "PARTY-MEMBERS-AURAS";
	self:InitMechanics4Lvl(KEY, sourceUnitName, spellId, "meta");
	self:InitMechanics4Lvl(KEY, sourceUnitName, spellId, "timeline");
	if (not self.db.global.meta.spells[spellId]) then
		self.db.global.meta.spells[spellId] = {};
	end
	self.db.global.meta.spells[spellId].auraType = auraType;
	local id = self.db.char.activeChallengeId;
	local endTime = time();
	if (amount == 0 and self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.lastStartTime) then
		self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.duration = self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.duration +
			(endTime - self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.lastStartTime);
		self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].meta.lastStartTime = nil;
	end
	tinsert(self.db.char.challenges[id].mechanics[KEY][sourceUnitName][spellId].timeline, {endTime, amount});
end

--[[--
Track when buff or debuff is removed from party member (triggers for stacks changing too)

@param[type=string] sourceUnitName
@param[type=string] sourceUnitGUID
@param[type=number] spellId
@param[type=string] auraType
@param[type=number] amount
]]
function MyDungeonsBook:TrackAuraRemovedFromEnemyUnit(targetUnitName, targetUnitGUID, spellId, auraType, amount)
	local KEY = "ENEMY-UNITS-AURAS";
	local id = self.db.char.activeChallengeId;
	if (not self:SafeNestedGet(self.db.char.challenges[id].mechanics, KEY, targetUnitGUID, spellId)) then
		return;
	end
	self:InitMechanics4Lvl(KEY, targetUnitGUID, spellId, "meta");
	self:InitMechanics4Lvl(KEY, targetUnitGUID, spellId, "timeline");
	if (not self.db.global.meta.spells[spellId]) then
		self.db.global.meta.spells[spellId] = {};
	end
	self.db.global.meta.spells[spellId].auraType = auraType;
	local endTime = time();
	if (amount == 0 and self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.lastStartTime) then
		self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.duration = self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.duration +
			(endTime - self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.lastStartTime);
		self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].meta.lastStartTime = nil;
	end
	tinsert(self.db.char.challenges[id].mechanics[KEY][targetUnitGUID][spellId].timeline, {endTime, amount});
end

--[[--
Track when buff or debuff is removed from enemy unit (triggers for stacks changing too)

@param[type=string] key
@param[type=string] sourceUnitName
@param[type=string] sourceUnitGUID
@param[type=string] sourceUnitFlags
@param[type=number] spellId
@param[type=string] auraType
@param[type=number] amount
]]
function MyDungeonsBook:TrackAuraRemovedFromEnemyUnits(key, neededSpells, sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, auraType, amount)
	local targetIsEnemy = bit.band(sourceUnitFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
	if (not targetIsEnemy) then
		return;
	end
	if (not neededSpells[spellId]) then
		return;
	end
	local id = self.db.char.activeChallengeId;
	local npcId = self:GetNpcIdFromGuid(sourceUnitGUID);
	self:InitMechanics4Lvl(key, npcId, sourceUnitGUID, spellId);
	local endTime = time();
	self:InitMechanics5Lvl(key, npcId, sourceUnitGUID, spellId, "meta");
	self:InitMechanics5Lvl(key, npcId, sourceUnitGUID, spellId, "timeline");
	if (amount == 0 and self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.lastStartTime) then
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.duration = self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.duration +
				(endTime - self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.lastStartTime);
		self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].meta.lastStartTime = nil;
	end
	tinsert(self.db.char.challenges[id].mechanics[key][npcId][sourceUnitGUID][spellId].timeline, {endTime, amount});
end

--[[--
Force to "clear" auras from some party member.

Used when party member dies or when challenge is completed.

@param[type=string] sourceUnitName
@param[type=string] sourceUnitGUID
]]
function MyDungeonsBook:RemoveAurasFromPartyMember(sourceUnitName, sourceUnitGUID)
    if (not UnitIsPlayer(sourceUnitName)) then
        return;
    end
	local KEY = "PARTY-MEMBERS-AURAS";
	self:InitMechanics2Lvl(KEY, sourceUnitName);
	local id = self.db.char.activeChallengeId;
	for spellId, info in pairs(self.db.char.challenges[id].mechanics[KEY][sourceUnitName]) do
		if (info and info.meta.lastStartTime) then
			self:TrackAuraRemovedFromPartyMember(sourceUnitName, sourceUnitGUID, spellId, self.db.global.meta.spells[spellId].auraType, 0);
		end
	end
end

--[[--
Works only for currently active challenge

@param[type=string] petUnitName
@param[type=GUID] petUnitGUID
@return[type=?string]
]]
function MyDungeonsBook:GetSummonedUnitOwner(petUnitName, petUnitGUID)
	local id = self.db.char.activeChallengeId;
	local challenge = self:Challenge_GetById(id);
	local summonedUnitOwnerName = self:SafeNestedGet(self.db.char.challenges[id].mechanics, "PARTY-MEMBERS-SUMMON", petUnitGUID);
	if (summonedUnitOwnerName) then
		return summonedUnitOwnerName;
	else
		local ownerUnitId = self:FindPetOwnerId(petUnitGUID);
		if (ownerUnitId) then
			local playerRealm = challenge.players.player.realm;
			local ownerRealm = challenge.players[ownerUnitId].realm;
			local name, nameAndRealm = self:GetNameByPartyUnit(id, ownerUnitId);
			local ownerName = name;
			if (playerRealm ~= ownerRealm) then
				ownerName = nameAndRealm;
			end
			self:TrackSummonnedByPartyMembersUnit(ownerName, UnitGUID(ownerName), petUnitName, petUnitGUID);
			return ownerName;
		end
	end
end

--[[--
Track when enemy unit died

Used to stop timers for buffs and debuffs for dead unit

@param[type=string] sourceUnitName
@param[type=GUID] sourceUnitGUID
@param[type=number] sourceUnitFlags
]]
function MyDungeonsBook:TrackEnemyUnitDied(sourceUnitName, sourceUnitGUID, sourceUnitFlags)
	local targetIsEnemy = bit.band(sourceUnitFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
	if (not targetIsEnemy) then
		return;
	end
	local id = self.db.char.activeChallengeId;
	local npcId = self:GetNpcIdFromGuid(sourceUnitGUID);
	local mechanics = self.db.char.challenges[id].mechanics;
	local bfaMechanic = self:SafeNestedGet(mechanics, "BFA-BUFFS-OR-DEBUFFS-ON-UNIT", npcId, sourceUnitGUID);
	if (bfaMechanic) then
		for spellId, info in pairs(bfaMechanic) do
			if (info and info.lastStartTime) then
				self:TrackBfASpecificBuffOrDebuffRemovedFromUnit(sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, self.db.global.meta.spells[spellId].auraType, 0);
			end
		end
	end
	local slMechanic = self:SafeNestedGet(mechanics, "SL-BUFFS-OR-DEBUFFS-ON-UNIT", npcId, sourceUnitGUID);
	if (slMechanic) then
		for spellId, info in pairs(slMechanic) do
			if (info and info.lastStartTime) then
				self:TrackSLSpecificBuffOrDebuffRemovedFromUnit(sourceUnitName, sourceUnitGUID, sourceUnitFlags, spellId, self.db.global.meta.spells[spellId].auraType, 0);
			end
		end
	end
	local KEY = "UNIT-APPEARS-IN-COMBAT";
	self:InitMechanics2Lvl(KEY, sourceUnitGUID);
	self.db.char.challenges[id].mechanics[KEY][sourceUnitGUID].died = time();
end

--[[--
Track when enemy unit appears in combat with party members (players or pets)

@param[type=string] sourceUnitName
@param[type=GUID] sourceUnitGUID
@param[type=number] sourceUnitFlags
@param[type=string] targetUnitName
@param[type=GUID] targetUnitGIUD
@param[type=number] targetUnitFlags
]]
function MyDungeonsBook:TrackEnemyUnitAppearsInCombat(sourceUnitName, sourceUnitGUID, sourceUnitFlags, targetUnitName, targetUnitGIUD, targetUnitFlags)
	local sourceIsEnemy = bit.band(sourceUnitFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
	local targetIsEnemy = bit.band(targetUnitFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0;
	local sourceType = strsplit("-", sourceUnitGUID);
	local sourceIsPlayerOrPet = (sourceType == "Pet") or (sourceType == "Player");
	local targetType = strsplit("-", targetUnitGIUD);
	local targetIsPlayerOrPet = (targetType == "Pet") or (targetType == "Player");
	if (not (sourceIsEnemy or targetIsEnemy)) then
		return;
	end
	if (not ((sourceIsEnemy and targetIsPlayerOrPet) or (targetIsEnemy and sourceIsPlayerOrPet))) then
		return;
	end
	local id = self.db.char.activeChallengeId;
	local KEY = "UNIT-APPEARS-IN-COMBAT";
	local unitGUID = (sourceIsEnemy and sourceUnitGUID) or targetUnitGIUD;
	if (self:SafeNestedGet(self.db.char.challenges[id].mechanics, KEY, unitGUID)) then
		self.db.char.challenges[id].mechanics[KEY][unitGUID].lastCast = time();
	else
		self:InitMechanics2Lvl(KEY, unitGUID);
		self.db.char.challenges[id].mechanics[KEY][unitGUID].firstHit = time();
	end
end
