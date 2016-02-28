local g = require('love.graphics')

class "PlayerBar" {
    
}

function PlayerBar:__init(isPlayerOne, healthFunction, xPos, yPos, width, height)
    self.maxHealth   = healthFunction()
    self.health      = healthFunction()
    self.healthFunction = healthFunction
    self.xPos        = xPos
    self.yPos        = yPos
    self.width       = width
    self.height      = height
    self.isPlayerOne = isPlayerOne
end

function PlayerBar:draw()
    local oldr,oldg,oldb,olda = g.getColor()	   
    
    -- draw Max XP
    g.setColor(100,100,100,150)
    g.rectangle("fill", self.xPos, self.yPos, self.width, self.height) 

    -- Calculate Actual Width
    local factor = self.health / self.maxHealth
    local actualHealthbarWidth = self.width * factor

    --  draw 
    if self.isPlayerOne then  --left
        local actualHealthbarXPos = (self.width - actualHealthbarWidth + self.xPos);
        g.setColor(0,255,0,200)
        g.rectangle("fill", actualHealthbarXPos, self.yPos, actualHealthbarWidth, self.height)        
    else --right
       
        g.setColor(0,255,0,200)       
        g.rectangle("fill", self.xPos, self.yPos, actualHealthbarWidth, self.height) 
    end

    
    g.setColor(oldr,oldg,oldb,olda)
end

function PlayerBar:replaceHealth(newHealthFunction)
    self.healthFunction = newHealthFunction
end

function PlayerBar:update(dt)
    self.health = self.healthFunction()
    if self.health < 0 then
        self.health = 0
    end
end

