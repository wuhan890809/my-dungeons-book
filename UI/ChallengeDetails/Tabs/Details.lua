--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates a frame for Details tab (data should be from `details` section for challenge).

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:DetailsFrame_Create(parentFrame, challengeId)
	local detailsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local cols = self:DetailsFrame_GetColumnsForTable();
	local table = self:TableWidget_Create(cols, 5, 40, nil, detailsFrame, "details");
	table:SetData(self:DetailsFrame_GetDataForTable(challengeId));
	table:SortData();
	return detailsFrame;
end

--[[--
Generate columns for Details table.

@return[type=Frame]
]]
function MyDungeonsBook:DetailsFrame_GetColumnsForTable()
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
		}
	};
end

--[[--
Map data from Details addon for challenge with id `challengeId`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:DetailsFrame_GetDataForTable(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	local tableData = {};
	if (not challenge) then
		return tableData;
	end
	if (not challenge.details) then
		return tableData;
	end
	if (not challenge.details.exists) then
		return tableData;
	end
	for _, unitId in pairs(self:GetPartyRoster()) do
		local details = challenge.details[unitId];
		if (not details) then
			local unitName = challenge.players[unitId].name;
			details = challenge.details[unitName];
			if (not details) then
				local unitRealm = challenge.players[unitId].realm;
				details = (unitRealm and challenge.details[unitName .. "-" .. unitRealm]) or {};
			end
		end
		tinsert(tableData, {
			cols = {
				{
					value = self:GetUnitNameRealmRoleStr(challenge.players[unitId])
				},
				{
					value = details.totalDamage
				},
				{
					value = details.effectiveDps
				},
				{
					value = details.totalHeal
				},
				{
					value = details.effectiveHps
				},
				{
					value = self:RoundNumber(details.interrupt) or "-"
				},
				{
					value = self:RoundNumber(details.dispell) or "-"
				}
			}
		});
	end
	return tableData;
end
