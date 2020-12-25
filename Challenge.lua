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
	if (spec == 0) then
		spec = nil;
	end
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
	local unitInfo = {
		name = name,
		role = role,
		race = race,
		class = class,
		spec = spec,
		realm = realm,
		items = items,
		talents = {},
		misc = {},
		covenant = {}
	};
	if (unit == "player") then
		local covenantId = C_Covenants.GetActiveCovenantID();
		local activeSoulbindId = C_Soulbinds.GetActiveSoulbindID();
		local activeSoulbindData = C_Soulbinds.GetSoulbindData(activeSoulbindId);
		local conduits = {};
		for _, conduit in pairs(activeSoulbindData.tree.nodes) do
			if (conduit.failureRenownRequirement == nil and conduit.state == 3) then
				tinsert(conduits, conduit);
			end
		end
		unitInfo.covenant.id = covenantId;
		unitInfo.covenant.soulbind = {
			id = activeSoulbindId,
			name = activeSoulbindData.name,
			textureKit = activeSoulbindData.textureKit,
			conduits = conduits
		};
	end
	return unitInfo;
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

--[[--
@param[type=number] id
@return[type=?table]
]]
function MyDungeonsBook:Challenge_GetById(id)
	if (not id) then
		id = self.db.char.activeChallengeId;
	end
	return self.db.char.challenges[id];
end

--[[--
@param[type=number] challengeId
@param[type=string] mechanicKey
@return[type=?table]
]]
function MyDungeonsBook:Challenge_Mechanic_GetById(challengeId, mechanicKey)
	local challenge = self:Challenge_GetById(challengeId);
	if (not challenge) then
		return nil;
	end
	if (challengeId == self.activeChallengeId) then
		if (not self.activeChallengeMechanics) then
			self.activeChallengeMechanics = challenge.mechanics;
			if (type(challenge.mechanics) ~= "table") then
				self.activeChallengeMechanics = select(2, self:Decompress(challenge.mechanics));
			end
		end
		return self.activeChallengeMechanics[mechanicKey];
	end
	local mechanics = challenge.mechanics;
	if (type(challenge.mechanics) ~= "table") then
		mechanics = select(2, self:Decompress(challenge.mechanics));
	end
	return mechanics[mechanicKey];
end
