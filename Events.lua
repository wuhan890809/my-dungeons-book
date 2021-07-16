--[[--
@module MyDungeonsBook
]]

--[[--
Event Handlers
@section EventHandlers
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Check combat events while player is in challenge.

It's triggered only when challenge is active.
]]
function MyDungeonsBook:COMBAT_LOG_EVENT_UNFILTERED()
	if (not self.db.char.activeChallengeId) then
		return;
	end
	local timestamp, subEventName, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2 = CombatLogGetCurrentEventInfo();
	local subEventPrefix, subEventSuffix = subEventName:match("^(.-)_?([^_]*)$");
	self:TrackEnemyUnitAppearsInCombat(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags);
	self:TrackSLUnitsAppearsInCombat(srcGUID, dstGUID); -- TODO remove later
	if (subEventSuffix == "SUMMON" or
		subEventSuffix == "CREATE") then
		self:TrackSummonnedByPartyMembersUnit(srcName, srcGUID, dstName, dstGUID);
	end
	if (subEventName == "UNIT_DIED") then
		self:TrackDeath(timestamp, dstName, dstGUID);
		self:TrackSummonByPartyMemberUnitDeath(dstName, dstGUID);
		self:TrackEnemyUnitDied(dstName, dstGUID, dstFlags);
		self:RemoveAurasFromPartyMember(dstName, dstGUID);
		self:SaveDeathLogsForPartyMember(timestamp, dstName);
	end
	if (subEventName == "UNIT_DESTROYED") then
		self:TrackSummonByPartyMemberUnitDeath(dstName, dstGUID);
	end
	if (subEventSuffix == "HEAL") then
		local spellId, _, _, amount, overheal, _, crit = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllHealDoneByPartyMembersToEachOther(srcName, srcGUID, dstName, dstGUID, spellId, amount, overheal);
		self:TrackAllHealBySpellDoneByPartyMembers(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, spellId, amount, overheal, crit);
		self:TrackCombatEventWithPartyMember(timestamp, dstName, dstGUID);
	end
	if (subEventName == "DAMAGE_SPLIT" or
		subEventName == "DAMAGE_SHIELD") then
		local spellId, _, _, amount, overheal = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllHealDoneByPartyMembersToEachOther(srcName, srcGUID, dstName, dstGUID, spellId, amount, overheal);
		self:TrackAllHealBySpellDoneByPartyMembers(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, spellId, amount, overheal, false);
		self:TrackCombatEventWithPartyMember(timestamp, dstName, dstGUID);
	end
	if (subEventName == "SPELL_ABSORBED") then
		local unitGUID, unitName, unitFlags, _, spellId, _, _, amount = select(12, CombatLogGetCurrentEventInfo());
		local N22 = select(22, CombatLogGetCurrentEventInfo());
		if (N22 ~= nil) then
			unitGUID, unitName, unitFlags, _, spellId, _, _, amount = select(15, CombatLogGetCurrentEventInfo());
		end
		self:TrackAllHealDoneByPartyMembersToEachOther(unitName, unitGUID, dstName, dstGUID, spellId, amount, -1);
		self:TrackAllHealBySpellDoneByPartyMembers(unitName, unitGUID, unitFlags, dstName, dstGUID, dstFlags, spellId, amount, -1, false);
		self:TrackCombatEventWithPartyMember(timestamp, dstName, dstGUID);
	end
	if (subEventSuffix == "INTERRUPT") then
		local spellId, _, _, extraSpellId = select(12, CombatLogGetCurrentEventInfo());
		self:TrackInterrupt(srcName, srcGUID, spellId, extraSpellId, dstFlags2);
	end
	if (subEventSuffix == "DISPEL" or
		subEventName == "SPELL_STOLEN") then
		local spellId, _, _, extraSpellId = select(12, CombatLogGetCurrentEventInfo());
		self:TrackDispel(srcName, srcGUID, spellId, extraSpellId, dstFlags2);
		self:TrackCombatEventWithPartyMember(timestamp, dstName, dstGUID);
	end
	if (subEventName == "SPELL_CAST_SUCCESS") then
		local spellId = select(12, CombatLogGetCurrentEventInfo());
		self:TrackTryInterrupt(srcName, srcGUID, spellId);
		self:TrackSLPassedCasts(srcName, spellId, srcFlags2);
		self:TrackAllEnemiesPassedCasts(srcName, srcGUID, spellId);
		self:TrackSpellsCaster(srcName, srcGUID, spellId);
		self:TrackSLSpecificCastDoneByPartyMembers(srcName, spellId);
		self:TrackAllCastsDoneByPartyMembers(srcName, srcGUID, spellId);
		self:TrackSLSpecificItemUsedByPartyMembers(srcName, spellId);
		self:TrackOwnCastDoneByPartyMembers(timestamp, srcName, spellId, dstName);
	end
	if ((subEventPrefix:match("^SPELL") or subEventPrefix:match("^RANGE")) and subEventSuffix == "DAMAGE") then
		local spellId, _, _, amount, overkill, _, _, _, _, crit = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllDamageDoneToPartyMembers(srcName, dstName, srcGUID, srcFlags, spellId, amount);
		self:TrackAllEnemiesFriendlyFire(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags);
		self:TrackAllDamageDoneByPartyMembers(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, spellId, amount, overkill, crit);
		self:TrackSLDamageDoneToSpecificUnits(srcName, srcGUID, spellId, amount, overkill, dstName, dstGUID);
		self:TrackCombatEventWithPartyMember(timestamp, dstName, dstGUID);
	end
	if (subEventName == "SWING_DAMAGE") then
		local amount, overkill, _, _, _, _, crit = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllDamageDoneToPartyMembers(srcName, dstName, srcGUID, srcFlags, -2, amount);
		self:TrackAllDamageDoneByPartyMembers(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, -2, amount, overkill, crit);
		self:TrackSLDamageDoneToSpecificUnits(srcName, srcGUID, -2, amount, overkill, dstName, dstGUID);
		self:TrackCombatEventWithPartyMember(timestamp, dstName, dstGUID);
	end
	if (subEventName == "SPELL_EXTRA_ATTACKS") then
		local amount = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllDamageDoneToPartyMembers(srcName, dstName, srcGUID, srcFlags, -2, amount);
		self:TrackAllDamageDoneByPartyMembers(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, -2, amount, 0, false);
	end
	if ((subEventPrefix:match("^SPELL") or subEventPrefix:match("^RANGE")) and subEventSuffix == "MISSED") then
		local spellId, _, _, _, _, amount = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllDamageDoneToPartyMembers(srcName, dstName, srcGUID, srcFlags, spellId, amount);
		self:TrackAllDamageDoneByPartyMembers(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, spellId, amount, 0, false);
	end
	if (subEventName == "SPELL_AURA_APPLIED" or
		subEventName == "SPELL_AURA_APPLIED_DOSE") then
		local spellId, _, _, auraType, amount = select(12, CombatLogGetCurrentEventInfo());
		self:TrackSLSpecificBuffOrDebuffOnPartyMembers(dstName, spellId);
		self:TrackSLSpecificBuffOrDebuffOnUnit(dstName, dstGUID, dstFlags, spellId, auraType, amount or 1);
		self:TrackAllBuffOrDebuffOnUnit(dstName, dstGUID, dstFlags, spellId, auraType, amount or 1);
		self:TrackAuraAddedToPartyMember(dstName, dstGUID, spellId, auraType, amount or 1);
		self:TrackAuraAddedToEnemyUnit(srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, spellId, auraType, amount or 1);
		self:TrackCombatEventWithPartyMember(timestamp, dstName, dstGUID);
	end
	if (subEventName == "SPELL_AURA_REMOVED" or
		subEventName == "SPELL_AURA_REMOVED_DOSE" or
		subEventName == "SPELL_AURA_BROKEN" or
		subEventName == "SPELL_AURA_BROKEN_SPELL") then
		local spellId, _, _, auraType, amount = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAuraRemovedFromPartyMember(dstName, dstGUID, spellId, auraType, amount or 0);
		self:TrackAuraRemovedFromEnemyUnit(dstName, dstGUID, spellId, auraType, amount or 0);
		self:TrackSLSpecificBuffOrDebuffRemovedFromUnit(dstName, dstGUID, dstFlags, spellId, auraType, amount or 0);
		self:TrackCombatEventWithPartyMember(timestamp, dstName, dstGUID);
	end
	if (subEventName == "SPELL_AURA_BROKEN" or
		subEventName == "SPELL_AURA_BROKEN_SPELL") then
		local brokenSpellId, _, _, spellId = select(12, CombatLogGetCurrentEventInfo());
		if (type(spellId) ~= "number") then
			spellId = -2; -- Swing Damage
		end
		self:TrackEnemyAuraBrokenByDamage(timestamp, srcName, srcGUID, srcFlags, dstName, dstGUID, dstFlags, brokenSpellId, spellId);
	end
