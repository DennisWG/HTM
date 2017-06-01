--[[
    HellfireThreat-1.0

    Collects threat information directly from the server you're playing on. 
    Only works for servers that have the ".debug threat" command available for players.
]]

local MAJOR, MINOR = "HellfireThreat-1.0", 1;
local lib = LibStub:NewLibrary(MAJOR, MINOR);

if not lib then return; end

local aceEvent = LibStub("AceEvent-3.0");
local aceTimer = LibStub("AceTimer-3.0");

do
    local THREAD_LIST_BEGIN_SHORT = "Threat list of .*";
    local THREAD_LIST_BEGIN = "Threat list of ([%w+%s*]*) .*";
    local THREAD_LIST_ENTRY = "%s*(%a+)%s*.* - threat (%d+%.%d*).*";
    local THREAD_LIST_END = "End of threat list.";
    
    lib.CurrentThread = nil;
    
    local ChatFrame1_AddMessage = ChatFrame1.AddMessage;
    ChatFrame1.AddMessage = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
       if string.match(arg2, THREAD_LIST_ENTRY)
       or string.match(arg2, THREAD_LIST_BEGIN_SHORT)
       or string.match(arg2, THREAD_LIST_END) then
           return;
       end
       
       return ChatFrame1_AddMessage(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
    end
    
    aceTimer:ScheduleRepeatingTimer(function()
        if not UnitExists("target") or UnitIsPlayer("target")
            or UnitIsFriend("player", "target") then
            return;
        end
        SendChatMessage(".debug threat", "Guild");
    end, 3.1);
    
    
    aceEvent:RegisterEvent("CHAT_MSG_SYSTEM", function(event, msg)
        if string.match(msg, THREAD_LIST_BEGIN) then
            lib.CurrentThread = {};
        end
        
        local name, threat = string.match(msg, THREAD_LIST_ENTRY);
        if name and threat then
            
            local unit;
            local groupType = "party";
            local numMembers = 5;
            
            if UnitInRaid("player") then
                groupType = "raid";
                numMembers = 40;
            end
            
            for i=1, numMembers do
                if UnitName(groupType..i) == name then
                    unit = groupType..i;
                    break;
                end
            end
            
            if not unit then
                if name == UnitName("player") then
                    unit = "player";
                end
            end
            
            table.insert(lib.CurrentThread, {name=name, threat=tonumber(threat), unit=unit});
        end
    end);
end

-- Returns the threat list of the player's current target if available
function lib:GetThreadList()
    return lib.CurrentThread;
end