local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
Check combat events while player is in challenge

@event COMBAT_LOG_EVENT_UNFILTERED
]]
function MyDungeonsBook:COMBAT_LOG_EVENT_UNFILTERED()
	if (self.db.char.activeChallengeId) then
		local timestamp, subEventName, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, dstGUID, dstName, dstFlags, dstFlags2 = CombatLogGetCurrentEventInfo();
		local subEventPrefix, subEventSuffix = subEventName:match("^(.-)_?([^_]*)$");
		self:TrackBfAUnitsAppearsInCombat(srcGUID, dstGUID);
		self:TrackSLUnitsAppearsInCombat(srcGUID, dstGUID);
		if (subEventName == "UNIT_DIED") then
			self:TrackDeath(dstGUID, dstName);
		end
		if (subEventSuffix == "HEAL") then
		end
		if (subEventSuffix == "INTERRUPT") then
			local spellId, _, _, extraSpellId = select(12, CombatLogGetCurrentEventInfo());
			self:TrackInterrupt(srcName, srcGUID, spellId, extraSpellId);
		end
		if (subEventName == "SPELL_CAST_SUCCESS") then
			local spellId = select(12, CombatLogGetCurrentEventInfo());
			self:TrackTryInterrupt(spellId, srcGUID, srcName);
			self:TrackSLPassedCasts(srcName, spellId);
			self:TrackBfAPassedCasts(srcName, spellId);
			self:TrackAllEnemiesPassedCasts(srcName, srcGUID, spellId);
			self:TrackBfASpecificCastDoneByPartyMembers(srcName, spellId);
			self:TrackSLSpecificCastDoneByPartyMembers(srcName, spellId);
		end
		if ((subEventPrefix:match("^SPELL") or subEventPrefix:match("^RANGE")) and subEventSuffix == "DAMAGE") then
			local spellId, _, _, amount, overkill = select(12, CombatLogGetCurrentEventInfo());
			self:TrackBfAAvoidableSpells(dstName, spellId, amount);
			self:TrackSLAvoidableSpells(dstName, spellId, amount);
			self:TrackBfADamageDoneToSpecificUnits(srcName, srcGUID, spellId, amount, overkill, dstName, dstGUID);
			self:TrackSLDamageDoneToSpecificUnits(srcName, srcGUID, spellId, amount, overkill, dstName, dstGUID);
		end
		if (subEventPrefix:match("^SPELL") and subEventSuffix == "MISSED") then
			local spellId, _, _, _, _, amount = select(12, CombatLogGetCurrentEventInfo());
			self:TrackBfAAvoidableSpells(dstName, spellId, amount);
			self:TrackSLAvoidableSpells(dstName, spellId, amount);
		end
		if (subEventName == "SPELL_AURA_APPLIED" or subEventName == "SPELL_AURA_APPLIED_DOSE") then
			local spellId = select(12, CombatLogGetCurrentEventInfo());
			self:TrackBfAAvoidableAuras(dstName, spellId);
			self:TrackSLAvoidableAuras(dstName, spellId);
			self:TrackBfASpecificBuffOrDebuffOnPartyMembers(dstName, spellId);
			self:TrackSLSpecificBuffOrDebuffOnPartyMembers(dstName, spellId);
			self:TrackBfASpecificBuffOrDebuffOnUnit(dstGUID, spellId);
			self:TrackSLSpecificBuffOrDebuffOnUnit(dstGUID, spellId);
		end
	end
end

--[[
Save info about started challenge to the db:
 * key level
 * affixes
 * time
 * zone name and its id
 * map id
 * team roster - name, race, class, spec, realm, items

@event CHALLENGE_MODE_START
]]
function MyDungeonsBook:CHALLENGE_MODE_START()
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
		affixesKey = affixesKey .. "-" .. k;
	end

	self:DebugPrint(string.format("affixesKey is %s", affixesKey));

	self.db.char.challenges[id].players.player = self:ParseUnitInfo("player");
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
		self.challengesTable:SetData(self:GetChallengesTableData());
	end
	self:LogPrint(string.format(L["%s +%s is started"], zoneName, cmLevel));
end

