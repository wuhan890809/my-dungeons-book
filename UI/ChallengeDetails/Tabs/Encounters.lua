--[[--
@module MyDungeonsBook
]]
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
--[[--
UI
@section UI
]]

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
	local table = self:TableWidget_Create(columns, 6, 40, nil, encountersFrame, "encounters");
	table:SetData(data);
	return encountersFrame;
end

--[[--
Generate columns for Encounters table.

@return[type=table]
]]
function MyDungeonsBook:EncountersFrame_GetColumnsForTable()
	return {
		{
			name = L["ID"],
			width = 50,
			align = "LEFT"
		},
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
			name = "|Tinterface\\targetingframe\\ui-raidtargetingicon_8:12|t" .. L["Before"],
			width = 75,
			align = "RIGHT"
		},
		{
			name = "|Tinterface\\targetingframe\\ui-raidtargetingicon_8:12|t" .. L["While"],
			width = 75,
			align = "RIGHT"
		},
		{
			name = "|Tinterface\\targetingframe\\ui-raidtargetingicon_8:12|t" .. L["After"],
			width = 75,
			align = "RIGHT"
		},
		{
			name = L["Result"],
			width = 40,
			align = "CENTER",
			DoCellUpdate = function(_, cellFrame, data, _, _, realrow, column)
				local success = data[realrow].cols[column].value;
				local icon;
				if (success == 1) then
					icon = "interface\\raidframe\\readycheck-ready.blp";
				else
					icon = "interface\\raidframe\\readycheck-notready.blp";
				end
				local suffix = self:GetIconTextureSuffix(16);
				(cellFrame.text or cellFrame):SetText("|T" .. (icon or "") .. suffix .. "|t");
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
				{value = encounterData.id},
				{value = encounterData.name},
				{value = (encounterData.startTime - challenge.challengeInfo.startTime - countDownDelay) * 1000},
				{value = (encounterData.endTime - challenge.challengeInfo.startTime - countDownDelay  + deathCountWhile * 5) * 1000},  -- +5s for each death
				{value = (encounterData.endTime - encounterData.startTime) * 1000},
				{value = deathCountOnStart},
				{value = deathCountOnEnd - deathCountOnStart},
				{value = deathCountOnEnd},
				{value = encounterData.success}
			}
		});
	end
	return tableData;
end
