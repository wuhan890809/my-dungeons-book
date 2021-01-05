--[[--
@module MyDungeonsBook
]]

--[[--
Event Handlers
@section EventHandlers
]]

--[[--
Send info about player to other party members.

It's used to keep roster info up to date for each party member.

@param[type=unitId] target
]]
function MyDungeonsBook:Message_CharacterData_Send(target)
    local id = self.db.char.activeChallengeId;
    if (not id) then
        return;
    end
    local challenge = self:Challenge_GetById(id);
    local player = challenge.players.player;
    self:SendCommMessage(
        MyDungeonsBook.COMM_PREFIX,
        self:Message_CommData_Prepare(MyDungeonsBook.CommSubPrefixes.PLAYER_IDLE_TIME, player.name, player.realm, player),
        "WHISPER",
        self:Message_CommTarget_Prepare(target)
    );
    self:DebugPrint(string.format("Player's data is sent"));
end

--[[--
Receive info about some party member sent by `Message_CharacterData_Send`.

@param[type=string] senderName
@param[type=string] senderRealm
@param[type=table] senderData
]]
function MyDungeonsBook:Message_CharacterData_Receive(senderName, senderRealm, senderData)
    local id = self.db.char.activeChallengeId;
    if (not id) then
        return;
    end
    local challenge = self:Challenge_GetById(id);
    for _, unitId in pairs(self:GetPartyRoster()) do
        local unitName = challenge.players[unitId].name;
        local unitRealm = challenge.players[unitId].realm;
        if (unitName == senderName and unitRealm == senderRealm) then
            challenge.players[unitId] = self:MergeTables(challenge.players[unitId], senderData);
            self:DebugPrint(string.format("Data is saved for %s (%s)", unitName, unitId));
            break;
        end
    end
end
