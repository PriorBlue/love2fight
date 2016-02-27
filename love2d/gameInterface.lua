-- infinite symbol: ∞
require('playerBar')
local g = require('love.graphics')
-- this is a constant for now
local healthBarHeight = 50
-- TODO maybe set this to 20
local healthBarY = 0
local healthBarBorderDistance = 10
local gameTimerWidth = 50
-- a little hack to determine if the newText function is available
local loveVersion10 = g.newText or false

class "GameInterface" {
    player1Bar = {};
    player2Bar = {};
    --gameTime: -1 = infinite
    gameTime = -1;
    gameTimeGraphic = {};
    gameTimerX = 0;
    gameTimerY = 0;
    gameTimerHeight = 0;
    gameTimerWidth = 0;
    screenWidth = 0;
}

function GameInterface:__init(player1Health, player2Health, gameTime)
    --TODO temporary parameters, remove these
    gameTime = 42
    -- calculate positions
    local screenWidth = g.getWidth()
    self.screenWidth = screenWidth
    local healthBarWidth = ((screenWidth-gameTimerWidth)-(screenWidth%2))/2
    local y = healthBarY
    local height = healthBarHeight
    -- calculate player 1 X
    local player1X = healthBarBorderDistance
    -- calculate player 2 X
    local player2X = screenWidth - (healthBarWidth + healthBarBorderDistance)
    
    self.player1Bar = PlayerBar:new(true, player1Health, player1X, y, healthBarWidth, height)
    self.player2Bar = PlayerBar:new(false, player2Health, player2X, y, healthBarWidth, height)
    -- calculate game timer position
    self.gameTimerX = healthBarWidth
    self.gameTimerY = healthBarY
    self.gameTimerHeight = 80
    self.gameTimerWidth = gameTimerWidth
    if loveVersion10 then
        self.gameTimeGraphic = g.newText()
    end
    self.gameTime = gameTime
end

function GameInterface:updateTime(newTime)
    if loveVersion10 then
        self.gameTime.set(newTime)
    else
        self.gameTime = newTime
    end
end

function GameInterface:draw()
    local oldr,oldg,oldb,olda = g.getColor()
    -- draw timer
    g.setColor(200,200,200,100)
    g.rectangle("fill",self.gameTimerX,self.gameTimerY,self.gameTimerHeight,self.gameTimerWidth,10)
    g.setColor(0,0,0,255)
    if loveVersion10 then
        g.draw(self.gameTimeGraphic)
    else
        g.printf(tostring(self.gameTime), ((self.screenWidth-self.gameTimerWidth)-(self.screenWidth%2))/2, self.gameTimerY, self.gameTimerWidth, "center")
    end
    
    g.setColor(oldr,oldg,oldb,olda)
    -- draw health bars
    self.player1Bar:draw()
    self.player2Bar:draw()    
end

