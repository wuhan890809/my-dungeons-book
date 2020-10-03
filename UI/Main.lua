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

local CustomWindowBackdrop = {
	bgFile = "Interface\\TutorialFrame\\TutorialFrameBackground",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 32,
	edgeSize = 16,
	insets = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5
	}
};

--[[
Creates a main frame for addon

@method MyDungeonsBook:CreateMainFrame
@return {table} frame
]]
function MyDungeonsBook:CreateMainFrame()
	local frame = CreateFrame("Frame", "MyDungeonsBookFrame", UIParent);
	frame:SetWidth(1500);
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

--[[
Creates a frame with title and block that allows to move main frame
Needed event listeners are defined too

@method MyDungeonsBook:CreateCloseButton
@param {table} frame - main window frame
@return {table} closeButton
]]
function MyDungeonsBook:CreateCloseButton(frame)
	local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton");
	closeButton:SetPoint("TOPRIGHT", 0, 0);
	closeButton:SetFrameLevel(3);
	closeButton:SetScript("OnClick", function()
		frame:Hide();
		if (self.db.profile.performance.collectgarbage) then
			collectgarbage("collect");
		end
	end);
	return closeButton;
end

--[[
Creates a frame with title and block that allows to move main frame
Needed event listeners are defined too

@method MyDungeonsBook:CreateTitleBar
@param {table} frame - main window frame
@return {table} titleBar
]]
function MyDungeonsBook:CreateTitleBar(frame)
	local titleBar = frame:CreateTexture(nil, "BACKGROUND");
	titleBar:SetColorTexture(0.5, 0.5, 0.5);
	titleBar:SetGradient("HORIZONTAL", 0.6, 0.6, 0.6, 0.3, 0.3, 0.3);
	titleBar:SetPoint("TOPLEFT", 4, -4);
	titleBar:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -28);

	local titleText = frame:CreateFontString(nil, "ARTWORK");
	titleText:SetFontObject(GameFontNormal);
	titleText:SetTextColor(0.6, 0.6, 0.6);
	titleText:SetPoint("TOPLEFT", titleBar, "TOPLEFT", 5, 0);
	titleText:SetPoint("BOTTOMRIGHT", titleBar);

	titleText:SetHeight(40);
	titleText:SetText(L["My Dungeons Book"]);
	titleText:SetJustifyH("LEFT");
	titleText:SetJustifyV("MIDDLE");

	local titleBarFrame = CreateFrame("Frame", nil, frame);
	titleBarFrame:SetAllPoints(titleBar);
	titleBarFrame:EnableMouse();
	titleBarFrame:SetScript("OnMouseDown", function()
		frame:StartMoving();
	end);
	titleBarFrame:SetScript("OnMouseUp", function()
		frame:StopMovingOrSizing();
		self:SaveFrameRect(frame);
	end);
	return titleBar;
end

--[[
Create (if not exists) a main frame and show it for player

@method MyDungeonsBook:Show
]]
function MyDungeonsBook:Show()
	if (not self.frame) then
		local frame = self:CreateMainFrame();
		local titleBar = self:CreateTitleBar(frame);
		local close = self:CreateCloseButton(frame);
		self.challengesTable = self:CreateChallengesTable(frame);
		self.challengeDetailsFrame = self:CreateChallengeDetailsFrame(frame);
		self.frame = frame;
	end
	self.frame:Show();
end

--[[
Save dimension and position of main frame after resizing or moving

@method MyDungeonsBook:SaveFrameRect
]]
function MyDungeonsBook:SaveFrameRect(frame)
	local _, _, sw, sh = UIParent:GetRect();
	local x, y, w, h = frame:GetRect();
	self.db.profile.display.x = x + w/2 - sw/2;
	self.db.profile.display.y = y + h/2 - sh/2;
	self.db.profile.display.w = w;
	self.db.profile.display.h = h;
end