--[[--
@module MyDungeonsBook
]]

--[[--
Challenge
@section Challenge
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Check if player is in challenge mode.

@return[type=bool]
]]
function MyDungeonsBook:IsInChallengeMode()
	local _, _, difficulty, _, _, _, _, _ = GetInstanceInfo();
	local _, elapsedTime = GetWorldElapsedTime(1);
	return C_ChallengeMode.IsChallengeModeActive() and difficulty == 8 and elapsedTime >= 0;
end

--[[--
Create a skeleton for a new dungeon challenge

@param[type=number] id identifier for new dungeon challenge
]]
function MyDungeonsBook:InitNewDungeonChallenge(id)
	self.db.char.challenges[id] = {
		id = id,
		challengeInfo = {},
		gameInfo = {},
		details = {
			exists = false,
			player = {},
			party1 = {},
			party2 = {},
			party3 = {},
			party4 = {}
		},
		encounters = {},
		players = {
			player = {},
			party1 = {},
			party2 = {},
			party3 = {},
			party4 = {}
		},
		mechanics = {},
		misc = {}
	};
	self:DebugPrint(string.format("New challenge is init with id %s", id));
end

--[[--
Parse info about player or any other party member (`unit`).

@param[type=unitId] unit
]]
function MyDungeonsBook:ParseUnitInfoWithWowApi(unit)
	if (not UnitExists(unit)) then
		return {};
	end
	local _, _, class = UnitClass(unit);
	local name, realm = UnitFullName(unit);
	local _, race = UnitRace(unit);
	local spec = GetInspectSpecialization(unit);
	local role = UnitGroupRolesAssigned(unit);
	if (not realm) then
		local _, myRealm = UnitFullName("player");
		realm = myRealm;
	end
	local items = {};
	for i = 1, 17 do
        local itemLink = GetInventoryItemLink(unit, i);
		items[i] = itemLink;
	end
	return {
		name = name,
		role = role,
		race = race,
		class = class,
		spec = spec,
		realm = realm,
		items = items,
		talents = {},
		misc = {}
	};
end

--[[--
Parse info from Details addon about all party members DPS, HPS etc.

**It must be called only when whole party is together (and anyone didn't leave it).**

@return[type=table] details for all party members
]]
function MyDungeonsBook:ParseInfoFromDetailsAddon()
	if(not IsAddOnLoaded("Details")) then
		self:LogPrint("Addon Details is not loaded!");
		return {exists = false};
	end
	local details = {
		exists = true
	};
	local combat = Details:GetCombat("overall");
	if (not combat) then
		self:LogPrint("Combat 'overall' not exists in the Details!");
		return {exists = false};
	end
	for _, unit in pairs(self:GetPartyRoster()) do
		local name, realm = UnitName(unit);
		local detailsUnitName = name;
		if (realm) then
			detailsUnitName = string.format("%s-%s", detailsUnitName, realm);
		end
		details[detailsUnitName] = self:ParseUnitInfoFromDetailsAddon(detailsUnitName or "NOT FOUND");
		self:DebugPrint(string.format("Details info for %s is saved", unit));
	end
	return details;
end

--[[--
Get info from Details addon for a single party member.

It can be called in any time while you didn't reset Details.

@param[type=string] detailsUnitName
@return[type=table] details for single a party member
]]
function MyDungeonsBook:ParseUnitInfoFromDetailsAddon(detailsUnitName)
	local details = {};
	local combat = Details:GetCombat("overall");
	local damageActor = combat:GetActor(DETAILS_ATTRIBUTE_DAMAGE, detailsUnitName);
		if (damageActor) then
			local totalDamage = (damageActor and damageActor.total) or 0;
			local activeDps, effectiveDps;
			if (totalDamage) then
				activeDps = totalDamage / combat:Tempo();
				effectiveDps = totalDamage / combat:GetCombatTime();
			else
				activeDps = "-";
				effectiveDps = "-";
			end
			details.totalDamage = totalDamage;
			details.activeDps = activeDps;
			details.effectiveDps = effectiveDps;
		else
			self:DebugPrint(string.format("%s actor not found for unit %s", "DAMAGE", detailsUnitName));
		end

		local healActor = combat:GetActor(DETAILS_ATTRIBUTE_HEAL, detailsUnitName);
		if (healActor) then
			local totalHeal = (healActor and healActor.total) or 0;
			local activeHps, effectiveHps;
			if (totalHeal) then
				activeHps = totalHeal / combat:Tempo();
				effectiveHps = totalHeal / combat:GetCombatTime();
			else
				activeHps = "-";
				effectiveHps = "-";
			end
			details.totalHeal = totalHeal;
			details.activeHps = activeHps;
			details.effectiveHps = effectiveHps;
		else
			self:DebugPrint(string.format("%s actor not found for unit %s", "HEAL", detailsUnitName));
		end

		local miscActor = combat:GetActor(DETAILS_ATTRIBUTE_MISC, detailsUnitName);
		if (miscActor) then
			local interrupt = miscActor.interrupt;
			local dispell = miscActor.dispell;
			details.interrupt = interrupt;
			details.dispell = dispell;
		else
			self:DebugPrint(string.format("%s actor not found for unit %s", "MISC", detailsUnitName));
		end
		return details;
end

--[[--
@param[type=GUID] guid
]]
function MyDungeonsBook:UpdateUnitInfo(guid)
	local id = self.db.char.activeChallengeId;
	if (not id) then
		return false;
	end
	local unit = self:GetPartyUnitByGuid(guid);
	if (not unit) then
		self:DebugPrint(string.format("Unit with guid %s not found", guid));
		return false;
	end
	local unitInfo = self:ParseUnitInfoWithWowApi(unit);
	self.db.char.challenges[id].players[unit] = self:MergeTables(self.db.char.challenges[id].players[unit], unitInfo);
	self:DebugPrint(string.format("Info about %s is stored", unit));
	return true;
end

--[[--
Delete info about challenge from local DB

@param[type=number] challengeId
]]
function MyDungeonsBook:Challenge_Delete(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		if (self.activeChallengeId == challengeId) then
			self.activeChallengeId = nil;
			self.challengeDetailsFrame.frame:Hide();
		end
		wipe(self.db.char.challenges[challengeId]);
		if (self.challengesTable) then
			self.challengesTable:SetData(self:ChallengesFrame_GetDataForTable());
		end
		self:LogPrint(string.format(L["Challenge #%s is deleted successfully"], challengeId));
	end
end
