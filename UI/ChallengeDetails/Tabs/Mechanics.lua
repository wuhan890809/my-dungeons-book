--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Mechanics tab

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:MechanicsFrame_Create(parentFrame)
	local mechanicsFrame = self:TabContentWrapperWidget_Create(parentFrame);
	mechanicsFrame.tabButtonsFrame = self:MechanicsFrame_CreateTabButtonsFrame(mechanicsFrame);
	mechanicsFrame.tabButtonsFrame:SelectTab("usedItems");
	return mechanicsFrame;
end
