--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Avoidable Damage tab (data is taken from `mechanics[**-AVOIDABLE-SPELLS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:AvoidableDamageFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:Table_Headers_GetForDamageToPartyMembers();
	local tableWrapper = CreateFrame("Frame", nil, parentFrame);
	tableWrapper:SetWidth(900);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 0, -120);
	local table = ScrollingTable:CreateST(cols, 10, 40, nil, tableWrapper);
	table:RegisterEvents({
		OnEnter = function (_, cellFrame, data, _, _, realrow, column)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
				end
			end
	    end,
		OnLeave = function (_, _, _, _, _, realrow, column)
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
Map data about Avoidable Damage for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for `BFA` and `SL`)
@return[type=table]
]]
function MyDungeonsBook:AvoidableDamageFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Avoidable Damage data for challenge #%s", challengeId));
		return {};
	end
	for name, damageBySpells in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		if (damageBySpells) then
			for spellId, numSumDetails in pairs(damageBySpells) do
				if (not tableData[spellId]) then
					tableData[spellId] = {
						spellId = spellId,
						playerNum = 0,
						playerSum = 0,
						party1Num = 0,
						party1Sum = 0,
						party2Num = 0,
						party2Sum = 0,
						party3Num = 0,
						party3Sum = 0,
						party4Num = 0,
						party4Sum = 0
					};
				end
				local partyUnitId = self:GetPartyUnitByName(challengeId, name);
				if (partyUnitId) then
					tableData[spellId][partyUnitId .. "Num"] = numSumDetails.num;
					tableData[spellId][partyUnitId .. "Sum"] = numSumDetails.sum;
				else
					self:DebugPrint(string.format("%s not found in the challenge party roster", name));
				end
			end
		else
			self:DebugPrint(string.format("%s not found", name));
		end
	end
	tinsert(tableData, self:AvoidableDamageFrame_GetSummaryRow(challengeId, key));
	local remappedTableData = {};
	for _, row in pairs(tableData) do
		local r = {
			cols = {}
		};
		if (row.spellId == -1) then
			r.color = {
				r = 0,
				g = 100,
				b = 0,
				a = 1
			};
		end
		tinsert(r.cols, {value = row.spellId});
		tinsert(r.cols, {value = row.spellId});
		tinsert(r.cols, {value = row.spellId});
		local nums = 0;
		local sums = 0;
		for _, unitId in pairs(self:GetPartyRoster()) do
			local unitNum = row[unitId .. "Num"];
			local unitSum = row[unitId .. "Sum"];
			tinsert(r.cols, {value = unitSum});
			tinsert(r.cols, {value = unitNum});
			if (unitNum) then
				nums = nums + unitNum;
			end
			if (unitSum) then
				sums = sums + unitSum;
			end
		end
		tinsert(r.cols, {value = sums});
		tinsert(r.cols, {value = nums});
		tinsert(remappedTableData, r);
	end
	return remappedTableData;
end

--[[--
Map sum of avoidable damage for each player.

@local
@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for `BFA` and `SL`)
@return[type=table]
]]
function MyDungeonsBook:AvoidableDamageFrame_GetSummaryRow(challengeId, key)
	local tableData = {
		spellId = -1
	};
	for name, damageBySpells in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		local partyUnitId = self:GetPartyUnitByName(challengeId, name);
		if (partyUnitId) then
			tableData[partyUnitId .. "Num"] = 0;
			tableData[partyUnitId .. "Sum"] = 0;
			if (damageBySpells) then
				for _, numSumDetails in pairs(damageBySpells) do
					tableData[partyUnitId .. "Num"] = tableData[partyUnitId .. "Num"] + numSumDetails.num;
					tableData[partyUnitId .. "Sum"] = tableData[partyUnitId .. "Sum"] + numSumDetails.sum;
				end
			end
		else
			self:DebugPrint(string.format("%s not found in the challenge party roster", name));
		end
	end
	tableData.nums = 0;
	tableData.sums = 0;
	for _, unitId in pairs(self:GetPartyRoster()) do
		if (tableData[unitId .. "Num"] and tableData[unitId .. "Sum"]) then
			tableData.nums = tableData.nums + tableData[unitId .. "Num"];
			tableData.sums = tableData.sums + tableData[unitId .. "Sum"];
		end
	end
	return tableData;
end

--[[--
Update Avoidable Damage-tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:AvoidableDamageFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local avoidableDamageTableData = self:AvoidableDamageFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-AVOIDABLE-SPELLS");
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.avoidableDamageFrame.table:SetData(avoidableDamageTableData);
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.avoidableDamageFrame.table:SetDisplayCols(self:Table_Headers_GetForDamageToPartyMembers(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.avoidableDamageFrame.table:SortData();
	end
end
