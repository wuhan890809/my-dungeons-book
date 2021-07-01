--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getIterruptedSpellMenu(rows, index, cols)
	local spellId = rows[index].cols[1].value;
	local report = MyDungeonsBook:InterruptsFrame_SpellInterruptedReport_Create(rows[index], cols);
	return {
		MyDungeonsBook:WowHead_Menu_SpellComplex(spellId),
		MyDungeonsBook:Report_Menu(report)
	};
end

local function getIterruptsSummaryMenu(rows, index)
	local spellId = rows[index].cols[1].value;
	return {
		MyDungeonsBook:WowHead_Menu_Spell(spellId)
	};
end

local function getIterruptsQuakingMenu(rows, index)
	local spellId = rows[index].cols[2].value;
	return {
		MyDungeonsBook:WowHead_Menu_Spell(spellId)
	};
end

--[[--
Creates a frame for Interrupts tab.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:InterruptsFrame_Create(parentFrame, challengeId)
	local interruptsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local data = self:InterruptsFrame_GetDataForTable(challengeId);
	local columns = self:InterruptsFrame_GetHeadersForTable(challengeId);
	local table = self:TableWidget_Create(columns, 5, 40, nil, interruptsFrame, "interrupts");
	table:SetData(data);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getIterruptedSpellMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end,
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
	local summaryData = self:InterruptsFrame_GetDataForSummaryTable(challengeId);
	local summaryColumns = self:InterruptsFrame_GetHeadersForSummaryTable(challengeId);
	local summaryTable = self:TableWidget_Create(summaryColumns, 5, 40, nil, interruptsFrame, "interrupts-summary");
	summaryTable.frame:SetPoint("TOPLEFT", 0, -290);
	summaryTable:SetData(summaryData);
	summaryTable:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getIterruptsSummaryMenu(data, realrow, summaryTable.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end,
		OnEnter = function (_, cellFrame, data, _, _, realrow, column)
			if (realrow) then
				if (column == 3 or column == 4) then
					self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
				end
			end
		end,
		OnLeave = function (_, _, _, _, _, realrow, column)
			if (realrow) then
				if (column == 3 or column == 4) then
					self:Table_Cell_MouseOut();
				end
			end
		end
	});
	local quakingData = self:InterruptsFrame_GetDataForQuakingTable(challengeId);
	local quakingColumns = self:InterruptsFrame_GetHeadersForQuakingTable(challengeId);
	local quakingTable = self:TableWidget_Create(quakingColumns, 5, 40, nil, interruptsFrame, "quaking-interrupts");
	quakingTable.frame:SetPoint("TOPLEFT", 320, -290);
	quakingTable:SetData(quakingData);
	quakingTable:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getIterruptsQuakingMenu(data, realrow, quakingTable.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end,
		OnEnter = function (_, cellFrame, data, _, _, realrow, column)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[2].value);
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
	if (self:Challenge_Mechanic_GetById(challengeId, "COMMON-AFFIX-QUAKING-INTERRUPTS")) then
		quakingTable.frame:Show();
	else
		quakingTable.frame:Hide();
	end
	return interruptsFrame;
end

--[[--
Map data about interrupts done by Quaking affix

@param[type=?number] challengeId
@return[type=table]
]]
function MyDungeonsBook:InterruptsFrame_GetDataForQuakingTable(challengeId)
	local tableData = {};
	local challenge = self:Challenge_GetById(challengeId);
	local interruptsMechanics = self:Challenge_Mechanic_GetById(challengeId, "COMMON-AFFIX-QUAKING-INTERRUPTS");
	if (not interruptsMechanics) then
		self:DebugPrint(string.format("No Quaking Interrupts data for challenge #%s", challengeId));
		return tableData;
	end
	for unitName, v in pairs(interruptsMechanics) do
		local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
		if (partyUnitId) then
			for _, interrupts in pairs(v) do
				for spellId, interruptsCount in pairs(interrupts) do
					tinsert(tableData, {
						cols = {
							{value = self:ClassColorTextByClassIndex(challenge.players[partyUnitId].class, challenge.players[partyUnitId].name)},
							{value = spellId},
							{value = spellId},
							{value = interruptsCount},
						}
					});
				end
			end
		end
	end
	return tableData;
end

--[[--
Generate columns for Quaking Interrupts table

@param[type=?number] challengeId
@return[type=table]
]]
function MyDungeonsBook:InterruptsFrame_GetHeadersForQuakingTable(challengeId)
	return {
		{
			name = L["Player"],
			width = 80,
			align = "LEFT"
		},
		{
			name = "",
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellIcon(...);
			end
		},
		{
			name = L["Spell"],
			width = 100,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellLink(...);
			end
		},
		{
			name = L["Quaked"],
			width = 40,
			align = "CENTER"
		}
	};
end

--[[--
Generate columns for Interrupts table.

@param[type=?number] challengeId
@return[type=table]
]]
function MyDungeonsBook:InterruptsFrame_GetHeadersForTable(challengeId)
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
			name = "",
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellIcon(...);
			end
		},
		{
			name = L["Spell"],
			width = 105,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellLink(...);
			end
		},
		{
			name = player,
			width = 65,
			align = "CENTER"
		},
		{
			name = party1,
			width = 65,
			align = "CENTER"
		},
		{
			name = party2,
			width = 65,
			align = "CENTER"
		},
		{
			name = party3,
			width = 65,
			align = "CENTER"
		},
		{
			name = party4,
			width = 65,
			align = "CENTER"
		},
		{
			name = L["Kicked"],
			width = 45,
			align = "CENTER",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			}
		},
		{
			name = L["Passed"],
			width = 45,
			align = "CENTER"
		}
	};
