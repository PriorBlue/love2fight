require('lib/32linesofgoodness')
require('background')
require('clouds')
require('fighter')
require("gameInterface")

function love.load()
 
  background = createBackground(0,0, 'gfx/back01.png', 10, true,  love.graphics.getWidth(),  love.graphics.getHeight())   
  street = createBackground(0, love.graphics.getHeight()- 60 , 'gfx/street01.jpg', 70, true, love.graphics.getWidth() )   
  
  castel = createBackground(love.graphics.getWidth() - love.graphics.getWidth()/2 +25 ,love.graphics.getHeight()-       love.graphics.getHeight()/2 - 50 , 'gfx/castel01.png', 25) 
  
  cloud1= createBackground(10,50 , 'gfx/cloud.png', 50)  
  cloud2= createBackground(150,90 , 'gfx/cloud.png', 50)  
  cloud3= createBackground(300,30 , 'gfx/cloud.png', 50)  
  cloud4= createBackground(500,70 , 'gfx/cloud.png', 50)  
  cloud5= createBackground(800,10 , 'gfx/cloud.png', 50)  

  clouds = {cloud1, cloud2, cloud3, cloud4, cloud5}
  backgrounds = {background, street, castel}
 
love2fight = {}

	background = createBackground(0,0, 'gfx/back01.png')
	fighter1 = loadFighter("data/fighter01.lua", love.graphics.getWidth() * 0.25, love.graphics.getHeight() - 80)
	fighter2 = loadFighter("data/fighter02.lua", love.graphics.getWidth() * 0.75, love.graphics.getHeight() - 80)
    love2fight.gameInterface = GameInterface:new(health)
end

function love.update(dt)
	fighter1.update(dt)
	fighter2.update(dt)
   
  
  for k,v in pairs (backgrounds) do
    v.update(dt, fighter1.x, fighter2.x)
  end
  for k,v in pairs (clouds) do
    v.update(dt, fighter1.x, fighter2.x)
  end
  
  animateClouds(dt, clouds)
  
end

function love.draw()

  local i=0
  for k,v in pairs (backgrounds) do
    v.draw()
  end
  for k,v in pairs (clouds) do
    v.draw()
  end
  
	fighter1.draw()
	fighter2.draw()
  love2fight.gameInterface:draw()
end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end