end

--[[--
Save info about started challenge to the db.

Next fields are saved:

* key level
* affixes
* time
* zone name and its id
* map id
* team roster - name, race, class, spec, realm, items
]]
function MyDungeonsBook:CHALLENGE_MODE_START()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("CHAT_MSG_LOOT");
    self:DebugPrint("CHALLENGE_MODE_START");
	wipe(self.allPartyMemberLogs or {});
	if (self.partyAliveStatusCheckTimer) then
		self:CancelTimer(self.partyAliveStatusCheckTimer);
	end
	self.partyAliveStatusCheckTimer = self:ScheduleRepeatingTimer("PartyAliveStatusCheck", 1);
	if (self.db.char.activeChallengeId) then
		self:DebugPrint(string.format("Challenge already exists with id %s", self.db.char.activeChallengeId));
		return;
	end
	local startTimestamp = time();
	local id = startTimestamp;
	self:InitNewDungeonChallenge(id);
	self.db.char.activeChallengeId = id;
	local _, _, _, _, _, _, _, currentZoneId = GetInstanceInfo();
	self:DebugPrint(string.format("currentZoneId is %s", currentZoneId));
	local cmLevel, affixes = C_ChallengeMode.GetActiveKeystoneInfo();
	self:DebugPrint(string.format("cmLevel is %s", cmLevel));
	local currentMapId = C_ChallengeMode.GetActiveChallengeMapID();
	self:DebugPrint(string.format("currentMapId is %s", currentMapId));
	local _, _, steps = C_Scenario.GetStepInfo();
	local zoneName, _, maxTime = C_ChallengeMode.GetMapUIInfo(currentMapId);
	self:DebugPrint(string.format("zoneName is %s", zoneName));
	self:DebugPrint(string.format("maxTime is %s", maxTime));

	local affixIds = {};
	for _, affixId in pairs(affixes) do
		table.insert(affixIds, affixId);
	end

	local affixesKey = "affixes";
	for _, k in ipairs(affixIds) do
		affixesKey = string.format("%s-%s", affixesKey, k);
	end

	self:DebugPrint(string.format("affixesKey is %s", affixesKey));

	self.db.char.challenges[id].players.player = self:ParseUnitInfoWithWowApi("player");
	local playersRealm = self.db.char.challenges[id].players.player.realm;
	for _, unitId in pairs(self:GetPartyRoster()) do
		self:UpdateUnitInfo(UnitGUID(unitId)); -- must be done first!
		local name, nameAndRealm = self:GetNameByPartyUnit(id, unitId);
		local nameToUse = name;
		if (playersRealm ~= self.db.char.challenges[id].players[unitId].realm) then
			nameToUse = nameAndRealm;
		end
		self:AddAurasToPartyMember(nameToUse, unitId);
		local petUnitId = unitId .. "pet";
        if (UnitExists(petUnitId)) then
			self:TrackSummonnedByPartyMembersUnit(nameToUse, UnitGUID(unitId), UnitName(petUnitId), UnitGUID(petUnitId));
        end
	end
	self:NotifyUpdateGroupInfo();
	local version, build, date, tocversion = GetBuildInfo();
	self:DebugPrint(string.format("version - %s, build - %s, date - %s, tocversion - %s", version, build, date, tocversion));
	self.db.char.challenges[id].gameInfo = {
		version = version,
		build = build,
		date = date,
		tocversion = tocversion
	};
	local damageMod, healthMod = C_ChallengeMode.GetPowerLevelDamageHealthMod(cmLevel);
	self:DebugPrint(string.format("damageMod - %s%%, healthMod - %s%%", damageMod, healthMod));
	self.db.char.challenges[id].challengeInfo = {
		cmLevel = cmLevel,
		levelKey = "l" .. cmLevel,
		affixes = affixes,
		affixesKey = affixesKey,
		zoneName = zoneName,
		currentZoneId = currentZoneId,
		currentMapId = currentMapId,
		maxTime = maxTime,
		steps = steps,
		startTime = startTimestamp,
		damageMod = damageMod,
		healthMod = healthMod,
		numDeaths = 0,
		neededEnemyForces = self:GetNeededEnemyForcesForActiveChallenge()
	};
	if (self.challengesTable) then
		self.challengesTable:SetData(self:ChallengesFrame_GetDataForTable());
	end
	self:LogPrint(string.format(L["%s +%s is started"], zoneName, cmLevel));
