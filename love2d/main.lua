require('lib/32linesofgoodness')
require('background')
require('clouds')
require('fighter')
require("gameInterface")
require("physicElements")
require("camera")

function love.load()
 
  background = createBackground(0,0, 'gfx/back01.png', 2, true,  love.graphics.getWidth(),  love.graphics.getHeight())   
  castel = createBackground(love.graphics.getWidth() - love.graphics.getWidth()/2 +25 ,love.graphics.getHeight()-love.graphics.getHeight()/2 - 50 , 'gfx/castel01.png', 4) 
  street = createBackground(0, love.graphics.getHeight()- 270 , 'gfx/beach-background.png', 10, true, love.graphics.getWidth() ) 
  
  cloud1= createBackground(10,50 , 'gfx/cloud.png', 3)  
  cloud2= createBackground(150,90 , 'gfx/cloud.png', 3)  
  cloud3= createBackground(300,30 , 'gfx/cloud.png', 3)  
  cloud4= createBackground(500,70 , 'gfx/cloud.png', 3)  
  cloud5= createBackground(800,10 , 'gfx/cloud.png', 3)  

  clouds = {cloud1, cloud2, cloud3, cloud4, cloud5}
  backgrounds = {background, street, castel}
 
	love2fight = {}

	phyWorld = love.physics.newWorld(0, 9.81 * 64)
	phyWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)

	createPhysicsBox(400, 600, 8000, 64)
	border1 = createPhysicsBox(0, 400, 32, 600)
	border2 = createPhysicsBox(800, 400, 32, 600)

	fighter1 = loadFighter("data/fighter01.lua", love.graphics.getWidth() * 0.25, love.graphics.getHeight() - 80)
	fighter2 = loadFighter("data/fighter02.lua", love.graphics.getWidth() * 0.75, love.graphics.getHeight() - 80)
    love2fight.gameInterface = GameInterface:new(fighter1.getHealth, fighter2.getHealth)
	
	camera = createCamera({fighter1, fighter2})
  
  sfx = love.audio.newSource("sfx/321fight.mp3", "static")
  love.audio.play(sfx)

end

function love.update(dt)
	fighter1.update(dt)
	fighter2.update(dt)
	camera.update(dt)
	phyWorld:update(dt)
	love2fight.gameInterface:update(dt)
  
  for k,v in pairs (backgrounds) do
    v.update(dt, camera)
  end
  for k,v in pairs (clouds) do
    v.update(dt, camera)
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
  
	camera.trans()
	fighter1.draw()
	fighter2.draw()
	camera.untrans()
  love2fight.gameInterface:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit(0)
    end
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end

function beginContact(a, b, coll)
	fighter1.coll(a, b, coll)
	fighter2.coll(a, b, coll)
end
 
function endContact(a, b, coll)
	
end
 
function preSolve(a, b, coll)
		
end
 
function postSolve(a, b, coll, normalimpulse, tangentimpulse)

end