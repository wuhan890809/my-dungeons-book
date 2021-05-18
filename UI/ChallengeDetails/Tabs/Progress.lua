--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Progress tab

@param[type=Frame] parentFrame
@return[type=Frame] progressFrame
]]
function MyDungeonsBook:ProgressFrame_Create(parentFrame)
    local progressFrame = self:TabContentWrapperWidget_Create(parentFrame);
    progressFrame.tabButtonsFrame = self:ProgressFrame_CreateTabButtonsFrame(progressFrame);
    progressFrame.tabButtonsFrame:SelectTab("encounters");
    return progressFrame;
end
