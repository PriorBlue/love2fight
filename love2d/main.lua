require('lib/32linesofgoodness')
require('background')
require('fighter')
require("gameInterface")

love2fight = {}

function love.load()
	background = createBackground(0,0, 'gfx/back01.png')
	
	fighter1 = loadFighter("data/fighter01.lua", 32, love.graphics.getHeight() - 80)
	fighter2 = loadFighter("data/fighter02.lua", 240, love.graphics.getHeight() - 80)

    love2fight.gameInterface = GameInterface:new()
end

function love.update(dt)
	fighter1.update(dt)
	fighter2.update(dt)
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