-- infinite symbol: ∞
require('playerBar')
local g = require('love.graphics')

class "GameInterface" {
    player1Bar = {};
    player2Bar = {};
}

function GameInterface:__init(health)
    self.player1Bar = PlayerBar:new(true, health) --TODO add variables here
    self.player2Bar = PlayerBar:new(false, health) --TODO add variables here
    
end

function GameInterface:draw()
    g.rectangle("fill",350,20,100,100)
    -- draw timer
    --TODO
    
    -- draw health bars
    --TODO
    self.player1Bar:draw()
    self.player2Bar:draw()
end

