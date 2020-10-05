local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
@method MyDungeonsBook:CreateEncountersFrame
@param {table} frame
@return {table}
]]
function MyDungeonsBook:CreateEncountersFrame(frame)
	local ScrollingTable = LibStub("ScrollingTable");
	local encountersFrame = CreateFrame("Frame", nil, frame);
	encountersFrame:SetWidth(900);
	encountersFrame:SetHeight(490);
	encountersFrame:SetPoint("TOPRIGHT", -5, -110);
	local cols = self:GetHeadersForEncountersTable();
	local tableWrapper = CreateFrame("Frame", nil, encountersFrame);
	tableWrapper:SetWidth(660);
	tableWrapper:SetHeight(270);
	tableWrapper:SetPoint("TOPLEFT", 10, 0);
	local table = ScrollingTable:CreateST(cols, 6, 40, nil, tableWrapper);
	table:RegisterEvents({
		OnClick = function(...)
			return true;
	    end
	});
	encountersFrame.table = table;
	return encountersFrame;
end

--[[
@method MyDungeonsBook:GetHeadersForEncountersTable
@return {table}
]]
function MyDungeonsBook:GetHeadersForEncountersTable()
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
			width = 75,
			align = "LEFT",
			sort = "dsc",
			DoCellUpdate = function(...)
				self:FormatCellValueAsTime(...);
			end
		},
		{
			name = L["End Time"],
			width = 75,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsTime(...);
			end
		},
		{
			name = L["Duration"],
			width = 75,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:FormatCellValueAsTime(...);
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
		}
	}
end

--[[
Map data about Encounters for challenge with id `challengeId`

@method MyDungeonsBook:GetDataForEncountersTable
@param {number} challengeId
@return {table}
]]
function MyDungeonsBook:GetDataForEncountersTable(challengeId)
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
	for id, encounterData in pairs(challenge.encounters) do
		local deathCountOnStart = encounterData.deathCountOnStart or 0;
		local deathCountOnEnd = encounterData.deathCountOnEnd or 0;
		local deathCountWhile = deathCountOnEnd - deathCountOnStart;
		tinsert(tableData, {
			cols = {
				{value = id},
				{value = encounterData.name},
				{value = (encounterData.startTime - challenge.challengeInfo.startTime - countDownDelay) * 1000},
				{value = (encounterData.endTime - challenge.challengeInfo.startTime - countDownDelay  + deathCountWhile * 5) * 1000},  -- +5s for each death
				{value = (encounterData.endTime - encounterData.startTime) * 1000},
				{value = deathCountOnStart},
				{value = deathCountOnEnd - deathCountOnStart},
				{value = deathCountOnEnd}
			}
		});
	end
	return tableData;
end

--[[
Update Encounters-tab for challenge with id `challengeId`

@method MyDungeonsBook:UpdateEncountersFrame
@param {number} challengeId
]]
function MyDungeonsBook:UpdateEncountersFrame(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local encountersTableData = self:GetDataForEncountersTable(challengeId);
		self.challengeDetailsFrame.encountersFrame.table:SetData(encountersTableData or {});
	end
end