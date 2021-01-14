--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getDamageToNpcMenu(rows, index, cols)
	local spellId = rows[index].cols[1].value;
	local report = MyDungeonsBook:DamageDoneToUnitsFrame_Report_Create(rows[index], cols);
	return {
		MyDungeonsBook:WowHead_Menu_Npc(spellId),
		MyDungeonsBook:Report_Menu(report)
	};
end

--[[--
Create a frame for Damage Done To Units tab (data is taken from `mechanics[**-DAMAGE-DONE-TO-UNITS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:DamageDoneToUnitsFrame_Create(parentFrame, challengeId)
	local damageDoneToUnitsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local data = self:DamageDoneToUnitsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-DAMAGE-DONE-TO-UNITS");
	local columns = self:DamageDoneToUnitsFrame_GetHeadersForTable(challengeId);
	local table = self:TableWidget_Create(columns, 11, 40, nil, damageDoneToUnitsFrame, "damage-done-to-units");
	table:SetData(data);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getDamageToNpcMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end,
		OnEnter = function (...)
			self:DamageDoneToUnitsFrame_RowHover(...);
		end,
		OnLeave = function (_, _, _, _, _, realrow)
			if (realrow) then
				self:Table_Cell_MouseOut();
			end
		end
	});
	return damageDoneToUnitsFrame;
end

--[[--
Generate columns for Damage Done To Units table.

Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:DamageDoneToUnitsFrame_GetHeadersForTable(challengeId)
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
			name = "|Tinterface\\scenarios\\scenarioicon-interact.blp:12|t",
			width = 40,
			align = "CENTER"
		},
		{
			name = L["ID"],
			width = 50,
			align = "LEFT"
		},
		{
			name = L["NPC"],
			width = 120,
			align = "LEFT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
		},
		{
			name = player,
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = party1,
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = party2,
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = party3,
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = party4,
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = L["Sum"],
			width = 70,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
	};
end

--[[--
@local
]]
function MyDungeonsBook:DamageDoneToUnitsFrame_RowHover(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	if (realrow and column % 3 == 2 and column > 3) then
		local amount = self:FormatNumber(data[realrow].cols[column].value);
		local overkill = self:FormatNumber(data[realrow].cols[column + 1].value);
		local hits = data[realrow].cols[column + 2].value;
		GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", cellFrame, "BOTTOMRIGHT");
		GameTooltip:AddLine(cols[column].name);
		GameTooltip:AddLine(string.format("%s: %s", L["Amount"], amount));
		GameTooltip:AddLine(string.format("%s: %s", L["Over"], overkill));
		GameTooltip:AddLine(string.format("%s: %s", L["Hits"], hits));
		GameTooltip:Show();
	end
end

--[[--
Map data about Damage Done To Units for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for BFA and SL)
@return[type=table]
]]
function MyDungeonsBook:DamageDoneToUnitsFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	if (not mechanics) then
		self:DebugPrint(string.format("No Damage Done To Units data for challenge #%s", challengeId));
		return tableData;
	end
	local specialNpcs = self:GetSLDamageDoneToSpecificUnits();
	for npcId, damageByPartyMembers in pairs(mechanics) do
		local row = {};
		for partyMemberName, partyMemberDamage in pairs(damageByPartyMembers) do
			local amount = 0;
			local hits = 0;
			local overkill = 0;
			local realPartyMemberName = (partyMemberDamage.meta and partyMemberDamage.meta.unitName) or partyMemberName;
			local partyUnitId = self:GetPartyUnitByName(challengeId, realPartyMemberName);
			if (partyUnitId) then
				for spellId, damageBySpell in pairs(partyMemberDamage) do
					if (spellId ~= "meta") then
						amount = amount + damageBySpell.amount;
						overkill = overkill + damageBySpell.overkill;
						hits = hits + damageBySpell.hits;
					end
				end
				row[partyUnitId .. "Amount"] = (row[partyUnitId .. "Amount"] or 0) + amount;
				row[partyUnitId .. "Hits"] = (row[partyUnitId .. "Hits"] or 0) + hits;
				row[partyUnitId .. "Overkill"] = (row[partyUnitId .. "Overkill"] or 0) + overkill;
				row["amount"] = (row["amount"] or 0) + amount;
				row["hits"] = (row["hits"] or 0) + hits;
				row["overkill"] = (row["overkill"] or 0) + overkill;
			else
				self:DebugPrint(string.format("%s not found in the challenge party roster", partyMemberName));
			end
		end
		local npcName = self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name;
		if (not npcName) then
			npcName = npcId;
		end
		local icon = "";
		if (specialNpcs[npcId]) then
			if (specialNpcs[npcId].type == "BOSS") then
				icon = "|Tinterface\\scenarios\\scenarioicon-boss.blp:12|t"
			end
			if (specialNpcs[npcId].type == "ADD") then
				icon = "|Tinterface\\scenarios\\scenarioicon-combat.blp:18|t"
			end
			if (specialNpcs[npcId].type == "MOB") then
				icon = "|Tinterface\\scenarios\\scenarioicon-dash.blp:18|t"
			end
			if (specialNpcs[npcId].type == "AFFIX") then
				icon = "|Tinterface\\characterframe\\deathknight-bloodrune.blp:18|t"
			end
		end
		local remappedRow = {
			cols = {
				{value = npcId},
				{value = icon},
				{value = npcId},
				{value = npcName}
			}
		};
		for _, unitId in pairs(self:GetPartyRoster()) do
			local amountCell = {
				value = row[unitId .. "Amount"] or 0
			};
			if (specialNpcs[npcId]) then
				amountCell.color = self:GetColorFor(specialNpcs[npcId].type);
			end
			tinsert(remappedRow.cols, amountCell);
			tinsert(remappedRow.cols, {
				value = row[unitId .. "Overkill"] or 0
			});
			tinsert(remappedRow.cols, {
				value = row[unitId .. "Hits"] or 0
			});
		end
		local amountSumCell = {
			value = row["amount"]
		};
		if (specialNpcs[npcId]) then
			amountSumCell.color = self:GetColorFor(specialNpcs[npcId].type);
		end
		tinsert(remappedRow.cols, amountSumCell);
		tinsert(remappedRow.cols, {value = row["overkill"]});
		tinsert(remappedRow.cols, {value = row["hits"]});
		tinsert(tableData, remappedRow);
	end
	return tableData;
end

--[[--
]]
function MyDungeonsBook:DamageDoneToUnitsFrame_Report_Create(row, cols)
	local npcId = row.cols[1].value;
	local npcName = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
	local title = string.format(L["MyDungeonsBook Damage done by party to %s:"], npcName);
	return self:Table_PlayersRow_Report_Create(row, cols, {5, 8, 11, 14, 17, 20}, title);
end
