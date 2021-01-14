--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getBuffsAndDebuffsOnUnitsSpellMenu(spellId)
	return {
		MyDungeonsBook:WowHead_Menu_Spell(spellId)
	};
end

--[[--
Create a frame for Buff Or Debuffs On Units tab (data is taken from `mechanics[**-BUFFS-OR-DEBUFFS-ON-UNIT]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_Create(parentFrame, challengeId)
	local buffsOrDebuffsOnUnitsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	-- local data = self:BuffsOrDebuffsOnUnitsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-BUFFS-OR-DEBUFFS-ON-UNIT");
	local data = self:BuffsOrDebuffsOnUnitsFrame_GetDataForTable(challengeId, "ENEMY-AURAS");
	local columns = self:BuffsOrDebuffsOnUnitsFrame_GetHeadersForTable();
	local table = self:TableWidget_Create(columns, 11, 40, nil, buffsOrDebuffsOnUnitsFrame, "enemy-auras");
	table:SetData(data);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getBuffsAndDebuffsOnUnitsSpellMenu(data[realrow].cols[1].value), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end,
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
			name = L["NPC"],
			width = 150,
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
			name = L["Type"],
			width = 60,
			align = "LEFT"
		},
		{
			name = L["Time"],
			width = 40,
			align = "RIGHT",
			sort = "asc",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsTime(...);
			end
		},
		{
			name = L["Hits"],
			width = 40,
			align = "RIGHT"
		},
		{
			name = L["Max Stacks"],
			width = 40,
			align = "RIGHT"
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
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	if (not mechanics) then
		self:DebugPrint(string.format("No Buff Or Debuffs On Units data for challenge #%s", challengeId));
		return tableData;
	end
	for npcId, units in pairs(mechanics) do
		for _, unit in pairs(units) do
			for spellId, spellInfo in pairs(unit) do
				local row = {
					cols = {
						{value = spellId},
						{value = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId},
						{value = spellId},
						{value = spellId},
						{value = (self.db.global.meta.spells[spellId] and self.db.global.meta.spells[spellId].auraType) or "???"},
						{value = (spellInfo.duration  and spellInfo.duration * 1000) or "-"},
						{value = spellInfo.hits},
						{value = spellInfo.maxAmount}
					}
				};
				tinsert(tableData, row);
			end
		end
	end
	return tableData;
end
