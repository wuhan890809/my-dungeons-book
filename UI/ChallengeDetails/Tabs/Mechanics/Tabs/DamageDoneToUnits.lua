local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
Create a frame for Special Casts tab (data is taken from `mechanics[**-DAMAGE-DONE-TO-UNITS]`)
Mouse hover/out handler are included

@method MyDungeonsBook:CreateDamageDoneToUnitsFrame
@param {table} frame
@return {table} tableWrapper
]]
function MyDungeonsBook:CreateDamageDoneToUnitsFrame(frame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:GetHeadersForDamageDoneToUnitsTable();
	local tableWrapper = CreateFrame("Frame", nil, frame);
	tableWrapper:SetWidth(900);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 0, -120);
	local table = ScrollingTable:CreateST(cols, 11, 40, nil, tableWrapper);
	tableWrapper.table = table;
	return tableWrapper;
end

--[[
Generate columns for special casts table

Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`

@method MyDungeonsBook:GetHeadersForDamageDoneToUnitsTable
@param {number} challengeId
@return {table}
]]
function MyDungeonsBook:GetHeadersForDamageDoneToUnitsTable(challengeId)
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
			name = "",
			width = 120,
			align = "LEFT"
		},
		{
			name = player .. "\nAmount",
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nOver",
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nHits",
			width = 30,
			align = "RIGHT"
		},
		{
			name = party1 .. "\nAmount",
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nOver",
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nHits",
			width = 30,
			align = "RIGHT"
		},
		{
			name = party2 .. "\nAmount",
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nOver",
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nHits",
			width = 30,
			align = "RIGHT"
		},
		{
			name = party3 .. "\nAmount",
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nOver",
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nHits",
			width = 30,
			align = "RIGHT"
		},
		{
			name = party4 .. "\nAmount",
			width = 70,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nOver",
			width = 50,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsNumber(...);
			end
		},
		{
			name = "\nHits",
			width = 30,
			align = "RIGHT"
		}
	};
end

--[[
Mouse-hover handler for special casts table
Shows a tooltip with spell name and description (from `GetSpellLink`)

@method MyDungeonsBook:DamageDoneToUnitsTable_UnitHover
@param {table} frame
@param {number} spellId
]]
function MyDungeonsBook:DamageDoneToUnitsTable_UnitHover(frame, spellId)
	if (spellId and spellId > 0) then
		GameTooltip:SetOwner(frame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT");
		GameTooltip:SetSpellByID(spellId);
		GameTooltip:Show();
	end
end

--[[
Mouse-out handler for avoidable damage table

@method MyDungeonsBook:DamageDoneToUnitsTable_UnitOut
]]
function MyDungeonsBook:DamageDoneToUnitsTable_UnitOut()
	GameTooltip:Hide();
end

--[[
Map data about Special Casts for challenge with id `challengeId`

@method MyDungeonsBook:GetDamageDoneToUnitsTableData
@param {number} challengeId
@param {key} string key for mechanics table (it's different for BFA and SL)
@return {table}
]]
function MyDungeonsBook:GetDamageDoneToUnitsTableData(challengeId, key)
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
				for spellId, damageBySpell in pairs(partyMemberDamage) do
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
		local remappedRow = {
			cols = {
				{value = (npc and npc.name) or npcId}
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

--[[
Update Special Casts-tab for challenge with id `challengeId`

@method MyDungeonsBook:UpdateDamageDoneToUnitsFrame
@param {number} challengeId
]]
function MyDungeonsBook:UpdateDamageDoneToUnitsFrame(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local specialCastsTableData = self:GetDamageDoneToUnitsTableData(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-DAMAGE-DONE-TO-UNITS");
		self.challengeDetailsFrame.mechanicsFrame.damageDoneToUnitsFrame.table:SetData(specialCastsTableData);
		self.challengeDetailsFrame.mechanicsFrame.damageDoneToUnitsFrame.table:SetDisplayCols(self:GetHeadersForDamageDoneToUnitsTable(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.damageDoneToUnitsFrame.table:SortData();
	end
end