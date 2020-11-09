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
	self:TrackBfAUnitsAppearsInCombat(srcGUID, dstGUID);
	self:TrackSLUnitsAppearsInCombat(srcGUID, dstGUID);
	if (subEventSuffix == "SUMMON" or
		subEventSuffix == "CREATE") then
		self:TrackSummonnedByPartyMembersUnit(srcName, srcGUID, dstName, dstGUID);
	end
	if (subEventName == "UNIT_DIED") then
		self:TrackDeath(dstGUID, dstName);
		self:TrackSummonByPartyMemberUnitDeath(dstGUID, dstName);
	end
	if (subEventName == "UNIT_DESTROYED") then
		self:TrackSummonByPartyMemberUnitDeath(dstGUID, dstName);
	end
	if (subEventSuffix == "HEAL") then
		local spellId, _, _, amount, overheal, _, crit = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllHealDoneByPartyMembersToEachOther(srcName, srcGUID, dstName, dstGUID, spellId, amount, overheal);
		self:TrackAllHealBySpellDoneByPartyMembers(srcName, srcGUID, spellId, amount, overheal, crit);
	end
	if (subEventName == "DAMAGE_SPLIT" or
		subEventName == "DAMAGE_SHIELD") then
		local spellId, _, _, amount, overheal = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllHealDoneByPartyMembersToEachOther(srcName, srcGUID, dstName, dstGUID, spellId, amount, overheal);
		self:TrackAllHealBySpellDoneByPartyMembers(srcName, srcGUID, spellId, amount, overheal, false);
	end
	if (subEventName == "SPELL_ABSORBED") then
		local unitGUID, unitName, _, _, spellId, _, _, amount = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllHealDoneByPartyMembersToEachOther(unitName, unitGUID, dstName, dstGUID, spellId, amount, -1);
		self:TrackAllHealBySpellDoneByPartyMembers(srcName, srcGUID, spellId, amount, -1, false);
	end
	if (subEventSuffix == "INTERRUPT") then
		local spellId, _, _, extraSpellId = select(12, CombatLogGetCurrentEventInfo());
		self:TrackInterrupt(srcName, srcGUID, spellId, extraSpellId);
	end
	if (subEventSuffix == "DISPEL" or
		subEventName == "SPELL_STOLEN") then
		local spellId, _, _, extraSpellId = select(12, CombatLogGetCurrentEventInfo());
		self:TrackDispel(srcName, srcGUID, spellId, extraSpellId);
	end
	if (subEventName == "SPELL_CAST_SUCCESS") then
		local spellId = select(12, CombatLogGetCurrentEventInfo());
		self:TrackTryInterrupt(srcName, srcGUID, spellId);
		self:TrackSLPassedCasts(srcName, spellId);
		self:TrackBfAPassedCasts(srcName, spellId);
		self:TrackAllEnemiesPassedCasts(srcName, srcGUID, spellId);
		self:TrackBfASpecificCastDoneByPartyMembers(srcName, spellId);
		self:TrackSLSpecificCastDoneByPartyMembers(srcName, spellId);
		self:TrackAllCastsDoneByPartyMembers(srcName, srcGUID, spellId);
		self:TrackBfASpecificItemUsedByPartyMembers(srcName, spellId);
		self:TrackSLSpecificItemUsedByPartyMembers(srcName, spellId);
		self:TrackOwnCastDoneByPartyMembers(srcName, spellId, dstName);
	end
	if ((subEventPrefix:match("^SPELL") or subEventPrefix:match("^RANGE")) and subEventSuffix == "DAMAGE") then
		local spellId, _, _, amount, overkill, _, _, _, _, crit = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllDamageDoneToPartyMembers(dstName, spellId, amount);
		self:TrackAllDamageDoneByPartyMembers(srcName, srcGUID, spellId, amount, overkill, crit);
		self:TrackBfAAvoidableSpells(dstName, spellId, amount);
		self:TrackSLAvoidableSpells(dstName, spellId, amount);
		self:TrackBfADamageDoneToSpecificUnits(srcName, srcGUID, spellId, amount, overkill, dstName, dstGUID);
		self:TrackSLDamageDoneToSpecificUnits(srcName, srcGUID, spellId, amount, overkill, dstName, dstGUID);
	end
	if (subEventName == "SWING_DAMAGE") then
		local amount, overkill, _, _, _, _, crit = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllDamageDoneToPartyMembers(dstName, -2, amount);
		self:TrackAllDamageDoneByPartyMembers(srcName, srcGUID, -2, amount, overkill, crit);
		self:TrackBfADamageDoneToSpecificUnits(srcName, srcGUID, -2, amount, overkill, dstName, dstGUID);
		self:TrackSLDamageDoneToSpecificUnits(srcName, srcGUID, -2, amount, overkill, dstName, dstGUID);
	end
	if (subEventName == "SPELL_EXTRA_ATTACKS") then
		local amount = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllDamageDoneToPartyMembers(dstName, -2, amount);
		self:TrackAllDamageDoneByPartyMembers(srcName, srcGUID, -2, amount, 0, false);
	end
	if (subEventPrefix:match("^SPELL") and
		subEventSuffix == "MISSED") then
		local spellId, _, _, _, _, amount = select(12, CombatLogGetCurrentEventInfo());
		self:TrackBfAAvoidableSpells(dstName, spellId, amount);
		self:TrackSLAvoidableSpells(dstName, spellId, amount);
		self:TrackAllDamageDoneToPartyMembers(dstName, spellId, amount);
	end
	if (subEventName == "SPELL_AURA_APPLIED" or
		subEventName == "SPELL_AURA_APPLIED_DOSE") then
		local spellId, _, _, auraType = select(12, CombatLogGetCurrentEventInfo());
		self:TrackAllAurasOnPartyMembers(dstName, spellId, auraType);
		self:TrackBfAAvoidableAuras(dstName, spellId);
		self:TrackSLAvoidableAuras(dstName, spellId);
		self:TrackBfASpecificBuffOrDebuffOnPartyMembers(dstName, spellId);
		self:TrackSLSpecificBuffOrDebuffOnPartyMembers(dstName, spellId);
		self:TrackBfASpecificBuffOrDebuffOnUnit(dstGUID, spellId);
		self:TrackSLSpecificBuffOrDebuffOnUnit(dstGUID, spellId);
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
	self:DebugPrint("CHALLENGE_MODE_START");
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
	for _, unitId in pairs(self:GetPartyRoster()) do
		self:UpdateUnitInfo(UnitGUID(unitId));
        local petUnitId = unitId .. "pet";
        if (UnitExists(petUnitId)) then
            self:TrackSummonnedByPartyMembersUnit(UnitName(unitId), UnitGUID(unitId), UnitName(petUnitId), UnitGUID(petUnitId));
            self:DebugPrint(string.format("%s is saved is pet for %s", UnitName(petUnitId) or petUnitId, UnitName(unitId) or unitId));
        end
	end
	NotifyInspect("player");
	for i = 1, 4 do
		self:ScheduleTimer(function()
			NotifyInspect("party" .. i);
		end, i * 2);
	end
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
		healthMod = healthMod
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
		self.db.char.challenges[id].details = self:ParseInfoFromDetailsAddon();
		self:LogPrint(string.format(L["%s +%s is completed"], self.db.char.challenges[id].challengeInfo.zoneName, self.db.char.challenges[id].challengeInfo.cmLevel));
		if (self.challengesTable) then
			self.challengesTable:SetData(self:ChallengesFrame_GetDataForTable());
		end
		if (self.db.char.challenges[id].mechanics["PARTY-MEMBERS-SUMMON"]) then
			wipe(self.db.char.challenges[id].mechanics["PARTY-MEMBERS-SUMMON"]); -- no sense to store hundreds of GUIDs
		end
		self.db.char.challenges[id].mechanics = self:Compress(self.db.char.challenges[id].mechanics);
	end
	self.db.char.activeChallengeId = nil;
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
	if (self:UpdateUnitInfo(guid)) then
		ClearInspectPlayer(guid);
	end
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
	local lastEncounterId = time();
	self.db.char.challenges[id].misc.lastEncounterId = lastEncounterId;
	self.db.char.challenges[id].encounters[lastEncounterId] = {
		id = encounterId,
		name = encounterName,
		startTime = time(),
		deathCountOnStart = C_ChallengeMode.GetDeathCount()
	};
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
	self.db.char.challenges[id].encounters[lastEncounterId].endTime = time();
	self.db.char.challenges[id].encounters[lastEncounterId].success = success;
	self.db.char.challenges[id].encounters[lastEncounterId].deathCountOnEnd = C_ChallengeMode.GetDeathCount();
	self.db.char.challenges[id].misc.lastEncounterId = nil;
	self:DebugPrint("ENCOUNTER_END", encounterId, encounterName, difficultyId, groupSize, success);
end
