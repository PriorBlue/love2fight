function createBackground (x, y, pictureName, speed, isQuad, width, height) 

  local obj = {}
  obj.x = x
  obj.y = y
  obj.px = 0
  
  obj.image = love.graphics.newImage(pictureName)

  obj.isQuad = isQuad or false
  obj.width = width or obj.image:getWidth()
  obj.height = height or obj.image:getHeight()
  
  
  obj.image:setWrap("repeat", "repeat")
  obj.speed = speed
  
   
  obj.Quad= love.graphics.newQuad (obj.x, obj.y, obj.width, obj.height,  obj.image:getWidth(), obj.image:getHeight()) 
  --obj.Quad:setViewport( x, y, w, h )
  
  obj.update = function(dt, xFigt1, xFigt2)
    canMoveBackVar = canMoveBack(xFigt1, xFigt2)
    if canMoveBackVar == true then
      if love.keyboard.isDown("a") then
        obj.px = obj.px + dt * obj.speed
      end

      if love.keyboard.isDown("d") then
        obj.px = obj.px - dt * obj.speed
      end
      
      --[[
      obj.x = math.max(-10, obj.x)
      obj.x = math.min(love.graphics.getWidth() + 50, obj.x)
      ]]--
      
    end
		
	end
  
  obj.draw = function()      
    if obj.isQuad then
    obj.Quad:setViewport( obj.px, 0,  obj.width, obj.height)
      love.graphics.draw(obj.image, obj.Quad, obj.x, obj.y)
    else
      love.graphics.draw(obj.image, obj.x - obj.px, obj.y)
    end
  end    
  
 return obj  
end

function canMoveBack (x1, x2) 
    if (x1 > 0 and x1 < love.graphics.getWidth()-33) and (x2 > 0 and x2 < love.graphics.getWidth()-65) then
      return true
    else
      return false
    end
  end