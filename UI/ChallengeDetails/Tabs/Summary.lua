--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates a frame for Summary tab.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:SummaryFrame_Create(parentFrame, challengeId)
	local summaryFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local cols = self:SummaryFrame_GetColumnsForTable();
	local challenge = self:Challenge_GetById(challengeId);
	local deathMechanics = self:Challenge_Mechanic_GetById(challengeId, "DEATHS") or {};
	local xLimit = (challenge.challengeInfo.duration and challenge.challengeInfo.duration / 1000) or nil;
	local series = {timeline = {}, icon = "interface\\targetingframe\\ui-targetingframe-skull", size = 16};
	local legend = {};
	for i, unitId in pairs(self:GetPartyRoster()) do
		local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
		local unitDeaths = deathMechanics[name] or deathMechanics[nameAndRealm];
		local unitIndex = 5 - i + 1;
		local unitInfo = challenge.players[unitId];
		legend[unitIndex] = self:ClassColorTextByClassIndex(unitInfo.class, unitInfo.name or "");
		if (unitDeaths) then
			for _, timestampOrTable in pairs(unitDeaths) do
				local timestamp = timestampOrTable;
				if (type(timestampOrTable) ~= "number") then
					timestamp = timestampOrTable.rounded;
				end
				tinsert(series.timeline, {timestamp, unitIndex - 1});
			end
		end
	end
	local encounterSeries = {};
	local encountersCopy = {};
	for _, encounterData in pairs(challenge.encounters) do
		tinsert(encountersCopy, encounterData);
	end
	table.sort(encountersCopy, function (a, b)
		return a.startTime < b.startTime;
	end);
	for _, encounterData in pairs(encountersCopy) do
		local st = encounterData.startTime - challenge.challengeInfo.startTime - 10;
		local et = encounterData.endTime - challenge.challengeInfo.startTime - 10;
		tinsert(encounterSeries, {st, 0});
		tinsert(encounterSeries, {st, 5}); -- 5 because graph contains five "rows" - 1 for each party member
		tinsert(encounterSeries, {et, 5});
		tinsert(encounterSeries, {et, 0});
	end
	local deathsGraph = self:SingleIconsGraph_Create(summaryFrame, "DeathsGraph", series, encounterSeries, challenge.challengeInfo.startTime, xLimit, 150, legend);
	summaryFrame:SetUserData("deathsGraph", deathsGraph);
	local table = self:TableWidget_Create(cols, 5, 40, nil, summaryFrame, "summary");
	summaryFrame:SetUserData("summaryTable", table);
	table:SetData(self:SummaryFrame_GetDataForTable(challengeId));
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, column, _, button)
			if (button == "LeftButton" and realrow) then
				local unitId = data[realrow].cols[1].value;
				if (column == 3 or column == 4 or column == 5) then
					self.challengeDetailsFrame.tabButtonsFrame:SelectTab("mechanics");
					self.mechanicsFrame.tabButtonsFrame:SelectTab("damage");
					self.damageFrame.tabButtonsFrame:SelectTab("damageDoneByPartyMembers");
					self.damageDoneByPartyMembersFrame.tabButtonsFrame:SelectTab(unitId);
				end
				if (column == 6 or column == 7 or column == 8) then
					self.challengeDetailsFrame.tabButtonsFrame:SelectTab("mechanics");
					self.mechanicsFrame.tabButtonsFrame:SelectTab("heal");
					self.healByPartyMembersFrameFrame.tabButtonsFrame:SelectTab(unitId);
				end
				if (column == 9) then
					self.challengeDetailsFrame.tabButtonsFrame:SelectTab("mechanics");
					self.mechanicsFrame.tabButtonsFrame:SelectTab("casts");
					self.castsFrame.tabButtonsFrame:SelectTab("interrupts");
				end
				if (column == 10) then
					self.challengeDetailsFrame.tabButtonsFrame:SelectTab("mechanics");
					self.mechanicsFrame.tabButtonsFrame:SelectTab("effectsAndAuras");
					self.effectsAndAurasFrame.tabButtonsFrame:SelectTab("dispels");
				end
				if (column == 11) then
					self.challengeDetailsFrame.tabButtonsFrame:SelectTab("mechanics");
					self.mechanicsFrame.tabButtonsFrame:SelectTab("deaths");
				end
			end
		end
	});
	table:SortData();
	table.frame:SetPoint("TOPLEFT", 0, -300);
	summaryFrame:SetCallback("OnRelease", function(frame)
		frame:GetUserData("deathsGraph"):ResetData();
		frame:GetUserData("deathsGraph"):Hide();
		frame:GetUserData("summaryTable"):Hide();
	end);
	return summaryFrame;
