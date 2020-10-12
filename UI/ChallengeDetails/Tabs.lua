--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for ChallengeDetails frame.

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `challengeDetailsFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreateTabButtonsFrame(parentFrame)
	local tabsButtonsFrame = CreateFrame("Frame", nil, parentFrame);
	tabsButtonsFrame:SetPoint("TOPLEFT", 0, -40);
	tabsButtonsFrame:SetWidth(900);
	tabsButtonsFrame:SetHeight(50);

	-- Roster
	local rosterTabButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	rosterTabButton:SetPoint("TOPLEFT", 0, 0);
	rosterTabButton:SetText(L["Roster"]);
	rosterTabButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_ShowTab("roster");
	end);
	PanelTemplates_TabResize(rosterTabButton, 0);

	-- Details
	local detailsTabButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	detailsTabButton:SetPoint("TOPLEFT", rosterTabButton, "TOPRIGHT", 0, 0);
	detailsTabButton:SetText(L["Details"]);
	detailsTabButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_ShowTab("details");
	end);
	PanelTemplates_TabResize(detailsTabButton, 0);

	-- Encouters
	local encountersTabButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	encountersTabButton:SetPoint("TOPLEFT", detailsTabButton, "TOPRIGHT", 0, 0);
	encountersTabButton:SetText(L["Encounters"]);
	encountersTabButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_ShowTab("encounters");
	end);
	PanelTemplates_TabResize(encountersTabButton, 0);

	-- Interrupts
	local interruptsTabButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	interruptsTabButton:SetPoint("TOPLEFT", encountersTabButton, "TOPRIGHT", 0, 0);
	interruptsTabButton:SetText(L["Interrupts"]);
	interruptsTabButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_ShowTab("interrupts");
	end);
	PanelTemplates_TabResize(interruptsTabButton, 0);

	-- Mechanics
	local mechanicsTabButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	mechanicsTabButton:SetPoint("TOPLEFT", interruptsTabButton, "TOPRIGHT", 0, 0);
	mechanicsTabButton:SetText(L["Mechanics"]);
	mechanicsTabButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_ShowTab("mechanics");
	end);
	PanelTemplates_TabResize(mechanicsTabButton, 0);

	-- DEV
	local devTabButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	devTabButton:SetPoint("TOPLEFT", mechanicsTabButton, "TOPRIGHT", 0, 0);
	devTabButton:SetText(L["DEV"]);
	devTabButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_ShowTab("dev");
	end);
	PanelTemplates_TabResize(devTabButton, 0);
	
	tabsButtonsFrame.tabButtons = {
		roster = rosterTabButton,
		avoidableDebuffs = avoidableDebuffsTabButton,
		details = detailsTabButton,
		interrupts = interruptsTabButton,
		encounters = encountersTabButton,
		mechanics = mechanicsTabButton,
		dev = devTabButton
	};
	return tabsButtonsFrame;
end

--[[--
Click-handler for tab-button in the ChallengeDetails frame.

Show selected tab, mark it as active, mark other as inactive and hide them.

@param[type=string] tabId
]]
function MyDungeonsBook:ChallengeDetailsFrame_ShowTab(tabId)
	for id, tabFrame in pairs(self.challengeDetailsFrame.tabs) do
		local tabButtonFrame = self.challengeDetailsFrame.tabButtonsFrame.tabButtons[id];
		if (id == tabId) then
			tabButtonFrame:Disable();
			tabButtonFrame:SetDisabledFontObject(GameFontHighlightSmall);
			tabFrame:Show();
		else
			tabButtonFrame:Enable();
			tabFrame:Hide();
		end
	end
end
