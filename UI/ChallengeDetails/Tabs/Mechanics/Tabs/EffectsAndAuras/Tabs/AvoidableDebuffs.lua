--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Avoidable Debuffs tab (data is taken from `mechanics[**-AVOIDABLE-AURAS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:AvoidableDebuffsFrame_Create(parentFrame)
	local ScrollingTable = LibStub("ScrollingTable");
	local interruptsFrame = CreateFrame("Frame", nil, parentFrame);
	interruptsFrame:SetWidth(900);
	interruptsFrame:SetHeight(490);
	interruptsFrame:SetPoint("TOPLEFT", 0, -120);
	local tableWrapper = CreateFrame("Frame", nil, interruptsFrame);
	tableWrapper:SetWidth(600);
	tableWrapper:SetHeight(450);
	tableWrapper:SetPoint("TOPLEFT", 0, 0);
	local cols = self:Table_Headers_GetForSpellsSummary();
	local table = ScrollingTable:CreateST(cols, 11, 40, nil, tableWrapper);
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
Map data about Avoidable Debuffs for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for BFA and SL)
@return[type=table]
]]
function MyDungeonsBook:AvoidableDebuffsFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Avoidable Debuffs data for challenge #%s", challengeId));
		return {};
	end
	for name, damageBySpells in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		if (damageBySpells) then
			for spellId, hits in pairs(damageBySpells) do
				if (not tableData[spellId]) then
					tableData[spellId] = {
						spellId = spellId,
						player = 0,
						party1 = 0,
						party2 = 0,
						party3 = 0,
						party4 = 0
					};
				end
				local partyUnitId = self:GetPartyUnitByName(challengeId, name);
				if (partyUnitId) then
					tableData[spellId][partyUnitId] = hits;
				else
					self:DebugPrint(string.format("%s not found in the challenge party roster", name));
				end
			end
		else
			self:DebugPrint(string.format("%s not found", name));
		end
	end
	local remappedTableData = {};
	for _, row in pairs(tableData) do
		local r = {
			cols = {}
		};
		tinsert(r.cols, {value = row.spellId});
		tinsert(r.cols, {value = row.spellId});
		tinsert(r.cols, {value = row.spellId});
		local sum = 0;
		for _, unitId in pairs(self:GetPartyRoster()) do
			tinsert(r.cols, {value = row[unitId]});
			if (row[unitId]) then
				sum = sum + row[unitId];
			end
		end
		tinsert(r.cols, {value = sum});
		tinsert(remappedTableData, r);
	end
	return remappedTableData;
end

--[[--
Update Avoidable Damage-tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:AvoidableDebuffsFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local avoidableDebuffsTableData = self:AvoidableDebuffsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-AVOIDABLE-AURAS");
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.avoidableDebuffsFrame.table:SetData(avoidableDebuffsTableData);
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.avoidableDebuffsFrame.table:SetDisplayCols(self:Table_Headers_GetForSpellsSummary(challengeId));
		self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.avoidableDebuffsFrame.table:SortData();
	end
end
