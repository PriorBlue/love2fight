require('playerBar')
local g = require('love.graphics')
-- this is a constant for now
local healthBarHeight = 50
-- TODO maybe set this to 20
local healthBarY = 0
local healthBarBorderDistance = 10
local gameTimerWidth = 90
-- a little hack to determine if the newText function is available
local loveVersion10 = g.newText or false

class "GameInterface" {
    player1Bar = {};
    player2Bar = {};
    --gameTime: -1 or nil means infinite
    gameTime = -1;
    gameTimeGraphic = {};
    gameTimerX = 0;
    gameTimerY = 0;
    gameTimerHeight = 0;
    gameTimerWidth = 0;
    screenWidth = 0;
}

--gameTime: -1 or nil means infinite
function GameInterface:__init(player1HealthFunction, player2HealthFunction, gameTime)
    --TODO temporary parameters, remove these
    gameTime = '∞'
    -- calculate positions
    local screenWidth = g.getWidth()
    self.screenWidth = screenWidth
    local healthBarWidth = ((screenWidth-gameTimerWidth)-(screenWidth%2))/2 * 0.9
    local y = healthBarY
    local height = healthBarHeight
    -- calculate player 1 X
    local player1X = healthBarBorderDistance
    -- calculate player 2 X
    local player2X = screenWidth - (healthBarWidth + healthBarBorderDistance)
    
    self.player1Bar = PlayerBar:new(true, player1HealthFunction, player1X, y, healthBarWidth, height)
    self.player2Bar = PlayerBar:new(false, player2HealthFunction, player2X, y, healthBarWidth, height)
    -- calculate game timer position
    self.gameTimerX = ((screenWidth-gameTimerWidth)-(screenWidth%2))/2
    self.gameTimerY = healthBarY-20
    self.gameTimerHeight = height+15--*0.9
    self.gameTimerWidth = gameTimerWidth
    self.gameTime = gameTime or '∞'
    local imageFontImage = g.newImage("gfx/timerSymbols.png")
    imageFontImage:setFilter("nearest")
    self.imageFont = g.newImageFont(imageFontImage," 0123456789.,:∞")
    local textX = (self.screenWidth-(self.screenWidth%2))/2-self.gameTimerWidth/2
    local textY = self.gameTimerY+self.gameTimerHeight/3+10
    if loveVersion10 then
        self.gameTimeGraphic = g.newText(self.imageFont,self.gameTime)
        self.gameTimeGraphic:setf(tostring(self.gameTime), self.gameTimerWidth, "center")
        self.drawTime = function () g.draw(self.gameTimeGraphic, textX, textY) end
    else
        self.drawTime = 
            function () local oldFont = g.getFont(); g.setFont(self.imageFont);
            g.printf(tostring(self.gameTime), textX, textY, self.gameTimerWidth, "center");
            g.setFont(oldFont)
            end
    end
    self.gameTime = gameTime
end

function GameInterface:update(dt)
    self.player1Bar:update(dt)
    self.player2Bar:update(dt)
    --TODO maybe update time with GameInterface.updateTime(self,time)
end

function GameInterface:updateTime(newTime)
-- infinite symbol: ∞
    if loveVersion10 then
        self.gameTimeGraphic:setf(tostring(newTime),self.gameTimerWidth, "center")
    else
        self.gameTime = newTime
    end
end
local time = 0
function GameInterface:draw()
    local oldr,oldg,oldb,olda = g.getColor()
    -- draw timer
    g.setColor(90,120,220,230)
    g.rectangle("fill",self.gameTimerX,self.gameTimerY,self.gameTimerWidth,self.gameTimerHeight,10)
    g.setColor(0,230,0,230)
    local oldLineWidth = g.getLineWidth()
    g.setLineWidth(3)
    g.rectangle("line",self.gameTimerX,self.gameTimerY,self.gameTimerWidth,self.gameTimerHeight,10)
    g.setLineWidth(oldLineWidth)
    g.setColor(200,200,0,255)
    self.drawTime()
    g.setColor(oldr,oldg,oldb,olda)
    -- draw health bars
    self.player1Bar:draw()
    self.player2Bar:draw()    
end

