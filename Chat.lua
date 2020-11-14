--[[--
@module MyDungeonsBook
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

local function isActiveChallengeId(challengeId)
	return challengeId == "active" or challengeId == "a";
end

--[[--
Parse chat slash command `/mdb ...` or `/mydungeonsbook ...`.

@local
@param[type=string] msg some chat message
]]
function MyDungeonsBook:ParseChatCommand(msg)
	local type, challengeId, resource, subResourceOrAction, actionOrNothing = self:GetArgs(msg, 10);
	if (type == "challenge" or type == "c") then
		return self:ParseChallengeChatCommand(challengeId, resource, subResourceOrAction, actionOrNothing);
	end
	if (type == "help" or type == "h") then
		local tpl = "|c0070DE00%s|r - %s";
		self:Print(string.format(tpl, "[..]", L["alias for previous word"]));
		self:Print(string.format(tpl, "/mdb challenge[c] active[a] roster[r] {{unitId}} update[u]", L["update info about party member for current challenge. unitId must be 'player' or 'party1..4'."]));
		self:Print(string.format(tpl, "/mdb help[h]", L["print this text."]));
		return;
	end
	self:MainFrame_Show();
end

--[[--
Parse chat command related to Challenges (e.g. `/mdb c ...`).

@local
@param[type=string|number] challengeId
@param[type=string] resource
@param[type=string] subResourceOrAction
@param[type=string] actionOrNothing
]]
function MyDungeonsBook:ParseChallengeChatCommand(challengeId, resource, subResourceOrAction, actionOrNothing, ...)
	if (resource == "roster" or resource == "r") then
		return self:ParseRosterChatCommand(challengeId, resource, subResourceOrAction, actionOrNothing, ...);
	end
end

--[[--
Parse chat command related to Challenge's Roster (e.g. `/mdb c a r ...`).

@local
@param[type=string|number] challengeId
@param[type=string] _
@param[type=string] subResource player or party1..4
@param[type=string] action
]]
function MyDungeonsBook:ParseRosterChatCommand(challengeId, _, subResource, action)
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
