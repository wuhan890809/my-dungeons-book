--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Widgets
]]

local ScrollingTableMdb = LibStub("ScrollingTableMdb");

local tables = {};

function MyDungeonsBook:TableWidget_Create(cols, numRows, rowHeight, highlight, parentFrame, id)
    local table = tables[id];
    if (table) then
        table.frame:SetParent(parentFrame.frame);
        table:Show();
        table:SetDisplayRows(numRows, rowHeight);
        table:SetDisplayCols(cols);
    else
        table = ScrollingTableMdb:CreateST(cols, numRows, rowHeight, highlight, parentFrame.frame);
        tables[id] = table;
    end
    table.frame:SetPoint("TOPLEFT", 0, -40);
    local tables = parentFrame:GetUserData("tables") or {};
    parentFrame.userdata.tables = parentFrame.userdata.tables or {};
    tinsert(tables, id);
    parentFrame:SetUserData("tables", tables);
    parentFrame:SetCallback("OnRelease", function(frame)
        local tbls = frame:GetUserData("tables");
        for _, tableId in pairs(tbls) do
            self:TableWidget_Release(tableId);
        end
    end);
    return table;
end

function MyDungeonsBook:TableWidget_Release(id)
    local table = tables[id];
    if (table) then
        table:Hide();
    end
end
