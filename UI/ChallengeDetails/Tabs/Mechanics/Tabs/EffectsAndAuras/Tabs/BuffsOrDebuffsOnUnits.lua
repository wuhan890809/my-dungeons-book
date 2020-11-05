--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Create a frame for Buff Or Debuffs On Units tab (data is taken from `mechanics[**-BUFFS-OR-DEBUFFS-ON-UNIT]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_Create(parentFrame, challengeId)
	local buffsOrDebuffsOnUnitsFrame, descriptionLabel = self:TabContentWrapperWidget_Create(parentFrame);
	descriptionLabel:SetText(L["List of important buffs and debuffs thay may appear on enemy units."]);
	local data = self:BuffsOrDebuffsOnUnitsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-BUFFS-OR-DEBUFFS-ON-UNIT");
	local columns = self:BuffsOrDebuffsOnUnitsFrame_GetHeadersForTable();
	local table = self:TableWidget_Create(columns, 10, 40, nil, buffsOrDebuffsOnUnitsFrame, "buffs-or-debuffs-on-units");
	table:SetData(data);
	table.frame:SetPoint("TOPLEFT", 0, -70);
	table:RegisterEvents({
		OnEnter = function (_, cellFrame, data, _, _, realrow, column)
			if (realrow) then
				if (column == 3 or column == 4) then
					self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[1].value);
				end
			end
		end,
		OnLeave = function (_, _, _, _, _, realrow, column)
			if (realrow) then
				if (column == 3 or column == 4) then
					self:Table_Cell_MouseOut();
				end
			end
		end
	});
	return buffsOrDebuffsOnUnitsFrame;
end

--[[--
Generate columns for Buff Or Debuffs On Units table.

Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`.

@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_GetHeadersForTable()
	return {
		{
			name = " ",
			width = 1,
			align = "LEFT"
		},
		{
			name = L["Spell"],
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellIcon(...);
			end
		},
		{
			name = "",
			width = 160,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellLink(...);
			end
		},
		{
			name = L["Count"],
			width = 80,
			align = "RIGHT",
			sort = "dsc",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			}
		}
	};
end

--[[--
Map data about Buff Or Debuffs On Units for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for `BFA` and `SL`)
@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	if (not self.db.char.challenges[challengeId].mechanics[key]) then
		self:DebugPrint(string.format("No Buff Or Debuffs On Units data for challenge #%s", challengeId));
		return tableData;
	end
	for spellId, buffsOrDebuffsOnUnit in pairs(self.db.char.challenges[challengeId].mechanics[key]) do
		local sum = 0;
		for _, count in pairs(buffsOrDebuffsOnUnit) do
			sum = sum + count;
		end
		local row = {
			cols = {
				{value = spellId},
				{value = spellId},
				{value = spellId},
				{value = sum}
			}
		};
		tinsert(tableData, row);
	end
	return tableData;
end
