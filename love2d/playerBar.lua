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
    
    PlayerBar.drawHealthbarBackground(self)
    PlayerBar.drawHealthBar(self)
    PlayerBar.drawHealthBarDamage(self)
    
    g.setColor(oldr,oldg,oldb,olda)
end

function PlayerBar:replaceHealth(newHealthFunction)
    self.healthFunction = newHealthFunction
end

function PlayerBar:drawHealthbarBackground()
    g.setColor(100,100,100,150)
    g.rectangle("fill", self.xPos, self.yPos, self.width, self.height) 
end

function PlayerBar:drawHealthBar()
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
end

function PlayerBar:drawHealthBarDamage(self)
   
end

function PlayerBar:update(dt)
    
    if self.health < 0 then
        self.health = 0
    end
    
    self.health = self.healthFunction()  

end

