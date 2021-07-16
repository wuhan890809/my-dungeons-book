--[[--
@module MyDungeonsBook
]]

--[[--
Utils
@section Utils
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local itemTooltipFrame = CreateFrame("GameTooltip", "MyDungeonsBookItemTooltip", nil, "GameTooltipTemplate");
itemTooltipFrame:SetOwner(WorldFrame, "ANCHOR_NONE");

local statsMessages = {
	crit = { L["%+(%d+) Critical Strike"], L["%+(%d+) Critical Strike (Gem)"] },
	haste = { L["%+(%d+) Haste"], L["%+(%d+) Haste (Gem)"] },
	mastery = { L["%+(%d+) Mastery"], L["%+(%d+) Mastery (Gem)"] },
	vers = { L["%+(%d+) Versatility"], L["%+(%d+) Versatility (Gem)"] },
};

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
	[122] = 135946, -- Inspiring
	[123] = 135945, -- Spiteful
	[124] = 136018, -- Storming
	[121] = 3528307, -- Prideful,
	[128] = 3528304, -- Tormented
};

local targetIconsMap = {
	[1] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1.blp:0|t",
	[2] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2.blp:0|t",
	[3] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3.blp:0|t",
	[4] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4.blp:0|t",
	[5] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5.blp:0|t",
	[6] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6.blp:0|t",
	[7] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7.blp:0|t",
	[8] = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8.blp:0|t",
};

local argoStatusesMap = {
    L["Not tanking anything, but have higher threat than tank on at least one unit"],
    L["Insecurely tanking at least one unit, but not securely tanking anything"],
    L["Securely tanking at least one unit"]
};

--[[--
Get texture for affix's icon (question mark is returned if no affix icon found).

It can be used in the strings like `"|T%%%:20:20:0:0:64:64:5:59:5:59|t"`, where `%%%` is a result of `MyDungeonsBook:GetAffixTextureById`.

@param[type=number] affixId myth+ affix identifier
@return[type=number] texture id for affix's icon
]]
function MyDungeonsBook:GetAffixTextureById(affixId)
	return affixesMap[affixId] or 134400;
end

--[[--
@param[type=number] dec
@return[type=string]
]]
function MyDungeonsBook:DecToHex(dec)
	if (dec == 0) then
		return "00";
	end
	return string.format("%x", dec * 255);
end

--[[--
@param[type=number]
@return[type=string]
]]
function MyDungeonsBook:GetArgoStatus(argoLevel)
    return argoStatusesMap[argoLevel] or L["Not tanking anything"];
end

--[[--
Convert number to K/M format.

@usage
FormatNumber(1); -- 1
FormatNumber(1234); -- 1.2K
FormatNumber(1234567); -- 1.23M

@param[type=number] n number to format
@return[type=string] formatted string
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
        return string.format("%.0f", n);
	end
	return n;
end

--[[--
Format Creature/Vehicle GUID

Param `format` determines format of GUID to display:
 * "SHORT" - only last part is shown
 * "MED" - NPC id and last part are shown
 * "FULL" - GUID is shown "as is"

@param[type=GUID] guid
@param[type=string] format
@return[type=string]
]]
function MyDungeonsBook:FormatGuid(guid, format)
	if (not guid) then
		return "";
	end
	local _, _, _, _, _, npcId, indx = strsplit("-", guid);
	if (not npcId) then
		return "";
	end
	if (format == "MED") then
		return string.format("%s-%s", npcId, indx);
	end
	if (format == "SHORT") then
		return indx;
	end
	return guid;
end

--[[--
Type-safe function to round (floor) a number.

@param[type=number] n
@return[type=number]
]]
function MyDungeonsBook:RoundNumber(n)
	if (type(n) ~= "number") then
		return n;
	end
	return floor(n);
end

--[[--
@param[type=number] n number to format
@return[type=string] formatted string
]]
function MyDungeonsBook:FormatPercents(n)
	if (type(n) ~= "number") then
		return n;
	end
	return string.format("%.2f", n);
end

--[[--
Format seconds as date string

@param[type=number] seconds
@return[type=string]
]]
function MyDungeonsBook:FormatDate(seconds)
	local dateFormat = self.db.profile.display.dateFormat;
	return seconds and date(dateFormat, seconds) or seconds;
end

--[[--
Format milliseconds as time string

@param[type=number] milliseconds
@return[type=string]
]]
function MyDungeonsBook:FormatTime(milliseconds)
	local timeFormat = self.db.profile.display.timeFormat;
	local time = milliseconds / 1000;
	if (time > 3600) then
		local separator = (strfind(timeFormat, ":") and ":") or "-";
		return date("%S", math.floor(time / 3600 + 0.5)) .. separator .. date(timeFormat, time % 3600);
	end
	return date(timeFormat, time);
end

--[[--
Print message with DEBUG prefix.
Mostly used for debugging (and it's used a lot). It can be disabled in the addon settings.

@param[type=string] msg message to output
]]
function MyDungeonsBook:DebugPrint(...)
	if (self.db.profile.verbose.debug) then
		self:Print("|c0070DEFF[DEBUG]|r", ...);
	end
end

--[[--
Print message with LOG prefix.
Mostly used for debugging. It can be disabled in the addon settings.

@param[type=string] msg message to output
]]
function MyDungeonsBook:LogPrint(...)
	if (self.db.profile.verbose.log) then
		self:Print("|c8787EDFF[LOG]|r", ...);
	end
end

--[[--
Return string colored with class-color of provided unit
If unit is not "classable", text is returned "as is"

@param[type=unitId] unit unitId to get its class color
@param[type=string] text message to colorize
@return[type=string] colorized `msg`
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

--[[--
Colorize `text` to class color of `classIndex`

@param[type=number]classIndex wow class identifier
@param[type=string] text text to colorize
@return[type=string] colorized `text`
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

--[[--
Replace color-wrapper from string

String is returned "as is" if it's not colorized

Input: `|caabbcc00test|r`
Output: `test`

@param[type=string]
@return[type=string]
]]
function MyDungeonsBook:DecolorizeString(str)
	if (type(str) ~= "string") then
		return str;
	end
	local msgWithColor = str:match("|c(.*)|r");
	return (msgWithColor and msgWithColor:sub(9)) or str;
end

--[[--
Get unitId for GUID that may be in the party or is current player

@param[type=GUID] guid GUID to check
@return[type=?string] "player" or "party1..4" or nil
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

--[[--
Get unitId for player with name `name` in the challenge with id `challengeId`

@param[type=number] challengeId
@param[typestring] name
@return[type=?unitId]
]]
function MyDungeonsBook:GetPartyUnitByName(challengeId, name)
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		return nil;
	end
	if (not name) then
		return nil;
	end
	for _, unit in pairs(self:GetPartyRoster()) do
		if (challenge.players[unit] and challenge.players[unit].name and strfind(string.lower(name), string.lower(challenge.players[unit].name))) then
			return unit;
		end
	end
	return nil;
end

--[[--
Get a unit's name (with and without realm) for unit `unitId` in the challenge with id `challengeId`

@param[type=number] challengeId
@param[unitId] unitId
@return[type=string] just a name
@return[type=string] name with realm (if realm available)
]]
function MyDungeonsBook:GetNameByPartyUnit(challengeId, unitId)
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		return nil, nil;
	end
	local name = challenge.players[unitId].name or "";
	local realm = challenge.players[unitId].realm;
	return name, (realm and string.format("%s-%s", name, realm)) or name;
end

--[[--
Create a colored string with key update level.

It can be "-1" (red), "+1" (green), "+2" (green) or "+3" (green).

@param[type=table] challenge
@return[type=string]
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

--[[--
Get a string with affixes icons for challenge with id `challengeId`.

Width and height for icons are set by `iconSize`.

@param[type=number] challengeId
@param[type=number] iconSize
@return[type=string] formatted string with icons for challenge affixes
]]
function MyDungeonsBook:GetChallengeAffixesIconsStr(challengeId, iconSize)
	local affixes = "";
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		self:DebugPrint(string.format("[GetChallengeAffixesIconsStr] Challenge #%s not found"), challengeId);
	end
	local suffix = self:GetIconTextureSuffix(iconSize);
	if (challenge.challengeInfo.affixes) then
		for _, affixId in pairs(challenge.challengeInfo.affixes) do
			affixes = string.format("%s |T%s%s|t", affixes, self:GetAffixTextureById(affixId), suffix);
		end
	end
	return affixes;
end

--[[--
Get a string with a small role icon (19x19) for `role`.

@param[type=string] role can be `TANK`, `HEALER` or `DAMAGER`
@return[type=string]
]]
function MyDungeonsBook:GetSmallRoleIcon(role)
	local roles = {
		TANK = "|A:groupfinder-icon-role-large-tank:19:19|a",
		HEALER = "|A:groupfinder-icon-role-large-heal:19:19|a",
		DAMAGER = "|A:groupfinder-icon-role-large-dps:19:19|a"
	};
	return roles[role] or "";
end

--[[--
Get a string with unit role, name and realm colored with it's class.

`nil` is returned  if `unitInfo` is empty.

@param[type=table] unitInfo
@return[type=?string]
]]
function MyDungeonsBook:GetUnitNameRealmRoleStr(unitInfo)
	if (unitInfo.name) then
		return self:ClassColorTextByClassIndex(unitInfo.class, string.format("%s %s - %s", self:GetSmallRoleIcon(unitInfo.role or ""), unitInfo.name or "", unitInfo.realm or ""));
	end
	return nil;
end

--[[--
Get a string with unit role and name colored with it's class.

`nil` is returned  if `unitInfo` is empty.

@param[type=table] unitInfo
@return[type=?string]
]]
function MyDungeonsBook:GetUnitNameRoleStr(unitInfo)
	if (unitInfo.name) then
		return self:ClassColorTextByClassIndex(unitInfo.class, string.format("%s %s", self:GetSmallRoleIcon(unitInfo.role or ""), unitInfo.name or ""));
	end
	return nil;
end

--[[--
Get an icon id for class with index `classIndex`.

@param[type=string] classIndex
@return[type=number]
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

--[[--
Get a prefix for mechanics (`SL` or `BFA` etc).

TODO should check zone id and not game version?

@param[type=number] challengeId
@return[type=string]
]]
function MyDungeonsBook:GetMechanicsPrefixForChallenge(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		return nil;
	end
	local version = challenge.gameInfo.version;
	local major = string.sub(version, 1, 1);
	if (major == "8" or version == "9.0.1") then
		return "BFA";
	end
	if (major == "9") then
		return "SL";
	end
	return nil;
end

--[[--
Get a table with values equal to party unit ids - `player`, `party1..4`

@return[type=table]
]]
function MyDungeonsBook:GetPartyRoster()
	return {"player", "party1", "party2", "party3", "party4"};
end

--[[--
Get count down time delay on challenge start.

Challenge's `startTime` is stored right after challenge start. However there is a countdown before "real" challenge timer starts.
Typically it's 9 seconds. It's possible to calculate it using `startTime`, `endTime` and `duration` (for already passed challenges).
If challenge is in progress or was abandoned, 9 seconds value is returned.

@param[type=number] challengeId
@return[type=number]
]]
function MyDungeonsBook:GetCountDownDelay(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge) then
		return nil;
	end
	local startTime = challenge.challengeInfo.startTime;
	local endTime = challenge.challengeInfo.endTime;
	local duration = (challenge.challengeInfo.duration or 0) / 1000;
	if (not endTime) then
		return 9;
	end
	return endTime - startTime - duration;
end

--[[--
Extracts Npc ID from units GUID.

It doesn't check if it's realy npc etc - just trying to extract and convert to number.

@param[type=GUID] unitGUID
@return[type=?number]
]]
function MyDungeonsBook:GetNpcIdFromGuid(unitGUID)
	local _, _, _, _, _, npcId = strsplit("-", unitGUID);
	return tonumber(npcId);
end

local function mergeInternal(t1, key, value)
	if (type(value) == "table") then
		if (type(t1[key]) ~= "table") then
			t1[key] = {};
		end
		for k, v in pairs(value) do
			t1[key][k] = mergeInternal(t1[key], k, v);
		end
	else
		if (not t1[key]) then
			t1[key] = value;
		end
	end
	return t1[key];
end

--[[--
Recursively merge values from `table2` to `table1`. Values in `table1` won't be overridden if they are already exists.

@param[type=table] table1
@param[type=table] table2
@return[type=table] updated `table1`
]]
function MyDungeonsBook:MergeTables(table1, table2)
	if (type(table2) ~= "table") then
		return table1;
	end
	if (type(table1) ~= "table") then
		return table2;
	end
	for k, v in pairs(table2) do
		table1[k] = mergeInternal(table1, k, v);
	end
	return table1;
end

--[[--
@param[type=number] size
]]
function MyDungeonsBook:GetIconTextureSuffix(size)
	if (self.db.profile.display.flattenIcons) then
		return string.format(":%s:%s:0:0:64:64:5:59:5:59", size, size);
	end
	return string.format(":%s:%s:0:0:64:64:0:64:0:64", size, size);
end

--[[--
Check if value exists in the table

@param[type=table] tbl
@param[type=string|number|bool] value
]]
function MyDungeonsBook:TableContainsValue(tbl, value)
	for _, v in pairs(tbl) do
		if (v == value) then
			return true;
		end
	end
	return false;
end

--[[--
Get a value from nested table without throwing an error if some needed subtable is `nil`

@usage
MyDungeonsBook:SafeNestedGet({a = {b = {c = 1}}}, "a", "b", "c");
@local
@param[type=table]
@return[type=*|nil]
]]
function MyDungeonsBook:SafeNestedGet(tbl, ...)
	if (type(tbl) ~= "table") then
		return nil;
	end
	local val = tbl;
	for _, key in pairs({...}) do
		if (type(val) ~= "table" or val[key] == nil) then
			return nil;
		else
			val = val[key];
		end
	end
	return val;
end

--[[--
@usage
local = tbl = {a = {b = {c = 1}}};
MyDungeonsBook:SafeNestedNumberModify(tbl, 1, "a", "b", "c");

@local
]]
function MyDungeonsBook:SafeNestedNumberModify(tbl, num, ...)
	if (not self:SafeNestedGet(tbl, ...)) then
		return;
	end
	local n = select('#', ...);
	local lastKey = select(n, ...);
	local lastTable = self:SafeNestedGet(tbl, unpack({...}, 1, n - 1));
	if (lastTable) then
		if (type(lastTable[lastKey]) == "number") then
			lastTable[lastKey] = lastTable[lastKey] + (num or 0);
		end
	end
end

--[[--
@param[type=string]
@return[type=?string]
]]
function MyDungeonsBook:GetColorFor(key)
	local colors = {
		["BOSS"] = {
			r = 255, g = 209, b = 0, a = 1
		},
		["MOB"] = {
			r = 0, g = 132, b = 103, a = 1
		},
		["AFFIX"] = {
			r = 64, g = 191, b = 64, a = 1
		},
		["ADD"] = {
			r = 0, g = 100, b = 0, a = 1
		}
	};
	return colors[key];
end

local covenantIconsMap = {
	[0] = 134400,
	[1] = 3257748,
	[2] = 3257751,
	[3] = 3257750,
	[4] = 3257749,
};

--[[--
Get an icon for covenant with id `covenantId`

@param[type=number] covenantId (0-4)
@return[type=number]
]]
function MyDungeonsBook:GetCovenantIconId(covenantId)
	return covenantIconsMap[covenantId];
end

--[[--
from https://gist.github.com/tylerneylon/81333721109155b2d244
]]
function MyDungeonsBook:CopyTable(obj)
	if (type(obj) ~= "table") then
		return obj;
	end
	local res = {};
	for k, v in pairs(obj) do
		res[self:CopyTable(k)] = self:CopyTable(v);
	end
	return res;
end

--[[--
Get item level using game tooltip

`GetItemInfo` sometimes return invalid item level

@param[type=string] itemStringOrLink
@return[type=?number] item level
]]
function MyDungeonsBook:GetItemLevelFromTooltip(itemStringOrLink)
	itemTooltipFrame:SetHyperlink(itemStringOrLink);
	local line2 = _G["MyDungeonsBookItemTooltipTextLeft2"] and _G["MyDungeonsBookItemTooltipTextLeft2"]:GetText() or "";
	local line2Number = line2 and string.match(line2, "%d+");
	local line3 = _G["MyDungeonsBookItemTooltipTextLeft3"] and _G["MyDungeonsBookItemTooltipTextLeft3"]:GetText() or "";
	local line3Number = line3 and string.match(line3, "%d+");
	if (line2Number ~= nil) then
		line2Number = tonumber(line2Number);
		if (line2Number > 35) then
			return line2Number;
		end
	end
	if (line3Number ~= nil) then
		line3Number = tonumber(line3Number);
		if (line3Number > 35) then
			return line3Number;
		end
	end
end

--[[--
@param[type=string] itemStringOrLink
@return[type=number] gemsCount
]]
function MyDungeonsBook:GetItemGemsCount(itemStringOrLink)
	local _, _, _, gem1, gem2, gem3, gem4 = strsplit(":", itemStringOrLink, 15);
	local gemsCount = 0;
	if (gem1 and gem1 ~= "") then
		gemsCount = gemsCount + 1;
	end
	if (gem2 and gem2 ~= "") then
		gemsCount = gemsCount + 1;
	end
	if (gem3 and gem3 ~= "") then
		gemsCount = gemsCount + 1;
	end
	if (gem4 and gem4 ~= "") then
		gemsCount = gemsCount + 1;
	end
	return gemsCount;
end

--[[--
Get raid-icon by index

Empty string for missing index

@param[type=number] index
@return[type=string]
]]
function MyDungeonsBook:GetTargetIconByIndex(index)
	return targetIconsMap[index] or "";
end

--[[--
Parse item string to get secondary stat bonuses

@param[type=string]
@return[type=table]
]]
function MyDungeonsBook:GetItemSecondaryStatsBonus(itemStringOrLink)
	local stats = {
		crit = 0,
		haste = 0,
		mastery = 0,
		vers = 0
	};
	itemTooltipFrame:SetHyperlink(itemStringOrLink);
	for i = 2, itemTooltipFrame:NumLines() do
		local line = _G["MyDungeonsBookItemTooltipTextLeft" .. i]:GetText();
		if (line and line ~= "") then
			line = self:DecolorizeString(line);
			for stat, messages in pairs(statsMessages) do
				for _, message in pairs(messages) do
					local foundStatBonus = line:match(message);
					if (foundStatBonus) then
						stats[stat] = stats[stat] + tonumber(foundStatBonus);
					end
				end
			end
		end
	end
	return stats;
end

--[[--
Can be used for both spells and auras
]]
function MyDungeonsBook:IsSpellAvoidableForPartyMember(challengeId, unitId, spellId)
	local challenge = self:Challenge_GetById(challengeId);
	if (not challenge) then
		return nil;
	end
	local role = challenge.players[unitId].role;
	local avoidableSpells = self:GetSLAvoidableSpells();
	local avoidableAuras = self:GetSLAvoidableAuras();
	local avoidableSpellsNoTank = self:GetSLAvoidableSpellsNoTank();
	local avoidableAurasNoTank = self:GetSLAvoidableAurasNoTank();
	if (avoidableSpells[spellId] or (avoidableSpellsNoTank[spellId] and role ~= "TANK")) then
		return true;
	end
	if (avoidableAuras[spellId] or (avoidableAurasNoTank[spellId] and role ~= "TANK")) then
		return true;
	end
	return false;
end

--[[--
Parse steps for active challenge to get number of needed enemy forces
@return[type=?number]
]]
function MyDungeonsBook:GetNeededEnemyForcesForActiveChallenge()
    local _, _, steps = C_Scenario.GetStepInfo();
    if (steps and steps > 0) then
        for i = 1, steps do
            local name, _, completed, curValue, finalValue, _, _, quantity, criteriaId = C_Scenario.GetCriteriaInfo(i);
            if (criteriaId == 0) then
                return finalValue;
            end
        end
    end
    return nil;
end

--[[--
@return[type=string]
]]
function MyDungeonsBook:GetCurrentAffixesKey()
    local affixes = C_MythicPlus.GetCurrentAffixes();
    return string.format("%s-%s-%s-%s", affixes[1].id, affixes[2].id, affixes[3].id, affixes[4].id);
end

function MyDungeonsBook:NotifyUpdateGroupInfo()
	NotifyInspect("player");
	for i = 1, 4 do
		self:ScheduleTimer(function()
			local unitId = "party" .. i;
			if (UnitExists(unitId)) then
				NotifyInspect(unitId);
			end
		end, i * 2);
	end
end
