--[[--
@module MyDungeonsBook
]]

--[[--
Core
@section Core
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");
MyDungeonsBook = LibStub("AceAddon-3.0"):NewAddon("MyDungeonsBook", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0", "AceConsole-3.0", "AceSerializer-3.0", "AceComm-3.0");

--[[--
Initial ACE-addon setup.
]]
function MyDungeonsBook:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MyDungeonsBookDB", self.OptionsDefaults);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("MyDungeonsBook", self.Options);
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("MyDungeonsBook", L["My Dungeons Book"]);
	self:RegisterChatCommand("mydungeonsbook", "ParseChatCommand");
	self:RegisterChatCommand("mdb", "ParseChatCommand");
	StaticPopupDialogs["MDB_CONFIRM_DELETE_CHALLENGE"] = {
		text = L["Are you sure you want to delete info about challenge?"],
		button1 = L["Yes"],
		button2 = L["No"],
		OnAccept = function(data)
			self:Challenge_Delete(data.data);
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3
	};
	StaticPopupDialogs["MDB_FILLED_WOWHEAD_LINK_INPUT"] = {
		text = L["WowHead Link for %s"],
		OnShow = function (self, linkToShow)
			self.editBox:SetText(linkToShow);
			self.editBox:HighlightText();
		end,
		hideOnEscape = true,
		hasEditBox = true,
		button1 = L["Close"],
	};
	self:DebugPrint("Loaded");
end

--[[--
Setup event handlers.

Next events are handled:

* `CHALLENGE_MODE_START`
* `CHALLENGE_MODE_COMPLETED`
* `CHALLENGE_MODE_RESET`
* `PLAYER_ENTERING_WORLD`
* `INSPECT_READY`
* `ENCOUNTER_END`
* `ENCOUNTER_START`

Events `COMBAT_LOG_EVENT_UNFILTERED`, `PLAYER_REGEN_DISABLED` and `PLAYER_REGEN_ENABLED` are handled while challenge is active. E.g. from `CHALLENGE_MODE_START` to `CHALLENGE_MODE_COMPLETED` or `CHALLENGE_MODE_RESET`.

Check methods with the same names to get more info about handlers.
]]
function MyDungeonsBook:OnEnable()
	self:RegisterEvent("CHALLENGE_MODE_START");
	self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
	self:RegisterEvent("CHALLENGE_MODE_RESET");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("INSPECT_READY");
	self:RegisterEvent("ENCOUNTER_END");
	self:RegisterEvent("ENCOUNTER_START");
	self:RegisterEvent("SCENARIO_CRITERIA_UPDATE");
	self:Messages_StartTrack();
	self:DebugPrint("Enabled");
end
