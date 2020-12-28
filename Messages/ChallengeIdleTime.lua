--[[--
@module MyDungeonsBook
]]

--[[--
Event Handlers
@section EventHandlers
]]

local MDB_CHALLENGE_IDLE_TIME = "MDB_CHALLENGE_IDLE_TIME";

--[[--
]]
function MyDungeonsBook:Message_IdleTime_StartTrack()
    self:RegisterMessage(MDB_CHALLENGE_IDLE_TIME);
end

--[[--
]]
function MyDungeonsBook:Message_IdleTime_StopTrack()
    self:UnregisterMessage(MDB_CHALLENGE_IDLE_TIME);
end

--[[--
]]
function MyDungeonsBook:Message_IdleTime_Send()
    local id = self.db.char.activeChallengeId;
    if (not id) then
        return;
    end
    local challenge = self:Challenge_GetById(id);
    local idleMechanics = challenge.mechanics["PARTY_MEMBERS_IDLE"];
    local player = challenge.players.player;
    self:SendMessage(MDB_CHALLENGE_IDLE_TIME, self:Serialize({
        idleTime = idleMechanics[player.name],
        name = player.name,
        realm = player.realm
    }));
    self:DebugPrint(string.format("Idle Time is sent"));
end

--[[--
]]
function MyDungeonsBook:MDB_CHALLENGE_IDLE_TIME(_, msg)
    local success, data = self:Deserialize(msg);
    if (not success) then
        return;
    end
    local id = self.db.char.activeChallengeId;
    if (not id) then
        return;
    end
    local challenge = self:Challenge_GetById(id);
    for _, unitId in pairs(self:GetPartyRoster()) do
        local unitName = challenge.players[unitId].name;
        local unitRealm = challenge.players[unitId].realm;
        if (unitName == data.name and unitRealm == data.realm) then
            local mechanicPartyMemberKey = data.name;
            if (challenge.players.player.realm ~= data.realm) then
                mechanicPartyMemberKey = string.format("%s-%s", data.name. data.realm);
            end
            challenge.mechanics["PARTY_MEMBERS_IDLE"][mechanicPartyMemberKey] = data.idleTime;
            self:DebugPrint(string.format("Idle Time is saved for %s (%s)", unitName, unitId));
            break;
        end
    end
end
