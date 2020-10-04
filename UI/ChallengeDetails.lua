local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
Click-handler for challenges table
Used on row click

@method MyDungeonsBook:ShowChallengeDetails
@param {number} challengeId
]]
function MyDungeonsBook:ShowChallengeDetails(challengeId)
	self:DebugPrint("Show details for challenge #" .. challengeId);
	self.activeChallengeId = challengeId;
	self:UpdateChallengeDetailsFrame(challengeId);
	self.challengeDetailsFrame:Show();
	self:ChallengeDetailsFrame_ShowTab("roster");
end

--[[
Create all frames related to the challenge details frames (with itself)

@method MyDungeonsBook:CreateChallengeDetailsFrame
@param {table} parentFrame
@return {table} challengeDetailsFrame
]]
function MyDungeonsBook:CreateChallengeDetailsFrame(parentFrame)
	local challengeDetailsFrame = CreateFrame("Frame", nil, parentFrame);
	challengeDetailsFrame:SetPoint("TOPRIGHT", -10, -30);
	challengeDetailsFrame:SetWidth(900);
	challengeDetailsFrame:SetHeight(650);
	challengeDetailsFrame.titleFrame = self:ChallengeDetailsFrame_CreateTitleFrame(challengeDetailsFrame);
	challengeDetailsFrame.tabButtonsFrame = self:ChallengeDetailsFrame_CreateTabButtonsFrame(challengeDetailsFrame);
	challengeDetailsFrame.challengeRosterFrame = self:CreateChallengeRosterFrame(challengeDetailsFrame);
	challengeDetailsFrame.avoidableDamageFrame = self:CreateAvoidableDamageFrame(challengeDetailsFrame);
	challengeDetailsFrame.avoidableDebuffsFrame = self:CreateAvoidableDebuffsFrame(challengeDetailsFrame);
	challengeDetailsFrame.detailsFrame = self:CreateDetailsFrame(challengeDetailsFrame);
	challengeDetailsFrame.encountersFrame = self:CreateEncountersFrame(challengeDetailsFrame);
	challengeDetailsFrame.interruptsFrame = self:CreateInterruptsFrame(challengeDetailsFrame);
	challengeDetailsFrame.mechanicsFrame = self:CreateMechanicsFrame(challengeDetailsFrame);
	challengeDetailsFrame.devFrame = self:CreateDevFrame(challengeDetailsFrame);
	challengeDetailsFrame.tabs = {
		roster = challengeDetailsFrame.challengeRosterFrame,
		avoidableDamage = challengeDetailsFrame.avoidableDamageFrame,
		avoidableDebuffs = challengeDetailsFrame.avoidableDebuffsFrame,
		details = challengeDetailsFrame.detailsFrame,
		dev = challengeDetailsFrame.devFrame,
		encounters = challengeDetailsFrame.encountersFrame,
		interrupts = challengeDetailsFrame.interruptsFrame,
		mechanics = challengeDetailsFrame.mechanicsFrame
	};
	challengeDetailsFrame:Hide();
	return challengeDetailsFrame;
end

--[[
@method MyDungeonsBook:ChallengeDetailsFrame_CreateTitleFrame
@param {table} parentFrame
@return {table} titleFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreateTitleFrame(parentFrame)
	local titleFrame = CreateFrame("Frame", nil, parentFrame);
	titleFrame:SetPoint("TOPRIGHT", 0, 0);
	titleFrame:SetWidth(900);
	titleFrame:SetHeight(50);

	local titleText = titleFrame:CreateFontString(nil, "ARTWORK");
	titleText:SetFontObject(GameFontNormalLarge);
	titleText:SetTextColor(0.6, 0.6, 0.6);
	titleText:SetPoint("TOPRIGHT", titleFrame, "TOPRIGHT", -10, 0);
	titleText:SetPoint("BOTTOMRIGHT", titleFrame);
	titleText:SetHeight(50);
	titleFrame.titleText = titleText;

	local titleAffixes = titleFrame:CreateFontString(nil, "ARTWORK");
	titleAffixes:SetFontObject(GameFontNormal);
	titleAffixes:SetTextColor(0.6, 0.6, 0.6);
	titleAffixes:SetPoint("TOPLEFT", titleFrame, "TOPLEFT", 5, 0);
	titleAffixes:SetPoint("BOTTOMLEFT", titleFrame);
	titleAffixes:SetHeight(50);
	titleFrame.titleAffixes = titleAffixes;
	return titleFrame;
end

--[[
Update all frames related to challenge details

@method MyDungeonsBook:UpdateChallengeDetailsFrame
@param {number} challengeId
]]
function MyDungeonsBook:UpdateChallengeDetailsFrame(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		self.challengeDetailsFrame.titleFrame.titleText:SetText(string.format("%s (+%s) %s", challenge.challengeInfo.zoneName, challenge.challengeInfo.cmLevel, self:GetKeyUpgradeStr(challenge)));
		self.challengeDetailsFrame.titleFrame.titleAffixes:SetText(self:GetChallengeAffixesIconsStr(challengeId, 30));
		self:UpdateAvoidableDamageFrame(challengeId);
		self:UpdateAvoidableDebuffsFrame(challengeId);
		self:UpdateInterruptsFrame(challengeId);
		self:UpdateDetailsFrame(challengeId);
		self:UpdateDevFrame(challengeId);
		self:UpdateRosterFrame(challengeId);
		self:UpdateEncountersFrame(challengeId);
		self:UpdateMechanicsFrame(challengeId);
	else
		self:DebugPrint(string.format("Challenge #%s not found", challengeId));
	end
end
