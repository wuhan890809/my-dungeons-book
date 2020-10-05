local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
Create a frame for Buff Or Debuffs On Units tab (data is taken from `mechanics[**-BUFFS-OR-DEBUFFS-ON-UNIT]`)
Mouse hover/out handler are included

@method MyDungeonsBook:CreateBuffsOrDebuffsOnUnitsFrame
@param {table} frame
@return {table} tableWrapper
]]
function MyDungeonsBook:CreateBuffsOrDebuffsOnUnitsFrame(frame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:GetHeadersForBuffsOrDebuffsOnUnitsTable();
	local tableWrapper = CreateFrame("Frame", nil, frame);
	tableWrapper:SetWidth(300);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 10, -120);
	local table = ScrollingTable:CreateST(cols, 11, 40, nil, tableWrapper);
	table:RegisterEvents({
		OnEnter = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 3 or column == 4) then
					self:BuffsOrDebuffsOnUnitsTable_SpellHover(cellFrame, data[realrow].cols[1].value);
				end
			end
	    end,
		OnLeave = function (rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			if (realrow) then
				if (column == 3 or column == 4) then
					self:BuffsOrDebuffsOnUnitsTable_SpellOut(cellFrame);
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

@method MyDungeonsBook:GetHeadersForBuffsOrDebuffsOnUnitsTable
@return {table}
]]
function MyDungeonsBook:GetHeadersForBuffsOrDebuffsOnUnitsTable()
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
			width = 160,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsSpellLink(...);
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

--[[
Mouse-hover handler for special casts table
Shows a tooltip with spell name and description (from `GetSpellLink`)

@method MyDungeonsBook:BuffsOrDebuffsOnUnitsTable_SpellHover
@param {table} frame
@param {number} spellId
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsTable_SpellHover(frame, spellId)
	if (spellId and spellId > 0) then
		GameTooltip:SetOwner(frame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT");
		GameTooltip:SetSpellByID(spellId);
		GameTooltip:Show();
	end
end

--[[
Mouse-out handler for avoidable damage table

@method MyDungeonsBook:BuffsOrDebuffsOnUnitsTable_SpellOut
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsTable_SpellOut()
	GameTooltip:Hide();
end

--[[
@method MyDungeonsBook:GetBuffsOrDebuffsOnUnitsTableData
@param {number} challengeId
@param {key} string key for mechanics table (it's different for BFA and SL)
@return {table}
]]
function MyDungeonsBook:GetBuffsOrDebuffsOnUnitsTableData(challengeId, key)
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

--[[
Update Special Casts-tab for challenge with id `challengeId`

@method MyDungeonsBook:UpdateBuffsOrDebuffsOnUnitsFrame
@param {number} challengeId
]]
function MyDungeonsBook:UpdateBuffsOrDebuffsOnUnitsFrame(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local buffsOrDebuffsOnUnitsTableData = self:GetBuffsOrDebuffsOnUnitsTableData(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-BUFFS-OR-DEBUFFS-ON-UNIT");
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnUnitsFrame.table:SetData(buffsOrDebuffsOnUnitsTableData);
		self.challengeDetailsFrame.mechanicsFrame.buffsOrDebuffsOnUnitsFrame.table:SortData();
	end
end