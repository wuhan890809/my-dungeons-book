--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Avoidable Debuffs tab (data is taken from `mechanics[**-AVOIDABLE-AURAS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:AvoidableDebuffsFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local interruptsFrame = CreateFrame("Frame", nil, parentFrame);
	interruptsFrame:SetWidth(900);
	interruptsFrame:SetHeight(490);
	interruptsFrame:SetPoint("TOPLEFT", 0, -100);
	local tableWrapper = CreateFrame("Frame", nil, interruptsFrame);
	tableWrapper:SetWidth(600);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 10, 0);
	local cols = self:AvoidableDebuffsFrame_GetHeadersForTable();
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
Generate columns for avoidable damage table.

Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:AvoidableDebuffsFrame_GetHeadersForTable(challengeId)
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
			name = player,
			width = 70,
			align = "RIGHT"
		},
		{
			name = party1,
			width = 70,
			align = "RIGHT"
		},
		{
			name = party2,
			width = 70,
			align = "RIGHT"
		},
		{
			name = party3,
			width = 70,
			align = "RIGHT"
		},
		{
			name = party4,
			width = 70,
			align = "RIGHT"
		},
		{
			name = L["Sum"],
			width = 50,
			align = "RIGHT",
			sort = "dsc",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			}
		}
	};
end

--[[--
Map data about Avoidable Debuffs for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for BFA and SL)
@return[type=table]
]]
function MyDungeonsBook:AvoidableDebuffsFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Avoidable Debuffs data for challenge #%s", challengeId));
		return {};
	end
	for name, damageBySpells in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		if (damageBySpells) then
			for spellId, hits in pairs(damageBySpells) do
				if (not tableData[spellId]) then
					tableData[spellId] = {
						spellId = spellId,
						player = 0,
						party1 = 0,
						party2 = 0,
						party3 = 0,
						party4 = 0
					};
				end
				local partyUnitId = self:GetPartyUnitByName(challengeId, name);
				if (partyUnitId) then
					tableData[spellId][partyUnitId] = hits;
				else
					self:DebugPrint(string.format("%s not found in the challenge party roster", name));
				end
			end
		else
			self:DebugPrint(string.format("%s not found", name));
		end
	end
	local remappedTableData = {};
	for _, row in pairs(tableData) do
		local r = {
			cols = {}
		};
		tinsert(r.cols, {value = row.spellId});
		tinsert(r.cols, {value = row.spellId});
		tinsert(r.cols, {value = row.spellId});
		local sum = 0;
		for _, unitId in pairs(self:GetPartyRoster()) do
			tinsert(r.cols, {value = row[unitId]});
			if (row[unitId]) then
				sum = sum + row[unitId];
			end
		end
		tinsert(r.cols, {value = sum});
		tinsert(remappedTableData, r);
	end
	return remappedTableData;
end

--[[--
Update Avoidable Damage-tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:AvoidableDebuffsFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local avoidableDebuffsTableData = self:AvoidableDebuffsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-AVOIDABLE-AURAS");
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.avoidableDebuffsFrame.table:SetData(avoidableDebuffsTableData);
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.avoidableDebuffsFrame.table:SetDisplayCols(self:AvoidableDebuffsFrame_GetHeadersForTable(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.avoidableDebuffsFrame.table:SortData();
	end
end
