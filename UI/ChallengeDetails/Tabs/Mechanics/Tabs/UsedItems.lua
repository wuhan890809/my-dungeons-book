--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function getUsedItemMenu(rows, index, cols)
	local itemId = rows[index].cols[1].value;
	local report = MyDungeonsBook:UsedItemsFrame_Report_Create(rows, index, cols);
	return {
		MyDungeonsBook:WowHead_Menu_Item(itemId),
		MyDungeonsBook:Report_Menu(report)
	};
end

--[[--
Create a frame for Used Items tab (data is taken from `mechanics[**-ITEM-USED-BY-PARTY-MEMBERS]`).

Mouse hover/out handler are included.

@param[type=Frame] parentFrame
@return[type=Frame] tableWrapper
]]
function MyDungeonsBook:UsedItemsFrame_Create(parentFrame, challengeId)
	local usedItemsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local data = self:UsedItemsFrame_GetDataForTable(challengeId, self:GetMechanicsPrefixForChallenge(challengeId) .. "-ITEM-USED-BY-PARTY-MEMBERS");
	local columns = self:UsedItemsFrame_GetColumnsForTable(challengeId);
	local table = self:TableWidget_Create(columns, 12, 40, nil, usedItemsFrame, "used-items");
	table:SetData(data);
	table:RegisterEvents({
		OnClick = function(_, _, data, _, _, realrow, _, _, button)
			if (button == "RightButton" and realrow) then
				EasyMenu(getUsedItemMenu(data, realrow, table.cols), self.menuFrame, "cursor", 0 , 0, "MENU");
			end
		end,
		OnEnter = function (_, cellFrame, data, _, _, realrow, column)
			if (realrow) then
				if (column == 2 or column == 3) then
					self:Table_Cell_ItemMouseHover(cellFrame, data[realrow].cols[1].value);
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
	return usedItemsFrame;
end

--[[--
@param[type=table] row
@param[type=table] cols
@return[type=table]
]]
function MyDungeonsBook:UsedItemsFrame_Report_Create(rows, index, cols)
    local row = rows[index];
	local _, itemLink = GetItemInfo(row.cols[1].value);
	local title = string.format(L["MyDungeonsBook %s Usage:"], itemLink);
	return self:Table_PlayersRow_Report_Create(row, cols, {4, 5, 6, 7, 8, 9}, title);
end

--[[--
Depending on `challengeId` real player names will be used or simple placeholders like `player` or `party1..4`.

@param[type=number] challengeId
@return[type=table]
]]
function MyDungeonsBook:UsedItemsFrame_GetColumnsForTable(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	local player = "Player";
	local party1 = "Party1";
	local party2 = "Party2";
	local party3 = "Party3";
	local party4 = "Party4";
	if (challenge) then
		local players = challenge.players;
		player = (players.player.name and self:ClassColorTextByClassIndex(players.player.class, players.player.name)) or L["Not Found"];
		party1 = (players.party1.name and self:ClassColorTextByClassIndex(players.party1.class, players.party1.name)) or L["Not Found"];
		party2 = (players.party2.name and self:ClassColorTextByClassIndex(players.party2.class, players.party2.name)) or L["Not Found"];
		party3 = (players.party3.name and self:ClassColorTextByClassIndex(players.party3.class, players.party3.name)) or L["Not Found"];
		party4 = (players.party4.name and self:ClassColorTextByClassIndex(players.party4.class, players.party4.name)) or L["Not Found"];
	end
	return {
		{
			name = " ",
			width = 1,
			align = "LEFT"
		},
		{
			name = L["Item"],
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsItemIcon(...);
			end
		},
		{
			name = "",
			width = 135,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsItemLink(...);
			end
		},
		{
			name = player,
			width = 70,
			align = "RIGHT"
		},
		{
			name = party1,
			width = 70,
			align = "RIGHT"
		},
		{
			name = party2,
			width = 70,
			align = "RIGHT"
		},
		{
			name = party3,
			width = 70,
			align = "RIGHT"
		},
		{
			name = party4,
			width = 70,
			align = "RIGHT"
		},
		{
			name = L["Sum"],
			width = 50,
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
Map data about Used Items for challenge with id `challengeId`.

@param[type=number] challengeId
@param[type=string] key for mechanics table (it's different for `BFA` and `SL`)
@return[type=table]
]]
function MyDungeonsBook:UsedItemsFrame_GetDataForTable(challengeId, key)
	local tableData = {};
	if (not challengeId) then
		return nil;
	end
	local mechanic = self:Challenge_Mechanic_GetById(challengeId, key);
	if (not mechanic) then
		self:DebugPrint(string.format("No Used Items data for challenge #%s", challengeId));
		return tableData;
	end
	for itemId, usageByPartyMember in pairs(mechanic) do
		local row = {};
		local sum = 0;
		for unitName, numberOfUsages in pairs(usageByPartyMember) do
			local partyUnitId = self:GetPartyUnitByName(challengeId, unitName);
			if (partyUnitId) then
				row[partyUnitId] = numberOfUsages or 0;
				sum = sum + numberOfUsages;
			else
				self:DebugPrint(string.format("%s not found in the challenge party roster", unitName));
			end
		end
		local remappedRow = {
			cols = {
				{value = itemId},
				{value = itemId},
				{value = itemId}
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
