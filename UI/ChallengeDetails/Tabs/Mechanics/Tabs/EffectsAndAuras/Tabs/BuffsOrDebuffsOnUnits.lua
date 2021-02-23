--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local AceGUI = LibStub("AceGUI-3.0");

local key = "ENEMY-UNITS-AURAS";

local function getBuffsAndDebuffsOnUnitsSpellMenu(rows, index, cols, npcFilter, auraFilter, guidFilter)
	local spellId = rows[index].cols[2].value;
	local npcId = rows[index].cols[1].value;
	local guid = rows[index].cols[10].value;
	local report = MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_NpcAuraReport_Create(rows[index], cols);
	local wowheadNpcMenuItem = MyDungeonsBook:WowHead_Menu_Npc(npcId);
	local npcName = (MyDungeonsBook.db.global.meta.npcs[npcId] and MyDungeonsBook.db.global.meta.npcs[npcId].name) or npcId;
	wowheadNpcMenuItem.text = npcName;
	local wowheadSpellMenuItem = MyDungeonsBook:WowHead_Menu_Spell(spellId);
	wowheadSpellMenuItem.text = GetSpellInfo(spellId);
	local wowheadMenuItem = {
		text = L["WowHead"],
		hasArrow = true,
		menuList = {
			wowheadNpcMenuItem,
			wowheadSpellMenuItem
		}
	};
	return {
		wowheadMenuItem,
		MyDungeonsBook:Report_Menu(report),
		{
			text = L["Filters"],
			hasArrow = true,
			menuList = {
				{
					text = npcName,
					func = function()
						if (npcFilter) then
							npcFilter:SetValue(npcId);
							npcFilter:Fire("OnValueChanged", npcId);
						end
					end
				},
				{
					text = GetSpellInfo(spellId),
					func = function()
						if (auraFilter) then
							auraFilter:SetValue(spellId);
							auraFilter:Fire("OnValueChanged", spellId);
						end
					end
				},
				{
					text = L["GUID"],
					func = function()
						if (guidFilter) then
							guidFilter:SetValue(guid);
							guidFilter:Fire("OnValueChanged", guid);
						end
					end
				}
			}
		}
	};
end

