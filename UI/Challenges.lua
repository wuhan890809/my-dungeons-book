--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local ScrollingTable = LibStub("ScrollingTable");
local AceGUI = LibStub("AceGUI-3.0");

--[[--
Create a frame with table containing challenges with current char.

@param[type=Frame] parentFrame main window frame
@return[type=Frame] table with challenges
]]
function MyDungeonsBook:ChallengesFrame_Create(parentFrame)
	local cols = {
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
			name = L["Dungeon"],
			width = 130,
			align = "LEFT"
		},
		{
			name = L["Time"],
			width = 40,
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
			name = "  " .. L["Affixes"],
			width = 100,
			align = "LEFT"
		},
		{
			name = " ",
			width = 30,
			align = "CENTER"
		}
	};
	local challengesFrame = AceGUI:Create("SimpleGroup");
	challengesFrame:SetLayout("Fill");
	challengesFrame:SetWidth(500);
	challengesFrame:SetFullHeight(true);
	parentFrame:AddChild(challengesFrame);
	local table = ScrollingTable:CreateST(cols, 15, 40, nil, challengesFrame.frame);
	table:SetData(self:ChallengesFrame_GetDataForTable());
	table:SortData();
	table:RegisterEvents({
		OnClick = function (_, _, data, _, _, realrow, column, _, button)
			if (button == "LeftButton" and realrow) then
				local challengeId = data[realrow].cols[1].value;
				if (column == 9) then
					-- Show confirmation modal to delete info about selected challenge
					local dialog = StaticPopup_Show("MDB_CONFIRM_DELETE_CHALLENGE", challengeId);
					if (dialog) then
						dialog.data = challengeId;
					end
				else
					-- Show challenge details
					self:ChallengeDetailsFrame_Show(challengeId);
				end
			end
	    end,
		OnEnter = function (_, cellFrame, data, _, _, realrow, column)
			if (realrow and column ~= 9) then
				self:ChallengesFrame_RowHover(cellFrame, data[realrow].cols[1].value);
			end
	    end,
		OnLeave = function (_, _, _, _, _, realrow)
			if (realrow) then
				self:Table_Cell_MouseOut();
			end
	    end
	});
	table.frame:SetPoint("TOPLEFT", 5, -40);
	return table;
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
		if (duration) then
			duration = duration / 1000;
		end
		GameTooltip:AddLine(string.format(L["Dungeon: %s (+%s)"], zoneName, cmLevel));
		if (damageMod and healthMod) then
			GameTooltip:AddLine(string.format(L["Key damage bonus: %s%%"], damageMod));
			GameTooltip:AddLine(string.format(L["Key HP bonus: %s%%"], healthMod));
		end
		if (maxTime and duration) then
			local saved = maxTime - duration;
			local sign = (saved < 0 and "+") or "-";
			local percents = math.abs(saved / maxTime * 100);
			GameTooltip:AddLine(string.format(L["Time: %s / %s (%s%s) %.1f%%"], date("%M:%S", duration), date("%M:%S", maxTime), sign, date("%M:%S", math.abs(saved)), percents));
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
			if (not deaths) then
				deaths = 0;
                if (challenge.mechanics["DEATHS"]) then
                    for _, unitDeaths in pairs(challenge.mechanics["DEATHS"]) do
                        deaths = deaths + #unitDeaths;
                    end
                end
			end
			local row = {
				cols = {
					{
						value = id
					},
					{
						value = challenge.challengeInfo.startTime or 0
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
						value = self:GetChallengeAffixesIconsStr(id, 20)
					},
					{
						value = "|Tinterface\\raidframe\\readycheck-notready.blp" .. self:GetIconTextureSuffix(16) .. "|t"
					}
				}
			};
			tinsert(tableData, row);
		else
			self:DebugPrint(string.format("Challenge #%s is empty", id));
		end
	end
	return tableData;
end

--[[--
@local
]]
function MyDungeonsBook:FormatCellAsChallengeKeyStatus(_, cellFrame, data, _, _, realrow, column)
	local val = data[realrow].cols[column].value;
	local text = (val > 0 and string.format("|cff1eff00+%s|r", val)) or "|cffcc3333-1|r";
    cellFrame.text:SetText(text);
end
