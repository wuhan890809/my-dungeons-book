--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local AceGUI = LibStub("AceGUI-3.0");

--[[--
Click-handler for challenges table. Used on row click.

@param[type=number] challengeId
]]
function MyDungeonsBook:ChallengeDetailsFrame_Show(challengeId)
	self:DebugPrint("Show details for challenge #" .. challengeId);
	self.activeChallengeId = challengeId;
	self.activeChallengeMechanics = nil;
	self:ChallengeDetailsFrame_Update(challengeId);
	self.challengeDetailsFrame.frame:Show();
	self.challengeDetailsFrame.tabButtonsFrame:SelectTab("roster");
end

--[[--
Creates all frames related to the challenge details frames (with itself).

@param[type=Frame] parentFrame
@return[type=Frame] challengeDetailsFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_Create(parentFrame)
	local challengeDetailsFrame = AceGUI:Create("SimpleGroup");
	challengeDetailsFrame:SetLayout("List");
	challengeDetailsFrame:SetFullHeight(true);
	challengeDetailsFrame:SetWidth(700);
	parentFrame:AddChild(challengeDetailsFrame);
	local grid = AceGUI:Create("SimpleGroup");
	grid:SetLayout("List");
	grid:SetFullWidth(true);
	challengeDetailsFrame:AddChild(grid);
	local titleAffixes, titleText, dateText = self:ChallengeDetailsFrame_TitleFrame_Create(grid);
	challengeDetailsFrame.titleAffixes = titleAffixes;
	challengeDetailsFrame.titleText = titleText;
	challengeDetailsFrame.dateText = dateText;
	local tabButtonsFrame = self:ChallengeDetailsFrame_CreateTabButtonsFrame(grid);
	challengeDetailsFrame.tabButtonsFrame = tabButtonsFrame;
	challengeDetailsFrame.frame:Hide();
	return challengeDetailsFrame;
end

--[[--
Creates a frame with challenge name and affixes.

@param[type=Frame] parentFrame
@return[type=Frame] titleFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_TitleFrame_Create(parentFrame)
	local grid = AceGUI:Create("SimpleGroup");
	grid:SetLayout("Flow");
	grid:SetFullWidth(true);
	parentFrame:AddChild(grid);
	grid:SetFullHeight(true);
	local titleAffixes = AceGUI:Create("Label");
	titleAffixes:SetFontObject(GameFontNormal);
	titleAffixes:SetWidth(200);
	grid:AddChild(titleAffixes);

	local titleText = AceGUI:Create("Label");
	titleText:SetFontObject(GameFontNormalLarge);
	titleText:SetWidth(300);
	grid:AddChild(titleText);

	local dateText = AceGUI:Create("Label");
	dateText:SetFontObject(GameFontNormalLarge);
	dateText:SetWidth(190);
	dateText:SetJustifyH("RIGHT");
	grid:AddChild(dateText);
	return titleAffixes, titleText, dateText;
end

--[[--
Update all frames related to challenge details.

@param[type=number] challengeId
]]
function MyDungeonsBook:ChallengeDetailsFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		self.challengeDetailsFrame.titleText:SetText(string.format(L["%s (%s) %s"], challenge.challengeInfo.zoneName, challenge.challengeInfo.cmLevel, self:GetKeyUpgradeStr(challenge)));
		self.challengeDetailsFrame.titleAffixes:SetText(self:GetChallengeAffixesIconsStr(challengeId, 30));
		self.challengeDetailsFrame.dateText:SetText(date(self.db.profile.display.dateFormat, challenge.challengeInfo.startTime));
	else
		self:DebugPrint(string.format("Challenge #%s not found", challengeId));
	end
end
