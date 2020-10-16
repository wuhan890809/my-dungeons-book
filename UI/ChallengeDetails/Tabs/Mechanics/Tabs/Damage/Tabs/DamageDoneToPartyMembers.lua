--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Damage Done To Party Members tab (data is taken from `mechanics[ALL-DAMAGE-DONE-TO-PARTY-MEMBERS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:DamageDoneToPartyMembersFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:Table_Headers_GetForDamageToPartyMembers();
	local tableWrapper = CreateFrame("Frame", nil, parentFrame);
	tableWrapper:SetWidth(900);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 0, -120);
	local table = ScrollingTable:CreateST(cols, 10, 40, nil, tableWrapper);
	table:RegisterEvents({
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
	tableWrapper.table = table;
	return tableWrapper;
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
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Damage Done To Party Members data for challenge #%s", challengeId));
		return tableData;
	end
	for unitName, damageDoneToPartyMember in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
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
			local hitsForPartyMember = tableData[spellId][rosterUnitId .. "Hits"] or 0;
			local amountForPartyMember = tableData[spellId][rosterUnitId .. "Amount"] or 0;
			hits = hits + hitsForPartyMember;
			amount = amount + amountForPartyMember;
			tinsert(remappedRow.cols, {value = amountForPartyMember});
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
	for unitName, damageDoneToPartyMember in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
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
			self:DebugPrint(string.format("%s not found in the challenge party roster", name));
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
Update Damage Done To Units tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:DamageDoneToPartyMembersFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local damageDoneToPartyMembersTableData = self:DamageDoneToPartyMembersFrame_GetDataForTable(challengeId, "ALL-DAMAGE-DONE-TO-PARTY-MEMBERS");
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.damageDoneToPartyMembersFrame.table:SetData(damageDoneToPartyMembersTableData);
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.damageDoneToPartyMembersFrame.table:SetDisplayCols(self:Table_Headers_GetForDamageToPartyMembers(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.damageDoneToPartyMembersFrame.table:SortData();
	end
end
