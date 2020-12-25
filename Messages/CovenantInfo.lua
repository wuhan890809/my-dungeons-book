--[[--
@module MyDungeonsBook
]]

--[[--
Event Handlers
@section EventHandlers
]]

local MDB_COVENANT_INFO = "MDB_COVENANT_INFO";

--[[--
]]
function MyDungeonsBook:Message_CovenantInfo_StartTrack()
    self:RegisterMessage(MDB_COVENANT_INFO);
end

--[[--
]]
function MyDungeonsBook:Message_CovenantInfo_StopTrack()
    self:UnregisterMessage(MDB_COVENANT_INFO);
end

--[[--
]]
function MyDungeonsBook:Message_CovenantInfo_Send()
    local id = self.db.char.activeChallengeId;
    if (not id) then
        return;
    end
    local challenge = self:Challenge_GetById(id);
    local player = challenge.players.player;
    self:DebugPrint(string.format("Covenant is sent"));
    self:SendMessage(MDB_COVENANT_INFO, self:Serialize({
        covenant = player.covenant,
        name = player.name,
        realm = player.realm
    }));
end

--[[--
]]
function MyDungeonsBook:MDB_COVENANT_INFO(_, msg)
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
            challenge.players[unitId].covenant = self:MergeTables(challenge.players[unitId].covenant, data.covenant);
            self:DebugPrint(string.format("Covenant is saved for %s (%s)", unitName, unitId));
            break;
        end
    end
end
