--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Utils
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function updateCellTextColor(_, cellFrame, data, cols, _, realrow, column)
	local defaultColor = {
		r = 1,
		g = 1,
		b = 1,
		a = 1
	};
	local celldata = data[realrow].cols[column];
	local color;
	if (type(celldata) == "table") then
		color = celldata.color;
	end

	if (not color) then
		color = cols[column].color;
		if (not color) then
			color = data[realrow].color;
		end
	end
	if (not color) then
		color = defaultColor;
    end
    if (cellFrame.text) then
        cellFrame.text:SetTextColor(color.r, color.g, color.b, color.a);
    else
        cellFrame:SetColor(color.r, color.g, color.b);
    end
end

--[[--
Wrapper for cells with formatted numbers. Uses `MyDungeonsBook:FormatNumber` to format cell value.

Original value (number) is left "as is" for sorting purposes.

Params are similar to [ScrollingTable:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsNumber(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
    (cellFrame.text or cellFrame):SetText((val and self:FormatNumber(val)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with formatted percents. Uses `MyDungeonsBook:FormatPercents` to format cell value.

Original value (number) is left "as is" for sorting purposes.

Params are similar to [ScrollingTable:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsPercents(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	(cellFrame.text or cellFrame):SetText((val and self:FormatPercents(val)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with formatted date.

Original value (timestamp) is left "as is" for sorting purposes.

Params are similar to [ScrollingTable:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsDate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	local dateFormat = self.db.profile.display.dateFormat;
    (cellFrame.text or cellFrame):SetText((val and date(dateFormat, val)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with formatted time (time should be in milliseconds!).

Original value (number) is left "as is" for sorting purposes.

Params are similar to [ScrollingTable:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsTime(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	local timeFormat = self.db.profile.display.timeFormat;
    (cellFrame.text or cellFrame):SetText((val > 0 and date(timeFormat, val / 1000)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with spell icon.

Original value (spell ID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTable:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsSpellIcon(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local spellId = data[realrow].cols[column].value;
	local suffix = self:GetIconTextureSuffix(30);
	if (spellId) then
		if (spellId == -2) then
			-- Hack to show "fist" icon for swing dmg
			local itemIcon = "|T999951" .. suffix .. "|t";
			(cellFrame.text or cellFrame):SetText(itemIcon);
		else
			if (spellId > 0) then
				local _, _, icon = GetSpellInfo(spellId);
				local spellIcon = "|T" .. (icon or "") .. suffix .. "|t";
				(cellFrame.text or cellFrame):SetText(spellIcon);
			else
				(cellFrame.text or cellFrame):SetText("");
			end
		end
	else
		(cellFrame.text or cellFrame):SetText("");
	end
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with spell link.

Original value (spell ID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTable:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsSpellLink(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local spellId = data[realrow].cols[column].value;
	if (spellId) then
		if (spellId == -2) then
			local cellText = L["Swing Damage"];
			if (data[realrow].meta and data[realrow].meta.unitName) then
				cellText = string.format("%s (%s)", cellText, data[realrow].meta.unitName);
			end
			(cellFrame.text or cellFrame):SetText(cellText);
		else
			if (spellId == -1) then
				(cellFrame.text or cellFrame):SetText(L["Sum"]);
			else
				if (spellId > 0) then
					local cellText = GetSpellLink(spellId);
					if (data[realrow].meta and data[realrow].meta.unitName) then
						cellText = string.format("%s (%s)", cellText, data[realrow].meta.unitName);
					end
					(cellFrame.text or cellFrame):SetText(cellText);
				else
					(cellFrame.text or cellFrame):SetText("");
				end
			end
		end
	else
		(cellFrame.text or cellFrame):SetText("");
	end
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with spell icon.

Original value (spell ID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTable:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsItemIcon(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local itemId = data[realrow].cols[column].value;
	local suffix = self:GetIconTextureSuffix(30);
	if (itemId and itemId > 0) then
		local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemId);
		local itemIcon = "|T" .. (icon or "") .. suffix .. "|t";
		(cellFrame.text or cellFrame):SetText(itemIcon);
	else
		(cellFrame.text or cellFrame):SetText("");
	end
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with spell link.

Original value (spell ID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTable:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsItemLink(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local itemId = data[realrow].cols[column].value;
	if (itemId and itemId > 0) then
		local _, itemLink = GetItemInfo(itemId);
		(cellFrame.text or cellFrame):SetText(itemLink);
	else
		(cellFrame.text or cellFrame):SetText("");
	end
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Default handler for mouse out event for table cells.

Just hide tooltip.

It can be used for any `OnLeave` if some tooltip should be hidden.
]]
function MyDungeonsBook:Table_Cell_MouseOut()
	if (GameTooltip) then
		GameTooltip:Hide();
	end
end

--[[--
Show "default" tooltip for spell with ID `spellId`. Tooltip is placed on the right of the frame `cellFrame`.

@param[type=Frame] cellFrame
@param[type=number] spellId
]]
function MyDungeonsBook:Table_Cell_SpellMouseHover(cellFrame, spellId)
	if (spellId and spellId > 0) then
		GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", cellFrame, "BOTTOMRIGHT");
		GameTooltip:SetSpellByID(spellId);
		GameTooltip:Show();
	end
end

--[[--
Show "default" tooltip for item with ID `itemId`. Tooltip is placed on the right of the frame `cellFrame`.

@param[type=Frame] cellFrame
@param[type=number] itemId
]]
function MyDungeonsBook:Table_Cell_ItemMouseHover(cellFrame, itemId)
	if (itemId and itemId > 0) then
		GameTooltip:SetOwner(cellFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", cellFrame, "BOTTOMRIGHT");
		local _, itemLink = GetItemInfo(itemId);
		GameTooltip:SetHyperlink(itemLink);
		GameTooltip:Show();
	end
end

--[[--
Get columns for table that looks like `| spell icon | spell link |  party member 1 .. 5 | sum |`

@param[type=?number] challengeId
@return[type=table]
]]
function MyDungeonsBook:Table_Headers_GetForSpellsSummary(challengeId)
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
            name = L["Spell"],
            width = 40,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellIcon(...);
            end
        },
        {
            name = "",
            width = 120,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellLink(...);
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
            sort = "asc",
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
Get columns for table that looks like `| spell icon | spell link | party member 1 .. 5 hits/amount  | sum |`

@param[type=?number] challengeId
@return[type=table]
]]
function MyDungeonsBook:Table_Columns_GetForDamageOrHealToPartyMembers(challengeId)
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
			name = L["Spell"],
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellIcon(...);
			end
		},
		{
			name = " ",
			width = 110,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellLink(...);
			end
		},
		{
			name = player,
			width = 75,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = party1,
			width = 75,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = party2,
			width = 75,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = party3,
			width = 75,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = party4,
			width = 75,
			align = "RIGHT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		},
		{
			name = L["Sum"],
			width = 75,
			align = "RIGHT",
			sort = "asc",
			bgcolor = {
				r = 0,
				g = 0,
				b = 0,
				a = 0.4
			},
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsNumber(...);
			end
		},
		{
			name = "",
			width = 1,
			align = "RIGHT"
		}
	};
end
