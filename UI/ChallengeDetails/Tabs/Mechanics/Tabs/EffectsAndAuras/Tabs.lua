--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Effects And Auras frame.

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `damageFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:EffectsAndAurasFrame_CreateTabButtonsFrame(parentFrame)
	local tabsButtonsFrame = CreateFrame("Frame", nil, parentFrame);
	tabsButtonsFrame:SetPoint("TOPLEFT", 10, -40);
	tabsButtonsFrame:SetWidth(900);
	tabsButtonsFrame:SetHeight(50);

	--  Avoidable Debuffs
	local avoidableDebuffsTabButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	avoidableDebuffsTabButton:SetPoint("TOPLEFT", 0, 0);
	avoidableDebuffsTabButton:SetText(L["Avoidable Debuffs"]);
	avoidableDebuffsTabButton:SetScript("OnClick", function()
		self:EffectsAndAurasFrame_ShowTab("avoidableDebuffs");
	end);
	PanelTemplates_TabResize(avoidableDebuffsTabButton, 0);

	-- Buffs Or Debuffs On Units
	local buffsOrDebuffsOnUnitsButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	buffsOrDebuffsOnUnitsButton:SetPoint("TOPLEFT", avoidableDebuffsTabButton, "TOPRIGHT", 0, 0);
	buffsOrDebuffsOnUnitsButton:SetText(L["Buffs Or Debuffs On Units"]);
	buffsOrDebuffsOnUnitsButton:SetScript("OnClick", function()
		self:EffectsAndAurasFrame_ShowTab("buffsOrDebuffsOnUnits");
	end);
	PanelTemplates_TabResize(buffsOrDebuffsOnUnitsButton, 0);
	
	-- Buffs Or Debuffs On Party Members
	local buffsOrDebuffsOnPartyMembersButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	buffsOrDebuffsOnPartyMembersButton:SetPoint("TOPLEFT", buffsOrDebuffsOnUnitsButton, "TOPRIGHT", 0, 0);
	buffsOrDebuffsOnPartyMembersButton:SetText(L["Buffs Or Debuffs On Party Members"]);
	buffsOrDebuffsOnPartyMembersButton:SetScript("OnClick", function()
		self:EffectsAndAurasFrame_ShowTab("buffsOrDebuffsOnPartyMembers");
	end);
	PanelTemplates_TabResize(buffsOrDebuffsOnPartyMembersButton, 0);

	-- All Buffs On Party Members
	local allBuffsOnPartyMembersButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	allBuffsOnPartyMembersButton:SetPoint("TOPLEFT", buffsOrDebuffsOnPartyMembersButton, "TOPRIGHT", 0, 0);
	allBuffsOnPartyMembersButton:SetText(L["All Buffs On Party Members"]);
	allBuffsOnPartyMembersButton:SetScript("OnClick", function()
		self:EffectsAndAurasFrame_ShowTab("allBuffsOnPartyMembers");
	end);
	PanelTemplates_TabResize(allBuffsOnPartyMembersButton, 0);

	-- All Debuffs On Party Members
	local allDebuffsOnPartyMembersButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	allDebuffsOnPartyMembersButton:SetPoint("TOPLEFT", allBuffsOnPartyMembersButton, "TOPRIGHT", 0, 0);
	allDebuffsOnPartyMembersButton:SetText(L["All Debuffs On Party Members"]);
	allDebuffsOnPartyMembersButton:SetScript("OnClick", function()
		self:EffectsAndAurasFrame_ShowTab("allDebuffsOnPartyMembers");
	end);
	PanelTemplates_TabResize(allDebuffsOnPartyMembersButton, 0);

	tabsButtonsFrame.tabButtons = {
		avoidableDebuffs = avoidableDebuffsTabButton,
		buffsOrDebuffsOnUnits = buffsOrDebuffsOnUnitsButton,
		buffsOrDebuffsOnPartyMembers = buffsOrDebuffsOnPartyMembersButton,
		allBuffsOnPartyMembers = allBuffsOnPartyMembersButton,
		allDebuffsOnPartyMembers = allDebuffsOnPartyMembersButton
	};
	return tabsButtonsFrame;
end

--[[--
Click-handler for tab-button in the Effects And Auras frame.

Show selected tab, mark it as active, mark other as inactive and hide them.

@param[type=string] tabId
]]
function MyDungeonsBook:EffectsAndAurasFrame_ShowTab(tabId)
	for id, tabFrame in pairs(self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.tabs) do
		local tabButtonFrame = self.challengeDetailsFrame.mechanicsFrame.effectsAndAurasFrame.tabButtonsFrame.tabButtons[id];
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
