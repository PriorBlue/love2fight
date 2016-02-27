require('lib/32linesofgoodness')
require('fighter')

function love.load()
	fighter1 = createFighter(8, love.graphics.getHeight() - 32, 32, 32, 100)
	fighter2 = createFighter(448, love.graphics.getHeight() - 64, 64, 64, 200)
end

function love.update(dt)
	fighter1.update(dt)
	fighter2.update(dt)
end

function love.draw()
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