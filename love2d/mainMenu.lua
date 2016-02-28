local g = require('love.graphics') 

-- a little hack to determine if the newText function is available
local loveVersion10 = g.newText or false

class "MainMenu" {
    startButton = {};
    settingsButton = {};
    creditsButton = {};
    quitButton = {};
    currentPosition = 0;
}

function MainMenu:__init()
    local screenHeight = g.getHeight()
    local screenWidth = g.getWidth()
    
    -- the menu buttons should be in the lower third
    --  and on the left half of the screen
    local menuMinY = screenHeight / 2
    local menuMaxX = screenWidth / 2
    
    -- initialize button vertices
    self.buttonSizeX = (menuMaxX /2)
    self.buttonSizeY = (screenHeight - menuMinY - 40) / 5
    self.startButtonX = menuMaxX * 0.1
    self.startButtonY = menuMinY + (screenHeight - menuMinY) / 5
    self.settingsButtonX = menuMaxX * 0.2
    self.settingsButtonY = menuMinY + (screenHeight - menuMinY) / 5 * 2
    self.creditsButtonX = menuMaxX * 0.3
    self.creditsButtonY = menuMinY + (screenHeight - menuMinY) / 5 * 3
    self.quitButtonX = menuMaxX * 0.4
    self.quitButtonY = menuMinY + (screenHeight - menuMinY) / 5 * 4
    local buttonTransparency = 200
    local startButtonVertices = {                                                                   
        {self.startButtonX,                   self.startButtonY,                    0.6,0.8,200,230,20, buttonTransparency},
        {self.startButtonX + self.buttonSizeX,self.startButtonY,                    0.3,0.4,200,230,20, buttonTransparency},
        {self.startButtonX + self.buttonSizeX,self.startButtonY + self.buttonSizeY, 0.3,0.4,200,180,20, buttonTransparency},
        {self.startButtonX,                   self.startButtonY + self.buttonSizeY, 0.3,0.4,200,180,20, buttonTransparency}
    }                                                                
    local settingsButtonVertices = {
        {self.settingsButtonX,                   self.settingsButtonY,                      0.3,0.4,200,230,20, buttonTransparency},
        {self.settingsButtonX + self.buttonSizeX,self.settingsButtonY,                      0.3,0.4,200,230,20, buttonTransparency},
        {self.settingsButtonX + self.buttonSizeX,self.settingsButtonY + self.buttonSizeY,   0.3,0.4,200,180,20, buttonTransparency},
        {self.settingsButtonX,                   self.settingsButtonY + self.buttonSizeY,   0.3,0.4,200,180,20, buttonTransparency}
    }
    local creditsButtonVertices = {
        {self.creditsButtonX,                   self.creditsButtonY,                      0.3,0.4,200,230,20, buttonTransparency},
        {self.creditsButtonX + self.buttonSizeX,self.creditsButtonY,                      0.3,0.4,200,230,20, buttonTransparency},
        {self.creditsButtonX + self.buttonSizeX,self.creditsButtonY + self.buttonSizeY,   0.3,0.4,200,180,20, buttonTransparency},
        {self.creditsButtonX,                   self.creditsButtonY + self.buttonSizeY,   0.3,0.4,200,180,20, buttonTransparency}
    }                                                                                                        
    local quitButtonVertices = {                                      
        {self.quitButtonX,                   self.quitButtonY,                      0.3,0.4,200,230,20, buttonTransparency},
        {self.quitButtonX + self.buttonSizeX,self.quitButtonY,                      0.3,0.4,200,230,20, buttonTransparency},
        {self.quitButtonX + self.buttonSizeX,self.quitButtonY + self.buttonSizeY,   0.3,0.4,200,180,20, buttonTransparency},
        {self.quitButtonX,                   self.quitButtonY + self.buttonSizeY,   0.3,0.4,200,180,20, buttonTransparency}
    }                                                                                                        
    -- create buttons                                                                                     
    self.startButton = g.newMesh(startButtonVertices,"fan","static")               
    self.settingsButton = g.newMesh(settingsButtonVertices,"fan","static")      
    self.creditsButton = g.newMesh(creditsButtonVertices,"fan","static")        
    self.quitButton = g.newMesh(quitButtonVertices,"fan","static")
    
    -- create text
    local imageFontImage = g.newImage("gfx/imagefont.png")
    imageFontImage:setFilter("nearest")
    self.imageFont = g.newImageFont(imageFontImage,
        " abcdefghijklmnopqrstuvwxyz" ..
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
        "123456789.,!?-+/():;%&`'*#=[]\""
    )
    local startTextX = self.startButtonX
    local startTextY = self.startButtonY +self.buttonSizeY/3
    local settingsTextX = self.settingsButtonX
    local settingsTextY = self.settingsButtonY + self.buttonSizeY/3
    local creditsTextX = self.creditsButtonX
    local creditsTextY = self.creditsButtonY + self.buttonSizeY/3
    local quitTextX = self.quitButtonX
    local quitTextY = self.quitButtonY + self.buttonSizeY/3
    if loveVersion10 then
        local startTextGraphic = g.newText(self.imageFont,self.gameTime)
        startTextGraphic:setf("Fight", self.buttonSizeX, "center")
        self.drawStartText = function ()
                local oldr,oldg,oldb,olda = g.getColor()
                g.setColor(200,200,20,250)
                g.draw(startTextGraphic, startTextX, startTextY)
                g.setColor(oldr,oldg,oldb,olda)
            end
        
        local settingsTextGraphic = g.newText(self.imageFont,self.gameTime)
        settingsTextGraphic:setf("Settings", self.buttonSizeX, "center")
        self.drawSettingsText = function ()
                local oldr,oldg,oldb,olda = g.getColor()
                g.setColor(200,200,20,250)
                g.draw(settingsTextGraphic, settingsTextX, settingsTextY)
                g.setColor(oldr,oldg,oldb,olda)
                end
        
        local creditsTextGraphic = g.newText(self.imageFont,self.gameTime)
        creditsTextGraphic:setf("Credits", self.buttonSizeX, "center")
        self.drawCreditsText = function ()
                local oldr,oldg,oldb,olda = g.getColor()
                g.setColor(200,200,20,250)
                g.draw(creditsTextGraphic, creditsTextX, creditsTextY)
                g.setColor(oldr,oldg,oldb,olda)
                end
        
        local quitTextGraphic = g.newText(self.imageFont,self.gameTime)
        quitTextGraphic:setf("Quit", self.buttonSizeX, "center")
        self.drawQuitText = function ()
                local oldr,oldg,oldb,olda = g.getColor()
                g.setColor(200,200,20,250)
                g.draw(quitTextGraphic, quitTextX, quitTextY)
                g.setColor(oldr,oldg,oldb,olda)
                end
    else
        self.drawStartText = 
            function ()
                local oldr,oldg,oldb,olda = g.getColor()
                g.setColor(200,200,20,250)
                local oldFont = g.getFont(); g.setFont(self.imageFont);
                g.printf("Fight", startTextX, startTextY, self.buttonSizeX, "center");
                g.setFont(oldFont)
                g.setColor(oldr,oldg,oldb,olda)
            end
            
        self.drawSettingsText = 
            function ()
                local oldr,oldg,oldb,olda = g.getColor()
                g.setColor(200,200,20,250)
                local oldFont = g.getFont(); g.setFont(self.imageFont);
                g.printf("Settings", settingsTextX, settingsTextY, self.buttonSizeX, "center");
                g.setFont(oldFont)
                g.setColor(oldr,oldg,oldb,olda)
            end
            
        self.drawCreditsText = 
            function ()
                local oldr,oldg,oldb,olda = g.getColor()
                g.setColor(200,200,20,250)
                local oldFont = g.getFont(); g.setFont(self.imageFont);
                g.printf("Credits", creditsTextX, creditsTextY, self.buttonSizeX, "center");
                g.setFont(oldFont)
                g.setColor(oldr,oldg,oldb,olda)
            end
            
        self.drawQuitText = 
            function ()
                local oldr,oldg,oldb,olda = g.getColor()
                g.setColor(200,200,20,250)
                local oldFont = g.getFont(); g.setFont(self.imageFont);
                g.printf("Quit", quitTextX, quitTextY, self.buttonSizeX, "center");
                g.setFont(oldFont)
                g.setColor(oldr,oldg,oldb,olda)
            end
    end
    
    self.selectionX = self.startButtonX
    self.selectionY = self.startButtonY
