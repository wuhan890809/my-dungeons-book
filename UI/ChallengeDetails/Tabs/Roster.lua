--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section UI
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local ScrollPaneBackdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = {
		left = 3,
		right = 3,
		top = 5,
		bottom = 3
	}
};

--[[--
Creates a frame for Roster tab

@param[type=Frame] parentFrame
@return[type=Frame] challengeRosterFrame
]]
function MyDungeonsBook:RosterFrame_Create(parentFrame)
	local challengeRosterFrame = CreateFrame("Frame", nil, parentFrame);
	challengeRosterFrame:SetBackdrop(ScrollPaneBackdrop);
	challengeRosterFrame:SetBackdropColor(0.1, 0.1, 0.1);
	challengeRosterFrame:SetPoint("TOPRIGHT", -10, -90);
	challengeRosterFrame:SetWidth(900);
	challengeRosterFrame:SetHeight(215);
	for i, unit in pairs(self:GetPartyRoster()) do
		challengeRosterFrame[unit .. "DetailsFrame"] = self:RosterFrame_PartyMemberFrame_Create(challengeRosterFrame, 0, -10 + (i - 1) * -40, unit);
	end
	return challengeRosterFrame;
end

--[[--
Creates a row for unit `unitId` with data about his name, role, class, realm and equipment

@param[type=Frame] challengeRosterFrame
@param[type=number] x
@param[type=number] y
@param[type=unitId] unitId
@return[type=Frame] partyMemberFrame
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_Create(challengeRosterFrame, x, y, unitId)
	local partyMemberFrame = CreateFrame("Frame", nil, challengeRosterFrame);
	partyMemberFrame:SetPoint("TOPLEFT", x, y);
	partyMemberFrame:SetHeight(40);
	partyMemberFrame:SetWidth(900);
	partyMemberFrame.class = self:RosterFrame_PartyMemberFrame_ClassIcon_Create(partyMemberFrame, 5, 0, unitId);
	partyMemberFrame.spec = self:RosterFrame_PartyMemberFrame_SpecIcon_Create(partyMemberFrame, 45, 0, unitId);
	partyMemberFrame.nameAndRealmText = self:RosterFrame_PartyMemberFrame_NameAndRealmText_Create(partyMemberFrame, 90, 0);
	partyMemberFrame.ilvlText = self:RosterFrame_PartyMemberFrame_IlvlText_Create(partyMemberFrame, 195, 0);
	partyMemberFrame.equipment = self:RosterFrame_PartyMemberFrame_Equipment_Create(partyMemberFrame, 210, 0, unitId);
	return partyMemberFrame;
end

--[[--
Creates a frame with class icon for `unitId`

@param[type=Frame] parentFrame
@param[type=number] x
@param[type=number] y
@param[type=unitId] unitId
@return[type=Frame] classFrame
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_ClassIcon_Create(parentFrame, x, y, unitId)
	local classFrame = CreateFrame("Frame", 0, parentFrame);
	classFrame:SetWidth(40);
	classFrame:SetHeight(40);
	classFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y);
	classFrame:SetScript("OnEnter", function(frame)
		self:RosterFrame_TableClassHover(frame, unitId);
	end);
	classFrame:SetScript("OnLeave", function()
		self:Table_Cell_MouseOut();
	end);
	local text = classFrame:CreateFontString(nil, "ARTWORK");
	text:SetFontObject(GameFontNormal);
	text:SetTextColor(0.6, 0.6, 0.6);
	text:SetAllPoints(classFrame);
	classFrame.text = text;
	return classFrame;
end

--[[--
Creates a frame with spec icon for `unitId`

@param[type=Frame] parentFrame
@param[type=number] x
@param[type=number] y
@param[type=unitId] unitId
@return[type=Frame] specFrame
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_SpecIcon_Create(parentFrame, x, y, unitId)
	local specFrame = CreateFrame("Frame", 0, parentFrame);
	specFrame:SetWidth(40);
	specFrame:SetHeight(40);
	specFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y);
	specFrame:SetScript("OnEnter", function(frame)
		self:RosterFrame_TableSpecHover(frame, unitId);
	end);
	specFrame:SetScript("OnLeave", function()
		self:Table_Cell_MouseOut();
	end);
	local text = specFrame:CreateFontString(nil, "ARTWORK");
	text:SetFontObject(GameFontNormal);
	text:SetTextColor(0.6, 0.6, 0.6);
	text:SetAllPoints(specFrame);
	specFrame.text = text;
	return specFrame;
end

--[[--
Creates a frame with name and realm for unit

@param[type=Frame] parentFrame
@param[type=number] x
@param[type=number] y
@return[type=Frame] nameAndRealmText
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_NameAndRealmText_Create(parentFrame, x, y)
	local nameAndRealmText = parentFrame:CreateFontString(nil, "ARTWORK");
	nameAndRealmText:SetFontObject(GameFontNormal);
	nameAndRealmText:SetTextColor(0.6, 0.6, 0.6);
	nameAndRealmText:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y);
	nameAndRealmText:SetHeight(40);
	nameAndRealmText:SetJustifyH("LEFT");
	return nameAndRealmText;
end

--[[--
Creates a frame with ilvl for unit

@param[type=Frame] parentFrame
@param[type=number] x
@param[type=number] y
@return[type=Frame] ilvlText
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_IlvlText_Create(parentFrame, x, y)
	local ilvlText = parentFrame:CreateFontString(nil, "ARTWORK");
	ilvlText:SetFontObject(GameFontNormal);
	ilvlText:SetTextColor(0.6, 0.6, 0.6);
	ilvlText:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y);
	ilvlText:SetWidth(40);
	ilvlText:SetHeight(40);
	ilvlText:SetJustifyH("RIGHT");
	return ilvlText;
end

--[[--
Creates a frame with equipment for `unitId`.

@param[type=Frame] parentFrame
@param[type=number] x
@param[type=number] y
@param[type=unitId] unitId
@return[type=Frame] itemFrames
]]
function MyDungeonsBook:RosterFrame_PartyMemberFrame_Equipment_Create(parentFrame, x, y, unitId)
	local itemFrames = {};
	for i = 1, 16 do
		local itemFrame = CreateFrame("Frame", 0, parentFrame);
		itemFrame:SetWidth(40);
		itemFrame:SetHeight(40);
		itemFrame:SetPoint("TOPLEFT", x + 40 * i, y);
		itemFrame:SetScript("OnEnter", function(frame)
			self:RosterFrame_TableItemHover(frame, unitId, i);
		end);
		itemFrame:SetScript("OnLeave", function()
			self:Table_Cell_MouseOut();
		end);
		local text = itemFrame:CreateFontString(nil, "ARTWORK");
		text:SetFontObject(GameFontNormal);
		text:SetTextColor(0.6, 0.6, 0.6);
		text:SetAllPoints(itemFrame);
		itemFrame.text = text;
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
		GameTooltip:SetOwner(itemFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", itemFrame, "BOTTOMRIGHT");
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
		GameTooltip:SetOwner(specIconFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", specIconFrame, "BOTTOMRIGHT");
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
		GameTooltip:SetOwner(classIconFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", classIconFrame, "BOTTOMRIGHT");
		GameTooltip:AddLine(className, 1, 1, 1);
		GameTooltip:Show();
	end
end

--[[
@param[type=number] challengeId
]]
function MyDungeonsBook:RosterFrame_Update(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		for _, unit in pairs(self:GetPartyRoster()) do
			if (challenge.players[unit]) then
				self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].nameAndRealmText:SetText(self:GetUnitNameRealmRoleStr(challenge.players[unit]) or L["Not Found"]);
				self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].spec.text:SetText("");
				self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].class.text:SetText("");
				--self:RosterFrame_Update_Ilvl(challenge, unit);
				if (challenge.players[unit].class) then
					self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].class.text:SetText("|T" .. self:GetClassIconByIndex(challenge.players[unit].class) .. ":30:30:0:0:64:64:5:59:5:59|t");
				end
				if (challenge.players[unit].spec) then
					local _, _, _, icon = GetSpecializationInfoByID(challenge.players[unit].spec);
					if (icon) then
						self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].spec.text:SetText("|T" .. icon .. ":30:30:0:0:64:64:5:59:5:59|t");
					end
				end
				for i = 1, 17 do
					local itemFrameIndex;
					if (i <= 3) then
						itemFrameIndex = i;
					else
						itemFrameIndex = i - 1;
					end
					if (i ~= 4) then
						self:RosterFrame_Update_EquipedItem(challenge, unit, itemFrameIndex, i);
					end
				end
			else
				self:DebugPrint(string.format("%s not found", unit));
			end
		end
	else
		self:DebugPrint(string.format("Challenge #%s not found", challengeId));
	end
end

--[[--
Update an item slot for party member (`unit`) in the `challenge`.

`itemFrameIndex` and `itemIndex` will be different if item slot is after 4.

@local
@param[type=table] challenge
@param[type=unitId] unit
@param[type=number] itemFrameIndex
@param[type=number] itemIndex
]]
function MyDungeonsBook:RosterFrame_Update_EquipedItem(challenge, unit, itemFrameIndex, itemIndex)
	self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].equipment[itemFrameIndex].text:SetText("");
	local itemString = challenge.players[unit].items and challenge.players[unit].items[itemIndex] or nil;
	if (itemString) then
		local _, itemId = strsplit(":", itemString);
		if (itemId) then
			self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].equipment[itemFrameIndex].text:SetText("|T" .. GetItemIcon(itemId) .. ":30:30:0:0:64:64:5:59:5:59|t");
		end
	end
end

--[[--
TODO should be calculated right after players parsing.

Update average items level for party member (`unit`) in the `challenge`.

@local
@param[type=table] challenge
@param[type=unitId] unit
]]
function MyDungeonsBook:RosterFrame_Update_Ilvl(challenge, unit)
	self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].ilvlText:SetText("");
	local sum = 0;
	local itemsCount = 0;
	for i = 1, 17 do
		if (i ~= 4) then
			local itemLink = challenge.players[unit].items and challenge.players[unit].items[i] or nil;
			if (itemLink) then
				local _, _, _, itemLevel = GetItemInfo(itemLink);
				if (itemLevel) then
					sum = sum + itemLevel;
					itemsCount = itemsCount + 1;
				end
			end
		end
	end
	if (itemsCount ~= 0) then
		self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].ilvlText:SetText(string.format("%.2f", sum / itemsCount));
	end
end
