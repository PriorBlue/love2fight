require('lib/32linesofgoodness')
require('background')
require('fighter')
require("gameInterface")
require("physicElements")

love2fight = {}

function love.load()
	phyWorld = love.physics.newWorld(0, 9.81 * 64)
	phyWorld:setCallbacks(beginContact, endContact, preSolve, postSolve)

	background = createBackground(0,0, 'gfx/back01.png')

	createPhysicsBox(400, 616, 800, 32)

	fighter1 = loadFighter("data/fighter01.lua", love.graphics.getWidth() * 0.25, love.graphics.getHeight() - 80)
	fighter2 = loadFighter("data/fighter02.lua", love.graphics.getWidth() * 0.75, love.graphics.getHeight() - 80)

    love2fight.gameInterface = GameInterface:new()
end

function love.update(dt)
	fighter1.update(dt)
	fighter2.update(dt)
	phyWorld:update(dt)
end

function love.draw()
	background.draw()
    --haus.draw()
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