--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Buff Or Debuffs On Units tab (data is taken from `mechanics[**-BUFFS-OR-DEBUFFS-ON-UNIT]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:BuffsOrDebuffsOnUnitsFrame_GetHeadersForTable();
	local tableWrapper = CreateFrame("Frame", nil, parentFrame);
	tableWrapper:SetWidth(300);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 10, -120);
	local table = ScrollingTable:CreateST(cols, 11, 40, nil, tableWrapper);
	table:RegisterEvents({
		OnEnter = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 3 or column == 4) then
					self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
				end
			end
	    end,
		OnLeave = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 3 or column == 4) then
					self:Table_Cell_MouseOut();
				end
			end
	    end
	});
	tableWrapper.table = table;
	return tableWrapper;
end

--[[--
Generate columns for Buff Or Debuffs On Units table.

Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`.

@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_GetHeadersForTable()
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
			width = 160,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellLink(...);
			end
		},
		{
			name = L["Count"],
			width = 80,
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
Map data about Buff Or Debuffs On Units for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for `BFA` and `SL`)
@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Buff Or Debuffs On Units data for challenge #%s", challengeId));
		return tableData;
	end
	for spellId, buffsOrDebuffsOnUnit in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		local sum = 0;
		for npcId, count in pairs(buffsOrDebuffsOnUnit) do
			sum = sum + count;
		end
		local row = {
			cols = {
				{value = spellId},
				{value = spellId},
				{value = spellId},
				{value = sum}
			}
		};
		tinsert(tableData, row);
	end
	return tableData;
end

--[[--
Update Buff Or Debuffs On Units tab for challenge with id `challengeId`

@param[type=number] challengeId
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local buffsOrDebuffsOnUnitsTableData = self:BuffsOrDebuffsOnUnitsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-BUFFS-OR-DEBUFFS-ON-UNIT");
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnUnitsFrame.table:SetData(buffsOrDebuffsOnUnitsTableData);
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnUnitsFrame.table:SortData();
	end
end