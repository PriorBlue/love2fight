require('lib/32linesofgoodness')
require('background')
require('clouds')
require('fighter')

function love.load()
 
  background = createBackground(-100,-50, 'gfx/back01.png', 10)   
  street = createBackground(-100,love.graphics.getHeight()- 60 , 'gfx/street01.jpg', 70)   
  street2 = createBackground(450,love.graphics.getHeight()- 60 , 'gfx/street01.jpg', 70)   
  castel = createBackground(love.graphics.getWidth() - love.graphics.getWidth()/2 +25 ,love.graphics.getHeight()-   love.graphics.getHeight()/2 - 50 , 'gfx/castel01.png', 25) 
  
  cloud1= createBackground(10,50 , 'gfx/cloud.png', 50)  
  cloud2= createBackground(150,90 , 'gfx/cloud.png', 50)  
  cloud3= createBackground(300,30 , 'gfx/cloud.png', 50)  
  cloud4= createBackground(500,70 , 'gfx/cloud.png', 50)  
  cloud5= createBackground(800,10 , 'gfx/cloud.png', 50)  

  clouds = {cloud1, cloud2, cloud3, cloud4, cloud5}
  backgrounds = {background, street, street2, castel}
 
	fighter1 = createFighter(8, love.graphics.getHeight() - 32, 32, 32, 100)
	fighter2 = createFighter(448, love.graphics.getHeight() - 64, 64, 64, 200)

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
end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end