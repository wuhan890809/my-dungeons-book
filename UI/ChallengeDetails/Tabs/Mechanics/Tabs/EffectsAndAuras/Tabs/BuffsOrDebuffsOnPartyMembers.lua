--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Buff Or Debuffs On Party Members tab (data is taken from `mechanics[**-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local cols = self:Table_Headers_GetForSpellsSummary();
	local buffsOrDebuffsOnPartyMembersFrame = CreateFrame("Frame", nil, parentFrame);
	buffsOrDebuffsOnPartyMembersFrame:SetWidth(900);
	buffsOrDebuffsOnPartyMembersFrame:SetHeight(490);
	buffsOrDebuffsOnPartyMembersFrame:SetPoint("TOPLEFT", 0, -120);
	local tableWrapper = CreateFrame("Frame", nil, buffsOrDebuffsOnPartyMembersFrame);
	tableWrapper:SetWidth(600);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 0, 0);
	local table = ScrollingTable:CreateST(cols, 10, 40, nil, tableWrapper);
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
	tableWrapper.table = table;
	return tableWrapper;
end

--[[--
Map data about Buff Or Debuffs On Party Members for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for `BFA` and `SL`)
@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Buff Or Debuffs On Party Members data for challenge #%s", challengeId));
		return tableData;
	end
	for spellId, buffsOrDebuffsOnPartyMembers in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		local sum = 0;
		local row = {};
		for unitName, numberOfBuffsOrDebuffs in pairs(buffsOrDebuffsOnPartyMembers) do
			local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
			if (partyUnitId) then
				row[partyUnitId] = numberOfBuffsOrDebuffs or 0;
				sum = sum + numberOfBuffsOrDebuffs;
			else
				self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
			end
		end
		tinsert(tableData, {
			cols = {
				{value = spellId},
				{value = spellId},
				{value = spellId},
				{value = row.player or 0},
				{value = row.party1 or 0},
				{value = row.party2 or 0},
				{value = row.party3 or 0},
				{value = row.party4 or 0},
				{value = sum}
			}
		});
	end
	return tableData;
end

--[[--
Update Buff Or Debuffs On Party Members tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:BuffsOrDebuffsOnPartyMembersFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local buffsOrDebuffsOnPartyMembersTableData = self:BuffsOrDebuffsOnPartyMembersFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-BUFFS-OR-DEBUFFS-ON-PARTY-MEMBERS");
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.buffsOrDebuffsOnPartyMembersFrame.table:SetDisplayCols(self:Table_Headers_GetForSpellsSummary(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.buffsOrDebuffsOnPartyMembersFrame.table:SetData(buffsOrDebuffsOnPartyMembersTableData);
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.buffsOrDebuffsOnPartyMembersFrame.table:SortData();
	end
end
