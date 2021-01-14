--[[--
@module MyDungeonsBook
]]

--[[--
UI
@section Utils
]]

local L = LibStub("AceLocale-3.0"):GetLocale("MyDungeonsBook");

--[[--
@poram[type=table] report
@param[type=?string] chat
@param[type=?string] channel
]]
function MyDungeonsBook:Report_Print(report, chat, channel)
    for i = 1, #report do
        local message = report[i];
        if (message ~= "") then
            if (chat) then
                SendChatMessage(message, chat, DEFAULT_CHAT_FRAME.editBox.languageID, channel);
            else
                print(message);
            end
        end
    end
end

--[[--
@param[type=table] report
@return[type=table]
]]
function MyDungeonsBook:Report_Menu(report)
    return {
        text = L["Report"],
        hasArrow = true,
        menuList = {
            {
                text = L["To Self"],
                func = function()
                    self:Report_Print(report)
                end
            },
            {
                text = L["To Target"],
                func = function()
                    if (UnitExists("target")) then
                        self:Report_Print(report, "WHISPER", UnitName("target"));
                    else
                        self:DebugPrint("No target unit to whisper.");
                    end
                end
            },
            {
                text = L["To Group/Raid"],
                func = function()
                    if (IsInRaid()) then
                        self:Report_Print(report, "RAID");
                    else
                        if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
                            self:Report_Print(report, "INSTANCE_CHAT");
                        else
                            if (IsInGroup()) then
                                self:Report_Print(report, "PARTY");
                            else
                                self:DebugPrint("You are not in group or raid.");
                            end
                        end
                    end
                end
            }
        }
    };
end