end

--[[--
Mark active challenge as completed.
]]
function MyDungeonsBook:CHALLENGE_MODE_RESET()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:UnregisterEvent("PLAYER_REGEN_DISABLED");
	self:UnregisterEvent("PLAYER_REGEN_ENABLED");
	self:UnregisterEvent("CHAT_MSG_LOOT");
	if (self.partyAliveStatusCheckTimer) then
		self:CancelTimer(self.partyAliveStatusCheckTimer);
	end
	local id = self.db.char.activeChallengeId;
	if (self.db.char.challenges[id]) then
		self.db.char.challenges[id].endTime = time();
		self:LogPrint(string.format(L["%s +%s is reset"], self.db.char.challenges[id].challengeInfo.zoneName, self.db.char.challenges[id].challengeInfo.cmLevel));
	end
	self.db.char.activeChallengeId = nil;
end

--[[--
Mark active challenge as completed and store additional info about it.

Next information is saved:

* Info from Details addon
* time lost by deaths
* key level upgrade
* challenge duration
]]
function MyDungeonsBook:CHALLENGE_MODE_COMPLETED()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	if (self.partyAliveStatusCheckTimer) then
		self:CancelTimer(self.partyAliveStatusCheckTimer);
	end
	local id = self.db.char.activeChallengeId;
	if (self.db.char.challenges[id]) then
		self.db.char.challenges[id].challengeInfo.endTime = time();
		local mapID, level, time, onTime, keystoneUpgradeLevels, practiceRun = C_ChallengeMode.GetCompletionInfo();
		local numDeaths, timeLost = C_ChallengeMode.GetDeathCount();
		self.db.char.challenges[id].challengeInfo.onTime = onTime;
		self.db.char.challenges[id].challengeInfo.duration = time;
		self.db.char.challenges[id].challengeInfo.keystoneUpgradeLevels = keystoneUpgradeLevels;
		self.db.char.challenges[id].challengeInfo.timeLost = timeLost;
		self.db.char.challenges[id].challengeInfo.numDeaths = numDeaths;
		self:LogPrint(string.format(L["%s +%s is completed"], self.db.char.challenges[id].challengeInfo.zoneName, self.db.char.challenges[id].challengeInfo.cmLevel));
		if (self.challengesTable) then
			self.challengesTable:SetData(self:ChallengesFrame_GetDataForTable());
		end
		if (self.db.char.challenges[id].mechanics["PARTY-MEMBERS-SUMMON"]) then
			wipe(self.db.char.challenges[id].mechanics["PARTY-MEMBERS-SUMMON"]); -- no sense to store hundreds of GUIDs
		end
		local playersRealm = self.db.char.challenges[id].players.player.realm;
		for _, unitId in pairs(self:GetPartyRoster()) do
			local name, nameAndRealm = self:GetNameByPartyUnit(id, unitId);
			local nameToUse = name;
			if (playersRealm ~= self.db.char.challenges[id].players[unitId].realm) then
				nameToUse = nameAndRealm;
			end
			self:RemoveAurasFromPartyMember(nameToUse, UnitGUID(unitId));
		end
		for i = 1, 4 do
			local target = "party" .. i;
			self:Message_CharacterData_Send(target);
			self:Message_IdleTime_Send(target);
		end
		self:ScheduleTimer(function()
			self.db.char.activeChallengeId = nil;
		end, 5);
		-- must be last!
		if (self.db.profile.performance.compress) then
			self.db.char.challenges[id].mechanics = self:Compress(self.db.char.challenges[id].mechanics);
		end
	end
	self:UnregisterEvent("PLAYER_REGEN_DISABLED");
	self:UnregisterEvent("PLAYER_REGEN_ENABLED");
	self:UnregisterEvent("CHAT_MSG_LOOT");
	wipe(self.allPartyMemberLogs or {});
