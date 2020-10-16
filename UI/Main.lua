--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local WindowBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 1,
	edgeSize = 1,
	insets = {
		left = 3,
		right = 3,
		top = 3,
		bottom = 3
	}
};

--[[--
Creates a main frame for addon.

@return[type=Frame] frame
]]
function MyDungeonsBook:MainFrame_Create()
	local frame = CreateFrame("Frame", "MyDungeonsBookFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate");
	frame:SetWidth(1425);
	frame:SetHeight(650);
	frame:SetPoint("CENTER", UIParent, "CENTER", self.db.profile.display.x, self.db.profile.display.y);
	frame:SetBackdrop(WindowBackdrop);
	frame:SetBackdropColor(0, 0, 0, 1);
	frame:SetBackdropBorderColor(0.4, 0.4, 0.4);
	
	frame:EnableMouse();
	frame:SetMovable(true);
	frame:SetClampedToScreen(true);
	frame:SetFrameStrata("HIGH");
	return frame;
end

--[[--
Creates a frame with title and block that allows to move main frame.

Needed event listeners are defined too.

@param[type=Frame] parentFrame main window frame
@return[type=Button] closeButton
]]
function MyDungeonsBook:MainFrame_CloseButton_Create(parentFrame)
	local closeButton = CreateFrame("Button", nil, parentFrame, "UIPanelCloseButton");
	closeButton:SetPoint("TOPRIGHT", 0, 0);
	closeButton:SetFrameLevel(3);
	closeButton:SetScript("OnClick", function()
		parentFrame:Hide();
		if (self.db.profile.performance.collectgarbage) then
			collectgarbage("collect");
		end
	end);
	return closeButton;
end

--[[--
Creates a frame with title and block that allows to move main frame.

Needed event listeners are defined too.

@param[type=Frame] parentFrame main window frame
@return[type=Frame] titleBar
]]
function MyDungeonsBook:MainFrame_TitleBar_Create(parentFrame)
	local titleBar = parentFrame:CreateTexture(nil, "BACKGROUND");
	titleBar:SetColorTexture(0.5, 0.5, 0.5);
	titleBar:SetGradient("HORIZONTAL", 0.6, 0.6, 0.6, 0.3, 0.3, 0.3);
	titleBar:SetPoint("TOPLEFT", 4, -4);
	titleBar:SetPoint("BOTTOMRIGHT", parentFrame, "TOPRIGHT", -4, -28);

	local titleText = parentFrame:CreateFontString(nil, "ARTWORK");
	titleText:SetFontObject(GameFontNormal);
	titleText:SetTextColor(0.6, 0.6, 0.6);
	titleText:SetPoint("TOPLEFT", titleBar, "TOPLEFT", 5, 0);
	titleText:SetPoint("BOTTOMRIGHT", titleBar);

	titleText:SetHeight(40);
	titleText:SetText(L["My Dungeons Book"]);
	titleText:SetJustifyH("LEFT");
	titleText:SetJustifyV("MIDDLE");

	local titleBarFrame = CreateFrame("Frame", nil, parentFrame);
	titleBarFrame:SetAllPoints(titleBar);
	titleBarFrame:EnableMouse();
	titleBarFrame:SetScript("OnMouseDown", function()
		parentFrame:StartMoving();
	end);
	titleBarFrame:SetScript("OnMouseUp", function()
		parentFrame:StopMovingOrSizing();
		self:SaveFrameRect(parentFrame);
	end);
	return titleBar;
end

--[[--
Create (if not exists) a main frame and show it for player
]]
function MyDungeonsBook:MainFrame_Show()
	if (not self.frame) then
		local frame = self:MainFrame_Create();
		self.titleBar = self:MainFrame_TitleBar_Create(frame);
		self.closeButton = self:MainFrame_CloseButton_Create(frame);
		self.challengesTable = self:ChallengesFrame_Create(frame);
		self.challengeDetailsFrame = self:ChallengeDetailsFrame_Create(frame);
		self.frame = frame;
    end
    self:ChallengesFrame_Update();
	self.frame:Show();
end

--[[--
Save dimension and position of main frame after moving

@local
@param[type=Frame] mainFrame
]]
function MyDungeonsBook:SaveFrameRect(mainFrame)
	local _, _, sw, sh = UIParent:GetRect();
	local x, y, w, h = mainFrame:GetRect();
	self.db.profile.display.x = x + w/2 - sw/2;
	self.db.profile.display.y = y + h/2 - sh/2;
	self.db.profile.display.w = w;
	self.db.profile.display.h = h;
end
