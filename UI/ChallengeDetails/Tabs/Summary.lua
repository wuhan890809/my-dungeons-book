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
	local table = self:TableWidget_Create(cols, 5, 40, nil, summaryFrame, "summary");
	table:SetData(self:SummaryFrame_GetDataForTable(challengeId));
	table:SortData();
	return summaryFrame;
end

--[[--
Generate columns for Summary table.

@return[type=Frame]
]]
function MyDungeonsBook:SummaryFrame_GetColumnsForTable()
	return {
		{
			name = L["Player"],
			width = 200,
			align = "LEFT"
		},
		{
			name = L["Damage"],
			width = 60,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = L["DPS"],
			width = 60,
			align = "RIGHT",
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
			name = L["HPS"],
			width = 60,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = L["Interrupts"],
			width = 60,
			align = "RIGHT"
		},
		{
			name = L["Dispells"],
			width = 60,
			align = "RIGHT"
		},
		{
			name = L["Deaths"],
			width = 60,
			align = "RIGHT"
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
	for _, unitId in pairs(self:GetPartyRoster()) do
		local _, damageDoneSummaryRow = self:DamageDoneByPartyMemberFrame_GetDataForTable(challengeId, "ALL-DAMAGE-DONE-BY-PARTY-MEMBERS", unitId);
		local allDamageDone = damageDoneSummaryRow.cols[5].value;
		local _, healDoneSummaryRow = self:HealByPartyMemberBySpellFrame_GetDataForTable(challengeId, "ALL-HEAL-DONE-BY-PARTY-MEMBERS", unitId);
		local allHealDone = healDoneSummaryRow.cols[5].value;
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
		if (partyDeaths[name]) then
			deathsCount = #partyDeaths[name];
		end
		if (partyDeaths[nameAndRealm]) then
			deathsCount = #partyDeaths[nameAndRealm];
		end
		tinsert(tableData, {
			cols = {
				{
					value = self:GetUnitNameRealmRoleStr(challenge.players[unitId])
				},
				{
					value = allDamageDone
				},
				{
					value = (challengeDuration and allDamageDone / challengeDuration) or "-"
				},
				{
					value = allHealDone
				},
				{
					value = (challengeDuration and allHealDone / challengeDuration) or "-"
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
	return tableData;
end
