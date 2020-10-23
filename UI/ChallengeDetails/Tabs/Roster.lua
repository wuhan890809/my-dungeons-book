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
Creates a frame for Roster tab

@param[type=Frame] parentFrame
@param[type=number] challengeId
@return[type=Frame] rosterFrame
]]
function MyDungeonsBook:RosterFrame_Create(parentFrame, challengeId)
	local rosterFrame = self:TabContentWrapperWidget_Create(parentFrame);
	local challenge = self.db.char.challenges[challengeId];
    if (challenge) then
        for _, unit in pairs(self:GetPartyRoster()) do
            self:RosterFrame_PartyMemberFrame_Create(rosterFrame, unit, challengeId);
        end
	end
	return rosterFrame;
end

--[[--
Creates a row for unit `unitId` with data about his name, role, class, realm and equipment

@param[type=Frame] rosterFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] partyMemberFrame
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_Create(rosterFrame, unitId, challengeId)
	local partyMemberFrame = AceGUI:Create("InlineGroup");
	partyMemberFrame:SetLayout("Flow");
	partyMemberFrame:SetFullWidth(true);
	partyMemberFrame:SetAutoAdjustHeight(false);
	partyMemberFrame:SetHeight(110);
	rosterFrame:AddChild(partyMemberFrame);
	local challenge = self.db.char.challenges[challengeId];
	partyMemberFrame:SetTitle(self:GetUnitNameRealmRoleStr(challenge.players[unitId]) or L["Not Found"]);
	self:RosterFrame_PartyMemberFrame_ClassIcon_Create(partyMemberFrame, unitId, challengeId);
	self:RosterFrame_PartyMemberFrame_SpecIcon_Create(partyMemberFrame, unitId, challengeId);
	self:RosterFrame_PartyMemberFrame_Equipment_Create(partyMemberFrame, unitId, challengeId);
	return partyMemberFrame;
end

--[[--
Creates a frame with class icon for `unitId`

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] classFrame
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_ClassIcon_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
	local classFrame = AceGUI:Create("InteractiveLabel");
	parentFrame:AddChild(classFrame);
    classFrame:SetWidth(35);
	classFrame.label:SetHeight(40);
	classFrame:SetCallback("OnEnter", function()
		self:RosterFrame_TableClassHover(classFrame, unitId);
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
@return[type=Frame] specFrame
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_SpecIcon_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
	local specFrame = AceGUI:Create("InteractiveLabel");
	parentFrame:AddChild(specFrame);
    specFrame:SetWidth(35);
	specFrame.label:SetHeight(40);
	specFrame:SetCallback("OnEnter", function()
		self:RosterFrame_TableSpecHover(specFrame, unitId);
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
Creates a frame with equipment for `unitId`.

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] itemFrames
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_Equipment_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
	local itemFrames = {};
	local itemsRow = AceGUI:Create("SimpleGroup");
	itemsRow:SetLayout("Flow");
	itemsRow:SetFullWidth(true);
	itemsRow:SetHeight(40);
	itemsRow:SetAutoAdjustHeight(false);
	parentFrame:AddChild(itemsRow);
	for i = 1, 16 do
		local itemFrame = AceGUI:Create("InteractiveLabel");
		itemsRow:AddChild(itemFrame);
		itemFrame:SetWidth(35);
		itemFrame.label:SetHeight(40);
		itemFrame:SetJustifyV("MIDDLE");
		itemFrame:SetCallback("OnEnter", function(frame)
			self:RosterFrame_TableItemHover(frame, unitId, i);
		end);
		itemFrame:SetCallback("OnLeave", function()
			self:Table_Cell_MouseOut();
		end);
        local itemFrameIndex;
        if (i <= 3) then
            itemFrameIndex = i;
        else
            itemFrameIndex = i - 1;
        end
        local itemString = challenge.players[unitId] and challenge.players[unitId].items and challenge.players[unitId].items[(i <= 3 and i) or i + 1] or nil;
        if (itemString) then
            local _, itemId = strsplit(":", itemString);
            if (itemId) then
				local suffix = self:GetIconTextureSuffix(30);
                itemFrame:SetText("|T" .. GetItemIcon(itemId) .. suffix .. "|t");
            end
        end
		tinsert(itemFrames, itemFrame);
    end
	return itemFrames;
end

--[[--
Mouse-hover handler for equiped item.

Shows a tooltip with data from item.

@param[type=Frame] itemFrame
@param[type=unitId] unitId
@param[type=number] itemIndex
]]
function MyDungeonsBook:RosterFrame_TableItemHover(itemFrame, unitId, itemIndex)
	local realItemIndex = itemIndex;
	if (itemIndex > 3) then
		realItemIndex = realItemIndex + 1;
	end
	local player = self.db.char.challenges[self.activeChallengeId].players[unitId];
	local itemString = player.items and self.db.char.challenges[self.activeChallengeId].players[unitId].items[realItemIndex] or nil;
	if (itemString) then
		GameTooltip:SetOwner(itemFrame.frame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", itemFrame.frame, "BOTTOMRIGHT");
		GameTooltip:SetHyperlink(self.db.char.challenges[self.activeChallengeId].players[unitId].items[realItemIndex]);
		GameTooltip:Show();
	end
end

--[[
Mouse-hover handler for spec icon.

Shows a spec name.

@param[type=Frame] specIconFrame
@param[type=unitId] unitId
]]
function MyDungeonsBook:RosterFrame_TableSpecHover(specIconFrame, unitId)
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
function MyDungeonsBook:RosterFrame_TableClassHover(classIconFrame, unitId)
	local class = self.db.char.challenges[self.activeChallengeId].players[unitId].class;
	if (class) then
		local className = GetClassInfo(self.db.char.challenges[self.activeChallengeId].players[unitId].class)
		GameTooltip:SetOwner(classIconFrame.frame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", classIconFrame.frame, "BOTTOMRIGHT");
		GameTooltip:AddLine(className, 1, 1, 1);
		GameTooltip:Show();
	end
end
