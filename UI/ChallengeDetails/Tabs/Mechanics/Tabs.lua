local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[
@method MyDungeonsBook:ChallengeDetailsFrame_Mechanics_CreateTabButtonsFrame
@param {table} parentFrame
@return {table} tabsButtonsFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_Mechanics_CreateTabButtonsFrame(parentFrame)
	local tabsButtonsFrame = CreateFrame("Frame", nil, parentFrame);
	tabsButtonsFrame:SetPoint("TOPLEFT", 10, -40);
	tabsButtonsFrame:SetWidth(900);
	tabsButtonsFrame:SetHeight(50);

	-- Special Casts
	local specialCastsButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	specialCastsButton:SetPoint("TOPLEFT", 0, 0);
	specialCastsButton:SetText(L["Special Casts"]);
	specialCastsButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_Mechanics_ShowTab("specialCasts");
	end);
	PanelTemplates_TabResize(specialCastsButton, 0);

	-- Damage Done To Units
	local damageDoneToUnitsButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	damageDoneToUnitsButton:SetPoint("TOPLEFT", specialCastsButton, "TOPRIGHT", 0, 0);
	damageDoneToUnitsButton:SetText(L["Damage Done To Units"]);
	damageDoneToUnitsButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_Mechanics_ShowTab("damageDoneToUnits");
	end);
	PanelTemplates_TabResize(damageDoneToUnitsButton, 0);

	-- Buffs Or Debuffs On Units
	local buffsOrDebuffsOnUnitsButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	buffsOrDebuffsOnUnitsButton:SetPoint("TOPLEFT", damageDoneToUnitsButton, "TOPRIGHT", 0, 0);
	buffsOrDebuffsOnUnitsButton:SetText(L["Buffs Or Debuffs On Units"]);
	buffsOrDebuffsOnUnitsButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_Mechanics_ShowTab("buffsOrDebuffsOnUnits");
	end);
	PanelTemplates_TabResize(buffsOrDebuffsOnUnitsButton, 0);
	
	-- Buffs Or Debuffs On Party Members
	local buffsOrDebuffsOnPartyMembersButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	buffsOrDebuffsOnPartyMembersButton:SetPoint("TOPLEFT", buffsOrDebuffsOnUnitsButton, "TOPRIGHT", 0, 0);
	buffsOrDebuffsOnPartyMembersButton:SetText(L["Buffs Or Debuffs On Party Members"]);
	buffsOrDebuffsOnPartyMembersButton:SetScript("OnClick", function()
		self:ChallengeDetailsFrame_Mechanics_ShowTab("buffsOrDebuffsOnPartyMembers");
	end);
	PanelTemplates_TabResize(buffsOrDebuffsOnPartyMembersButton, 0);

	tabsButtonsFrame.tabButtons = {
		specialCasts = specialCastsButton,
		damageDoneToUnits = damageDoneToUnitsButton,
		buffsOrDebuffsOnUnits = buffsOrDebuffsOnUnitsButton,
		buffsOrDebuffsOnPartyMembers = buffsOrDebuffsOnPartyMembersButton
	};
	return tabsButtonsFrame;
end

--[[
@method MyDungeonsBook:ChallengeDetailsFrame_Mechanics_ShowTab
@param {string} tabId
]]
function MyDungeonsBook:ChallengeDetailsFrame_Mechanics_ShowTab(tabId)
	for id, tabFrame in pairs(self.challengeDetailsFrame.mechanicsFrame.tabs) do
		local tabButtonFrame = self.challengeDetailsFrame.mechanicsFrame.tabButtonsFrame.tabButtons[id];
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
