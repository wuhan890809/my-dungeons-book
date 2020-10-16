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
@return[type=Frame]
]]
function MyDungeonsBook:DetailsFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:DetailsFrame_GetHeadersForTable();
	local detailsFrame = CreateFrame("Frame", nil, parentFrame);
	detailsFrame:SetWidth(825);
	detailsFrame:SetHeight(250);
	detailsFrame:SetPoint("TOPLEFT", 0, -110);
	local table = ScrollingTable:CreateST(cols, 5, 40, nil, detailsFrame);
	detailsFrame.table = table;
	return detailsFrame;
end

--[[--
Generate columns for avoidable damage table.

@return[type=Frame]
]]
function MyDungeonsBook:DetailsFrame_GetHeadersForTable()
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

--[[--
Updates a Details frame with data for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:DetailsFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		self.challengeDetailsFrame.detailsFrame.table:SetData(self:DetailsFrame_GetDataForTable(challengeId));
	end
end
