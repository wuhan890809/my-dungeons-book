--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Mechanics frame.

Created frame has a field `tabButtons` with tab-buttons. Keys in the `tabButtons` are equal to keys in the `mechanicsFrame.tabs`.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:MechanicsFrame_CreateTabButtonsFrame(parentFrame)
	local tabsButtonsFrame = CreateFrame("Frame", nil, parentFrame);
	tabsButtonsFrame:SetPoint("TOPLEFT", 10, -40);
	tabsButtonsFrame:SetWidth(900);
	tabsButtonsFrame:SetHeight(50);

	-- Special Casts
	local specialCastsButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	specialCastsButton:SetPoint("TOPLEFT", 0, 0);
	specialCastsButton:SetText(L["Special Casts"]);
	specialCastsButton:SetScript("OnClick", function()
		self:MechanicsFrame_ShowTab("specialCasts");
	end);
	PanelTemplates_TabResize(specialCastsButton, 0);

	-- Used Items
	local usedItemsButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	usedItemsButton:SetPoint("TOPLEFT", specialCastsButton, "TOPRIGHT", 0, 0);
	usedItemsButton:SetText(L["Used Items"]);
	usedItemsButton:SetScript("OnClick", function()
		self:MechanicsFrame_ShowTab("usedItems");
	end);
	PanelTemplates_TabResize(usedItemsButton, 0);

	-- Damage
	local damageButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	damageButton:SetPoint("TOPLEFT", usedItemsButton, "TOPRIGHT", 0, 0);
	damageButton:SetText(L["Damage"]);
	damageButton:SetScript("OnClick", function()
		self:MechanicsFrame_ShowTab("damage");
	end);
	PanelTemplates_TabResize(damageButton, 0);

	-- Effects and Auras
	local effectsAndAurasButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
	effectsAndAurasButton:SetPoint("TOPLEFT", damageButton, "TOPRIGHT", 0, 0);
	effectsAndAurasButton:SetText(L["Effects and Auras"]);
	effectsAndAurasButton:SetScript("OnClick", function()
		self:MechanicsFrame_ShowTab("effectsAndAuras");
	end);
	PanelTemplates_TabResize(effectsAndAurasButton, 0);

	tabsButtonsFrame.tabButtons = {
		specialCasts = specialCastsButton,
		usedItems = usedItemsButton,
		damage = damageButton,
		effectsAndAuras = effectsAndAurasButton
	};
	return tabsButtonsFrame;
end

--[[--
Click-handler for tab-button in the Mechanics frame.

Show selected tab, mark it as active, mark other as inactive and hide them.

@param[type=string] tabId
]]
function MyDungeonsBook:MechanicsFrame_ShowTab(tabId)
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
