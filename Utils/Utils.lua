local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
Convert number to K/M format
Examples:
  FormatNumber(1) -> 1
  FormatNumber(1234) -> 1.2K
  FormatNumber(1234567) -> 1.23M

@method MyDungeonsBook:FormatNumber
@param {number} n - number to format
@return {string} formatted string
]]
function MyDungeonsBook:FormatNumber(n)
	if (type(n) ~= "number") then
		return n;
	end
    if (n >= 10 ^ 6) then
        return string.format("%.2fM", n / 10^6);
    elseif (n >= 10 ^ 3) then
        return string.format("%.1fK", n / 10^3);
    else
        return tostring(n);
    end
end

--[[
@method MyDungeonsBook:RoundNumber
@param {number} n
@return number
]]
function MyDungeonsBook:RoundNumber(n)
	if (type(n) ~= "number") then
		return n;
	end
	return floor(n);
end

--[[
Print message with DEBUG prefix.
Mostly used for debugging. It can be disabled in the addon settings.

@method MyDungeonsBook:DebugPrint
@param {string} msg - message to output
]]
function MyDungeonsBook:DebugPrint(...)
	if (self.db.profile.verbose.debug) then
		self:Print("|c0070DEFF[DEBUG]|r", ...);
	end
end

--[[
Print message with LOG prefix.
Mostly used for debugging. It can be disabled in the addon settings.

@method MyDungeonsBook:LogPrint
@param {string} msg - message to output
]]
function MyDungeonsBook:LogPrint(...)
	if (self.db.profile.verbose.log) then
		self:Print("|c8787EDFF[LOG]|r", ...);
	end
end

--[[
Return string color with class-color of provided unit
If unit is not "classable", text is returned "as is"

@method MyDungeonsBook:ClassColorText
@param {unitId} unit - unitId to get its class color
@param {string} msg - message colorize
@return {string} colorized `msg`
]]
function MyDungeonsBook:ClassColorText(unit, text)
	if unit and UnitExists(unit) then
		local _, class = UnitClass(unit);
		if not class then
			return text;
		else
			local classData = RAID_CLASS_COLORS[class];
			local coloredText = ("|c%s%s|r"):format(classData.colorStr, text);
			return coloredText;
		end
	else
		return text;
	end
end

--[[
Colorize `text` to class color of `classIndex`

@method MyDungeonsBook:ClassColorTextByClassIndex
@param {number} classIndex - wow class identifier
@param {string} text - text to colorize
@return {string} colorized `text`
]]
function MyDungeonsBook:ClassColorTextByClassIndex(classIndex, text)
	local _, className = GetClassInfo(classIndex);
	if (className) then
		local classData = RAID_CLASS_COLORS[className];
		if (classData) then
			return ("|c%s%s|r"):format(classData.colorStr, text);
		end
		return text;
	end
	return text;
end

--[[
Get unitId for GUID that may be in the party or is current player

@method MyDungeonsBook:GetPartyUnitByGuid
@param {GUID} guid - GUID to check
@return {string} "player" or "party1..4" or nil
]]
function MyDungeonsBook:GetPartyUnitByGuid(guid)
	if (guid == UnitGUID("player")) then
		return "player";
	end
	for i = 1, 4 do
		if (guid == UnitGUID("party" .. i)) then
			return "party" .. i;
		end
	end
	return nil;
end

--[[
Get unitId for player with name `name` in the challenge with id `challengeId`

@method MyDungeonsBook:GetPartyUnitByName
@param {number} challengeId
@param {string} name
@return {unitId|nil}
]]
function MyDungeonsBook:GetPartyUnitByName(challengeId, name)
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		return nil;
	end
	for _, unit in pairs(self:GetPartyRoster()) do
		if (challenge.players[unit] and challenge.players[unit].name and strfind(string.lower(name), string.lower(challenge.players[unit].name))) then
			return unit;
		end
	end
	return nil;
end

--[[
@method MyDungeonsBook:GetKeyUpgradeStr
@param {table} challenge
@return string
]]
function MyDungeonsBook:GetKeyUpgradeStr(challenge)
	local result;
	if (challenge.challengeInfo.onTime) then
		result = string.format("|cff1eff00+%s|r", challenge.challengeInfo.keystoneUpgradeLevels);
	else
		result = "|cffcc3333-1|r";
	end
	return result;
end

