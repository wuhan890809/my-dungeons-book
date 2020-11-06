--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Widgets
]]

local AceGUI = LibStub("AceGUI-3.0");

--[[--
@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:TabContentWrapperWidget_Create(parentFrame)
    local tabContentWrapperFrame = AceGUI:Create("SimpleGroup");
    tabContentWrapperFrame:SetLayout("Flow");
    tabContentWrapperFrame:SetFullWidth(true);
    parentFrame:AddChild(tabContentWrapperFrame);
    return tabContentWrapperFrame;
end
