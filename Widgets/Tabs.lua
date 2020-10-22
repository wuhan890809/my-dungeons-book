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
function MyDungeonsBook:TabsWidget_Create(parentFrame)
    local tabsFrame = AceGUI:Create("TabGroup");
    tabsFrame:SetLayout("Flow");
    tabsFrame:SetFullWidth(true);
    tabsFrame.borderoffset = 1;
    tabsFrame.alignoffset = 1;
    tabsFrame.content:SetPoint("TOPLEFT", 5, 0);
    tabsFrame.content:SetPoint("BOTTOMRIGHT", 0, 0);
    tabsFrame.border:SetPoint("TOPLEFT", 0, 0);
    tabsFrame.border:SetPoint("BOTTOMRIGHT", 0, 0);
    tabsFrame:SetAutoAdjustHeight(false);
    parentFrame:AddChild(tabsFrame);
    return tabsFrame;
end
