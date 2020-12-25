--[[--
@module MyDungeonsBook
]]

--[[--
Event Handlers
@section EventHandlers
]]

--[[--
]]
function MyDungeonsBook:Messages_StartTrack()
    self:Message_CovenantInfo_StartTrack();
    self:Message_IdleTime_StartTrack();
end

--[[--
]]
function MyDungeonsBook:Messages_StopTrack()
    self:Message_CovenantInfo_StopTrack();
    self:Message_IdleTime_StopTrack();
end
