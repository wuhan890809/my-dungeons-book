--[[--
@module MyDungeonsBook
]]

--[[--
Event Handlers
@section EventHandlers
]]

--[[--
Send info about player's idle time to other party members.

It's used to keep challenge data up to date for each party member.

@param[type=unitId] target
]]
function MyDungeonsBook:Message_IdleTime_Send(target)
    local id = self.db.char.activeChallengeId;
    if (not id) then
        return;
    end
    local challenge = self:Challenge_GetById(id);
    local idleMechanics = challenge.mechanics["PARTY_MEMBERS_IDLE"];
    local player = challenge.players.player;
    self:SendCommMessage(
        MyDungeonsBook.COMM_PREFIX,
        self:Message_CommData_Prepare(MyDungeonsBook.CommSubPrefixes.PLAYER_IDLE_TIME, player.name, player.realm, idleMechanics[player.name]),
        "WHISPER",
        self:Message_CommTarget_Prepare(target)
    );
    self:DebugPrint(string.format("Idle Time is sent to %s", target));
end

--[[--
Receive info about idle time for some party member sent by `Message_IdleTime_Send`.

@param[type=string] senderName
@param[type=string] senderRealm
@param[type=table] senderData
]]
function MyDungeonsBook:Message_IdleTime_Receive(senderName, senderRealm, senderIdleTime)
    local id = self.db.char.activeChallengeId;
    if (not id) then
        return;
    end
    local challenge = self:Challenge_GetById(id);
    for _, unitId in pairs(self:GetPartyRoster()) do
        local unitName = challenge.players[unitId].name;
        local unitRealm = challenge.players[unitId].realm;
        if (unitName == senderName and unitRealm == senderRealm) then
            local mechanicPartyMemberKey = senderName;
            if (challenge.players.player.realm ~= senderRealm) then
                mechanicPartyMemberKey = string.format("%s-%s", senderName, senderRealm);
            end
            challenge.mechanics["PARTY_MEMBERS_IDLE"][mechanicPartyMemberKey] = senderIdleTime;
            self:DebugPrint(string.format("Idle Time is saved for %s (%s)", unitName, unitId));
            break;
        end
    end
end
