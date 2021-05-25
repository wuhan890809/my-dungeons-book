--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getAvoidableDebuffsSpellMenu(rows, index, cols)
	local spellId = rows[index].cols[1].value;
	local report = MyDungeonsBook:AvoidableDebuffsFrame_Report_Create(rows[index], cols);
	return {
		MyDungeonsBook:WowHead_Menu_SpellComplex(spellId),
		MyDungeonsBook:Report_Menu(report)
	};
end

--[[--
Create a frame for Avoidable Debuffs tab (data is taken from `mechanics[**-AVOIDABLE-AURAS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:AvoidableDebuffsFrame_Create(parentFrame, challengeId)
	local avoidableDebuffsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local data = self:AvoidableDebuffsFrame_GetDataForTable(challengeId, "PARTY-MEMBERS-AURAS");
	local columns = self:Table_Headers_GetForSpellsSummary(challengeId);
	local table = self:TableWidget_Create(columns, 12, 40, nil, avoidableDebuffsFrame, "avoidable-debuffs");
	table:SetData(data);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getAvoidableDebuffsSpellMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end,
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
	return avoidableDebuffsFrame;
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
		return tableData;
	end
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	if (not mechanics) then
		self:DebugPrint(string.format("No Avoidable Debuffs data for challenge #%s", challengeId));
		return tableData;
	end
	for unitName, auras in pairs(mechanics) do
		for spellId, spellInfo in pairs(auras) do
			if (not tableData[spellId]) then
				tableData[spellId] = {
					spellId = spellId,
					player = 0,
					party1 = 0,
					party2 = 0,
					party3 = 0,
					party4 = 0,
					isAvoidable = false
				};
			end
			local unitId = self:GetPartyUnitByName(challengeId, unitName);
			if (unitId) then
				tableData[spellId][unitId] = spellInfo.meta.hits;
				local isAvoidable = self:IsSpellAvoidableForPartyMember(challengeId, unitId, spellId);
				if (isAvoidable) then
					tableData[spellId].isAvoidable = true;
				end
			end
		end
	end
	local remappedTableData = {};
	for _, row in pairs(tableData) do
		local r = {
			cols = {}
		};
		if (row.isAvoidable) then
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
	end
	return remappedTableData;
end

--[[--
@param[type=table] row
@param[type=table] cols
@return[type=table]
]]
function MyDungeonsBook:AvoidableDebuffsFrame_Report_Create(row, cols)
	local spellLink = GetSpellLink(row.cols[1].value);
	local title = string.format(L["MyDungeonsBook Debuff %s hits:"], spellLink);
	return self:Table_PlayersRow_Report_Create(row, cols, {4, 5, 6, 7, 8, 9}, title);
end
