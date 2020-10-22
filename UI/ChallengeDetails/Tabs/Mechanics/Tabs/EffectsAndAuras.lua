--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Effects And Auras tab

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:EffectsAndAurasFrame_Create(parentFrame)
	local effectsAndAurasFrame = self:TabContentWrapperWidget_Create(parentFrame);
	effectsAndAurasFrame:SetHeight(650);
	effectsAndAurasFrame.tabButtonsFrame = self:EffectsAndAurasFrame_CreateTabButtonsFrame(effectsAndAurasFrame);
	effectsAndAurasFrame.tabButtonsFrame:SelectTab("dispels");
	return effectsAndAurasFrame;
end
