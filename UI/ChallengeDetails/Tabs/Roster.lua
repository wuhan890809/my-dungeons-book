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
	self:RosterFrame_PartyMemberFrame_Race_Create(partyMemberFrame, unitId, challengeId);
	self:RosterFrame_PartyMemberFrame_Covenant_Create(partyMemberFrame, unitId, challengeId);
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
@param[type=number] challengeId
@return[type=Frame] specFrame
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_SpecIcon_Create(parentFrame, unitId, challengeId)
    local challenge = self.db.char.challenges[challengeId];
	local specFrame = AceGUI:Create("InteractiveLabel");
	parentFrame:AddChild(specFrame);
    specFrame:SetWidth(35);
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
Creates a frame with `unitId`'s race.

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
@return[type=Frame] raceFrame
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_Race_Create(parentFrame, unitId, challengeId)
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
Creates a frame with `unitId`'s covenant.

@param[type=Frame] parentFrame
@param[type=unitId] unitId
@param[type=number] challengeId
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_Covenant_Create(parentFrame, unitId, challengeId)
	local challenge = self.db.char.challenges[challengeId];
	local covenantIconFrame = AceGUI:Create("InteractiveLabel");
	parentFrame:AddChild(covenantIconFrame);
	local unitCovenantInfo = challenge.players[unitId] and challenge.players[unitId].covenant;
	if (not unitCovenantInfo or not unitCovenantInfo.id) then
		return;
	end
	local id = unitCovenantInfo.id;
	local covenantMetaInfo = C_Covenants.GetCovenantData(unitCovenantInfo.id);
	local suffix = self:GetIconTextureSuffix(30);
	covenantIconFrame:SetText("|T" .. self:GetCovenantIconId(id) .. suffix .. "|t");
	covenantIconFrame:SetCallback("OnEnter", function()
		GameTooltip:SetOwner(covenantIconFrame.frame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", covenantIconFrame.frame, "BOTTOMRIGHT");
		GameTooltip:AddLine(covenantMetaInfo.name, 1, 1, 1);
		GameTooltip:Show();
	end);
	covenantIconFrame:SetCallback("OnLeave", function()
		self:Table_Cell_MouseOut();
	end);
	covenantIconFrame:SetWidth(40);
	local soulbindFrame = AceGUI:Create("Label");
	soulbindFrame:SetText(unitCovenantInfo.soulbind.name);
	soulbindFrame:SetWidth(60);
	parentFrame:AddChild(soulbindFrame);
	table.sort(unitCovenantInfo.soulbind.conduits, function (c1, c2)
		return c1.row < c2.row;
	end);
	for _, conduit in pairs(unitCovenantInfo.soulbind.conduits) do
		local conduitFrame = AceGUI:Create("InteractiveLabel");
		local spellId = conduit.spellID;
		local icon = conduit.icon;
		if (spellId == 0 and conduit.conduitID ~= 0) then
			spellId = C_Soulbinds.GetConduitSpellID(conduit.conduitID, conduit.conduitRank);
		end
		if (conduit.conduitID ~= 0) then
			icon = select(3, GetSpellInfo(spellId));
		end
		conduitFrame:SetText("|T".. icon .. suffix .."|t");
		conduitFrame:SetWidth(40);
		conduitFrame:SetCallback("OnEnter", function()
			GameTooltip:SetOwner(conduitFrame.frame, "ANCHOR_NONE");
			GameTooltip:SetPoint("BOTTOMLEFT", conduitFrame.frame, "BOTTOMRIGHT");
			if (conduit.conduitID == 0) then
				GameTooltip:SetSpellByID(spellId);
			else
				GameTooltip:SetHyperlink(C_Soulbinds.GetConduitHyperlink(conduit.conduitID, conduit.conduitRank));
			end
			GameTooltip:Show();
		end);
		conduitFrame:SetCallback("OnLeave", function()
			self:Table_Cell_MouseOut();
		end);
		parentFrame:AddChild(conduitFrame);
	end
	return covenantIconFrame;
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
	--local itemsRow = AceGUI:Create("SimpleGroup");
	--[[itemsRow:SetLayout("Flow");
	itemsRow:SetFullWidth(true);
	itemsRow:SetHeight(40);]]
	local itemsTitle = AceGUI:Create("Label");
	itemsTitle:SetText("Items:");
	itemsTitle:SetFullWidth(true);
	parentFrame:AddChild(itemsTitle);
	--parentFrame:AddChild(itemsRow);
	for i = 1, 16 do
		local itemFrame = AceGUI:Create("InteractiveLabel");
		parentFrame:AddChild(itemFrame);
		itemFrame:SetWidth(35);
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
