HTM.BarWidth = 198;

-- Creates the GUI
function HTM:CreateGui()
    -- Main Frame
    do
        self.frame = CreateFrame("Frame", "HTMFrame", UIParent);
        self.frame:SetPoint("CENTER", UIParent, "CENTER");
        self.frame:SetWidth(225);
        self.frame:SetHeight(141);
        
        self.frame:EnableMouse(true);
        self.frame:SetMovable(true);
        self.frame:RegisterForDrag("LeftButton");
        self.frame:SetScript("OnDragStart", self.frame.StartMoving);
        self.frame:SetScript("OnDragStop", self.frame.StopMovingOrSizing);
        
        self.frame:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
            tile = true,
            tileSize = 32,
            edgeSize = 32,
            insets =  {left=11,right=12,top=12,bottom=11}
        });
        self.frame:SetBackdropColor(0,0,0);
    end
    
    -- Bars
    do
        self.frame.bar1 = HTM:CreateBar();
        self.frame.bar1:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 13, -14);
        self:UpdateBarData(1, nil);
        
        self.frame.bar2 = HTM:CreateBar();
        self.frame.bar2:SetPoint("TOPLEFT", self.frame.bar1, "BOTTOMLEFT", 0, -2);
        self:UpdateBarData(2, nil);
        
        self.frame.bar3 = HTM:CreateBar();
        self.frame.bar3:SetPoint("TOPLEFT", self.frame.bar2, "BOTTOMLEFT", 0, -2);
        self:UpdateBarData(3, nil);
        
        self.frame.bar4 = HTM:CreateBar();
        self.frame.bar4:SetPoint("TOPLEFT", self.frame.bar3, "BOTTOMLEFT", 0, -2);
        self:UpdateBarData(4, nil);
    end
end

local CLASS_COLORS = {
    DRUID = {r=1.00, g=0.49, b=0.04},
    HUNTER = {r=0.67, g=0.83, b=0.45},
    MAGE = {r=0.41, g=0.80, b=0.94},
    PALADIN = {r=0.96, g=0.55, b=0.73},
    PRIEST = {r=1.00, g=1.00, b=1.00},
    ROGUE = {r=1.00, g=0.96, b=0.41},
    SHAMAN = {r=0.00, g=0.44, b=0.87},
    WARLOCK = {r=0.58, g=0.51, b=0.79},
    WARRIOR = {r=0.78, g=0.61, b=0.43},
};

-- Creates a Bar that represents an entry in the threat list
function HTM:CreateBar()
    local bg = CreateFrame("Frame", nil, self.frame);
    bg:SetHeight(27);
    bg:SetWidth(HTM.BarWidth);
    
    local bar = CreateFrame("Frame", nil, bg);
    bar:SetHeight(27);
    bar:SetWidth(HTM.BarWidth);
    bar:SetPoint("TOPLEFT", bg, "TOPLEFT");
    
    bar:SetBackdrop({
        bgFile = "Interface\\BUTTONS\\WHITE8X8",
        tile = true,
        tileSize = 32,
    });
    
    bar.playerName = bar:CreateFontString(nil, nil, "GameFontNormal");
	bar.playerName:SetPoint("LEFT", bar, "LEFT", 2, 0);
	bar.playerName:SetText("Longplrna");
    
    bar.percentage = bar:CreateFontString(nil, nil, "GameFontNormal");
	bar.percentage:SetPoint("RIGHT", bg, "RIGHT", -2, 0);
	bar.percentage:SetText("130%");
    
    bar.threatValue = bar:CreateFontString(nil, nil, "GameFontNormal");
	bar.threatValue:SetPoint("RIGHT", bar.percentage, "LEFT", -20, 0);
	bar.threatValue:SetText("8866");
    
    bg.bar = bar;
   return bg; 
end
    
function HTM:UpdateBarData(barNumber, data, maxThreat)
    local bar = self.frame["bar"..barNumber].bar;
    if not data or not data.threat then
        bar:Hide();
        return;
    else
        bar:Show();
    end
    
    if not data.unit then
        bar:SetBackdropColor(0, 0, 1, 0.5);
    else
        local _, class = UnitClass(data.unit);
        local color = CLASS_COLORS[class];
        if color then
            bar:SetBackdropColor(color.r, color.g, color.b, 0.5);
        end
    end
    
    bar.playerName:SetText(data.name);
    bar.threatValue:SetText(math.floor(data.threat+0.5));
    
    local percentage = 100 / maxThreat * data.threat;
    bar:SetWidth(HTM.BarWidth / 100 * percentage);
    
    bar.percentage:SetText(math.floor(percentage+0.5).."%");
end
