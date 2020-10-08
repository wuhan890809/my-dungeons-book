--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Buff Or Debuffs On Party Members tab (data is taken from `mechanics[**-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:BuffsOrDebuffsOnPartyMembersFrame_GetHeadersForTable();
	local tableWrapper = CreateFrame("Frame", nil, parentFrame);
	tableWrapper:SetWidth(550);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 10, -120);
	local table = ScrollingTable:CreateST(cols, 11, 40, nil, tableWrapper);
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
Generate columns for Buff Or Debuffs On Party Members table.

Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`.

@param[type=?number] challengeId
@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersFrame_GetHeadersForTable(challengeId)
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

--[[--
Map data about Buff Or Debuffs On Party Members for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for `BFA` and `SL`)
@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersFrame_GetDataForTable(challengeId, key)
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

--[[--
Update Buff Or Debuffs On Party Members tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local buffsOrDebuffsOnPartyMembersTableData = self:BuffsOrDebuffsOnPartyMembersFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS");
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame.table:SetDisplayCols(self:BuffsOrDebuffsOnPartyMembersFrame_GetHeadersForTable(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame.table:SetData(buffsOrDebuffsOnPartyMembersTableData);
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnPartyMembersFrame.table:SortData();
	end
end