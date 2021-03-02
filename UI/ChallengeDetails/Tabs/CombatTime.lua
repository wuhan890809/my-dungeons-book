--[[--
@module MyDungeonsBook
]]
local AceGUI = LibStub("AceGUI-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
--[[--
UI
@section UI
]]

--[[--
Creates a frame for Combat Time tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:CombatTimeFrame_Create(parentFrame, challengeId)
    local combatTimeFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local challenge = self:Challenge_GetById(challengeId);
    local idleMechanics = self:Challenge_Mechanic_GetById(challengeId, "PARTY_MEMBERS_IDLE");
    if (not idleMechanics) then
        return combatTimeFrame;
    end
    local name, nameAndRealm = self:GetNameByPartyUnit(challengeId, "player");
    local playerIdle = idleMechanics[name] or idleMechanics[nameAndRealm];
    local overallIdleTime = (playerIdle and playerIdle.meta.duration) or "?";
    local idleLabel = AceGUI:Create("Label");
    idleLabel:SetFullWidth(true);
    idleLabel:SetFontObject(GameFontNormalLarge);
    idleLabel:SetText(string.format(L["Overall Idle Time - %s"], self:FormatTime(overallIdleTime * 1000)));
    combatTimeFrame:AddChild(idleLabel);
    local xLimit = (challenge.challengeInfo.duration and challenge.challengeInfo.duration / 1000) or nil;
    local idleTimeGraph = self:SingleFilledAreaGraph_Create(combatTimeFrame, "IdleTimeGraph", playerIdle, challenge.challengeInfo.startTime, xLimit, 150);
    combatTimeFrame:SetUserData("idleTimeGraph", idleTimeGraph);
    combatTimeFrame:SetCallback("OnRelease", function(frame)
        frame:GetUserData("idleTimeGraph"):ResetData();
        frame:GetUserData("idleTimeGraph"):Hide();
    end);
    return combatTimeFrame;
end
