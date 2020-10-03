local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function isActiveChallengeId(challengeId)
	return challengeId == "active" or challengeId == "a";
end

--[[
Parse chat slash command "/mdb ..." or "/mydungeonsbook ..."

@method MyDungeonsBook:ParseChatCommand
@param {string} msg
]]
function MyDungeonsBook:ParseChatCommand(msg)
	local type, challengeId, resource, subResourceOrAction, actionOrNothing = self:GetArgs(msg, 10);
	if (type == "challenge" or type == "c") then
		return self:ParseChallengeChatCommand(challengeId, resource, subResourceOrAction, actionOrNothing);
	end
	if (type == "help" or type == "h") then
		local tpl = "|c0070DE00%s|r - %s";
		self:Print(string.format(tpl, "[..]", "alias for previous word"));
		self:Print(string.format(tpl, "/mdb challenge[c] active[a] details[d] parse[p]", "save info from Details addon. It's done automatically when challenge is completed (in time or not), however it's not done if challenge is abandonned. Use this command right before leave the party."));
		self:Print(string.format(tpl, "/mdb challenge[c] active[a] roster[r] {{unitId}} update[u]", "update info about party member for current challenge. unitId must be 'player' or 'party1..4'."));
		self:Print(string.format(tpl, "/mdb help[h]", "print this text."));
		return;
	end
	self:Show();
end

function MyDungeonsBook:ParseChallengeChatCommand(challengeId, resource, subResourceOrAction, actionOrNothing, ...)
	if (resource == "roster" or resource == "r") then
		return self:ParseRosterChatCommand(challengeId, resource, subResourceOrAction, actionOrNothing, ...);
	end
	if (resource == "details" or resource == "d") then
		return self:ParseDetailsChatCommand(challengeId, resource, subResourceOrAction, ...);
	end
end

function MyDungeonsBook:ParseRosterChatCommand(challengeId, resource, subResource, action, ...)
	if (isActiveChallengeId(challengeId) and self.db.char.activeChallengeId) then
		for _, unitId in pairs(self:GetPartyRoster()) do
			if (unitId == subResource) then
				if (action == "update" or action == "u") then
					NotifyInspect(unitId);
				end
			end
		end
	end
end

--[[
Proceed chat command about Details addon integration

@method MyDungeonsBook:ParseDetailsChatCommand
@param {number|string} challengeId "active"
@param {string} resource "details"
@param {string} action "parse"
]]
function MyDungeonsBook:ParseDetailsChatCommand(challengeId, resource, action, ...)
	if (isActiveChallengeId(challengeId) and self.db.char.activeChallengeId) then
		local challenge = self.db.char.challenges[self.db.char.activeChallengeId];
		if (challenge) then
			if (not challenge.details.exists) then
				self.db.char.challenges[self.db.char.activeChallengeId].details = self:ParseInfoFromDetailsAddon();
				self:LogPrint(string.format("Info from Details addon is stored for challenge #%s", self.db.char.activeChallengeId));
			end
		end
	end
end