--[[
Get a string with affixes icons for challenge with id `challengeId`
Width and height for icons are set by `iconSize`

@method MyDungeonsBook:GetChallengeAffixesIconsStr
@param {number} challengeId
@param {number} iconSize
@return {string} formatted string with icons for challenge affixes
]]
function MyDungeonsBook:GetChallengeAffixesIconsStr(challengeId, iconSize)
	local affixes = "";
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		self:DebugPrint(string.format("[GetChallengeAffixesIconsStr] Challenge #%s not found"), challengeId);
	end
	local iconFormatter = string.format(":%s:%s:0:0:64:64:5:59:5:59|t", iconSize, iconSize);
	if (challenge.challengeInfo.affixes) then
		for _, affixId in pairs(challenge.challengeInfo.affixes) do
			affixes = affixes .. " |T" .. self:GetAffixTextureById(affixId) .. iconFormatter;
		end
	end
	return affixes;
end

--[[
Get a string with a small role icon (19x19) for `role`

@method MyDungeonsBook:GetSmallRoleIcon
@param {string} role can be TANK, HEALER or DAMAGER
@return string
]]
function MyDungeonsBook:GetSmallRoleIcon(role)
	local roles = {
		TANK = "|A:groupfinder-icon-role-large-tank:19:19|a",
		HEALER = "|A:groupfinder-icon-role-large-heal:19:19|a",
		DAMAGER = "|A:groupfinder-icon-role-large-dps:19:19|a"
	};
	return roles[role] or "";
end

--[[
Get a string with unit role, name and realm colored with it's class
`nil` is returned  if there unitInfo is empty

@method MyDungeonsBook:GetUnitNameRealmRoleStr
@param {table} unitInfo
@return {string|nil}
]]
function MyDungeonsBook:GetUnitNameRealmRoleStr(unitInfo)
	if (unitInfo.name) then
		return self:ClassColorTextByClassIndex(unitInfo.class, string.format("%s %s\n%s", self:GetSmallRoleIcon(unitInfo.role), unitInfo.name, unitInfo.realm));
	end
	return nil;
end

--[[
Get an icon id for class with index `classIndex`

@method MyDungeonsBook:GetClassIconByIndex
@param {string} classIndex
@return {number}
]]
function MyDungeonsBook:GetClassIconByIndex(classIndex)
	local icons = {
		["DEMONHUNTER"] = 236415,
		["DRUID"] = 625999,
		["HUNTER"] = 626000,
		["MAGE"] = 626001,
		["MONK"] = 626002,
		["PALADIN"] = 626003,
		["PRIEST"] = 626004,
		["ROGUE"] = 626005,
		["SHAMAN"] = 626006,
		["WARLOCK"] = 626007,
		["WARRIOR"] = 626008,
		["DEATHKNIGHT"] = 135771
	};
	local _, class = GetClassInfo(classIndex);
	return icons[class];
end

--[[
Get a prefix for mechanics ("SL" or "BFA" etc)
TODO should check zone id and not game version?

@method MyDungeonsBook:GetMechanicsPrefixForChallenge
@param {number} challengeId
@return {string}
]]
function MyDungeonsBook:GetMechanicsPrefixForChallenge(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		return nil;
	end
	local version = challenge.gameInfo.version;
	local major = string.sub(version, 1, 1);
	if (major == "8") then
		return "BFA";
	end
	if (major == "9") then
		return "SL";
	end
	return nil;
end

--[[
Get a table with values equal to party unit ids - player, party1..4

@method MyDungeonsBook:GetPartyRoster
@return {table}
]]
function MyDungeonsBook:GetPartyRoster()
	return {"player", "party1", "party2", "party3", "party4"};
end

--[[
Get count down time delay on challenge start

Challenge's `startTime` is stored right after challenge start. However there is a countdown before "real" challenge timer starts.
Typically it's 9 seconds. It's possible to calculate it using `startTime`, `endTime` and `duration` (for already passed challenges).
If challenge is in progress or was abandonned, 9 seconds value is returned.

@method MyDungeonsBook:GetCountDownDelay
@param {number} challengeId
@return {number}
]]
function MyDungeonsBook:GetCountDownDelay(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		return nil;
	end
	local startTime = challenge.challengeInfo.startTime;
	local endTime = challenge.challengeInfo.endTime;
	local duration = challenge.challengeInfo.duration / 1000;
	if (not endTime) then
		return 9;
	end
	return endTime - startTime - duration;
end

--[[
Extracts Npc ID from units GUID
It doesn't check if it's realy npc etc - just trying to extract and convert to number

@method MyDungeonsBook:GetNpcIdFromGuid
@param {GUID} unitGUID
@return {number|nil}
]]
function MyDungeonsBook:GetNpcIdFromGuid(unitGUID)
	local _, _, _, _, _, npcId = strsplit("-", unitGUID);
	return tonumber(npcId);
end