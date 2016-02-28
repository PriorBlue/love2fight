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

    self.xPosHealth  = xPos
    self.yPosHealth  = yPos
    self.widthHealth = width    
    self.heightHealth = height    

    self.isPlayerOne = isPlayerOne
    self.hbColor = {0,255,0,220}   

    self.xPosDamageBarP1 = 0
    self.widthDamangeBarP2 = 0
end

function PlayerBar:draw()
    local oldr,oldg,oldb,olda = g.getColor()	   
    
    -- draw Max XP
    g.setColor(100,100,100,150)
    g.rectangle("fill", self.xPos, self.yPos, self.width, self.height) 

    -- Calculate Actual Width
    local factor = self.health / self.maxHealth
    self.widthHealth = self.width * factor

    --  draw 
    if self.isPlayerOne then  
        self.xPosHealth = (self.width - self.widthHealth + self.xPos);
        g.setColor(self.hbColor[1],self.hbColor[2],self.hbColor[3],self.hbColor[4])
        g.rectangle("fill", self.xPosHealth, self.yPosHealth, self.widthHealth, self.heightHealth)        
    else                
        g.setColor(self.hbColor[1],self.hbColor[2],self.hbColor[3],self.hbColor[4])       
        g.rectangle("fill", self.xPosHealth, self.yPosHealth, self.widthHealth, self.heightHealth) 
    end

    -- draw the damaged Health at the end with the faded Color
    
    if oldHealthFadingValue ~= 0 then
      g.setColor(self.hbColor[1],self.hbColor[2],self.hbColor[3],self.hbColor[4]) 
      --g.rectangle("fill", xPos,y,widht,height)       
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

