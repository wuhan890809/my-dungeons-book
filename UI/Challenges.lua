--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local ScrollingTableMdb = LibStub("ScrollingTableMdb");
local AceGUI = LibStub("AceGUI-3.0");

local function getChallengesMenu(rows, index, cols)
	local challengeId = rows[index].cols[1].value;
	local report = MyDungeonsBook:ChallengesFrame_Challenge_Menu_Summary(rows[index], cols);
	return {
		MyDungeonsBook:ChallengesFrame_Challenge_Menu_Delete(challengeId),
		MyDungeonsBook:Report_Menu(report)
	};
end

--[[--
Create a frame with table containing challenges with current char.

@param[type=Frame] parentFrame main window frame
@return[type=Frame] table with challenges
]]
function MyDungeonsBook:ChallengesFrame_Create(parentFrame)
	local challengesFrame = AceGUI:Create("SimpleGroup");
	challengesFrame:SetLayout("Flow");
	challengesFrame:SetWidth(500);
	challengesFrame:SetFullHeight(true);
	parentFrame:AddChild(challengesFrame);
	local filtersFrame = self:ChallengesFrame_Filters_Create(challengesFrame);
	local table = self:ChallengesFrame_Table_Create(challengesFrame);
	return table, filtersFrame;
end

--[[--
Create a table with Challenges.

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:ChallengesFrame_Table_Create(parentFrame)
	local table = ScrollingTableMdb:CreateST(self:ChallengesFrame_GetColumnsForTable(), 12, 40, {r = 1.0, g = 0.9, b = 0.0, a = 0.5}, parentFrame.frame);
	table:EnableSelection(true);
	table:SetData(self:ChallengesFrame_GetDataForTable());
	table:SetSummaryVisible(true);
	table:SortData();
	table:RegisterEvents({
		OnClick = function (_, _, data, _, _, realrow, column, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getChallengesMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
			if (button == "LeftButton" and realrow) then
				local challengeId = data[realrow].cols[1].value;
				-- Show challenge details
				self:ChallengeDetailsFrame_Show(challengeId);
			end
		end,
		OnEnter = function (_, cellFrame, data, _, _, realrow, column)
			if (realrow and column ~= 11) then
				self:ChallengesFrame_RowHover(cellFrame, data[realrow].cols[1].value);
			end
		end,
		OnLeave = function (_, _, _, _, _, realrow)
			if (realrow) then
				self:Table_Cell_MouseOut();
			end
		end
	});
	table:SetFilter(function(_, row)
		-- In Time or Not
		local inTimeFilter = self.db.char.filters.challenges.inTime;
		if (inTimeFilter ~= "ALL") then
			local inTime = row.cols[7].value;
			if (
				(inTimeFilter == "-1" and inTime ~= -1) or
				(inTimeFilter == "T" and inTime == -1) or
				(inTimeFilter == "+1" and inTime ~= 1) or
				(inTimeFilter == "+2" and inTime ~= 2) or
				(inTimeFilter == "+3" and inTime ~= 3)
			) then
				return false;
			end
		end
		-- Key level
		local keyLevelFilter = self.db.char.filters.challenges.keyLevel;
		if (keyLevelFilter ~= "ALL") then
			local keyLevel = row.cols[6].value;
			if (
				(keyLevelFilter == "1-4" and (keyLevel > 4 or keyLevel < 1)) or
				(keyLevelFilter == "5-9" and (keyLevel > 9 or keyLevel < 5)) or
				(keyLevelFilter == "10-14" and (keyLevel > 14 or keyLevel < 10)) or
				(keyLevelFilter == "15-19" and (keyLevel > 19 or keyLevel < 15)) or
				(keyLevelFilter == "20-24" and (keyLevel > 24 or keyLevel < 20)) or
				(keyLevelFilter == "25-29" and (keyLevel > 29 or keyLevel < 25)) or
				(keyLevelFilter == "30+" and (keyLevel < 30))
			) then
				return false;
			end
		end
		-- Dungeon
		local dungeonFilter = self.db.char.filters.challenges.dungeon;
		if (dungeonFilter ~= "ALL") then
			local dungeon = row.cols[3].value;
			if (dungeon ~= dungeonFilter) then
				return false;
			end
		end
		-- Affixes
		local affixesFilter = self.db.char.filters.challenges.affixes;
		if (affixesFilter ~= "ALL") then
			local affixes = row.cols[9].value;
			if (not self:TableContainsValue(affixes, affixesFilter)) then
				return false;
			end
		end
		-- Deaths
		local deathsFilter = self.db.char.filters.challenges.deaths;
		if (deathsFilter ~= "ALL") then
			local deaths = row.cols[8].value;
			if (type(deaths) ~= "number") then
				return false;
			end
			if (
				(deathsFilter == "0" and deaths ~= 0) or
				(deathsFilter == "1-5" and (deaths > 5 or deaths < 1)) or
				(deathsFilter == "6-10" and (deaths > 10 or deaths < 6)) or
				(deathsFilter == "11-15" and (deaths > 15 or deaths < 11)) or
				(deathsFilter == "16-20" and (deaths > 20 or deaths < 16)) or
				(deathsFilter == "21-25" and (deaths > 25 or deaths < 21)) or
				(deathsFilter == "26+" and deaths < 26)
			) then
				return false;
			end
		end
		-- Current Week
		local currentWeekFilter = self.db.char.filters.challenges.currentWeek;
		if (currentWeekFilter) then
			local affixes = row.cols[9].value;
			local startTime = row.cols[2].value;
			local currentWeekaffixes = C_MythicPlus.GetCurrentAffixes();
			if (affixes[1] ~= currentWeekaffixes[1].id or
				affixes[2] ~= currentWeekaffixes[2].id or
				affixes[3] ~= currentWeekaffixes[3].id or
				affixes[4] ~= currentWeekaffixes[4].id or
				time() - startTime > 7 * 24 * 60 * 60) then
				return false;
			end
		end
		return true;
	end);
	table.frame:SetPoint("TOPLEFT", 5, -180);
	return table;
end

--[[--
Create frame with filters for table with Challenges.

Filters are next:

* In time or not
* By key level
* By dungeon
* By deaths count
* By affixes

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:ChallengesFrame_Filters_Create(parentFrame)
	local filtersFrame = AceGUI:Create("InlineGroup");
	filtersFrame:SetWidth(500);
	filtersFrame:SetTitle(L["Filters"]);
	filtersFrame:SetLayout("Flow");
	parentFrame:AddChild(filtersFrame);
	-- In Time filter
	local inTimeFilter = AceGUI:Create("Dropdown");
	inTimeFilter:SetWidth(100);
	inTimeFilter:SetList({
		["ALL"] = L["All"],
		["-1"] = L["Not In Time"],
		["T"] = L["In Time"],
		["+1"] = "+1",
		["+2"] = "+2",
		["+3"] = "+3"
	}, {"ALL", "-1", "T", "+1", "+2", "+3"});
	inTimeFilter:SetValue(self.db.char.filters.challenges.inTime);
	inTimeFilter:SetLabel(L["Result"]);
	inTimeFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
		self.db.char.filters.challenges.inTime = filterValue;
		self.challengesTable:SortData();
	end);
	filtersFrame:AddChild(inTimeFilter);
	-- Key level filter
	local keyFilter = AceGUI:Create("Dropdown");
	keyFilter:SetWidth(100);
	keyFilter:SetList({
		["ALL"] = L["All"],
		["1-4"] = "1 - 4",
		["5-9"] = "5 - 9",
		["10-14"] = "10 - 14",
		["15-19"] = "15 - 19",
		["20-24"] = "20 - 24",
		["25-29"] = "25 - 29",
		["30+"] = "30+",
	}, {"ALL", "1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30+"});
	keyFilter:SetValue(self.db.char.filters.challenges.keyLevel);
	keyFilter:SetLabel(L["Key"]);
	keyFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
		self.db.char.filters.challenges.keyLevel = filterValue;
		self.challengesTable:SortData();
	end);
	filtersFrame:AddChild(keyFilter);
	-- Dungeon filter
	local dungeonFilter = AceGUI:Create("Dropdown");
	dungeonFilter:SetWidth(220);
	local challengeFilterOptions = {["ALL"] = L["All"]};
	for _, challenge in pairs(self.db.char.challenges) do
		if (challenge and challenge.challengeInfo and challenge.challengeInfo.currentMapId and challenge.challengeInfo.zoneName) then
			challengeFilterOptions[challenge.challengeInfo.currentMapId] = challenge.challengeInfo.zoneName;
		end
	end
	dungeonFilter:SetList(challengeFilterOptions);
	dungeonFilter:SetLabel(L["Dungeon"]);
	if (challengeFilterOptions[self.db.char.filters.challenges.dungeon]) then
		dungeonFilter:SetValue(self.db.char.filters.challenges.dungeon);
	else
		dungeonFilter:SetValue("ALL");
	end
	dungeonFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
		self.db.char.filters.challenges.dungeon = filterValue;
		self.challengesTable:SortData();
	end);
	filtersFrame:AddChild(dungeonFilter);
	-- Affixes filter
	local affixesFilter = AceGUI:Create("Dropdown");
	affixesFilter:SetWidth(130);
	affixesFilter:SetList({
		[9] = L["Tyrannical"],
		[10] = L["Fortified"],
		["ALL"] = L["All"]
	}, {"ALL", 9, 10});
	affixesFilter:SetValue(self.db.char.filters.challenges.affixes);
	affixesFilter:SetLabel(L["Affixes"]);
	affixesFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
		self.db.char.filters.challenges.affixes = filterValue;
		self.challengesTable:SortData();
	end);
	filtersFrame:AddChild(affixesFilter);
	-- Deaths filter
	local deathsFilter = AceGUI:Create("Dropdown");
	deathsFilter:SetWidth(100);
	deathsFilter:SetList({
		["ALL"] = L["All"],
		["0"] = "0",
		["1-5"] = "1 - 5",
		["6-10"] = "6 - 10",
		["11-15"] = "11 - 15",
		["16-20"] = "16 - 20",
		["21-25"] = "21 - 25",
		["26+"] = "26+"
	}, {"ALL", "0", "1-5", "6-10", "11-15", "16-20", "21-25", "26+"});
	deathsFilter:SetValue(self.db.char.filters.challenges.affixes);
	deathsFilter:SetLabel(L["Deaths"]);
	deathsFilter:SetCallback("OnValueChanged", function (_, _, filterValue)
		self.db.char.filters.challenges.deaths = filterValue;
		self.challengesTable:SortData();
	end);
	filtersFrame:AddChild(deathsFilter);
	-- Current Week
	local currentWeekFilter = AceGUI:Create("CheckBox");
	currentWeekFilter:SetLabel(L["This week"]);
	currentWeekFilter:SetWidth(100);
	currentWeekFilter:SetValue(self.db.char.filters.challenges.currentWeek);
	currentWeekFilter:SetCallback("OnValueChanged", function(_, _, newValue)
		self.db.char.filters.challenges.currentWeek = newValue;
		self.challengesTable:SortData();
	end);
	filtersFrame:AddChild(currentWeekFilter);
	-- Reset filters
	local resetFilters = AceGUI:Create("Button");
	resetFilters:SetText(L["Reset"]);
	resetFilters:SetWidth(90);
	resetFilters:SetCallback("OnClick", function()
		self.db.char.filters.challenges.dungeon = "ALL";
		self.db.char.filters.challenges.keyLevel = "ALL";
		self.db.char.filters.challenges.inTime = "ALL";
		self.db.char.filters.challenges.affixes = "ALL";
		self.db.char.filters.challenges.deaths = "ALL";
		self.db.char.filters.challenges.currentWeek = false;
		dungeonFilter:SetValue("ALL");
		keyFilter:SetValue("ALL");
		inTimeFilter:SetValue("ALL");
		affixesFilter:SetValue("ALL");
		deathsFilter:SetValue("ALL");
        currentWeekFilter:SetValue(false);
		self.challengesTable:SortData();
	end);
	filtersFrame:AddChild(resetFilters);
	return filtersFrame;
end

--[[--
Mouse-hover handler for rows in the challenges table.

@param[type=Frame] tableCellFrame
@param[type=number] challengeId
]]
function MyDungeonsBook:ChallengesFrame_RowHover(tableCellFrame, challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		GameTooltip:SetOwner(tableCellFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", tableCellFrame, "BOTTOMRIGHT");
		local zoneName = challenge.challengeInfo.zoneName;
		local cmLevel = challenge.challengeInfo.cmLevel;
		local timeLost = challenge.challengeInfo.timeLost or 0;
		local damageMod = challenge.challengeInfo.damageMod;
		local healthMod = challenge.challengeInfo.healthMod;
		local maxTime = challenge.challengeInfo.maxTime;
		local duration = challenge.challengeInfo.duration;
		GameTooltip:AddLine(string.format(L["Dungeon: %s (+%s)"], zoneName, cmLevel));
		if (damageMod and healthMod) then
			GameTooltip:AddLine(string.format(L["Key damage bonus: %s%%"], damageMod));
			GameTooltip:AddLine(string.format(L["Key HP bonus: %s%%"], healthMod));
		end
		if (maxTime and duration) then
			local saved = maxTime - duration / 1000;
			local sign = (saved < 0 and "+") or "-";
			local percents = math.abs(saved / maxTime * 100);
			GameTooltip:AddLine(string.format(L["Time: %s / %s (%s%s) %.1f%%"], self:FormatTime(duration), date("%M:%S", maxTime), sign, date("%M:%S", math.abs(saved)), percents));
		end
		GameTooltip:AddLine(string.format(L["Time lost: %ss"], timeLost));
		GameTooltip:Show();
	end
end

--[[--
Map challenges info into the table rows.

@return[type=table]
]]
function MyDungeonsBook:ChallengesFrame_GetDataForTable()
	local tableData = {};
	for id, challenge in pairs(self.db.char.challenges) do
		if (challenge and next(challenge) ~= nil) then
			local deaths = challenge.challengeInfo.numDeaths;
			local row = {
				cols = {
					{
						value = id
					},
					{
						value = challenge.challengeInfo.startTime or 0
					},
					{
						value = challenge.challengeInfo.currentMapId
					},
					{
						value = challenge.challengeInfo.zoneName or ""
					},
					{
						value = challenge.challengeInfo.duration or 0
					},
					{
						value = challenge.challengeInfo.cmLevel or 0
					},
					{
						value = (challenge.challengeInfo.onTime and challenge.challengeInfo.keystoneUpgradeLevels) or -1
					},
					{
						value = deaths or "-"
					},
					{
						value = challenge.challengeInfo.affixes
					},
					{
						value = self:GetChallengeAffixesIconsStr(id, 20)
					}
				}
			};
			tinsert(tableData, row);
		end
	end
	return tableData;
end

--[[--
Create a column definitions for table with Challenges.

@return[type=table]
]]
function MyDungeonsBook:ChallengesFrame_GetColumnsForTable()
	return {
		{
			-- First column is for challenge ID used on row's click-handler to show details for selected challenge
			name = "",
			width = 1,
			align = "LEFT"
		},
		{
			name = L["Date"],
			width = 75,
			align = "LEFT",
			sort = "asc",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsDate(...);
			end
		},
		{
			name = " ",
			width = 1,
			align = "LEFT"
		},
		{
			name = L["Dungeon"],
			width = 110,
			align = "LEFT"
		},
		{
			name = L["Time"],
			width = 55,
			align = "CENTER",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsTime(...);
			end,
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
		},
		{
			name = L["Key"],
			width = 35,
			align = "RIGHT"
		},
		{
			name = "",
			width = 30,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:FormatCellAsChallengeKeyStatus(...)
			end
		},
		{
			name = "|Tinterface\\targetingframe\\ui-raidtargetingicon_8:12|t",
			width = 20,
			align = "CENTER",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
		},
		{
			name = " ",
			width = 1,
			align = "LEFT"
		},
		{
			name = "  " .. L["Affixes"],
			width = 130,
			align = "LEFT"
		}
	};
end

--[[--
@local
]]
function MyDungeonsBook:FormatCellAsChallengeKeyStatus(_, cellFrame, data, _, _, realrow, column)
	local val = data[realrow].cols[column].value;
	local text = (val > 0 and string.format("|cff1eff00+%s|r", val)) or "|cffcc3333-1|r";
    cellFrame.text:SetText(text);
end

--[[--
@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:ChallengesFrame_Challenge_Menu_Delete(challengeId)
	return {
		text = L["Delete"],
		func = function()
			-- Show confirmation modal to delete info about selected challenge
			local dialog = StaticPopup_Show("MDB_CONFIRM_DELETE_CHALLENGE", challengeId);
			if (dialog) then
				dialog.data = challengeId;
			end
		end
	};
end

--[[--
@param[type=table] row
@param[type=table] cols
@param[type=number] challengeId
@param[type=unitId] unitId
@return[type=table]
]]
function MyDungeonsBook:ChallengesFrame_Challenge_Menu_Summary(row, cols)
	local report = {};
	local msgFormat = "%s: %s";
	tinsert(report, string.format(L["MyDungeonsBook Challenge summary for %s:"], row.cols[4].value));
	tinsert(report, string.format(msgFormat, cols[2].name, string.gsub(self:FormatDate(row.cols[2].value), "\n", " ")));
	tinsert(report, string.format(msgFormat, cols[5].name, self:FormatTime(row.cols[5].value)));
	local result = row.cols[7].value;
	tinsert(report, string.format("%s: %s (%s)", cols[6].name, row.cols[6].value, (result > 0 and "+" .. result) or result));
	tinsert(report, string.format(msgFormat, L["Deaths"], row.cols[8].value));
	return report;
end
