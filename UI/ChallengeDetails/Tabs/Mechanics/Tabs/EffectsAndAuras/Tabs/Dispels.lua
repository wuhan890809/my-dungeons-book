--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates a frame for Dispels tab.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:DispelsFrame_Create(parentFrame, challengeId)
	local dispelsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local data = self:DispelsFrame_GetDataForTable(challengeId);
	local columns = self:Table_Headers_GetForSpellsSummary(challengeId);
	local table = self:TableWidget_Create(columns, 5, 40, nil, dispelsFrame, "dispels");
	table:SetData(data);
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
	local summaryData = self:DispelsFrame_GetDataForSummaryTable(challengeId);
	local summaryColumns = self:DispelsFrame_GetHeadersForSummaryTable(challengeId);
	local summaryTable = self:TableWidget_Create(summaryColumns, 5, 40, nil, dispelsFrame, "dispels-summary");
	summaryTable:SetData(summaryData);
	summaryTable.frame:SetPoint("TOPLEFT", 0, -280);
	summaryTable:RegisterEvents({
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
	return dispelsFrame;
end

--[[--
Map data about Dispels for challenge with id `challengeId`.

Data from `COMMON-DISPEL` is used.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:DispelsFrame_GetDataForTable(challengeId)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
    local mechanics = self:Challenge_Mechanic_GetById(challengeId, "COMMON-DISPEL");
	if (not mechanics) then
		self:DebugPrint(string.format("No Dispels data for challenge #%s", challengeId));
		return nil;
	end
	for unitName, dispelsBySpells in pairs(mechanics) do
		if (dispelsBySpells) then
			for _, dispelsBySpells in pairs(dispelsBySpells) do
				for dispelledSpellId, dispelsCount in pairs(dispelsBySpells) do
					if (not tableData[dispelledSpellId]) then
						tableData[dispelledSpellId] = {
							spellId = dispelledSpellId,
							player = 0,
							party1 = 0,
							party2 = 0,
							party3 = 0,
							party4 = 0,
							sum = 0
						};
					end
					tableData[dispelledSpellId].sum = tableData[dispelledSpellId].sum + dispelsCount;
					local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
					if (partyUnitId) then
						tableData[dispelledSpellId][partyUnitId] = tableData[dispelledSpellId][partyUnitId] + dispelsCount;
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
		tinsert(remappedTableData, r);
	end
	return remappedTableData;
end

--[[--
Generate columns for Dispels Summary table.

@return[type=table]
]]
function MyDungeonsBook:DispelsFrame_GetHeadersForSummaryTable()
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
			name = L["Spell"],
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellIcon(...);
			end
		},
		{
			name = "",
			width = 100,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellLink(...);
			end
		},
		{
			name = L["Casts"],
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
Map summary data about Dispels for challenge with id `challengeId`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:DispelsFrame_GetDataForSummaryTable(challengeId)
	local tableData = {};
	if (not challengeId) then
		return nil;
    end
    local challenge = self:Challenge_GetById(challengeId);
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, "COMMON-DISPEL");
    if (not mechanics) then
		self:DebugPrint(string.format("No Dispels data for challenge #%s", challengeId));
		return nil;
	end
	for unitName, dispelsBySpells in pairs(mechanics) do
		local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
		if (partyUnitId) then
			if (dispelsBySpells) then
				for unitSpellId, dispelsBySpells in pairs(dispelsBySpells) do
					local sum = 0;
					for _, dispelsCount in pairs(dispelsBySpells) do
						sum = sum + dispelsCount;
					end
					tinsert(tableData, {
						cols = {
							{value = unitSpellId},
							{value = self:ClassColorTextByClassIndex(challenge.players[partyUnitId].class, challenge.players[partyUnitId].name)},
							{value = unitSpellId},
							{value = unitSpellId},
							{value = sum},
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
