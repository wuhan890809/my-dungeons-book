local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
Create a frame for Special Casts tab (data is taken from `mechanics[**-CASTS-DONE-BY-PARTY-MEMBERS]`)
Mouse hover/out handler are included

@method MyDungeonsBook:CreateSpecialCastsFrame
@param {table} frame
@return {table} tableWrapper
]]
function MyDungeonsBook:CreateSpecialCastsFrame(frame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:GetHeadersForSpecialCastsTable();
	local tableWrapper = CreateFrame("Frame", nil, frame);
	tableWrapper:SetWidth(600);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 10, -120);
	local table = ScrollingTable:CreateST(cols, 11, 40, nil, tableWrapper);
	table:RegisterEvents({
		OnEnter = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:SpecialCastsTable_SpellHover(cellFrame, data[realrow].cols[1].value);
				end
			end
	    end,
		OnLeave = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:SpecialCastsTable_SpellOut(cellFrame);
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

@method MyDungeonsBook:GetHeadersForSpecialCastsTable
@param {number} challengeId
@return {table}
]]
function MyDungeonsBook:GetHeadersForSpecialCastsTable(challengeId)
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
			name = "Spell",
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsSpellIcon(...);
			end
		},
		{
			name = "",
			width = 135,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsSpellLink(...);
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
			name = "Sum",
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

--[[
Mouse-hover handler for special casts table
Shows a tooltip with spell name and description (from `GetSpellLink`)

@method MyDungeonsBook:SpecialCastsTable_SpellHover
@param {table} frame
@param {number} spellId
]]
function MyDungeonsBook:SpecialCastsTable_SpellHover(frame, spellId)
	if (spellId and spellId > 0) then
		GameTooltip:SetOwner(frame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT");
		GameTooltip:SetSpellByID(spellId);
		GameTooltip:Show();
	end
end

--[[
Mouse-out handler for avoidable damage table

@method MyDungeonsBook:SpecialCastsTable_SpellOut
]]
function MyDungeonsBook:SpecialCastsTable_SpellOut()
	GameTooltip:Hide();
end

--[[
Map data about Special Casts for challenge with id `challengeId`

@method MyDungeonsBook:GetSpecialCastsTableData
@param {number} challengeId
@param {key} string key for mechanics table (it's different for BFA and SL)
@return {table}
]]
function MyDungeonsBook:GetSpecialCastsTableData(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Special Casts data for challenge #%s", challengeId));
		return tableData;
	end
	for spellId, castsByPartyMember in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		local row = {};
		local sum = 0;
		for unitName, numberOfCasts in pairs(castsByPartyMember) do
			local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
			if (partyUnitId) then
				row[partyUnitId] = numberOfCasts or 0;
				sum = sum + numberOfCasts;
			else
				self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
			end
		end
		local remappedRow = {
			cols = {
				{value = spellId},
				{value = spellId},
				{value = spellId}
			}
		};
		for _, unitId in pairs(self:GetPartyRoster()) do
			tinsert(remappedRow.cols, {
				value = row[unitId] or 0
			});
		end
		tinsert(remappedRow.cols, {
			value = sum
		});
		tinsert(tableData, remappedRow);
	end
	return tableData;
end

--[[
Update Special Casts-tab for challenge with id `challengeId`

@method MyDungeonsBook:UpdateSpecialCastsFrame
@param {number} challengeId
]]
function MyDungeonsBook:UpdateSpecialCastsFrame(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local specialCastsTableData = self:GetSpecialCastsTableData(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-CASTS-DONE-BY-PARTY-MEMBERS");
		self.challengeDetailsFrame.mechanicsFrame.specialCastsFrame.table:SetData(specialCastsTableData);
		self.challengeDetailsFrame.mechanicsFrame.specialCastsFrame.table:SetDisplayCols(self:GetHeadersForSpecialCastsTable(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.specialCastsFrame.table:SortData();
	end
end