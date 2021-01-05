--[[--
@module MyDungeonsBook
]]

--[[--
Event Handlers
@section EventHandlers
]]

local PLAYER_IDLE_TIME = 'PLAYER_IDLE_TIME';
local PLAYER_DETAILS = 'PLAYER_DETAILS';
local TEST_COMM = 'TEST_COMM';

MyDungeonsBook.COMM_PREFIX = "MDBCOMM";

MyDungeonsBook.CommSubPrefixes = {
    [PLAYER_IDLE_TIME] = PLAYER_IDLE_TIME,
    [PLAYER_DETAILS] = PLAYER_DETAILS,
    [TEST_COMM] = TEST_COMM
};

--[[--
]]
function MyDungeonsBook:Messages_StartTrack()
    self:RegisterComm(MyDungeonsBook.COMM_PREFIX, "CommReceived");
end

--[[--
]]
function MyDungeonsBook:CommReceived(_, msg)
    local success, deserialized = self:Deserialize(msg);
    if (not success) then
        self:DebugPrint("CommReceived failed to parse received data");
        return;
    end
    local prefix = deserialized.meta.prefix;
    local senderName = deserialized.meta.name;
    local senderRealm = deserialized.meta.realm;
    local senderData = deserialized.data;
    if (prefix == PLAYER_IDLE_TIME) then
        self:Message_IdleTime_Receive(senderName, senderRealm, senderData);
        return;
    end
    if (prefix == PLAYER_DETAILS) then
        self:Message_CharacterData_Receive(senderName, senderRealm, senderData);
        return;
    end
    if (prefix == TEST_COMM) then
        self:Message_TestMessage_Receive(senderName, senderRealm, senderData);
        return;
    end
    self:DebugPrint(string.format("Prefix `%s` not found", prefix));
end

--[[--
Format data to send it via comm message

@param[type=string] prefix
@param[type=string] name
@param[type=string] realm
@param[type=*] data
@return[type=string]
]]
function MyDungeonsBook:Message_CommData_Prepare(prefix, name, realm, data)
    return self:Serialize({
        meta = {
            prefix = prefix,
            name = name,
            realm = realm,
            version = 1
        },
        data = data
    });
end

--[[--
@local
@param[type=unitId] target
@return[type=string]
]]
function MyDungeonsBook:Message_CommTarget_Prepare(target)
    local name, realm = UnitFullName(target);
    local playersRealm = GetRealmName();
    local realmToUse = realm;
    if (not realmToUse) then
        realmToUse = playersRealm;
    end
    return name .. "-" .. realmToUse;
end

--[[--
@local
]]
function MyDungeonsBook:Message_TestMessage_Send(target, text)
    target = target or "player";
    self:SendCommMessage(
        MyDungeonsBook.COMM_PREFIX,
        self:Message_CommData_Prepare(MyDungeonsBook.CommSubPrefixes.TEST_COMM, UnitName("player"), GetRealmName(), {message = text}),
        "WHISPER",
        self:Message_CommTarget_Prepare(target)
    );
end

--[[--
@local
]]
function MyDungeonsBook:Message_TestMessage_Receive(senderName, senderRealm, senderData)
    self:Print(string.format("Message `%s` is received from %s-%s", senderData.message, senderName, senderRealm));
end
