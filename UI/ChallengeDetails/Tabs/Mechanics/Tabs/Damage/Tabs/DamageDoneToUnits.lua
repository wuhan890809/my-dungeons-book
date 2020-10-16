--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Damage Done To Units tab (data is taken from `mechanics[**-DAMAGE-DONE-TO-UNITS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:DamageDoneToUnitsFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:DamageDoneToUnitsFrame_GetHeadersForTable();
	local tableWrapper = CreateFrame("Frame", nil, parentFrame);
	tableWrapper:SetWidth(900);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 0, -120);
	local table = ScrollingTable:CreateST(cols, 10, 40, nil, tableWrapper);
	tableWrapper.table = table;
	return tableWrapper;
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
			name = L["NPC"],
			width = 120,
			align = "LEFT"
		},
		{
			name = player .. "\n" .. L["Amount"],
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Over"],
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 30,
			align = "RIGHT"
		},
		{
			name = party1 .. "\n" .. L["Amount"],
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Over"],
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 30,
			align = "RIGHT"
		},
		{
			name = party2 .. "\n" .. L["Amount"],
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Over"],
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 30,
			align = "RIGHT"
		},
		{
			name = party3 .. "\n" .. L["Amount"],
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Over"],
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 30,
			align = "RIGHT"
		},
		{
			name = party4 .. "\n" .. L["Amount"],
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Over"],
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "\n" .. L["Hits"],
			width = 30,
			align = "RIGHT"
		}
	};
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
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Damage Done To Units data for challenge #%s", challengeId));
		return tableData;
	end
	for npcId, damageByPartyMembers in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		local row = {};
		for partyMemberName, partyMemberDamage in pairs(damageByPartyMembers) do
			local amount = 0;
			local hits = 0;
			local overkill = 0;
			local partyUnitId = self:GetPartyUnitByName(challengeId, partyMemberName);
			if (partyUnitId) then
				for _, damageBySpell in pairs(partyMemberDamage) do
					amount = amount + damageBySpell.amount;
					overkill = overkill + damageBySpell.overkill;
					hits = hits + damageBySpell.hits;
				end
				row[partyUnitId .. "Amount"] = amount;
				row[partyUnitId .. "Hits"] = hits;
				row[partyUnitId .. "Overkill"] = overkill;
			else
				self:DebugPrint(string.format("%s not found in the challenge party roster", partyMemberName));
			end
		end
		local npcs = self:GetBfADamageDoneToSpecificUnits();
		local npc = npcs[npcId];
		if (not npc) then
			npcs = self:GetSLDamageDoneToSpecificUnits();
			npc = npcs[npcId];
		end
		local npcName;
		if (npc and npc.name) then
			npcName = npc.name;
		end
		if (not npcName) then
			npcName = self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name;
		end
		if (not npcName) then
			npcName = npcId;
		end
		local remappedRow = {
			cols = {
				{value = npcName}
			}
		};
		for _, unitId in pairs(self:GetPartyRoster()) do
			tinsert(remappedRow.cols, {
				value = row[unitId .. "Amount"] or 0
			});
			tinsert(remappedRow.cols, {
				value = row[unitId .. "Overkill"] or 0
			});
			tinsert(remappedRow.cols, {
				value = row[unitId .. "Hits"] or 0
			});
		end
		tinsert(tableData, remappedRow);
	end
	return tableData;
end

--[[--
Update Damage Done To Units tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:DamageDoneToUnitsFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local damageDoneToUnitsTableData = self:DamageDoneToUnitsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-DAMAGE-DONE-TO-UNITS");
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.damageDoneToUnitsFrame.table:SetData(damageDoneToUnitsTableData);
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.damageDoneToUnitsFrame.table:SetDisplayCols(self:DamageDoneToUnitsFrame_GetHeadersForTable(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.damageFrame.damageDoneToUnitsFrame.table:SortData();
	end
end
