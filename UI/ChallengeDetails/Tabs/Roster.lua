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

--[[
Create a frame for Roster tab

@method MyDungeonsBook:CreateChallengeRosterFrame
@param {table} frame
@return {table} challengeRosterFrame
]]
function MyDungeonsBook:CreateChallengeRosterFrame(frame)
	local challengeRosterFrame = CreateFrame("Frame", nil, frame);
	challengeRosterFrame:SetBackdrop(ScrollPaneBackdrop);
	challengeRosterFrame:SetBackdropColor(0.1, 0.1, 0.1);
	challengeRosterFrame:SetPoint("TOPRIGHT", -10, -90);
	challengeRosterFrame:SetWidth(900);
	challengeRosterFrame:SetHeight(215);
	for i, unit in pairs(self:GetPartyRoster()) do
		challengeRosterFrame[unit .. "DetailsFrame"] = self:ChallengeDetailsFrame_CreatePartyMemberFrame(challengeRosterFrame, 0, -10 + (i - 1) * -40, unit);
	end
	return challengeRosterFrame;
end

--[[
Create a row for unit `unitId` with data about his name, role, class, realm and equipment

@method MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberFrame
@param {table} challengeRosterFrame
@param {number} x
@param {number} y
@param {unitId} unitId
@return {table} partyMemberFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberFrame(challengeRosterFrame, x, y, unitId)
	local partyMemberFrame = CreateFrame("Frame", nil, challengeRosterFrame);
	partyMemberFrame:SetPoint("TOPLEFT", x, y);
	partyMemberFrame:SetHeight(40);
	partyMemberFrame:SetWidth(900);
	partyMemberFrame.class = self:ChallengeDetailsFrame_CreatePartyMemberClassIcon(partyMemberFrame, 5, 0, unitId);
	partyMemberFrame.spec = self:ChallengeDetailsFrame_CreatePartyMemberSpecIcon(partyMemberFrame, 45, 0, unitId);
	partyMemberFrame.nameAndRealmText = self:ChallengeDetailsFrame_CreatePartyMemberNameAndRealmText(partyMemberFrame, 90, 0);
	partyMemberFrame.ilvlText = self:ChallengeDetailsFrame_CreatePartyMemberIlvlText(partyMemberFrame, 195, 0);
	partyMemberFrame.equipment = self:ChallengeDetailsFrame_CreatePartyMemberEquipment(partyMemberFrame, 210, 0, unitId);
	return partyMemberFrame;
end

--[[
Create a frame with class icon for `unitId`

@method MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberClassIcon
@param {table} parentFrame
@param {number} x
@param {number} y
@param {unitId} unitId
@return {table} classFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberClassIcon(parentFrame, x, y, unitId)
	local classFrame = CreateFrame("Frame", 0, parentFrame);
	classFrame:SetWidth(40);
	classFrame:SetHeight(40);
	classFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y);
	classFrame:SetScript("OnEnter", function(frame)
		self:ChallengeDetailsFrame_ClassHover(frame, unitId);
	end);
	classFrame:SetScript("OnLeave", function(frame)
		self:ChallengeDetailsFrame_ClassOut(frame);
	end);
	local text = classFrame:CreateFontString(nil, "ARTWORK");
	text:SetFontObject(GameFontNormal);
	text:SetTextColor(0.6, 0.6, 0.6);
	text:SetAllPoints(classFrame);
	classFrame.text = text;
	return classFrame;
end

--[[
Create a frame with spec icon for `unitId`

@method MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberSpecIcon
@param {table} parentFrame
@param {number} x
@param {number} y
@param {unitId} unitId
@return {table} specFrame
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberSpecIcon(parentFrame, x, y, unitId)
	local specFrame = CreateFrame("Frame", 0, parentFrame);
	specFrame:SetWidth(40);
	specFrame:SetHeight(40);
	specFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y);
	specFrame:SetScript("OnEnter", function(frame)
		self:ChallengeDetailsFrame_SpecHover(frame, unitId);
	end);
	specFrame:SetScript("OnLeave", function(frame)
		self:ChallengeDetailsFrame_SpecOut(frame);
	end);
	local text = specFrame:CreateFontString(nil, "ARTWORK");
	text:SetFontObject(GameFontNormal);
	text:SetTextColor(0.6, 0.6, 0.6);
	text:SetAllPoints(specFrame);
	specFrame.text = text;
	return specFrame;
end

--[[
Create a frame with name and realm for unit

@method MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberNameAndRealmText
@param {table} parentFrame
@param {number} x
@param {number} y
@return {table} nameAndRealmText
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberNameAndRealmText(parentFrame, x, y)
	local nameAndRealmText = parentFrame:CreateFontString(nil, "ARTWORK");
	nameAndRealmText:SetFontObject(GameFontNormal);
	nameAndRealmText:SetTextColor(0.6, 0.6, 0.6);
	nameAndRealmText:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y);
	nameAndRealmText:SetHeight(40);
	nameAndRealmText:SetJustifyH("LEFT");
	return nameAndRealmText;
end

--[[
Create a frame with ilvl for unit

@method MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberIlvlText
@param {table} parentFrame
@param {number} x
@param {number} y
@return {table} ilvlText
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberIlvlText(parentFrame, x, y)
	local ilvlText = parentFrame:CreateFontString(nil, "ARTWORK");
	ilvlText:SetFontObject(GameFontNormal);
	ilvlText:SetTextColor(0.6, 0.6, 0.6);
	ilvlText:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", x, y);
	ilvlText:SetWidth(40);
	ilvlText:SetHeight(40);
	ilvlText:SetJustifyH("RIGHT");
	return ilvlText;
end

--[[
Create a frame with equipment for `unitId`

@method MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberEquipment
@param {table} parentFrame
@param {number} x
@param {number} y
@param {unitId} unitId
@return {table} itemFrames
]]
function MyDungeonsBook:ChallengeDetailsFrame_CreatePartyMemberEquipment(parentFrame, x, y, unitId)
	local itemFrames = {};
	for i = 1, 16 do
		local itemFrame = CreateFrame("Frame", 0, parentFrame);
		itemFrame:SetWidth(40);
		itemFrame:SetHeight(40);
		itemFrame:SetPoint("TOPLEFT", x + 40 * i, y);
		itemFrame:SetScript("OnEnter", function(frame)
			self:ChallengeDetailsFrame_ItemHover(frame, unitId, i);
		end);
		itemFrame:SetScript("OnLeave", function(frame)
			self:ChallengeDetailsFrame_ItemOut(frame);
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

--[[
Mouse-hover handler for equiped item
Shows a tooltip with data from item

@method MyDungeonsBook:ChallengeDetailsFrame_ItemHover
@param {table} itemFrame
@param {unitId} unitId
@param {number} itemIndex
]]
function MyDungeonsBook:ChallengeDetailsFrame_ItemHover(itemFrame, unitId, itemIndex)
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
Mouse-out handler for item icon
Hides a tooltip

@method MyDungeonsBook:ChallengeDetailsFrame_ItemOut
]]
function MyDungeonsBook:ChallengeDetailsFrame_ItemOut()
	GameTooltip:Hide();
end

--[[
Mouse-hover handler for spec icon
Shows a spec name

@method MyDungeonsBook:ChallengeDetailsFrame_SpecHover
@param {table} specIconFrame
@param {unitId} unitId
]]
function MyDungeonsBook:ChallengeDetailsFrame_SpecHover(specIconFrame, unitId)
	local spec = self.db.char.challenges[self.activeChallengeId].players[unitId].spec;
	if (spec) then
		local _, specName, description = GetSpecializationInfoByID(self.db.char.challenges[self.activeChallengeId].players[unitId].spec);
		GameTooltip:SetOwner(specIconFrame, "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMLEFT", specIconFrame, "BOTTOMRIGHT");
		GameTooltip:AddLine(specName, 1, 1, 1);
		GameTooltip:Show();
	end
end

--[[
Mouse-out handler for spec icon
Hides a tooltip

@method MyDungeonsBook:ChallengeDetailsFrame_SpecOut
]]
function MyDungeonsBook:ChallengeDetailsFrame_SpecOut()
	GameTooltip:Hide();
end

--[[
Mouse-hover handler for class icon
Shows a class name

@method MyDungeonsBook:ChallengeDetailsFrameClassHover
@param {table} specIconFrame
@param {unitId} unitId
]]
function MyDungeonsBook:ChallengeDetailsFrame_ClassHover(classIconFrame, unitId)
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
Mouse-out handler for class icon
Hides a tooltip

@method MyDungeonsBook:ChallengeDetailsFrame_ClassOut
]]
function MyDungeonsBook:ChallengeDetailsFrame_ClassOut()
	GameTooltip:Hide();
end

--[[
@method MyDungeonsBook:UpdateRosterFrame
@param {number} challengeId
]]
function MyDungeonsBook:UpdateRosterFrame(challengeId)
	local challenge = self.db.char.challenges[challengeId];
	if (challenge) then
		for _, unit in pairs(self:GetPartyRoster()) do
			if (challenge.players[unit]) then
				self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].nameAndRealmText:SetText(self:GetUnitNameRealmRoleStr(challenge.players[unit]) or L["Not Found"]);
				self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].spec.text:SetText("");
				self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].class.text:SetText("");
				--self:UpdateRosterFrame_Ilvl(challenge, unit);
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
						self:UpdateRosterFrame_EquipedItem(challenge, unit, itemFrameIndex, i);
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

--[[
Update an item slot for party member (`unit`) in the `challenge`
`itemFrameIndex` and `itemIndex` will be different if item slot is after 4

@method MyDungeonsBook:UpdateRosterFrame_EquipedItem
@param {table} challenge
@param {unitId} unit
@param {number} itemFrameIndex
@param {number} itemIndex
]]
function MyDungeonsBook:UpdateRosterFrame_EquipedItem(challenge, unit, itemFrameIndex, itemIndex)
	self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].equipment[itemFrameIndex].text:SetText("");
	local itemString = challenge.players[unit].items and challenge.players[unit].items[itemIndex] or nil;
	if (itemString) then
		local _, itemId = strsplit(":", itemString);
		if (itemId) then
			self.challengeDetailsFrame.challengeRosterFrame[unit .. "DetailsFrame"].equipment[itemFrameIndex].text:SetText("|T" .. GetItemIcon(itemId) .. ":30:30:0:0:64:64:5:59:5:59|t");
		end
	end
end

--[[
TODO should be calculated right after players parsing

Update average items level for party member (`unit`) in the `challenge`

@method MyDungeonsBook:UpdateRosterFrame_Ilvl
@param {table} challenge
@param {unitId} unit
]]
function MyDungeonsBook:UpdateRosterFrame_Ilvl(challenge, unit)
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