--[[--
Create a frame for Buff Or Debuffs On Units tab (data is taken from `mechanics[ENEMY-UNITS-AURAS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_Create(parentFrame, challengeId)
	local buffsOrDebuffsOnUnitsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	self:BuffsOrDebuffsOnUnitsFrame_Filters_Create(buffsOrDebuffsOnUnitsFrame, challengeId);
	local data = self:BuffsOrDebuffsOnUnitsFrame_GetDataForTable(challengeId);
	local columns = self:BuffsOrDebuffsOnUnitsFrame_GetHeadersForTable();
	local table = self:TableWidget_Create(columns, 8, 40, nil, buffsOrDebuffsOnUnitsFrame, "enemy-auras");
	buffsOrDebuffsOnUnitsFrame:SetUserData("buffsOrDebuffsOnUnitsTable", table);
	buffsOrDebuffsOnUnitsFrame:GetUserData("resetFilters"):Fire("OnClick");
	table:SetData(data);
	table:SetSummaryVisible(true);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			local npcFilter = buffsOrDebuffsOnUnitsFrame:GetUserData("npcFilter");
			local auraFilter = buffsOrDebuffsOnUnitsFrame:GetUserData("auraFilter");
			local guidFilter = buffsOrDebuffsOnUnitsFrame:GetUserData("guidFilter");
			if (button == "RightButton" and realrow) then
				EasyMenu(getBuffsAndDebuffsOnUnitsSpellMenu(data, realrow, table.cols, npcFilter, auraFilter, guidFilter), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end,
		OnEnter = function (_, cellFrame, data, _, _, realrow, column)
			if (realrow) then
				if (column == 4 or column == 5) then
					self:Table_Cell_SpellMouseHover(cellFrame, data[realrow].cols[2].value);
				end
			end
		end,
		OnLeave = function (_, _, _, _, _, realrow, column)
			if (realrow) then
				if (column == 4 or column == 5) then
					self:Table_Cell_MouseOut();
				end
			end
		end
	});
	table:SetFilter(function(_, row)
		-- NPC
		local npcFilter = self.db.char.filters.unitAuras.npc;
		if (npcFilter ~= "ALL") then
			local npc = row.cols[1].value;
			if (npc ~= npcFilter) then
				return false;
			end
		end
		-- Aura
		local auraFilter = self.db.char.filters.unitAuras.aura;
		if (auraFilter ~= "ALL") then
			local aura = row.cols[2].value;
			if (aura ~= auraFilter) then
				return false;
			end
		end
		-- GUID
		local guidFilter = self.db.char.filters.unitAuras.guid;
		if (guidFilter ~= "ALL") then
			local guid = row.cols[10].value;
			if (guid ~= guidFilter) then
				return false;
			end
		end
		return true;
	end);
	table.frame:SetPoint("TOPLEFT", 0, -130);
	return buffsOrDebuffsOnUnitsFrame;
end

--[[--
@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_Filters_Create(parentFrame, challengeId)
	local filtersFrame = AceGUI:Create("InlineGroup");
	filtersFrame:SetFullWidth(true);
	filtersFrame:SetWidth(500);
	filtersFrame:SetTitle("Filters");
	filtersFrame:SetLayout("Flow");
	parentFrame:AddChild(filtersFrame);

	local npcFilterOptions = {["ALL"] = L["All"]};
	local auraFilterOptions = {["ALL"] = L["All"]};
	local guidFilterOptions = {["ALL"] = L["All"]};
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	for unitGUID, unitInfo in pairs(mechanics) do
		local npcId = self:GetNpcIdFromGuid(unitGUID);
		if (npcId) then
			guidFilterOptions[unitGUID] = self:FormatGuid(unitGUID, "SHORT");
			npcFilterOptions[npcId] = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
			for spellId, _ in pairs(unitInfo) do
				auraFilterOptions[spellId] = GetSpellInfo(spellId);
			end
		end
	end

	-- NPC filter
	local npcFilter = AceGUI:Create("Dropdown");
	npcFilter:SetWidth(200);
	npcFilter:SetLabel(L["NPC"]);
	npcFilter:SetList(npcFilterOptions);
	npcFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
		self.db.char.filters.unitAuras.npc = filterValue;
		parentFrame:GetUserData("buffsOrDebuffsOnUnitsTable"):SortData();
	end);
	filtersFrame:AddChild(npcFilter);
	parentFrame:SetUserData("npcFilter", npcFilter);
	-- Aura filter
	local auraFilter = AceGUI:Create("Dropdown");
	auraFilter:SetWidth(200);
	auraFilter:SetValue(self.db.char.filters.unitAuras.aura);
	auraFilter:SetLabel(L["Aura"]);
	auraFilter:SetList(auraFilterOptions);
	auraFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
		self.db.char.filters.unitAuras.aura = filterValue;
		parentFrame:GetUserData("buffsOrDebuffsOnUnitsTable"):SortData();
	end);
	filtersFrame:AddChild(auraFilter);
	parentFrame:SetUserData("auraFilter", auraFilter);
	-- GUID filter
	local guidFilter = AceGUI:Create("Dropdown");
	guidFilter:SetWidth(120);
	guidFilter:SetLabel(L["GUID"]);
	guidFilter:SetList(guidFilterOptions);
	guidFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
		self.db.char.filters.unitAuras.guid = filterValue;
		parentFrame:GetUserData("buffsOrDebuffsOnUnitsTable"):SortData();
	end);
	filtersFrame:AddChild(guidFilter);
	parentFrame:SetUserData("guidFilter", guidFilter);
	-- Reset filters
	local resetFilters = AceGUI:Create("Button");
	resetFilters:SetText(L["Reset"]);
	resetFilters:SetWidth(90);
	resetFilters:SetCallback("OnClick", function()
		self.db.char.filters.unitAuras.npc = "ALL";
		self.db.char.filters.unitAuras.aura = "ALL";
		self.db.char.filters.unitAuras.guid = "ALL";
		parentFrame:GetUserData("auraFilter"):SetValue("ALL");
		parentFrame:GetUserData("npcFilter"):SetValue("ALL");
		parentFrame:GetUserData("guidFilter"):SetValue("ALL");
		parentFrame:GetUserData("buffsOrDebuffsOnUnitsTable"):SortData();
	end);
	parentFrame:SetUserData("resetFilters", resetFilters);
	filtersFrame:AddChild(resetFilters);
	return filtersFrame;
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
			width = 30,
			align = "RIGHT"
		},
		{
			name = L["Max Stacks"],
			width = 75,
			align = "RIGHT"
		},
		{
			name = L["GUID"],
			width = 75,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsGuid("SHORT", ...);
			end
		}
	};
end

--[[--
Map data about Buff Or Debuffs On Units for challenge with id `challengeId`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_GetDataForTable(challengeId)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	local mechanics = self:Challenge_Mechanic_GetById(challengeId, key);
	if (not mechanics) then
		self:DebugPrint(string.format("No Buff Or Debuffs On Units data for challenge #%s", challengeId));
		return tableData;
	end
	for unitGUID, unitInfo in pairs(mechanics) do
		if (unitGUID) then
			local npcId = self:GetNpcIdFromGuid(unitGUID);
			if (npcId) then
				for spellId, spellInfo in pairs(unitInfo) do
					local row = {
						cols = {
							{ value = npcId },
							{ value = spellId },
							{ value = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId },
							{ value = spellId },
							{ value = spellId },
							{ value = (self.db.global.meta.spells[spellId] and self.db.global.meta.spells[spellId].auraType) or "???" },
							{ value = (spellInfo.meta.duration and spellInfo.meta.duration * 1000) or "-" },
							{ value = spellInfo.meta.hits },
							{ value = spellInfo.meta.maxAmount },
							{ value = unitGUID }
						}
					};
					tinsert(tableData, row);
				end
			end
		end
	end
	return tableData;
end

--[[--
@param[type=table] row
@param[type=table] cols
@return[type=table]
]]
function MyDungeonsBook:BuffsOrDebuffsOnUnitsFrame_NpcAuraReport_Create(row, cols)
	local spellId = row.cols[2].value;
	local npcId = row.cols[1].value;
	local npcName = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
	local auraType = (self.db.global.meta.spells[spellId] and self.db.global.meta.spells[spellId].auraType) or "???";
	local msgFormat = "%s: %s";
	local report = {};
	tinsert(report, string.format(L["MyDungeonsBook %s %s for %s"], auraType, GetSpellLink(spellId), npcName));
	tinsert(report, string.format(msgFormat, cols[7].name, self:FormatTime(row.cols[7].value)));
	tinsert(report, string.format(msgFormat, cols[8].name, row.cols[8].value));
	tinsert(report, string.format(msgFormat, cols[9].name, row.cols[9].value));
	return report;
end
