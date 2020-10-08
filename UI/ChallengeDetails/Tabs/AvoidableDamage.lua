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
	local cols = self:AvoidableDamageFrame_GetHeadersForTable();
	local tableWrapper = CreateFrame("Frame", nil, parentFrame);
	tableWrapper:SetWidth(900);
	tableWrapper:SetHeight(490);
	tableWrapper:SetPoint("TOPRIGHT", -5, -110);
	local table = ScrollingTable:CreateST(cols, 12, 40, nil, tableWrapper);
	table:RegisterEvents({
		OnEnter = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
				end
			end
	    end,
		OnLeave = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
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
Generate columns for avoidable damage table.

Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:AvoidableDamageFrame_GetHeadersForTable(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	local player = "Player";
	local party1 = "Party1";
	local party2 = "Party2";
	local party3 = "Party3";
	local party4 = "Party4";
	if (challenge) then
		local players = challenge.players;
		player = (players.player.name and self:ClassColorTextByClassIndex(players.player.class, players.player.name)) or L["Not Found"];
		party1 = (players.party1.name and self:ClassColorTextByClassIndex(players.party1.class, players.party1.name)) or L["Not Found"];
		party2 = (players.party2.name and self:ClassColorTextByClassIndex(players.party2.class, players.party2.name)) or L["Not Found"];
		party3 = (players.party3.name and self:ClassColorTextByClassIndex(players.party3.class, players.party3.name)) or L["Not Found"];
		party4 = (players.party4.name and self:ClassColorTextByClassIndex(players.party4.class, players.party4.name)) or L["Not Found"];
	end
	return {
		{
			name = " ",
			width = 1,
			align = "LEFT"
		},
		{
			name = L["Spell"],
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellIcon(...);
			end
		},
		{
			name = "",
			width = 135,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellLink(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 50,
			align = "RIGHT"
		},
		{
			name = player .. "\n" .. L["Sum"],
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 50,
			align = "RIGHT"
		},
		{
			name = party1 .. "\nSum",
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 50,
			align = "RIGHT"
		},
		{
			name = party2 .. "\nSum",
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 50,
			align = "RIGHT"
		},
		{
			name = party3 .. "\nSum",
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 50,
			align = "RIGHT"
		},
		{
			name = party4 .. "\nSum",
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = L["Nums"],
			width = 50,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			}
		},
		{
			name = L["Sums"],
			width = 50,
			align = "RIGHT",
			sort = "dsc",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		}
	};
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
			tinsert(r.cols, {value = unitNum});
			tinsert(r.cols, {value = unitSum});
			if (unitNum) then
				nums = nums + unitNum;
			end
			if (unitSum) then
				sums = sums + unitSum;
			end
		end
		tinsert(r.cols, {value = nums});
		tinsert(r.cols, {value = sums});
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
				for spellId, numSumDetails in pairs(damageBySpells) do
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
		self.challengeDetailsFrame.avoidableDamageFrame.table:SetData(avoidableDamageTableData);
		self.challengeDetailsFrame.avoidableDamageFrame.table:SetDisplayCols(self:AvoidableDamageFrame_GetHeadersForTable(challengeId));
		self.challengeDetailsFrame.avoidableDamageFrame.table:SortData();
	end
end