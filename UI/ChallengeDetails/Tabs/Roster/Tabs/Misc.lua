--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
local AceGUI = LibStub("AceGUI-3.0");

--[[--
Creates a frame for Misc tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:MiscFrame_Create(parentFrame, challengeId)
    local miscFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local challenge = self:Challenge_GetById(challengeId);
    if (not challenge) then
        return;
    end
    self:MiscFrame_MawPowers_Create(miscFrame, challengeId);
    return miscFrame;
end

--[[--
Creates a frame with `unitId`'s misc info

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
]]
function MyDungeonsBook:MiscFrame_MawPowers_Create(parentFrame, challengeId)
    local challenge = self:Challenge_GetById(challengeId);
    if (not challenge) then
        return;
    end
    local affixes = challenge.challengeInfo.affixes;
    if (#affixes ~= 4 or affixes[4] ~= 128) then
        return;
    end
    local mawPowersFrame = AceGUI:Create("InlineGroup");
    mawPowersFrame:SetLayout("Flow");
    mawPowersFrame:SetFullWidth(true);
    mawPowersFrame:SetTitle(L["Anima Powers"]);
    parentFrame:AddChild(mawPowersFrame);
    for _, unitId in pairs(self:GetPartyRoster()) do
        local nameFrame = AceGUI:Create("Label");
        mawPowersFrame:AddChild(nameFrame);
        if (challenge.players[unitId]) then
            nameFrame:SetText(self:GetUnitNameRealmRoleStr(challenge.players[unitId]) or L["Not Found"]);
        end
        nameFrame:SetWidth(200);
        local suffix = self:GetIconTextureSuffix(30);
        if (challenge.players[unitId].misc.animaPowers and challenge.players[unitId].misc.animaPowers.powers) then
            for _, animaPower in pairs(challenge.players[unitId].misc.animaPowers.powers) do
                local mawPowerFrame = AceGUI:Create("InteractiveLabel");
                local spellId = animaPower.spellId;
                local icon = animaPower.icon;
                mawPowerFrame:SetText("|T".. icon .. suffix .."|t");
                mawPowerFrame:SetWidth(35);
                mawPowerFrame:SetCallback("OnEnter", function()
                    self:Table_Cell_SpellMouseHover(mawPowerFrame.frame, spellId);
                end);
                mawPowerFrame:SetCallback("OnLeave", function()
                    self:Table_Cell_MouseOut();
                end);
                mawPowersFrame:AddChild(mawPowerFrame);
            end
        end
        self:NewLine_Create(mawPowersFrame);
    end
end