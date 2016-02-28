local g = require('love.graphics')

class "PlayerBar" {
    
}

function PlayerBar:__init(isPlayerOne, healthFunction, xPos, yPos, width, height)
    self.maxHealth   = healthFunction()
    self.health      = healthFunction()
    self.healthFunction = healthFunction
    self.damage      = 30
       
    self.xPos        = xPos
    self.yPos        = yPos
    self.width       = width
    self.height      = height

    self.xPosHealth  = xPos
    self.yPosHealth  = yPos
    self.widthHealth = width    
    self.heightHealth = height    

    self.isPlayerOne = isPlayerOne
    
    self.hbBackgroundColor  = {100,100,100,150}
    self.hbHealthColor      = {0,255,0,220}   
    self.hbDamageColor      = {255, 0, 0, 220}

    self.xPosDamageBar    = 0
    self.yPosDamageBar    = 0
    self.widthDamageBar   = 0
    self.heightDamageBar  = 0

    self.opacityDamageBar = 255
end

function PlayerBar:draw()
    local oldr,oldg,oldb,olda = g.getColor()	   
    
    PlayerBar.drawHealthbarBackground(self)
    PlayerBar.drawHealthBar(self)
    PlayerBar.drawHealthDamageBar(self)
    
    g.setColor(oldr,oldg,oldb,olda)
end

function PlayerBar:replaceHealth(newHealthFunction)
    self.healthFunction = newHealthFunction
end

function PlayerBar:drawHealthbarBackground()
    g.setColor(self.hbBackgroundColor[1],self.hbBackgroundColor[2],self.hbBackgroundColor[3],self.hbBackgroundColor[4])
    g.rectangle("fill", self.xPos, self.yPos, self.width, self.height) 
end



function PlayerBar:drawHealthBar()
    
    self.widthHealth = PlayerBar.calculateHealthBarLength(self,self.health)   

    --  draw 
    if self.isPlayerOne then 
        g.setColor(self.hbHealthColor[1],self.hbHealthColor[2],self.hbHealthColor[3],self.hbHealthColor[4])
        g.rectangle("fill", self.xPosHealth, self.yPosHealth, self.widthHealth, self.heightHealth)        
    else                
        g.setColor(self.hbHealthColor[1],self.hbHealthColor[2],self.hbHealthColor[3],self.hbHealthColor[4])       
        g.rectangle("fill", self.xPosHealth, self.yPosHealth, self.widthHealth, self.heightHealth) 
    end
end

function PlayerBar:drawHealthDamageBar()
    
    if self.opacityDamageBar > 0 then  
        --Draw Damage Bar
        if isPlayerOne then
            g.setColor(self.hbDamageColor[1], self.hbDamageColor[2], self.hbDamageColor[3], self.hbDamageColor[4])
            g.rectangle("fill",self.xPosDamageBar, self.yPosDamageBar, self.widthDamageBar, self.heightDamageBar)
        else
            g.setColor(self.hbDamageColor[1], self.hbDamageColor[2], self.hbDamageColor[3], self.hbDamageColor[4])
            g.rectangle("fill",self.xPosDamageBar, self.yPosDamageBar, self.widthDamageBar, self.heightDamageBar)
        end 
    end
end
 
function PlayerBar:calculateHealthBarLength(healthValue)
    local factor = healthValue / self.maxHealth
    return self.width * factor
end

function PlayerBar:calculateHealthBarDamagePosition()
    if isPlayerOne then
        --DamgeBarP1
        self.xPosDamageBar    = self.xPos - self.withDamageBar
        self.yPosDamageBar    = self.yPos
        self.widthDamageBar   = self.widthDamageBar
        self.heightDamageBar  = self.height
    else
        --DamgeBarP2
        self.xPosDamageBar    = self.xPos + self.widthDamageBar
        self.yPosDamageBar    = self.yPos
        self.widthDamageBar   = self.widthDamageBar
        self.heightDamageBar  = self.height     
    end
end

function PlayerBar:update(dt)
    
    --Getting Damage    
    if self.healthFunction() < self.health then
        
        self.damage = self.health - self.healthFunction()   --Calculate the Damage
        self.health = self.healthFunction()                 -- Update Health
        
        --Calculate xPosHealth for Player1
        if self.isPlayerOne then
            self.xPosHealth = (self.width - self.widthHealth + self.xPos)
        end 

        self.widthDamageBar = PlayerBar.calculateHealthBarLength(self,self.damage)        
        
        self.opacityDamageBar = 255 -- setOpacityHealthbar to 255   

        PlayerBar.calculateHealthBarDamagePosition(self)
        



    end

    --Can't get Damage under 0
    if self.health < 0 then
        self.health = 0
    end

    --Healing (Adding Health)
    if self.healthFunction() > self.health then
        self.health = self.healthFunction()
    end
      
end

