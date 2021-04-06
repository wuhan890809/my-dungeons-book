--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getOwnSpellMenu(rows, index, cols)
	local spellId = rows[index].cols[1].value;
	local report = MyDungeonsBook:SpecialCastsFrame_Report_Create(rows[index], cols);
	return {
		MyDungeonsBook:WowHead_Menu_Spell(spellId),
		MyDungeonsBook:Report_Menu(report)
	};
end

--[[--
Create a frame for Special Casts tab (data is taken from `mechanics[**-CASTS-DONE-BY-PARTY-MEMBERS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:SpecialCastsFrame_Create(parentFrame, challengeId)
	local specialCastsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local data = self:SpecialCastsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-CASTS-DONE-BY-PARTY-MEMBERS");
	local columns = self:Table_Headers_GetForSpellsSummary(challengeId);
	local table = self:TableWidget_Create(columns, 12, 40, nil, specialCastsFrame, "special-casts-by-party-members");
	table:SetData(data);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getOwnSpellMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
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
	return specialCastsFrame;
end

--[[--
Map data about Special Casts for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for `BFA` and `SL`)
@return[type=table]
]]
function MyDungeonsBook:SpecialCastsFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	if (not mechanics) then
		self:DebugPrint(string.format("No Special Casts data for challenge #%s", challengeId));
		return tableData;
	end
	for spellId, castsByPartyMember in pairs(mechanics) do
		local row = {};
		local sum = 0;
		for unitName, numberOfCasts in pairs(castsByPartyMember) do
			local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
			if (partyUnitId) then
				row[partyUnitId] = numberOfCasts or 0;
				sum = sum + numberOfCasts;
			else
				self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
			end
		end
		local remappedRow = {
			cols = {
				{value = spellId},
				{value = spellId},
				{value = spellId}
			}
		};
		for _, unitId in pairs(self:GetPartyRoster()) do
			tinsert(remappedRow.cols, {
				value = row[unitId] or 0
			});
		end
		tinsert(remappedRow.cols, {
			value = sum
		});
		tinsert(tableData, remappedRow);
	end
	return tableData;
end

--[[--
@param[type=table] row
@param[type=table] cols
@return[type=table]
]]
function MyDungeonsBook:SpecialCastsFrame_Report_Create(row, cols)
	local spellLink = GetSpellLink(row.cols[1].value);
	local title = string.format(L["MyDungeonsBook %s Casts:"], spellLink);
	return self:Table_PlayersRow_Report_Create(row, cols, {4, 5, 6, 7, 8, 9}, title);
end
