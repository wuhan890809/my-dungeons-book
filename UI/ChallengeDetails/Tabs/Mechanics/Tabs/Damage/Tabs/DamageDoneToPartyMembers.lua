--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getDamageToEachPartyMemberSpellMenu(rows, index, cols)
	local spellId = rows[index].cols[1].value;
	local report = MyDungeonsBook:DamageDoneToPartyMembersFrame_Report_Create(rows[index], cols);
	return {
		MyDungeonsBook:WowHead_Menu_SpellComplex(spellId),
		MyDungeonsBook:Report_Menu(report)
	};
end

--[[--
Create a frame for Damage Done To Party Members tab (data is taken from `mechanics[ALL-DAMAGE-DONE-TO-PARTY-MEMBERS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:DamageDoneToPartyMembersFrame_Create(parentFrame, challengeId)
	local damageDoneToPartyMembersFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local data = self:DamageDoneToPartyMembersFrame_GetDataForTable(challengeId, "ALL-DAMAGE-DONE-TO-PARTY-MEMBERS");
	local columns = self:Table_Columns_GetForDamageOrHealToPartyMembers(challengeId);
	local table = self:TableWidget_Create(columns, 12, 40, nil, damageDoneToPartyMembersFrame, "damage-done-to-party-members");
	table:SetData(data);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				if (data[realrow].cols[1].value > 0) then
					EasyMenu(getDamageToEachPartyMemberSpellMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
				end
			end
		end,
		OnEnter = function (_, cellFrame, data, _, _, realrow, column, _)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
				end
			end
		end,
		OnLeave = function (_, _, _, _, _, realrow, column, _)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:Table_Cell_MouseOut();
				end
			end
		end
	});
	return damageDoneToPartyMembersFrame;
end

--[[--
Map data about Damage Done To Party Members for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's the same for BFA and SL)
@return[type=table]
]]
function MyDungeonsBook:DamageDoneToPartyMembersFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	local challenge = self:Challenge_GetById(challengeId);
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	if (not mechanics) then
		self:DebugPrint(string.format("No Damage Done To Party Members data for challenge #%s", challengeId));
		return tableData;
	end
	local avoidableSpells = self:GetSLAvoidableSpells();
	local avoidableSpellsNoTank = self:GetSLAvoidableSpellsNoTank();
	for unitName, damageDoneToPartyMember in pairs(mechanics) do
		for spellId, numSumBySpell in pairs(damageDoneToPartyMember) do
			if (not tableData[spellId]) then
				tableData[spellId] = {};
				for _, rosterUnitId in pairs(self:GetPartyRoster()) do
					tableData[spellId][rosterUnitId .. "Amount"] = 0;
					tableData[spellId][rosterUnitId .. "Hits"] = 0;
				end
			end
			local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
			if (partyUnitId) then
				tableData[spellId][partyUnitId .. "Amount"] = tableData[spellId][partyUnitId .. "Amount"] + numSumBySpell.sum;
				tableData[spellId][partyUnitId .. "Hits"] = tableData[spellId][partyUnitId .. "Hits"] + numSumBySpell.num;
			else
				self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
			end
		end
	end
	tableData[-1] = self:DamageDoneToPartyMembersFrame_GetSummaryRow(challengeId, key);
	tableData[-3] = self:DamageDoneToPartyMembersFrame_GetAvoidableSummaryRow(challengeId, key);
	local remappedTableData = {};
	for spellId, _ in pairs(tableData) do
		local remappedRow = {
			cols = {
				{value = spellId},
				{value = spellId},
				{value = spellId}
			}
		};
		local hits = 0;
		local amount = 0;
		for _, rosterUnitId in pairs(self:GetPartyRoster()) do
			local role = challenge.players[rosterUnitId].role;
			local hitsForPartyMember = tableData[spellId][rosterUnitId .. "Hits"] or 0;
			local amountForPartyMember = tableData[spellId][rosterUnitId .. "Amount"] or 0;
			hits = hits + hitsForPartyMember;
			amount = amount + amountForPartyMember;
			local amountCell = {value = amountForPartyMember};
			local amountIsAvoidable = avoidableSpells[spellId] or (avoidableSpellsNoTank[spellId] and role ~= "TANK");
			if (amountIsAvoidable and amountForPartyMember > 0) then
				amountCell.color = {
					r = 200,
					g = 0,
					b = 0,
					a = 1
				};
			end
			tinsert(remappedRow.cols, amountCell);
			tinsert(remappedRow.cols, {value = hitsForPartyMember});
		end
		tinsert(remappedRow.cols, {value = amount});
		tinsert(remappedRow.cols, {value = hits});
		if (spellId == -1) then
			remappedRow.color = {
				r = 0,
				g = 100,
				b = 0,
				a = 1
			};
		end
		if (spellId == -3) then
			remappedRow.color = {
				r = 200,
				g = 0,
				b = 0,
				a = 1
			};
		end
		tinsert(remappedTableData, remappedRow);
	end
	return remappedTableData;
end

--[[--
Map sum of avoidable damage for each player.

@local
@param[type=number] challengeId
@param[type=string] key for mechanics table (it's the same for BFA and SL)
@return[type=table]
]]
function MyDungeonsBook:DamageDoneToPartyMembersFrame_GetSummaryRow(challengeId, key)
	local tableData = {
		spellId = -1
	};
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	for unitName, damageDoneToPartyMember in pairs(mechanics) do
		local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
		if (partyUnitId) then
			tableData[partyUnitId .. "Hits"] = 0;
			tableData[partyUnitId .. "Amount"] = 0;
			if (damageDoneToPartyMember) then
				for _, numSumDetails in pairs(damageDoneToPartyMember) do
					tableData[partyUnitId .. "Hits"] = tableData[partyUnitId .. "Hits"] + numSumDetails.num;
					tableData[partyUnitId .. "Amount"] = tableData[partyUnitId .. "Amount"] + numSumDetails.sum;
				end
			end
		else
			self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
		end
	end
	tableData.hits = 0;
	tableData.amount = 0;
	for _, unitId in pairs(self:GetPartyRoster()) do
		if (tableData[unitId .. "Num"] and tableData[unitId .. "Sum"]) then
			tableData.nums = tableData.nums + tableData[unitId .. "Num"];
			tableData.sums = tableData.sums + tableData[unitId .. "Sum"];
		end
	end
	return tableData;
end

--[[--
@local
@param[type=number] challengeId
@param[type=string] key
@return[type=table]
]]
function MyDungeonsBook:DamageDoneToPartyMembersFrame_GetAvoidableSummaryRow(challengeId, key)
	local tableData = {
		spellId = -3
	};
	local avoidableSpells = self:GetSLAvoidableSpells();
	local avoidableSpellsNoTank = self:GetSLAvoidableSpellsNoTank();
	local challenge = self:Challenge_GetById(challengeId);
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	for unitName, damageDoneToPartyMember in pairs(mechanics) do
		local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
		if (partyUnitId) then
			tableData[partyUnitId .. "Hits"] = 0;
			tableData[partyUnitId .. "Amount"] = 0;
			local role = challenge.players[partyUnitId].role;
			if (damageDoneToPartyMember) then
				for spellId, numSumDetails in pairs(damageDoneToPartyMember) do
					local amountIsAvoidable = avoidableSpells[spellId] or (avoidableSpellsNoTank[spellId] and role ~= "TANK");
					if (amountIsAvoidable) then
						tableData[partyUnitId .. "Hits"] = tableData[partyUnitId .. "Hits"] + numSumDetails.num;
						tableData[partyUnitId .. "Amount"] = tableData[partyUnitId .. "Amount"] + numSumDetails.sum;
					end
				end
			end
		else
			self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
		end
	end
	tableData.hits = 0;
	tableData.amount = 0;
	for _, unitId in pairs(self:GetPartyRoster()) do
		if (tableData[unitId .. "Num"] and tableData[unitId .. "Sum"]) then
			tableData.nums = tableData.nums + tableData[unitId .. "Num"];
			tableData.sums = tableData.sums + tableData[unitId .. "Sum"];
		end
	end
	return tableData;
end

--[[--
@param[type=table] row
@param[type=table] cols
@return[type=table]
]]
function MyDungeonsBook:DamageDoneToPartyMembersFrame_Report_Create(row, cols)
	local spellLink = GetSpellLink(row.cols[1].value);
	local title = string.format(L["MyDungeonsBook Damage taken by party from %s:"], spellLink);
	return self:Table_PlayersRow_Report_Create(row, cols, {4, 6, 8, 10, 12, 14}, title);
end
