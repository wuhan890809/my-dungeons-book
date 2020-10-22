--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Casts tab

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:CastsFrame_Create(parentFrame)
    local castsFrame = self:TabContentWrapperWidget_Create(parentFrame);
    castsFrame:SetHeight(650);
    castsFrame.tabButtonsFrame = self:CastsFrame_CreateTabButtonsFrame(castsFrame);
    castsFrame.tabButtonsFrame:SelectTab("interrupts");
    return castsFrame;
end
