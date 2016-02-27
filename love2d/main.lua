require('lib/32linesofgoodness')
require('background')

function love.load()
  background = createBackground(0,0, 'gfx/back01.png')  

end

function love.update(dt)

end

function love.draw()
  background.draw()
    --haus.draw()
end

function love.keypressed(key)

end

function love.keyreleased(key)

end

function love.mousepressed(x, y, button)

end

function love.mousemoved(x, y, dx, dy)

end