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
Creates a frame for Equipment tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame]
]]
function MyDungeonsBook:ShortInfoFrame_Create(parentFrame, challengeId)
    local partyMemberShortInfoFrame = self:TabContentWrapperWidget_Create(parentFrame);
    local challenge = self.db.char.challenges[challengeId];
    if (not challenge) then
        return;
    end
    local wrapperFrame = AceGUI:Create("InlineGroup");
    wrapperFrame:SetLayout("Flow");
    wrapperFrame:SetFullWidth(true);
    for _, unit in pairs(self:GetPartyRoster()) do
        self:ShortInfoFrame_PartyMemberFrame_Create(wrapperFrame, unit, challengeId);
    end
    partyMemberShortInfoFrame:AddChild(wrapperFrame);
    return partyMemberShortInfoFrame;
end

--[[--
Creates a row for unit `unitId` with data about his name, role, class, realm and equipment

@param[type=Frame] rosterFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] partyMemberFrame
]]
function MyDungeonsBook:ShortInfoFrame_PartyMemberFrame_Create(rosterFrame, unitId, challengeId)
    self:ShortInfoFrame_PartyMemberFrame_ClassIcon_Create(rosterFrame, unitId, challengeId);
    self:ShortInfoFrame_PartyMemberFrame_SpecIcon_Create(rosterFrame, unitId, challengeId);
    self:ShortInfoFrame_PartyMemberFrame_Name_Create(rosterFrame, unitId, challengeId);
    self:ShortInfoFrame_PartyMemberFrame_Race_Create(rosterFrame, unitId, challengeId);
    self:NewLine_Create(rosterFrame);
end

--[[--
Creates a frame with class icon for `unitId`

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] classFrame
]]
function MyDungeonsBook:ShortInfoFrame_PartyMemberFrame_ClassIcon_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
    local classFrame = AceGUI:Create("InteractiveLabel");
    parentFrame:AddChild(classFrame);
    classFrame:SetWidth(35);
    classFrame:SetCallback("OnEnter", function()
        self:ShortInfoFrame_TableClassHover(classFrame, unitId);
    end);
    classFrame:SetCallback("OnLeave", function()
        self:Table_Cell_MouseOut();
    end);
    if (challenge.players[unitId].class) then
        local suffix = self:GetIconTextureSuffix(30);
        classFrame:SetText("|T" .. self:GetClassIconByIndex(challenge.players[unitId].class) .. suffix .. "|t");
    end
    return classFrame;
end

--[[--
Creates a frame with spec icon for `unitId`

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] specFrame
]]
function MyDungeonsBook:ShortInfoFrame_PartyMemberFrame_SpecIcon_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
    local specFrame = AceGUI:Create("InteractiveLabel");
    parentFrame:AddChild(specFrame);
    specFrame:SetWidth(35);
    specFrame:SetCallback("OnEnter", function()
        self:ShortInfoFrame_TableSpecHover(specFrame, unitId);
    end);
    specFrame:SetCallback("OnLeave", function()
        self:Table_Cell_MouseOut();
    end);
    if (challenge.players[unitId].spec) then
        local _, _, _, icon = GetSpecializationInfoByID(challenge.players[unitId].spec);
        if (icon) then
            local suffix = self:GetIconTextureSuffix(30);
            specFrame:SetText("|T" .. icon .. suffix .. "|t");
        end
    end
    return specFrame;
end

--[[--
Creates a frame with `unitId`'s race.

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] raceFrame
]]
function MyDungeonsBook:ShortInfoFrame_PartyMemberFrame_Race_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
    local raceFrame = AceGUI:Create("Label");
    parentFrame:AddChild(raceFrame);
    if (challenge.players[unitId]) then
        raceFrame:SetText(string.format(L["Race: %s"], challenge.players[unitId].race or L["Not Found"]));
    end
    raceFrame:SetWidth(150);
    return raceFrame;
end

--[[--
Creates a frame with `unitId`'s race.

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] raceFrame
]]
function MyDungeonsBook:ShortInfoFrame_PartyMemberFrame_Name_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
    local nameFrame = AceGUI:Create("Label");
    parentFrame:AddChild(nameFrame);
    if (challenge.players[unitId]) then
        nameFrame:SetText(self:GetUnitNameRealmRoleStr(challenge.players[unitId]) or L["Not Found"]);
    end
    nameFrame:SetWidth(200);
    return nameFrame;
end

--[[
Mouse-hover handler for spec icon.

Shows a spec name.

@param[type=Frame] specIconFrame
@param[type=unitId] unitId
]]
function MyDungeonsBook:ShortInfoFrame_TableSpecHover(specIconFrame, unitId)
    local spec = self.db.char.challenges[self.activeChallengeId].players[unitId].spec;
    if (spec) then
        local _, specName = GetSpecializationInfoByID(self.db.char.challenges[self.activeChallengeId].players[unitId].spec);
        GameTooltip:SetOwner(specIconFrame.frame, "ANCHOR_NONE");
        GameTooltip:SetPoint("BOTTOMLEFT", specIconFrame.frame, "BOTTOMRIGHT");
        GameTooltip:AddLine(specName, 1, 1, 1);
        GameTooltip:Show();
    end
end

--[[--
Mouse-hover handler for class icon.

Shows a class name.

@param[type=Frame] classIconFrame
@param[type=unitId] unitId
]]
function MyDungeonsBook:ShortInfoFrame_TableClassHover(classIconFrame, unitId)
    local class = self.db.char.challenges[self.activeChallengeId].players[unitId].class;
    if (class) then
        local className = GetClassInfo(self.db.char.challenges[self.activeChallengeId].players[unitId].class)
        GameTooltip:SetOwner(classIconFrame.frame, "ANCHOR_NONE");
        GameTooltip:SetPoint("BOTTOMLEFT", classIconFrame.frame, "BOTTOMRIGHT");
        GameTooltip:AddLine(className, 1, 1, 1);
        GameTooltip:Show();
    end
end
