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

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsNumber(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
    (cellFrame.text or cellFrame):SetText((val and self:FormatNumber(val)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with formatted percents. Uses `MyDungeonsBook:FormatPercents` to format cell value.

Original value (number) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsPercents(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	if (type(val) == "number") then
		if (val <= 1) then
			val = val * 100;
		end
	end
	(cellFrame.text or cellFrame):SetText((val and self:FormatPercents(val)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with formatted date.

Original value (timestamp) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
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

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsTime(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	local time;
    if (val and (type(val) == "number") and val > 0) then
        time = self:FormatTime(val);
    else
        time = "-";
    end
    (cellFrame.text or cellFrame):SetText(time);
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with formatted time (time should be in milliseconds!).

Original value (GUID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
First param `format` determines format of GUID to display:
 * "SHORT" - only last part is shown
 * "MED" - NPC id and last part are shown
 * "FULL" - GUID is shown "as is"
]]
function MyDungeonsBook:Table_Cell_FormatAsGuid(format, rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	val = self:FormatGuid(val, format);
	(cellFrame.text or cellFrame):SetText(val);
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

function MyDungeonsBook:Table_Cell_FormatAsSizedSpellIcon(size, rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local spellId = data[realrow].cols[column].value;
	local suffix = self:GetIconTextureSuffix(size);
	if (spellId and type(spellId) == "number") then
		if (spellId < -3) then
			local npcId = math.abs(spellId);
			local icon = (self.db.global.meta.npcToTrackSwingDamage[npcId] and self.db.global.meta.npcToTrackSwingDamage[npcId].icon) or "999951";
			(cellFrame.text or cellFrame):SetText("|T".. icon .. suffix .. "|t");
		else
			if (spellId == -2) then
				-- Hack to show "fist" icon for swing dmg
				local spellIcon = "|T999951" .. suffix .. "|t";
				(cellFrame.text or cellFrame):SetText(spellIcon);
			else
				if (spellId > 0) then
					local _, _, icon = GetSpellInfo(spellId);
					local spellIcon = "|T" .. (icon or "") .. suffix .. "|t";
					(cellFrame.text or cellFrame):SetText(spellIcon);
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

function MyDungeonsBook:Table_Cell_FormatAsSmallSpellIcon(...)
	return self:Table_Cell_FormatAsSizedSpellIcon(15, ...);
end

--[[--
Wrapper for cells with spell icon.

Original value (spell ID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsSpellIcon(...)
	return self:Table_Cell_FormatAsSizedSpellIcon(30, ...);
end

--[[--
Wrapper for cells with spell link.

Original value (spell ID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsSpellLink(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local spellId = data[realrow].cols[column].value;
	if (spellId and type(spellId) == "number") then
		if (spellId < -3) then
			local npcId = math.abs(spellId);
			local cellText = L["Swing Damage"];
			local unitName = (self.db.global.meta.npcs[npcId] and self.db.global.meta.npcs[npcId].name) or npcId;
			cellText = string.format("%s (%s)", cellText, unitName);
			(cellFrame.text or cellFrame):SetText(cellText);
		else
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
					if (spellId == -3) then
						(cellFrame.text or cellFrame):SetText(L["Avoidable"]);
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
			end
		end
	else
		(cellFrame.text or cellFrame):SetText("");
	end
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[--
Wrapper for cells with texture.

Original value (display ID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsTexture(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local displayId = data[realrow].cols[column].value;
	if (displayId < 0) then
		if (cellFrame.texture) then
			cellFrame.texture:SetTexture("interface\\inventoryitems\\wowunknownitem01.blp");
		end
		return;
	end
	local texture = cellFrame.texture or cellFrame:CreateTexture(nil, "BACKGROUND");
	texture:SetPoint("TOPLEFT", cellFrame ,"TOPLEFT", 3, -3);
	texture:SetPoint("BOTTOMRIGHT", cellFrame ,"BOTTOMRIGHT", -3, 3);
	cellFrame.texture = texture;
	SetPortraitTextureFromCreatureDisplayID(texture, displayId);
end

--[[--
Wrapper for cells with spell icon.

Original value (item ID) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
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

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
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
Wrapper for cells with party member name

Original value (party member name) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatAsPartyMember(challengeId, rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local challenge = self:Challenge_GetById(challengeId);
	if (not challenge) then
		return;
	end
	local unitName = data[realrow].cols[column].value or "";
	local unitId = self:GetPartyUnitByName(challengeId, unitName);
	local val = unitId and self:GetUnitNameRealmRoleStr(challenge.players[unitId]) or unitName;
	cellFrame.text:SetText(val);
end

--[[--
Wrapper for cells with party member overall agro level

Original value (party member overall agro level) is left "as is" for sorting purposes.

Params are similar to [ScrollingTableMdb:DoCellUpdate](https://www.wowace.com/projects/lib-st/pages/docell-update)
]]
function MyDungeonsBook:Table_Cell_FormatCellAsArgo(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local threat = data[realrow].cols[column].value or -1;
	local val = "";
	if (threat >= 0) then
		local r, g, b = GetThreatStatusColor(threat);
		val = string.format("|cff%s%s%s%s|r", self:DecToHex(r), self:DecToHex(g), self:DecToHex(b), threat);
	end
	cellFrame.text:SetText(val);
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
	if (spellId and type(spellId) == "number" and spellId > 0) then
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
            name = "",
            width = 40,
            align = "LEFT",
            DoCellUpdate = function(...)
                self:Table_Cell_FormatAsSpellIcon(...);
            end
        },
        {
            name = L["Spell"],
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
			name = "",
			width = 40,
			align = "LEFT",
			DoCellUpdate = function(...)
				self:Table_Cell_FormatAsSpellIcon(...);
			end
		},
		{
			name = L["Spell"],
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

--[[--
@param[type=table] row
@param[type=table] cols
@param[type=table] columnIndexes
@param[type=string] title
@param[type=?string] msgFormat
@return[type=table]
]]
function MyDungeonsBook:Table_PlayersRow_Report_Create(row, cols, columnIndexes, title, msgFormat)
	local report = {};
    msgFormat = msgFormat or "%s: %s";
	tinsert(report, title);
	for i = 1, #columnIndexes do
		local index = columnIndexes[i];
		local val = row.cols[index].value;
		if (type(val) == "number") then
			val = self:FormatNumber(val);
		end
		tinsert(report, string.format(msgFormat, self:DecolorizeString(cols[index].name), val));
	end
	return report;
end

--[[--
@param[type=table] row
@param[type=table] cols
@param[type=string] title
@param[type=?string] msgFormat
@return[type=table]
]]
function MyDungeonsBook:Table_PlayersRowBySpell_Report_Create(row, cols, title, msgFormat)
	local report = {};
	local msgFormat = msgFormat or L["Amount - %s (%s%%), over - %s, crit - %s%%, max - %s (%s)"];
	tinsert(report, title);
	local amount = self:FormatNumber(row.cols[5].value);
	local percentage = self:FormatPercents(row.cols[6].value);
	local over = self:FormatNumber(row.cols[7].value);
	local crit = self:FormatPercents(row.cols[8].value);
	local maxCrit = self:FormatNumber(row.cols[10].value);
	local maxNotCrit = self:FormatNumber(row.cols[12].value);
	tinsert(report, string.format(msgFormat, amount, percentage, over, crit, maxCrit, maxNotCrit));
	return report;
end

--[[--
@param[type=table] tbl
@param[type=table] cols
@param[type=table] columnIndexes
@param[type=string] title
@param[type=?string] msgFormat
@return[type=table]
]]
function MyDungeonsBook:Table_AllRows_Report_Create(tbl, cols, columnIndexes, title, msgFormat)
    local report = {};
    tinsert(report, title);
    for _, row in pairs(tbl) do
        local vals = {};
        local msg = "";
        for i = 1, #columnIndexes do
            local index = columnIndexes[i];
            tinsert(vals, row.cols[index].value);
        end
        msgFormat = msgFormat or (string.rep("%s ", #vals));
        tinsert(report, string.format(msgFormat, unpack(vals)));
    end
    return report;
end
