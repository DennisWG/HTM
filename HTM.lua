--local PlayerName = UnitName("player")
--local Threat = LibStub("HellfireThreat-1.0")
--local math_floor = math.floor
--local timers = {}
--local AceConfig = LibStub("AceConfigDialog-3.0")
--local L = LibStub("AceLocale-3.0"):GetLocale("Omen")

HTM = LibStub("AceAddon-3.0"):NewAddon("HTM", "AceConsole-3.0")
local Threat = LibStub("HellfireThreat-1.0")

local aceEvent = LibStub("AceEvent-3.0");
local aceTimer = LibStub("AceTimer-3.0");

function HTM:MySlashProcessorFunc(input)
    ReloadUI()
end

function HTM:OnInitialize()
    HTM:RegisterChatCommand("rl", "MySlashProcessorFunc")
    
    HTM:CreateGui();
    
    local genData = function()
        local threat = math.random(10000);
        local n = math.random(1,2);
        local unit = "raid"..n;
        local name = UnitName(unit);
        return {name=name, unit=unit, threat=threat};
    end;
            
            
    local compare = function(a, b)
        return a.threat > b.threat;
    end

    aceTimer:ScheduleRepeatingTimer(function()
        --local data = { genData(), genData(), genData() };
        local data = Threat:GetThreadList();
        if not data then return; end
        
        local maxThreat;
        
        if #data == 1 then
            maxThreat = data[1].threat;
        elseif #data == 2 then
            maxThreat = math.max(data[1].threat, data[2].threat);
        elseif #data > 2 then
            maxThreat = math.max(data[1].threat, data[2].threat, data[3].threat);
        end
        
        table.sort(data, compare);
        
        for i=1, 4 do
            HTM:UpdateBarData(i, data[i], maxThreat);
        end
    end, 3.1);
end

function HTM:OnEnable()
    
end

function HTM:OnDisable()
    
end
