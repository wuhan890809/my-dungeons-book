--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
Creates tabs (with click-handlers) for Healing frame.

@param[type=Frame] parentFrame
@return[type=Frame] tabsButtonsFrame
]]
function MyDungeonsBook:HealByPartyMemberFrame_CreateTabButtonsFrame(parentFrame, unitId)
    local tabs = self:TabsWidget_Create(parentFrame);
    tabs:SetTabs({
        {value = "bySpell", text = L["By Spell"]},
        {value = "toEachPartyMember", text = L["To Each Party Member"]}
    });
    tabs:SetCallback("OnGroupSelected", function (container, _, tabId)
        container:ReleaseChildren();
        if (tabId == "bySpell") then
            self:HealByPartyMemberBySpellFrame_Create(container, self.activeChallengeId, unitId);
        end
        if (tabId == "toEachPartyMember") then
            self:HealByPartyMemberToEachPartyMemberFrame_Create(container, self.activeChallengeId, unitId);
        end
    end);
    tabs:SetHeight(550);
    return tabs;
end
