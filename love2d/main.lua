require('lib/32linesofgoodness')
require('background')
require('fighter')

function love.load()
	background = createBackground(0,0, 'gfx/back01.png')  
	fighter1 = createFighter({
		x = 8,
		y = love.graphics.getHeight() - 48,
		width = 32,
		height = 32,
		speed = 100,
		health = 100,
		live = 2,
		color = {255, 0, 0},
	})
	fighter2 = createFighter({
		x = 448,
		y = love.graphics.getHeight() - 80,
		width = 64,
		height = 64,
		speed = 200,
		health = 100,
		live = 2,
		color = {0, 255, 0},
	})
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
end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end