--[[
Mark active challenge as completed

@event CHALLENGE_MODE_RESET
]]
function MyDungeonsBook:CHALLENGE_MODE_RESET()
	local id = self.db.char.activeChallengeId;
	if (self.db.char.challenges[id]) then
		self.db.char.challenges[id].endTime = time();
		self:LogPrint(string.format(L["%s +%s is reset"], self.db.char.challenges[id].challengeInfo.zoneName, self.db.char.challenges[id].challengeInfo.cmLevel));
	end
	self.db.char.activeChallengeId = nil;
end

--[[
Mark active challenge as completed and store additional info about it:

* Info from Details addon
* time lost by deaths
* key level upgrade
* challenge duration

@event CHALLENGE_MODE_COMPLETED
]]
function MyDungeonsBook:CHALLENGE_MODE_COMPLETED()
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
			self.challengesTable:SetData(self:GetChallengesTableData());
		end
	end
	self.db.char.activeChallengeId = nil;
end

--[[
Reset `activeChallengeId` on load if player is not in challenge

@event PLAYER_ENTERING_WORLD
]]
function MyDungeonsBook:PLAYER_ENTERING_WORLD()
	if (not self:IsInChallengeMode()) then
		self.db.char.activeChallengeId = nil;
	end
end

--[[
Parse info about party member if it'ready
Its request is sent in the `MyDungeonsBook:CHALLENGE_MODE_START`

@event INSPECT_READY
@param {string} _ - "INSPECT_READY"
@param {GUID} guid of needed unit
]]
function MyDungeonsBook:INSPECT_READY(_, guid)
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return;
	end
	local unit = self:GetPartyUnitByGuid(guid);
	if (not unit) then
		self:DebugPrint(string.format("Unit with guid %s not found", guid));
		return;
	end
	local unitInfo = self:ParseUnitInfo(unit);
	self.db.char.challenges[id].players[unit] = unitInfo;
	self:DebugPrint(string.format("Info about %s is stored", unit));
	ClearInspectPlayer(guid);
end

--[[
Get info for each encounter when it's started

Encounters have unique IDs, however encounters can be ended not successfully (e.g. boss is not killed and team is dead) and can be restarted.
So, only last try will be saved (typically it should be successful try).

Each encounter has next fields:

* id - encounter id
* name - encounter name (usually, name of the boss)
* startTime - timestamp, when encounter is started
* deathCountOnStart - number of deaths when encounter starts
* endTime - timestamp, when encounter is ended (it's set in the `MyDungeonsBook:ENCOUNTER_END`)
* deathCountOnEnd - number of deaths when encounter ends (it's set in the `MyDungeonsBook:ENCOUNTER_END`)
* success - was encounter passed or not (it's set in the `MyDungeonsBook:ENCOUNTER_END`)

@method MyDungeonsBook:ENCOUNTER_START
@param {string} _ - "ENCOUNTER_START"
@param {number} encounterId
@param {string} encounterName
]]
function MyDungeonsBook:ENCOUNTER_START(_, encounterId, encounterName, ...)
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return;
	end
	if (not self.db.char.challenges[id]) then
		return;
	end
	self.db.char.challenges[id].encounters[encounterId] = {
		id = encounterId,
		name = encounterName,
		startTime = time(),
		deathCountOnStart = C_ChallengeMode.GetDeathCount()
	};
	self:DebugPrint("ENCOUNTER_START", encounterId, encounterName);
end

--[[
Get additional info (endTime, deathCountOnEnd, success) about each encounter when it's ended

@method MyDungeonsBook:ENCOUNTER_END
@param {string} _ - "ENCOUNTER_END"
@param {number} encounterId
@param {string} encounterName
@param {number} difficultyId
@param {number} groupSize
@param {bool?} success
]]
function MyDungeonsBook:ENCOUNTER_END(_, encounterId, encounterName, difficultyId, groupSize, success)
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return;
	end
	if (not self.db.char.challenges[id]) then
		return;
	end
	self.db.char.challenges[id].encounters[encounterId].endTime = time();
	self.db.char.challenges[id].encounters[encounterId].success = success;
	self.db.char.challenges[id].encounters[encounterId].deathCountOnEnd = C_ChallengeMode.GetDeathCount();
	self:DebugPrint("ENCOUNTER_END", encounterId, encounterName, difficultyId, groupSize, success);
end
