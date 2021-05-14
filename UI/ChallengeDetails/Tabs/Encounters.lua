--[[--
@module MyDungeonsBook
]]
--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getEncounterMenu(rows, index, cols, challengeId)
	local report = MyDungeonsBook:EncountersFrame_EncounterReport_Create(rows[index], cols, challengeId);
	return {
		MyDungeonsBook:Report_Menu(report)
	};
end

--[[--
Creates a frame for Encounters tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:EncountersFrame_Create(parentFrame, challengeId)
	local encountersFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local data = self:EncountersFrame_GetDataForTable(challengeId);
	local columns = self:EncountersFrame_GetColumnsForTable();
	local table = self:TableWidget_Create(columns, 14, 40, nil, encountersFrame, "encounters");
	table:SetData(data);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getEncounterMenu(data, realrow, table.cols, challengeId), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end
	});
	return encountersFrame;
end

function getSuccessFailIcon(success)
	local icon;
	if (success == 1) then
		icon = "interface\\raidframe\\readycheck-ready.blp";
	else
		icon = "interface\\raidframe\\readycheck-notready.blp";
	end
	local suffix = MyDungeonsBook:GetIconTextureSuffix(16);
	return "|T" .. (icon or "") .. suffix .. "|t";
end

--[[--
Generate columns for Encounters table.

@return[type=table]
]]
function MyDungeonsBook:EncountersFrame_GetColumnsForTable()
	return {
		{
			name = L["Name"],
			width = 150,
			align = "LEFT"
		},
		{
			name = L["Start Time"],
			width = 60,
			align = "LEFT",
			sort = "dsc",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsTime(...);
			end
		},
		{
			name = L["End Time"],
			width = 60,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsTime(...);
			end
		},
		{
			name = L["Duration"],
			width = 45,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsTime(...);
			end
		},
		{
			name = "% " .. L["Before"],
			width = 50,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsPercents(...);
			end
		},
		{
			name = "% " .. L["After"],
			width = 50,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsPercents(...);
			end
		},
		{
			name = "|Tinterface\\targetingframe\\ui-raidtargetingicon_8:12|t" .. L["Before"],
			width = 50,
			align = "RIGHT"
		},
		{
			name = "|Tinterface\\targetingframe\\ui-raidtargetingicon_8:12|t" .. L["While"],
			width = 75,
			align = "RIGHT"
		},
		{
			name = "|Tinterface\\targetingframe\\ui-raidtargetingicon_8:12|t" .. L["After"],
			width = 50,
			align = "RIGHT"
		},
		{
			name = L["Result"],
			width = 40,
			align = "CENTER",
			DoCellUpdate = function(_, cellFrame, data, _, _, realrow, column)
				local success = data[realrow].cols[column].value;
				(cellFrame.text or cellFrame):SetText(getSuccessFailIcon(success));
			end
		}
	}
end

--[[--
Map data about Encounters for challenge with id `challengeId`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:EncountersFrame_GetDataForTable(challengeId)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	local challenge = self.db.char.challenges[challengeId];
	if (not challenge.encounters) then
		self:DebugPrint(string.format("No Encounters data for challenge #%s", challengeId));
		return nil;
	end
	local countDownDelay = self:GetCountDownDelay(challengeId);
	for _, encounterData in pairs(challenge.encounters) do
		local deathCountOnStart = encounterData.deathCountOnStart or 0;
		local deathCountOnEnd = encounterData.deathCountOnEnd or 0;
		local deathCountWhile = deathCountOnEnd - deathCountOnStart;
		tinsert(tableData, {
			cols = {
				{value = encounterData.name},
				{value = (encounterData.startTime - challenge.challengeInfo.startTime - countDownDelay) * 1000},
				{value = (encounterData.endTime - challenge.challengeInfo.startTime - countDownDelay  + deathCountWhile * 5) * 1000},  -- +5s for each death
				{value = (encounterData.endTime - encounterData.startTime) * 1000},
				{value = encounterData.enemyForcesOnStart},
				{value = encounterData.enemyForcesOnEnd},
				{value = deathCountOnStart},
				{value = deathCountOnEnd - deathCountOnStart},
				{value = deathCountOnEnd},
				{value = encounterData.success}
			}
		});
	end
	return tableData;
end

--[[--
@param[type=table] row
@param[type=table] cols
@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:EncountersFrame_EncounterReport_Create(row, cols, challengeId)
	local challenge = self:Challenge_GetById(challengeId);
	local challengeName = challenge.challengeInfo.zoneName or "";
	local encounterName = row.cols[2].value;
	local key = challenge.challengeInfo.cmLevel;
	local challengeDate = string.gsub(self:FormatDate(challenge.challengeInfo.startTime), "\n", " ");
	local title = string.format(L["MyDungeonsBook Encounter %s (%s) for %s (%s) at %s:"], encounterName, (row.cols[9].value == 1 and "+" or "-"), challengeName, key, challengeDate);
	local msgFormat = "%s: %s";
	local report = {};
	tinsert(report, title);
	tinsert(report, string.format(msgFormat, cols[3].name, self:FormatTime(row.cols[3].value)));
	tinsert(report, string.format(msgFormat, cols[4].name, self:FormatTime(row.cols[4].value)));
	tinsert(report, string.format(msgFormat, cols[5].name, self:FormatTime(row.cols[5].value)));
	tinsert(report, string.format(msgFormat, L["Deaths"], row.cols[7].value));
	return report;
end
