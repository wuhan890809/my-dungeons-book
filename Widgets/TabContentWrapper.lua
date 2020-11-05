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
@return[1][type=Frame] content wrapper frame
@return[2][type=Frame] description label
]]
function MyDungeonsBook:TabContentWrapperWidget_Create(parentFrame)
    local tabContentWrapperFrame = AceGUI:Create("SimpleGroup");
    tabContentWrapperFrame:SetLayout("Flow");
    tabContentWrapperFrame:SetFullWidth(true);
    parentFrame:AddChild(tabContentWrapperFrame);
    local descriptionLabel = AceGUI:Create("Label");
    tabContentWrapperFrame:AddChild(descriptionLabel);
    descriptionLabel:SetWidth(650);
    descriptionLabel.label:SetHeight(40);
    descriptionLabel:SetJustifyV("MIDDLE");
    return tabContentWrapperFrame, descriptionLabel;
end
