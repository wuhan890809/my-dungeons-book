--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Damage frame.

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `damageFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:DamageFrame_CreateTabButtonsFrame(parentFrame)
	local tabsButtonsFrame = CreateFrame("Frame", nil, parentFrame);
	tabsButtonsFrame:SetPoint("TOPLEFT", 10, -40);
	tabsButtonsFrame:SetWidth(900);
	tabsButtonsFrame:SetHeight(50);

	-- Avoidable Damage
	local avoidableDamageTabButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	avoidableDamageTabButton:SetPoint("TOPLEFT", 0, 0);
	avoidableDamageTabButton:SetText(L["Avoidable Damage"]);
	avoidableDamageTabButton:SetScript("OnClick", function()
		self:DamageFrame_ShowTab("avoidableDamage");
	end);
	PanelTemplates_TabResize(avoidableDamageTabButton, 0);

	-- Damage Done To Units
	local damageDoneToUnitsButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	damageDoneToUnitsButton:SetPoint("TOPLEFT", avoidableDamageTabButton, "TOPRIGHT", 0, 0);
	damageDoneToUnitsButton:SetText(L["Damage Done To Units"]);
	damageDoneToUnitsButton:SetScript("OnClick", function()
		self:DamageFrame_ShowTab("damageDoneToUnits");
	end);
	PanelTemplates_TabResize(damageDoneToUnitsButton, 0);

	-- Damage Done To Party Members
	local damageDoneToPartyMembersButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	damageDoneToPartyMembersButton:SetPoint("TOPLEFT", damageDoneToUnitsButton, "TOPRIGHT", 0, 0);
	damageDoneToPartyMembersButton:SetText(L["Damage Done To Party Members"]);
	damageDoneToPartyMembersButton:SetScript("OnClick", function()
		self:DamageFrame_ShowTab("damageDoneToPartyMembers");
	end);
	PanelTemplates_TabResize(damageDoneToPartyMembersButton, 0);

	tabsButtonsFrame.tabButtons = {
		avoidableDamage = avoidableDamageTabButton,
		damageDoneToUnits = damageDoneToUnitsButton,
		damageDoneToPartyMembers = damageDoneToPartyMembersButton
	};
	return tabsButtonsFrame;
end

--[[--
Click-handler for tab-button in the Damage frame.

Show selected tab, mark it as active, mark other as inactive and hide them.

@param[type=string] tabId
]]
function MyDungeonsBook:DamageFrame_ShowTab(tabId)
	for id, tabFrame in pairs(self.challengeDetailsFrame.mechanicsFrame.damageFrame.tabs) do
		local tabButtonFrame = self.challengeDetailsFrame.mechanicsFrame.damageFrame.tabButtonsFrame.tabButtons[id];
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
