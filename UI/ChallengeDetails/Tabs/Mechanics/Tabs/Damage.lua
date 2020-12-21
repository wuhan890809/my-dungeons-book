--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for Damage tab

@param[type=Frame] parentFrame
@return[type=Frame]
]]
function MyDungeonsBook:DamageFrame_Create(parentFrame)
	local damageFrame = self:TabContentWrapperWidget_Create(parentFrame);
	damageFrame:SetHeight(650);
	damageFrame.tabButtonsFrame = self:DamageFrame_CreateTabButtonsFrame(damageFrame);
	damageFrame.tabButtonsFrame:SelectTab("damageDoneToPartyMembers");
	return damageFrame;
end
