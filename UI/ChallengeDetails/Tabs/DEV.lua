--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]
local AceGUI = LibStub("AceGUI-3.0");
--[[--
Creates a frame for DEV tab.

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] devFrame
]]
function MyDungeonsBook:DevFrame_Create(parentFrame, challengeId)
	local devFrame = self:TabContentWrapperWidget_Create(parentFrame);
	devFrame:SetFullHeight(true);
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		local editBox = AceGUI:Create("EditBox");
		editBox:SetFullWidth(true);
		editBox.button:SetText("Get JSON");
		editBox.button:Show();
		editBox:SetCallback("OnEnterPressed", function ()
			local isTable = type(challenge.mechanics) == "table";
			editBox:SetText(self:Table2Json((isTable and challenge.mechanics) or select(2, self:Decompress(challenge.mechanics))));
			editBox:HighlightText();
		end);
		devFrame:AddChild(editBox);
	end
	return devFrame;
end
