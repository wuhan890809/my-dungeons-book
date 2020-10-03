local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
Create a frame for DEV tab

@method MyDungeonsBook:CreateDevFrame
@param {table} frame
@return {table} devWrapper
]]
function MyDungeonsBook:CreateDevFrame(frame)
	local devWrapper = CreateFrame("Frame", nil, frame);
	devWrapper:SetWidth(900);
	devWrapper:SetHeight(490);
	devWrapper:SetPoint("TOPRIGHT", -5, -110);
	local textarea = CreateFrame("EditBox", nil, devWrapper, "InputBoxTemplate");
	textarea:SetFontObject(GameFontNormal);
	textarea:SetPoint("TOPLEFT", 10, -10);
	textarea:SetWidth(800);
	textarea:SetHeight(20);
	devWrapper.textarea = textarea;
	return devWrapper; 
end

function MyDungeonsBook:UpdateDevFrame(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		self.challengeDetailsFrame.devFrame.textarea:SetText(self:Table2Json(challenge));
		self.challengeDetailsFrame.devFrame.textarea:HighlightText();
	end
end