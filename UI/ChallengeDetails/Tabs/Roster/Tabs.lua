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
function MyDungeonsBook:RosterFrame_CreateTabButtonsFrame(parentFrame)
    local tabs = self:TabsWidget_Create(parentFrame);
    tabs:SetTabs({
        {value = "shortInfo", text = L["Info"]},
        {value = "equipment", text = L["Equipment"]},
        {value = "talents", text = L["Talents"]},
        {value = "covenant", text = L["Covenant"]},
        {value = "misc", text = L["Misc"]},
    });
    tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
        container:ReleaseChildren();
        if (tabId == "covenant") then
            self.covenantFrame = self:CovenantFrame_Create(container, self.activeChallengeId);
        end
        if (tabId == "shortInfo") then
            self.covenantFrame = self:ShortInfoFrame_Create(container, self.activeChallengeId);
        end
        if (tabId == "equipment") then
            self.equipmentFrame = self:EquipmentFrame_Create(container, self.activeChallengeId);
        end
        if (tabId == "talents") then
            self.talentsFrame = self:TalentsFrame_Create(container, self.activeChallengeId);
        end
        if (tabId == "misc") then
            self.talentsFrame = self:MiscFrame_Create(container, self.activeChallengeId);
        end
    end);
    tabs:SetHeight(622);
    return tabs;
end
