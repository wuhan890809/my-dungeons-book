--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Click-handler for challenges table. Used on row click.

@param[type=number] challengeId
]]
function MyDungeonsBook:ChallengeDetailsFrame_Show(challengeId)
	self:DebugPrint("Show details for challenge #" .. challengeId);
	self.activeChallengeId = challengeId;
	self:ChallengeDetailsFrame_Update(challengeId);
	self.challengeDetailsFrame:Show();
    self:Tab_Click(self.challengeDetailsFrame, "roster");
end

--[[--
Creates all frames related to the challenge details frames (with itself).

@param[type=Frame] parentFrame
@return[type=Frame] challengeDetailsFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_Create(parentFrame)
	local challengeDetailsFrame = CreateFrame("Frame", nil, parentFrame);
	challengeDetailsFrame:SetPoint("TOPLEFT", 590, -30);
	challengeDetailsFrame:SetWidth(900);
	challengeDetailsFrame:SetHeight(650);
	challengeDetailsFrame.titleFrame = self:ChallengeDetailsFrame_TitleFrame_Create(challengeDetailsFrame);
	challengeDetailsFrame.tabButtonsFrame = self:ChallengeDetailsFrame_CreateTabButtonsFrame(challengeDetailsFrame);
	challengeDetailsFrame.challengeRosterFrame = self:RosterFrame_Create(challengeDetailsFrame);
	challengeDetailsFrame.detailsFrame = self:DetailsFrame_Create(challengeDetailsFrame);
	challengeDetailsFrame.encountersFrame = self:EncountersFrame_Create(challengeDetailsFrame);
	challengeDetailsFrame.interruptsFrame = self:InterruptsFrame_Create(challengeDetailsFrame);
	challengeDetailsFrame.mechanicsFrame = self:MechanicsFrame_Create(challengeDetailsFrame);
	challengeDetailsFrame.devFrame = self:DevFrame_Create(challengeDetailsFrame);
	challengeDetailsFrame.tabs = {
		roster = challengeDetailsFrame.challengeRosterFrame,
		details = challengeDetailsFrame.detailsFrame,
		dev = challengeDetailsFrame.devFrame,
		encounters = challengeDetailsFrame.encountersFrame,
		interrupts = challengeDetailsFrame.interruptsFrame,
		mechanics = challengeDetailsFrame.mechanicsFrame
	};
	challengeDetailsFrame:Hide();
	return challengeDetailsFrame;
end

--[[--
Creates a frame with challenge name and affixes.

@param[type=Frame] parentFrame
@return[type=Frame] titleFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_TitleFrame_Create(parentFrame)
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

--[[--
Update all frames related to challenge details.

@param[type=number] challengeId
]]
function MyDungeonsBook:ChallengeDetailsFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		self.challengeDetailsFrame.titleFrame.titleText:SetText(string.format(L["%s (+%s) %s"], challenge.challengeInfo.zoneName, challenge.challengeInfo.cmLevel, self:GetKeyUpgradeStr(challenge)));
		self.challengeDetailsFrame.titleFrame.titleAffixes:SetText(self:GetChallengeAffixesIconsStr(challengeId, 30));
		self:InterruptsFrame_Update(challengeId);
		self:DetailsFrame_Update(challengeId);
		self:DevFrame_Update(challengeId);
		self:RosterFrame_Update(challengeId);
		self:EncountersFrame_Update(challengeId);
		self:MechanicsFrame_Update(challengeId);
	else
		self:DebugPrint(string.format("Challenge #%s not found", challengeId));
	end
end
