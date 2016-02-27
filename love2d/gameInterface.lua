-- infinite symbol: ∞
require('playerBar')
local g = require('love.graphics')
-- this is a constant for now
local healthBarHeight = 50
-- TODO maybe set this to 20
local healthBarY = 0
local healthBarBorderDistance = 10

class "GameInterface" {
    player1Bar = {};
    player2Bar = {};
}

function GameInterface:__init(player1Health, player2Health)
    -- calculate positions
    local screenWidth = g.getWidth()
    local healthBarWidth = ((screenWidth-100)-(screenWidth%2))/2
    local y = healthBarY
    local height = healthBarHeight
    -- calculate player 1 X
    local player1X = healthBarBorderDistance
    -- calculate player 2 X
    local player2X = screenWidth - (healthBarWidth + healthBarBorderDistance)
    
    self.player1Bar = PlayerBar:new(true, health, player1X, y, healthBarWidth, height)
    self.player2Bar = PlayerBar:new(false, health, player2X, y, healthBarWidth, height)
    
end

function GameInterface:draw()
    -- draw timer
    --TODO
    
    g.rectangle("fill",350,20,100,50,10)

    -- draw health bars
    --TODO
    self.player1Bar:draw()
    self.player2Bar:draw()
end

