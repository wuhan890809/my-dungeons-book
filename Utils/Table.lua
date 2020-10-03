local function updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local defaultColor = {
		r = 1,
		g = 1,
		b = 1,
		a = 1
	};
	local celldata = data[realrow].cols[column];
	local color = nil;
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
	cellFrame.text:SetTextColor(color.r, color.g, color.b, color.a);
end

--[[
Wrapper for cells with formatted numbers. Uses `MyDungeonsBook:FormatNumber` to format cell value.
Original value is left "as is" for sorting purposes

Params are similar to https://www.wowace.com/projects/lib-st/pages/docell-update

@method MyDungeonsBook:FormatCellValueAsNumber
]]
function MyDungeonsBook:FormatCellValueAsNumber(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	cellFrame.text:SetText((val and self:FormatNumber(val)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[
Wrapper for cells with formatted date
Original value is left "as is" for sorting purposes

Params are similar to https://www.wowace.com/projects/lib-st/pages/docell-update

@method MyDungeonsBook:FormatCellValueAsDate
]]
function MyDungeonsBook:FormatCellValueAsDate(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	cellFrame.text:SetText((val and date("%Y-%m-%d %H:%M", val)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[
Wrapper for cells with formatted time (time should be in milliseconds!)
Original value is left "as is" for sorting purposes

Params are similar to https://www.wowace.com/projects/lib-st/pages/docell-update

@method MyDungeonsBook:FormatCellValueAsTime
]]
function MyDungeonsBook:FormatCellValueAsTime(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local val = data[realrow].cols[column].value;
	cellFrame.text:SetText((val > 0 and date("%M:%S", val / 1000)) or "-");
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[
Wrapper for cells with spell icon
Original value is left "as is" for sorting purposes

Params are similar to https://www.wowace.com/projects/lib-st/pages/docell-update

@method MyDungeonsBook:FormatCellValueAsSpellIcon
]]
function MyDungeonsBook:FormatCellValueAsSpellIcon(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local spellId = data[realrow].cols[column].value;
	if (spellId and spellId > 0) then
		local _, _, icon = GetSpellInfo(spellId);
		local spellIcon = "|T" .. icon .. ":30:30:0:0:64:64:5:59:5:59|t";
		cellFrame.text:SetText(spellIcon);
	else
		cellFrame.text:SetText("");
	end
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end

--[[
Wrapper for cells with spell link
Original value is left "as is" for sorting purposes

Params are similar to https://www.wowace.com/projects/lib-st/pages/docell-update

@method MyDungeonsBook:FormatCellValueAsSpellLink
]]
function MyDungeonsBook:FormatCellValueAsSpellLink(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table)
	local spellId = data[realrow].cols[column].value;
	if (spellId and spellId > 0) then
		local spellLink = GetSpellLink(spellId);
		cellFrame.text:SetText(spellLink);
	else
		cellFrame.text:SetText("");
	end
	updateCellTextColor(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, table);
end