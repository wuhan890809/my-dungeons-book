--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Roster frame.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:ProgressFrame_CreateTabButtonsFrame(parentFrame)
    local tabs = self:TabsWidget_Create(parentFrame);
    tabs:SetTabs({
        {value = "encounters", text = L["Encounters"]},
        {value = "units", text = L["Enemy Forces"]},
        {value = "combatTime", text = L["Combat Time"]},
    });
    tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
        container:ReleaseChildren();
        if (tabId == "units") then
            self.unitsFrame = self:UnitsFrame_Create(container, self.activeChallengeId);
        end
        if (tabId == "combatTime") then
            self.combatTimeFrame = self:CombatTimeFrame_Create(container, self.activeChallengeId);
        end
        if (tabId == "encounters") then
            self.encountersFrame = self:EncountersFrame_Create(container, self.activeChallengeId);
        end
    end);
    tabs:SetHeight(622);
    return tabs;
end
