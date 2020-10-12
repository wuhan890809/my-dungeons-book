--[[--
Create a frame with tabs linked to `parentFrame`. Each tab is a value of `tabsDetails`.

It must have two fields - `id` and `title`. `id` must be unique in the scope of `tabsDetails`.

@param[type=Frame] parentFrame
@param[type=table] tabsDetails
]]
function MyDungeonsBook:Tabs_Create(parentFrame, tabsDetails)
    local tabsButtonsFrame = CreateFrame("Frame", nil, parentFrame);
    tabsButtonsFrame:SetPoint("TOPLEFT", 10, -40);
    tabsButtonsFrame:SetWidth(900);
    tabsButtonsFrame:SetHeight(50);
    tabsButtonsFrame.tabButtons = {};
    local previousButton;
    for _, tabDetails in pairs(tabsDetails) do
        local currentButton = CreateFrame("Button", nil, tabsButtonsFrame, "TabButtonTemplate");
        if (previousButton) then
            currentButton:SetPoint("TOPLEFT", previousButton, "TOPRIGHT", 0, 0);
        else
            currentButton:SetPoint("TOPLEFT", 0, 0);
        end
        currentButton:SetText(tabDetails.title);
        currentButton:SetScript("OnClick", function()
            self:Tab_Click(parentFrame, tabDetails.id);
        end);
        PanelTemplates_TabResize(currentButton, 0);
        tabsButtonsFrame.tabButtons[tabDetails.id] = currentButton;
        previousButton = currentButton;
    end
    return tabsButtonsFrame;
end

--[[--
Click-handler for tabs. It's called autimatically when user clicks on tab.

To call it manually `parentFrame` should be set to frame where `tabs` and `tabButtons` (result of `Tabs_Create`) are.
`tabId` should be one of `tabButtons` identifiers.

@param[type=Frame] parentFrame
@param[type=string] tabId
]]
function MyDungeonsBook:Tab_Click(parentFrame, tabId)
    if (not parentFrame.tabs or not parentFrame.tabButtonsFrame) then
        self:DebugPrint(string.format("tabs or tabButtons frame is missing. Tab ID is %s", tabId));
    end
    for id, tabFrame in pairs(parentFrame.tabs) do
        local tabButtonFrame = parentFrame.tabButtonsFrame.tabButtons[id];
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
