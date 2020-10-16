--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

--[[--
Creates a frame for DEV tab.

@param[type=Frame] parentFrame
@return[type=Frame] devWrapper
]]
function MyDungeonsBook:DevFrame_Create(parentFrame)
	local devWrapper = CreateFrame("Frame", nil, parentFrame);
	devWrapper:SetWidth(700);
	devWrapper:SetHeight(490);
	devWrapper:SetPoint("TOPLEFT", 0, -80);
	local textarea = CreateFrame("EditBox", nil, devWrapper, "InputBoxTemplate");
	textarea:SetFontObject(GameFontNormal);
	textarea:SetPoint("TOPLEFT", 0, 0);
	textarea:SetWidth(650);
	textarea:SetHeight(30);
	devWrapper.textarea = textarea;
	return devWrapper; 
end

--[[--
Update DEV-tab for challenge with id `challengeId`.

@param[type=number] challengeId
]]
function MyDungeonsBook:DevFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		self.challengeDetailsFrame.devFrame.textarea:SetText(self:Table2Json(challenge));
		self.challengeDetailsFrame.devFrame.textarea:HighlightText();
	end
end