end

--[[--
Reset `activeChallengeId` if player is not in challenge.
]]
function MyDungeonsBook:PLAYER_ENTERING_WORLD()
	if (not self:IsInChallengeMode()) then
		self.db.char.activeChallengeId = nil;
	end
end

--[[--
Parse info about party member if it'ready.

Its request is sent in the `MyDungeonsBook:CHALLENGE_MODE_START`

@param[type=string] _ "INSPECT_READY"
@param[type=GUID] guid
]]
function MyDungeonsBook:INSPECT_READY(_, guid)
	self:UpdateUnitInfo(guid);
end

--[[--
Get info for each encounter when it's started.

Encounters have unique IDs, however encounters can be ended not successfully (e.g. boss is not killed and team is dead) and can be restarted.
So, only last try will be saved (typically it should be successful try).

Each encounter has next fields:

* `id` - encounter id
* `name` - encounter name (usually, name of the boss)
* `startTime` - timestamp, when encounter is started
* `deathCountOnStart` - number of deaths when encounter starts
* `endTime` - timestamp, when encounter is ended (it's set in the `MyDungeonsBook:ENCOUNTER_END`)
* `deathCountOnEnd` - number of deaths when encounter ends (it's set in the `MyDungeonsBook:ENCOUNTER_END`)
* `success` - was encounter passed or not (it's set in the `MyDungeonsBook:ENCOUNTER_END`)

@param[type=string] _
@param[type=number] encounterId
@param[type=string] encounterName
]]
function MyDungeonsBook:ENCOUNTER_START(_, encounterId, encounterName, ...)
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return;
	end
	if (not self.db.char.challenges[id]) then
		return;
	end
	local ts = time();
	self.db.char.challenges[id].misc.lastEncounterId = ts;
	local enemyForcesProgressMechanic = self:SafeNestedGet(self.db.char.challenges[id].mechanics, "ENEMY-FORCES-PROGRESS");
	local enemyForcesOnStart;
	if (enemyForcesProgressMechanic) then
		enemyForcesOnStart = (enemyForcesProgressMechanic[#enemyForcesProgressMechanic] or {})[2];
	end
	self.db.char.challenges[id].encounters[ts] = {
		id = encounterId,
		name = encounterName,
		startTime = ts,
		deathCountOnStart = C_ChallengeMode.GetDeathCount(),
		enemyForcesOnStart = enemyForcesOnStart
	};
	self:NotifyUpdateGroupInfo();
	self:DebugPrint("ENCOUNTER_START", encounterId, encounterName);
end

--[[--
Get additional info (`endTime`, `deathCountOnEnd`, `success`) about each encounter when it's ended.

@param[type=string] _ "ENCOUNTER_END"
@param[type=number] encounterId
@param[type=string] encounterName
@param[type=number] difficultyId
@param[type=number] groupSize
@param[type=?bool] success
]]
function MyDungeonsBook:ENCOUNTER_END(_, encounterId, encounterName, difficultyId, groupSize, success)
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return;
	end
	if (not self.db.char.challenges[id]) then
		return;
	end
	local lastEncounterId = self.db.char.challenges[id].misc.lastEncounterId;
	if (not lastEncounterId) then
		-- is it possible???
		return;
	end
	local enemyForcesProgressMechanic = self:SafeNestedGet(self.db.char.challenges[id].mechanics, "ENEMY-FORCES-PROGRESS");
	local enemyForcesOnEnd;
	if (enemyForcesProgressMechanic) then
		enemyForcesOnEnd = (enemyForcesProgressMechanic[#enemyForcesProgressMechanic] or {})[2];
	end
	self.db.char.challenges[id].encounters[lastEncounterId].endTime = time();
	self.db.char.challenges[id].encounters[lastEncounterId].success = success;
	self.db.char.challenges[id].encounters[lastEncounterId].deathCountOnEnd = C_ChallengeMode.GetDeathCount();
	self.db.char.challenges[id].encounters[lastEncounterId].enemyForcesOnEnd = enemyForcesOnEnd;
	self.db.char.challenges[id].misc.lastEncounterId = nil;
	self:DebugPrint("ENCOUNTER_END", encounterId, encounterName, difficultyId, groupSize, success);
end

--[[--
Track when player leaves a combat

Used to calculate idle time
]]
function MyDungeonsBook:PLAYER_REGEN_ENABLED()
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return;
	end
	local KEY = "PARTY_MEMBERS_IDLE";
	local name = UnitName("player");
	self:InitMechanics3Lvl(KEY, name, "meta");
	self:InitMechanics4Lvl(KEY, name, "meta", "duration", true);
	self:InitMechanics3Lvl(KEY, name, "timeline");
	local timestamp = time();
	self.db.char.challenges[id].mechanics[KEY][name].meta.lastStartTime = timestamp;
	tinsert(self.db.char.challenges[id].mechanics[KEY][name].timeline, {timestamp, 0});
	self:DebugPrint("Combat is finished.");
end

--[[--
Track when player enters a combat

Used to calculate idle time
]]
function MyDungeonsBook:PLAYER_REGEN_DISABLED()
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return;
	end
	local KEY = "PARTY_MEMBERS_IDLE";
	local name = UnitName("player");
	local now = time();
	self:InitMechanics3Lvl(KEY, name, "meta");
	self:InitMechanics4Lvl(KEY, name, "meta", "duration", true);
	self:InitMechanics3Lvl(KEY, name, "timeline");
	local currentIdle = time() - (self.db.char.challenges[id].mechanics[KEY][name].meta.lastStartTime or now);
	local overallIdle = self.db.char.challenges[id].mechanics[KEY][name].meta.duration + currentIdle;
	self.db.char.challenges[id].mechanics[KEY][name].meta.duration = overallIdle;
	self.db.char.challenges[id].mechanics[KEY][name].meta.lastStartTime = nil;
	self:DebugPrint(string.format("Combat is started. Idle time - %s, overall - %s", self:FormatTime(currentIdle * 1000), self:FormatTime(overallIdle * 1000)));
	local timestamp = time();
	tinsert(self.db.char.challenges[id].mechanics[KEY][name].timeline, {timestamp, 1});
end

--[[--
Track enemy forces progress
]]
function MyDungeonsBook:SCENARIO_CRITERIA_UPDATE()
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return;
	end
	local KEY = "ENEMY-FORCES-PROGRESS";
	self:InitMechanics1Lvl(KEY);
	local _, _, steps = C_Scenario.GetStepInfo();
	if (steps and steps > 0) then
		for i = 1, steps do
			local name, _, completed, curValue, finalValue, _, _, quantity, criteriaId = C_Scenario.GetCriteriaInfo(i);
			if (criteriaId == 0) then
				local quantityNumber = string.sub(quantity, 1, string.len(quantity) - 1);
				local quantityPercent = tonumber(quantityNumber) / finalValue;
				if (completed) then
					quantityPercent = 1;
				end
				tinsert(self.db.char.challenges[id].mechanics[KEY], {time(), quantityPercent});
			end
		end
	end
end

--[[--
Used to track anima-powers for SL season 2 (for now)
]]
function MyDungeonsBook:CHAT_MSG_LOOT(_, text, partyMemberName)
    if (not self.db.char.activeChallengeId) then
        return;
    end
    if (not string.find(text, "mawpower")) then
        return;
    end
    local partyUnitId = self:GetPartyUnitByName(self.db.char.activeChallengeId, partyMemberName);
    if (not partyUnitId) then
        return;
    end
    self:UpdatePartyMemberAnimaPowers(self.db.char.activeChallengeId, text, partyUnitId);
end