end

function MainMenu:draw()
    local oldr,oldg,oldb,olda = g.getColor()
    -- draw buttons and text
    g.draw(self.startButton)
    self.drawStartText()
    g.draw(self.settingsButton)
    self.drawSettingsText()
    g.draw(self.creditsButton)
    self.drawCreditsText()
    g.draw(self.quitButton)
    self.drawQuitText()
    -- draw selection rectangle
    local oldLineWidth = g.getLineWidth()
    g.setColor(100,100,10,200)
    g.setLineWidth(4)
    g.rectangle("line",self.selectionX,self.selectionY,self.buttonSizeX,self.buttonSizeY)
    g.setColor(oldr,oldg,oldb,olda)
    g.setLineWidth(oldLineWidth)
end

function MainMenu:relocateSelection()
    if self.currentPosition == 0 then
        self.selectionX = self.startButtonX
        self.selectionY = self.startButtonY                                                               
    elseif self.currentPosition == 1 then
        self.selectionX = self.settingsButtonX
        self.selectionY = self.settingsButtonY                                                            
    elseif self.currentPosition == 2 then
        self.selectionX = self.creditsButtonX
        self.selectionY = self.creditsButtonY
    else
        self.selectionX = self.quitButtonX
        self.selectionY = self.quitButtonY
    end
end

function MainMenu:onDownArrow()
    if self.currentPosition > 2 then
        self.currentPosition = 0
    else
        self.currentPosition = self.currentPosition + 1
    end
    MainMenu.relocateSelection(self)
end

function MainMenu:onUpArrow()
    if self.currentPosition < 1 then
        self.currentPosition = 3
    else
        self.currentPosition = self.currentPosition - 1
    end
    MainMenu.relocateSelection(self)
end

function MainMenu:onEnter()
    if self.currentPosition == 0 then
        --TODO start game
    elseif self.currentPosition == 1 then
        --TODO add settings
    elseif self.currentPosition == 2 then
        --TODO add credits
    else
        --TODO quit
        love.event.quit(0)
    end
end

function MainMenu:keypressed(key)
    if key == "up" then
        love2fight.mainMenu:onUpArrow()
    elseif key == "down" then
        love2fight.mainMenu:onDownArrow()
    end
    if key == "return" then
        love2fight.mainMenu:onEnter()
    end
end