end

--[[--
Map data about Interrupts for challenge with id `challengeId`.

Data from `COMMON-INTERRUPTS` is taken as basis. Amount of passed casts is stored in the `ALL-ENEMY-PASSED-CASTS`.

If some important spells (are in the `BFA|SL-SPELLS-TO-INTERRUPT`) were not interrupted, they are also added.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:InterruptsFrame_GetDataForTable(challengeId)
	local tableData = {};
	if (not challengeId) then
		return tableData;
	end
	local spellsToInterrupt = self:GetSLSpellsToInterrupt();
	local interruptsMechanics = self:Challenge_Mechanic_GetById(challengeId, "COMMON-INTERRUPTS");
	if (not interruptsMechanics) then
		self:DebugPrint(string.format("No Interrupts data for challenge #%s", challengeId));
		return tableData;
	end
	local passedSpellsToInterrupt = self:Challenge_Mechanic_GetById(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-SPELLS-TO-INTERRUPT") or {};
	local passedSpellsToInterruptNotInterrupted = {};
	for spellId, _ in pairs(passedSpellsToInterrupt) do
		passedSpellsToInterruptNotInterrupted[spellId] = true;
	end
	local allEnemiesPassedCasts = self:Challenge_Mechanic_GetById(challengeId, "ALL-ENEMY-PASSED-CASTS") or {};
	for unitName, interruptsBySpells in pairs(interruptsMechanics) do
		if (interruptsBySpells) then
			for _, interruptsByUnitSpell in pairs(interruptsBySpells) do
				for interruptedSpellId, interruptsCount in pairs(interruptsByUnitSpell) do
					passedSpellsToInterruptNotInterrupted[interruptedSpellId] = false;
					if (not tableData[interruptedSpellId]) then
						tableData[interruptedSpellId] = {
							spellId = interruptedSpellId,
							player = 0,
							party1 = 0,
							party2 = 0,
							party3 = 0,
							party4 = 0,
							sum = 0
						};
					end
					tableData[interruptedSpellId].sum = tableData[interruptedSpellId].sum + interruptsCount;
					local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
					if (partyUnitId) then
						tableData[interruptedSpellId][partyUnitId] = tableData[interruptedSpellId][partyUnitId] + interruptsCount;
					else
						self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
					end
				end
			end
		else
			self:DebugPrint(string.format("%s not found", unitName));
		end
	end
	local remappedTableData = {};
	for _, row in pairs(tableData) do
		local r = {
			cols = {}
		};
		for i = 1, 3 do
			tinsert(r.cols, {value = row.spellId});
		end
		for _, unitId in pairs(self:GetPartyRoster()) do
			tinsert(r.cols, {value = row[unitId]});
		end
		tinsert(r.cols, {value = row.sum});
		tinsert(r.cols, {value = allEnemiesPassedCasts[row.spellId] or "-"});
		tinsert(remappedTableData, r);
	end
	-- Here important to interrupt but not interrupted spells are added
	for spellId, shouldAddRowToTable in pairs(passedSpellsToInterruptNotInterrupted) do
		if (shouldAddRowToTable) then
			local r = {
				cols = {}
			};
			for i = 1, 3 do
				tinsert(r.cols, {value = spellId});
			end
			for _, _ in pairs(self:GetPartyRoster()) do
				tinsert(r.cols, {value = 0});
			end
			tinsert(r.cols, {value = 0});
			tinsert(r.cols, {value = allEnemiesPassedCasts[spellId] or "-"});
			tinsert(remappedTableData, r);
		end
	end
	for k, v in pairs(remappedTableData) do
		if (spellsToInterrupt[v.cols[1].value]) then
			remappedTableData[k].color = {
				r = 200,
				g = 0,
				b = 0,
				a = 1
			};
		end
	end
	return remappedTableData;
end

--[[--
Generate columns for Interrupts Summary table.

@return[type=table]
]]
function MyDungeonsBook:InterruptsFrame_GetHeadersForSummaryTable()
	return {
		{
			name = " ",
			width = 1,
			align = "LEFT"
		},
		{
			name = L["Player"],
			width = 80,
			align = "LEFT"
		},
		{
			name = "",
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellIcon(...);
			end
		},
		{
			name = L["Spell"],
			width = 100,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellLink(...);
			end
		},
		{
			name = L["Kicks"],
			width = 30,
			align = "CENTER"
		},
		{
			name = L["Casted"],
			width = 35,
			align = "CENTER"
		},
		{
			name = " ",
			width = 1,
			align = "CENTER"
		}
	};
end

--[[--
Map summary data about Interrupts for challenge with id `challengeId`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:InterruptsFrame_GetDataForSummaryTable(challengeId)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	local challenge = self:Challenge_GetById(challengeId);
	local interruptsMechanics = self:Challenge_Mechanic_GetById(challengeId, "COMMON-INTERRUPTS");
	if (not interruptsMechanics) then
		self:DebugPrint(string.format("No Interrupts data for challenge #%s", challengeId));
		return nil;
	end
	local tryInterrupts = self:Challenge_Mechanic_GetById(challengeId, "COMMON-TRY-INTERRUPT") or {};
	for unitName, interruptsBySpells in pairs(interruptsMechanics) do
		local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
		if (partyUnitId) then
			if (interruptsBySpells) then
				for unitSpellId, interruptsByUnitSpell in pairs(interruptsBySpells) do
					local sum = 0;
					for _, interruptsCount in pairs(interruptsByUnitSpell) do
						sum = sum + interruptsCount;
					end
					local triedToInterrupt;
					if (tryInterrupts[unitName] and tryInterrupts[unitName][unitSpellId]) then
						triedToInterrupt = tryInterrupts[unitName][unitSpellId];
					else
						local fullName = string.format("%s-%s", unitName, challenge.players[partyUnitId].realm);
						if (tryInterrupts[fullName] and tryInterrupts[fullName][unitSpellId]) then
							triedToInterrupt = tryInterrupts[fullName][unitSpellId];
						end
					end
					tinsert(tableData, {
						cols = {
							{value = unitSpellId},
							{value = self:ClassColorTextByClassIndex(challenge.players[partyUnitId].class, challenge.players[partyUnitId].name)},
							{value = unitSpellId},
							{value = unitSpellId},
							{value = sum},
							{value = triedToInterrupt or "-"},
							{value = partyUnitId}
						}
					});
				end
			end
		else
			self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
		end
	end
	return tableData;
end

--[[--
@param[type=table] row
@param[type=table] cols
@return[type=table]
]]
function MyDungeonsBook:InterruptsFrame_SpellInterruptedReport_Create(row, cols)
	local spellLink = GetSpellLink(row.cols[1].value);
	local title = string.format(L["MyDungeonsBook %s Interrupted:"], spellLink);
	return self:Table_PlayersRow_Report_Create(row, cols, {4, 5, 6, 7, 8, 9, 10}, title);
end
