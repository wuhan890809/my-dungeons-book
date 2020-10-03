local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local affixesMap = {
	[1] = 463570, -- Overflowing
	[2] = 135994, -- Skittish
	[3] = 451169, -- Volcanic
	[4] = 1029009, -- Necrotic
	[5] = 136054, -- Teeming
	[6] = 132345, -- Raging
	[7] = 132333, -- Bolstering
	[8] = 136124, -- Sanguine
	[9] = 236401, -- Tyrannical
	[10] = 463829, -- Fortified
	[11] = 1035055, -- Bursting
	[12] = 132090, -- Grievous
	[13] = 2175503, -- Explosive
	[14] = 136025, -- Quaking
	[15] = 132739, -- Relentless
	[16] = 2032223, -- Infested
	[117] = 2446016, -- Reaping
	[119] = 237565, -- Beguiling
	[120] = 442737, -- Awakened
};

--[[
Get texture for affix's icon.
It can be used in the strings like `"|T%%%:20:20:0:0:64:64:5:59:5:59|t"`, where %%% is a result if `MyDungeonsBook:GetAffixTextureById(affixId)`

@method MyDungeonsBook:GetAffixTextureById
@param {number} affixId - myth+ affix identifier
@return {number} texture id for affix's icon
]]
function MyDungeonsBook:GetAffixTextureById(affixId)
	return affixesMap[affixId];
end

--[[
Check if player is in challenge mode

@method MyDungeonsBook:IsInChallengeMode
@return {bool}
]]
function MyDungeonsBook:IsInChallengeMode()
	local _, _, difficulty, _, _, _, _, _ = GetInstanceInfo();
	local _, elapsedTime = GetWorldElapsedTime(1);
	return C_ChallengeMode.IsChallengeModeActive() and difficulty == 8 and elapsedTime >= 0;
end

--[[
Create a skeleton for a new dungeon challenge

@method MyDungeonsBook:InitNewDungeonChallenge
@param {number} id - identifier for new dungeon challenge
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
		deaths = {},
		mechanics = {},
		misc = {}
	};
	self:DebugPrint(string.format("New challenge is init with id %s", id));
end

--[[
Parse info about player or any other party member (`unit`)

@method MyDungeonsBook:ParseUnitInfo
@param {unitId} unit
]]
function MyDungeonsBook:ParseUnitInfo(unit)
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

--[[
@method MyDungeonsBook:InitMechanics4Lvl
@param {string|number} first
@param {bool} asCounter
]]
function MyDungeonsBook:InitMechanics1Lvl(first, asCounter)
	local id = self.db.char.activeChallengeId;
	if (not self.db.char.challenges[id].mechanics[first]) then
		self.db.char.challenges[id].mechanics[first] = (asCounter and 0) or {};
	end
end

--[[
@method MyDungeonsBook:InitMechanics4Lvl
@param {string|number} first
@param {string|number} second
@param {bool} asCounter
]]
function MyDungeonsBook:InitMechanics2Lvl(first, second, asCounter)
	local id = self.db.char.activeChallengeId;
	self:InitMechanics1Lvl(first);
	if (not self.db.char.challenges[id].mechanics[first][second]) then
		self.db.char.challenges[id].mechanics[first][second] = (asCounter and 0) or {};
	end
end

--[[
@method MyDungeonsBook:InitMechanics4Lvl
@param {string|number} first
@param {string|number} second
@param {string|number} third
@param {bool} asCounter
]]
function MyDungeonsBook:InitMechanics3Lvl(first, second, third, asCounter)
	local id = self.db.char.activeChallengeId;
	self:InitMechanics2Lvl(first, second, false);
	if (not self.db.char.challenges[id].mechanicss[first][second][third]) then
		self.db.char.challenges[id].mechanicss[first][second][third] = (asCounter and 0) or {};
	end
end

--[[
@method MyDungeonsBook:InitMechanics4Lvl
@param {string|number} first
@param {string|number} second
@param {string|number} third
@param {string|number} fourth
@param {bool} asCounter
]]
function MyDungeonsBook:InitMechanics4Lvl(first, second, third, fourth, asCounter)
	local id = self.db.char.activeChallengeId;
	self:InitMechanics3Lvl(first, second, third, false);
	if (not self.db.char.challenges[id].mechanics[first][second][third][fourth]) then
		self.db.char.challenges[id].mechanics[first][second][third][fourth] = (asCounter and 0) or {};
	end
end

--[[
Parse info from Details addon about party members DPS, HPS etc

@method MyDungeonsBook:ParseInfoFromDetailsAddon
@return {table} details
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
			detailsUnitName = detailsUnitName .. "-"..realm;
		end
		details[unit] = self:ParseUnitInfoFromDetailsAddon(detailsUnitName or "NOT FOUND");
		self:DebugPrint(string.format("Details info for %s is saved", unit));
	end
	return details;
end

--[[
Get info from Details addon for a single player

@method MyDungeonsBook:ParseUnitInfoFromDetailsAddon
@param {string} detailsUnitName
@return {table}
]]
function MyDungeonsBook:ParseUnitInfoFromDetailsAddon(detailsUnitName)
	details = {};
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