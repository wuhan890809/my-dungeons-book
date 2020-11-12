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
Creates a main frame for addon.

@return[type=Frame] frame
]]
function MyDungeonsBook:MainFrame_Create()
    local frame = AceGUI:Create("Frame");
	frame:SetWidth(1234); -- IDK why it can't be just 1200 :/
	frame:SetHeight(720);
	frame:SetPoint("CENTER", UIParent, "CENTER", self.db.profile.display.x, self.db.profile.display.y);
	frame:SetTitle(L["My Dungeons Book"]);
    frame:SetLayout("Fill");
	frame:EnableResize(false)
    frame:SetCallback("OnClose", function ()
		self.activeChallengeId = nil;
		self.activeChallengeMechanics = nil;
		self.challengeDetailsFrame.frame:Hide();
		self.challengesTable:ClearSelection();
        if (self.db.profile.performance.collectgarbage) then
            collectgarbage("collect");
        end
    end)
	return frame;
end

--[[--
Create (if not exists) a main frame and show it for player
]]
function MyDungeonsBook:MainFrame_Show()
	if (not self.frame) then
		local frame = self:MainFrame_Create();
		local grid = AceGUI:Create("SimpleGroup");
		grid:SetLayout("Flow");
		frame:AddChild(grid);
		frame:PauseLayout();
		local challengesTable, challengesFiltersFrame = self:ChallengesFrame_Create(grid);
		self.challengesTable = challengesTable;
		self.challengesFiltersFrame = challengesFiltersFrame;
		self.challengeDetailsFrame = self:ChallengeDetailsFrame_Create(grid);
		self.frame = frame;
		frame:ResumeLayout();
    end
	self.frame:Show();
	self.challengesTable:SetData(self:ChallengesFrame_GetDataForTable());
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