end

--[[--
Generate columns for Summary table.

@return[type=Frame]
]]
function MyDungeonsBook:SummaryFrame_GetColumnsForTable()
	return {
		{
			name = "",
			width = 1,
			align = "LEFT"
		},
		{
			name = L["Player"],
			width = 200,
			align = "LEFT"
		},
		{
			name = L["Damage"],
			width = 60,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = L["%"],
			width = 40,
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
			name = L["DPS"],
			width = 40,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = L["Heal"],
			width = 60,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = L["%"],
			width = 40,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsPercents(...);
			end
		},
		{
			name = L["HPS"],
			width = 40,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = L["Interrupts"],
			width = 60,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
		},
		{
			name = L["Dispels"],
			width = 60,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
		},
		{
			name = L["Deaths"],
			width = 60,
			align = "RIGHT",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
		}
	};
end

--[[--
Map data from Details addon for challenge with id `challengeId`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:SummaryFrame_GetDataForTable(challengeId)
	local challenge = self:Challenge_GetById(challengeId);
	local tableData = {};
	if (not challenge) then
		return tableData;
	end
	local challengeDuration = (challenge.challengeInfo.duration and challenge.challengeInfo.duration / 1000) or nil;
	local partyDeaths = self:Challenge_Mechanic_GetById(challengeId, "DEATHS");
	local damageSum = 0;
	local healSum = 0;
	for _, unitId in pairs(self:GetPartyRoster()) do
		local _, damageDoneSummaryRow = self:DamageDoneByPartyMemberFrame_GetDataForTable(challengeId, "ALL-DAMAGE-DONE-BY-PARTY-MEMBERS", unitId);
		local allDamageDoneByPartyMember = damageDoneSummaryRow.cols[5].value;
		local _, healDoneSummaryRow = self:HealByPartyMemberBySpellFrame_GetDataForTable(challengeId, "ALL-HEAL-DONE-BY-PARTY-MEMBERS", unitId);
		local allHealDoneByPartyMember = healDoneSummaryRow and healDoneSummaryRow.cols[5].value or 0;
		local interruptsTableData = self:InterruptsFrame_GetDataForSummaryTable(challengeId);
		local unitInterruptsSum = 0;
		for _, v in pairs(interruptsTableData) do
			if (v.cols[7].value == unitId) then
				unitInterruptsSum = unitInterruptsSum + v.cols[5].value;
			end
		end
		local dispelsTableData = self:DispelsFrame_GetDataForSummaryTable(challengeId);
		local unitDispelsSum = 0;
		for _, v in pairs(dispelsTableData) do
			if (v.cols[6].value == unitId) then
				unitDispelsSum = unitDispelsSum + v.cols[5].value;
			end
		end
		local deathsCount = 0;
		local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, unitId);
		if (partyDeaths and partyDeaths[name]) then
			deathsCount = #partyDeaths[name];
		end
		if (partyDeaths and partyDeaths[nameAndRealm]) then
			deathsCount = #partyDeaths[nameAndRealm];
		end
		damageSum = damageSum + allDamageDoneByPartyMember;
		healSum = healSum + allHealDoneByPartyMember;
		tinsert(tableData, {
			cols = {
				{
					value = unitId
				},
				{
					value = self:GetUnitNameRealmRoleStr(challenge.players[unitId])
				},
				{
					value = allDamageDoneByPartyMember
				},
				{
					value = 0,
				},
				{
					value = (challengeDuration and allDamageDoneByPartyMember / challengeDuration) or "-"
				},
				{
					value = allHealDoneByPartyMember
				},
				{
					value = 0,
				},
				{
					value = (challengeDuration and allHealDoneByPartyMember / challengeDuration) or "-"
				},
				{
					value = unitInterruptsSum
				},
				{
					value = unitDispelsSum
				},
				{
					value = deathsCount
				}
			}
		});
	end
	for _, row in pairs(tableData) do
		row.cols[4].value = row.cols[3].value / damageSum;
		row.cols[7].value = row.cols[6].value / healSum;
	end
	return tableData;
end
