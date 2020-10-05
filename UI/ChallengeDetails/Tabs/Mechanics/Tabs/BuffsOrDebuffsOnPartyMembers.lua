local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
Create a frame for Buff Or Debuffs On Units tab (data is taken from `mechanics[**-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS]`)
Mouse hover/out handler are included

@method MyDungeonsBook:CreateBuffsOrDebuffsOnPartyMembersFrame
@param {table} frame
@return {table} tableWrapper
]]
function MyDungeonsBook:CreateBuffsOrDebuffsOnPartyMembersFrame(frame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:GetHeadersForBuffsOrDebuffsOnPartyMembersTable();
	local tableWrapper = CreateFrame("Frame", nil, frame);
	tableWrapper:SetWidth(550);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 10, -120);
	local table = ScrollingTable:CreateST(cols, 11, 40, nil, tableWrapper);
	table:RegisterEvents({
		OnEnter = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:BuffsOrDebuffsOnPartyMembersTable_SpellHover(cellFrame, data[realrow].cols[1].value);
				end
			end
	    end,
		OnLeave = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:BuffsOrDebuffsOnPartyMembersTable_SpellOut(cellFrame);
				end
			end
	    end
	});
	tableWrapper.table = table;
	return tableWrapper;
end

--[[
Generate columns for special casts table

Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`

@method MyDungeonsBook:GetHeadersForBuffsOrDebuffsOnPartyMembersTable
@param {number|nil} challengeId
@return {table}
]]
function MyDungeonsBook:GetHeadersForBuffsOrDebuffsOnPartyMembersTable(challengeId)
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
				self:FormatCellValueAsSpellIcon(...);
			end
		},
		{
			name = "",
			width = 105,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsSpellLink(...);
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
			name = L["Sum"],
			width = 45,
			align = "CENTER",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			}
		},
	};
end

--[[
Mouse-hover handler for special casts table
Shows a tooltip with spell name and description (from `GetSpellLink`)

@method MyDungeonsBook:BuffsOrDebuffsOnPartyMembersTable_SpellHover
@param {table} frame
@param {number} spellId
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersTable_SpellHover(frame, spellId)
	if (spellId and spellId > 0) then
		GameTooltip:SetOwner(frame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT");
		GameTooltip:SetSpellByID(spellId);
		GameTooltip:Show();
	end
end

--[[
Mouse-out handler for avoidable damage table

@method MyDungeonsBook:BuffsOrDebuffsOnPartyMembersTable_SpellOut
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersTable_SpellOut()
	GameTooltip:Hide();
end

--[[
@method MyDungeonsBook:GetBuffsOrDebuffsOnPartyMembersTableData
@param {number} challengeId
@param {key} string key for mechanics table (it's different for BFA and SL)
@return {table}
]]
function MyDungeonsBook:GetBuffsOrDebuffsOnPartyMembersTableData(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Buff Or Debuffs On Party Members data for challenge #%s", challengeId));
		return tableData;
	end
	for spellId, buffsOrDebuffsOnPartyMembers in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		local sum = 0;
		local row = {};
		for unitName, numberOfBuffsOrDebuffs in pairs(buffsOrDebuffsOnPartyMembers) do
			local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
			if (partyUnitId) then
				row[partyUnitId] = numberOfBuffsOrDebuffs or 0;
				sum = sum + numberOfBuffsOrDebuffs;
			else
				self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
			end
		end
		tinsert(tableData, {
			cols = {
				{value = spellId},
				{value = spellId},
				{value = spellId},
				{value = row.player or 0},
				{value = row.party1 or 0},
				{value = row.party2 or 0},
				{value = row.party3 or 0},
				{value = row.party4 or 0},
				{value = sum}
			}
		});
	end
	return tableData;
end

--[[
Update Special Casts-tab for challenge with id `challengeId`

@method MyDungeonsBook:UpdateBuffsOrDebuffsOnPartyMembersFrame
@param {number} challengeId
]]
function MyDungeonsBook:UpdateBuffsOrDebuffsOnPartyMembersFrame(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local buffsOrDebuffsOnPartyMembersTableData = self:GetBuffsOrDebuffsOnPartyMembersTableData(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS");
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame.table:SetDisplayCols(self:GetHeadersForBuffsOrDebuffsOnPartyMembersTable(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame.table:SetData(buffsOrDebuffsOnPartyMembersTableData);
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame.table:SortData();
	end
end