local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
MyDungeonsBook = LibStub("AceAddon-3.0"):NewAddon("MyDungeonsBook", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0", "AceConsole-3.0");

--[[
Initial addon setup

@method MyDungeonsBook:OnInitialize
]]
function MyDungeonsBook:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MyDungeonsBookDB", self.OptionsDefaults);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MyDungeonsBook", self.Options);
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MyDungeonsBook", L["My Dungeons Book"]);
	self:RegisterChatCommand("mydungeonsbook", "ParseChatCommand");
	self:RegisterChatCommand("mdb", "ParseChatCommand");
	self:DebugPrint("Loaded");
end

--[[
Setup event handlers

@method MyDungeonsBook:OnEnable
]]
function MyDungeonsBook:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("CHALLENGE_MODE_START");
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
	self:RegisterEvent("CHALLENGE_MODE_RESET");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("INSPECT_READY");
	self:RegisterEvent("ENCOUNTER_END");
	self:RegisterEvent("ENCOUNTER_START");
	self:DebugPrint("Enabled");
end

--[[
@method MyDungeonsBook:OnDisable
]]
function MyDungeonsBook:OnDisable()
    self:DebugPrint("Disabled");
end
