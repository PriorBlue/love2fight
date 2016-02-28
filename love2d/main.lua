require('lib/32linesofgoodness')
require("lib/postshader")
require('background')
require('clouds')
require('fighter')
require("gameInterface")
require("mainMenu")
require("physicElements")
require("camera")

love2fight = {}
beachmode = false

function love.load()
 
  background = createBackground(0,0, 'gfx/beach-level-sky.png', 2, true,  love.graphics.getWidth(),  love.graphics.getHeight(), true) 
  
  cloud1= createBackground(-400,10 , 'gfx/cloud1.png', 3)
  cloud2= createBackground(-150,150 , 'gfx/cloud2.png', 3)
  cloud3= createBackground(100,30 , 'gfx/cloud3.png', 3)
  cloud4= createBackground(400,100 , 'gfx/cloud4.png', 3)
  cloud5= createBackground(700,10 , 'gfx/cloud5.png', 3)  
  cloud5= createBackground(900,200 , 'gfx/cloud6.png', 3)
  
  backed = createBackground(500, love.graphics.getHeight()- 650 , 'gfx/beach-level-2.png', 2) 
  castel = createBackground(-450, love.graphics.getHeight()- 700 , 'gfx/beach-level-3.png', 4)   

  street = createBackground(0, love.graphics.getHeight()- 270 , 'gfx/beach-level-1.png', 10, true, love.graphics.getWidth() ) 

  clouds = {cloud1, cloud2, cloud3, cloud4, cloud5}
  backgrounds = {backed, castel, street}
 
	phyWorld = love.physics.newWorld(0, 9.81 * 64)
	phyWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)

	createPhysicsBox(love.graphics.getWidth() * 0.5, love.graphics.getHeight(), love.graphics.getWidth() * 10, 128)
	createPhysicsBox(0, -306, love.graphics.getWidth() * 10, 32)
	border1 = createPhysicsBox(0, 300, 32, 12000)
	border2 = createPhysicsBox(love.graphics.getWidth(), 300, 32, 12000)
	border3 = createPhysicsBox(love.graphics.getWidth() * 0.5, love.graphics.getHeight(), 32, love.graphics.getHeight())
	border4 = createPhysicsCircle(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.5, 16, "static")
	ball = createPhysicsCircle(love.graphics.getWidth() * 0.5 + math.random(-8, 8), 0, 32)
	
	ball.fixture:setSensor(true)
	border3.fixture:setSensor(true)
	border4.fixture:setSensor(true)

	fighter1 = loadFighter("data/fighter01.lua", love.graphics.getWidth() * 0.25, love.graphics.getHeight() - 80)
	fighter2 = loadFighter("data/fighter02.lua", love.graphics.getWidth() * 0.75, love.graphics.getHeight() - 80)
    love2fight.gameInterface = GameInterface:new(fighter1.getHealth, fighter2.getHealth)
	if love._version_major >=10 then 
    love2fight.mainMenu = MainMenu:new()
  end
	love2fight.gameModes = {"mainMenu", "selectionScreen", "inGame", "fightEnd", "credits"}
	-- set game mode to ingame/3 for testing, later it should be mainMenu/1
	love2fight.currentGameMode = love2fight.gameModes[3]
	camera = createCamera({fighter1, fighter2})
  
  sfx = love.audio.newSource("sfx/321fight.mp3", "static")
  love.audio.play(sfx) 
  sfx1=sfx
  love.audio.play(sfx1)
  
  
  sfxLoopMusic = love.audio.newSource("sfx/Brandon_Liew_-_03_-_Fight_Action.mp3", "stream")
  sfxLoopMusic:setVolume(0.3)
  sfxLoopMusic:setLooping( true )
  love.audio.play(sfxLoopMusic)
  
  sfxLoopWater = love.audio.newSource("sfx/water.wav", "stream")
  sfxLoopWater:setVolume(0.1)
  sfxLoopWater:setLooping( true )
  love.audio.play(sfxLoopWater)
  
  joysticks = love.joystick.getJoysticks()
  print (joysticks[1])
 
end

function love.update(dt)

	fighter1.update(dt, fighter2, joysticks[1])
	fighter2.update(dt, fighter1, joysticks[2])

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
	border1.body:setX(camera.x)
	border2.body:setX(camera.x + love.graphics.getWidth())
end

function love.draw()
	love.postshader.setBuffer("render")

	love.graphics.setColor(255, 255, 255)
	local i=0
  background.draw()
  for k,v in pairs (clouds) do
    v.draw()
	end
	for k,v in pairs (backgrounds) do
    v.draw()
	end


	camera.trans()
	fighter1.draw(fighter2.x)
	fighter2.draw(fighter1.x)

	if beachmode then
		love.graphics.setColor(255, 255, 255)
		ball.draw()
		love.graphics.setColor(191, 191, 191)
		border3.draw()
		border4.draw()
		love.graphics.setColor(255, 255, 255)
	end

	camera.untrans()

	love2fight.gameInterface:draw()

    if love2fight.currentGameMode == love2fight.gameModes[1] then
    	love2fight.mainMenu:draw()
    elseif love2fight.currentGameMode == love2fight.gameModes[3] then
        love2fight.gameInterface:draw()
    end

	timeleft = math.max(fighter1.damaged, fighter2.damaged) * 3
	
	love.postshader.addEffect("4colors")
	love.postshader.addEffect("chromatic",
		math.sin(love.timer.getTime()*5) * timeleft,
		math.sin(love.timer.getTime()*4) * timeleft,
		math.sin(love.timer.getTime()*3) * timeleft,
		math.cos(love.timer.getTime()*7) * timeleft,
		math.cos(love.timer.getTime()*4) * timeleft,
		math.sin(love.timer.getTime()*9) * timeleft
	)
	
	--love.postshader.addEffect("bloom", 2, 2)
	love.postshader.addEffect("scanlines")
	love.postshader.draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit(0)
    end
    if love2fight.currentGameMode == love2fight.gameModes[1] then
        love2fight.mainMenu:keypressed(key)
    end
end

function love.keyreleased(key)
	if key == "b" then
		beachmode = not beachmode
		ball.body:setPosition(love.graphics.getWidth() * 0.5 + math.random(-8, 8), 64)
		ball.body:setLinearVelocity(0, 0)
		ball.fixture:setSensor(not beachmode)
		border3.fixture:setSensor(not beachmode)
		border4.fixture:setSensor(not beachmode)
	end
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