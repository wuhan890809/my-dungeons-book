--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Widgets
]]

local ScrollingTable = LibStub("ScrollingTable");

local tables = {};

--[[--
@param[type=table] cols
@param[type=number] numRows
@param[type=number] rowHeight
@param[type=table] highlight
@param[type=table] parentFrame
@param[type=string] id
@return[type=table]
]]
function MyDungeonsBook:TableWidget_Create(cols, numRows, rowHeight, highlight, parentFrame, id)
    local table = tables[id];
    if (table) then
        table.frame:SetParent(parentFrame.frame);
        table:Show();
        table:SetDisplayRows(numRows, rowHeight);
        table:SetDisplayCols(cols);
    else
        table = ScrollingTable:CreateST(cols, numRows, rowHeight, highlight, parentFrame.frame);
        tables[id] = table;
    end
    table.frame:SetPoint("TOPLEFT", 0, -40);
    parentFrame.userdata.tables = parentFrame.userdata.tables or {};
    tinsert(parentFrame.userdata.tables, id);
    parentFrame:SetCallback("OnRelease", function()
        for _, tableId in pairs(parentFrame.userdata.tables) do
            self:TableWidget_Release(tableId);
        end
    end);
    return table;
end

--[[--
@param[type=string] id
]]
function MyDungeonsBook:TableWidget_Release(id)
    local table = tables[id];
    if (table) then
        table:Hide();
    end
end
