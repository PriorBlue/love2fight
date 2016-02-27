local g = require('love.graphics')

class "PlayerBar" {
    isPlayerOne = false;
}

function PlayerBar:__init(isPlayerOne)
    self.isPlayerOne = isPlayerOne or false
end

function PlayerBar:draw()
    local oldr,oldg,oldb,olda = g.getColor()
    if self.isPlayerOne then
        g.setColor(200,0,0,200)
        g.rectangle("fill",0,20,100,100)
    else
        g.setColor(200,0,0,200)
        g.rectangle("fill",450,20,100,100)
    end
    -- draw health bar
    --TODO
    
    -- draw lives
    --TODO
    
    g.setColor(oldr,oldg,oldb,olda)
end

