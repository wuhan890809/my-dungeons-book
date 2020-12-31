--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Widgets
]]

local AceGUI = LibStub("AceGUI-3.0");

--[[--
Create a simple blank label that takes full width of parent frame.

It will move next child-frames to the "next line"

@param[type=Frame]
@return[type=Frame]
]]
function MyDungeonsBook:NewLine_Create(parentFrame)
    local newLine = AceGUI:Create("Label");
    newLine:SetFullWidth(true);
    parentFrame:AddChild(newLine);
    return newLine;
end
